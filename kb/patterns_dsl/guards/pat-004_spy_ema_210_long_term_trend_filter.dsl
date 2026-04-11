; SPY EMA 210 Long-Term Trend Filter — pat-004
; confidence: 0.9 | seen: 24x
; category: guard
; archetypes: ALL
; regimes effective: bull_low_vol, sideways_chop
; regimes less effective: bear_sustained, vix_spike
;
; DESCRIPTION: Long-term trend filter using SPY price vs its 210-day exponential moving average. SPY > EMA(210) confirms bull macro regime. Found in FNGG ms-022/024, Beta Baller ms-004/007, NOVA Best ms-001/034/036/038. Often combined with shorter MA(3) for dual-timeframe confirmation (see pat-012). The 210-day window approximates one trading year and filters out bear market rallies.
;
; USAGE: Apply as an outer guard wrapping entire leveraged bull allocation branches. This is a macro filter, not a timing signal. When SPY < EMA(210), route to defensive allocations (BIL, SPY, or short basket) regardless of other bullish signals. Can be layered with MA(3) for dual-timeframe confirmation.
;
; GENERATOR INSTRUCTION: Generator: When constructing strategy trees with leveraged bull allocations (TQQQ, SOXL, TECL, SPXL, UPRO), wrap the entire bull branch in an outer if-child with lhs-fn='exponential-moving-average-price', lhs-fn-params={'window-days':210}, lhs-val='SPY', comparator='lt', rhs-val='SPY', rhs-fixed-value=false. The true branch (SPY > EMA) continues to bull logic; the else branch routes to BIL or defensive allocation.
;
; DSL:
(if (> (current-price "EQUITIES::SPY//USD" 2)
       (exponential-moving-average-price "EQUITIES::SPY//USD" 210))
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")]
  [(asset "EQUITIES::BIL//USD" "BIL")])
