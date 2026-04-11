; SVXY RSI Bull Health Confirmation — pat-019
; confidence: 0.83 | seen: 8x
; category: guard
; archetypes: vol_harvesting, vol_premium, carry_harvesting
; regimes effective: bull_low_vol
; regimes less effective: vix_spike
;
; DESCRIPTION: Confirms that the short-volatility regime is healthy before allocating to SVXY or SVIX. Uses two conditions: SVXY RSI(10) must be above 31 (indicating the asset is not oversold/crashing) AND SVXY 1-day return must be above -6% (no single-day crash in progress). Both conditions must pass for vol-short allocation to proceed.
;
; USAGE: Always use both conditions together as a compound gate before any SVXY or SVIX allocation. If either condition fails, route to BIL instead. This pattern pairs with pat-003 (SVXY Triple Crash Guard) which handles the inverse case of detecting active crashes.
;
; GENERATOR INSTRUCTION: Generator: Before ANY asset node that holds SVXY or SVIX, insert a two-level nested if-child structure. The outer if-child checks relative-strength-index on SVXY with window-days 10, greater-than 31. If true, the then-child is another if-child checking cumulative-return on SVXY with window-days 1, greater-than -6. If that inner condition is also true, the then-child is the SVXY or SVIX asset node. Both the outer else and inner else must route to an asset node for BIL. Never allocate to SVXY or SVIX without this two-condition gate.
;
; DSL:
(if (> (rsi "EQUITIES::SVXY//USD" 10) 31)
  [(if (> (cumulative-return "EQUITIES::SVXY//USD" 1) -6)
    [(asset "EQUITIES::SVXY//USD" "SVXY")]
    [(asset "EQUITIES::BIL//USD" "BIL")])]
  [(asset "EQUITIES::BIL//USD" "BIL")])
