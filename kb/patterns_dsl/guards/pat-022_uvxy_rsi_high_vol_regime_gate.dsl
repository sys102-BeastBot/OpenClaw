; UVXY RSI High Vol Regime Gate — pat-022
; confidence: 0.90 | seen: 47x
; category: guard
; archetypes: ALL
; regimes effective: bear_sustained, vix_spike, bull_volatile
; regimes less effective: bull_low_vol
;
; DESCRIPTION: When UVXY RSI(21) > 65, market is in a high-vol regime.
; This is the most common UVXY entry pattern in Sisyphus — found 47x.
; The 21-day window balances responsiveness with noise filtering.
; Above 65 = vol regime confirmed, proceed to vol profit allocation.
;
; USAGE: Use as an intermediate vol regime check between crash guards
; and bull allocation. When UVXY RSI(21) > 65, route to vol profit block.
; When <= 65, proceed to normal bull conditions (EMA, momentum gates).
;
; GENERATOR INSTRUCTION: This is the KEY missing pattern in generated
; strategies. After crash guards pass (not crashing), check if we are
; in a vol regime with UVXY RSI(21) > 65. If yes, route to UVXY profit.
; If no, THEN check bull conditions. This is how bear market profits work.
;
; DSL:
(if (> (rsi "EQUITIES::UVXY//USD" 21) 65)
  [(asset "EQUITIES::UVXY//USD" "UVXY")]
  [(if (> (current-price "EQUITIES::SPY//USD" 2)
          (exponential-moving-average-price "EQUITIES::SPY//USD" 210))
    [(if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5)
      [(weight-inverse-vol 10 [
        (asset "EQUITIES::TQQQ//USD" "TQQQ")
        (asset "EQUITIES::SOXL//USD" "SOXL")
        (asset "EQUITIES::TECL//USD" "TECL")
      ])]
      [(asset "EQUITIES::QQQ//USD" "QQQ")])]
    [(asset "EQUITIES::BIL//USD" "BIL")])])
