"""
recover_opus.py — Recover from partial batch success.

Loads already-parsed results from raw files saved in kb/pilot/,
then runs only the failed tasks (C2 and D) as direct synchronous
calls with higher token limits.

Usage: python3 src/recover_opus.py
"""
import json, re, sys, time, datetime
from pathlib import Path

HOME       = Path.home()
LEARN_ROOT = HOME / '.openclaw' / 'workspace' / 'learning'
PILOT_DIR  = LEARN_ROOT / 'kb' / 'pilot'
OUTPUT     = LEARN_ROOT / 'kb' / 'patterns_opus.json'
AUTH_PATH  = HOME / '.openclaw' / 'agents' / 'security' / 'agent' / 'auth-profiles.json'
CORPUS     = (LEARN_ROOT / 'src' / 'opus_synthesis_prompt.txt').read_text()

with open(AUTH_PATH) as f:
    api_key = json.load(f)['profiles']['anthropic:default']['key']

import anthropic
client = anthropic.Anthropic(api_key=api_key)

SYSTEM = (
    "You are a quantitative strategy architect producing a JSON pattern library. "
    "Output ONLY a valid JSON array. Start with [ end with ]. "
    "No preamble, no explanation, no markdown fences. "
    "Complete every object fully — never truncate mid-string."
)

SCHEMA = (LEARN_ROOT / 'src' / 'opus_synthesis_prompt.txt').read_text()
# Extract just the schema section (reuse from prompt)

def parse_array(raw, label):
    clean = re.sub(r'```(?:json)?\s*', '', raw).strip()
    if not clean.startswith('['):
        s, e = clean.find('['), clean.rfind(']')
        if s != -1 and e > s:
            clean = clean[s:e+1]
    try:
        arr = json.loads(clean)
        print(f"  ✓ Parsed {len(arr)} {label}")
        return arr
    except json.JSONDecodeError as err:
        print(f"  ✗ FAILED {label}: {err}")
        print(f"  Last 300: {clean[-300:]}")
        return None

def direct_call(task_prompt, label, max_tokens):
    """Synchronous call — no batch, immediate response."""
    print(f"\n{label} (max_tokens={max_tokens}, direct call)...")
    t0 = time.time()
    m = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=max_tokens,
        system=SYSTEM,
        messages=[{"role": "user", "content": CORPUS + "\n\n" + task_prompt}]
    )
    elapsed = time.time() - t0
    u = m.usage
    stop = m.stop_reason
    print(f"  {elapsed:.1f}s | {u.input_tokens}in/{u.output_tokens}out | stop={stop}")
    if stop == 'max_tokens':
        print(f"  !! STILL TRUNCATED — need to split further")
    raw = m.content[0].text.strip()
    (PILOT_DIR / f'opus_recover_{label}.txt').write_text(raw)
    return raw

# ── Load already-successful results from raw files ────────────────────────────
print("Loading successful results from saved raw files...")

def load_raw(filename, label):
    path = PILOT_DIR / filename
    if path.exists():
        raw = path.read_text()
        result = parse_array(raw, label)
        if result:
            return result
    print(f"  ✗ {filename} not found or failed")
    return None

pa  = load_raw('opus_task_a_core.txt',    'patterns A')
pb  = load_raw('opus_task_b_vol.txt',     'patterns B')
pb2 = load_raw('opus_task_b2_pat011.txt', 'patterns B2')
pc1 = load_raw('opus_task_c1_new.txt',    'patterns C1')

if any(x is None for x in [pa, pb, pb2, pc1]):
    print("\nSome base results missing. Check pilot directory.")
    sys.exit(1)

print(f"\nLoaded: {len(pa)} + {len(pb)} + {len(pb2)} + {len(pc1)} = {len(pa)+len(pb)+len(pb2)+len(pc1)} winning patterns so far")

# ── Re-run C2 (pat-016 to pat-019) — split into 2 calls of 2 if needed ────────

SCHEMA_BLOCK = """
Each pattern object (ALL fields required):
{
  "id": "pat-NNN", "name": "...", "category": "guard|selection|allocation|weighting",
  "times_seen": 0, "first_seen_generation": null, "last_seen_generation": null,
  "performance": {"avg_fitness_with": null, "avg_fitness_without": null, "fitness_boost": null, "confidence": 0.0},
  "applicability": {"archetypes": [], "regimes_effective": [], "regimes_less_effective": [], "regime_note": "..."},
  "description": "...", "usage_note": "...",
  "generator_instruction": "Generator: [direct actionable command referencing Composer JSON fields]",
  "confirmed_in_symphonies": [],
  "base_parameters": {"_basis": "...", "_confidence": 0.0},
  "archetype_overrides": {},
  "template": {"step": "if", "children": [...]},
  "lineage": {"source": "research_phase", "derived_from": [], "first_strategy_id": null}
}"""

# Split C2 into two calls: pat-016+017, then pat-018+019
TASK_C2a = f"""
Write ONLY patterns pat-016 and pat-017 (2 patterns):

pat-016: SPY MA3 Plus EMA210 Dual Timeframe
  Core: moving-average-price on SPY window=3 (entry timing) PLUS
        exponential-moving-average-price window=210 (macro regime)
  Both must confirm for bull entry: MA(3) confirms recent momentum,
  EMA(210) confirms 10-month bull regime
  Evidence: FNGG ms-010 (Unholy VIXation), NOVA Best ms-001
  Confidence: 0.83. Both signals use SPY which is in universe.
  generator_instruction: before committing to TIER 1 leveraged allocation,
    require both SPY MA(3) > SPY price AND SPY EMA(210) > SPY price
    as sequential if-child conditions

pat-017: BND RSI Long Window Bond Stress
  Core: relative-strength-index on BND, window=45, threshold=SPY (dynamic)
  45-day RSI catches sustained bond stress (not just spikes like pat-005 10-day)
  When BND RSI > SPY RSI over 45 days: prolonged risk-off rotation underway
  Evidence: FNGG ms-041/042/044 with explicit window=45
  Confidence: 0.80. BND is signal-only asset (not held).
  generator_instruction: add as a secondary bear confirmation: if BND RSI(45) > SPY,
    reduce allocation tier by 1 (e.g. TIER 1 → TIER 2, TIER 2 → TIER 3)

{SCHEMA_BLOCK}
Return ONLY a JSON array of exactly 2 patterns. IDs pat-016 and pat-017."""

TASK_C2b = f"""
Write ONLY patterns pat-018 and pat-019 (2 patterns):

pat-018: TQQQ Extreme Crash Circuit Breaker
  Core: cumulative-return on TQQQ, window=10, threshold=-33
  Fires ONLY when crash is already severe (TQQQ down 33% in 10 days)
  Distinct from the 5.5% entry gate — this is the emergency stop
  Evidence: NOVA Best ms-033/035 (JRT Bear+); -33% threshold in both
  Confidence: 0.80. TQQQ in universe.
  generator_instruction: place as outermost crash guard: if TQQQ cumulative-return(10) < -33,
    exit to BIL immediately, bypassing all other conditions

pat-019: SVXY RSI Bull Health Confirmation
  Core: relative-strength-index on SVXY, window=10, threshold=31
  SVXY RSI > 31 = vol-short regime healthy, safe to allocate to SVXY or SVIX
  Always pair with SVXY 1-day return > -6 as a two-condition health check
  Evidence: FNGG ms-017/019/027/029 — appears as entry gate before vol-short allocation
  Confidence: 0.83. SVXY in universe.
  generator_instruction: before ANY allocation to SVXY or SVIX, add two conditions:
    (1) SVXY RSI(10) > 31 AND (2) SVXY cumulative-return(1) > -6.
    Both must pass. If either fails, route to BIL instead of vol-short assets.

{SCHEMA_BLOCK}
Return ONLY a JSON array of exactly 2 patterns. IDs pat-018 and pat-019."""

raw_c2a = direct_call(TASK_C2a, "C2a_pat016_017", max_tokens=4000)
pc2a = parse_array(raw_c2a, "patterns C2a (016-017)")

raw_c2b = direct_call(TASK_C2b, "C2b_pat018_019", max_tokens=4000)
pc2b = parse_array(raw_c2b, "patterns C2b (018-019)")

pc2 = (pc2a or []) + (pc2b or [])
if len(pc2) < 4:
    print(f"WARNING: only got {len(pc2)}/4 new patterns from C2")

# ── Re-run D (losing patterns) — split into 2 calls of 5+4 ───────────────────

LOSING_SCHEMA = """
Each losing pattern (ALL fields required):
{"id": "pat-bad-NNN", "name": "...", "category": "...", "times_seen": 0,
 "confidence": 0.0, "description": "...", "why_it_fails": "...",
 "historical_evidence": ["..."], "never_do": "Never...",
 "lineage": {"source": "research_phase", "derived_from": []}}"""

TASK_Da = f"""
Write ONLY losing patterns pat-bad-001 through pat-bad-005 (5 patterns):

pat-bad-001: Naked SVXY Hold
  SVXY without outer max-drawdown guard. Volmageddon Feb 5 2018 = -93% intraday.
  Never hold SVXY without max-drawdown(window=2) > 10 as outermost condition.
  Confidence: 0.99

pat-bad-002: Single Condition Leverage Entry
  Routing to TQQQ/SOXL/TECL/SPXL/UPRO based on only one condition.
  All 5 research symphonies (202 mini-strategies) chain 3+ conditions.
  A single condition cannot distinguish regime types; fires on bear rallies.
  Confidence: 0.92

pat-bad-003: Bear ETF in Else Branch
  SQQQ/SPXS/SOXS/TECS in the else (normal market) branch.
  Decay -60-70% annually in bull markets. SQQQ lost -70% in 2023 alone.
  Requires explicitly confirmed bearish signal, not just absence of bullish.
  Confidence: 0.95

pat-bad-004: UPRO SPXL Simultaneous Hold
  Pearson r=0.98. No diversification. Wastes two allocation slots on one exposure.
  Same restriction applies to TQQQ+TECL (r=0.94) and TQQQ+SOXL (r=0.92).
  Confidence: 0.98

pat-bad-005: TMF as Equity Hedge
  2022: TMF -70% simultaneously with equities during Fed rate hikes.
  Bond-equity negative correlation is regime-dependent; unreliable post-2022.
  TMF is signal-only (condition asset), never a safe-haven holding.
  Confidence: 0.88

{LOSING_SCHEMA}
Return ONLY a JSON array of exactly 5 patterns. IDs pat-bad-001 to pat-bad-005."""

TASK_Db = f"""
Write ONLY losing patterns pat-bad-006 through pat-bad-009 (4 patterns):

pat-bad-006: Single Window Vol Signal
  Using only one volatility signal (e.g. only SVXY drawdown OR only VIXY spike).
  Different crash types trigger different signals first: Volmageddon triggers SVXY,
  2022 rate shock triggers bond signals first, COVID triggers UVXY spike.
  All 5 research symphonies use 2+ independent vol/stress signals.
  Confidence: 0.85

pat-bad-007: Single Bear ETF Without Short Basket
  Holding SQQQ, TECS, or SOXS alone instead of the confirmed 3-asset basket.
  FNGG has named SHORT GROUP with exactly TECS+SOXS+SQQQ equal-weight.
  Individual bears have higher decay and concentration risk than the basket.
  Confidence: 0.87

pat-bad-008: Fixed Numeric RSI Threshold
  Using RSI > 50 (fixed number) instead of RSI(asset_A) vs RSI(asset_B).
  All 5 symphonies use dynamic cross-asset RSI: BIL vs IEF, IEF vs PSQ,
  IGIB vs SPY, SVXY vs threshold 31. Fixed thresholds fail as regimes shift.
  Confidence: 0.83

pat-bad-009: Bull Branch Missing TQQQ Gate
  Routing to leveraged bulls without TQQQ 5.5% cumulative-return confirmation.
  This gate appeared in 11/55 FNGG + multiple other symphonies across all 5.
  0 of 202 mini-strategies route to 3x leveraged bulls without this gate.
  Strategies without it enter on bear rallies and suffer severe drawdown.
  Confidence: 0.90

{LOSING_SCHEMA}
Return ONLY a JSON array of exactly 4 patterns. IDs pat-bad-006 to pat-bad-009."""

raw_da = direct_call(TASK_Da, "Da_losing_1to5", max_tokens=4000)
pda = parse_array(raw_da, "losing 001-005")

raw_db = direct_call(TASK_Db, "Db_losing_6to9", max_tokens=3000)
pdb = parse_array(raw_db, "losing 006-009")

pd = (pda or []) + (pdb or [])
if len(pd) < 9:
    print(f"WARNING: only got {len(pd)}/9 losing patterns")

# ── Assemble final result ─────────────────────────────────────────────────────
all_winning = pa + pb + pb2 + pc1 + pc2
all_losing  = pd

# Enforce sequential IDs
for i, p in enumerate(all_winning, 1):
    p['id'] = f'pat-{i:03d}'
for i, p in enumerate(all_losing, 1):
    p['id'] = f'pat-bad-{i:03d}'

result = {
    "version": "1.0",
    "last_updated": datetime.datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ'),
    "last_updated_generation": 0,
    "winning_patterns": all_winning,
    "losing_patterns":  all_losing,
}

with open(OUTPUT, 'w') as f:
    json.dump(result, f, indent=2)
size = OUTPUT.stat().st_size
print(f"\n✓ Saved: {OUTPUT} ({size:,} bytes)")

print(f"\n{'='*65}")
print(f"WINNING: {len(all_winning)}")
for p in all_winning:
    conf = p.get('performance', {}).get('confidence', '?')
    gi   = 'GI:✓' if 'generator_instruction' in p else 'GI:✗'
    syms = len(p.get('confirmed_in_symphonies', []))
    print(f"  {p['id']:<12} conf={conf:<5}  {gi}  syms={syms}  {p['name'][:45]}")
print(f"\nLOSING: {len(all_losing)}")
for p in all_losing:
    conf = p.get('confidence', '?')
    print(f"  {p['id']:<14} conf={conf}  {p['name']}")
gi_n = sum(1 for p in all_winning if 'generator_instruction' in p)
print(f"\nGenerator instructions: {gi_n}/{len(all_winning)}")
print('='*65)
