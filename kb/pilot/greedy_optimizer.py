"""
Greedy forward selection optimizer — dual track (Sharpe vs Return)
Runs overnight as a batch job. Safe to interrupt and resume.
"""
import sys, json, requests, uuid, copy, time
from pathlib import Path
from datetime import datetime

sys.path.insert(0, str(Path(__file__).parent.parent.parent / 'src'))
from credentials import CredentialManager

creds = CredentialManager()
headers = creds.get_composer_headers()

OPT_PERIODS = [('2022','2022-01-01','2022-12-31'),
               ('2023','2023-01-01','2023-12-31'),
               ('2024','2024-01-01','2024-12-31')]
MAX_K        = 10
MIN_MARGINAL = 0.0
API_DELAY    = 1.5
RETRY_DELAY  = 10
MAX_RETRIES  = 3
OUT_DIR      = Path(__file__).parent / 'greedy_optimizer_results'
OUT_DIR.mkdir(exist_ok=True)

SOURCES = {
    'sisyphus':  Path(__file__).parent.parent / 'pilot/sisyphus_groups',
    'fngg':      Path(__file__).parent.parent / 'pilot/fngg_groups',
    'wild_west': Path(__file__).parent.parent / 'pilot/wild_west_groups',
    'v2_comm':   Path(__file__).parent.parent / 'pilot/v2_community_groups',
    'beta_tame': Path(__file__).parent.parent / 'community/beta_baller_tame',
    'macro':     Path(__file__).parent.parent / 'community/macro_oscillator',
    'sandy':     Path(__file__).parent.parent / 'community/sandy_dragon',
}

SKIP_FILES = {
    'raw_score.json','backtest_results.json','full_symphony.json',
    'correlation_vs_sisyphus.json','loo_multi_period.json',
    'optimization_results.json','backtest_comparison.json',
    'final_results.json','expansion_results.json',
    'regime_weights.json','regime_weights_best.json',
    'regime_dates.json','sisyphus_v2_deployable.json',
    'greedy_selection_v2.json','v2_correlation_analysis.json',
    'replace_add_skip.json','v3_test_results.json',
    'correlation_vs_sisyphus.json','priority_backtest_results.json',
}

# Exclude: low-return stabilizers, data artifacts, confirmed weak strategies
SKIP_SLUGS = {
    # Anomalies / artifacts
    'almost_pure_cash',              # 20% return — too low
    'ief_macro_momentum',            # 14 Sharpe in 2023 is anomaly
    'ief_macro_momentum',
    'copy_of_inflation_protected_simple',  # 4748% artifact
    'tlt_macro_momentum',            # regime-specific, breaks 2024
    # Confirmed weak from leaderboard
    'gld_trend','xlp_easy_money','votes_core','semis_shield',
    'commodities_macro_momentum','interest_rate_linked',
    'trend_and_momentum','long_volatility','fiat_alternatives',
    'u_s__dollar','oil_st_trading',
    # Near-zero or negative
    'long_volatility_tests___layere',
}

def load_strategies():
    pool = {}
    for source, path in SOURCES.items():
        p = Path(path)
        if not p.exists(): continue
        for f in sorted(p.glob('*.json')):
            if f.name in SKIP_FILES: continue
            slug = f.stem
            if any(skip in slug.lower() for skip in SKIP_SLUGS): continue
            if slug in SKIP_SLUGS: continue
            pool[slug] = {'file': f, 'source': source}
    return pool

def get_group_node(data):
    c1 = data.get('children',[{}])[0]
    c2 = c1.get('children',[{}])
    return c2[0] if c2 else c1

def build_portfolio(slug_list, pool):
    children = []
    for slug in slug_list:
        data = json.loads(pool[slug]['file'].read_text())
        g = copy.deepcopy(get_group_node(data))
        g['id'] = str(uuid.uuid4())
        children.append(g)
    return {'id':str(uuid.uuid4()),'step':'root','name':'optimizer_test',
            'description':'','rebalance':'daily',
            'children':[{'id':str(uuid.uuid4()),'step':'wt-cash-equal',
                         'children':children}]}

def bt_period(slug_list, pool, start, end):
    sym = build_portfolio(slug_list, pool)
    for attempt in range(MAX_RETRIES):
        try:
            r = requests.post('http://localhost:8080/composer/api/v0.1/backtest',
                headers=headers,
                json={'capital':10000,'apply_reg_fee':False,'apply_taf_fee':False,
                      'slippage_percent':0.001,'broker':'ALPACA_WHITE_LABEL',
                      'start_date':start,'end_date':end,'benchmark_tickers':['SPY'],
                      'symphony':{'raw_value':sym}},timeout=30)
            if r.status_code==200:
                s=r.json().get('stats',{})
                return {'sharpe':round(s.get('sharpe_ratio',0),3),
                        'annret':round(s.get('annualized_rate_of_return',0)*100,1),
                        'maxdd': round(s.get('max_drawdown',0)*100,2)}
            code = r.json().get('errors',[{}])[0].get('code',r.status_code)
            if 'too-many' in str(code):
                wait = RETRY_DELAY*(attempt+1)
                log(f"    rate limit — waiting {wait}s...")
                time.sleep(wait)
            else:
                return {'sharpe':0,'annret':0,'maxdd':0,'error':str(code)}
        except Exception as e:
            log(f"    exception: {e}")
            time.sleep(RETRY_DELAY)
    return {'sharpe':0,'annret':0,'maxdd':0,'error':'exhausted'}

def bt_all(slug_list, pool):
    results = {}
    for yr, s, e in OPT_PERIODS:
        results[yr] = bt_period(slug_list, pool, s, e)
        time.sleep(API_DELAY)
    sharpes = [results[yr]['sharpe'] for yr in ['2022','2023','2024']]
    rets    = [results[yr]['annret'] for yr in ['2022','2023','2024']]
    # Only count years with valid data
    valid_sh  = [s for s in sharpes if s != 0]
    valid_ret = [r for r in rets if r != 0]
    return {
        'per_year':   results,
        'avg_sharpe': round(sum(valid_sh)/len(valid_sh),3) if valid_sh else 0,
        'avg_return': round(sum(valid_ret)/len(valid_ret),1) if valid_ret else 0,
        'maxdd_2022': results.get('2022',{}).get('maxdd',0),
    }

def log(msg):
    ts = datetime.now().strftime('%H:%M:%S')
    line = f"[{ts}] {msg}"
    print(line, flush=True)
    with open(OUT_DIR/'run.log','a') as f:
        f.write(line+'\n')

def run_single_scan(pool):
    cache = OUT_DIR/'single_results.json'
    if cache.exists():
        data = json.loads(cache.read_text())
        # Resume partial scan
        if len(data) < len(pool):
            log(f"Resuming single scan ({len(data)}/{len(pool)} done)...")
        else:
            log(f"Single scan cached ({len(data)} strategies)")
            return data
    else:
        data = {}

    slugs_done = set(data.keys())
    for i, slug in enumerate(pool, 1):
        if slug in slugs_done: continue
        res = bt_all([slug], pool)
        data[slug] = res
        flag = '★' if res['avg_sharpe']>4 else ('↑' if res['avg_sharpe']>2.5 else ' ')
        log(f"  [{i:2d}/{len(pool)}] {flag} {slug:<36} "
            f"Sh={res['avg_sharpe']:.2f} R={res['avg_return']:.1f}%")
        cache.write_text(json.dumps(data, indent=2))

    return data

def greedy_select(pool, single, criterion):
    cache = OUT_DIR/f'greedy_{criterion}.json'

    def score(res):
        return res['avg_sharpe'] if criterion=='sharpe' else res['avg_return']

    # Load checkpoint if exists
    if cache.exists():
        state = json.loads(cache.read_text())
        if state.get('done'):
            log(f"greedy_{criterion} already complete")
            return state
        selected  = state['selected']
        history   = state['history']
        remaining = [s for s in pool if s not in selected]
        current   = score({'avg_sharpe':history[-1]['avg_sharpe'],
                           'avg_return':history[-1]['avg_return']})
        log(f"Resuming greedy_{criterion} at K={len(selected)}")
    else:
        # Seed from best valid single strategy
        ranked = sorted(
            [(s,r) for s,r in single.items() if r['avg_sharpe']>0.5],
            key=lambda x: -score(x[1])
        )
        seed_slug, seed_res = ranked[0]
        selected  = [seed_slug]
        remaining = [s for s,_ in ranked[1:]]
        current   = score(seed_res)
        history   = [{'step':0,'added':seed_slug,
                      'avg_sharpe':seed_res['avg_sharpe'],
                      'avg_return':seed_res['avg_return'],
                      'maxdd_2022':seed_res['maxdd_2022'],'marginal':0}]
        log(f"Greedy [{criterion.upper()}] seed: {seed_slug} "
            f"(sh={seed_res['avg_sharpe']:.2f} r={seed_res['avg_return']:.1f}%)")

    for step in range(len(history), MAX_K+1):
        if len(selected) >= MAX_K:
            log(f"  Max K={MAX_K} reached")
            break

        log(f"\n  Step {step}: testing {len(remaining)} candidates...")
        best_slug, best_score, best_res = None, -999, None

        for j, candidate in enumerate(remaining, 1):
            trial = selected + [candidate]
            res = bt_all(trial, pool)
            s = score(res)
            if s > best_score:
                best_score = s
                best_slug  = candidate
                best_res   = res
            log(f"    [{j:2d}/{len(remaining)}] {candidate:<34} "
                f"Sh={res['avg_sharpe']:.2f} R={res['avg_return']:.1f}% "
                f"→ {criterion}={s:.2f}")

        marginal = best_score - current
        flag = '★' if marginal>0.3 else ('↑' if marginal>0.05 else ('~' if marginal>0 else '✗'))
        log(f"\n  → Best: {best_slug} | {criterion}={best_score:.2f} "
            f"(+{marginal:.2f}) {flag}")

        h = {'step':step,'added':best_slug,
             'avg_sharpe':best_res['avg_sharpe'],
             'avg_return':best_res['avg_return'],
             'maxdd_2022':best_res['maxdd_2022'],
             'marginal':round(marginal,3)}
        history.append(h)

        # Save checkpoint
        cache.write_text(json.dumps(
            {'selected':selected,'history':history,
             'criterion':criterion,'done':False}, indent=2))

        if marginal <= MIN_MARGINAL:
            log(f"  → Marginal non-positive. Stopping at K={len(selected)}.")
            break

        selected.append(best_slug)
        remaining.remove(best_slug)
        current = best_score

    # Final per-year validation
    log(f"\n  Final validation ({len(selected)} components):")
    final = {}
    for yr, s, e in OPT_PERIODS:
        res = bt_period(selected, pool, s, e)
        final[yr] = res
        time.sleep(API_DELAY)
        log(f"    {yr}: Sharpe={res['sharpe']:.2f} Return={res['annret']:.1f}% DD={res['maxdd']:.1f}%")

    output = {'criterion':criterion,'selected':selected,
              'history':history,'final_results':final,
              'k':len(selected),'done':True}
    cache.write_text(json.dumps(output, indent=2))
    return output

if __name__ == '__main__':
    log("="*60)
    log("OpenClaw Greedy Optimizer — Dual Track")
    log("="*60)

    pool = load_strategies()
    log(f"Pool: {len(pool)} strategies")
    for src in SOURCES:
        n = sum(1 for s in pool.values() if s['source']==src)
        if n: log(f"  {src:<20} {n}")

    single = run_single_scan(pool)

    log("\nTop 10 by Sharpe:")
    for s,r in sorted(single.items(),key=lambda x:-x[1]['avg_sharpe'])[:10]:
        log(f"  {s:<36} Sh={r['avg_sharpe']:.2f} R={r['avg_return']:.1f}%")

    log("\nTop 10 by Return:")
    for s,r in sorted(single.items(),key=lambda x:-x[1]['avg_return'])[:10]:
        log(f"  {s:<36} Sh={r['avg_sharpe']:.2f} R={r['avg_return']:.1f}%")

    log("\n"+"="*60)
    log("TRACK A: Optimize for Sharpe")
    log("="*60)
    result_sh = greedy_select(pool, single, 'sharpe')

    log("\n"+"="*60)
    log("TRACK B: Optimize for Return")
    log("="*60)
    result_ret = greedy_select(pool, single, 'return')

    log("\n"+"="*60)
    log("FINAL SUMMARY")
    log("="*60)
    for label, result in [("SHARPE",result_sh),("RETURN",result_ret)]:
        log(f"\n{label} TRACK — K={result['k']}:")
        for i,s in enumerate(result['selected'],1):
            log(f"  [{i}] {s}")
        fr = result['final_results']
        avgs = sum(fr[yr]['sharpe'] for yr in ['2022','2023','2024'])/3
        avgr = sum(fr[yr]['annret'] for yr in ['2022','2023','2024'])/3
        log(f"  Avg Sharpe={avgs:.2f} Avg Return={avgr:.1f}% DD={fr['2022']['maxdd']:.1f}%")

    log("Done.")
