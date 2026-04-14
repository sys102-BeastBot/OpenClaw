# OpenClaw — Key Learnings
*Sessions: April 12–13, 2026*

---

## 1. The Core Philosophy — Why This Works

### Uncorrelation Is Everything
Combining uncorrelated mini-strategies produces portfolio Sharpe far exceeding any individual component. Sisyphus original (10 components, avg Sharpe 5.23) — best standalone component was only 4.07. The whole is greater than the sum of its parts.

This validates Dalio's All Weather principle applied to algorithmic trading: each strategy has an environmental bias. Equal weight across genuinely uncorrelated strategies captures all regimes simultaneously — without prediction.

### Confirmed by Enders Capital
Enders Capital runs 18 live models simultaneously at equal weight, spanning equities, commodities, volatility, emerging markets, gold. Targets: inter-strategy correlation below 50%, SPY beta below 1.0, max drawdown never more than 10% — achieved through uncorrelation, not stop losses.

Their warning on AI-generated strategies: "You'll take AI and say make an algorithm and AI will spit out correlated scenarios... it'll have no sense into how it actually trades market conditions. It'll just be coincidences that happen through time." This is why starting with community-validated strategies and extracting their mini-components is more reliable than generating strategies from scratch.

---

## 2. Replace / Add / Skip Framework

The single most important framework. Apply to every new candidate:

### REPLACE
Candidate is correlated with an existing component AND has meaningfully better Sharpe AND/OR return.
- Threshold: Sharpe improvement >0.5 with return within -10%, OR return improvement >50% with Sharpe within -0.3
- Always test by running the actual portfolio swap — standalone improvement does not guarantee portfolio improvement

### ADD
Candidate is genuinely uncorrelated (avg stress-weighted correlation <0.20) AND adds standalone value (Sharpe >2.0, avg return >100%).
- Do not add low-return diversifiers — they dilute compounding without proportional benefit
- Example that passed: natural_gas (-0.084 avg stress-weighted corr, 172% return)
- Example that failed: almost_pure_cash (Sharpe 6.53 but only 20% return)

### SKIP
Either: correlated AND weaker than the component it resembles. Or: uncorrelated but return too low.

### The Critical Lesson — Standalone Does Not Equal Portfolio
A strategy that beats another in standalone testing can still hurt the portfolio when substituted, because portfolio contribution depends on the full correlation matrix.

Proof: sis_opt_serenity beats hwrt_3 on Sharpe in 4/5 periods standalone. But swapping it in drops avg portfolio Sharpe from 5.94 to 5.58 and doubles MaxDD from 4.8% to 10.0%. hwrt_3's specific correlation pattern with natural_gas provides portfolio-level diversification that sis_opt_serenity does not replicate. Always test the full portfolio swap.

---

## 3. Stress-Weighted Correlation

### Why Normal Correlation Lies
Average normal correlation among Sisyphus components: 0.126.
Average stress correlation (SPY worst decile days): 0.242 — nearly doubles under drawdown.
Correlations spike exactly when you need diversification most.

### The Formula
Sigma_weighted = (1 - lambda) x Sigma_normal + lambda x Sigma_stress
lambda = 0.4

### Key Findings
- EM Emerging + EM ftlt: 0.91 stress correlation — biggest redundancy, but both contribute jointly per LOO. Keep both.
- QQQ cluster (hwrt_3, qqq_ftlt_bonds, qqq_ftlt_sma): spikes to 0.63–0.79 under stress
- Bonds Zoop: near-zero or negative everywhere — true crash airbag
- Natural gas: -0.207 with hwrt_3, -0.233 with qqq_ftlt_bonds — genuine crash buffer

### Why natural_gas Is Irreplaceable (For Now)
After testing 80+ strategies, nothing replaced natural_gas because replacements need BOTH decent standalone performance AND negative/near-zero stress correlation with the QQQ cluster. Most high-Sharpe strategies are positively correlated with equities under stress.

---

## 4. Sharpe vs Return — The Right Tradeoff

At 240–700% annualized returns, optimizing purely for Sharpe at the expense of return is the wrong objective. Only sacrifice return for Sharpe when the drawdown reduction is meaningful (>5% MaxDD improvement), or Sharpe improvement is substantial (>0.5) with minimal return sacrifice (<10%).

### The 60d_bnd_bil Lesson
Adding it to v2: cost 12.9% annualized return for only +0.12 Sharpe. Not worth it. Always model the full tradeoff.

---

## 5. Greedy Forward Selection — The Right Way

### Algorithm
1. Find best single strategy by optimization criterion (Sharpe or Return)
2. Add each remaining candidate one at a time; keep the best improvement
3. Stop when marginal improvement is at or below 0, or K = 10

### The Overfitting Trap
Optimize on 2022–2023, validate on 2024.

K=10: avg Sharpe 6.65 but 2024 Sharpe 4.75 — overfit.
K=7:  avg Sharpe 6.49 but 2024 Sharpe 5.36 — best out-of-sample.

Steps 8–10 added 0.035, 0.016 marginal Sharpe — noise, not signal.

### The Stopping Rule
Stop when marginal improvement drops below 0.10 Sharpe per step, not just when it goes negative.

### Dual Track Results
| Track           | K | Avg Sharpe | Avg Return | MaxDD |
|-----------------|---|------------|------------|-------|
| Sharpe-optimized| 7 | 6.49       | 242%       | 3.9%  |
| Return-optimized| 1 | 3.12       | 700%       | 36.1% |

Return track: every addition reduces better_kmlm's return. Optimal return portfolio is K=1.

---

## 6. Regime Switching — Not Useful For This Portfolio

Tested: SPY 200MA, SPY 60-day return, HYG, UUP, TLT, VIXY. All underperformed equal weight.

Signal lag kills value — a 60-day signal means 60 days of bear market have already passed. The 7 components are already self-regulating across regimes.

One valid exception: HYG 20-day signal reduces MaxDD 9.1% to 8.3% with only -0.09 Sharpe cost. Viable only if drawdown minimization is the explicit primary objective.

---

## 7. Final Portfolios

### Sisyphus v2 — Best Return Balance (8 components)
bonds_zoop, hwrt_3, em_ftlt, gold, qqq_ftlt_bonds, em_emerging, qqq_ftlt_sma, natural_gas_st_trading
Avg Sharpe 5.94 | Avg Return 274.7% | MaxDD 4.8%

### Sisyphus v3 — Best Sharpe + OOS (7 components) — DEPLOYED IN IRA
sis_opt_serenity, combo_10_frankround, spy_ftlt_hedged, natural_gas_st_trading, hwrt_3, em_ftlt, 60d_bnd_bil
Avg Sharpe 6.49 | Avg Return 242% | MaxDD 3.9% | 2024 OOS Sharpe 5.36

### Return Track — better_kmlm standalone
Avg Sharpe 3.12 | Avg Return 700% | MaxDD 36.1%
2022: 234% / 2023: 579% / 2024: 1289%
Allocation: 5% max as a fixed dollar amount you can afford to lose entirely.

### Portfolio Evolution
| Version              | Avg Sharpe | Avg Return | MaxDD | Key Change            |
|----------------------|------------|------------|-------|-----------------------|
| Original Sisyphus(10)| 5.23       | 284.8%     | 7.8%  | Baseline              |
| Optimized v1 (7)     | 5.41       | 281.6%     | 9.1%  | Removed weak slots    |
| v2 (8)               | 5.94       | 274.7%     | 4.8%  | Added natural_gas     |
| v3 (7)               | 6.49       | 242.0%     | 3.9%  | Greedy Sharpe opt     |

---

## 8. Community Mining — What Actually Works

### The Fundamental Limitation
The Composer search API only searches your own portfolio. The only programmatic community search is the Composer MCP tool (requires active session). Without it, the workflow is manual browse + copy.

### The Practical Workflow
1. Browse Composer community manually — look for multi-group portfolios
2. Copy interesting ones to your account
3. Fetch score via GET /api/v0.1/symphonies/{id}/score
4. Scan group depths to find extractable mini-strategies
5. Extract, wrap in standalone root, reassign all UUIDs, backtest
6. Apply replace/add/skip framework

### Signs of a Portfolio Worth Mining
- Name: "Ensemble", "Outliers", "Non-Correlated", "0 Beta", "Uncorrelated"
- Groups at depth 2–5 with 3+ named sub-strategies
- Composer AI Score >3.0

### Themes to Prioritize (for our portfolio)
| Priority | Theme                         | Rationale                      |
|----------|-------------------------------|--------------------------------|
| 1        | Commodity / negative-beta     | Potential natural_gas replace  |
| 2        | Bond rotation / defensive     | Potential 60d_bnd_bil replace  |
| 3        | High-return momentum          | Supplement to return track     |
| 4        | Vol profit                    | Already well covered           |
| 5        | QQQ/TQQQ                      | Saturated                      |

---

## 9. API Reference — Confirmed Working

### Inline Backtest (1 req/sec)
POST /api/v0.1/backtest with symphony.raw_value = compiled JSON
No imports needed. Results match by-ID exactly.

### By-ID Backtest (500 req/sec)
POST /api/v0.1/symphonies/{id}/backtest
Use for strategies in your portfolio — dramatically faster for grid searches.

### Score Endpoint
GET /api/v0.1/symphonies/{id}/score
Returns readable JSON but strips if-child condition fields.

### Critical Schema Rules
- lhs-window-days must be a string, not an integer
- rhs-val must be a string, not a number
- No rhs-fn fields when using fixed values
- is-else-condition? required on if-child nodes
- Always reassign all UUIDs when wrapping extracted group components

### Rate Limit Strategy
- Default: 1 req/sec | By-ID backtest: 500 req/sec
- Safe delays: 1.1–1.5s normally, 2.5s when hitting limits
- Retry: wait 8 x attempt seconds, max 3 retries

---

## 10. Known Bad Strategies — Hard Skip List

| Strategy                    | Why Skip                                          |
|-----------------------------|---------------------------------------------------|
| almost_pure_cash            | Sharpe 6.53 but 20% return — dilutes compounding  |
| IEF Macro Momentum          | Sharpe 14.0 in 2023 is anomaly; -0.10 in 2024    |
| Inflation Protected (BB)    | 4748% return is a data artifact                   |
| DereckN Hedge System        | Declining 3.70→3.00→0.83; breaks in 2024          |
| Rising Rates Vol Switch     | Perfect 2022–2023, zero in 2024 — regime trap     |
| BWC Beta Balls              | UVIX/SVIX — insufficient data history             |
| Oil standalone              | Avg Sharpe 0.03 — essentially flat                |
| numberSeven as add          | +0.03 Sharpe, -2.8% return vs v3 — noise          |
| sis_opt_serenity as swap    | Beats hwrt_3 standalone but hurts portfolio       |

### The Regime Trap Pattern
Sharpe >3.0 in 2022–2023 that collapses to <1.0 in 2024 = capturing a specific macro regime, not a durable edge. Require consistency across all three years.

---

## 11. 5-Year Compounding Model (from $100K)

| Portfolio                        | Year 3  | Year 5  |
|----------------------------------|---------|---------|
| v3 alone (242% ann)              | ~$4M    | ~$47M   |
| 95/5 blend (RT=300% conservative)| ~$4.1M  | ~$49M   |
| 95/5 blend (RT=700% base case)   | ~$5.4M  | ~$74M   |

Practical advice: allocate a fixed dollar amount to the return track, not a portfolio percentage. A 36% drawdown on a fixed $5K is $1,800. The same drawdown on 5% of a growing $1M portfolio is $18,000 and rising.

---

## 12. Deployment Status (April 13, 2026)

| Portfolio          | Status          | File                            |
|--------------------|-----------------|----------------------------------|
| Sisyphus v3 (7)    | LIVE in IRA     | kb/pilot/sisyphus_v3_deployable.json |
| Sisyphus v2 (8)    | Ready to deploy | kb/pilot/sisyphus_v2_deployable.json |
| better_kmlm        | Ready to deploy | kb/pilot/sisyphus_groups/better_kmlm.json |

What to watch at 30 days: v3 live Sharpe >4.0 validates the backtest model. better_kmlm mental stop at 40% drawdown.

---

## 13. Open Questions for Future Sessions

1. MCP search reconnect — run three targeted searches: commodity/negative-beta, bond-rotation/low-DD, high-return/moderate-Sharpe.
2. IP Theft remaining groups — 24 groups total, only 9 tested.
3. PURE CASH PLUS Oil component (koMXFEhE24J7DaX0NveZ) — not yet backtested.
4. v3 vs v2 live comparison — check after 60 days.
5. Volatility matching — measure per-strategy annualized standard deviation; check for outliers dominating the portfolio despite equal weight.
6. kmlm_switcher as return track — 638% avg return with 22.3% MaxDD vs better_kmlm's 36.1%. May be a better standalone return track.

---

*Update this document after each major session.*
