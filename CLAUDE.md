# OpenClaw — Claude Code Context

## What this project is
Autonomous trading strategy evolution system for Composer.trade.
Generates, backtests, scores, and learns from trading strategies (symphonies).

## Key paths
- `src/` — all Python source files
- `kb/` — knowledge base (patterns, lessons, graveyard, lineage)
- `kb/pilot/` — reference DSL files (sisyphus.dsl, nova_best.dsl, beta_baller.dsl)
- `kb/patterns_dsl/` — DSL fragment library (in progress)
- `~/.openclaw/composer-credentials.json` — API credentials

## Architecture
- `dsl_compiler.py` — DSL → JSON (39+ tests passing)
- `json_to_dsl_converter.py` — JSON → DSL (84 tests passing)
- `context_builder.py` — assembles Generator prompts
- `generator_agent.py` — calls Claude to generate strategies
- `backtest_runner.py` — runs backtests via Composer API
- `learner_agent.py` — extracts lessons from results

## DSL pipeline (proven end-to-end)
Natural language → Composer AI DSL → dsl_compiler.py → JSON
→ import to Composer UI → save → backtest by ID → results

## Critical constraints
- PUT endpoint silently ignores changes — always import manually via UI
- Backtest always runs live/deployed version of a symphony
- Asset nodes must NOT have children field (Composer rejects it)
- if-child nodes need collapsed?=False field
- rhs-fixed-value?=True always wins over rhs-fn (even if both present)

## Reference symphonies
- Sisyphus: qjRIwrAOA1YzFSghM08b (2022 Sharpe 5.21, MaxDD 7.8%)
- NOVA Best: zIMBF3ElL1diBeqo9eg4 (2022 Sharpe 6.40, MaxDD 4.7%)
- Beta Baller: vNP5oYsbpV8tS9USqGEL (2022 Sharpe 4.55, MaxDD 18.2%)

## Current state (as of 2026-04-10)
- DSL round-trip proven on Sisyphus and NOVA (exact backtest match)
- patterns.json has 19 winning + 9 losing patterns (JSON format, needs DSL conversion)
- active.json has 40 lessons
- Next: convert portfolio sample to DSL, rebuild KB in DSL format

## Run tests
cd ~/.openclaw/workspace/learning
python3 src/test_json_to_dsl.py     # 84 tests
python3 src/dsl_compiler.py         # 40 tests
