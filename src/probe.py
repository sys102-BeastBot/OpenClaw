"""
probe.py — Disposable diagnostic for the Composer local proxy.

Purpose: answer 5 questions before building community_scanner.py.

  1. Does GET /symphonies/{id}/score work through localhost:8080?
     What does it return — JSON, EDN, something else?
  2. If /score doesn't work, does GET /symphonies/{id} work as fallback?
  3. What's in the backtest stats response — specifically, are
     pearson_r, r_squared, alpha, beta present, and where?
  4. What's the raw payload size of a fetched symphony?
  5. Does the fetched symphony's node count match what we expect
     from on-disk inspection of Sisyphus (1,725 nodes)?

Run:    python3 probe.py
Output: stdout only, no files written
Crash:  intentional — if something is wrong, you want the traceback
"""
import json
from pathlib import Path
import requests

# ── Config (mirrors run_stress_tests.py) ──────────────────────────────────────
HOME    = Path.home()
CREDS   = json.load(open(HOME / '.openclaw/composer-credentials.json'))
KEY_ID  = CREDS.get('composer_api_key_id') or CREDS.get('keyId')
SECRET  = CREDS.get('composer_api_secret') or CREDS.get('secret')
HEADERS = {
    'x-api-key-id':  KEY_ID,
    'authorization': f'Bearer {SECRET}',
}
BASE = 'http://localhost:8080/composer/api/v0.1'

# Sisyphus — known to exist, known node count from disk inspection
SYM_ID   = 'qjRIwrAOA1YzFSghM08b'
SYM_NAME = 'Sisyphus'
EXPECTED_NODES = 1725  # from on-disk inspection of Sisyphus_V0_0__291_7_2022___Any_All_.txt


# ── Helpers ───────────────────────────────────────────────────────────────────

def banner(text: str) -> None:
    print()
    print('=' * 70)
    print(text)
    print('=' * 70)


def count_nodes(node, counts=None):
    """Walk a Composer JSON tree, count by step type."""
    if counts is None:
        counts = {}
    if not isinstance(node, dict):
        return counts
    step = node.get('step', '?')
    counts[step] = counts.get(step, 0) + 1
    for child in node.get('children', []) or []:
        count_nodes(child, counts)
    return counts


def list_keys_recursive(obj, prefix='', max_depth=4, depth=0):
    """Walk a dict, listing every key path with a truncated value preview."""
    if depth >= max_depth:
        print(f'  {prefix}... [max depth reached]')
        return
    if isinstance(obj, dict):
        for k, v in obj.items():
            path = f'{prefix}.{k}' if prefix else k
            if isinstance(v, dict):
                print(f'  {path}: dict[{len(v)}]')
                list_keys_recursive(v, path, max_depth, depth + 1)
            elif isinstance(v, list):
                preview = f'list[{len(v)}]'
                if v and not isinstance(v[0], (dict, list)):
                    preview += f'  e.g. {str(v[0])[:40]}'
                print(f'  {path}: {preview}')
            else:
                val_str = str(v)[:60]
                print(f'  {path}: {type(v).__name__} = {val_str}')


def try_fetch(endpoint: str) -> tuple[int, str, dict | None, int]:
    """Hit an endpoint, return (status, content_type, parsed_json_or_None, raw_size)."""
    url = f'{BASE}{endpoint}'
    print(f'  GET {url}')
    r = requests.get(url, headers=HEADERS, timeout=30)
    content_type = r.headers.get('content-type', 'unknown')
    raw_size = len(r.content)
    print(f'    status: {r.status_code}')
    print(f'    content-type: {content_type}')
    print(f'    raw size: {raw_size:,} bytes')
    parsed = None
    if r.status_code == 200:
        try:
            parsed = r.json()
            print(f'    JSON parse: ✓')
        except Exception as e:
            print(f'    JSON parse: ✗ ({e})')
            print(f'    first 200 chars: {r.text[:200]!r}')
    return r.status_code, content_type, parsed, raw_size


# ── Question 1 & 2 — Fetch endpoints ──────────────────────────────────────────

banner(f'Q1/Q2 — Symphony fetch endpoints for {SYM_NAME} ({SYM_ID})')

print('\n--- Trying /symphonies/{id}/score ---')
score_status, score_ct, score_json, score_size = try_fetch(
    f'/symphonies/{SYM_ID}/score'
)

print('\n--- Trying /symphonies/{id} (no suffix) ---')
plain_status, plain_ct, plain_json, plain_size = try_fetch(
    f'/symphonies/{SYM_ID}'
)

# ── Question 4 & 5 — Structural inspection of whichever worked ────────────────

banner('Q4/Q5 — Structural summary of fetched symphony')

# Pick whichever one returned JSON we can walk
chosen_endpoint = None
chosen_json     = None

for label, endpoint, parsed in [
    ('/score', f'/symphonies/{SYM_ID}/score', score_json),
    ('/plain', f'/symphonies/{SYM_ID}',       plain_json),
]:
    if parsed and isinstance(parsed, dict):
        # Heuristic: does it look like a Composer symphony tree?
        if 'step' in parsed or 'children' in parsed or 'symphony' in parsed:
            chosen_endpoint = endpoint
            chosen_json     = parsed
            print(f'Using endpoint: {endpoint}')
            break
        # Some responses wrap the symphony in another key
        for wrap_key in ('symphony', 'data', 'score'):
            if wrap_key in parsed and isinstance(parsed[wrap_key], dict):
                chosen_endpoint = endpoint
                chosen_json     = parsed[wrap_key]
                print(f'Using endpoint: {endpoint} (unwrapped from .{wrap_key})')
                break
        if chosen_json:
            break

if chosen_json is None:
    print('✗ NEITHER fetch endpoint returned a usable Composer symphony tree.')
    print('  Both responses are shown above. Cannot proceed to structural analysis.')
else:
    print(f'Top-level keys: {list(chosen_json.keys())[:15]}')
    print(f'Top-level step: {chosen_json.get("step", "(none)")}')
    name_val = chosen_json.get("name", "(none)")
    name_preview = name_val[:60] if isinstance(name_val, str) else name_val
    print(f'Top-level name: {name_preview}')

    counts = count_nodes(chosen_json)
    total = sum(counts.values())
    print(f'\nTotal nodes: {total:,}  (expected {EXPECTED_NODES:,} from on-disk Sisyphus)')
    print(f'Match: {"✓" if total == EXPECTED_NODES else "✗  (drift — investigate)"}')
    print(f'\nNode counts by step type:')
    for step, count in sorted(counts.items(), key=lambda x: -x[1]):
        print(f'  {step:30s} {count:>8,}')

# ── Question 3 — Backtest response shape ──────────────────────────────────────

banner(f'Q3 — Backtest response shape for {SYM_NAME} on 2022')

payload = {
    'capital':           10000,
    'apply_reg_fee':     False,
    'apply_taf_fee':     False,
    'slippage_percent':  0,
    'broker':            'ALPACA_WHITE_LABEL',
    'start_date':        '2022-01-01',
    'end_date':          '2022-12-31',
    'benchmark_tickers': ['SPY'],
}

bt_url = f'{BASE}/symphonies/{SYM_ID}/backtest'
print(f'  POST {bt_url}')
r = requests.post(bt_url, headers=HEADERS, json=payload, timeout=60)
print(f'    status: {r.status_code}')
print(f'    raw size: {len(r.content):,} bytes')

if r.status_code != 200:
    print(f'    body: {r.text[:500]!r}')
else:
    bt = r.json()
    print(f'\nTop-level keys: {list(bt.keys())}')

    stats = bt.get('stats', {})
    if stats:
        print(f'\n--- stats.* (full structure, 4 levels deep) ---')
        list_keys_recursive(stats, prefix='stats', max_depth=4)

    # Specifically hunt for SPY-correlation fields R1 expects
    print(f'\n--- Hunting for SPY correlation fields (pearson_r / r_squared / alpha / beta) ---')
    found = []

    def hunt(obj, path='stats'):
        if isinstance(obj, dict):
            for k, v in obj.items():
                key_lower = k.lower().replace('-', '_').replace(' ', '_')
                if any(target in key_lower for target in
                       ('pearson', 'r_squared', 'rsquared', 'alpha', 'beta', 'correlation')):
                    found.append((f'{path}.{k}', v))
                hunt(v, f'{path}.{k}')

    hunt(stats)
    if found:
        for path, val in found:
            print(f'  ✓ {path} = {val}')
    else:
        print('  ✗ NONE found — R1 will need these computed separately or from another endpoint')

# ── Summary ───────────────────────────────────────────────────────────────────

banner('SUMMARY')

print(f'Q1 /symphonies/{{id}}/score:  {"✓" if score_status == 200 else f"✗ ({score_status})"}')
print(f'Q2 /symphonies/{{id}}:        {"✓" if plain_status == 200 else f"✗ ({plain_status})"}')
print(f'Q3 backtest response:       {"✓" if r.status_code == 200 else f"✗ ({r.status_code})"}')
print(f'Q4 chosen fetch endpoint:   {chosen_endpoint or "NONE"}')
print(f'Q5 node count match:        {"✓" if chosen_json and sum(count_nodes(chosen_json).values()) == EXPECTED_NODES else "✗ or not checked"}')

print('\nProbe complete. Use the output above to lock the scanner design.')
