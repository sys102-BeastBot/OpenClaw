; UVXY RSI Overbought Vol Exhaustion Exit — pat-015
; confidence: 0.82 | seen: 3x
; category: guard
; archetypes: vol-harvest, hybrid, adaptive
; regimes effective: vix_spike
; regimes less effective: bear_sustained, bull_low_vol
;
; DESCRIPTION: Monitors UVXY RSI for extreme overbought conditions (>84) indicating volatility spike exhaustion. Found in Sisyphus ms-018 (BSC 2). When UVXY RSI exceeds 84, the vol spike has peaked and mean-reversion collapse is imminent. Exit any vol-long positions (UVXY, VIXM) immediately to BIL. This is also a signal to prepare for re-entry into short-vol (SVXY, SVIX) or leveraged bull positions. The 84 threshold is notably higher than standard overbought (70) because vol instruments can sustain extreme readings during genuine crises.
;
; USAGE: Place as an exit condition wrapper around any UVXY or VIXM holding. When RSI exceeds 84, exit to BIL. Can also be used as an entry signal for short-vol positions - when UVXY RSI drops below 84 after exceeding it, the spike is confirmed over.
;
; GENERATOR INSTRUCTION: Generator: When any branch holds UVXY or VIXM, wrap it in an if-node where the first if-child has lhs-fn=relative-strength-index, lhs-fn-params.window=10, lhs-val=UVXY, comparator=gt, rhs-val=84, rhs-fixed-value=true. When true (RSI>84), route to BIL. The else-child contains the original UVXY/VIXM holding. This creates automatic exit when vol spike exhausts.
;
; DSL:
(if (> (rsi "EQUITIES::UVXY//USD" 10) 84)
  [(asset "EQUITIES::BIL//USD" "BIL")]
  [(asset "EQUITIES::UVXY//USD" "UVXY")])
