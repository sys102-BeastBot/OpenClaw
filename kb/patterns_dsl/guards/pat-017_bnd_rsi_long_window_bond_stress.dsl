; BND RSI Long Window Bond Stress — pat-017
; confidence: 0.8 | seen: 8x
; category: guard
; archetypes: volatility_harvest, leveraged_momentum, defensive_rotation
; regimes effective: bear_sustained
; regimes less effective: bull_low_vol
;
; DESCRIPTION: Long-window bond stress detector using 45-day RSI on BND compared dynamically to SPY RSI. Unlike pat-005 which uses 10-day windows for immediate rate stress, this pattern captures prolonged risk-off rotation where institutional money has been steadily flowing into bonds for over a month. When BND RSI(45) exceeds SPY RSI(45), it signals sustained defensive positioning that warrants reducing leveraged exposure.
;
; USAGE: Use as a secondary bear confirmation layer, not a primary signal. When triggered, reduce allocation tier by one level (TIER 1 → TIER 2, TIER 2 → TIER 3). Do not use for complete risk-off—that requires crash guards like pat-012 or pat-013. The 45-day window means this signal is slower but more reliable than short-window variants.
;
; GENERATOR INSTRUCTION: Generator: After any TIER 1 leveraged allocation branch passes its primary guards, add a secondary if-child that checks BND RSI(45) vs SPY RSI(45). Structure: if lhs={fn: relative-strength-index, window-days: 45, asset: BND} comparator: > rhs={fn: relative-strength-index, window-days: 45, asset: SPY}, then route to TIER 2 asset (QQQ or SPY) instead of TIER 1 (TQQQ, SOXL). This downgrades allocation when sustained bond stress is detected.
;
; DSL:
(if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45))
  [(asset "EQUITIES::QQQ//USD" "QQQ")]
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")])
