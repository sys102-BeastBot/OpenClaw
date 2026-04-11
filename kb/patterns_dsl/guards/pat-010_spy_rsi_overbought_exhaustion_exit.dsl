; SPY RSI Overbought Exhaustion Exit — pat-010
; confidence: 0.83 | seen: 8x
; category: guard
; archetypes: adaptive-momentum, crash-protected-growth, aggressive-momentum
; regimes effective: bull_low_vol, bear_sustained
; regimes less effective: sideways_chop
;
; DESCRIPTION: Use relative-strength-index on SPY with window 10 and threshold 70-80 to detect overbought exhaustion conditions, triggering rotation from leveraged positions to safer assets. v2 Community Discovery NOVA ms-002 uses RSI threshold 70 for earlier exit. v2 ms-006 and ms-094 use threshold 80 for later exit allowing stronger momentum to run. The RSI(10) window matches the corpus-confirmed standard fast RSI. When SPY RSI exceeds the threshold, reduce leverage exposure by rotating to QQQ or SPY.
;
; USAGE: Apply this as a conditional exit within leveraged long branches, not as a root guard. When SPY RSI exceeds threshold, rotate from 3x leveraged (TQQQ/SOXL/SPXL) to 1x (QQQ/SPY), not to BIL. Use 70 for conservative mean-reversion strategies, 80 for trend-following strategies.
;
; GENERATOR INSTRUCTION: Generator: In any branch that terminates in TQQQ, SOXL, TECL, SPXL, or UPRO, add an RSI overbought check as a wrapper. Insert an if-block where the first if-child has: lhs-fn=relative-strength-index, lhs-fn-params.window=10, lhs-val=SPY, comparator=gt, rhs-val=70 (conservative) or rhs-val=80 (aggressive). When true (overbought), route to {"step":"asset","symbol":"QQQ"} or {"step":"asset","symbol":"SPY"}. When false (not overbought), route to the original leveraged asset.
;
; DSL:
(if (> (rsi "EQUITIES::SPY//USD" 10) 70) [
  (asset "EQUITIES::QQQ//USD" "QQQ")
] [
  (asset "EQUITIES::TQQQ//USD" "TQQQ")
])
