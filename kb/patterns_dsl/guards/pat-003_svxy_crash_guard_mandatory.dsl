; SVXY Crash Guard Mandatory — pat-003
; confidence: 0.95 | seen: 31x
; category: guard
; archetypes: vol_arb, adaptive_growth
; regimes effective: bull_low_vol, sideways_chop
; regimes less effective: none
;
; DESCRIPTION: Maximum drawdown guard on SVXY preventing allocation during volatility spikes. Conservative variant uses window=2, threshold=10% (fires early). Aggressive variant uses window=3, threshold=20% (allows more drawdown before exit). Found in FNGG ms-001, NOVA Best ms-001, v2 ms-006. Historical evidence: XIV (SVXY predecessor) lost 93% in Volmageddon February 2018. Strategies without this guard showed catastrophic equity curves in backtests.
;
; USAGE: MANDATORY for any branch containing SVXY or SVIX. Place as outermost guard before any short-vol allocation. The conservative (2-day, 10%) version is preferred for capital preservation. The aggressive (3-day, 20%) version is only for strategies explicitly tolerating higher vol drawdowns for increased return.
;
; GENERATOR INSTRUCTION: Generator: Every if-child tree that terminates in SVXY or SVIX must have max-drawdown guard as the outermost condition. Insert if-child with lhs-fn='max-drawdown', lhs-fn-params={'window-days':2}, lhs-val='SVXY', comparator='lt', rhs-val=10, rhs-fixed-value=true. The true branch continues to vol allocation; the else branch routes to BIL. This guard is non-negotiable—never generate SVXY/SVIX allocation without it.
;
; VARIANTS:
;   aggressive:   threshold=20
;   conservative: threshold=10
;
; DSL:
(if (> (max-drawdown "EQUITIES::SVXY//USD" 2) 10)
  [(asset "EQUITIES::BIL//USD" "BIL")]
  [(asset "EQUITIES::SVXY//USD" "SVXY")])
