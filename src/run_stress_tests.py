"""
run_stress_tests.py — Parallel stress test backtests on all 5 research symphonies.
5 symphonies × 5 years (2020-2024) = 25 backtests, all concurrent.
Results saved to kb/research/stress_test_results.json
"""
import json, time, os, requests
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timezone

HOME     = Path.home()
CREDS    = json.load(open(HOME / '.openclaw/composer-credentials.json'))
KEY_ID   = CREDS.get('composer_api_key_id') or CREDS.get('keyId')
SECRET   = CREDS.get('composer_api_secret') or CREDS.get('secret')
HEADERS  = {'x-api-key-id': KEY_ID, 'authorization': f'Bearer {SECRET}'}
BASE     = 'http://localhost:8080/composer/api/v0.1'
OUT_PATH = HOME / '.openclaw/workspace/learning/kb/research/stress_test_results.json'

SYMPHONIES = {
    'FNGG':         'n9J6L8weCzu2vAUrMWnm',
    'Sisyphus':     'qjRIwrAOA1YzFSghM08b',
    'Beta Baller':  'vNP5oYsbpV8tS9USqGEL',
    'NOVA Best':    'zIMBF3ElL1diBeqo9eg4',
    'v2 Community': '1nCprFAGFjwxc8l3LkxB',
}

PERIODS = [
    ('2020', '2020-01-01', '2020-12-31'),
    ('2021', '2021-01-01', '2021-12-31'),
    ('2022', '2022-01-01', '2022-12-31'),
    ('2023', '2023-01-01', '2023-12-31'),
    ('2024', '2024-01-01', '2024-12-31'),
]

def backtest_one(name, sym_id, period, start, end):
    payload = {
        'capital': 10000, 'apply_reg_fee': False, 'apply_taf_fee': False,
        'slippage_percent': 0, 'broker': 'ALPACA_WHITE_LABEL',
        'start_date': start, 'end_date': end, 'benchmark_tickers': ['SPY'],
    }
    try:
        r = requests.post(f'{BASE}/symphonies/{sym_id}/backtest',
                          headers=HEADERS, json=payload, timeout=60)
        if r.status_code != 200:
            return name, period, None, f"HTTP {r.status_code}"
        s  = r.json().get('stats', {})
        bm = s.get('benchmarks', {}).get('SPY', {})
        bm_pct = bm.get('percent', {})
        return name, period, {
            'sharpe':     round(s.get('sharpe_ratio', 0), 3),
            'return_ann': round(s.get('annualized_rate_of_return', 0) * 100, 2),
            'return_tot': round(s.get('cumulative_return', 0) * 100, 2),
            'max_dd':     round(s.get('max_drawdown', 0) * 100, 2),
            'volatility': round(s.get('standard_deviation', 0) * 100, 2),
            'win_rate':   round(s.get('win_rate', 0) * 100, 2),
            'sortino':    round(s.get('sortino_ratio', 0), 3),
            'calmar':     round(s.get('calmar_ratio', 0), 3),
            'spy_sharpe': round(bm.get('sharpe_ratio', 0), 3),
            'spy_return': round(bm.get('annualized_rate_of_return', 0) * 100, 2),
            'alpha':      round(bm_pct.get('alpha', 0), 3),
            'beta':       round(bm_pct.get('beta', 0), 3),
        }, None
    except Exception as e:
        return name, period, None, str(e)

tasks = [
    (name, sym_id, period, start, end)
    for name, sym_id in SYMPHONIES.items()
    for period, start, end in PERIODS
]

print(f"Running {len(tasks)} backtests concurrently (5 workers)...")
results = {name: {} for name in SYMPHONIES}
errors  = []

t0 = time.time()
with ThreadPoolExecutor(max_workers=5) as pool:
    futures = {pool.submit(backtest_one, *task): task for task in tasks}
    for fut in as_completed(futures):
        name, period, data, err = fut.result()
        if data:
            results[name][period] = data
            print(f"  ✓ {name:<15} {period}  "
                  f"Sharpe={data['sharpe']:5.2f}  "
                  f"Return={data['return_ann']:6.1f}%  "
                  f"MaxDD={data['max_dd']:5.1f}%")
        else:
            errors.append(f"{name} {period}: {err}")
            print(f"  ✗ {name} {period}: {err}")

elapsed = time.time() - t0
print(f"\nDone in {elapsed:.1f}s — {len(tasks)-len(errors)}/{len(tasks)} succeeded")

# 2022 survival summary — the key test
print(f"\n{'='*65}")
print("2022 BEAR MARKET SURVIVAL")
print(f"{'Symphony':<18} {'Sharpe':>7} {'Return':>8} {'MaxDD':>7} {'SPY Sharpe':>11}")
print("-" * 55)
for name in SYMPHONIES:
    d = results[name].get('2022', {})
    if d:
        print(f"{name:<18} {d['sharpe']:>7.2f} {d['return_ann']:>7.1f}% "
              f"{d['max_dd']:>6.1f}%   {d['spy_sharpe']:>6.2f}")

# Full multi-year table
print(f"\n{'='*65}")
print("MULTI-YEAR SHARPE COMPARISON")
print(f"{'Symphony':<18} {'2020':>6} {'2021':>6} {'2022':>6} {'2023':>6} {'2024':>6}")
print("-" * 50)
for name in SYMPHONIES:
    row = f"{name:<18}"
    for yr in ['2020','2021','2022','2023','2024']:
        d = results[name].get(yr, {})
        row += f" {d.get('sharpe', 0):>6.2f}" if d else f" {'N/A':>6}"
    print(row)

# Save
output = {
    'generated_at': datetime.now(timezone.utc).isoformat(),
    'symphonies':   list(SYMPHONIES.keys()),
    'periods':      [p[0] for p in PERIODS],
    'results':      results,
    'errors':        errors,
}
tmp = str(OUT_PATH) + '.tmp'
with open(tmp, 'w') as f:
    json.dump(output, f, indent=2)
os.replace(tmp, str(OUT_PATH))
print(f"\nSaved to {OUT_PATH}")
