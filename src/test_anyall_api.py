"""
test_anyall_api.py — Test Composer API acceptance of Any/All condition schemas.

Uses the proven workflow from research_phase.py:
  1. Copy Sisyphus as template
  2. PUT our test strategy
  3. Backtest by symphony ID
  4. Delete temp symphony

Tests 5 schemas — each is a minimal valid strategy using a different
condition format. Test 5 is the regression (legacy format).
"""
import json, time, sys, uuid, copy, requests
from pathlib import Path

HOME        = Path.home()
CREDS_PATH  = HOME / '.openclaw' / 'composer-credentials.json'
PROXY_BASE  = 'http://localhost:8080/composer/api/v0.1'
COPY_SOURCE = 'qjRIwrAOA1YzFSghM08b'   # Sisyphus — copy source

with open(CREDS_PATH) as f:
    creds = json.load(f)
key_id = creds.get('composer_api_key_id') or creds.get('keyId')
secret = creds.get('composer_api_secret') or creds.get('secret')
headers = {
    'x-api-key-id':   key_id,
    'authorization':  f'Bearer {secret}',
    'content-type':   'application/json',
}

# ── Helpers ───────────────────────────────────────────────────────────────────

def add_ids(node):
    """Recursively add UUIDs to all nodes (required by Composer API)."""
    n = copy.deepcopy(node)
    if 'id' not in n:
        n['id'] = str(uuid.uuid4())
    n['children'] = [add_ids(c) for c in n.get('children', [])]
    return n

def create_temp(name, composer_json):
    """Copy Sisyphus, PUT our strategy, return symphony_id or None."""
    # Step 1: Copy
    r = requests.post(f'{PROXY_BASE}/symphonies/{COPY_SOURCE}/copy',
                      headers=headers, json={'name': f'tmp-anyall-{name[:30]}'},
                      timeout=15)
    if r.status_code not in (200, 201):
        print(f"  Copy failed: HTTP {r.status_code} — {r.text[:200]}")
        return None
    sym_id = r.json().get('symphony_id')
    if not sym_id:
        print(f"  Copy: no symphony_id in response: {r.text[:200]}")
        return None

    # Step 2: PUT our strategy
    children = [add_ids(c) for c in composer_json.get('children', [])]
    put_payload = {
        'name':        f'tmp-anyall-{name[:40]}',
        'description': 'Any/All API test',
        'step':        'root',
        'rebalance':   'daily',
        'asset_class': 'EQUITIES',
        'children':    children,
    }
    r2 = requests.put(f'{PROXY_BASE}/symphonies/{sym_id}',
                      headers=headers, json=put_payload, timeout=30)
    if r2.status_code not in (200, 201):
        print(f"  PUT failed: HTTP {r2.status_code} — {r2.text[:300]}")
        delete_temp(sym_id)
        return None
    return sym_id

def delete_temp(sym_id):
    try:
        requests.delete(f'{PROXY_BASE}/symphonies/{sym_id}',
                        headers=headers, timeout=10)
    except Exception:
        pass

def backtest(sym_id):
    """Run 1Y backtest on a symphony by ID."""
    payload = {
        'capital':           10000,
        'apply_reg_fee':     False,
        'apply_taf_fee':     False,
        'slippage_percent':  0,
        'broker':            'ALPACA_WHITE_LABEL',
        'start_date':        '2023-01-01',
        'end_date':          '2023-12-31',
        'benchmark_tickers': ['SPY'],
    }
    r = requests.post(f'{PROXY_BASE}/symphonies/{sym_id}/backtest',
                      headers=headers, json=payload, timeout=60)
    return r.status_code, r.json() if r.content else {}

def run_test(name, composer_json):
    print(f"\n{name}")
    sym_id = create_temp(name, composer_json)
    if not sym_id:
        print(f"  ✗ FAILED — could not create symphony")
        return False
    try:
        status, data = backtest(sym_id)
        if status == 200:
            stats  = data.get('stats', {})
            sharpe = stats.get('sharpe_ratio', '?')
            ret    = stats.get('annualized_rate_of_return', '?')
            sharpe_str = f"{sharpe:.2f}" if isinstance(sharpe, (int,float)) else str(sharpe)
            ret_str    = f"{ret*100:.1f}%" if isinstance(ret, (int,float)) else str(ret)
            print(f"  ✓ HTTP 200 | Sharpe={sharpe_str} | Return={ret_str}")
            return True
        else:
            err = data.get('error') or data.get('message') or str(data)[:300]
            print(f"  ✗ HTTP {status} — {err}")
            return False
    finally:
        delete_temp(sym_id)
        time.sleep(1)

# ── Strategy definitions ───────────────────────────────────────────────────────

def wrap(inner_if):
    return {"step": "wt-cash-equal", "children": [inner_if]}

def make_if(true_child, else_child, condition_obj,
            legacy_fn, legacy_window, legacy_val, legacy_comp,
            legacy_rhs_val, legacy_rhs_fixed=True, legacy_rhs_fn=None):
    """Build a complete if node with condition object + legacy fallback fields."""
    true_if_child = {
        "step": "if-child",
        "is-else-condition?": False,
        "condition": condition_obj,
        # Legacy fallback fields (always required alongside condition object)
        "lhs-fn": legacy_fn,
        "lhs-window-days": legacy_window,
        "lhs-val": legacy_val,
        "comparator": legacy_comp,
        "rhs-val": legacy_rhs_val,
        "rhs-fixed-value?": legacy_rhs_fixed,
        "children": [true_child],
    }
    if legacy_rhs_fn:
        true_if_child["rhs-fn"] = legacy_rhs_fn
        del true_if_child["rhs-fixed-value?"]

    return {
        "step": "if",
        "children": [
            true_if_child,
            {"step": "if-child", "is-else-condition?": True,
             "children": [else_child]},
        ]
    }

BIL  = {"step": "asset", "ticker": "BIL",  "children": []}
TQQQ = {"step": "asset", "ticker": "TQQQ", "children": []}
UVXY = {"step": "asset", "ticker": "UVXY", "children": []}

# ── Test 1: binary-compound/any ───────────────────────────────────────────────
test1 = wrap(make_if(
    true_child = BIL, else_child = TQQQ,
    condition_obj = {
        "condition-type": "binary-compound",
        "operator": "any",
        "tickers": ["TQQQ", "SPY"],
        "lhs": {"fn": "relative-strength-index",
                "params": {"window": 10}, "ticker": "%"},
        "comparator": "gt",
        "rhs": {"constant": 75},
    },
    legacy_fn="relative-strength-index", legacy_window="10",
    legacy_val="TQQQ", legacy_comp="gt",
    legacy_rhs_val="75", legacy_rhs_fixed=True,
))

# ── Test 2: compound/all — RSI band ───────────────────────────────────────────
test2 = wrap(make_if(
    true_child = UVXY, else_child = TQQQ,
    condition_obj = {
        "condition-type": "compound",
        "operator": "all",
        "conditions": [
            {"condition-type": "binary",
             "lhs": {"fn": "relative-strength-index",
                     "params": {"window": 10}, "ticker": "UVXY"},
             "comparator": "gt", "rhs": {"constant": 30}},
            {"condition-type": "binary",
             "lhs": {"fn": "relative-strength-index",
                     "params": {"window": 10}, "ticker": "UVXY"},
             "comparator": "lt", "rhs": {"constant": 84}},
        ],
    },
    legacy_fn="relative-strength-index", legacy_window="10",
    legacy_val="UVXY", legacy_comp="gt",
    legacy_rhs_val="30", legacy_rhs_fixed=True,
))

# ── Test 3: compound/any — TQQQ OR SPY overbought ────────────────────────────
test3 = wrap(make_if(
    true_child = BIL, else_child = TQQQ,
    condition_obj = {
        "condition-type": "compound",
        "operator": "any",
        "conditions": [
            {"condition-type": "binary",
             "lhs": {"fn": "relative-strength-index",
                     "params": {"window": 10}, "ticker": "TQQQ"},
             "comparator": "gt", "rhs": {"constant": 75}},
            {"condition-type": "binary",
             "lhs": {"fn": "relative-strength-index",
                     "params": {"window": 10}, "ticker": "SPY"},
             "comparator": "gt", "rhs": {"constant": 75}},
        ],
    },
    legacy_fn="relative-strength-index", legacy_window="10",
    legacy_val="TQQQ", legacy_comp="gt",
    legacy_rhs_val="75", legacy_rhs_fixed=True,
))

# ── Test 4: compound/all 3-cond — SVXY triple crash guard ────────────────────
test4 = wrap(make_if(
    true_child = BIL, else_child = TQQQ,
    condition_obj = {
        "condition-type": "compound",
        "operator": "all",
        "conditions": [
            {"condition-type": "binary",
             "lhs": {"fn": "relative-strength-index",
                     "params": {"window": 10}, "ticker": "SVXY"},
             "comparator": "lt", "rhs": {"constant": 31}},
            {"condition-type": "binary",
             "lhs": {"fn": "cumulative-return",
                     "params": {"window": 1}, "ticker": "SVXY"},
             "comparator": "lt", "rhs": {"constant": -6}},
            {"condition-type": "binary",
             "lhs": {"fn": "max-drawdown",
                     "params": {"window": 20}, "ticker": "SPY"},
             "comparator": "gt", "rhs": {"constant": 6}},
        ],
    },
    legacy_fn="relative-strength-index", legacy_window="10",
    legacy_val="SVXY", legacy_comp="lt",
    legacy_rhs_val="31", legacy_rhs_fixed=True,
))

# ── Test 5: legacy format — regression check ──────────────────────────────────
test5 = wrap({
    "step": "if",
    "children": [
        {
            "step": "if-child",
            "is-else-condition?": False,
            "lhs-fn": "cumulative-return",
            "lhs-fn-params": {"window-days": 1},
            "lhs-val": "TQQQ",
            "comparator": "gt",
            "rhs-val": "5.5",
            "rhs-fixed-value?": True,
            "children": [TQQQ],
        },
        {
            "step": "if-child",
            "is-else-condition?": True,
            "children": [BIL],
        },
    ],
})

# ── Run ───────────────────────────────────────────────────────────────────────
print("\n=== Any/All API Schema Tests ===")

tests = [
    ("Test 1: binary-compound/any  (same indicator, multi-ticker)", test1),
    ("Test 2: compound/all         (UVXY RSI band — 2 conditions)",  test2),
    ("Test 3: compound/any         (TQQQ OR SPY — 2 conditions)",    test3),
    ("Test 4: compound/all 3-cond  (SVXY triple crash guard)",       test4),
    ("Test 5: legacy format        (regression — no condition obj)", test5),
]

results = [run_test(name, s) for name, s in tests]

print(f"\n{'='*60}")
passed = sum(results)
print(f"Results: {passed}/{len(results)} passed")
if passed == len(results):
    print("ALL TESTS PASSED ✓")
else:
    print("SOME TESTS FAILED — see errors above")
