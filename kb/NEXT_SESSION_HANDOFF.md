# OpenClaw — Next Session Handoff
# Written: 2026-04-12 (end of session)

---

## BREAKTHROUGH TODAY

### Inline Backtest API Working
POST /api/v0.1/backtest with {"symphony": {"raw_value": compiled_json}}
- No manual imports needed
- No copy+PUT flow needed  
- Exact match with by-ID results (proven)
- Rate limit: check carefully — 500 req/sec is only for by-ID endpoint

### LOO Analysis Complete (Sisyphus 10 components)
Results saved: kb/pilot/sisyphus_groups/loo_multi_period.json

| Component      | 2022  | 2023  | 2024  | Avg Marginal |
|----------------|-------|-------|-------|--------------|
| em_ftlt        | +0.48 | +0.34 | +0.23 | +0.35 ★      |
| em_emerging    | +0.32 | +0.43 | +0.23 | +0.32 ★      |
| bonds_zoop     | +0.25 | +0.47 | -0.01 | +0.23 ★      |
| hwrt_3         | +0.08 | +0.11 | -0.00 | +0.06        |
| gold           | +0.01 | +0.08 | +0.12 | +0.07        |
| hg_short_only  | +0.02 | -0.12 | +0.00 | -0.03        |
| qqq_ftlt_bonds | +0.30 | -0.18 | -0.27 | -0.05        |
| better_kmlm    | -0.47 | +0.03 | +0.13 | -0.10        |
| four_corners   | -0.18 | -0.15 | -0.03 | -0.12        |
| qqq_ftlt_sma   | +0.03 | -0.29 | -0.11 | -0.13        |

Key insight: Marginal contribution ≠ standalone Sharpe.
Gold (standalone 0.86) contributes +0.07 avg through diversification.
Better KMLM (standalone 1.78 in 2022) drags portfolio by -0.10 due to correlation.

### New API Capabilities Discovered
- POST /api/v0.1/search/symphonies — search entire public database
- GET /api/v0.1/symphonies/{id}/score — fetch any symphony definition
- dvm_capital in backtest response — daily equity curves for correlation analysis
- POST /api/v0.1/symphonies — create and save permanently

---

## TOMORROW'S MAIN TASK

### Write up the Portfolio Component Selection Problem
Run through Claude Opus + competing models to get the framework right
before building the pipeline.

### The Problem Statement

We are building a portfolio of N mini-strategies (equal or inverse-vol weighted).
Each mini-strategy is a Composer symphony group (10-100 lines of logic).
We have a universe of candidate mini-strategies from:
  - Sisyphus (10 components, all extracted)
  - NOVA Best (to be extracted)
  - FNGG (to be extracted)  
  - Beta Baller (to be extracted)
  - Composer public database (to be searched)

Goal: Select the best K components (K=8-12) and optimal weighting
to maximize risk-adjusted returns across multiple market regimes.

### Key Insight
We are NOT selecting for best standalone Sharpe.
We are selecting for best PORTFOLIO CONTRIBUTION.
Gold with Sharpe 0.86 can be more valuable than HWRT 3 with Sharpe 4.07
if Gold is negatively correlated with everything else.

### Proposed Scoring Framework (needs validation)

Tier 1 — Return Generators:
  Sharpe > 2.0 AND correlation_SPY > 0.3
  Best bull market engines
  Keep: highest Sharpe, avoid redundancy with similar strategies

Tier 2 — Crisis Hedges:
  Correlation_SPY < 0.2 AND 2022 Sharpe > 1.5
  Perform when everything else fails
  Keep: most negatively correlated with positive return

Tier 3 — Uncorrelated Alpha:
  Abs(correlation_SPY) < 0.3 AND Sharpe > 1.5
  Rarest and most valuable — add return AND diversification
  Keep: always include

Reject if ALL true:
  Avg Sharpe < 0.5 AND SPY correlation > 0.5 AND 2022 Sharpe < 0

### Open Questions for Opus Review
1. Is the 3-tier framework the right way to think about this?
2. Should we use SPY correlation or portfolio correlation for screening?
   (Portfolio correlation is circular — you need the portfolio to compute it)
3. How do we handle regime-specific correlation?
   (Gold may be uncorrelated in bull markets but highly correlated in crashes)
4. What's the right K (number of components)?
   Sisyphus uses 10 but some are dragging performance
5. Equal weight vs inverse-vol weight vs optimized weight?
   Sisyphus uses equal weight but that may not be optimal
6. How do we prevent overfitting to 2022?
   We need the portfolio to work in 2023/2024 too

### Technical Implementation (after framework is agreed)

Step 1 — Harvest candidates:
  search_symphonies API → filter by basic criteria → fetch definitions
  Extract mini-strategies from NOVA, FNGG, Beta Baller DSL files

Step 2 — Score candidates:
  inline backtest 2021/2022/2023/2024 for each candidate
  Extract: sharpe, maxdd, annret, dvm_capital (daily curves)
  Compute: correlation_SPY, correlation_QQQ from daily curves
  Classify into tiers

Step 3 — Build correlation matrix:
  Pairwise correlation between all candidates using dvm_capital
  Identify redundant pairs (correlation > 0.7)
  Keep only best representative from each correlated cluster

Step 4 — Combination testing:
  Start with top representatives from each tier
  Test combinations with LOO analysis
  Try equal weight and inverse-vol weight
  Measure multi-period Sharpe for each combination

Step 5 — Claude synthesis:
  Feed Opus the full data: correlation matrix, standalone performance,
  marginal contributions, tier classifications
  Ask: propose optimal portfolio composition and weighting
  Validate with inline backtests

---

## KEY FILES ON THEBEAST

Source:
  src/backtest_runner.py — inline backtest working
  src/scorer.py — exponential decay fitness
  src/json_to_dsl_converter.py — 84 tests passing
  src/dsl_compiler.py — 40 tests passing

Data:
  kb/pilot/sisyphus_groups/ — 10 compiled mini-strategy JSONs
  kb/pilot/sisyphus_groups/loo_multi_period.json — LOO results
  kb/pilot/sisyphus.dsl — full Sisyphus DSL (2674 lines)

To extract next:
  NOVA Best: zIMBF3ElL1diBeqo9eg4
  FNGG: n9J6L8weCzu2vAUrMWnm (Extended OOS)
  Beta Baller: vNP5oYsbpV8tS9USqGEL

---

## RATE LIMIT WARNING
Inline backtest (/api/v0.1/backtest) rate limit unclear — may be 1 req/sec.
Add time.sleep(1.1) between calls for safety.
500 req/sec only confirmed for /symphonies/{id}/backtest (by-ID).

---

## FILES TO SYNC TO CLAUDE.AI
Upload before next session:
  src/backtest_runner.py
  src/scorer.py
  kb/pilot/sisyphus_groups/loo_multi_period.json
