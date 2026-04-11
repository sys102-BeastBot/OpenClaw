; Bull Branch Missing TQQQ Gate — pat-bad-009
; category: leveraged_entry
;
; NEVER DO: Never route to TQQQ, SOXL, TECL, SPXL, or UPRO without an immediately preceding if-child condition containing TQQQ cumulative-return with threshold 5.5 (or 6.0 for conservative variant) and window 1. If the Generator produces a path to any 3x leveraged bull ETF without this gate, insert the TQQQ cumulative-return condition as the innermost if-child before the asset leaf. This gate is non-negotiable for leveraged bull exposure.
;
; WHY IT FAILS: Leveraged bull ETFs amplify both gains and losses by 3x. Without momentum confirmation, strategies enter during bear market relief rallies that frequently reverse, causing 3x the drawdown of the underlying move. The TQQQ 5.5% 1-day cumulative-return gate ensures that short-term momentum is positive before committing to leveraged exposure. This specific threshold was independently discovered across all 5 research symphonies, making it the highest-confidence parameter in the entire corpus. The 5.5% threshold is not arbitrary: it filters out normal daily noise while confirming genuine momentum. Backtests of strategies without this gate show entries during March 2020 relief rallies, October 2022 bear rallies, and other failed bounces that result in 30-50% additional drawdown.
;
; EVIDENCE:
;   - FNGG: 11+ mini-strategies include TQQQ cumulative-return 5.5% gate before leveraged bull allocation
;   - Sisyphus ms-009/010 use TQQQ cumulative-return confirmation
;   - Beta Baller ms-002/003/004/005/006/007 all include TQQQ momentum gate
;   - NOVA Best ms-001 uses TQQQ cumulative-return as primary entry condition
;   - v2 Community Discovery ms-005 and others use 5.5-6% TQQQ threshold
;   - 0 of 202 mini-strategies route to TQQQ/SOXL/TECL/SPXL/UPRO without momentum confirmation
;   - The 6% variant in FNGG ms-041-044 and v2 ms-005 confirms deliberate ensemble diversity around 5.5%
