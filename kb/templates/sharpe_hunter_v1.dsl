defsymphony "{{NAME}}" {:rebalance-frequency :daily}
  (weight-equal [
    (group "Crash Guard" [
      (weight-equal [
        (if (or (> (max-drawdown "EQUITIES::SVXY//USD" {{CG_WINDOW_1}}) {{CG_THRESH_1}})
                (< (rsi "EQUITIES::SVXY//USD" {{CG_RSI_WINDOW}}) {{CG_RSI_THRESH}})
                (> (standard-deviation-return "EQUITIES::UVXY//USD" {{CG_STDDEV_WINDOW}}) {{CG_STDDEV_THRESH}}))
          [(asset "EQUITIES::BIL//USD" "BIL")]
          [(asset "EQUITIES::SVXY//USD" "SVXY")])
      ])
    ])
    (group "Vol Profit" [
      (weight-equal [
        (if (and (> (rsi "EQUITIES::UVXY//USD" {{VP_RSI_WINDOW}}) {{VP_RSI_LOW}})
                 (< (rsi "EQUITIES::UVXY//USD" {{VP_RSI_WINDOW}}) {{VP_RSI_HIGH}}))
          [(asset "EQUITIES::UVXY//USD" "UVXY")]
          [(if (> (rsi "EQUITIES::UVXY//USD" {{VP_LT_WINDOW}}) {{VP_LT_THRESH}})
            [(asset "EQUITIES::UVXY//USD" "UVXY")]
            [(asset "EQUITIES::VIXM//USD" "VIXM")])])
      ])
    ])
    (group "Bull Momentum" [
      (weight-equal [
        (if (> (current-price "EQUITIES::SPY//USD" 2)
                (exponential-moving-average-price "EQUITIES::SPY//USD" {{BM_EMA_WINDOW}}))
          [(if (> (cumulative-return "EQUITIES::TQQQ//USD" {{BM_MOM_WINDOW}}) {{BM_MOM_THRESH}})
            [(weight-inverse-vol {{BM_IVOL_WINDOW}} [
              (asset "EQUITIES::TQQQ//USD" "TQQQ")
              (asset "EQUITIES::SOXL//USD" "SOXL")
              (asset "EQUITIES::TECL//USD" "TECL")
            ])]
            [(asset "EQUITIES::QQQ//USD" "QQQ")])]
          [(asset "EQUITIES::BIL//USD" "BIL")])
      ])
    ])
  ])
