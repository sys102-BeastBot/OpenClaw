; TECS SOXS SQQQ Named Short Basket — pat-014
; confidence: 0.88 | seen: 12x
; category: allocation
; archetypes: leveraged-bear, hybrid, adaptive
; regimes effective: bear_sustained, vix_spike
; regimes less effective: bull_low_vol
;
; DESCRIPTION: Equal-weight allocation to three leveraged inverse ETFs: TECS (3x inverse tech), SOXS (3x inverse semiconductors), and SQQQ (3x inverse Nasdaq). FNGG explicitly names this combination as 'SHORT GROUP' and uses it as a terminal allocation bucket. The three-asset basket diversifies bear exposure and reduces single-sector risk. Never hold any of these individually - always as the complete basket. All three assets are in the generator universe.
;
; USAGE: Deploy only when upstream routing confirms bearish regime (e.g., SPY below EMA-210, TQQQ momentum negative, vol signals elevated). Use wt-cash-equal step to hold all three with equal weight. This is a terminal allocation, not a conditional branch.
;
; GENERATOR INSTRUCTION: Generator: When any branch requires bear-regime allocation, never use TECS, SOXS, or SQQQ individually. Always use a wt-cash-equal node containing exactly three asset children: TECS, SOXS, SQQQ in that order. The wt-cash-equal step creates equal 33.3% allocation to each. Place this basket only after confirmed bearish routing logic (pat-002 SPY EMA-210 failing, or vol spike detected).
;
; DSL:
(weight-equal [
  (asset "EQUITIES::TECS//USD" "TECS")
  (asset "EQUITIES::SOXS//USD" "SOXS")
  (asset "EQUITIES::SQQQ//USD" "SQQQ")
])
