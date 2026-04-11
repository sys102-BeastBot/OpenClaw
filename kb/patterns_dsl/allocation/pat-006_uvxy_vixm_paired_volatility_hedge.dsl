; UVXY VIXM Paired Volatility Hedge — pat-006
; confidence: 0.82 | seen: 14x
; category: allocation
; archetypes: vol-regime-switch, adaptive-momentum, crash-protected-growth
; regimes effective: bear_sustained, vix_spike
; regimes less effective: bull_low_vol
;
; DESCRIPTION: Always allocate to UVXY and VIXM together using equal cash weighting in defensive volatility branches, never holding either asset in isolation. Sisyphus V0.0 demonstrates this in ms-001, ms-002, ms-005, and ms-006 where the volatility hedge allocation consistently pairs both assets. UVXY alone decays rapidly in contango; VIXM alone misses acute spikes. The equal-weight combination captures both term structure dynamics. This pattern appears in 4 of Sisyphus's 10 non-trivial mini-strategies (40% frequency) and implicitly in FNGG's volatility routing architecture.
;
; USAGE: Apply this pattern whenever the strategy routes to a volatility-long defensive position. Do not use UVXY or VIXM as standalone holdings in any branch. The wt-cash-equal wrapper ensures both assets receive equal dollar allocation regardless of price.
;
; GENERATOR INSTRUCTION: Generator: Whenever constructing a defensive branch that holds long-volatility assets, never place UVXY or VIXM as a standalone asset leaf. Instead, wrap them in a wt-cash-equal node with both assets as children. The structure must be: {"step":"wt-cash-equal","children":[{"step":"asset","symbol":"UVXY"},{"step":"asset","symbol":"VIXM"}]}. If you find a branch terminating in only UVXY or only VIXM, add the missing paired asset inside a wt-cash-equal wrapper.
;
; DSL:
(weight-equal [
  (asset "EQUITIES::UVXY//USD" "UVXY")
  (asset "EQUITIES::VIXM//USD" "VIXM")
])
