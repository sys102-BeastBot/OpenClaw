; UVXY RSI Long-Term Vol Regime — pat-021
; confidence: 0.88 | seen: 34x
; category: guard
; archetypes: ALL
; regimes effective: bear_sustained, vix_spike
; regimes less effective: bull_low_vol, sideways_chop
;
; DESCRIPTION: When UVXY RSI(60) > 40, sustained volatility regime is active.
; The 60-day window confirms this is not a brief vol spike but an extended
; period of elevated fear. Found in Sisyphus lines 154, 211 and repeated
; throughout the strategy tree.
;
; USAGE: Use as an outer vol regime filter. When UVXY RSI(60) > 40,
; route to UVXY as a sustained bear profit position.
; When UVXY RSI(60) <= 40, proceed to normal bull allocation logic.
;
; GENERATOR INSTRUCTION: Add a long-term vol regime check using RSI(60).
; This catches sustained bear markets where short vol signals would be noisy.
; Route to UVXY when confirmed, else continue to bull allocation.
;
; DSL:
(if (> (rsi "EQUITIES::UVXY//USD" 60) 40)
  [(asset "EQUITIES::UVXY//USD" "UVXY")]
  [(if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5)
    [(weight-inverse-vol 10 [
      (asset "EQUITIES::TQQQ//USD" "TQQQ")
      (asset "EQUITIES::SOXL//USD" "SOXL")
    ])]
    [(asset "EQUITIES::QQQ//USD" "QQQ")])])
