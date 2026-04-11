; SPY Max Drawdown Hard Floor — pat-007
; confidence: 0.88 | seen: 11x
; category: guard
; archetypes: ALL
; regimes effective: bear_sustained, vix_spike
; regimes less effective: bull_low_vol
;
; DESCRIPTION: Use max-drawdown indicator on SPY as a hard floor circuit breaker that forces exit to safe haven (BIL) when breached. v2 Community Discovery NOVA ms-004 uses a 6% threshold for early exit; Beta Baller ms-005 uses a more permissive 10% threshold allowing deeper drawdowns before triggering. NOVA Best Leverage Mashup implies similar logic in its risk management layer. This pattern catches sustained market stress that cumulative-return indicators may miss because it tracks peak-to-trough rather than point-to-point returns. The 20-day window is standard across implementations.
;
; USAGE: Place this guard at or near the root of the symphony, before any asset selection logic. When triggered, route directly to BIL regardless of other conditions. Use 6% threshold for conservative strategies, 10% for aggressive strategies seeking to ride volatility longer.
;
; GENERATOR INSTRUCTION: Generator: Add a max-drawdown guard on SPY as the first or second if-child in the root if-block of every symphony. The condition must be: lhs-fn=max-drawdown, lhs-val=SPY, lhs-fn-params.window=20, comparator=gt, rhs-val=6 (conservative) or rhs-val=10 (aggressive). When this condition is true, the children must route directly to BIL: {"step":"asset","symbol":"BIL"}. Do not place any leveraged assets in the true branch of this condition.
;
; DSL:
(if (> (max-drawdown "EQUITIES::SPY//USD" 20) 6)
  [(asset "EQUITIES::BIL//USD" "BIL")]
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")])
