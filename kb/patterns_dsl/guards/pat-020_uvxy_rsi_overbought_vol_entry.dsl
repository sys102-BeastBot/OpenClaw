; UVXY RSI Overbought Vol Entry — pat-020
; confidence: 0.92 | seen: 61x
; category: guard
; archetypes: ALL
; regimes effective: bear_sustained, vix_spike
; regimes less effective: bull_low_vol
;
; DESCRIPTION: When UVXY RSI(10) is between 74-84, volatility is elevated
; but not yet exhausted — this is the profit zone for long vol positions.
; Found 61x in Sisyphus across multiple mini-strategies. The band 74-84
; captures vol momentum without chasing an exhausted spike.
;
; USAGE: In bear/stressed regimes, use as a positive entry signal for UVXY.
; The upper bound RSI < 84 prevents buying vol at exhaustion.
; This is a PROFIT pattern — routes TO UVXY, not to BIL.
;
; GENERATOR INSTRUCTION: When the strategy is in a stressed/bear branch
; (after crash guards have passed), insert a UVXY profit layer:
; if UVXY RSI > 74 AND < 84, route to UVXY as a profit position.
; This is how strategies make money IN bear markets, not just avoid losses.
;
; DSL:
(if (and (> (rsi "EQUITIES::UVXY//USD" 10) 74)
         (< (rsi "EQUITIES::UVXY//USD" 10) 84))
  [(asset "EQUITIES::UVXY//USD" "UVXY")]
  [(asset "EQUITIES::BIL//USD" "BIL")])
