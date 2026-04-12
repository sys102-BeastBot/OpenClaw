# OpenClaw — Next Session Handoff
# Written: 2026-04-11 (end of session)
# Author: Claude, reviewed with Sherman

---

## SYSTEM STATE — WHAT IS PROVEN AND WORKING

### Round-trip pipeline (fully proven)
```
Symphony JSON → json_to_dsl_converter.py → DSL
→ dsl_compiler.py → JSON → import Composer UI → save → backtest by ID
```

### Generation pipeline (working end-to-end)
```
context_builder.py → DSL prompt → Claude Opus → DSL → dsl_compiler.py
→ JSON → logic_auditor.py → pending/ → import Composer → backtest
```

### Gen-0 backtest progression (2022 Sharpe)
| Strategy | Sharpe | MaxDD | Key change |
|---|---|---|---|
| strat-04 | -1.81 | 41.2% | No vol profit layer |
| strat-05 | -2.18 | 39.7% | Crude UVXY RSI>65 |
| strat-06 | -2.77 | 43.8% | UVXY band + OR guard |
| strat-07 | -0.02 | 19.6% | 150-line Sisyphus parent ← best |
| strat-08 | -1.98 | 78.7% | Full Sisyphus (2674 lines) — worse |

**Key finding:** 150 lines of Sisyphus as parent is the sweet spot.
Full DSL overwhelms the generator — it pattern-matches instead of innovating.

---

## KEY FILES ON THEBEAST

### Source files
- `src/json_to_dsl_converter.py` — 84 tests passing ✓
- `src/dsl_compiler.py` — 40 tests passing ✓
- `src/context_builder.py` — DSL prompts, 10 fragments, RULE 11, Sisyphus parent
- `src/generator_agent.py` — Opus model, DSL output, 16K tokens
- `src/logic_auditor.py` — tightened crash guard detection
- `src/learner_agent.py` — NEEDS SCORING PIPELINE before it can be trusted

### KB state
- `kb/lessons/active.json` — 43 lessons (manually curated, trustworthy)
- `kb/patterns_dsl/` — 28 fragments (guards/allocation/selection/anti_patterns)
- `kb/patterns.json` — 23 winning + 9 losing patterns
- `kb/community_watchlist.json` — 29 community strategies with 2022 backtest results
- `kb/pending/` — 7 strategy files (5 scored, 1 disqualified, 1 test)

### Reference IDs
- Sisyphus: `qjRIwrAOA1YzFSghM08b` (2022 Sharpe 5.21)
- NOVA Best: `zIMBF3ElL1diBeqo9eg4` (2022 Sharpe 6.40)
- Best gen-0: `6Ku1yaOmIS8ojIvC1H6H` (strat-07, Sharpe -0.02)

### Credential fix (IMPORTANT)
The correct Anthropic API key is in:
  `~/.openclaw/agents/main/agent/auth-profiles.json`
NOT in security/agent/auth-profiles.json (had old key, now synced).
Verify at start of every session:
```bash
python3 -c "
import json, requests
from pathlib import Path
auth = json.loads((Path.home() / '.openclaw/agents/security/agent/auth-profiles.json').read_text())
key = auth['profiles']['anthropic:default']['key']
r = requests.post('https://api.anthropic.com/v1/messages',
    headers={'x-api-key': key, 'anthropic-version': '2023-06-01', 'content-type': 'application/json'},
    json={'model': 'claude-sonnet-4-5', 'max_tokens': 5, 'messages': [{'role': 'user', 'content': 'hi'}]},
    timeout=10)
print('Key OK' if r.status_code == 200 else f'Key FAILED: {r.status_code}')
"
```

### GitHub
Repo: https://github.com/sys102-BeastBot/OpenClaw.git
Commit at end of every session: `git add -A && git commit -m "description" && git push`

---

## THREE THINGS NEEDED BEFORE LOOP CAN SELF-SUSTAIN

### Problem 1 — No scoring pipeline (CRITICAL)
The learner needs composite_fitness scores to extract meaningful lessons.
Currently all strategies have null fitness → learner hallucinates.

Fix: Add scorer.py:
```python
def score_strategy(sharpe, maxdd_pct):
    if sharpe <= 0:
        return sharpe
    return sharpe * max(0, 1 - maxdd_pct / 50)
```
Store in strategy_file['summary']['final_composite_fitness']
and strategy_file['nominal_result']['composite_fitness']['score']

### Problem 2 — Strategies too shallow (IMPORTANT)
Best gen-0 has 10 IF branches. Sisyphus has ~386. Gap is 40x.
Add RULE 12 to HARD_RULES:
"Your strategy must have minimum 8 nested if levels and at least 15 IF
branches total. Shallow strategies (< 6 IF levels) consistently underperform."

### Problem 3 — No parent mutation loop
Gen-0 uses fixed Sisyphus parent. Gen-1 should use best gen-0 as parent.
Fix: In run_generation(), find best pending strategy by Sharpe and pass as parent.

---

## NEXT SESSION TASKS (in order)

1. Verify API key works (credential check above)
2. Add scorer.py — simple fitness formula, score the 5 gen-0 strategies
3. Add RULE 12 — depth requirement to HARD_RULES
4. Run gen-1 with strat-07 (Sharpe -0.02) as parent — expect deeper trees
5. Run learner on scored gen-1 results — verify no hallucination
6. Commit everything to GitHub

---

## WHAT WE LEARNED TODAY

1. 150 lines of parent DSL > full DSL — sweet spot for context
2. OR crash guards > AND crash guards — AND rarely fires in gradual bears
3. UVXY RSI band (74-84) > simple RSI>65 — avoids buying vol at exhaustion
4. Learner needs real fitness scores — null fitness = hallucinated lessons
5. Manual lessons outperform learner for now — curate manually until scoring works
6. GitHub connected — repo at sys102-BeastBot/OpenClaw
7. Credential management — main/agent/auth-profiles.json is canonical key source
8. Full Sisyphus DSL as parent hurts — 78% MaxDD vs 19% with 150 lines

---

## FILES TO SYNC TO CLAUDE.AI PROJECT

Upload these 5 files (all updated today):
- src/context_builder.py — Sisyphus parent, RULE 11, 10 fragments
- src/generator_agent.py — Opus, 16K tokens, DSL output
- src/logic_auditor.py — tightened crash guard
- src/json_to_dsl_converter.py — decimal weights, collapsed? fixes
- src/dsl_compiler.py — compound condition fix

```bash
for f in context_builder generator_agent logic_auditor json_to_dsl_converter dsl_compiler; do
  cp ~/.openclaw/workspace/learning/src/${f}.py \
     "/mnt/c/Users/sys10/Downloads/${f}.py"
done
echo "Ready to upload"
```
