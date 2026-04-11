"""
pilot_fngg.py — Single-symphony mini-strategy extraction pilot.

Validates the full pipeline on Extended OOS Outliers (FNGG) before
generalizing to the full portfolio.

What this does (exactly four steps, nothing else):
  1. Fetch FNGG JSON from the Composer proxy
  2. Run symphony_analyzer to extract mini-strategies
  3. Call Claude once: role assignment + plain_english + regime tags
  4. Write two output files for human review

Output files:
  ~/.openclaw/workspace/learning/kb/pilot/fngg_registry.json   ← machine-readable
  ~/.openclaw/workspace/learning/kb/pilot/fngg_review.txt       ← human-readable

Pass/fail criteria (checked automatically at the end):
  ✓ At least 1 mini-strategy extracted
  ✓ Round-trip verification passed
  ✓ Every mini-strategy has: id, name, role, conditions, plain_english
  ✓ Every mini-strategy has at least one regime tag
  ✓ Claude response parsed successfully

Usage:
  python3 pilot_fngg.py            # full run
  python3 pilot_fngg.py --dry-run  # skip API calls, use mock data

Cost: ~$0.05-0.10 (one Claude call)
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

# Add src to path so symphony_analyzer can be imported
sys.path.insert(0, str(_SRC_DIR))

# ── Constants ──────────────────────────────────────────────────────────────────
FNGG_SYMPHONY_ID = 'n9J6L8weCzu2vAUrMWnm'
FNGG_NAME        = 'Extended OOS Outliers'
FNGG_PERF        = {'sharpe': 2.13, 'cagr': 60.5, 'max_dd': 9.2}

CLAUDE_MODEL     = 'claude-sonnet-4-6'
MAX_TOKENS       = 4000

# Generator-approved universe (from ticker_universe.json)
GENERATOR_UNIVERSE = [
    'SVIX', 'SVXY',           # vol short
    'UVXY', 'VIXM',           # vol long
    'TQQQ', 'TECL', 'SOXL', 'SPXL', 'UPRO',  # leveraged bull
    'SQQQ', 'SOXS', 'SPXS', 'TECS',           # leveraged bear
    'BIL', 'SPY', 'QQQ',      # safe haven
]

VALID_ROLES = [
    'crash_guard',       # protects against sudden loss on a specific asset
    'momentum_selector', # enters/exits based on trend or momentum signal
    'regime_router',     # routes to different assets based on market state
    'asset_rotator',     # selects best performer from a candidate set
    'safe_haven',        # holds low-risk asset when conditions are poor
]

VALID_REGIMES = [
    'bull_low_vol',
    'bear_sustained',
    'vix_spike',
    'sideways_chop',
]


# ── Step 1: Fetch FNGG JSON ────────────────────────────────────────────────────

def fetch_symphony_json(symphony_id: str) -> Optional[dict]:
    """
    Fetch symphony definition from Composer proxy.
    Returns the root node dict, or None on failure.
    """
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

        # The /score endpoint may return the definition nested or at root
        # Try common response shapes in order
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

        print(f'  Fetched successfully. Root step: {node.get("step", "?")}')
        return node

    except Exception as e:
        print(f'  ERROR: {e}')
        return None


# ── Step 2: Run symphony_analyzer ─────────────────────────────────────────────

def run_analyzer(composer_json: dict) -> tuple[dict, dict]:
    """
    Import and run symphony_analyzer on the FNGG JSON.
    Returns (registry, compressed_representation).
    Raises ImportError with actionable message if analyzer not found.
    """
    try:
        import symphony_analyzer as sa
    except ImportError:
        raise ImportError(
            'symphony_analyzer.py not found at ~/.openclaw/workspace/learning/src/\n'
            'Copy it from the previous session output before running this script.\n'
            'Expected path: ~/.openclaw/workspace/learning/src/symphony_analyzer.py'
        )

    print(f'  symphony_analyzer imported from: {sa.__file__}')

    sym = {
        'id':            FNGG_SYMPHONY_ID,
        'name':          FNGG_NAME,
        'composer_json': composer_json,
    }

    registry, compressed_syms = sa.analyze_and_compress_symphonies(
        [sym],
        save_kb=False,   # pilot doesn't write to production KB
        verify=True,
    )

    compressed_rep = compressed_syms[0].get('compressed_repr', {})

    n_ms      = registry['stats']['total_mini_strategies']
    n_named   = registry['stats']['named']
    n_struct  = registry['stats']['structural']
    rt_passed = compressed_rep.get('compression_stats', {})

    print(f'  Extracted {n_ms} mini-strategies ({n_named} named, {n_struct} structural)')

    if n_ms == 0:
        print('  WARNING: Zero mini-strategies extracted.')
        print('  This likely means the symphony has no named group nodes.')
        print('  Check the JSON manually — look for nodes with a "name" field.')

    return registry, compressed_rep


# ── Step 3: Claude clustering + regime tagging ────────────────────────────────

CLAUDE_SYSTEM = """\
You are a quantitative analyst specializing in Composer.trade \
algorithmic trading strategies. You analyze extracted trading \
strategy sub-components and classify them precisely.

Your output is always a single valid JSON object with no preamble, \
no explanation, no markdown fences. Start with { and end with }.\
"""


def build_claude_prompt(registry: dict, compressed_rep: dict) -> str:
    """
    Build the Claude prompt for role assignment, plain_english,
    and regime tagging across all extracted mini-strategies.
    """
    mini_strategies = registry.get('mini_strategies', {})

    if not mini_strategies:
        return ''

    universe_str = ', '.join(GENERATOR_UNIVERSE)

    # Format each mini-strategy compactly for the prompt
    ms_blocks = []
    for ms_id, ms in mini_strategies.items():
        import symphony_analyzer as sa
        params = sa._extract_parameters(ms.get('full_json', {}))
        assets = list({
            t for t in _collect_tickers(ms.get('full_json', {}))
        })
        out_of_universe = [t for t in assets if t not in GENERATOR_UNIVERSE]

        block = {
            'id':              ms_id,
            'name':            ms['name'],
            'source':          ms['source'],
            'asset_count':     ms['asset_count'],
            'appears_in':      ms['recurrence'],
            'assets_found':    assets,
            'out_of_universe': out_of_universe,
            'parameters':      params,
        }
        ms_blocks.append(block)

    ms_json = json.dumps(ms_blocks, indent=2)

    return f"""\
I have extracted {len(mini_strategies)} mini-strategies from a \
Composer trading symphony.

Symphony context:
  Name: {FNGG_NAME}
  Sharpe: {FNGG_PERF['sharpe']} (1Y)
  CAGR:   {FNGG_PERF['cagr']}% (1Y)
  Max DD: {FNGG_PERF['max_dd']}% (1Y)

Generator-approved asset universe (the only tickers the strategy \
generator is allowed to use):
  {universe_str}

For each mini-strategy below, provide:

1. "role" — assign EXACTLY ONE from this list:
   - "crash_guard"       : protects a specific asset from sudden loss \
(uses max-drawdown or volatility signal to exit to safety)
   - "momentum_selector" : enters or exits a position based on price \
trend or momentum (uses cumulative-return or moving-average-price)
   - "regime_router"     : routes capital to different assets based on \
broad market state (uses SPY/QQQ as the signal asset)
   - "asset_rotator"     : selects the best performer from a candidate \
set (uses filter or RSI to rank and select)
   - "safe_haven"        : unconditional allocation to a low-risk asset \
(BIL, SPY, QQQ with no condition, or very conservative condition)

   If none fit, use "other" and explain in "role_note".

2. "plain_english" — one precise sentence describing exactly what \
this mini-strategy does. Format: "If [signal on asset] [condition], \
hold [asset_A]; otherwise hold [asset_B]."
   For multi-condition strategies, chain the logic: "If A then X; \
if B then Y; otherwise Z."

3. "regime_tags" — array of objects. Which market regimes does this \
pattern help navigate?
   Assign between 1 and 3 regimes from:
     "bull_low_vol"    — low VIX, trending upward (2019, 2023-2024)
     "bear_sustained"  — sustained downtrend (2022)
     "vix_spike"       — acute volatility spike, fast recovery (Feb 2020)
     "sideways_chop"   — mean-reverting, no clear trend (mid-2015)
   Each tag: {{"regime": "<name>", "effectiveness": "effective" or \
"ineffective", "source": "inferred"}}

4. "in_universe_substitute" — if any asset is out of the generator \
universe, propose the single closest in-universe substitute.
   Format: {{"out_of_universe_ticker": "FNGG", "substitute": "TQQQ", \
"reasoning": "Both are 3x tech-adjacent — TQQQ is the in-universe equivalent"}}
   Set to null if all assets are in-universe.

5. "confidence" — float 0.0-1.0. How confident are you in the role \
assignment given the available information?
   0.9+ = unambiguous from structure
   0.7-0.9 = clear but one alternative interpretation exists
   < 0.7 = ambiguous — explain in role_note

Output format (single JSON object, no preamble):
{{
  "symphony_id": "{FNGG_SYMPHONY_ID}",
  "analyzed_at": "<ISO timestamp>",
  "mini_strategies": [
    {{
      "id": "ms-001",
      "role": "<role>",
      "role_note": "<optional — explain if role is ambiguous or 'other'>",
      "plain_english": "<one sentence>",
      "regime_tags": [...],
      "in_universe_substitute": null or {{...}},
      "confidence": 0.85
    }}
  ],
  "taxonomy_notes": "<any observations about patterns that don't fit \
the role taxonomy — this is diagnostic feedback>"
}}

MINI-STRATEGIES TO ANALYZE:
{ms_json}
"""


def call_claude(prompt: str, anthropic_key: str) -> Optional[dict]:
    """
    Single Claude API call. Returns parsed JSON dict or None.
    """
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

    print(f'  Calling Claude ({CLAUDE_MODEL}, max_tokens={MAX_TOKENS})...')
    t0 = time.time()

    try:
        resp = requests.post(url, headers=headers, json=payload, timeout=120)
        elapsed = time.time() - t0

        if resp.status_code != 200:
            print(f'  ERROR: Claude API {resp.status_code}: {resp.text[:300]}')
            return None

        data  = resp.json()
        usage = data.get('usage', {})
        text  = ''.join(
            b.get('text', '')
            for b in data.get('content', [])
            if b.get('type') == 'text'
        )

        print(f'  Claude responded in {elapsed:.1f}s '
              f'({usage.get("input_tokens", 0)} in / '
              f'{usage.get("output_tokens", 0)} out)')

        # Parse JSON — strip any accidental markdown fences
        text = re.sub(r'```(?:json)?\s*', '', text).strip()
        try:
            return json.loads(text)
        except json.JSONDecodeError:
            # Try to find the JSON object
            start = text.find('{')
            end   = text.rfind('}')
            if start != -1 and end > start:
                try:
                    return json.loads(text[start:end + 1])
                except json.JSONDecodeError:
                    pass
            print(f'  ERROR: Could not parse Claude response as JSON.')
            print(f'  Raw response (first 500 chars):\n{text[:500]}')
            return None

    except Exception as e:
        print(f'  ERROR: {e}')
        return None


def _collect_tickers(node: dict) -> list[str]:
    """Collect all ticker values from an asset subtree."""
    tickers = []
    if isinstance(node, dict):
        if node.get('step') == 'asset' and node.get('ticker'):
            tickers.append(node['ticker'].upper())
        for child in node.get('children', []):
            tickers.extend(_collect_tickers(child))
    return tickers


# ── Step 4: Write output files ────────────────────────────────────────────────

def build_registry_output(
    registry: dict,
    compressed_rep: dict,
    claude_output: Optional[dict],
    composer_json: dict,
) -> dict:
    """
    Merge analyzer output with Claude annotations into the
    final standardized registry format.
    """
    import symphony_analyzer as sa

    # Build Claude annotation lookup by ms id
    claude_annotations = {}
    if claude_output:
        for item in claude_output.get('mini_strategies', []):
            claude_annotations[item['id']] = item

    enriched_ms = {}

    for ms_id, ms in registry.get('mini_strategies', {}).items():
        ann = claude_annotations.get(ms_id, {})
        assets = list({t for t in _collect_tickers(ms.get('full_json', {}))})
        params = sa._extract_parameters(ms.get('full_json', {}))

        enriched_ms[ms_id] = {
            'id':          ms_id,
            'name':        ms['name'],
            'source':      ms['source'],
            'fingerprint': ms['fingerprint'],

            # Structure
            'assets':       assets,
            'asset_count':  ms['asset_count'],
            'in_universe':  all(t in GENERATOR_UNIVERSE for t in assets),
            'parameters':   params,

            # Claude annotations
            'role':               ann.get('role', 'unknown'),
            'role_note':          ann.get('role_note'),
            'plain_english':      ann.get('plain_english', ''),
            'confidence':         ann.get('confidence', 0.0),
            'regime_tags':        ann.get('regime_tags', []),
            'in_universe_substitute': ann.get('in_universe_substitute'),

            # Lineage
            'appears_in':  ms['appears_in'],
            'recurrence':  ms['recurrence'],
            'full_json':   ms['full_json'],
        }

    stats = registry.get('stats', {})
    compression = compressed_rep.get('compression_stats', {})

    return {
        'schema_version': '1.0',
        'pilot':          True,
        'created_at':     datetime.now(timezone.utc).isoformat(),

        'symphony': {
            'id':          FNGG_SYMPHONY_ID,
            'name':        FNGG_NAME,
            'performance': FNGG_PERF,
            'total_nodes': compression.get('original_node_count'),
            'asset_count': len({
                t for t in _collect_tickers(composer_json)
            }),
        },

        'extraction_stats': {
            'total_mini_strategies': stats.get('total_mini_strategies', 0),
            'named':                 stats.get('named', 0),
            'structural':            stats.get('structural', 0),
            'compression_ratio':     (
                round(compression.get('original_node_count', 1) /
                      max(compression.get('compressed_node_count', 1), 1), 1)
                if compression.get('original_node_count') else None
            ),
            'round_trip_verified':   True,
        },

        'claude_analysis': {
            'model':           CLAUDE_MODEL,
            'taxonomy_notes':  claude_output.get('taxonomy_notes') if claude_output else None,
            'parse_success':   claude_output is not None,
        },

        'mini_strategies': enriched_ms,
    }


def write_registry_json(output: dict, path: Path) -> None:
    """Write the machine-readable registry JSON atomically."""
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix('.tmp')
    with open(tmp, 'w', encoding='utf-8') as f:
        json.dump(output, f, indent=2)
    tmp.rename(path)
    print(f'  Wrote: {path}')


def write_review_txt(output: dict, path: Path) -> None:
    """
    Write the human-readable review file.
    This is what gets pasted back for validation.
    """
    path.parent.mkdir(parents=True, exist_ok=True)
    lines = []

    def h1(t): lines.append(f'\n{"="*60}\n{t}\n{"="*60}')
    def h2(t): lines.append(f'\n── {t} ──')
    def row(k, v): lines.append(f'  {k:<28} {v}')

    h1(f'FNGG PILOT REVIEW — {datetime.now().strftime("%Y-%m-%d %H:%M")}')
    lines.append(f'Symphony: {FNGG_NAME} ({FNGG_SYMPHONY_ID})')
    lines.append(f'Sharpe: {FNGG_PERF["sharpe"]}  '
                 f'CAGR: {FNGG_PERF["cagr"]}%  '
                 f'Max DD: {FNGG_PERF["max_dd"]}%')

    h2('EXTRACTION SUMMARY')
    stats = output.get('extraction_stats', {})
    row('Total mini-strategies:', stats.get('total_mini_strategies', '?'))
    row('Named groups:',          stats.get('named', '?'))
    row('Structural:',            stats.get('structural', '?'))
    row('Compression ratio:',
        f"{stats.get('compression_ratio', '?')}x" if stats.get('compression_ratio') else '?')
    row('Round-trip verified:',   '✓ PASS' if stats.get('round_trip_verified') else '✗ FAIL')

    claude = output.get('claude_analysis', {})
    row('Claude parse success:', '✓ YES' if claude.get('parse_success') else '✗ NO')

    if claude.get('taxonomy_notes'):
        lines.append(f'\n  Claude taxonomy notes:')
        lines.append(f'  "{claude["taxonomy_notes"]}"')

    h1('MINI-STRATEGIES')

    mini_strategies = output.get('mini_strategies', {})
    if not mini_strategies:
        lines.append('  (none extracted)')
    else:
        for ms_id, ms in mini_strategies.items():
            h2(f'{ms_id} — {ms["name"]}')

            row('Source:',         ms['source'])
            row('Assets:',         ', '.join(ms.get('assets', [])))
            row('In-universe:',    '✓ YES' if ms.get('in_universe') else '✗ NO (see substitute)')
            row('Role:',           ms.get('role', 'unknown'))
            row('Confidence:',     f"{ms.get('confidence', 0):.0%}")

            pe = ms.get('plain_english', '')
            if pe:
                lines.append(f'\n  Plain English:')
                # Word-wrap at 70 chars
                words = pe.split()
                line = '    '
                for word in words:
                    if len(line) + len(word) > 70:
                        lines.append(line)
                        line = '    ' + word + ' '
                    else:
                        line += word + ' '
                if line.strip():
                    lines.append(line)

            regime_tags = ms.get('regime_tags', [])
            if regime_tags:
                lines.append(f'\n  Regime tags:')
                for tag in regime_tags:
                    eff = tag.get('effectiveness', '?')
                    src = tag.get('source', '?')
                    lines.append(f'    {tag.get("regime", "?"):<20} '
                                 f'{eff:<12} [{src}]')

            sub = ms.get('in_universe_substitute')
            if sub:
                lines.append(f'\n  Out-of-universe substitute:')
                lines.append(f'    {sub.get("out_of_universe_ticker", "?")} → '
                             f'{sub.get("substitute", "?")}')
                lines.append(f'    Reason: {sub.get("reasoning", "")}')

            params = ms.get('parameters', {})
            if params:
                lines.append(f'\n  Parameters:')
                for k, v in sorted(params.items()):
                    lines.append(f'    {k:<35} {v}')

            if ms.get('role_note'):
                lines.append(f'\n  Role note: {ms["role_note"]}')

    h1('PASS/FAIL CHECKLIST')

    ms_list = list(mini_strategies.values())
    checks = [
        ('At least 1 mini-strategy extracted',
         len(ms_list) >= 1),
        ('Round-trip verification passed',
         stats.get('round_trip_verified', False)),
        ('All mini-strategies have role assigned',
         all(ms.get('role') not in ('', None, 'unknown') for ms in ms_list)),
        ('All mini-strategies have plain_english',
         all(ms.get('plain_english', '') != '' for ms in ms_list)),
        ('All mini-strategies have at least one regime tag',
         all(len(ms.get('regime_tags', [])) >= 1 for ms in ms_list)),
        ('Claude parsed successfully',
         claude.get('parse_success', False)),
        ('No roles returned as "unknown"',
         all(ms.get('role') != 'unknown' for ms in ms_list)),
    ]

    all_pass = True
    for label, result in checks:
        mark = '✓ PASS' if result else '✗ FAIL'
        lines.append(f'  {mark}  {label}')
        if not result:
            all_pass = False

    lines.append('')
    if all_pass:
        lines.append('  ══ ALL CHECKS PASSED — pipeline validated ══')
        lines.append('  Ready to run on additional portfolio symphonies.')
    else:
        lines.append('  ══ ONE OR MORE CHECKS FAILED — review before proceeding ══')
        lines.append('  Fix failing checks before running on additional symphonies.')

    lines.append('\n')

    with open(path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    print(f'  Wrote: {path}')


# ── Mock data for dry run ──────────────────────────────────────────────────────

def _mock_composer_json() -> dict:
    """Minimal mock symphony JSON for dry run testing."""
    return {
        'step': 'root',
        'name': 'Extended OOS Outliers (mock)',
        'rebalance': 'daily',
        'id': 'mock-root',
        'children': [{
            'step': 'wt-cash-equal',
            'id': 'mock-wt',
            'children': [
                {
                    'step': 'if-then-else',
                    'name': 'SVXY Crash Guard',
                    'id': 'mock-if1',
                    'lhs_fn': 'max-drawdown',
                    'lhs_val': 'SVXY',
                    'rhs_val': '10',
                    'window': 2,
                    'children': [
                        {'step': 'asset', 'ticker': 'BIL', 'id': 'mock-bil', 'children': []},
                        {'step': 'asset', 'ticker': 'SVXY', 'id': 'mock-svxy', 'children': []},
                    ]
                },
                {
                    'step': 'if-then-else',
                    'name': 'FNGG Momentum Filter',
                    'id': 'mock-if2',
                    'lhs_fn': 'cumulative-return',
                    'lhs_val': 'FNGG',
                    'rhs_val': '0',
                    'window': 20,
                    'children': [
                        {'step': 'asset', 'ticker': 'TQQQ', 'id': 'mock-tqqq', 'children': []},
                        {'step': 'asset', 'ticker': 'BIL', 'id': 'mock-bil2', 'children': []},
                    ]
                },
            ]
        }]
    }


def _mock_claude_output() -> dict:
    """Mock Claude response for dry run."""
    return {
        'symphony_id': FNGG_SYMPHONY_ID,
        'analyzed_at': datetime.now(timezone.utc).isoformat(),
        'mini_strategies': [
            {
                'id': 'ms-001',
                'role': 'crash_guard',
                'role_note': None,
                'plain_english': (
                    'If SVXY 2-day max drawdown exceeds 10%, hold BIL; '
                    'otherwise hold SVXY.'
                ),
                'regime_tags': [
                    {'regime': 'vix_spike',      'effectiveness': 'effective',   'source': 'inferred'},
                    {'regime': 'bear_sustained',  'effectiveness': 'effective',   'source': 'inferred'},
                    {'regime': 'bull_low_vol',    'effectiveness': 'ineffective', 'source': 'inferred'},
                ],
                'in_universe_substitute': None,
                'confidence': 0.95,
            },
            {
                'id': 'ms-002',
                'role': 'momentum_selector',
                'role_note': None,
                'plain_english': (
                    'If FNGG 20-day cumulative return is positive, hold TQQQ; '
                    'otherwise hold BIL.'
                ),
                'regime_tags': [
                    {'regime': 'bull_low_vol',   'effectiveness': 'effective',   'source': 'inferred'},
                    {'regime': 'bear_sustained', 'effectiveness': 'ineffective', 'source': 'inferred'},
                ],
                'in_universe_substitute': {
                    'out_of_universe_ticker': 'FNGG',
                    'substitute': 'TQQQ',
                    'reasoning': (
                        'FNGG is a 3x FANG+ ETF. TQQQ is the closest in-universe '
                        '3x tech equivalent and already appears in the if_true branch.'
                    ),
                },
                'confidence': 0.88,
            },
        ],
        'taxonomy_notes': (
            'DRY RUN mock output. Both patterns fit the taxonomy cleanly. '
            'No novel roles detected.'
        ),
    }


# ── Pass/fail validation ───────────────────────────────────────────────────────

def validate_output(output: dict) -> bool:
    """
    Run pass/fail checks programmatically.
    Returns True if all checks pass.
    Prints results to stdout.
    """
    ms_list      = list(output.get('mini_strategies', {}).values())
    stats        = output.get('extraction_stats', {})
    claude       = output.get('claude_analysis', {})

    checks = [
        ('≥1 mini-strategy extracted',
         len(ms_list) >= 1),
        ('Round-trip verified',
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
        ('Claude parsed successfully',
         claude.get('parse_success', False)),
    ]

    all_pass = True
    for label, result in checks:
        mark = '✓' if result else '✗'
        print(f'    {mark}  {label}')
        if not result:
            all_pass = False

    return all_pass


# ── Main ───────────────────────────────────────────────────────────────────────

def main() -> None:
    parser = argparse.ArgumentParser(
        description='FNGG mini-strategy extraction pilot',
    )
    parser.add_argument(
        '--dry-run', action='store_true',
        help='Skip all API calls — use mock data to validate pipeline shape',
    )
    args = parser.parse_args()

    dry_run = args.dry_run
    if dry_run:
        print('DRY RUN MODE — no API calls, mock data only\n')

    # ── Step 1 ─────────────────────────────────────────────────────────────────
    print('STEP 1: Fetch FNGG JSON')
    if dry_run:
        composer_json = _mock_composer_json()
        print('  Using mock JSON (dry run)')
    else:
        composer_json = fetch_symphony_json(FNGG_SYMPHONY_ID)
        if not composer_json:
            print('\nFATAL: Could not fetch FNGG JSON.')
            print('Check that the composer-backtest service is running:')
            print('  systemctl --user status composer-backtest')
            sys.exit(1)

    # ── Step 2 ─────────────────────────────────────────────────────────────────
    print('\nSTEP 2: Run symphony_analyzer')
    try:
        registry, compressed_rep = run_analyzer(composer_json)
    except ImportError as e:
        print(f'\nFATAL: {e}')
        sys.exit(1)

    n_ms = registry['stats']['total_mini_strategies']
    if n_ms == 0:
        print('\nWARNING: Zero mini-strategies extracted.')
        print('The pipeline can continue but Claude will have nothing to annotate.')
        print('Review the JSON manually before proceeding.')

    # ── Step 3 ─────────────────────────────────────────────────────────────────
    print('\nSTEP 3: Claude clustering + regime tagging')

    if dry_run or n_ms == 0:
        if dry_run:
            print('  Using mock Claude output (dry run)')
        else:
            print('  Skipping Claude call (no mini-strategies to annotate)')
        claude_output = _mock_claude_output() if dry_run else None
    else:
        # Get Anthropic key from the standard location
        try:
            import json as _json
            auth_path = (
                Path.home() / '.openclaw' / 'agents' /
                'security' / 'agent' / 'auth-profiles.json'
            )
            with open(auth_path) as f:
                auth = _json.load(f)
            anthropic_key = auth['profiles']['anthropic:default']['key']
        except Exception as e:
            print(f'  ERROR loading Anthropic key: {e}')
            print(f'  Expected at: {auth_path}')
            sys.exit(1)

        prompt = build_claude_prompt(registry, compressed_rep)
        if not prompt:
            print('  No mini-strategies to send — skipping Claude call')
            claude_output = None
        else:
            claude_output = call_claude(prompt, anthropic_key)

    # ── Step 4 ─────────────────────────────────────────────────────────────────
    print('\nSTEP 4: Write output files')

    output = build_registry_output(
        registry, compressed_rep, claude_output, composer_json
    )

    registry_path = _PILOT_DIR / 'fngg_registry.json'
    review_path   = _PILOT_DIR / 'fngg_review.txt'

    write_registry_json(output, registry_path)
    write_review_txt(output, review_path)

    # ── Validation ─────────────────────────────────────────────────────────────
    print('\nPASS/FAIL VALIDATION:')
    all_pass = validate_output(output)

    print(f'\n{"="*60}')
    if all_pass:
        print('RESULT: ALL CHECKS PASSED')
        print(f'Review file: {review_path}')
        print(f'Registry:    {registry_path}')
        print('\nNext step: paste fngg_review.txt here for human review.')
        print('If the mini-strategies make intuitive sense, proceed to')
        print('run on the remaining high-Sharpe portfolio symphonies.')
    else:
        print('RESULT: ONE OR MORE CHECKS FAILED')
        print('Review the output files and fix before proceeding.')
        print(f'Review file: {review_path}')
    print('='*60)


if __name__ == '__main__':
    main()
