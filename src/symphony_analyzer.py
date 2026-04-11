"""
symphony_analyzer.py -- Mini-strategy extraction and symphony compression.
"""

from __future__ import annotations
import copy, hashlib, json, logging, re, sys
from collections import defaultdict
from pathlib import Path
from typing import Optional

_LEARNING_ROOT = Path.home() / ".openclaw" / "workspace" / "learning"
_SRC_DIR       = _LEARNING_ROOT / "src"
sys.path.insert(0, str(_SRC_DIR))

try:
    from kb_writer import read_json, write_json_atomic
    _HAS_KB_WRITER = True
except ImportError:
    _HAS_KB_WRITER = False

logger = logging.getLogger(__name__)

MIN_DEPTH      = 1
MIN_ASSETS     = 2
MIN_RECURRENCE = 2
_KB_MINI_STRATEGIES_PATH = _LEARNING_ROOT / "kb" / "mini_strategies.json"
_ASSET_STEP = "asset"
_ROOT_STEP  = "root"
_KNOWN_TICKERS = {
    "SVIX","SVXY","UVXY","VIXM","TQQQ","TECL","SOXL","SPXL","UPRO",
    "SQQQ","SOXS","SPXS","TECS","BIL","SPY","QQQ","TMF","TLT","GLD",
    "SHV","VIXY","FNGG","FNGU","LABU","LABD","TNA","TZA",
}


def _get_depth(node):
    children = node.get("children", [])
    if not children: return 0
    return 1 + max(_get_depth(c) for c in children)

def _count_assets(node):
    if node.get("step") == _ASSET_STEP: return 1
    return sum(_count_assets(c) for c in node.get("children", []))

def _strip_ids(node):
    n = copy.deepcopy(node)
    n.pop("id", None)
    n["children"] = [_strip_ids(c) for c in n.get("children", [])]
    return n

def _fingerprint(node):
    stripped   = _strip_ids(node)
    serialized = json.dumps(stripped, sort_keys=True, separators=(",", ":"))
    return hashlib.sha256(serialized.encode()).hexdigest()[:16]

def _is_ticker_name(name):
    if not name: return False
    upper = name.strip().upper()
    if upper in _KNOWN_TICKERS: return True
    if re.match(r"^[A-Z0-9]{1,5}$", upper): return True
    return False

def _is_named_group(node, depth):
    if depth == 0: return False
    name = node.get("name", "").strip()
    if not name or _is_ticker_name(name): return False
    step = node.get("step", "")
    if step == _ASSET_STEP or step == _ROOT_STEP: return False
    if _count_assets(node) < MIN_ASSETS: return False
    if _get_depth(node) < MIN_DEPTH: return False
    return True

def _get_dominant_tickers(node, max_tickers=2):
    ticker_counts = defaultdict(int)
    def walk(n):
        if n.get("step") == _ASSET_STEP:
            t = n.get("ticker", "").upper()
            if t: ticker_counts[t] += 1
        for c in n.get("children", []): walk(c)
    walk(node)
    if not ticker_counts: return []
    return sorted(ticker_counts, key=ticker_counts.__getitem__, reverse=True)[:max_tickers]

def _get_primary_function(node):
    conditions = []
    def walk(n):
        if n.get("step") in ("if-then","if-then-else","if","if-child"):
            fn = n.get("lhs_fn","") or n.get("lhs-fn","")
            if fn: conditions.append(fn.upper().replace("-","_"))
        for c in n.get("children",[]): walk(c)
    walk(node)
    if not conditions: return node.get("step","").upper().replace("-","_")
    fn_map = {
        "MAX_DRAWDOWN":"CRASH_GUARD","RELATIVE_STRENGTH_INDEX":"RSI",
        "MOVING_AVERAGE_PRICE":"MA","CUMULATIVE_RETURN":"MOMENTUM",
        "STANDARD_DEVIATION_RETURN":"VOL",
    }
    return fn_map.get(conditions[0], conditions[0][:12])

def _get_outcome_hint(node):
    step = node.get("step","")
    if step in ("filter","select-n"):
        n_s = node.get("n", node.get("select",""))
        return f"TOP{n_s}" if n_s else "FILTER"
    def has_dd(n):
        fn = n.get("lhs_fn","") or n.get("lhs-fn","")
        if "drawdown" in fn.lower(): return True
        return any(has_dd(c) for c in n.get("children",[]))
    if has_dd(node): return "GUARD"
    if step == "wt-inverse-vol": return "INVVOL"
    return ""

def _auto_name(node):
    tickers  = _get_dominant_tickers(node)
    function = _get_primary_function(node)
    outcome  = _get_outcome_hint(node)
    parts    = []
    if tickers:  parts.append(tickers[0].upper())
    if function: parts.append(function)
    if outcome:  parts.append(outcome)
    if len(parts) >= 2: return "_".join(parts)
    return f"STRATEGY_{_fingerprint(node)[:8].upper()}"

# Granularity filter constants for named group extraction.
# These define the "sweet spot" — large enough to be a meaningful sub-strategy,
# small enough to be a reusable building block.
#
# The problem with only extracting symphony-level wrappers (depth <= 12):
#   Too coarse — "BWC Modified Madness" (304 assets) is not a reusable block.
#
# The problem with extracting everything (all 429 groups in NOVA Best):
#   Too granular — "Pick Top 3" (5 assets) and "VIX Blend++" (2 assets) are noise.
#
# Sweet spot: Named groups that represent discrete trading logic —
#   large enough to be meaningful (>= MIN_ASSETS_MEANINGFUL)
#   but not so large they are just wrappers (asset_count <= MAX_ASSETS_WRAPPER)
#   OR any group shallow enough to be a symphony-level component (depth <= MAX_SHALLOW_DEPTH)
#
# Deduplication: After extraction, groups with identical fingerprints are collapsed.
# The same sub-strategy embedded in multiple parent wrappers appears once.

_MAX_SHALLOW_DEPTH      = 12    # Always extract groups at this depth or shallower
_MIN_ASSETS_MEANINGFUL  = 20    # Groups deeper than MAX_SHALLOW_DEPTH need >= this many assets
_MAX_ASSETS_WRAPPER     = 400   # Groups with > this many assets are likely just wrappers
                                # Exception: shallow groups (depth <= MAX_SHALLOW_DEPTH) kept regardless


def _extract_named_groups(node, depth=0, results=None, seen_fps=None):
    """
    Extract all meaningful named groups from the symphony tree.

    v1.2 improvements:
    1. Atomicity fix: recurse into children of named groups (not just stop at first match)
    2. Granularity filter: extract groups in the sweet spot — not too big, not too small
    3. Deduplication: skip groups with fingerprints already seen in this extraction pass

    Extraction criteria for a named group at depth D with asset_count A:
      INCLUDE if: D <= _MAX_SHALLOW_DEPTH                    (symphony-level component)
      INCLUDE if: A >= _MIN_ASSETS_MEANINGFUL                (meaningful sub-strategy)
                  AND A <= _MAX_ASSETS_WRAPPER               (not just a giant wrapper)
      SKIP    if: A < _MIN_ASSETS_MEANINGFUL AND D > _MAX_SHALLOW_DEPTH  (noise leaf)
      SKIP    if: fingerprint already seen in this pass      (duplicate instance)
    """
    if results is None:  results  = []
    if seen_fps is None: seen_fps = set()

    if _is_named_group(node, depth):
        asset_count = _count_assets(node)
        fp          = _fingerprint(node)

        # Deduplication — same sub-strategy embedded in multiple parents
        if fp not in seen_fps:
            shallow   = depth <= _MAX_SHALLOW_DEPTH
            in_range  = _MIN_ASSETS_MEANINGFUL <= asset_count <= _MAX_ASSETS_WRAPPER

            if shallow or in_range:
                seen_fps.add(fp)
                results.append({
                    "node":        node,
                    "name":        node.get("name","").strip(),
                    "depth":       depth,
                    "asset_count": asset_count,
                    "fingerprint": fp,
                    "source":      "named",
                })
        # Always recurse — find nested named groups inside this one
    for child in node.get("children",[]):
        _extract_named_groups(child, depth+1, results, seen_fps)
    return results

def _extract_candidate_subtrees(node, depth=0, results=None):
    if results is None: results = []
    if depth == 0:
        for child in node.get("children",[]): _extract_candidate_subtrees(child, 1, results)
        return results
    step = node.get("step","")
    name = node.get("name","").strip()
    if name and not _is_ticker_name(name): return results
    if step == _ASSET_STEP: return results
    if _count_assets(node) >= MIN_ASSETS and _get_depth(node) >= MIN_DEPTH:
        results.append({
            "node": node, "name": _auto_name(node), "depth": depth,
            "asset_count": _count_assets(node), "fingerprint": _fingerprint(node),
            "source": "structural",
        })
    for child in node.get("children",[]): _extract_candidate_subtrees(child, depth+1, results)
    return results

def _extract_parameters(node):
    params = {}
    def walk(n, path=""):
        step = n.get("step","")
        if step in ("if-then","if-then-else","if","if-child"):
            lhs_fn  = n.get("lhs_fn") or n.get("lhs-fn")
            lhs_val = n.get("lhs_val") or n.get("lhs-val")
            rhs_val = n.get("rhs_val") or n.get("rhs-val")
            window  = n.get("window") or (n.get("lhs_fn_params") or n.get("lhs-fn-params") or {}).get("window")
            if lhs_fn:
                key = f"{path}{lhs_fn}" if path else lhs_fn
                if window  is not None: params[f"{key}.window"]    = window
                if rhs_val is not None: params[f"{key}.threshold"] = rhs_val
                if lhs_val is not None: params[f"{key}.asset"]     = lhs_val
        if step in ("filter","select-n"):
            n_val   = n.get("n") or n.get("select")
            sort_fn = n.get("sort_fn") or n.get("sort-fn")
            if n_val   is not None: params[f"{path}select_n"] = n_val
            if sort_fn:             params[f"{path}sort_fn"]  = sort_fn
        if step == "wt-inverse-vol":
            w = n.get("window") or n.get("window_days") or n.get("window-days")
            if w is not None: params[f"{path}invvol_window"] = w
        for child in n.get("children",[]): walk(child, path)
    walk(node)
    return params

def build_mini_strategy_registry(symphonies, min_recurrence=MIN_RECURRENCE):
    fp_to_candidates = defaultdict(list)
    for sym in symphonies:
        sym_id   = sym.get("id","unknown")
        sym_json = sym.get("composer_json",{})
        if not sym_json: continue
        for c in _extract_named_groups(sym_json):
            fp_to_candidates[c["fingerprint"]].append({**c,"symphony_id":sym_id})
        for c in _extract_candidate_subtrees(sym_json):
            fp = c["fingerprint"]
            if fp not in fp_to_candidates:
                fp_to_candidates[fp].append({**c,"symphony_id":sym_id})
            elif fp_to_candidates[fp][0]["source"] == "structural":
                fp_to_candidates[fp].append({**c,"symphony_id":sym_id})
    registry = {
        "version":"1.0","mini_strategies":{},"fingerprint_to_id":{},
        "stats":{"total_symphonies":len(symphonies),"total_mini_strategies":0,"named":0,"structural":0},
    }
    ms_counter = 1
    for fp, instances in sorted(fp_to_candidates.items()):
        is_named     = any(i["source"]=="named" for i in instances)
        symphony_ids = list({i["symphony_id"] for i in instances})
        recurrence   = len(symphony_ids)
        if not is_named and recurrence < min_recurrence: continue
        ms_id     = f"ms-{ms_counter:03d}"
        ms_counter += 1
        canonical = next((i for i in instances if i["source"]=="named"), instances[0])
        source    = "named" if is_named else "structural"
        param_instances = [
            {"symphony_id":i["symphony_id"],"parameters":_extract_parameters(i["node"])}
            for i in instances if _extract_parameters(i["node"])
        ]
        registry["mini_strategies"][ms_id] = {
            "id":ms_id,"name":canonical["name"],"source":source,
            "fingerprint":fp,"asset_count":canonical["asset_count"],
            "appears_in":symphony_ids,"recurrence":recurrence,
            "full_json":_strip_ids(canonical["node"]),"parameter_instances":param_instances,
        }
        registry["fingerprint_to_id"][fp] = ms_id
        registry["stats"]["named" if source=="named" else "structural"] += 1
    registry["stats"]["total_mini_strategies"] = ms_counter - 1
    return registry

def _count_nodes(node):
    return 1 + sum(_count_nodes(c) for c in node.get("children",[]))

def compress_symphony(symphony_json, registry):
    fp_to_id = registry.get("fingerprint_to_id",{})
    if not fp_to_id:
        return copy.deepcopy(symphony_json)
    compressed = _compress_node(symphony_json, fp_to_id, 0)
    compressed["_compression"] = {
        "version":"1.0","registry_size":len(fp_to_id),
        "original_node_count":_count_nodes(symphony_json),
        "compressed_node_count":_count_nodes(compressed),
    }
    return compressed

def _compress_node(node, fp_to_id, depth):
    if depth > 0:
        fp = _fingerprint(node)
        if fp in fp_to_id:
            return {"step":"MINI_STRATEGY","mini_strategy_id":fp_to_id[fp],"_name":node.get("name","")}
    result = copy.deepcopy(node)
    result["children"] = [_compress_node(c,fp_to_id,depth+1) for c in node.get("children",[])]
    return result

def expand_symphony(compressed, registry):
    ms = registry.get("mini_strategies",{})
    expanded = _expand_node(compressed, ms)
    expanded.pop("_compression",None)
    return expanded

def _expand_node(node, mini_strategies):
    if node.get("step") == "MINI_STRATEGY":
        ms_id = node.get("mini_strategy_id","")
        ms    = mini_strategies.get(ms_id)
        if ms: return copy.deepcopy(ms["full_json"])
        return copy.deepcopy(node)
    result = copy.deepcopy(node)
    result["children"] = [_expand_node(c,mini_strategies) for c in result.get("children",[])]
    return result

def verify_round_trip(original, registry, symphony_id="unknown"):
    compressed = compress_symphony(original, registry)
    expanded   = expand_symphony(compressed, registry)
    orig_stripped = _strip_ids(original)
    exp_stripped  = _strip_ids(expanded)
    exp_stripped.pop("_compression",None)
    ok = _fingerprint(orig_stripped) == _fingerprint(exp_stripped)
    logger.info("verify_round_trip: %s — %s", symphony_id, "PASS" if ok else "FAIL")
    return ok

def _collect_references(node):
    refs = set()
    if node.get("step") == "MINI_STRATEGY":
        ms_id = node.get("mini_strategy_id","")
        if ms_id: refs.add(ms_id)
    for child in node.get("children",[]): refs |= _collect_references(child)
    return refs

def build_compressed_representation(symphony, registry):
    symphony_id   = symphony.get("id","unknown")
    symphony_name = symphony.get("name",symphony_id)
    composer_json = symphony.get("composer_json",{})
    if not composer_json:
        return {"symphony_id":symphony_id,"symphony_name":symphony_name,
                "mini_strategy_tree":{},"referenced_mini_strategies":{},
                "compression_stats":{"error":"no_composer_json"}}
    compressed       = compress_symphony(composer_json, registry)
    compression_meta = compressed.pop("_compression",{})
    referenced_ids   = _collect_references(compressed)
    referenced_ms    = {
        ms_id: registry["mini_strategies"][ms_id]
        for ms_id in referenced_ids if ms_id in registry["mini_strategies"]
    }
    return {
        "symphony_id":symphony_id,"symphony_name":symphony_name,
        "mini_strategy_tree":compressed,"referenced_mini_strategies":referenced_ms,
        "compression_stats":{**compression_meta,"referenced_mini_strategy_count":len(referenced_ids)},
    }

def render_compressed_for_prompt(compressed_rep):
    lines = [
        f"COMPRESSED SYMPHONY: {compressed_rep['symphony_name']}",
        f"ID: {compressed_rep['symphony_id']}","","TREE:","",
    ]
    for ms_id, ms in compressed_rep.get("referenced_mini_strategies",{}).items():
        lines.append(f"  {ms_id} -- {ms['name']} (assets:{ms['asset_count']})")
        params = _extract_parameters(ms.get("full_json",{}))
        if params:
            lines.append(f"    Params: {json.dumps(params)}")
    return "\n".join(lines)

def save_registry_to_kb(registry):
    _KB_MINI_STRATEGIES_PATH.parent.mkdir(parents=True, exist_ok=True)
    path_str = str(_KB_MINI_STRATEGIES_PATH)
    if _HAS_KB_WRITER:
        write_json_atomic(path_str, registry)
    else:
        with open(path_str,"w",encoding="utf-8") as f:
            json.dump(registry, f, indent=2)

def load_registry_from_kb():
    if not _KB_MINI_STRATEGIES_PATH.exists(): return None
    try:
        if _HAS_KB_WRITER: return read_json(str(_KB_MINI_STRATEGIES_PATH))
        with open(str(_KB_MINI_STRATEGIES_PATH),encoding="utf-8") as f: return json.load(f)
    except Exception: return None

def analyze_and_compress_symphonies(symphonies, save_kb=True, verify=True):
    registry = build_mini_strategy_registry(symphonies)
    if save_kb:
        try: save_registry_to_kb(registry)
        except Exception as e: logger.warning("KB save failed: %s", e)
    compressed_symphonies = []
    n_pass = n_fail = 0
    for sym in symphonies:
        sym_id = sym.get("id","unknown")
        if verify and sym.get("composer_json"):
            ok = verify_round_trip(sym["composer_json"], registry, sym_id)
            if ok: n_pass += 1
            else:  n_fail += 1
        compressed_rep = build_compressed_representation(sym, registry)
        enriched = dict(sym)
        enriched["compressed_repr"] = compressed_rep
        compressed_symphonies.append(enriched)
    return registry, compressed_symphonies
