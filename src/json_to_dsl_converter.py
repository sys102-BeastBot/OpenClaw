"""
json_to_dsl_converter.py — Composer JSON → DSL converter
Inverse of dsl_compiler.py. Walks the Composer symphony JSON tree
and emits the Clojure-style DSL that dsl_compiler.py can round-trip back.

Design principles:
  - Every JSON node type has exactly one DSL form (no ambiguity)
  - Compound conditions (binary-compound, compound/all, compound/any) fully supported
  - Dynamic comparisons (rhs-fn) supported
  - Round-trip test harness included: JSON → DSL → JSON → compare
  - Deterministic output: same JSON always produces same DSL

JSON node types handled:
  wt-cash-equal / wt-equal  → (weight-equal [...])
  wt-cash-specified          → (weight-cash-specified [...])  children carry :weight
  wt-inverse-vol             → (weight-inverse-vol <window> [...])
  if + if-child              → (if <condition> [...] [...])
  filter                     → (filter (<sort-fn> <window>) (select-top/bottom <n>) [...])
  asset                      → (asset "EQUITIES::<TICKER>//USD" "<TICKER>")
  group                      → (group "<name>" [...])

Condition schemas (all three confirmed from live Sisyphus data):
  binary (simple)            → (> (rsi "EQUITIES::X//USD" W) V)
  binary with rhs-fn         → (> (current-price "EQUITIES::X//USD" 2) (moving-average-price ...))
  compound/all (AND)         → (and <cond1> <cond2> ...)
  compound/any (OR)          → (or <cond1> <cond2> ...)
  binary-compound            → (or (> (fn TICKER W) V) (> (fn TICKER2 W) V))   [expanded]

Usage:
  python3 json_to_dsl_converter.py --input symphony.json --output symphony.dsl
  python3 json_to_dsl_converter.py --roundtrip symphony.json   # requires dsl_compiler.py

Author: OpenClaw project — TheBeast / WSL2
"""

import json
import sys
import argparse
import subprocess
import tempfile
import os
from typing import Any


# ── Function name maps ─────────────────────────────────────────────────────────

# JSON lhs-fn → DSL function name
FN_JSON_TO_DSL = {
    "relative-strength-index":  "rsi",
    "cumulative-return":        "cumulative-return",
    "moving-average-price":     "moving-average-price",
    "max-drawdown":             "max-drawdown",
    "standard-deviation-return": "standard-deviation-return",
    "standard-deviation-price":  "standard-deviation-price",
    "exponential-moving-average-price": "exponential-moving-average-price",
    "moving-average-return":    "moving-average-return",
    "current-price":            "current-price",
}

# Comparator JSON → DSL operator
COMPARATOR_TO_DSL = {
    "gt":  ">",
    "lt":  "<",
    "gte": ">=",
    "lte": "<=",
    "eq":  "=",
}

# Filter sort function JSON → DSL
FILTER_FN_JSON_TO_DSL = {
    "standard-deviation-return": "standard-deviation-return",
    "standard-deviation-price":  "standard-deviation-price",
    "cumulative-return":         "cumulative-return",
    "relative-strength-index":   "rsi",
    "moving-average-price":      "moving-average-price",
    "max-drawdown":              "max-drawdown",
}


# ── Ticker normalisation ───────────────────────────────────────────────────────

def escape_dsl_string(s: str) -> str:
    """Escape double quotes inside a DSL string literal."""
    return s.replace('\\', '\\\\').replace('"', '\\"')


def ticker_to_dsl(ticker: str) -> str:
    """
    Wrap a bare ticker in its canonical DSL asset reference.
    Composer JSON stores tickers as bare strings ("TQQQ").
    DSL represents them as "EQUITIES::TQQQ//USD".
    """
    # Already fully qualified — pass through
    if "::" in ticker:
        return f'"{ticker}"'
    return f'"EQUITIES::{ticker}//USD"'


def ticker_from_lhs_val(lhs_val: str) -> str:
    """
    lhs-val in JSON is always a bare ticker string e.g. "SVXY".
    Return the DSL form: "EQUITIES::SVXY//USD".
    """
    return ticker_to_dsl(lhs_val)


# ── Condition rendering ────────────────────────────────────────────────────────

def render_fn_call(fn_name: str, ticker_dsl: str, window: Any) -> str:
    """Render a single indicator call: (rsi "EQUITIES::X//USD" 10)"""
    dsl_fn = FN_JSON_TO_DSL.get(fn_name, fn_name)
    return f'({dsl_fn} {ticker_dsl} {window})'


def render_binary_condition(cond: dict) -> str:
    """
    Render a single binary condition from its JSON fields.

    Handles two sub-cases:
      (a) rhs-fixed-value? = true  → compare against constant
          (> (rsi "EQUITIES::SVXY//USD" 10) 74)

      (b) rhs-fixed-value? = false  → compare against another indicator
          (> (current-price "EQUITIES::SPY//USD" 2) (moving-average-price "EQUITIES::SPY//USD" 200))

    Source fields may come from either the flat if-child layout:
      lhs-fn, lhs-fn-params, lhs-val, comparator, rhs-val, rhs-fixed-value?
    or from a nested binary condition object:
      lhs: {fn, params, ticker}, comparator, rhs: {constant} or rhs: {fn, params, ticker}
    """
    # Normalise: support both flat (if-child top-level) and nested (condition object) layouts
    if "lhs" in cond:
        # Nested condition object layout (inside compound conditions)
        lhs_info  = cond["lhs"]
        fn_name   = lhs_info.get("fn") or lhs_info.get("lhs-fn", "")
        window    = (lhs_info.get("params") or lhs_info.get("lhs-fn-params", {})).get("window", 10)
        ticker    = lhs_info.get("ticker") or lhs_info.get("lhs-val", "")
        comp_sym  = COMPARATOR_TO_DSL.get(cond.get("comparator", "gt"), ">")
        rhs_info  = cond.get("rhs", {})

        lhs_dsl = render_fn_call(fn_name, ticker_to_dsl(ticker), window)

        if "constant" in rhs_info:
            return f'({comp_sym} {lhs_dsl} {rhs_info["constant"]})'
        elif "fn" in rhs_info:
            # Dynamic: compare two indicators
            rhs_fn     = rhs_info["fn"]
            rhs_window = (rhs_info.get("params") or {}).get("window", window)
            rhs_ticker = rhs_info.get("ticker", ticker)
            rhs_dsl    = render_fn_call(rhs_fn, ticker_to_dsl(rhs_ticker), rhs_window)
            return f'({comp_sym} {lhs_dsl} {rhs_dsl})'
        else:
            # Fallback: use rhs-val if present
            rhs_val = cond.get("rhs-val", "0")
            return f'({comp_sym} {lhs_dsl} {rhs_val})'

    else:
        # Flat if-child layout — two sub-formats exist in the wild:
        #
        # Old format (lhs-window-days / rhs-window-days as flat strings):
        #   lhs-fn, lhs-window-days: '2', lhs-val, comparator,
        #   rhs-fn, rhs-window-days: '200', rhs-val
        #
        # New format (lhs-fn-params / rhs-fn-params as objects):
        #   lhs-fn, lhs-fn-params: {window: 10}, lhs-val, comparator,
        #   rhs-fn, rhs-fn-params: {window: 200}, rhs-val
        #
        # Both formats may appear in the same symphony (Sisyphus uses both).

        fn_name  = cond.get("lhs-fn", "")
        ticker   = cond.get("lhs-val", "")
        comp_sym = COMPARATOR_TO_DSL.get(cond.get("comparator", "gt"), ">")

        # Resolve lhs window — prefer lhs-fn-params, fall back to lhs-window-days
        if "lhs-fn-params" in cond:
            lhs_window = cond["lhs-fn-params"].get("window", 10)
        elif "lhs-window-days" in cond:
            lhs_window = int(cond["lhs-window-days"])
        else:
            lhs_window = 10

        lhs_dsl = render_fn_call(fn_name, ticker_to_dsl(ticker), lhs_window)

        # Dynamic when rhs-fn is present AND rhs-fixed-value? is not explicitly True.
        # CRITICAL: rhs-fixed-value?=True takes absolute precedence — some nodes have
        # both rhs-fn AND rhs-fixed-value?=True (Composer stores rhs-fn as metadata
        # even on fixed-value conditions). Always treat as constant when True.
        is_fixed_explicit = cond.get("rhs-fixed-value?") is True
        has_rhs_fn        = bool(cond.get("rhs-fn"))

        if has_rhs_fn and not is_fixed_explicit:
            # Dynamic: rhs is another indicator call
            rhs_fn     = cond.get("rhs-fn", "moving-average-price")
            rhs_ticker = cond.get("rhs-val", ticker)

            # Resolve rhs window — prefer rhs-fn-params, fall back to rhs-window-days
            if "rhs-fn-params" in cond:
                rhs_window = cond["rhs-fn-params"].get("window", lhs_window)
            elif "rhs-window-days" in cond:
                rhs_window = int(cond["rhs-window-days"])
            else:
                rhs_window = lhs_window

            rhs_dsl = render_fn_call(rhs_fn, ticker_to_dsl(rhs_ticker), rhs_window)
            return f'({comp_sym} {lhs_dsl} {rhs_dsl})'
        else:
            # Fixed value — rhs-val is a constant (even if rhs-fn also present)
            rhs_val = cond.get("rhs-val", "0")
            return f'({comp_sym} {lhs_dsl} {rhs_val})'


def render_condition(cond: dict) -> str:
    """
    Dispatch to the right condition renderer based on condition-type.

    Three confirmed schemas from live Sisyphus data:

    Schema 1 — binary (simple, single ticker):
      {"condition-type": "binary", "lhs": {...}, "comparator": "gt", "rhs": {"constant": 74}}

    Schema 2 — compound/all (AND logic):
      {"condition-type": "compound", "operator": "all", "conditions": [...]}

    Schema 3 — compound/any (OR logic):
      {"condition-type": "compound", "operator": "any", "conditions": [...]}

    Schema 4 — binary-compound (same indicator, multiple tickers — expanded to OR):
      {"condition-type": "binary-compound", "operator": "any",
       "tickers": ["QQQ", "SPY"],
       "lhs": {"fn": "...", "params": {...}, "ticker": "%"},
       "comparator": "gt", "rhs": {"constant": 79}}
    """
    cond_type = cond.get("condition-type", "binary")

    if cond_type == "binary":
        return render_binary_condition(cond)

    elif cond_type == "compound":
        operator   = cond.get("operator", "all")
        conditions = cond.get("conditions", [])
        dsl_op     = "and" if operator == "all" else "or"
        parts      = [render_condition(c) for c in conditions]
        inner      = " ".join(parts)
        return f'({dsl_op} {inner})'

    elif cond_type == "binary-compound":
        # Expand: apply same test to each ticker → OR them together
        tickers  = cond.get("tickers", [])
        operator = cond.get("operator", "any")  # "any" = OR, "all" = AND
        dsl_op   = "and" if operator == "all" else "or"
        lhs_info = cond.get("lhs", {})
        fn_name  = lhs_info.get("fn", "")
        window   = (lhs_info.get("params") or {}).get("window", 10)
        comp_sym = COMPARATOR_TO_DSL.get(cond.get("comparator", "gt"), ">")
        rhs_info = cond.get("rhs", {})
        rhs_val  = rhs_info.get("constant", "0")

        parts = []
        for t in tickers:
            lhs_dsl = render_fn_call(fn_name, ticker_to_dsl(t), window)
            parts.append(f'({comp_sym} {lhs_dsl} {rhs_val})')

        if len(parts) == 1:
            return parts[0]
        inner = " ".join(parts)
        return f'({dsl_op} {inner})'

    else:
        # Unknown condition type — render as comment and best-effort binary
        result = render_binary_condition(cond)
        return f'; UNKNOWN condition-type={cond_type!r} — best-effort: {result}'


def extract_condition_from_if_child(node: dict) -> str:
    """
    Extract the condition DSL from a non-else if-child node.

    The condition can be expressed in two ways:
    (a) Flat fields: lhs-fn, lhs-fn-params, lhs-val, comparator, rhs-val, ...
        This is the simple case from the strategy guide examples.
    (b) Condition object: a "condition" key holding one of the three compound schemas.
        This is what Sisyphus actually uses for complex multi-condition branches.

    When both are present, the "condition" object is authoritative (it's the full schema).
    The flat fields are legacy/compatibility copies of the primary condition.
    """
    if "condition" in node:
        return render_condition(node["condition"])
    else:
        # Flat layout — build a synthetic binary dict from the if-child fields
        return render_binary_condition(node)


# ── Node renderers ─────────────────────────────────────────────────────────────

def indent_lines(dsl: str, spaces: int) -> str:
    """Indent every line of a DSL string by N spaces."""
    pad = " " * spaces
    return "\n".join(pad + line if line.strip() else line
                     for line in dsl.split("\n"))


def render_children_block(children: list, indent: int) -> str:
    """Render children as a [...] block — the DSL list syntax the compiler expects."""
    if not children:
        return "[]"
    child_dsls = [render_node(c, indent + 2) for c in children]
    inner = "\n".join(child_dsls)
    pad = " " * indent
    return f'[\n{inner}\n{pad}]'


def render_node(node: dict, indent: int = 2) -> str:
    """
    Recursively render a JSON node to its DSL string.
    Returns the DSL with the given base indentation.
    """
    step = node.get("step", "")
    pad  = " " * indent

    # ── asset ──────────────────────────────────────────────────────────────────
    if step == "asset":
        ticker     = node.get("ticker", "UNKNOWN")
        ticker_dsl = ticker_to_dsl(ticker)
        # Never emit :weight here — weight-specified carries weights in its dict,
        # not on individual asset nodes. The compiler handles weight assignment
        # from the dict, not from child node attributes.
        return f'{pad}(asset {ticker_dsl} "{ticker}")'

    # ── weight-equal / wt-equal ────────────────────────────────────────────────
    elif step in ("wt-cash-equal", "wt-equal"):
        block = render_children_block(node.get("children", []), indent)
        return f'{pad}(weight-equal {block})'

    # ── weight-specified ───────────────────────────────────────────────────────
    elif step == "wt-cash-specified":
        # DSL form A (all-asset children): (weight-specified {"TQQQ" 60 "BIL" 40} [...])
        # DSL form B (mixed/non-asset children): (weight-specified [50 0 50] [...])
        #
        # Form B is required when children include filter, group, if, or other
        # non-asset nodes — which have no ticker to key the dict on.
        # The compiler applies Form B weights positionally by child index.
        children = node.get("children", [])
        all_asset = all(c.get("step") == "asset" for c in children)

        if all_asset:
            # Form A: ticker dict
            weight_pairs = []
            for child in children:
                ticker = child.get("ticker", "UNKNOWN")
                w      = child.get("weight", {"num": 0, "den": 100})
                pct    = w.get("num", 0)
                weight_pairs.append(f'"{ticker}" {pct}')
            weight_spec = "{" + " ".join(weight_pairs) + "}"
        else:
            # Form B: positional list
            weights = []
            for child in children:
                w   = child.get("weight", {"num": 0, "den": 100})
                pct = w.get("num", 0)
                # Preserve exact value — decimal weights like 19.59 must not be truncated
                try:
                    pct_f = float(str(pct))
                    # Emit as integer if whole, decimal otherwise
                    pct = str(int(pct_f)) if pct_f == int(pct_f) else str(pct_f)
                except (ValueError, TypeError):
                    pct = "0"
                weights.append(pct)
            weight_spec = "[" + " ".join(weights) + "]"

        block = render_children_block(children, indent)
        return f'{pad}(weight-specified {weight_spec} {block})'

    # ── weight-inverse-vol ─────────────────────────────────────────────────────
    elif step == "wt-inverse-vol":
        window = node.get("window-days", "10")
        block = render_children_block(node.get("children", []), indent)
        return f'{pad}(weight-inverse-vol {window} {block})'

    # ── filter ─────────────────────────────────────────────────────────────────
    elif step == "filter":
        sort_fn    = node.get("sort-by-fn", "cumulative-return")
        sort_params = node.get("sort-by-fn-params", {})
        window     = sort_params.get("window", 20)
        dsl_fn     = FILTER_FN_JSON_TO_DSL.get(sort_fn, sort_fn)
        select_fn  = node.get("select-fn", "top")
        select_n   = node.get("select-n", "1")
        select_kw  = f"select-{select_fn}"
        block = render_children_block(node.get("children", []), indent)
        return f'{pad}(filter ({dsl_fn} {window}) ({select_kw} {select_n}) {block})'

    # ── if / if-child ──────────────────────────────────────────────────────────
    elif step == "if":
        children = node.get("children", [])
        condition_child = next((c for c in children
                                if not c.get("is-else-condition?", False)), None)
        else_child      = next((c for c in children
                                if c.get("is-else-condition?", False)), None)

        if condition_child is None:
            raise ValueError(f"if node has no non-else if-child: {node}")
        if else_child is None:
            raise ValueError(f"if node has no else if-child: {node}")

        condition_dsl  = extract_condition_from_if_child(condition_child)
        true_block     = render_children_block(condition_child.get("children", []), indent)
        false_block    = render_children_block(else_child.get("children", []),      indent)

        return f'{pad}(if {condition_dsl} {true_block} {false_block})'

    # ── group ──────────────────────────────────────────────────────────────────
    elif step == "group":
        name  = escape_dsl_string(node.get("name", "unnamed"))
        block = render_children_block(node.get("children", []), indent)
        return f'{pad}(group "{name}" {block})'

    else:
        # Unknown step — emit as comment with raw JSON for manual inspection
        return f'{pad}; UNKNOWN step={step!r} — raw: {json.dumps(node)}'


# ── Post-compilation cleanup ───────────────────────────────────────────────────

def clean_compiled(node: dict) -> dict:
    """
    Post-process compiled JSON to match Composer's expected format.

    Fixes applied:
    1. Asset nodes: strip children:[] — Composer rejects explicit empty children
    2. All nodes: add collapsed?=False if missing — Composer requires this field
    3. if-child nodes: restore lhs-fn-params / rhs-fn-params — Composer needs both
       the old window-days flat fields AND the new params objects
    4. filter nodes: add sort-by-window-days from sort-by-fn-params if missing
    """
    if not isinstance(node, dict):
        return node
    node = dict(node)  # shallow copy — don't mutate original

    step = node.get("step", "")

    # Fix 1: asset nodes — strip empty children
    if step == "asset":
        node.pop("children", None)
        # Do NOT add collapsed? to asset nodes — Composer rejects it
        return node

    # Fix 2: add collapsed? to all non-asset nodes that support it
    if step in ("if", "if-child", "group", "wt-cash-equal", "wt-cash-specified",
                "wt-inverse-vol", "wt-equal", "filter"):
        if "collapsed?" not in node:
            node["collapsed?"] = False

    # Fix 3: if-child — ensure both lhs-fn-params AND lhs-window-days present
    if step == "if-child":
        # Restore lhs-fn-params if stripped or missing
        if "lhs-fn-params" not in node and "lhs-window-days" in node:
            node["lhs-fn-params"] = {"window": int(node["lhs-window-days"])}
        # Restore rhs-fn-params if rhs-fn present but params missing
        if "rhs-fn" in node and "rhs-fn-params" not in node and "rhs-window-days" in node:
            node["rhs-fn-params"] = {"window": int(node["rhs-window-days"])}

    # Fix 4: filter nodes — ensure sort-by-window-days present
    if step == "filter":
        if "sort-by-window-days" not in node and "sort-by-fn-params" in node:
            node["sort-by-window-days"] = str(node["sort-by-fn-params"].get("window", 10))

    # Recurse into children
    if "children" in node:
        node["children"] = [clean_compiled(c) for c in node["children"]]

    return node

def json_to_dsl(symphony_json: dict) -> str:
    """
    Convert a Composer symphony JSON object to DSL string.

    Handles two JSON layouts:
    (a) Generator KB format:
        {"name": "...", "rebalance_frequency": "daily", "children": [...]}
    (b) API root format (with step: "root"):
        {"step": "root", "name": "...", "rebalance": "daily", "children": [...]}

    Returns a complete DSL string ready to feed to dsl_compiler.py.
    """
    # Detect layout
    if symphony_json.get("step") == "root":
        name     = symphony_json.get("name", "Unnamed Symphony")
        rebalance = symphony_json.get("rebalance", "daily")
        children  = symphony_json.get("children", [])
    else:
        name      = symphony_json.get("name", "Unnamed Symphony")
        rebalance = symphony_json.get("rebalance_frequency", "daily")
        children  = symphony_json.get("children", [])

    name_escaped = escape_dsl_string(name)
    rebalance_dsl = f":{rebalance}"

    lines = [f'defsymphony "{name_escaped}" {{:rebalance-frequency {rebalance_dsl}}}']
    for child in children:
        lines.append(render_node(child, indent=2))

    return "\n".join(lines)


# ── Original-field preservation ───────────────────────────────────────────────

def merge_from_original(compiled: dict, original: dict) -> dict:
    """
    Walk compiled and original trees in parallel, copying fields that the
    DSL round-trip cannot preserve:
      - weight on filter/if/group/wt-cash-equal (wt-cash-specified children)
      - window-days on wt-cash-equal nodes (Composer quirk)
      - collapsed? on all nodes
      - sort-by-window-days on filter nodes

    Trees must be structurally aligned (same node types, same children order).
    Misaligned subtrees are skipped safely.
    """
    COPY_FIELDS = {'weight', 'window-days', 'collapsed?', 'sort-by-window-days',
                   'rebalance-corridor-width'}

    def _merge(comp, orig):
        if not isinstance(comp, dict) or not isinstance(orig, dict):
            return comp
        if comp.get('step') != orig.get('step'):
            return comp  # misaligned — skip safely

        comp = dict(comp)
        for field in COPY_FIELDS:
            if field in orig and field not in comp:
                comp[field] = orig[field]

        # Recurse — align children by position
        comp_ch = comp.get('children', [])
        orig_ch = orig.get('children', [])
        if comp_ch and orig_ch:
            merged = [_merge(cc, oc) for cc, oc in zip(comp_ch, orig_ch)]
            merged += comp_ch[len(orig_ch):]  # keep any extra compiled nodes
            comp['children'] = merged

        return comp

    return _merge(compiled, original)


# ── Round-trip test harness ────────────────────────────────────────────────────

def normalise_for_compare(node: dict) -> dict:
    """
    Strip fields that are irrelevant to logical equality for round-trip comparison:
    - id / uuid fields (regenerated by compiler)
    - description block (metadata, not logic)
    - asset_class fields
    - version_id fields
    Returns a cleaned copy suitable for structural diffing.
    """
    SKIP_KEYS = {"id", "asset_class", "asset-class", "version_id",
                 "description", "created_at", "updated_at"}
    if isinstance(node, dict):
        return {k: normalise_for_compare(v)
                for k, v in node.items()
                if k not in SKIP_KEYS}
    elif isinstance(node, list):
        return [normalise_for_compare(i) for i in node]
    else:
        return node


def deep_diff(a: Any, b: Any, path: str = "") -> list[str]:
    """
    Recursively diff two normalised JSON structures.
    Returns list of human-readable difference strings.
    """
    diffs = []

    if type(a) != type(b):
        diffs.append(f"{path}: type mismatch {type(a).__name__} vs {type(b).__name__}")
        return diffs

    if isinstance(a, dict):
        all_keys = set(a) | set(b)
        for k in sorted(all_keys):
            child_path = f"{path}.{k}" if path else k
            if k not in a:
                diffs.append(f"{child_path}: MISSING in original (present in compiled)")
            elif k not in b:
                diffs.append(f"{child_path}: MISSING in compiled (present in original)")
            else:
                diffs.extend(deep_diff(a[k], b[k], child_path))

    elif isinstance(a, list):
        if len(a) != len(b):
            diffs.append(f"{path}: list length {len(a)} vs {len(b)}")
        for i, (x, y) in enumerate(zip(a, b)):
            diffs.extend(deep_diff(x, y, f"{path}[{i}]"))

    else:
        if a != b:
            diffs.append(f"{path}: {a!r} → {b!r}")

    return diffs


def run_roundtrip(input_json_path: str, compiler_path: str = "src/dsl_compiler.py") -> bool:
    """
    Full round-trip test:
      1. Load original JSON
      2. Convert JSON → DSL (this converter)
      3. Compile DSL → JSON (dsl_compiler.py)
      4. Normalise both JSONs (strip UUIDs, descriptions)
      5. Deep-diff and report

    Returns True if round-trip is clean (no logical differences).
    """
    print(f"\n{'='*60}")
    print(f"ROUND-TRIP TEST: {input_json_path}")
    print(f"{'='*60}")

    # Step 1: Load original
    with open(input_json_path) as f:
        original_json = json.load(f)
    print(f"  Loaded original JSON ({len(json.dumps(original_json))} bytes)")

    # Step 2: Convert to DSL
    dsl_str = json_to_dsl(original_json)
    print(f"  Converted to DSL ({len(dsl_str)} bytes, "
          f"{len(dsl_str.splitlines())} lines)")

    # Write DSL to temp file
    with tempfile.NamedTemporaryFile(mode='w', suffix='.dsl',
                                     delete=False) as tf:
        tf.write(dsl_str)
        dsl_path = tf.name

    compiled_json_path = dsl_path.replace(".dsl", "_compiled.json")

    try:
        # Step 3: Compile DSL → JSON
        result = subprocess.run(
            ["python3", compiler_path, "--input", dsl_path,
             "--output", compiled_json_path],
            capture_output=True, text=True
        )
        if result.returncode != 0:
            print(f"  COMPILER ERROR:\n{result.stderr}")
            print(f"\n  DSL output (first 50 lines):")
            for i, line in enumerate(dsl_str.splitlines()[:50], 1):
                print(f"    {i:3d}  {line}")
            return False

        with open(compiled_json_path) as f:
            compiled_json = json.load(f)
        print(f"  Compiled back to JSON ({len(json.dumps(compiled_json))} bytes)")

        # Step 4: Normalise
        orig_norm     = normalise_for_compare(original_json)
        compiled_norm = normalise_for_compare(compiled_json)

        # Step 5: Diff
        diffs = deep_diff(orig_norm, compiled_norm)

        if not diffs:
            print(f"  ✓ ROUND-TRIP CLEAN — no logical differences")
            return True
        else:
            print(f"  ✗ ROUND-TRIP DIFFERENCES ({len(diffs)} found):")
            for d in diffs[:30]:  # cap output for large symphonies
                print(f"    {d}")
            if len(diffs) > 30:
                print(f"    ... and {len(diffs) - 30} more")
            return False

    finally:
        os.unlink(dsl_path)
        if os.path.exists(compiled_json_path):
            os.unlink(compiled_json_path)


# ── CLI ────────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Convert Composer symphony JSON to DSL"
    )
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--input",     "-i", help="Input JSON file path")
    group.add_argument("--roundtrip", "-r", help="Run round-trip test on JSON file")
    group.add_argument("--compile",   "-c", help="Convert JSON → DSL → cleaned JSON (for Composer import)")

    parser.add_argument("--output",   "-o", help="Output file path (default: stdout)")
    parser.add_argument("--compiler",       help="Path to dsl_compiler.py",
                        default="src/dsl_compiler.py")
    parser.add_argument("--stdin",          action="store_true",
                        help="Read JSON from stdin instead of file")

    args = parser.parse_args()

    if args.roundtrip:
        success = run_roundtrip(args.roundtrip, args.compiler)
        sys.exit(0 if success else 1)

    if args.compile:
        # Full pipeline: JSON → DSL → compile → clean → merge → output JSON
        import importlib.util
        spec = importlib.util.spec_from_file_location("dsl_compiler", args.compiler)
        mod  = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(mod)

        with open(args.compile) as f:
            symphony_json = json.load(f)
        dsl_str  = json_to_dsl(symphony_json)
        compiled = mod.compile_dsl(dsl_str)
        cleaned  = clean_compiled(compiled)
        merged   = merge_from_original(cleaned, symphony_json)

        out = json.dumps(merged, indent=2)
        if args.output:
            with open(args.output, "w") as f:
                f.write(out)
            print(f"Wrote compiled JSON to {args.output} ({len(out):,} bytes)")
        else:
            print(out)
        return

    # Normal conversion mode: JSON → DSL
    if args.stdin:
        symphony_json = json.load(sys.stdin)
    else:
        with open(args.input) as f:
            symphony_json = json.load(f)

    dsl_str = json_to_dsl(symphony_json)

    if args.output:
        with open(args.output, "w") as f:
            f.write(dsl_str)
            f.write("\n")
        print(f"Wrote DSL to {args.output} ({len(dsl_str)} bytes, "
              f"{len(dsl_str.splitlines())} lines)")
    else:
        print(dsl_str)


if __name__ == "__main__":
    main()
