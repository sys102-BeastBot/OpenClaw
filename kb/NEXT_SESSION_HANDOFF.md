# OpenClaw — Next Session Handoff
# Written: 2026-04-10 (end of session)
# Author: Claude, reviewed with Sherman

---

## SYSTEM STATE — WHAT IS PROVEN AND WORKING

### Round-trip pipeline (fully proven)
```
Symphony JSON → json_to_dsl_converter.py → DSL
→ dsl_compiler.py → JSON → import Composer UI → save → backtest by ID
```

Round-trip backtest results (exact match = logic preserved):
| Symphony | Sharpe | MaxDD | AnnRet | Status |
|---|---|---|---|---|
| Sisyphus | 5.21 | 7.8% | 337.6% | ✓ CLEAN |
| NOVA Best | 6.40 | 4.7% | 1019.1% | ✓ CLEAN |
| 01 s90 50/40 maxDD | 3.15 | 24.9% | 351.9% | ✓ CLEAN |
| Combined Wild West | 1.14 | 15.0% | 27.5% | ✓ CLEAN |
| Extended OOS FNGG | 4.72 | 6.9% | 358.6% | ✓ CLEAN |
| Beta Baller | ✗ diverges | — | — | Exotic tickers |

### Generation pipeline (working, bugs fixed)
```
context_builder.py → DSL prompt → Claude → DSL → dsl_compiler.py
→ JSON → logic_auditor.py → pending/ → import Composer → backtest
```

Gen-0 results:
| Attempt | Status | Sharpe 2022 | Issue |
|---|---|---|---|
| strat-01 | DISQUALIFIED | 0.10 | No vol profit layer |
| strat-03 | DISQUALIFIED | — | Auditor false positive (fixed) |
| strat-04 | PENDING | -1.81 | Dip-buying in bear market |
| strat-05+ | Blocked | — | Anthropic API 500 errors |

---

## KEY FILES ON THEBEAST (current state)

### Source files (all updated today)
- `src/json_to_dsl_converter.py` — 84 tests passing ✓
- `src/dsl_compiler.py` — 40 tests passing ✓ (compound condition fix, decimal weights)
- `src/context_builder.py` — DSL-based prompts, 10 fragments, RULE 11 (UVXY mandatory)
- `src/generator_agent.py` — outputs DSL, compiles to JSON, writes to pending/
- `src/logic_auditor.py` — tightened crash guard detection (window/asset/threshold)
- `src/kb_writer.py` — unchanged

### KB files
- `kb/patterns_dsl/guards/` — 17 DSL fragments (pat-001 to pat-022)
- `kb/patterns_dsl/allocation/` — 3 DSL fragments (pat-006, pat-014, pat-023)
- `kb/patterns_dsl/selection/` — 2 DSL fragments (pat-002, pat-013)
- `kb/patterns_dsl/anti_patterns/` — 9 DSL fragments (pat-bad-001 to pat-bad-009)
- `kb/patterns.json` — 23 winning + 9 losing patterns (updated with pat-020 to pat-023)
- `kb/lessons/active.json` — 41 active lessons (lesson-gen0-001 added)
- `kb/portfolio_dsl/` — 8 portfolio symphonies as DSL files
- `kb/community_watchlist.json` — 29 community strategies with 2022 backtest results
- `kb/pilot/sisyphus.dsl` — canonical reference DSL
- `kb/pilot/nova_best.dsl` — canonical reference DSL
- `kb/pilot/beta_baller.dsl` — canonical reference DSL (approximate)

### Pending strategies
- `pending/gen-000-strat-01.json` — Test Direct Write (ignore)
- `pending/gen-000-strat-03.json` — DISQUALIFIED (auditor false positive, ignore)
- `pending/gen-000-strat-04.json` — PENDING (Sharpe -1.81, no vol profit)

### Reference symphony IDs
- Sisyphus: `qjRIwrAOA1YzFSghM08b` (2022 Sharpe 5.21)
- NOVA Best: `zIMBF3ElL1diBeqo9eg4` (2022 Sharpe 6.40)
- Gen-0 strat-04: `Q0RMA1paDyFv8nYK51Qq` (2022 Sharpe -1.81, for learner)
- Gen-0 attempt 1: `GpuJBtRQaTwPxyJRJhlF` (2022 Sharpe 0.10, for learner)

---

## BUGS FIXED TODAY

1. **json_to_dsl_converter.py — rhs-fixed-value?=True wins over rhs-fn**
   Nodes with both fields present were treating numeric constants as tickers.

2. **json_to_dsl_converter.py — asset nodes must NOT have collapsed? field**
   Composer rejects asset nodes with collapsed? — was causing all saves to fail.

3. **json_to_dsl_converter.py — rebalance-corridor-width preserved via merge_from_original**
   NOVA-type symphonies need this field or Composer rejects the import.

4. **json_to_dsl_converter.py — decimal weights preserved in wt-cash-specified**
   19.59% was being truncated to 19%, causing weights to not sum to 100.

5. **dsl_compiler.py — nested compound conditions (or (or A B C) D) flattened correctly**
   Sub-conditions with both _binary and _compound keys now prefer _compound.

6. **logic_auditor.py — _has_max_drawdown_condition too broad**
   max-drawdown(SPY, 20) > 6% was treated as crash guard. Now requires
   window ≤ 5 OR crash asset (SVXY/UVXY/etc) OR threshold > 15%.

7. **logic_auditor.py — _leveraged_in_defensive_branch walked full subtree**
   Was flagging TQQQ anywhere below a crash guard, even in nested bull branches.
   Now only checks IMMEDIATE children of crash guard true branch.
   Also split _CRASH_ASSETS into drawdown set vs signal set (SOXL RSI dropping
   ≠ crash guard).

8. **generator_agent.py — write_strategy_file missing stage='pending'**
   Quarantine paths weren't writing to disk. All 3 calls now have stage='pending'.

9. **generator_agent.py — disqualification_reason hardcoded as 'INVALID_JSON'**
   Now shows actual audit failures: 'AUDIT_FAILURE: {failures}'.

---

## THE CORE INSIGHT — WHY GEN-0 FAILS

Generated strategies score near zero in 2022 because they only AVOID bear
markets (routing to BIL). Sisyphus PROFITS from bear markets via UVXY.

**The gap:** Sisyphus has 61 UVXY profit paths. Gen-0 has zero.

**The fix (in KB now):** pat-020 through pat-023 are UVXY profit patterns.
RULE 11 in HARD_RULES mandates a vol profit layer.

**Expected structure of a good strategy:**
```
crash_guard (SVXY/UVXY failing) → BIL
  else →
    UVXY RSI(21) > 65? → UVXY (vol profit in bear regime)
    else →
      SPY > EMA(210)? → bull allocation (TQQQ/SOXL/TECL)
      else → BIL
```

---

## NEXT SESSION TASKS (in order)

### Task 1 — Complete generation run (immediate)
The API 500 errors stopped us. Resume with:
```bash
cd ~/.openclaw/workspace/learning && python3 - << 'PYEOF'
import sys, json
sys.path.insert(0, 'src')
from generator_agent import run_generator_agent
from pathlib import Path

auth = json.loads((Path.home() / '.openclaw/agents/security/agent/auth-profiles.json').read_text())
anthropic_key = auth['profiles']['anthropic:default']['key']

result = run_generator_agent(
    archetype='SHARPE_HUNTER', generation=0, slot_number=5,
    parent_ids=[], anthropic_key=anthropic_key
)

status = result.get('pipeline', {}).get('current_status') if result else 'None'
dsl    = result.get('raw_dsl', '') if result else ''
print(f"Status: {status}")
print(f"Has UVXY profit: {'EQUITIES::UVXY' in dsl}")
print(f"IF count: {dsl.count('(if ')}")
print(dsl)
PYEOF
```

Expect: UVXY in the DSL, audit PASS, import to Composer, backtest vs Sisyphus.

### Task 2 — Add tree metrics to strategy file
Track per-generation: max_depth, avg_depth, leaf_count, unique_conditions.
Add to `_build_strategy_file` in generator_agent.py:
```python
def _compute_tree_metrics(composer_json: dict) -> dict:
    # Walk tree, compute: max_depth, leaf_count, unique_conditions
    # Return dict stored in strategy_file['summary']['tree_metrics']
```

### Task 3 — Run learner agent on gen-0 results
Process pending/ strategies through learner_agent.py.
Extract lessons from failures, add to active.json.
Key lesson to extract: "no vol profit layer = near-zero 2022 Sharpe"

### Task 4 — Run generation 1 (with learner feedback)
After learner processes gen-0, run gen-1 with enriched lessons.
Expect deeper trees, UVXY profit paths, better 2022 Sharpe.

### Task 5 — Community watchlist conversion (optional, later)
Top 2 candidates worth converting to DSL for KB:
- "Tame the Beta Baller WM 74": `v9ueglUdSu8Ei2HizAfG` (Sharpe 5.09, DD 12.6%)
- "10 day Oversold Block": `aIBl5xshv8S2CyuaeBkD` (Sharpe 4.88, DD 0.1%)
Criteria for KB inclusion: 2022 Sharpe ≥ 3.0, MaxDD ≤ 25%, novel concepts.

---

## FILES TO SYNC TO CLAUDE.AI PROJECT

Upload these to replace outdated project files:
1. `src/json_to_dsl_converter.py` — major updates (decimal weights, collapsed? fix)
2. `src/dsl_compiler.py` — compound condition fix
3. `src/logic_auditor.py` — tightened crash guard detection
4. `src/generator_agent.py` — DSL output, write fixes
5. `src/context_builder.py` — DSL prompts, UVXY fragments, RULE 11

```bash
for f in json_to_dsl_converter dsl_compiler logic_auditor generator_agent context_builder; do
  cp ~/.openclaw/workspace/learning/src/${f}.py \
     "/mnt/c/Users/sys10/Downloads/${f}.py"
done
echo "Done"
```

---

## HOW TO START NEXT SESSION

Tell Claude.ai:
"Starting new OpenClaw session. Files synced. Resume from NEXT_SESSION_HANDOFF.md.
First task: run generation slot-5 and see if UVXY profit layer appears."

Tell Claude Code:
"Read CLAUDE.md. Run generation slot-5 for SHARPE_HUNTER gen-0.
Check if UVXY appears in the DSL as a profit path (not just a crash guard).
If audit passes, save compiled JSON to kb/pilot/gen0_strat05.json."

---

## UPDATE: 2026-04-10 Late Session — Generation Results

### Gen-0 backtest progression (2022 Sharpe)
| Strategy | Sharpe | MaxDD | Key change |
|---|---|---|---|
| strat-04 | -1.81 | 41.2% | No vol profit layer |
| strat-05 | -2.18 | 39.7% | Crude UVXY RSI>65 entry |
| strat-06 | -2.77 | 43.8% | UVXY band + OR guard (still bad) |
| strat-07 | -0.02 | 19.6% | Sisyphus DSL as parent ← big jump |

### Key insight: template-guided generation
Showing Claude 150 lines of Sisyphus DSL as a parent halved MaxDD and nearly
broke even in one step. The "19 blocks to build the car" approach is the path forward.

### Next session priority 1: template-guided generation
Instead of free-form generation, pass Sisyphus DSL excerpt as parent AND add
explicit instruction: "Use these building blocks to assemble something structurally
similar to the parent — same depth, same vol profit architecture, but with your
own parameter choices and variations."

Expected outcome: strategies in 1.0-3.0 Sharpe range within 2-3 generations.

### New symphony IDs (gen-0)
- strat-04: Q0RMA1paDyFv8nYK51Qq (Sharpe -1.81)
- strat-05: iIVYDrEFoxpJHy2ZwC4I (Sharpe -2.18)
- strat-06: cEXQlmcovlwmS5LPtVWC (Sharpe -2.77)
- strat-07: 6Ku1yaOmIS8ojIvC1H6H (Sharpe -0.02) ← best gen-0

### Files to sync to claude.ai project (updated again today)
- src/logic_auditor.py — tightened crash guard + immediate-child-only check
- src/generator_agent.py — DSL output, write fixes, correct disqualification reason
- src/context_builder.py — UVXY patterns, RULE 11, 10 fragments
- kb/lessons/active.json — 43 lessons (gen-0 lessons added)
