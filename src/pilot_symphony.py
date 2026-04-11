"""
pilot_symphony.py — Generalized symphony mini-strategy extraction pilot.

Runs the full extraction pipeline on any portfolio symphony by ID,
then optionally compares registries across multiple symphonies to
identify overlapping mini-strategy patterns.

Improvements over pilot_fngg.py:
  - Works on any symphony by --id and --name flags
  - KMLM and other managed-futures tickers flagged as no_substitute
  - Large-asset mini-strategies (>20 assets) marked recomposable:partial
    with sector decomposition note instead of single-ticker oversimplification
  - Adds recomposable field: full | partial | logic_only
  - --compare flag loads two registry JSONs and reports overlaps

Usage:
  # Run on Sisyphus:
  python3 pilot_symphony.py \\
    --id qjRIwrAOA1YzFSghM08b \\
    --name "Sisyphus V0.0" \\
    --sharpe 1.92 --cagr 45.8 --maxdd 10.3

  # Compare FNGG vs Sisyphus after both have run:
  python3 pilot_symphony.py --compare \\
    --reg1 kb/pilot/fngg_registry.json \\
    --reg2 kb/pilot/sisyphus_registry.json

  # Dry run:
  python3 pilot_symphony.py --id TEST --name "Test" --dry-run

Output files (written to kb/pilot/):
  {slug}_registry.json   machine-readable registry
  {slug}_review.txt      human-readable review
  overlap_report.txt     (--compare mode only)

Cost: ~$0.05-0.15 per symphony (one Claude call)
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import time
from datetime import datetime, timezone
from pathlib import Path
from typing import Optional

# ── Path setup ─────────────────────────────────────────────────────────────────
_LEARNING_ROOT = Path.home() / '.openclaw' / 'workspace' / 'learning'
_SRC_DIR       = _LEARNING_ROOT / 'src'
_PILOT_DIR     = _LEARNING_ROOT / 'kb' / 'pilot'
_PROXY_BASE    = 'http://localhost:8080/composer'

sys.path.insert(0, str(_SRC_DIR))

# ── Constants ──────────────────────────────────────────────────────────────────
CLAUDE_MODEL = 'claude-sonnet-4-6'
MAX_TOKENS   = 8000

# Generator-approved universe
GENERATOR_UNIVERSE = {
    'SVIX', 'SVXY',
    'UVXY', 'VIXM',
    'TQQQ', 'TECL', 'SOXL', 'SPXL', 'UPRO',
    'SQQQ', 'SOXS', 'SPXS', 'TECS',
    'BIL', 'SPY', 'QQQ',
}

# Tickers that have NO meaningful in-universe substitute.
# These are strategy categories not represented in the generator universe.
NO_SUBSTITUTE_TICKERS = {
    # Managed futures / trend-following — no analog in universe
    'KMLM', 'BTAL', 'FTLS', 'DBMF', 'CTA',
    # Fixed income / rates — no bond ETF in universe
    'BND', 'IEF', 'TLT', 'TMF', 'TMV', 'TYO', 'IEI', 'SHY', 'GOVT',
    # Commodities
    'GLD', 'DBC', 'UCO', 'USO', 'UNG',
    # Currency
    'UUP', 'USDU',
    # International
    'EEM', 'EFA', 'EDC', 'EDZ', 'EEMV',
}

# Sector ETFs — out of universe but have describable sector role
SECTOR_ETFS = {
    'XLK': 'technology', 'XLF': 'financials', 'XLE': 'energy',
    'XLV': 'healthcare', 'XLU': 'utilities', 'XLI': 'industrials',
    'XLP': 'consumer_staples', 'XLB': 'materials', 'XLRE': 'real_estate',
    'SMH': 'semiconductors', 'SPHB': 'high_beta', 'SPLV': 'low_vol',
}

# Threshold above which a mini-strategy is flagged as recomposable:partial
LARGE_ASSET_THRESHOLD = 20


# ── Step 1: Fetch symphony JSON ────────────────────────────────────────────────

def fetch_symphony_json(symphony_id: str) -> Optional[dict]:
    """Fetch symphony definition from Composer proxy."""
    import requests

    url = f'{_PROXY_BASE}/api/v0.1/symphonies/{symphony_id}/score'
    print(f'  Fetching {url}...')

    try:
        resp = requests.get(url, timeout=15)
        if resp.status_code != 200:
            print(f'  ERROR: HTTP {resp.status_code}')
            print(f'  Body: {resp.text[:200]}')
            return None

        data = resp.json()
        node = (
            data.get('definition') or
            data.get('score') or
            data.get('symphony') or
            (data if data.get('step') else None)
        )

        if not node:
            print(f'  ERROR: Could not find node tree in response.')
            print(f'  Response keys: {list(data.keys())}')
            return None

        print(f'  Fetched. Root step: {node.get("step", "?")}')
        return node

    except Exception as e:
        print(f'  ERROR: {e}')
        return None


# ── Step 2: Run symphony_analyzer ─────────────────────────────────────────────

def run_analyzer(composer_json: dict, symphony_id: str, symphony_name: str) -> tuple:
    """Run symphony_analyzer. Returns (registry, compressed_rep)."""
    try:
        import symphony_analyzer as sa
    except ImportError:
        raise ImportError(
            'symphony_analyzer.py not found.\n'
            'Expected: ~/.openclaw/workspace/learning/src/symphony_analyzer.py'
        )

    print(f'  symphony_analyzer imported from: {sa.__file__}')

    sym = {'id': symphony_id, 'name': symphony_name, 'composer_json': composer_json}
    registry, compressed_syms = sa.analyze_and_compress_symphonies(
        [sym], save_kb=False, verify=True,
    )
    compressed_rep = compressed_syms[0].get('compressed_repr', {})

    stats = registry['stats']
    print(f'  Extracted {stats["total_mini_strategies"]} mini-strategies '
          f'({stats["named"]} named, {stats["structural"]} structural)')

    if stats['total_mini_strategies'] == 0:
        print('  WARNING: Zero mini-strategies extracted.')
        print('  Symphony may have no named group nodes.')

    return registry, compressed_rep


# ── Step 3: Claude prompt and call ────────────────────────────────────────────

CLAUDE_SYSTEM = """\
You are a quantitative analyst specializing in Composer.trade \
algorithmic trading strategies. You analyze extracted trading \
strategy sub-components and classify them precisely.

Your output is always a single valid JSON object with no preamble, \
no explanation, no markdown fences. Start with { and end with }.\
"""


def _collect_tickers(node: dict) -> list:
    tickers = []
    if isinstance(node, dict):
        if node.get('step') == 'asset' and node.get('ticker'):
            tickers.append(node['ticker'].upper())
        for child in node.get('children', []):
            tickers.extend(_collect_tickers(child))
    return tickers


def _classify_out_of_universe(assets: list) -> dict:
    """
    Classify each out-of-universe asset into one of three categories:
      substitute_available  — clear in-universe equivalent exists
      no_substitute         — strategy category not in universe
      sector_etf            — sector ETF, describe by sector role
    """
    result = {}
    for t in assets:
        if t in GENERATOR_UNIVERSE:
            continue
        if t in NO_SUBSTITUTE_TICKERS:
            result[t] = 'no_substitute'
        elif t in SECTOR_ETFS:
            result[t] = f'sector_etf:{SECTOR_ETFS[t]}'
        else:
            result[t] = 'substitute_available'
    return result


def _recomposability(assets: list, out_of_universe: list) -> str:
    """
    Determine how recomposable a mini-strategy is.
      full         — all assets in-universe, can be used directly
      partial      — mostly in-universe, substitutes available
      logic_only   — too many out-of-universe assets or large stock list
    """
    total = len(assets)
    oou   = len(out_of_universe)

    if oou == 0:
        return 'full'
    if total > LARGE_ASSET_THRESHOLD:
        return 'logic_only'
    if oou <= 2:
        return 'partial'
    # Check if out-of-universe assets are all in no_substitute category
    classifications = _classify_out_of_universe(assets)
    no_sub_count = sum(1 for v in classifications.values() if v == 'no_substitute')
    if no_sub_count > 1:
        return 'logic_only'
    return 'partial'


def _summarise_oou(assets: list, oou: list) -> str:
    """
    Summarise out-of-universe assets as a short string for the prompt.
    E.g. "3 no_substitute (TLT, IEF, BND), 2 substitute_available (FNGD, SPXU)"
    Avoids sending full classification dicts that bloat the prompt.
    """
    if not oou:
        return "all in-universe"
    no_sub    = [t for t in oou if t in NO_SUBSTITUTE_TICKERS]
    sector    = [t for t in oou if t in SECTOR_ETFS]
    sub_avail = [t for t in oou if t not in NO_SUBSTITUTE_TICKERS and t not in SECTOR_ETFS]
    parts = []
    if no_sub:
        parts.append(f"{len(no_sub)} no_substitute ({', '.join(no_sub[:4])})")
    if sector:
        parts.append(f"{len(sector)} sector_etf ({', '.join(sector[:3])})")
    if sub_avail:
        parts.append(f"{len(sub_avail)} substitute_available ({', '.join(sub_avail[:4])})")
    return "; ".join(parts)


def _build_batch_prompt(
    ms_batch: list,
    symphony_id: str,
    symphony_name: str,
    perf: dict,
    universe_str: str,
    batch_num: int,
    total_batches: int,
) -> str:
    """Build a prompt for one batch of mini-strategies."""
    ms_json = json.dumps(ms_batch, indent=2)
    return _make_prompt_body(
        ms_json, len(ms_batch), symphony_id, symphony_name, perf, universe_str,
        batch_note=f"(batch {batch_num}/{total_batches})"
    )


def build_claude_prompt(

    registry: dict,
    symphony_id: str,
    symphony_name: str,
    perf: dict,
) -> str:
    """Build Claude prompt with improved substitution and recomposability guidance."""
    mini_strategies = registry.get('mini_strategies', {})
    if not mini_strategies:
        return ''

    try:
        import symphony_analyzer as sa
        _extract_parameters = sa._extract_parameters
    except ImportError:
        return ''

    universe_str = ', '.join(sorted(GENERATOR_UNIVERSE))

    ms_blocks = []
    for ms_id, ms in mini_strategies.items():
        params  = _extract_parameters(ms.get('full_json', {}))
        assets  = list({t for t in _collect_tickers(ms.get('full_json', {}))})
        oou     = [t for t in assets if t not in GENERATOR_UNIVERSE]
        recomp  = _recomposability(assets, oou)
        oou_summary = _summarise_oou(assets, oou)

        ms_blocks.append({
            'id':           ms_id,
            'name':         ms['name'],
            'asset_count':  len(assets),
            # Only 8 sample tickers — Claude needs categories not full lists
            'sample_assets': assets[:8],
            'oou_summary':  oou_summary,
            'recomposable': recomp,
            'parameters':   params,
        })

    ms_json = json.dumps(ms_blocks, indent=2)

    # If prompt would be too large, batch into groups of 5 and return a list
    BATCH_SIZE = 5
    if len(ms_json) > 7000 or len(ms_blocks) > BATCH_SIZE:
        n_batches = (len(ms_blocks) + BATCH_SIZE - 1) // BATCH_SIZE
        print(f'  Batching {len(ms_blocks)} mini-strategies into {n_batches} Claude calls')
        batches = [
            ms_blocks[i:i+BATCH_SIZE]
            for i in range(0, len(ms_blocks), BATCH_SIZE)
        ]
        return [
            _build_batch_prompt(b, symphony_id, symphony_name, perf,
                                universe_str, i+1, n_batches)
            for i, b in enumerate(batches)
        ]

    # Single call — return string directly
    return _make_prompt_body(
        ms_json, len(ms_blocks), symphony_id, symphony_name, perf, universe_str
    )


def _make_prompt_body(
    ms_json: str,
    n_ms: int,
    symphony_id: str,
    symphony_name: str,
    perf: dict,
    universe_str: str,
    batch_note: str = '',
) -> str:
    """Assemble the actual prompt string."""
    return f"""\
I have extracted {n_ms} mini-strategies {batch_note}from a \
Composer trading symphony.

Symphony context:
  Name:   {symphony_name}
  ID:     {symphony_id}
  Sharpe: {perf.get('sharpe')} (1Y)
  CAGR:   {perf.get('cagr')}% (1Y)
  Max DD: {perf.get('max_dd')}% (1Y)

Generator-approved asset universe:
  {universe_str}

IMPORTANT SUBSTITUTION RULES:
- Managed futures ETFs (KMLM, BTAL, FTLS, DBMF): NO in-universe substitute.
  These are trend-following/alternative risk premia strategies with NO analog
  in the generator universe. Set in_universe_substitute to null with
  note "no_substitute: managed futures category not in universe".
- Bond/rate ETFs (BND, IEF, TLT, TMF, TYO, IEI, SHY, GOVT): NO in-universe
  substitute. Set to null with note "no_substitute: fixed income not in universe".
- Individual stocks (AAPL, MSFT, NVDA etc): If >5 individual stocks, do NOT
  simplify to SPY. Instead describe the sector composition and note
  "logic_only: large equity universe — extract RSI/momentum logic, not tickers".
- Sector ETFs (XLK, XLF, XLE etc): Note the sector role
  (e.g. "XLK fills technology sector role — no direct in-universe substitute").

For each mini-strategy, provide:

1. "role" — EXACTLY ONE from:
   "crash_guard"       : exits to safety when drawdown/vol signal triggers
   "momentum_selector" : enters/exits based on price trend or momentum
   "regime_router"     : routes between bull/bear assets based on market state
   "asset_rotator"     : ranks and selects best performer from candidate set
   "safe_haven"        : holds low-risk asset (BIL/SPY/QQQ) unconditionally
   If none fit, use "other" and explain in role_note.

2. "plain_english" — one precise sentence. Format:
   "If [signal on asset] [condition], hold [asset]; otherwise hold [asset]."
   Chain logic for multi-condition: "If A then X; if B then Y; otherwise Z."

3. "regime_tags" — 1-3 regime objects:
   "bull_low_vol"   — low VIX, uptrend (2019, 2023-2024)
   "bear_sustained" — sustained downtrend (2022)
   "vix_spike"      — acute spike, fast recovery (Feb 2020)
   "sideways_chop"  — mean-reverting, no clear trend (mid-2015)
   Each: {{"regime": "X", "effectiveness": "effective|ineffective", "source": "inferred"}}

4. "in_universe_substitute" — Follow the substitution rules above strictly.
   For assets with no substitute: {{"out_of_universe_ticker": "KMLM",
   "substitute": null, "reasoning": "no_substitute: managed futures category"}}
   For assets with a substitute: {{"out_of_universe_ticker": "FNGG",
   "substitute": "TQQQ", "reasoning": "3x tech-adjacent — TQQQ is equivalent"}}
   Set entire field to null if all assets are in-universe.

5. "recomposable" — use the pre-computed value from the input data:
   "full"       : all assets in-universe, generator can use directly
   "partial"    : minor substitutions needed, logic and structure reusable
   "logic_only" : too many out-of-universe assets; extract the logic pattern
                  only — do not attempt to reuse tickers

6. "extractable_pattern" — one sentence describing what the generator
   should LEARN from this mini-strategy, regardless of recomposability.
   Focus on the structural logic, not the specific tickers.
   Example: "Use TQQQ 5.5% cumulative-return threshold as a momentum gate
   before entering leveraged bull positions."

7. "confidence" — 0.0-1.0 for role assignment confidence.

Output (single JSON, no preamble):
{{
  "symphony_id": "{symphony_id}",
  "analyzed_at": "<ISO>",
  "mini_strategies": [
    {{
      "id": "ms-001",
      "role": "<role>",
      "role_note": "<optional>",
      "plain_english": "<sentence>",
      "regime_tags": [...],
      "in_universe_substitute": null or {{...}},
      "recomposable": "full|partial|logic_only",
      "extractable_pattern": "<sentence>",
      "confidence": 0.85
    }}
  ],
  "taxonomy_notes": "<diagnostic observations>",
  "cross_strategy_patterns": [
    "<any parameters or structural patterns that appear in 2+ mini-strategies>"
  ]
}}

MINI-STRATEGIES TO ANALYZE:
{ms_json}
"""  # end _make_prompt_body


def call_claude(prompt: str, anthropic_key: str, label: str = '') -> Optional[dict]:
    """Single Claude API call. Returns parsed JSON or None."""
    import requests

    url     = 'https://api.anthropic.com/v1/messages'
    headers = {
        'x-api-key':         anthropic_key,
        'anthropic-version': '2023-06-01',
        'content-type':      'application/json',
    }
    payload = {
        'model':      CLAUDE_MODEL,
        'max_tokens': MAX_TOKENS,
        'system':     CLAUDE_SYSTEM,
        'messages':   [{'role': 'user', 'content': prompt}],
    }

    tag = f' [{label}]' if label else ''
    print(f'  Calling Claude{tag} ({CLAUDE_MODEL}, max_tokens={MAX_TOKENS})...')
    t0 = time.time()

    try:
        resp    = requests.post(url, headers=headers, json=payload, timeout=240)
        elapsed = time.time() - t0

        if resp.status_code != 200:
            print(f'  ERROR: {resp.status_code}: {resp.text[:300]}')
            return None

        data  = resp.json()
        usage = data.get('usage', {})
        stop_reason = data.get('stop_reason', '')
        text  = ''.join(
            b.get('text', '')
            for b in data.get('content', [])
            if b.get('type') == 'text'
        )

        print(f'  Claude responded in {elapsed:.1f}s '
              f'({usage.get("input_tokens",0)} in / '
              f'{usage.get("output_tokens",0)} out, '
              f'stop={stop_reason})')

        if stop_reason == 'max_tokens':
            print(f'  WARNING: Response truncated at {MAX_TOKENS} tokens.')
            print(f'  The JSON will be incomplete and unparseable.')
            print(f'  Consider reducing the number of mini-strategies per call.')

        text = re.sub(r'```(?:json)?\s*', '', text).strip()

        # Always save raw response for debugging
        raw_path = _PILOT_DIR / f'_last_claude_raw.txt'
        try:
            raw_path.parent.mkdir(parents=True, exist_ok=True)
            raw_path.write_text(text, encoding='utf-8')
        except Exception:
            pass

        try:
            return json.loads(text)
        except json.JSONDecodeError:
            start = text.find('{')
            end   = text.rfind('}')
            if start != -1 and end > start:
                try:
                    return json.loads(text[start:end + 1])
                except json.JSONDecodeError:
                    pass
            print(f'  ERROR: Could not parse Claude response as JSON.')
            print(f'  Output tokens: {usage.get("output_tokens", 0)} '
                  f'(limit: {MAX_TOKENS})')
            if usage.get("output_tokens", 0) >= MAX_TOKENS - 50:
                print(f'  LIKELY CAUSE: Response was truncated at token limit.')
                print(f'  Raw response saved to: {raw_path}')
                print(f'  First 300 chars of response:\n{text[:300]}')
                print(f'  Last 300 chars of response:\n{text[-300:]}')
            else:
                print(f'  Raw response saved to: {raw_path}')
                print(f'  First 500 chars:\n{text[:500]}')
            return None

    except Exception as e:
        print(f'  ERROR: {e}')
        return None


# ── Step 4: Build output ───────────────────────────────────────────────────────

def _normalise_substitute(sub) -> object:
    """
    Normalise Claude's in_universe_substitute field.
    Claude sometimes returns:
      - null  → return None
      - dict  → return as-is
      - list of dicts → return list (writer handles iteration)
      - list with one element → return that element as dict
    """
    if not sub:
        return None
    if isinstance(sub, dict):
        return sub
    if isinstance(sub, list):
        # Filter out non-dict entries
        clean = [s for s in sub if isinstance(s, dict)]
        if not clean:
            return None
        if len(clean) == 1:
            return clean[0]
        return clean   # multiple substitutes — writer will iterate
    return None  # unexpected type


def build_registry_output(
    registry: dict,
    compressed_rep: dict,
    claude_output: Optional[dict],
    composer_json: dict,
    symphony_id: str,
    symphony_name: str,
    perf: dict,
) -> dict:
    """Merge analyzer + Claude output into final standardized registry."""
    try:
        import symphony_analyzer as sa
        _extract_parameters = sa._extract_parameters
    except ImportError:
        def _extract_parameters(n): return {}

    claude_annotations = {}
    if claude_output:
        for item in claude_output.get('mini_strategies', []):
            claude_annotations[item['id']] = item

    enriched_ms = {}
    for ms_id, ms in registry.get('mini_strategies', {}).items():
        ann    = claude_annotations.get(ms_id, {})
        assets = list({t for t in _collect_tickers(ms.get('full_json', {}))})
        params = _extract_parameters(ms.get('full_json', {}))
        oou    = [t for t in assets if t not in GENERATOR_UNIVERSE]

        enriched_ms[ms_id] = {
            'id':          ms_id,
            'name':        ms['name'],
            'source':      ms['source'],
            'fingerprint': ms['fingerprint'],
            'assets':      assets,
            'asset_count': len(assets),
            'in_universe': len(oou) == 0,
            'parameters':  params,

            # Claude annotations
            'role':                  ann.get('role', 'unknown'),
            'role_note':             ann.get('role_note'),
            'plain_english':         ann.get('plain_english', ''),
            'confidence':            ann.get('confidence', 0.0),
            'regime_tags':           ann.get('regime_tags', []),
            # Normalise substitute: Claude sometimes returns list, sometimes dict, sometimes null
            'in_universe_substitute': _normalise_substitute(ann.get('in_universe_substitute')),
            'recomposable':          ann.get('recomposable',
                                             _recomposability(assets, oou)),
            'extractable_pattern':   ann.get('extractable_pattern', ''),

            # Lineage
            'appears_in':  ms['appears_in'],
            'recurrence':  ms['recurrence'],
            'full_json':   ms['full_json'],
        }

    compression = compressed_rep.get('compression_stats', {})
    stats       = registry.get('stats', {})

    return {
        'schema_version': '1.0',
        'created_at':     datetime.now(timezone.utc).isoformat(),

        'symphony': {
            'id':          symphony_id,
            'name':        symphony_name,
            'performance': perf,
            'total_nodes': compression.get('original_node_count'),
            'asset_count': len({t for t in _collect_tickers(composer_json)}),
        },

        'extraction_stats': {
            'total_mini_strategies': stats.get('total_mini_strategies', 0),
            'named':                 stats.get('named', 0),
            'structural':            stats.get('structural', 0),
            'compression_ratio': (
                round(
                    compression.get('original_node_count', 1) /
                    max(compression.get('compressed_node_count', 1), 1),
                    1
                ) if compression.get('original_node_count') else None
            ),
            'round_trip_verified': True,
        },

        'claude_analysis': {
            'model':               CLAUDE_MODEL,
            'taxonomy_notes':      claude_output.get('taxonomy_notes') if claude_output else None,
            'cross_strategy_patterns': (
                claude_output.get('cross_strategy_patterns', []) if claude_output else []
            ),
            'parse_success':       claude_output is not None,
        },

        'mini_strategies': enriched_ms,
    }


# ── Output writers ─────────────────────────────────────────────────────────────

def write_registry_json(output: dict, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix('.tmp')
    with open(tmp, 'w', encoding='utf-8') as f:
        json.dump(output, f, indent=2)
    tmp.rename(path)
    print(f'  Wrote: {path}')


def write_review_txt(output: dict, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    lines = []

    def h1(t): lines.append(f'\n{"="*60}\n{t}\n{"="*60}')
    def h2(t): lines.append(f'\n── {t} ──')
    def row(k, v): lines.append(f'  {k:<32} {v}')

    sym  = output.get('symphony', {})
    perf = sym.get('performance', {})

    h1(f'SYMPHONY REVIEW — {datetime.now().strftime("%Y-%m-%d %H:%M")}')
    lines.append(f'Symphony: {sym.get("name")} ({sym.get("id")})')
    lines.append(
        f'Sharpe: {perf.get("sharpe")}  '
        f'CAGR: {perf.get("cagr")}%  '
        f'Max DD: {perf.get("max_dd")}%'
    )

    h2('EXTRACTION SUMMARY')
    stats = output.get('extraction_stats', {})
    row('Total mini-strategies:',  stats.get('total_mini_strategies', '?'))
    row('Named groups:',           stats.get('named', '?'))
    row('Structural:',             stats.get('structural', '?'))
    cr = stats.get('compression_ratio')
    row('Compression ratio:',      f'{cr}x' if cr else '?')
    row('Round-trip verified:',    '✓ PASS' if stats.get('round_trip_verified') else '✗ FAIL')

    claude = output.get('claude_analysis', {})
    row('Claude parse success:',   '✓ YES' if claude.get('parse_success') else '✗ NO')

    if claude.get('taxonomy_notes'):
        lines.append(f'\n  Taxonomy notes:')
        # word-wrap at 70
        words = claude['taxonomy_notes'].split()
        line  = '  '
        for w in words:
            if len(line) + len(w) > 72:
                lines.append(line)
                line = '  ' + w + ' '
            else:
                line += w + ' '
        if line.strip():
            lines.append(line)

    csp = claude.get('cross_strategy_patterns', [])
    if csp:
        lines.append(f'\n  Cross-strategy patterns:')
        for p in csp:
            lines.append(f'    • {p}')

    h1('MINI-STRATEGIES')

    mini_strategies = output.get('mini_strategies', {})
    if not mini_strategies:
        lines.append('  (none extracted)')
    else:
        recomp_counts = {'full': 0, 'partial': 0, 'logic_only': 0}

        for ms_id, ms in mini_strategies.items():
            h2(f'{ms_id} — {ms["name"]}')

            row('Source:',        ms['source'])
            row('Assets:',        f'{ms["asset_count"]} total')
            if ms['asset_count'] <= 15:
                row('  Tickers:',  ', '.join(ms.get('assets', [])))
            else:
                shown = ms.get('assets', [])[:10]
                row('  First 10:', ', '.join(shown) + f'  (+{ms["asset_count"]-10} more)')
            row('In-universe:',   '✓ YES' if ms.get('in_universe') else '✗ NO')
            row('Recomposable:',  ms.get('recomposable', '?'))
            row('Role:',          ms.get('role', 'unknown'))
            row('Confidence:',    f'{ms.get("confidence", 0):.0%}')

            recomp_counts[ms.get('recomposable', 'logic_only')] = (
                recomp_counts.get(ms.get('recomposable', 'logic_only'), 0) + 1
            )

            pe = ms.get('plain_english', '')
            if pe:
                lines.append(f'\n  Plain English:')
                words = pe.split()
                line  = '    '
                for w in words:
                    if len(line) + len(w) > 70:
                        lines.append(line)
                        line = '    ' + w + ' '
                    else:
                        line += w + ' '
                if line.strip():
                    lines.append(line)

            ep = ms.get('extractable_pattern', '')
            if ep:
                lines.append(f'\n  Extractable pattern:')
                words = ep.split()
                line  = '    '
                for w in words:
                    if len(line) + len(w) > 70:
                        lines.append(line)
                        line = '    ' + w + ' '
                    else:
                        line += w + ' '
                if line.strip():
                    lines.append(line)

            regime_tags = ms.get('regime_tags', [])
            if regime_tags:
                lines.append(f'\n  Regime tags:')
                for tag in regime_tags:
                    lines.append(
                        f'    {tag.get("regime","?"):<22} '
                        f'{tag.get("effectiveness","?"):<12} '
                        f'[{tag.get("source","?")}]'
                    )

            sub = ms.get('in_universe_substitute')
            if sub:
                # Claude sometimes returns a list of substitutes instead of a single dict.
                # Normalise to a list so we can iterate regardless of shape.
                subs = sub if isinstance(sub, list) else [sub]
                for s in subs:
                    if not isinstance(s, dict):
                        lines.append(f'\n  Substitute note: {s}')
                        continue
                    oou_t = s.get('out_of_universe_ticker', '?')
                    subst = s.get('substitute')
                    if subst:
                        lines.append(f'\n  Substitute: {oou_t} → {subst}')
                    else:
                        lines.append(f'\n  No substitute: {oou_t}')
                    reasoning = s.get('reasoning', '')
                    if reasoning:
                        lines.append(f'    {reasoning}')

            params = ms.get('parameters', {})
            if params:
                lines.append(f'\n  Parameters:')
                for k, v in sorted(params.items()):
                    lines.append(f'    {k:<38} {v}')

            if ms.get('role_note'):
                lines.append(f'\n  Role note: {ms["role_note"]}')

        lines.append(f'\n  Recomposability summary:')
        lines.append(f'    full={recomp_counts["full"]}  '
                     f'partial={recomp_counts["partial"]}  '
                     f'logic_only={recomp_counts["logic_only"]}')

    h1('PASS/FAIL CHECKLIST')

    ms_list = list(mini_strategies.values())
    checks = [
        ('≥1 mini-strategy extracted',
         len(ms_list) >= 1),
        ('Round-trip verification passed',
         stats.get('round_trip_verified', False)),
        ('All have role (not unknown/missing)',
         all(ms.get('role') not in ('', None, 'unknown') for ms in ms_list)
         if ms_list else False),
        ('All have plain_english',
         all(ms.get('plain_english', '') != '' for ms in ms_list)
         if ms_list else False),
        ('All have ≥1 regime tag',
         all(len(ms.get('regime_tags', [])) >= 1 for ms in ms_list)
         if ms_list else False),
        ('All have extractable_pattern',
         all(ms.get('extractable_pattern', '') != '' for ms in ms_list)
         if ms_list else False),
        ('Claude parsed successfully',
         claude.get('parse_success', False)),
    ]

    all_pass = True
    for label, result in checks:
        mark = '✓ PASS' if result else '✗ FAIL'
        lines.append(f'  {mark}  {label}')
        if not result:
            all_pass = False

    lines.append('')
    if all_pass:
        lines.append('  ══ ALL CHECKS PASSED ══')
    else:
        lines.append('  ══ ONE OR MORE CHECKS FAILED ══')

    lines.append('\n')
    with open(path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    print(f'  Wrote: {path}')


# ── Overlap comparison ─────────────────────────────────────────────────────────

def compare_registries(reg1_path: Path, reg2_path: Path) -> None:
    """
    Load two registry JSONs and report structural overlaps.

    Overlap is defined as:
      1. Exact match  — identical fingerprint
      2. Role match   — same role classification
      3. Pattern match — same extractable_pattern keywords
    """
    print(f'\nLoading registries for comparison...')

    with open(reg1_path, encoding='utf-8') as f:
        reg1 = json.load(f)
    with open(reg2_path, encoding='utf-8') as f:
        reg2 = json.load(f)

    name1 = reg1.get('symphony', {}).get('name', reg1_path.stem)
    name2 = reg2.get('symphony', {}).get('name', reg2_path.stem)

    ms1 = reg1.get('mini_strategies', {})
    ms2 = reg2.get('mini_strategies', {})

    print(f'  {name1}: {len(ms1)} mini-strategies')
    print(f'  {name2}: {len(ms2)} mini-strategies')

    # ── Exact fingerprint matches ──────────────────────────────────────────────
    fp1 = {ms['fingerprint']: (ms_id, ms) for ms_id, ms in ms1.items()}
    fp2 = {ms['fingerprint']: (ms_id, ms) for ms_id, ms in ms2.items()}
    exact_overlaps = set(fp1.keys()) & set(fp2.keys())

    # ── Role matches ───────────────────────────────────────────────────────────
    roles1 = {}
    for ms_id, ms in ms1.items():
        role = ms.get('role', 'unknown')
        roles1.setdefault(role, []).append((ms_id, ms))

    roles2 = {}
    for ms_id, ms in ms2.items():
        role = ms.get('role', 'unknown')
        roles2.setdefault(role, []).append((ms_id, ms))

    shared_roles = set(roles1.keys()) & set(roles2.keys())

    # ── Parameter overlaps ─────────────────────────────────────────────────────
    def get_key_params(ms):
        """Extract signature parameters for comparison."""
        params = ms.get('parameters', {})
        return {
            k: v for k, v in params.items()
            if 'threshold' in k or 'window' in k
        }

    param_matches = []
    for ms_id1, ms1_item in ms1.items():
        for ms_id2, ms2_item in ms2.items():
            p1 = get_key_params(ms1_item)
            p2 = get_key_params(ms2_item)
            shared = {k: v for k, v in p1.items() if k in p2 and p2[k] == v}
            if len(shared) >= 2:
                param_matches.append({
                    'ms1': (ms_id1, ms1_item['name']),
                    'ms2': (ms_id2, ms2_item['name']),
                    'shared_params': shared,
                })

    # ── Write report ───────────────────────────────────────────────────────────
    lines = []

    def h1(t): lines.append(f'\n{"="*60}\n{t}\n{"="*60}')
    def h2(t): lines.append(f'\n── {t} ──')

    h1(f'OVERLAP REPORT — {datetime.now().strftime("%Y-%m-%d %H:%M")}')
    lines.append(f'Symphony 1: {name1} ({len(ms1)} mini-strategies)')
    lines.append(f'Symphony 2: {name2} ({len(ms2)} mini-strategies)')

    h2('EXACT STRUCTURAL MATCHES (identical fingerprint)')
    if exact_overlaps:
        for fp in exact_overlaps:
            ms_id1, ms1_item = fp1[fp]
            ms_id2, ms2_item = fp2[fp]
            lines.append(f'  {ms_id1} "{ms1_item["name"]}"')
            lines.append(f'    = {ms_id2} "{ms2_item["name"]}"')
            lines.append(f'    Fingerprint: {fp}')
    else:
        lines.append('  None — no structurally identical sub-trees found.')
        lines.append('  (This is expected for symphonies with different authors.)')

    h2('SHARED ROLES')
    for role in sorted(shared_roles):
        c1 = len(roles1.get(role, []))
        c2 = len(roles2.get(role, []))
        lines.append(f'  {role:<22}  {name1}: {c1}  |  {name2}: {c2}')
        # Show names for each
        for _, ms in roles1.get(role, []):
            lines.append(f'    [1] {ms["name"]}  ({ms.get("recomposable","?")})')
        for _, ms in roles2.get(role, []):
            lines.append(f'    [2] {ms["name"]}  ({ms.get("recomposable","?")})')

    h2('PARAMETER MATCHES (≥2 shared key parameters)')
    if param_matches:
        for m in param_matches:
            lines.append(
                f'  [{name1}] {m["ms1"][0]} "{m["ms1"][1]}"'
            )
            lines.append(
                f'  [{name2}] {m["ms2"][0]} "{m["ms2"][1]}"'
            )
            lines.append(f'  Shared params:')
            for k, v in m['shared_params'].items():
                lines.append(f'    {k} = {v}')
            lines.append('')
    else:
        lines.append('  None found.')

    h2('CROSS-STRATEGY PATTERNS (from Claude analysis)')
    csp1 = reg1.get('claude_analysis', {}).get('cross_strategy_patterns', [])
    csp2 = reg2.get('claude_analysis', {}).get('cross_strategy_patterns', [])
    if csp1:
        lines.append(f'  {name1}:')
        for p in csp1:
            lines.append(f'    • {p}')
    if csp2:
        lines.append(f'  {name2}:')
        for p in csp2:
            lines.append(f'    • {p}')

    h1('SYNTHESIS')
    lines.append(f'  Total exact structural overlaps:  {len(exact_overlaps)}')
    lines.append(f'  Total shared role categories:     {len(shared_roles)}')
    lines.append(f'  Total parameter matches:          {len(param_matches)}')

    if len(exact_overlaps) == 0 and len(param_matches) == 0:
        lines.append('')
        lines.append('  These two symphonies appear structurally independent.')
        lines.append('  Role-level overlap shows they share design patterns')
        lines.append('  (crash guards, regime routers) but implement them')
        lines.append('  differently — suggesting complementary KB lessons.')
    elif len(exact_overlaps) > 0:
        lines.append('')
        lines.append('  Exact structural matches found — these sub-trees are')
        lines.append('  confirmed reusable patterns with evidence from')
        lines.append('  multiple symphonies. Promote to patterns.json.')

    lines.append('\n')

    report_path = _PILOT_DIR / 'overlap_report.txt'
    _PILOT_DIR.mkdir(parents=True, exist_ok=True)
    with open(report_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))

    print('\n'.join(lines))
    print(f'\nWrote: {report_path}')


# ── Validation ─────────────────────────────────────────────────────────────────

def validate_output(output: dict) -> bool:
    ms_list = list(output.get('mini_strategies', {}).values())
    stats   = output.get('extraction_stats', {})
    claude  = output.get('claude_analysis', {})

    checks = [
        ('≥1 mini-strategy extracted',   len(ms_list) >= 1),
        ('Round-trip verified',           stats.get('round_trip_verified', False)),
        ('All have role',                 all(ms.get('role') not in ('', None, 'unknown')
                                             for ms in ms_list) if ms_list else False),
        ('All have plain_english',        all(ms.get('plain_english', '') != ''
                                             for ms in ms_list) if ms_list else False),
        ('All have ≥1 regime tag',        all(len(ms.get('regime_tags', [])) >= 1
                                             for ms in ms_list) if ms_list else False),
        ('All have extractable_pattern',  all(ms.get('extractable_pattern', '') != ''
                                             for ms in ms_list) if ms_list else False),
        ('Claude parsed successfully',    claude.get('parse_success', False)),
    ]

    all_pass = True
    for label, result in checks:
        mark = '✓' if result else '✗'
        print(f'    {mark}  {label}')
        if not result:
            all_pass = False
    return all_pass


# ── Mock data ──────────────────────────────────────────────────────────────────

def _mock_composer_json() -> dict:
    return {
        'step': 'root', 'name': 'Mock Symphony', 'rebalance': 'daily',
        'id': 'mock-root', 'children': [{
            'step': 'wt-cash-equal', 'id': 'mock-wt', 'children': [
                {
                    'step': 'if-then-else', 'name': 'SVXY Crash Guard',
                    'id': 'mock-if1', 'lhs_fn': 'max-drawdown',
                    'lhs_val': 'SVXY', 'rhs_val': '10', 'window': 2,
                    'children': [
                        {'step': 'asset', 'ticker': 'BIL', 'id': 'a1', 'children': []},
                        {'step': 'asset', 'ticker': 'SVXY', 'id': 'a2', 'children': []},
                    ]
                },
                {
                    'step': 'if-then-else', 'name': 'SPY Momentum Gate',
                    'id': 'mock-if2', 'lhs_fn': 'cumulative-return',
                    'lhs_val': 'SPY', 'rhs_val': '0', 'window': 20,
                    'children': [
                        {'step': 'asset', 'ticker': 'TQQQ', 'id': 'a3', 'children': []},
                        {'step': 'asset', 'ticker': 'BIL',  'id': 'a4', 'children': []},
                    ]
                },
            ]
        }]
    }


def _mock_claude_output(symphony_id: str) -> dict:
    return {
        'symphony_id':   symphony_id,
        'analyzed_at':   datetime.now(timezone.utc).isoformat(),
        'mini_strategies': [
            {
                'id': 'ms-001', 'role': 'crash_guard', 'role_note': None,
                'plain_english': 'If SVXY 2-day max drawdown exceeds 10%, hold BIL; otherwise hold SVXY.',
                'regime_tags': [
                    {'regime': 'vix_spike',     'effectiveness': 'effective',   'source': 'inferred'},
                    {'regime': 'bear_sustained', 'effectiveness': 'effective',   'source': 'inferred'},
                ],
                'in_universe_substitute': None,
                'recomposable': 'full',
                'extractable_pattern': 'Use max-drawdown(2) > 10% on vol-short asset as crash guard to exit to BIL.',
                'confidence': 0.95,
            },
            {
                'id': 'ms-002', 'role': 'momentum_selector', 'role_note': None,
                'plain_english': 'If SPY 20-day cumulative return is positive, hold TQQQ; otherwise hold BIL.',
                'regime_tags': [
                    {'regime': 'bull_low_vol',   'effectiveness': 'effective',   'source': 'inferred'},
                    {'regime': 'bear_sustained',  'effectiveness': 'ineffective', 'source': 'inferred'},
                ],
                'in_universe_substitute': None,
                'recomposable': 'full',
                'extractable_pattern': 'Use SPY cumulative-return(20) > 0 as a broad market momentum gate before holding 3x leveraged ETF.',
                'confidence': 0.90,
            },
        ],
        'taxonomy_notes': 'DRY RUN — mock output.',
        'cross_strategy_patterns': [
            'BIL used as the universal safe-haven exit in both mini-strategies.',
        ],
    }


# ── Main ───────────────────────────────────────────────────────────────────────

def main() -> None:
    parser = argparse.ArgumentParser(
        description='Generalized symphony mini-strategy extraction pilot',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  Run on Sisyphus:
    python3 pilot_symphony.py \\
      --id qjRIwrAOA1YzFSghM08b \\
      --name "Sisyphus V0.0" \\
      --sharpe 1.92 --cagr 45.8 --maxdd 10.3

  Run on Beta Baller:
    python3 pilot_symphony.py \\
      --id vNP5oYsbpV8tS9USqGEL \\
      --name "Beta Baller" \\
      --sharpe 4.06 --cagr 108.0 --maxdd 5.3

  Compare two registries:
    python3 pilot_symphony.py --compare \\
      --reg1 kb/pilot/fngg_registry.json \\
      --reg2 kb/pilot/sisyphus_registry.json
        """
    )

    # Symphony selection
    parser.add_argument('--id',     type=str, help='Composer symphony ID')
    parser.add_argument('--name',   type=str, help='Symphony name (for output files)')
    parser.add_argument('--sharpe', type=float, default=0.0)
    parser.add_argument('--cagr',   type=float, default=0.0)
    parser.add_argument('--maxdd',  type=float, default=0.0)

    # Modes
    parser.add_argument('--from-registry', type=str, default=None,
                        metavar='PATH',
                        help='Skip fetch+analyzer+Claude — regenerate review from existing registry JSON')
    parser.add_argument('--dry-run', action='store_true',
                        help='Skip API calls — use mock data')
    parser.add_argument('--compare', action='store_true',
                        help='Compare two existing registries')
    parser.add_argument('--reg1', type=str, help='Path to first registry JSON')
    parser.add_argument('--reg2', type=str, help='Path to second registry JSON')

    args = parser.parse_args()

    # ── Compare mode ──────────────────────────────────────────────────────────
    if args.compare:
        if not args.reg1 or not args.reg2:
            print('ERROR: --compare requires --reg1 and --reg2')
            sys.exit(1)
        reg1_path = Path(args.reg1)
        reg2_path = Path(args.reg2)
        if not reg1_path.is_absolute():
            reg1_path = _LEARNING_ROOT / reg1_path
        if not reg2_path.is_absolute():
            reg2_path = _LEARNING_ROOT / reg2_path
        compare_registries(reg1_path, reg2_path)
        return

    # ── From-registry shortcut: regenerate review without re-running Claude ──────
    if args.from_registry:
        reg_path = Path(args.from_registry)
        if not reg_path.is_absolute():
            reg_path = _LEARNING_ROOT / reg_path
        if not reg_path.exists():
            print(f'ERROR: Registry not found: {reg_path}')
            sys.exit(1)
        print(f'Loading existing registry: {reg_path}')
        with open(reg_path, encoding='utf-8') as f:
            output = json.load(f)
        sym   = output.get('symphony', {})
        slug  = re.sub(r'[^a-z0-9]+', '_', sym.get('name', 'unknown').lower()).strip('_')
        review_path = _PILOT_DIR / f'{slug}_review.txt'
        print(f'Regenerating review: {review_path}')
        write_review_txt(output, review_path)
        print('\nPASS/FAIL VALIDATION:')
        validate_output(output)
        print(f'\nDone. Review: {review_path}')
        return

    # ── Extraction mode ───────────────────────────────────────────────────────
    if not args.id or not args.name:
        parser.print_help()
        print('\nERROR: --id and --name are required for extraction mode.')
        sys.exit(1)

    symphony_id   = args.id
    symphony_name = args.name
    perf          = {'sharpe': args.sharpe, 'cagr': args.cagr, 'max_dd': args.maxdd}
    slug          = re.sub(r'[^a-z0-9]+', '_', symphony_name.lower()).strip('_')
    dry_run       = args.dry_run

    if dry_run:
        print('DRY RUN MODE — no API calls\n')

    print(f'Symphony: {symphony_name} ({symphony_id})')
    print(f'Output slug: {slug}')

    # Step 1
    print('\nSTEP 1: Fetch symphony JSON')
    if dry_run:
        composer_json = _mock_composer_json()
        print('  Using mock JSON')
    else:
        composer_json = fetch_symphony_json(symphony_id)
        if not composer_json:
            print('\nFATAL: Could not fetch symphony JSON.')
            print('Check: systemctl --user status composer-backtest')
            sys.exit(1)

    # Step 2
    print('\nSTEP 2: Run symphony_analyzer')
    try:
        registry, compressed_rep = run_analyzer(composer_json, symphony_id, symphony_name)
    except ImportError as e:
        print(f'\nFATAL: {e}')
        sys.exit(1)

    n_ms = registry['stats']['total_mini_strategies']

    # Step 3
    print('\nSTEP 3: Claude classification')
    if dry_run or n_ms == 0:
        if dry_run:
            print('  Using mock Claude output')
        else:
            print('  No mini-strategies — skipping Claude call')
        claude_output = _mock_claude_output(symphony_id) if dry_run else None
    else:
        try:
            auth_path = (
                Path.home() / '.openclaw' / 'agents' /
                'security' / 'agent' / 'auth-profiles.json'
            )
            with open(auth_path) as f:
                auth = json.load(f)
            anthropic_key = auth['profiles']['anthropic:default']['key']
        except Exception as e:
            print(f'  ERROR loading Anthropic key: {e}')
            sys.exit(1)

        prompt_result = build_claude_prompt(registry, symphony_id, symphony_name, perf)

        # build_claude_prompt returns either a single string or a list of strings
        # (batched). Handle both cases.
        if isinstance(prompt_result, list):
            # Multiple batches — call Claude once per batch, merge results
            print(f'  Running {len(prompt_result)} batched Claude calls...')
            all_ms_annotations = []
            taxonomy_notes_list = []
            csp_list = []
            parse_ok = True

            for i, batch_prompt in enumerate(prompt_result):
                batch_result = call_claude(
                    batch_prompt, anthropic_key,
                    label=f'{symphony_name} batch {i+1}/{len(prompt_result)}'
                )
                if batch_result is None:
                    print(f'  WARNING: Batch {i+1} failed to parse')
                    parse_ok = False
                    continue
                all_ms_annotations.extend(
                    batch_result.get('mini_strategies', [])
                )
                tn = batch_result.get('taxonomy_notes', '')
                if tn:
                    taxonomy_notes_list.append(f'[batch {i+1}] {tn}')
                csp_list.extend(batch_result.get('cross_strategy_patterns', []))
                time.sleep(0.5)  # brief pause between batch calls

            # Merge into a single claude_output dict
            claude_output = {
                'symphony_id':             symphony_id,
                'analyzed_at':             datetime.now(timezone.utc).isoformat(),
                'mini_strategies':         all_ms_annotations,
                'taxonomy_notes':          ' | '.join(taxonomy_notes_list),
                'cross_strategy_patterns': csp_list,
                '_batched':                True,
                '_parse_success':          parse_ok,
            } if (all_ms_annotations or parse_ok) else None

        else:
            # Single prompt
            claude_output = call_claude(prompt_result, anthropic_key, label=symphony_name)

    # Step 4
    print('\nSTEP 4: Write output files')
    output = build_registry_output(
        registry, compressed_rep, claude_output,
        composer_json, symphony_id, symphony_name, perf,
    )

    registry_path = _PILOT_DIR / f'{slug}_registry.json'
    review_path   = _PILOT_DIR / f'{slug}_review.txt'

    write_registry_json(output, registry_path)
    write_review_txt(output, review_path)

    print('\nPASS/FAIL VALIDATION:')
    all_pass = validate_output(output)

    print(f'\n{"="*60}')
    if all_pass:
        print(f'RESULT: ALL CHECKS PASSED')
        print(f'Review: {review_path}')
        print(f'\nNext — read the review file:')
        print(f'  cat {review_path}')
        print(f'\nThen compare with FNGG:')
        print(
            f'  python3 src/pilot_symphony.py --compare \\\n'
            f'    --reg1 kb/pilot/fngg_registry.json \\\n'
            f'    --reg2 kb/pilot/{slug}_registry.json'
        )
    else:
        print('RESULT: ONE OR MORE CHECKS FAILED')
        print(f'Review: {review_path}')
    print('='*60)


if __name__ == '__main__':
    main()
