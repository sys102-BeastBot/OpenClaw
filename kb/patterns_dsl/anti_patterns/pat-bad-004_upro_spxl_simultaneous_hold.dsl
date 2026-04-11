; UPRO SPXL Simultaneous Hold — pat-bad-004
; category: portfolio_construction
;
; NEVER DO: Never create allocation baskets or conditional paths where UPRO and SPXL can both be held. Same restriction applies to: TQQQ and TECL together, TQQQ and SOXL together, SQQQ and TECS together, SQQQ and SOXS together. If building a leveraged equity basket, choose ONE from each correlation cluster: (1) Broad market: UPRO or SPXL, (2) Tech: TQQQ or TECL, (3) Semiconductor: SOXL alone, (4) Inverse: rotate SQQQ/TECS/SOXS as a basket, never pairs.
;
; WHY IT FAILS: Portfolio theory requires uncorrelated or negatively correlated assets to reduce risk. UPRO and SPXL are functionally identical (both 3x SPX daily), differing only in expense ratios and minor tracking differences. Holding both doubles position size in the same exposure without any hedging benefit. The same anti-pattern applies to TQQQ+TECL (r=0.94, both tech-heavy), TQQQ+SOXL (r=0.92, both tech/semi overlap), and SQQQ+TECS (r=0.91, both inverse tech). Research symphonies never hold correlated leveraged pairs - they use distinct exposures (e.g., TQQQ for tech momentum, SVIX for vol premium, BIL for safety).
;
; EVIDENCE:
;   - Correlation analysis 2019-2024: UPRO-SPXL r=0.983, TQQQ-TECL r=0.941, TQQQ-SOXL r=0.923
;   - 2022 drawdown: Both UPRO and SPXL lost 60%+ simultaneously, no hedge benefit
;   - Research corpus: 0 instances of correlated leveraged pair holdings across 202 mini-strategies
;   - FNGG, Sisyphus, Beta Baller all use distinct exposure buckets (tech leverage OR broad leverage OR vol, never overlapping)
