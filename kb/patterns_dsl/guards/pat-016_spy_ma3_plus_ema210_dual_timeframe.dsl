; SPY MA3 Plus EMA210 Dual Timeframe — pat-016
; confidence: 0.83 | seen: 14x
; category: guard
; archetypes: volatility_harvest, leveraged_momentum, trend_following
; regimes effective: bull_low_vol, sideways_chop
; regimes less effective: none
;
; DESCRIPTION: Dual-timeframe trend confirmation requiring both short-term momentum (3-day MA) and long-term regime validation (210-day EMA) before committing to leveraged bull positions. The MA(3) captures immediate price action above recent average, while EMA(210) represents approximately 10 months of price history, ensuring the macro trend is bullish. Both conditions must pass simultaneously.
;
; USAGE: Apply as a two-layer gate before any TIER 1 leveraged allocation. First check EMA(210) for macro regime, then MA(3) for entry timing. Never invert the order—macro confirmation must precede timing signal. This pattern is specifically designed for SPY as the reference asset because it represents broad market regime.
;
; GENERATOR INSTRUCTION: Generator: Before any if-child that routes to TQQQ, SOXL, TECL, SPXL, or UPRO as a terminal asset, insert two sequential if-child conditions: (1) outer condition with lhs={fn: exponential-moving-average-price, window-days: 210, asset: SPY}, comparator: <=, rhs={fn: current-price, asset: SPY}, then (2) inner condition with lhs={fn: moving-average-price, window-days: 3, asset: SPY}, comparator: <=, rhs={fn: current-price, asset: SPY}. The leveraged asset must be nested inside both conditions passing.
;
; DSL:
(if (> (current-price "EQUITIES::SPY//USD" 2)
       (exponential-moving-average-price "EQUITIES::SPY//USD" 210))
  [(if (> (current-price "EQUITIES::SPY//USD" 2)
          (moving-average-price "EQUITIES::SPY//USD" 3))
    [(asset "EQUITIES::TQQQ//USD" "TQQQ")]
    [(asset "EQUITIES::QQQ//USD" "QQQ")])]
  [(asset "EQUITIES::BIL//USD" "BIL")])
