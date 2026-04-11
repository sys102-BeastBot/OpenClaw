; UVXY Moving Average Return vs VIXM Trending Signal — pat-013
; confidence: 0.82 | seen: 4x
; category: selection
; archetypes: vol-harvest, hybrid, adaptive
; regimes effective: vix_spike
; regimes less effective: bull_low_vol
;
; DESCRIPTION: Compares short-term UVXY momentum (3-day moving average return) against VIXM as a dynamic threshold. UVXY tracks near-term VIX futures while VIXM tracks mid-term. When UVXY's 3-day MA-return exceeds VIXM's equivalent measure, it indicates near-term volatility is accelerating faster than the sustained vol regime - a spike is building or continuing. Found in FNGG ms-010 and ms-040. Both UVXY and VIXM are in the generator universe, making this fully recomposable.
;
; USAGE: Use as a regime filter to distinguish spike-in-progress from elevated-but-stable vol. When UVXY MA-return > VIXM, favor defensive positioning or vol-long. When VIXM > UVXY MA-return, vol is elevated but mean-reverting - safer to hold short-vol or leveraged equity.
;
; GENERATOR INSTRUCTION: Generator: When building vol-regime detection logic, add an if-child with lhs-fn=moving-average-return, lhs-fn-params.window=3, lhs-val=UVXY, comparator=gt, rhs-val=VIXM, rhs-fixed-value=false. The true branch indicates spike-accelerating regime (route to BIL or vol-long). The else branch indicates stable-vol regime (safe for SVXY or leveraged bull).
;
; DSL:
(if (> (moving-average-return "EQUITIES::UVXY//USD" 3)
       (moving-average-return "EQUITIES::VIXM//USD" 3))
  [(asset "EQUITIES::BIL//USD" "BIL")]
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")])
