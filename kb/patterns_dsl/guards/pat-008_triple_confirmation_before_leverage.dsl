; Triple Confirmation Before Leverage — pat-008
; confidence: 0.87 | seen: 18x
; category: guard
; archetypes: ALL
; regimes effective: bull_low_vol
; regimes less effective: none
;
; DESCRIPTION: Chain at least 3 independent conditions covering distinct signal categories (trend + momentum + stress) before routing to any leveraged ETF. NOVA Best Leverage Mashup ms-001 exemplifies this with 7 chained conditions before TQQQ allocation. Sisyphus V0.0 ms-002 and ms-009 use 3-4 conditions. Beta Baller ms-003, ms-004, and ms-005 all chain 3+ conditions before leveraged positions. The three categories must be: (1) trend confirmation (e.g., price vs EMA), (2) momentum confirmation (e.g., cumulative return or RSI), (3) stress absence (e.g., vol check or drawdown check). Single or dual conditions before leverage correlate with higher drawdowns.
;
; USAGE: Before any TQQQ, SOXL, TECL, SPXL, UPRO, SVIX, or SVXY allocation, ensure at least 3 sequential if-child conditions from different categories must all pass. The else branch of the final condition should route to a safer asset (BIL, SPY, or QQQ).
;
; GENERATOR INSTRUCTION: Generator: Before any asset leaf containing TQQQ, SOXL, TECL, SPXL, UPRO, SVIX, or SVXY, count the number of if-child conditions that must pass to reach that leaf. If fewer than 3, add conditions until there are at least 3. The conditions must span at least 2 of these categories: (a) trend: current-price vs moving-average-price or exponential-moving-average-price, (b) momentum: cumulative-return or relative-strength-index, (c) stress: max-drawdown, standard-deviation-return, or UVXY-based indicator. Structure as nested if-children where each condition's true branch contains the next condition.
;
; DSL:
(if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5)
  [(if (> (current-price "EQUITIES::SPY//USD" 2)
          (exponential-moving-average-price "EQUITIES::SPY//USD" 210))
    [(if (< (standard-deviation-return "EQUITIES::UVXY//USD" 10) 10)
      [(asset "EQUITIES::TQQQ//USD" "TQQQ")]
      [(asset "EQUITIES::BIL//USD" "BIL")])]
    [(asset "EQUITIES::QQQ//USD" "QQQ")])]
  [(asset "EQUITIES::SPY//USD" "SPY")])
