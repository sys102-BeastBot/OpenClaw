; TQQQ Extreme Crash Circuit Breaker — pat-018
; confidence: 0.8 | seen: 4x
; category: guard
; archetypes: leveraged_momentum, vol_harvesting, aggressive_growth, trend_following
; regimes effective: vix_spike, bear_sustained
; regimes less effective: bull_low_vol
;
; DESCRIPTION: Detects when TQQQ has fallen more than 33% over 10 trading days, indicating an extreme crash event. This threshold is distinct from the 5.5% entry momentum gate — this circuit breaker fires only when catastrophic losses have already occurred and further leveraged exposure is dangerous.
;
; USAGE: Place as the outermost condition in any strategy that holds leveraged bull assets. This guard should wrap all other logic so that when triggered, the strategy immediately exits to safety without evaluating downstream conditions.
;
; GENERATOR INSTRUCTION: Generator: When constructing any strategy that can allocate to TQQQ, SOXL, TECL, SPXL, or UPRO, wrap the entire decision tree in an outermost if-child with condition cumulative-return on TQQQ, window-days 10, less-than -33. If this condition is true, the then-child must be an asset node for BIL. The otherwise-child contains the rest of the strategy logic. Never place this guard inside other conditions — it must be the first evaluated node.
;
; DSL:
(if (< (cumulative-return "EQUITIES::TQQQ//USD" 10) -33)
  [(asset "EQUITIES::BIL//USD" "BIL")]
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")])
