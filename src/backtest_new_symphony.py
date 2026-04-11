import requests, json, time
from pathlib import Path

creds = json.load(open(Path.home() / '.openclaw/composer-credentials.json'))
headers = {'x-api-key-id': creds.get('composer_api_key_id'),
           'authorization': f'Bearer {creds.get("composer_api_secret")}'}
base = 'http://localhost:8080/composer/api/v0.1'

SYM_ID = 'm36cKalUklvsyCG0JGcC'
NAME   = 'Leveraged ETF Momentum Strategy'

PERIODS = [
    ('2021', '2021-01-01', '2021-12-31'),
    ('2022', '2022-01-01', '2022-12-31'),
    ('2023', '2023-01-01', '2023-12-31'),
    ('2024', '2024-01-01', '2024-12-31'),
    ('2Y',   None, None),  # handled below
]

from datetime import date, timedelta
today = date.today()
two_yr_start = (today - timedelta(days=730)).isoformat()

results = {}
for period, start, end in PERIODS:
    if period == '2Y':
        start, end = two_yr_start, today.isoformat()
    r = requests.post(
        f'{base}/symphonies/{SYM_ID}/backtest',
        headers=headers, timeout=60,
        json={'capital': 10000, 'apply_reg_fee': False, 'apply_taf_fee': False,
              'slippage_percent': 0, 'broker': 'ALPACA_WHITE_LABEL',
              'start_date': start, 'end_date': end, 'benchmark_tickers': ['SPY']}
    )
    if r.status_code == 200:
        s  = r.json().get('stats', {})
        bm = s.get('benchmarks', {}).get('SPY', {})
        results[period] = {
            'sharpe':     round(s.get('sharpe_ratio', 0), 3),
            'return_ann': round(s.get('annualized_rate_of_return', 0) * 100, 2),
            'return_tot': round(s.get('cumulative_return', 0) * 100, 2),
            'max_dd':     round(s.get('max_drawdown', 0) * 100, 2),
            'win_rate':   round(s.get('win_rate', 0) * 100, 1),
            'spy_sharpe': round(bm.get('sharpe_ratio', 0), 3),
            'spy_return': round(bm.get('annualized_rate_of_return', 0) * 100, 2),
        }
    else:
        results[period] = {'error': r.status_code}
    time.sleep(0.3)

# ── Reference benchmarks (from stress tests) ──────────────────────────────────
REFS = {
    'Sisyphus':     {'2022': 5.61, '2023': 6.48, '2024': 4.87},
    'NOVA Best':    {'2022': 6.71, '2023': 6.18, '2024': 5.01},
    'Beta Baller':  {'2022': 5.07, '2023': 1.53, '2024': 2.82},
    'v2 Community': {'2022': 4.51, '2023': 3.99, '2024': 5.05},
}

print(f"\n{'='*65}")
print(f"BACKTEST RESULTS: {NAME}")
print(f"{'='*65}")
print(f"{'Period':<8} {'Sharpe':>7} {'Ann Ret':>9} {'Tot Ret':>9} {'MaxDD':>7} {'WinRate':>8}")
print("-"*55)
for period in ['2021','2022','2023','2024','2Y']:
    d = results.get(period, {})
    if 'error' in d:
        print(f"{period:<8} ERROR {d['error']}")
    else:
        print(f"{period:<8} {d['sharpe']:>7.3f} {d['return_ann']:>8.1f}% "
              f"{d['return_tot']:>8.1f}% {d['max_dd']:>6.1f}% {d['win_rate']:>7.1f}%")

# ── vs benchmarks ─────────────────────────────────────────────────────────────
print(f"\n{'='*65}")
print("vs REFERENCE SYMPHONIES (Sharpe by year)")
print(f"{'Symphony':<18} {'2021':>6} {'2022':>6} {'2023':>6} {'2024':>6}")
print("-"*45)

# Our strategy
row = f"{'NEW STRATEGY':<18}"
for yr in ['2021','2022','2023','2024']:
    d = results.get(yr, {})
    row += f" {d.get('sharpe',0):>6.2f}" if 'sharpe' in d else f" {'N/A':>6}"
print(row + "  ← NEW")

for ref_name, ref_data in REFS.items():
    row = f"{ref_name:<18}"
    for yr in ['2021','2022','2023','2024']:
        v = ref_data.get(yr, 0)
        row += f" {v:>6.2f}" if v else f" {'N/A':>6}"
    print(row)

print(f"\n{'='*65}")
print("FITNESS GATE: 2022 Sharpe ≥ 2.0 to pass")
sharpe_2022 = results.get('2022', {}).get('sharpe', 0)
if sharpe_2022 >= 2.0:
    print(f"✓ PASSES ({sharpe_2022:.2f}) — eligible as gen-0 parent")
else:
    print(f"✗ FAILS ({sharpe_2022:.2f}) — below fitness gate")
