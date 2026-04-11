import requests, json, time
from pathlib import Path

creds = json.load(open(Path.home() / '.openclaw/composer-credentials.json'))
headers = {'x-api-key-id': creds.get('composer_api_key_id'),
           'authorization': f'Bearer {creds.get("composer_api_secret")}'}
base = 'http://localhost:8080/composer/api/v0.1'

SYMPHONIES = {
    'v1 (EMA vs MA200)':       'm36cKalUklvsyCG0JGcC',
    'v2 (inverted — broken)':  'y2CPPxd6f4LsMI1oC86W',
    'v3 (price > EMA + gate)': 'eIsUqvvWwPnGE040g1hX',
    'v4 (price > MA200)':      'p8Xc6tqoxC9yh5GNGRGy',
    'V5 (Leveraged ETF Momentum)': 'NP6AADjtYnisdyAvQwzt',
    'Sisyphus':                 'qjRIwrAOA1YzFSghM08b',
}

PERIODS = [('2021','2021-01-01','2021-12-31'),('2022','2022-01-01','2022-12-31'),
           ('2023','2023-01-01','2023-12-31'),('2024','2024-01-01','2024-12-31')]

results = {}
for name, sym_id in SYMPHONIES.items():
    results[name] = {}
    for period, start, end in PERIODS:
        r = requests.post(f'{base}/symphonies/{sym_id}/backtest',
            headers=headers, timeout=60,
            json={'capital':10000,'apply_reg_fee':False,'apply_taf_fee':False,
                  'slippage_percent':0,'broker':'ALPACA_WHITE_LABEL',
                  'start_date':start,'end_date':end,'benchmark_tickers':['SPY']})
        if r.status_code == 200:
            s = r.json().get('stats',{})
            results[name][period] = {
                'sharpe': round(s.get('sharpe_ratio',0),3),
                'return': round(s.get('annualized_rate_of_return',0)*100,1),
                'max_dd': round(s.get('max_drawdown',0)*100,1),
            }
        time.sleep(0.3)

for metric, key, fmt in [('SHARPE','sharpe','{:>6.2f}'),
                          ('MAX DRAWDOWN','max_dd','{:>5.1f}%'),
                          ('ANN RETURN','return','{:>6.1f}%')]:
    print(f"\n{metric}")
    print(f"{'Symphony':<26} {'2021':>7} {'2022':>7} {'2023':>7} {'2024':>7}")
    print("-"*55)
    for name, periods in results.items():
        row = f"{name:<26}"
        for yr in ['2021','2022','2023','2024']:
            d = periods.get(yr,{})
            row += (' '+fmt.format(d[key])) if key in d else f" {'N/A':>7}"
        print(row)
