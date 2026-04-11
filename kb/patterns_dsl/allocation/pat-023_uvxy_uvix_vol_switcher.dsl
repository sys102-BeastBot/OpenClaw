; UVXY/UVIX Vol Instrument Switcher — pat-023
; confidence: 0.85 | seen: 28x
; category: allocation
; archetypes: ALL
; regimes effective: bear_sustained, vix_spike
; regimes less effective: bull_low_vol
;
; DESCRIPTION: When in a vol profit position, use UVXY RSI(10) < 40 to
; switch between UVIX (less aggressive) and UVXY (more aggressive).
; RSI(10) < 40 = vol is cheap/oversold → use UVIX for less leverage.
; RSI(10) >= 40 = vol is elevated → use UVXY for full exposure.
; Found 28x in Sisyphus vol profit branches.
;
; USAGE: Use inside a vol profit block when you want to differentiate
; between aggressive and moderate vol exposure. Not required for simpler
; strategies — can just use UVXY directly.
;
; DSL:
(if (< (rsi "EQUITIES::UVXY//USD" 10) 40)
  [(asset "EQUITIES::UVIX//USD" "UVIX")]
  [(asset "EQUITIES::UVXY//USD" "UVXY")])
