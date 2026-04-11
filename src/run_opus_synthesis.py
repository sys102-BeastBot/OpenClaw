"""
run_opus_synthesis.py — Opus synthesis using Anthropic Batch API.

Batch API = 50% cost reduction, async processing (results in ~10-60 min).
All 4 calls submitted simultaneously, script polls until complete.

Usage:
  python3 src/run_opus_synthesis.py          # submit batch + poll
  python3 src/run_opus_synthesis.py --submit  # submit only, print batch ID
  python3 src/run_opus_synthesis.py --fetch BATCH_ID  # fetch completed batch
"""
import json, re, sys, time, datetime, argparse
from pathlib import Path

HOME          = Path.home()
LEARN_ROOT    = HOME / '.openclaw' / 'workspace' / 'learning'
PROMPT_PATH   = LEARN_ROOT / 'src' / 'opus_synthesis_prompt.txt'
OUTPUT_PATH   = LEARN_ROOT / 'kb' / 'patterns_opus.json'
PILOT_DIR     = LEARN_ROOT / 'kb' / 'pilot'
BATCH_ID_PATH = PILOT_DIR / 'opus_batch_id.txt'
AUTH_PATH     = HOME / '.openclaw' / 'agents' / 'security' / 'agent' / 'auth-profiles.json'

with open(AUTH_PATH) as f:
    api_key = json.load(f)['profiles']['anthropic:default']['key']

try:
    import anthropic
except ImportError:
    print("ERROR: pip install anthropic --break-system-packages")
    sys.exit(1)

client  = anthropic.Anthropic(api_key=api_key)
corpus  = PROMPT_PATH.read_text()
SYSTEM  = (
    "You are a quantitative strategy architect producing a JSON pattern library. "
    "Output ONLY a valid JSON array. Start with [ end with ]. "
    "No preamble, no explanation, no markdown fences. Never truncate a pattern."
)

SCHEMA = """
Each pattern object (ALL fields required):
{
  "id": "pat-NNN",
  "name": "Short name",
  "category": "guard|selection|allocation|weighting",
  "times_seen": 0,
  "first_seen_generation": null,
  "last_seen_generation": null,
  "performance": {"avg_fitness_with":null,"avg_fitness_without":null,
                  "fitness_boost":null,"confidence":0.00},
  "applicability": {"archetypes":["ALL"],"regimes_effective":[],
                    "regimes_less_effective":[],"regime_note":""},
  "description": "What it does and why it works. Reference symphony evidence.",
  "usage_note": "When and how to use it.",
  "generator_instruction": "Generator: [DIRECT COMMAND — reference specific Composer JSON fields, e.g. 'Before every if-child routing to TQQQ/SOXL/TECL/SPXL/UPRO, add a preceding if-child with lhs-fn=cumulative-return, lhs-val=TQQQ, rhs-val=5.5, window=1, comparator=gt']",
  "confirmed_in_symphonies": ["symphony name"],
  "base_parameters": {"param":"value","_basis":"evidence","_confidence":0.00},
  "archetype_overrides": {},
  "template": {"step":"if","children":[{"step":"if-child","is-else-condition?":false,"lhs-fn":"...","lhs-fn-params":{"window":10},"lhs-val":"...","comparator":"gt","rhs-val":"...","rhs-fixed-value?":true,"children":[]},{"step":"if-child","is-else-condition?":true,"children":[]}]},
  "lineage": {"source":"research_phase","derived_from":[],"first_strategy_id":null}
}
"""

LOSING_SCHEMA = """
Each losing pattern (ALL fields required):
{"id":"pat-bad-NNN","name":"...","category":"...","times_seen":0,"confidence":0.00,
 "description":"...","why_it_fails":"...","historical_evidence":["..."],
 "never_do":"Never ...","lineage":{"source":"research_phase","derived_from":[]}}
"""

# ── Task definitions ───────────────────────────────────────────────────────────

TASK_A = corpus + """

TASK A — Write winning patterns pat-001 through pat-005 (core parameter priors):

pat-001: TQQQ Bull Entry Gate
  cumulative-return on TQQQ, threshold=5.5, window=1
  Evidence: 11/55 FNGG + Sisyphus ms-009/010 + 5/21 Beta Baller + NOVA Best + v2
  Confidence: 0.97

pat-002: RSI Window 10 Default
  All RSI windows default to 10; window=7 is confirmed fast variant
  Evidence: 40+ mini-strategies across all 5 symphonies
  Confidence: 0.97

pat-003: SVXY Crash Guard Mandatory
  max-drawdown on SVXY, window=2, threshold=10 (conservative) OR window=3, threshold=20 (aggressive)
  Evidence: FNGG ms-001, NOVA Best ms-001, v2 ms-006. Volmageddon 2018 = -93% without guard
  Confidence: 0.95

pat-004: SPY EMA 210 Long-Term Trend Filter
  exponential-moving-average-price on SPY, window=210, vs SPY threshold
  Evidence: FNGG ms-022/024, Beta Baller ms-004/007, NOVA Best ms-001/034/036
  Confidence: 0.90

pat-005: BIL RSI vs IEF Rate Stress Signal
  relative-strength-index on BIL, window=10, threshold=IEF (dynamic comparison, not fixed)
  BIL RSI < IEF RSI = rate stress incoming before equity drawdown
  Evidence: Beta Baller ms-003/004/005/007, NOVA Best ms-034/036, FNGG ms-046/050
  Confidence: 0.85

""" + SCHEMA + "\nReturn ONLY a JSON array of exactly 5 patterns. IDs: pat-001 to pat-005."

TASK_B = corpus + """

TASK B — Write winning patterns pat-006 through pat-011:

pat-006: UVXY VIXM Paired Volatility Hedge
  Always use UVXY+VIXM together (wt-cash-equal) in defensive branches, never alone
  Evidence: Sisyphus ms-001/002/005/006 (4 of 10 mini-strategies)
  Confidence: 0.82

pat-007: SPY Max Drawdown Hard Floor
  max-drawdown on SPY, threshold=6% (v2 ms-004) or 10% (Beta Baller ms-005)
  Evidence: Beta Baller ms-005, v2 ms-004, NOVA Best implicit
  Confidence: 0.88

pat-008: Triple Confirmation Before Leverage
  Chain 3+ independent conditions (trend + momentum + stress) before any leveraged ETF
  Evidence: Sisyphus ms-002/009, Beta Baller ms-003/004/005, NOVA Best ms-001 (7 conditions)
  Confidence: 0.87

pat-009: VIXY UVXY Cumulative Return Spike Detector
  cumulative-return on UVXY, window=10, threshold=20 → exit to BIL when breached
  Evidence: NOVA Best ms-001 (threshold 20), v2 ms-006 (threshold 25)
  Confidence: 0.85

pat-010: SPY RSI Overbought Exhaustion Exit
  relative-strength-index on SPY, window=10, threshold=70 (v2 ms-002) or 80 (v2 ms-006)
  Evidence: v2 ms-002, v2 ms-006, v2 ms-094
  Confidence: 0.83

""" + SCHEMA + "\nReturn ONLY a JSON array of exactly 5 patterns. IDs: pat-006 to pat-010."

TASK_B2 = corpus + """

TASK B2 — Write ONLY winning pattern pat-011:

pat-011: Max Drawdown Black Swan Catch and Recover
  Two-phase crash response — the only pattern handling both exit AND re-entry:
  Phase 1 EXIT:   if SPY max-drawdown(window=20) > 6%, route to BIL immediately
  Phase 2 ENTRY:  NESTED inside exit branch: if SOXL RSI(window=10) < 30
                  (deeply oversold = crash near bottom) then TQQQ, else BIL
  Evidence: v2 Community ms-004 named "Max Drawdown Black Swan Catcher"
  Confidence: 0.80
  Template (required nested structure):
    if[outer]
      if-child[false, SPY max-drawdown > 6]:
        if[inner]
          if-child[false, SOXL RSI < 30] → asset: TQQQ
          if-child[true/else]            → asset: BIL
      if-child[true/else] → [left empty for generator to fill]

""" + SCHEMA + "\nReturn ONLY a JSON array of exactly 1 pattern with id pat-011."

TASK_C1 = corpus + """

TASK C1 — Write winning patterns pat-012 through pat-015 (4 patterns only):

pat-012: SVXY Triple Crash Guard Compound
  3-part compound: SVXY RSI(10)<31 AND SVXY 1-day cumret<-6% AND TMF max-DD(10)>7%
  Evidence: FNGG ms-001/010/017/019/027/029 (8 mini-strategies), these 3 always appear together
  Confidence: 0.90

pat-013: UVXY Moving Average Return vs VIXM
  moving-average-return on UVXY, window=3, threshold=VIXM (dynamic)
  UVXY MA-return > VIXM = near-term spike accelerating vs sustained vol
  Evidence: FNGG ms-010/040. Both UVXY and VIXM in universe — fully recomposable
  Confidence: 0.82

pat-014: TECS SOXS SQQQ Named Short Basket
  wt-cash-equal with TECS + SOXS + SQQQ (equal weight bear allocation)
  FNGG named SHORT GROUP contains exactly these 3; never use any single one alone
  Evidence: FNGG multiple batches. All 3 in generator universe
  Confidence: 0.88

pat-015: UVXY RSI Overbought Vol Exhaustion Exit
  relative-strength-index on UVXY, threshold=84 → exit vol positions to BIL
  When UVXY RSI > 84: vol spike exhausting, exit before mean-reversion collapse
  Evidence: Sisyphus ms-018 (BSC 2). Fully recomposable
  Confidence: 0.82

""" + SCHEMA + "\nReturn ONLY a JSON array of exactly 4 patterns. IDs: pat-012 to pat-015."

TASK_C2 = corpus + """

TASK C2 — Write winning patterns pat-016 through pat-019 (4 patterns only):

pat-016: SPY MA3 Plus EMA210 Dual Timeframe
  moving-average-price on SPY window=3 PLUS exponential-moving-average-price window=210
  MA(3) confirms recent momentum; EMA(210) confirms macro regime. Both must pass for bull entry
  Evidence: FNGG ms-010 (Unholy VIXation), NOVA Best ms-001
  Confidence: 0.83

pat-017: BND RSI Long Window Bond Stress
  relative-strength-index on BND, window=45, threshold=SPY (dynamic)
  45-day window catches sustained bond stress; distinct from pat-005 (10-day BIL vs IEF)
  Evidence: FNGG ms-041/042/044 with explicit RSI window=45
  Confidence: 0.80

pat-018: TQQQ Extreme Crash Circuit Breaker
  cumulative-return on TQQQ, window=10, threshold=-33
  Fires when crash already severe (distinct from 5.5% entry gate)
  Evidence: NOVA Best ms-033/035. Threshold -33% confirmed in both
  Confidence: 0.80

pat-019: SVXY RSI Bull Health Confirmation
  relative-strength-index on SVXY, window=10, threshold=31 (above = vol-short regime healthy)
  Combined with SVXY 1-day return>-6% as standard pair before vol-short allocation
  Evidence: FNGG ms-017/019/027/029
  Confidence: 0.83

""" + SCHEMA + "\nReturn ONLY a JSON array of exactly 4 patterns. IDs: pat-016 to pat-019."

TASK_D = corpus + """

TASK D — Write 9 losing patterns pat-bad-001 through pat-bad-009:

pat-bad-001: Naked SVXY Hold — SVXY without max-drawdown guard. Volmageddon 2018 = -93%
pat-bad-002: Single Condition Leverage Entry — one condition before leveraged ETF; all high-Sharpe use 3+
pat-bad-003: Bear ETF in Else Branch — SQQQ/SPXS/SOXS/TECS in normal-market else branch; -60-70%/yr decay
pat-bad-004: UPRO SPXL Simultaneous Hold — r=0.98 correlation; no diversification
pat-bad-005: TMF as Equity Hedge — 2022: TMF -70% simultaneously with equities; unreliable post-2022
pat-bad-006: Single Window Vol Signal — using only one vol signal; different crash types trigger different signals first
pat-bad-007: Single Bear ETF Without Basket — holding SQQQ or TECS alone instead of TECS+SOXS+SQQQ basket
pat-bad-008: Fixed Numeric RSI Threshold — RSI>50 instead of dynamic cross-asset RSI comparison
pat-bad-009: Bull Branch Missing TQQQ Gate — leveraged bull branch without TQQQ 5.5% cumulative-return gate

""" + LOSING_SCHEMA + "\nReturn ONLY a JSON array of exactly 9 patterns. IDs: pat-bad-001 to pat-bad-009."

# ── Submit batch ───────────────────────────────────────────────────────────────

def make_request(custom_id, task_prompt, max_tokens):
    return {
        "custom_id": custom_id,
        "params": {
            "model": "claude-opus-4-5",
            "max_tokens": max_tokens,
            "system": SYSTEM,
            "messages": [{"role": "user", "content": task_prompt}],
        }
    }

def submit_batch():
    requests = [
        make_request("task_a_core",     TASK_A, 6000),
        make_request("task_b_vol",      TASK_B, 7000),
        make_request("task_b2_pat011",  TASK_B2, 3000),
        make_request("task_c1_new",     TASK_C1, 5000),
        make_request("task_c2_new",     TASK_C2, 5000),
        make_request("task_d_losing",   TASK_D, 5000),
    ]
    print(f"Submitting batch of {len(requests)} requests to Anthropic Batch API...")
    print("(50% cost reduction vs real-time calls)")

    batch = client.messages.batches.create(requests=requests)
    batch_id = batch.id
    BATCH_ID_PATH.write_text(batch_id)

    input_tokens_est = sum(len(r['params']['messages'][0]['content'])//4 for r in requests)
    print(f"\nBatch submitted: {batch_id}")
    print(f"Status: {batch.processing_status}")
    print(f"Estimated input tokens: ~{input_tokens_est:,}")
    print(f"Estimated cost: ~${input_tokens_est*0.000015 + 25000*0.000075:.2f} (50% batch discount applied)")
    print(f"Batch ID saved to: {BATCH_ID_PATH}")
    print(f"\nResults typically ready in 10-60 minutes.")
    print(f"To fetch results run:")
    print(f"  python3 src/run_opus_synthesis.py --fetch {batch_id}")
    return batch_id

# ── Fetch and process batch results ───────────────────────────────────────────

def fetch_batch(batch_id):
    print(f"Fetching batch: {batch_id}")
    batch = client.messages.batches.retrieve(batch_id)
    print(f"Status: {batch.processing_status}")

    if batch.processing_status != 'ended':
        print(f"Not ready yet. Request counts: {batch.request_counts}")
        print(f"Try again in a few minutes.")
        return False

    print(f"Batch complete. Processing results...")

    results = {}
    for result in client.messages.batches.results(batch_id):
        cid = result.custom_id
        if result.result.type == 'succeeded':
            text = result.result.message.content[0].text.strip()
            stop = result.result.message.stop_reason
            usage = result.result.message.usage
            print(f"  {cid}: {usage.input_tokens}in/{usage.output_tokens}out stop={stop}")
            if stop == 'max_tokens':
                print(f"    WARNING: truncated")
            results[cid] = text
            (PILOT_DIR / f'opus_{cid}.txt').write_text(text)
        else:
            print(f"  {cid}: FAILED — {result.result.type}")
            if hasattr(result.result, 'error'):
                print(f"    Error: {result.result.error}")

    if len(results) < 6:
        print(f"Only {len(results)}/6 tasks succeeded. Check pilot directory for raw files.")
        return False

    return results

def parse_array(raw, label):
    clean = re.sub(r'```(?:json)?\s*', '', raw).strip()
    if not clean.startswith('['):
        s, e = clean.find('['), clean.rfind(']')
        if s != -1 and e > s:
            clean = clean[s:e+1]
    try:
        arr = json.loads(clean)
        print(f"  Parsed {len(arr)} {label}")
        return arr
    except json.JSONDecodeError as err:
        print(f"  FAILED to parse {label}: {err}")
        print(f"  Last 400: {clean[-400:]}")
        return None

def build_patterns_json(results):
    pa  = parse_array(results['task_a_core'],    "patterns A (core priors)")
    pb  = parse_array(results['task_b_vol'],     "patterns B (vol+structure)")
    pb2 = parse_array(results['task_b2_pat011'], "patterns B2 (pat-011)")
    pc1 = parse_array(results['task_c1_new'],    "patterns C1 (new 012-015)")
    pc2 = parse_array(results['task_c2_new'],    "patterns C2 (new 016-019)")
    pc  = (pc1 or []) + (pc2 or [])
    pd  = parse_array(results['task_d_losing'],  "losing patterns")

    if any(x is None for x in [pa, pb, pb2, pc1, pc2, pd]):
        print("One or more tasks failed to parse. Check raw files in kb/pilot/")
        return False

    all_winning = (pa or []) + (pb or []) + (pb2 or []) + (pc or [])
    losing      = pd or []

    for i, p in enumerate(all_winning, 1):
        p['id'] = f'pat-{i:03d}'
    for i, p in enumerate(losing, 1):
        p['id'] = f'pat-bad-{i:03d}'

    result = {
        "version": "1.0",
        "last_updated": datetime.datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ'),
        "last_updated_generation": 0,
        "winning_patterns": all_winning,
        "losing_patterns":  losing,
    }

    with open(OUTPUT_PATH, 'w') as f:
        json.dump(result, f, indent=2)
    size = OUTPUT_PATH.stat().st_size
    print(f"\nSaved: {OUTPUT_PATH} ({size:,} bytes)")

    print(f"\n{'='*65}")
    print(f"WINNING: {len(all_winning)}")
    for p in all_winning:
        conf = p.get('performance', {}).get('confidence', '?')
        gi   = 'GI:✓' if 'generator_instruction' in p else 'GI:✗'
        syms = len(p.get('confirmed_in_symphonies', []))
        print(f"  {p['id']:<12} conf={conf}  {gi}  syms={syms}  {p['name'][:45]}")
    print(f"\nLOSING: {len(losing)}")
    for p in losing:
        print(f"  {p['id']:<14} {p['name']}")
    gi_n = sum(1 for p in all_winning if 'generator_instruction' in p)
    print(f"\nGenerator instructions: {gi_n}/{len(all_winning)}")
    print('='*65)
    return True

# ── Poll until complete ────────────────────────────────────────────────────────

def poll_and_fetch(batch_id, interval=60, max_wait=7200):
    """Poll every `interval` seconds until batch completes or timeout."""
    print(f"\nPolling batch {batch_id} (checking every {interval}s, max {max_wait//60}min)...")
    start = time.time()
    while time.time() - start < max_wait:
        batch = client.messages.batches.retrieve(batch_id)
        status = batch.processing_status
        counts = batch.request_counts
        elapsed = int(time.time() - start)
        print(f"  [{elapsed:4d}s] status={status} | {counts}", flush=True)
        if status == 'ended':
            print("Batch complete — fetching results...")
            return fetch_batch(batch_id)
        time.sleep(interval)
    print(f"Timeout after {max_wait//60} minutes. Run with --fetch {batch_id} later.")
    return False

# ── Main ───────────────────────────────────────────────────────────────────────

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Opus synthesis via Batch API')
    parser.add_argument('--submit',      action='store_true', help='Submit batch only')
    parser.add_argument('--fetch',       type=str, metavar='BATCH_ID', help='Fetch completed batch')
    parser.add_argument('--no-poll',     action='store_true', help='Submit without polling')
    parser.add_argument('--poll-interval', type=int, default=60, help='Poll interval seconds (default 60)')
    args = parser.parse_args()

    if args.fetch:
        results = fetch_batch(args.fetch)
        if results:
            build_patterns_json(results)

    elif args.submit or args.no_poll:
        submit_batch()

    else:
        # Default: submit then poll
        batch_id = submit_batch()
        print()
        results = poll_and_fetch(batch_id, interval=args.poll_interval)
        if results:
            build_patterns_json(results)
