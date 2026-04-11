defsymphony "Custom Foreign RINF mod updated with 1x below spy200d and reduced lev FRs _ EMA (Buy Copy)" {:rebalance-frequency :daily}
  (weight-inverse-vol 90 [
    (group "Foreign RINF mod" [
      (weight-equal [
        (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
          (group "Full leverage" [
            (weight-equal [
              (if (> (rsi "EQUITIES::EEM//USD" 10) 80) [
                (group "Edz/bil 65/35" [
                  (weight-specified {"EDZ" 65 "BIL" 35} [
                    (asset "EQUITIES::EDZ//USD" "EDZ")
                    (asset "EQUITIES::BIL//USD" "BIL")
                  ])
                ])
              ] [
                (weight-equal [
                  (if (< (rsi "EQUITIES::EEM//USD" 10) 25) [
                    (group "EDC/bil 68/32" [
                      (weight-specified {"EDC" 68 "BIL" 32} [
                        (asset "EQUITIES::EDC//USD" "EDC")
                        (asset "EQUITIES::BIL//USD" "BIL")
                      ])
                    ])
                  ] [
                    (weight-equal [
                      (if (> (current-price "EQUITIES::RINF//USD" 10) (moving-average-price "EQUITIES::RINF//USD" 50)) [
                        (weight-equal [
                          (if (> (current-price "EQUITIES::EEM//USD" 10) (moving-average-price "EQUITIES::EEM//USD" 200)) [
                            (group "IEI vs IWM" [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::IEI//USD" 10) (rsi "EQUITIES::IWM//USD" 15)) [
                                  (asset "EQUITIES::EDC//USD" "EDC")
                                ] [
                                  (asset "EQUITIES::EDZ//USD" "EDZ")
                                ])
                              ])
                            ])
                          ] [
                            (group "IGIB vs EEM" [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::IGIB//USD" 15) (rsi "EQUITIES::EEM//USD" 15)) [
                                  (asset "EQUITIES::EDC//USD" "EDC")
                                ] [
                                  (asset "EQUITIES::EDZ//USD" "EDZ")
                                ])
                              ])
                            ])
                            (group "IGIB vs SPY" [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::IGIB//USD" 10) (rsi "EQUITIES::SPY//USD" 15)) [
                                  (asset "EQUITIES::EDC//USD" "EDC")
                                ] [
                                  (asset "EQUITIES::EDZ//USD" "EDZ")
                                ])
                              ])
                            ])
                          ])
                        ])
                      ] [
                        (group "IGIB vs SPY" [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::IGIB//USD" 10) (rsi "EQUITIES::SPY//USD" 15)) [
                              (asset "EQUITIES::EDC//USD" "EDC")
                            ] [
                              (asset "EQUITIES::EDZ//USD" "EDZ")
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
        ] [
          (group "Reduced leverage" [
            (weight-equal [
              (if (> (rsi "EQUITIES::EEM//USD" 10) 80) [
                (group "Edz/bil 65/35" [
                  (weight-specified {"EDZ" 65 "BIL" 35} [
                    (asset "EQUITIES::EDZ//USD" "EDZ")
                    (asset "EQUITIES::BIL//USD" "BIL")
                  ])
                ])
              ] [
                (weight-equal [
                  (if (< (rsi "EQUITIES::EEM//USD" 10) 25) [
                    (group "EDC/bil 68/32" [
                      (weight-specified {"EDC" 68 "BIL" 32} [
                        (asset "EQUITIES::EDC//USD" "EDC")
                        (asset "EQUITIES::BIL//USD" "BIL")
                      ])
                    ])
                  ] [
                    (weight-equal [
                      (if (> (current-price "EQUITIES::RINF//USD" 10) (moving-average-price "EQUITIES::RINF//USD" 50)) [
                        (weight-equal [
                          (if (> (current-price "EQUITIES::EEM//USD" 10) (moving-average-price "EQUITIES::EEM//USD" 200)) [
                            (group "IEI vs IWM" [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::IEI//USD" 10) (rsi "EQUITIES::IWM//USD" 15)) [
                                  (asset "EQUITIES::EEM//USD" "EEM")
                                ] [
                                  (group "Eum (1/3 Edz)" [
                                    (weight-specified {"EDZ" 33 "BIL" 67} [
                                      (asset "EQUITIES::EDZ//USD" "EDZ")
                                      (asset "EQUITIES::BIL//USD" "BIL")
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ] [
                            (group "IGIB vs EEM" [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::IGIB//USD" 15) (rsi "EQUITIES::EEM//USD" 15)) [
                                  (asset "EQUITIES::EEM//USD" "EEM")
                                ] [
                                  (group "Eum (1/3 Edz)" [
                                    (weight-specified {"EDZ" 33 "BIL" 67} [
                                      (asset "EQUITIES::EDZ//USD" "EDZ")
                                      (asset "EQUITIES::BIL//USD" "BIL")
                                    ])
                                  ])
                                ])
                              ])
                            ])
                            (group "IGIB vs SPY" [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::IGIB//USD" 10) (rsi "EQUITIES::SPY//USD" 15)) [
                                  (asset "EQUITIES::EEM//USD" "EEM")
                                ] [
                                  (group "Eum (1/3 Edz)" [
                                    (weight-specified {"EDZ" 33 "BIL" 67} [
                                      (asset "EQUITIES::EDZ//USD" "EDZ")
                                      (asset "EQUITIES::BIL//USD" "BIL")
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ] [
                        (group "IGIB vs SPY" [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::IGIB//USD" 10) (rsi "EQUITIES::SPY//USD" 15)) [
                              (asset "EQUITIES::EEM//USD" "EEM")
                            ] [
                              (group "Eum (1/3 Edz)" [
                                (weight-specified {"EDZ" 33 "BIL" 67} [
                                  (asset "EQUITIES::EDZ//USD" "EDZ")
                                  (asset "EQUITIES::BIL//USD" "BIL")
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
        ])
      ])
    ])
    (group "EMA" [
      (weight-equal [
        (if (> (current-price "EQUITIES::QQQ//USD" 10) (exponential-moving-average-price "EQUITIES::QQQ//USD" 66)) [
          (group "Pareto" [
            (weight-equal [
              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 82) [
                (weight-equal [
                  (if (< (rsi "EQUITIES::TECL//USD" 10) 80) [
                    (weight-equal [
                      (if (< (rsi "EQUITIES::UPRO//USD" 10) 78) [
                        (weight-equal [
                          (if (< (rsi "EQUITIES::SOXL//USD" 10) 81) [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SOXL//USD" 10) 81) [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::TQQQ//USD" 10) 27) [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::TECL//USD" 10) 29) [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::TECL//USD" 10) 29) [
                                                (weight-equal [
                                                  (if (> (rsi "EQUITIES::UPRO//USD" 10) 29) [
                                                    (weight-equal [
                                                      (group "MAIN STRATEGY" [
                                                        (weight-equal [
                                                          (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -11) [
                                                            (weight-equal [
                                                              (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                (weight-equal [
                                                                  (group "SHORT (Negative Beta -1 to -3)" [
                                                                    (weight-equal [
                                                                      (group "SHORT GROUP (UVXY)" [
                                                                        (weight-equal [
                                                                          (weight-equal [
                                                                            (filter (standard-deviation-return 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                            ])
                                                                            (filter (cumulative-return 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                            ])
                                                                            (filter (rsi 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                            ])
                                                                          ])
                                                                          (weight-equal [
                                                                            (filter (standard-deviation-return 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                            ])
                                                                            (filter (cumulative-return 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                            ])
                                                                            (filter (rsi 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                            ])
                                                                          ])
                                                                          (weight-equal [
                                                                            (filter (standard-deviation-return 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                            ])
                                                                            (filter (cumulative-return 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                            ])
                                                                            (filter (rsi 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                      (group "SHORT GROUP (NO UVXY)" [
                                                                        (weight-equal [
                                                                          (weight-equal [
                                                                            (filter (standard-deviation-return 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                            ])
                                                                            (filter (cumulative-return 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                            ])
                                                                            (filter (rsi 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                            ])
                                                                          ])
                                                                          (weight-equal [
                                                                            (filter (standard-deviation-return 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                            ])
                                                                            (filter (cumulative-return 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                            ])
                                                                            (filter (rsi 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                            ])
                                                                          ])
                                                                          (weight-equal [
                                                                            (filter (standard-deviation-return 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                            ])
                                                                            (filter (cumulative-return 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                            ])
                                                                            (filter (rsi 20) (select-top 1) [
                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (group "Risk-On" [
                                                                    (weight-equal [
                                                                      (group "SPY" [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 20) (select-top 3) [
                                                                            (asset "EQUITIES::AAPL//USD" "AAPL")
                                                                            (asset "EQUITIES::MSFT//USD" "MSFT")
                                                                            (asset "EQUITIES::AMZN//USD" "AMZN")
                                                                            (asset "EQUITIES::NVDA//USD" "NVDA")
                                                                            (asset "EQUITIES::TSLA//USD" "TSLA")
                                                                            (asset "EQUITIES::GOOG//USD" "GOOG")
                                                                            (asset "EQUITIES::GOOGL//USD" "GOOGL")
                                                                            (asset "EQUITIES::META//USD" "META")
                                                                            (asset "EQUITIES::BRK/B//USD" "BRK/B")
                                                                            (asset "EQUITIES::UNH//USD" "UNH")
                                                                            (asset "EQUITIES::JNJ//USD" "JNJ")
                                                                            (asset "EQUITIES::JPM//USD" "JPM")
                                                                            (asset "EQUITIES::XOM//USD" "XOM")
                                                                            (asset "EQUITIES::V//USD" "V")
                                                                            (asset "EQUITIES::LLY//USD" "LLY")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                      (group "QQQ" [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 20) (select-top 3) [
                                                                            (asset "EQUITIES::AMD//USD" "AMD")
                                                                            (asset "EQUITIES::NFLX//USD" "NFLX")
                                                                            (asset "EQUITIES::CSCO//USD" "CSCO")
                                                                            (asset "EQUITIES::ADBE//USD" "ADBE")
                                                                            (asset "EQUITIES::COST//USD" "COST")
                                                                            (asset "EQUITIES::PEP//USD" "PEP")
                                                                            (asset "EQUITIES::AVGO//USD" "AVGO")
                                                                            (asset "EQUITIES::GOOG//USD" "GOOG")
                                                                            (asset "EQUITIES::GOOGL//USD" "GOOGL")
                                                                            (asset "EQUITIES::META//USD" "META")
                                                                            (asset "EQUITIES::TSLA//USD" "TSLA")
                                                                            (asset "EQUITIES::AMZN//USD" "AMZN")
                                                                            (asset "EQUITIES::NVDA//USD" "NVDA")
                                                                            (asset "EQUITIES::AAPL//USD" "AAPL")
                                                                            (asset "EQUITIES::MSFT//USD" "MSFT")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                      (group "DIA" [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 20) (select-top 3) [
                                                                            (asset "EQUITIES::UNH//USD" "UNH")
                                                                            (asset "EQUITIES::MSFT//USD" "MSFT")
                                                                            (asset "EQUITIES::GS//USD" "GS")
                                                                            (asset "EQUITIES::HD//USD" "HD")
                                                                            (asset "EQUITIES::MCD//USD" "MCD")
                                                                            (asset "EQUITIES::JNJ//USD" "JNJ")
                                                                            (asset "EQUITIES::TRV//USD" "TRV")
                                                                            (asset "EQUITIES::AXP//USD" "AXP")
                                                                            (asset "EQUITIES::AAPL//USD" "AAPL")
                                                                            (asset "EQUITIES::HON//USD" "HON")
                                                                            (asset "EQUITIES::CRM//USD" "CRM")
                                                                            (asset "EQUITIES::BA//USD" "BA")
                                                                            (asset "EQUITIES::AMGN//USD" "AMGN")
                                                                            (asset "EQUITIES::V//USD" "V")
                                                                            (asset "EQUITIES::CAT//USD" "CAT")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::TYO//USD" 20) (rsi "EQUITIES::SPY//USD" 20)) [
                                                                (group "Risk-On" [
                                                                  (weight-equal [
                                                                    (group "SPY" [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 20) (select-top 3) [
                                                                          (asset "EQUITIES::AAPL//USD" "AAPL")
                                                                          (asset "EQUITIES::MSFT//USD" "MSFT")
                                                                          (asset "EQUITIES::AMZN//USD" "AMZN")
                                                                          (asset "EQUITIES::NVDA//USD" "NVDA")
                                                                          (asset "EQUITIES::TSLA//USD" "TSLA")
                                                                          (asset "EQUITIES::GOOG//USD" "GOOG")
                                                                          (asset "EQUITIES::GOOGL//USD" "GOOGL")
                                                                          (asset "EQUITIES::META//USD" "META")
                                                                          (asset "EQUITIES::BRK/B//USD" "BRK/B")
                                                                          (asset "EQUITIES::UNH//USD" "UNH")
                                                                          (asset "EQUITIES::JNJ//USD" "JNJ")
                                                                          (asset "EQUITIES::JPM//USD" "JPM")
                                                                          (asset "EQUITIES::XOM//USD" "XOM")
                                                                          (asset "EQUITIES::V//USD" "V")
                                                                          (asset "EQUITIES::LLY//USD" "LLY")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                              ])
                                                              (if (< (rsi "EQUITIES::TYO//USD" 20) (rsi "EQUITIES::DIA//USD" 20)) [
                                                                (group "Risk-On" [
                                                                  (weight-equal [
                                                                    (group "DIA" [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 20) (select-top 3) [
                                                                          (asset "EQUITIES::UNH//USD" "UNH")
                                                                          (asset "EQUITIES::MSFT//USD" "MSFT")
                                                                          (asset "EQUITIES::GS//USD" "GS")
                                                                          (asset "EQUITIES::HD//USD" "HD")
                                                                          (asset "EQUITIES::MCD//USD" "MCD")
                                                                          (asset "EQUITIES::JNJ//USD" "JNJ")
                                                                          (asset "EQUITIES::TRV//USD" "TRV")
                                                                          (asset "EQUITIES::AXP//USD" "AXP")
                                                                          (asset "EQUITIES::AAPL//USD" "AAPL")
                                                                          (asset "EQUITIES::HON//USD" "HON")
                                                                          (asset "EQUITIES::CRM//USD" "CRM")
                                                                          (asset "EQUITIES::BA//USD" "BA")
                                                                          (asset "EQUITIES::AMGN//USD" "AMGN")
                                                                          (asset "EQUITIES::V//USD" "V")
                                                                          (asset "EQUITIES::CAT//USD" "CAT")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (asset "EQUITIES::BIL//USD" "BIL")
                                                                ])
                                                              ])
                                                              (if (< (rsi "EQUITIES::TYO//USD" 20) (rsi "EQUITIES::QQQ//USD" 20)) [
                                                                (group "Risk-On" [
                                                                  (weight-equal [
                                                                    (group "QQQ" [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 20) (select-top 3) [
                                                                          (asset "EQUITIES::AMD//USD" "AMD")
                                                                          (asset "EQUITIES::NFLX//USD" "NFLX")
                                                                          (asset "EQUITIES::CSCO//USD" "CSCO")
                                                                          (asset "EQUITIES::ADBE//USD" "ADBE")
                                                                          (asset "EQUITIES::COST//USD" "COST")
                                                                          (asset "EQUITIES::PEP//USD" "PEP")
                                                                          (asset "EQUITIES::AVGO//USD" "AVGO")
                                                                          (asset "EQUITIES::GOOG//USD" "GOOG")
                                                                          (asset "EQUITIES::GOOGL//USD" "GOOGL")
                                                                          (asset "EQUITIES::META//USD" "META")
                                                                          (asset "EQUITIES::TSLA//USD" "TSLA")
                                                                          (asset "EQUITIES::AMZN//USD" "AMZN")
                                                                          (asset "EQUITIES::NVDA//USD" "NVDA")
                                                                          (asset "EQUITIES::AAPL//USD" "AAPL")
                                                                          (asset "EQUITIES::MSFT//USD" "MSFT")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (asset "EQUITIES::BIL//USD" "BIL")
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ] [
                                                    (group "LONG (HIGH BETA 2-3)" [
                                                      (weight-equal [
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ] [
                                                (group "LONG (HIGH BETA 2-3)" [
                                                  (weight-equal [
                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                    (asset "EQUITIES::SVXY//USD" "SVXY")
                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ] [
                                            (group "LONG (HIGH BETA 2-3)" [
                                              (weight-equal [
                                                (asset "EQUITIES::SOXL//USD" "SOXL")
                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                (asset "EQUITIES::SVXY//USD" "SVXY")
                                                (asset "EQUITIES::TECL//USD" "TECL")
                                              ])
                                            ])
                                          ])
                                        ])
                                      ] [
                                        (group "LONG (HIGH BETA 2-3)" [
                                          (weight-equal [
                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (asset "EQUITIES::TECL//USD" "TECL")
                                          ])
                                        ])
                                      ])
                                    ])
                                  ] [
                                    (group "LONG (HIGH BETA 2-3)" [
                                      (weight-equal [
                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                        (asset "EQUITIES::TECL//USD" "TECL")
                                      ])
                                    ])
                                  ])
                                ])
                              ] [
                                (group "SHORT (Negative Beta -1 to -3)" [
                                  (weight-equal [
                                    (group "SHORT GROUP (UVXY)" [
                                      (weight-equal [
                                        (weight-equal [
                                          (filter (standard-deviation-return 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                          ])
                                          (filter (cumulative-return 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                          ])
                                          (filter (rsi 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                          ])
                                        ])
                                        (weight-equal [
                                          (filter (standard-deviation-return 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                          ])
                                          (filter (cumulative-return 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                          ])
                                          (filter (rsi 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                          ])
                                        ])
                                        (weight-equal [
                                          (filter (standard-deviation-return 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                          ])
                                          (filter (cumulative-return 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                          ])
                                          (filter (rsi 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "SHORT GROUP (NO UVXY)" [
                                      (weight-equal [
                                        (weight-equal [
                                          (filter (standard-deviation-return 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                          ])
                                          (filter (cumulative-return 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                          ])
                                          (filter (rsi 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                          ])
                                        ])
                                        (weight-equal [
                                          (filter (standard-deviation-return 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                          ])
                                          (filter (cumulative-return 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                          ])
                                          (filter (rsi 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                          ])
                                        ])
                                        (weight-equal [
                                          (filter (standard-deviation-return 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                          ])
                                          (filter (cumulative-return 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                          ])
                                          (filter (rsi 20) (select-top 1) [
                                            (asset "EQUITIES::TECS//USD" "TECS")
                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ] [
                            (group "SHORT (Negative Beta -1 to -3)" [
                              (weight-equal [
                                (group "SHORT GROUP (UVXY)" [
                                  (weight-equal [
                                    (weight-equal [
                                      (filter (standard-deviation-return 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                      ])
                                      (filter (cumulative-return 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                      ])
                                      (filter (rsi 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                      ])
                                    ])
                                    (weight-equal [
                                      (filter (standard-deviation-return 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                      ])
                                      (filter (cumulative-return 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                      ])
                                      (filter (rsi 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                      ])
                                    ])
                                    (weight-equal [
                                      (filter (standard-deviation-return 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                      ])
                                      (filter (cumulative-return 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                      ])
                                      (filter (rsi 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                      ])
                                    ])
                                  ])
                                ])
                                (group "SHORT GROUP (NO UVXY)" [
                                  (weight-equal [
                                    (weight-equal [
                                      (filter (standard-deviation-return 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                      ])
                                      (filter (cumulative-return 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                      ])
                                      (filter (rsi 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                      ])
                                    ])
                                    (weight-equal [
                                      (filter (standard-deviation-return 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                      ])
                                      (filter (cumulative-return 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                      ])
                                      (filter (rsi 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                      ])
                                    ])
                                    (weight-equal [
                                      (filter (standard-deviation-return 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                      ])
                                      (filter (cumulative-return 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                      ])
                                      (filter (rsi 20) (select-top 1) [
                                        (asset "EQUITIES::TECS//USD" "TECS")
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ] [
                        (group "SHORT (Negative Beta -1 to -3)" [
                          (weight-equal [
                            (group "SHORT GROUP (UVXY)" [
                              (weight-equal [
                                (weight-equal [
                                  (filter (standard-deviation-return 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                  ])
                                  (filter (cumulative-return 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                  ])
                                  (filter (rsi 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                  ])
                                ])
                                (weight-equal [
                                  (filter (standard-deviation-return 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                  ])
                                  (filter (cumulative-return 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                  ])
                                  (filter (rsi 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                  ])
                                ])
                                (weight-equal [
                                  (filter (standard-deviation-return 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                  ])
                                  (filter (cumulative-return 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                  ])
                                  (filter (rsi 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                  ])
                                ])
                              ])
                            ])
                            (group "SHORT GROUP (NO UVXY)" [
                              (weight-equal [
                                (weight-equal [
                                  (filter (standard-deviation-return 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                  ])
                                  (filter (cumulative-return 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                  ])
                                  (filter (rsi 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                  ])
                                ])
                                (weight-equal [
                                  (filter (standard-deviation-return 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                  ])
                                  (filter (cumulative-return 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                  ])
                                  (filter (rsi 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                  ])
                                ])
                                (weight-equal [
                                  (filter (standard-deviation-return 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                  ])
                                  (filter (cumulative-return 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                  ])
                                  (filter (rsi 20) (select-top 1) [
                                    (asset "EQUITIES::TECS//USD" "TECS")
                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                    (asset "EQUITIES::SOXS//USD" "SOXS")
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ] [
                    (group "SHORT (Negative Beta -1 to -3)" [
                      (weight-equal [
                        (group "SHORT GROUP (UVXY)" [
                          (weight-equal [
                            (weight-equal [
                              (filter (standard-deviation-return 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                                (asset "EQUITIES::UVXY//USD" "UVXY")
                              ])
                              (filter (cumulative-return 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                                (asset "EQUITIES::UVXY//USD" "UVXY")
                              ])
                              (filter (rsi 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                                (asset "EQUITIES::UVXY//USD" "UVXY")
                              ])
                            ])
                            (weight-equal [
                              (filter (standard-deviation-return 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                                (asset "EQUITIES::UVXY//USD" "UVXY")
                              ])
                              (filter (cumulative-return 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                                (asset "EQUITIES::UVXY//USD" "UVXY")
                              ])
                              (filter (rsi 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                                (asset "EQUITIES::UVXY//USD" "UVXY")
                              ])
                            ])
                            (weight-equal [
                              (filter (standard-deviation-return 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                                (asset "EQUITIES::UVXY//USD" "UVXY")
                              ])
                              (filter (cumulative-return 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                                (asset "EQUITIES::UVXY//USD" "UVXY")
                              ])
                              (filter (rsi 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                                (asset "EQUITIES::UVXY//USD" "UVXY")
                              ])
                            ])
                          ])
                        ])
                        (group "SHORT GROUP (NO UVXY)" [
                          (weight-equal [
                            (weight-equal [
                              (filter (standard-deviation-return 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                              ])
                              (filter (cumulative-return 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                              ])
                              (filter (rsi 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                              ])
                            ])
                            (weight-equal [
                              (filter (standard-deviation-return 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                              ])
                              (filter (cumulative-return 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                              ])
                              (filter (rsi 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                              ])
                            ])
                            (weight-equal [
                              (filter (standard-deviation-return 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                              ])
                              (filter (cumulative-return 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                              ])
                              (filter (rsi 20) (select-top 1) [
                                (asset "EQUITIES::TECS//USD" "TECS")
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::SOXS//USD" "SOXS")
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ] [
                (group "SHORT (Negative Beta -1 to -3)" [
                  (weight-equal [
                    (group "SHORT GROUP (UVXY)" [
                      (weight-equal [
                        (weight-equal [
                          (filter (standard-deviation-return 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ])
                          (filter (cumulative-return 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ])
                          (filter (rsi 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ])
                        ])
                        (weight-equal [
                          (filter (standard-deviation-return 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ])
                          (filter (cumulative-return 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ])
                          (filter (rsi 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ])
                        ])
                        (weight-equal [
                          (filter (standard-deviation-return 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ])
                          (filter (cumulative-return 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ])
                          (filter (rsi 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ])
                        ])
                      ])
                    ])
                    (group "SHORT GROUP (NO UVXY)" [
                      (weight-equal [
                        (weight-equal [
                          (filter (standard-deviation-return 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                          ])
                          (filter (cumulative-return 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                          ])
                          (filter (rsi 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                          ])
                        ])
                        (weight-equal [
                          (filter (standard-deviation-return 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                          ])
                          (filter (cumulative-return 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                          ])
                          (filter (rsi 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                          ])
                        ])
                        (weight-equal [
                          (filter (standard-deviation-return 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                          ])
                          (filter (cumulative-return 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                          ])
                          (filter (rsi 20) (select-top 1) [
                            (asset "EQUITIES::TECS//USD" "TECS")
                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                            (asset "EQUITIES::SOXS//USD" "SOXS")
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
        ] [
          (weight-equal [
            (group "S9" [
              (weight-equal [
                (weight-equal [
                  (weight-specified [95 5] [
                    (if (< (cumulative-return "EQUITIES::QQQ//USD" 5) -5.5) [
                      (group "Volatile Market" [
                        (weight-specified [20 80] [
                          (group "Conditional VXX" [
                            (weight-equal [
                              (if (> (rsi "EQUITIES::UVXY//USD" 21) 62) [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::UVXY//USD" 10) 74) [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::UVXY//USD" 10) 84) [
                                        (weight-equal [
                                          (if (< (cumulative-return "EQUITIES::UVXY//USD" 2) 4.5) [
                                            (asset "EQUITIES::FLOT//USD" "FLOT")
                                          ] [
                                            (asset "EQUITIES::FLOT//USD" "FLOT")
                                            (asset "EQUITIES::FLOT//USD" "FLOT")
                                            (asset "EQUITIES::VXX//USD" "VXX")
                                            (asset "EQUITIES::VXX//USD" "VXX")
                                            (asset "EQUITIES::FLOT//USD" "FLOT")
                                            (asset "EQUITIES::FLOT//USD" "FLOT")
                                          ])
                                        ])
                                      ] [
                                        (asset "EQUITIES::FLOT//USD" "FLOT")
                                      ])
                                    ])
                                  ] [
                                    (asset "EQUITIES::FLOT//USD" "FLOT")
                                  ])
                                ])
                              ] [
                                (weight-specified {"BIL" 100} [
                                  (asset "EQUITIES::BIL//USD" "BIL")
                                ])
                              ])
                            ])
                          ])
                          (asset "EQUITIES::BIL//USD" "BIL")
                        ])
                      ])
                    ] [
                      (group "Core" [
                        (weight-specified [70 30] [
                          (group "Combo 4 QQQ Gold Bonds Short (48,11,2012)" [
                            (weight-equal [
                              (group "Gold - V0.0 - (33,50,2009)" [
                                (weight-equal [
                                  (if (> (moving-average-price "EQUITIES::UGL//USD" 50) (moving-average-price "EQUITIES::UGL//USD" 200)) [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::UGL//USD" 20) 80) [
                                        (asset "EQUITIES::GLL//USD" "GLL")
                                      ] [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::UGL//USD" 10) 90) [
                                            (asset "EQUITIES::GLL//USD" "GLL")
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::UGL//USD" 2) 99.9) [
                                                (asset "EQUITIES::GLL//USD" "GLL")
                                              ] [
                                                (asset "EQUITIES::UGL//USD" "UGL")
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ] [
                                    (weight-equal [
                                      (if (> (moving-average-price "EQUITIES::UGL//USD" 20) (moving-average-price "EQUITIES::UGL//USD" 50)) [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::UGL//USD" 20) 75) [
                                            (asset "EQUITIES::GLL//USD" "GLL")
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::UGL//USD" 2) 99.9) [
                                                (asset "EQUITIES::GLL//USD" "GLL")
                                              ] [
                                                (asset "EQUITIES::UGL//USD" "UGL")
                                              ])
                                            ])
                                          ])
                                        ])
                                      ] [
                                        (weight-equal [
                                          (if (> (moving-average-price "EQUITIES::UGL//USD" 5) (moving-average-price "EQUITIES::UGL//USD" 10)) [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::UGL//USD" 10) 60) [
                                                (asset "EQUITIES::GLL//USD" "GLL")
                                              ] [
                                                (asset "EQUITIES::UGL//USD" "UGL")
                                              ])
                                            ])
                                          ] [
                                            (weight-equal [
                                              (if (< (rsi "EQUITIES::UGL//USD" 20) 30) [
                                                (asset "EQUITIES::UGL//USD" "UGL")
                                              ] [
                                                (asset "EQUITIES::GLL//USD" "GLL")
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                              (group "Bonds - V0.0 - (60,28,2009)" [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::TMF//USD" 10) 85) [
                                    (asset "EQUITIES::TMV//USD" "TMV")
                                  ] [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::TMF//USD" 10) 32) [
                                        (asset "EQUITIES::TMF//USD" "TMF")
                                      ] [
                                        (weight-equal [
                                          (if (> (current-price "EQUITIES::TLT//USD" 10) (moving-average-price "EQUITIES::TLT//USD" 200)) [
                                            (weight-equal [
                                              (if (< (rsi "EQUITIES::BIL//USD" 30) (rsi "EQUITIES::TLT//USD" 20)) [
                                                (weight-equal [
                                                  (if (< (exponential-moving-average-price "EQUITIES::TMF//USD" 8) (moving-average-price "EQUITIES::TMF//USD" 10)) [
                                                    (asset "EQUITIES::TMF//USD" "TMF")
                                                  ] [
                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                  ])
                                                ])
                                              ] [
                                                (asset "EQUITIES::BIL//USD" "BIL")
                                              ])
                                            ])
                                          ] [
                                            (weight-equal [
                                              (if (> (moving-average-price "EQUITIES::TMV//USD" 15) (moving-average-price "EQUITIES::TMV//USD" 50)) [
                                                (weight-equal [
                                                  (if (> (current-price "EQUITIES::TMV//USD" 10) (moving-average-price "EQUITIES::TMV//USD" 135)) [
                                                    (weight-equal [
                                                      (if (> (rsi "EQUITIES::TMV//USD" 10) 65) [
                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                      ] [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::TMV//USD" 60) 59) [
                                                            (asset "EQUITIES::TMF//USD" "TMF")
                                                          ] [
                                                            (asset "EQUITIES::TMV//USD" "TMV")
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ] [
                                                    (asset "EQUITIES::TMF//USD" "TMF")
                                                  ])
                                                ])
                                              ] [
                                                (asset "EQUITIES::TMF//USD" "TMF")
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                              (group "Hg Short Only V0.2 (57,19,2011)" [
                                (weight-equal [
                                  (if (> (current-price "EQUITIES::SPY//USD" 2) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                                        (weight-equal [
                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                        ])
                                      ] [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::SPY//USD" 10) 79) [
                                            (weight-equal [
                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                            ])
                                          ] [
                                            (weight-equal [
                                              (asset "EQUITIES::BOND//USD" "BOND")
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ] [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                        (weight-equal [
                                          (asset "EQUITIES::BOND//USD" "BOND")
                                        ])
                                      ] [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::UPRO//USD" 10) 31) [
                                            (weight-equal [
                                              (asset "EQUITIES::BOND//USD" "BOND")
                                            ])
                                          ] [
                                            (weight-equal [
                                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -11) [
                                                (group "Buy the dips. Sell the rips. V2" [
                                                  (weight-equal [
                                                    (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                      (weight-equal [
                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (asset "EQUITIES::BOND//USD" "BOND")
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ] [
                                                (weight-equal [
                                                  (if (> (current-price "EQUITIES::QLD//USD" 10) (moving-average-price "EQUITIES::QLD//USD" 20)) [
                                                    (weight-equal [
                                                      (asset "EQUITIES::BOND//USD" "BOND")
                                                    ])
                                                  ] [
                                                    (weight-equal [
                                                      (if (> (moving-average-return "EQUITIES::TLT//USD" 20) (moving-average-return "EQUITIES::UDN//USD" 20)) [
                                                        (weight-equal [
                                                          (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                        ])
                                                      ] [
                                                        (weight-equal [
                                                          (filter (rsi 10) (select-bottom 1) [
                                                            (asset "EQUITIES::UUP//USD" "UUP")
                                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                              (group "QQQ FTLT V0.0 (35,21,1999)" [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                    (weight-equal [
                                      (filter (rsi 10) (select-bottom 1) [
                                        (asset "EQUITIES::XLP//USD" "XLP")
                                        (asset "EQUITIES::VBF//USD" "VBF")
                                      ])
                                    ])
                                  ] [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                                        (weight-equal [
                                          (filter (rsi 10) (select-bottom 1) [
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::VBF//USD" "VBF")
                                          ])
                                        ])
                                      ] [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::XLP//USD" 10) 77) [
                                            (weight-equal [
                                              (filter (rsi 10) (select-bottom 1) [
                                                (asset "EQUITIES::XLP//USD" "XLP")
                                                (asset "EQUITIES::VBF//USD" "VBF")
                                              ])
                                            ])
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::XLF//USD" 10) 81) [
                                                (weight-equal [
                                                  (filter (rsi 10) (select-bottom 1) [
                                                    (asset "EQUITIES::XLP//USD" "XLP")
                                                    (asset "EQUITIES::VBF//USD" "VBF")
                                                  ])
                                                ])
                                              ] [
                                                (weight-equal [
                                                  (if (> (rsi "EQUITIES::SPY//USD" 70) 60) [
                                                    (weight-equal [
                                                      (filter (rsi 10) (select-bottom 1) [
                                                        (asset "EQUITIES::XLP//USD" "XLP")
                                                        (asset "EQUITIES::VBF//USD" "VBF")
                                                      ])
                                                    ])
                                                  ] [
                                                    (group "FTLT" [
                                                      (weight-equal [
                                                        (if (< (cumulative-return "EQUITIES::QQQ//USD" 5) -5) [
                                                          (group "Mean Reversion" [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::SPY//USD" 10) 32.5) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              ] [
                                                                (weight-equal [
                                                                  (filter (rsi 10) (select-bottom 1) [
                                                                    (asset "EQUITIES::XLP//USD" "XLP")
                                                                    (asset "EQUITIES::VBF//USD" "VBF")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                              (group "Bull" [
                                                                (weight-equal [
                                                                  (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 25)) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (cumulative-return "EQUITIES::QQQ//USD" 20) (moving-average-return "EQUITIES::QQQ//USD" 10)) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ] [
                                                                        (weight-equal [
                                                                          (filter (rsi 10) (select-bottom 1) [
                                                                            (asset "EQUITIES::XLP//USD" "XLP")
                                                                            (asset "EQUITIES::VBF//USD" "VBF")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (group "Bear" [
                                                                (weight-equal [
                                                                  (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (< (cumulative-return "EQUITIES::QQQ//USD" 60) -11) [
                                                                        (group "XLK vs XLE" [
                                                                          (weight-equal [
                                                                            (filter (rsi 10) (select-bottom 1) [
                                                                              (asset "EQUITIES::XLP//USD" "XLP")
                                                                              (asset "EQUITIES::VBF//USD" "VBF")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 25)) [
                                                                            (weight-equal [
                                                                              (if (> (cumulative-return "EQUITIES::QQQ//USD" 10) 5) [
                                                                                (weight-equal [
                                                                                  (filter (rsi 10) (select-bottom 1) [
                                                                                    (asset "EQUITIES::XLP//USD" "XLP")
                                                                                    (asset "EQUITIES::VBF//USD" "VBF")
                                                                                  ])
                                                                                ])
                                                                              ] [
                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (filter (rsi 10) (select-bottom 1) [
                                                                                (asset "EQUITIES::XLP//USD" "XLP")
                                                                                (asset "EQUITIES::VBF//USD" "VBF")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                          (group "Tariff block" [
                            (weight-equal [
                              (weight-equal [
                                (weight-specified [100] [
                                  (if (> (rsi "EQUITIES::VIXY//USD" 5) 85) [
                                    (asset "EQUITIES::BIL//USD" "BIL")
                                  ] [
                                    (group "Core" [
                                      (weight-equal [
                                        (group "Tariff block TQQQ/TECL + SPXL + SOXL" [
                                          (weight-specified [10 15 40 35] [
                                            (group "NOVA VS. DERECK Hedge" [
                                              (weight-equal [
                                                (filter (rsi 20) (select-top 1) [
                                                  (group "Nova Hedge Block" [
                                                    (weight-equal [
                                                      (group "Foreign RINF" [
                                                        (weight-equal [
                                                          (if (> (current-price "EQUITIES::RINF//USD" 10) (moving-average-price "EQUITIES::RINF//USD" 50)) [
                                                            (weight-equal [
                                                              (if (> (current-price "EQUITIES::EEM//USD" 10) (moving-average-price "EQUITIES::EEM//USD" 200)) [
                                                                (group "IEI vs IWM" [
                                                                  (weight-equal [
                                                                    (if (> (rsi "EQUITIES::IEI//USD" 10) (rsi "EQUITIES::IWM//USD" 15)) [
                                                                      (asset "EQUITIES::EDC//USD" "EDC")
                                                                    ] [
                                                                      (asset "EQUITIES::EDZ//USD" "EDZ")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (group "IGIB vs EEM" [
                                                                  (weight-equal [
                                                                    (if (> (rsi "EQUITIES::IGIB//USD" 15) (rsi "EQUITIES::EEM//USD" 15)) [
                                                                      (asset "EQUITIES::EDC//USD" "EDC")
                                                                    ] [
                                                                      (asset "EQUITIES::EDZ//USD" "EDZ")
                                                                    ])
                                                                  ])
                                                                ])
                                                                (group "IGIB vs SPY" [
                                                                  (weight-equal [
                                                                    (if (> (rsi "EQUITIES::IGIB//USD" 10) (rsi "EQUITIES::SPY//USD" 15)) [
                                                                      (asset "EQUITIES::EDC//USD" "EDC")
                                                                    ] [
                                                                      (asset "EQUITIES::EDZ//USD" "EDZ")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ] [
                                                            (group "IGIB vs SPY" [
                                                              (weight-equal [
                                                                (if (> (rsi "EQUITIES::IGIB//USD" 10) (rsi "EQUITIES::SPY//USD" 15)) [
                                                                  (asset "EQUITIES::EDC//USD" "EDC")
                                                                ] [
                                                                  (asset "EQUITIES::EDZ//USD" "EDZ")
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                      (group "FTLT/Bull/Bonds" [
                                                        (weight-equal [
                                                          (if (< (cumulative-return "EQUITIES::QQQ//USD" 5) -4) [
                                                            (group "Mean Reversion" [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                  (group "Ticker Mixer" [
                                                                    (weight-equal [
                                                                      (group "Bottom 3 CR" [
                                                                        (weight-equal [
                                                                          (filter (cumulative-return 20) (select-bottom 3) [
                                                                            (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (group "SVXY FTLT" [
                                                                    (weight-equal [
                                                                      (if (> (current-price "EQUITIES::SVXY//USD" 10) (moving-average-price "EQUITIES::SVXY//USD" 25)) [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 20) (select-top 1) [
                                                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                            (asset "EQUITIES::VTI//USD" "VTI")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ] [
                                                            (group "FTLT/Bull/Bonds" [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::XLU//USD" 126) (rsi "EQUITIES::XLK//USD" 126)) [
                                                                  (group "Compares" [
                                                                    (weight-equal [
                                                                      (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                        (group "Ticker Mixer" [
                                                                          (weight-equal [
                                                                            (group "Bottom 3 CR" [
                                                                              (weight-equal [
                                                                                (filter (cumulative-return 20) (select-bottom 3) [
                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (rsi "EQUITIES::AGG//USD" 21) (rsi "EQUITIES::SPHB//USD" 21)) [
                                                                            (group "Ticker Mixer" [
                                                                              (weight-equal [
                                                                                (group "Bottom 3 CR" [
                                                                                  (weight-equal [
                                                                                    (filter (cumulative-return 20) (select-bottom 3) [
                                                                                      (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::TLT//USD" 126) 50) [
                                                                      (group "20/60" [
                                                                        (weight-equal [
                                                                          (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          ] [
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (group "TMF or XLP" [
                                                                        (weight-equal [
                                                                          (filter (rsi 20) (select-bottom 1) [
                                                                            (asset "EQUITIES::TMF//USD" "TMF")
                                                                            (asset "EQUITIES::XLP//USD" "XLP")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                      (group "Modified Foreign Rat" [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::VIXM//USD" 14) 70) [
                                                            (group "TQQQ or not | BlackSwan MeanRev BondSignal" [
                                                              (weight-equal [
                                                                (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                                  (asset "EQUITIES::BIL//USD" "BIL")
                                                                  (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                ] [
                                                                  (weight-equal [
                                                                    (group "Huge volatility" [
                                                                      (weight-equal [
                                                                        (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -13) [
                                                                          (weight-equal [
                                                                            (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 6) [
                                                                              (weight-equal [
                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (group "Mean Rev" [
                                                                                  (weight-equal [
                                                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (< (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                          (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                        ] [
                                                                                          (weight-equal [
                                                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (group "Normal market" [
                                                                              (weight-equal [
                                                                                (if (> (max-drawdown "EQUITIES::QQQ//USD" 10) 6) [
                                                                                  (asset "EQUITIES::BIL//USD" "BIL")
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (> (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                      (asset "EQUITIES::BIL//USD" "BIL")
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 25)) [
                                                                                          (weight-equal [
                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                          ])
                                                                                        ] [
                                                                                          (weight-equal [
                                                                                            (if (> (rsi "EQUITIES::SPY//USD" 60) 50) [
                                                                                              (group "Bond > Stock" [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  ] [
                                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ] [
                                                                                              (group "Bond Mid-term < Long-term" [
                                                                                                (weight-equal [
                                                                                                  (if (< (rsi "EQUITIES::IEF//USD" 200) (rsi "EQUITIES::TLT//USD" 200)) [
                                                                                                    (weight-equal [
                                                                                                      (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                      ] [
                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                      ])
                                                                                                    ])
                                                                                                  ] [
                                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (if (> (current-price "EQUITIES::EEM//USD" 10) (moving-average-price "EQUITIES::EEM//USD" 200)) [
                                                                (weight-equal [
                                                                  (if (> (rsi "EQUITIES::IEI//USD" 11) (rsi "EQUITIES::IWM//USD" 16)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::EDC//USD" "EDC")
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::EDZ//USD" "EDZ")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (rsi "EQUITIES::IEI//USD" 11) (rsi "EQUITIES::EEM//USD" 16)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::EDC//USD" "EDC")
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::EDZ//USD" "EDZ")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                      (group "Low Voltage w/ Frontrunner" [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::IOO//USD" 10) 80) [
                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                          ] [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (rsi "EQUITIES::VTV//USD" 10) 80) [
                                                                        (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (rsi "EQUITIES::VOX//USD" 10) 79) [
                                                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (> (rsi "EQUITIES::XLP//USD" 10) 78) [
                                                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (if (> (rsi "EQUITIES::XLF//USD" 10) 81) [
                                                                                    (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                                  ] [
                                                                                    (weight-equal [
                                                                                      (group "Grail" [
                                                                                        (weight-equal [
                                                                                          (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 200)) [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                              ] [
                                                                                                (asset "EQUITIES::QLD//USD" "QLD")
                                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                              ])
                                                                                            ])
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                                                (asset "EQUITIES::XLK//USD" "XLK")
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                                                                                    (asset "EQUITIES::SOXX//USD" "SOXX")
                                                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (if (< (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                                        (weight-equal [
                                                                                                          (filter (rsi 20) (select-top 1) [
                                                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                            (asset "EQUITIES::BSV//USD" "BSV")
                                                                                                          ])
                                                                                                        ])
                                                                                                      ] [
                                                                                                        (asset "EQUITIES::QLD//USD" "QLD")
                                                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                      (group "JRT" [
                                                                                        (weight-equal [
                                                                                          (weight-inverse-vol 10 [
                                                                                            (asset "EQUITIES::LLY//USD" "LLY")
                                                                                            (asset "EQUITIES::NVO//USD" "NVO")
                                                                                            (asset "EQUITIES::COST//USD" "COST")
                                                                                            (group "PGR || GE" [
                                                                                              (weight-equal [
                                                                                                (filter (moving-average-return 60) (select-top 1) [
                                                                                                  (asset "EQUITIES::PGR//USD" "PGR")
                                                                                                  (asset "EQUITIES::GE//USD" "GE")
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                  (group "DereckN Hedge System" [
                                                    (weight-equal [
                                                      (group "TMV Momentum" [
                                                        (weight-equal [
                                                          (if (< (rsi "EQUITIES::TMF//USD" 10) 32) [
                                                            (asset "EQUITIES::TMF//USD" "TMF")
                                                          ] [
                                                            (weight-equal [
                                                              (if (> (moving-average-price "EQUITIES::TMV//USD" 15) (moving-average-price "EQUITIES::TMV//USD" 50)) [
                                                                (weight-equal [
                                                                  (if (> (current-price "EQUITIES::TMV//USD" 10) (moving-average-price "EQUITIES::TMV//USD" 135)) [
                                                                    (weight-equal [
                                                                      (if (> (rsi "EQUITIES::TMV//USD" 10) 71) [
                                                                        (asset "EQUITIES::SHV//USD" "SHV")
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (rsi "EQUITIES::TMV//USD" 60) 59) [
                                                                            (asset "EQUITIES::TLT//USD" "TLT")
                                                                          ] [
                                                                            (asset "EQUITIES::TMV//USD" "TMV")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::BND//USD" "BND")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (asset "EQUITIES::BND//USD" "BND")
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                      (group "TMF Momentum" [
                                                        (weight-specified [100] [
                                                          (if (> (rsi "EQUITIES::QQQ//USD" 10) 80) [
                                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                                          ] [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                                              ] [
                                                                (weight-equal [
                                                                  (if (< (rsi "EQUITIES::TMF//USD" 10) 32) [
                                                                    (asset "EQUITIES::TMF//USD" "TMF")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (< (rsi "EQUITIES::BIL//USD" 30) (rsi "EQUITIES::TLT//USD" 20)) [
                                                                        (weight-equal [
                                                                          (if (< (exponential-moving-average-price "EQUITIES::TMF//USD" 8) (moving-average-price "EQUITIES::TMF//USD" 10)) [
                                                                            (weight-equal [
                                                                              (if (> (rsi "EQUITIES::TMF//USD" 10) 72) [
                                                                                (asset "EQUITIES::SHV//USD" "SHV")
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (asset "EQUITIES::TMF//USD" "TMF")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (asset "EQUITIES::SHV//USD" "SHV")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                          ] [
                                                                            (weight-equal [
                                                                              (asset "EQUITIES::SHV//USD" "SHV")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                      (group "SVXY FTLT" [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::QQQ//USD" 10) 80) [
                                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                                          ] [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                                              ] [
                                                                (weight-equal [
                                                                  (if (< (rsi "EQUITIES::QQQ//USD" 10) 30) [
                                                                    (asset "EQUITIES::XLK//USD" "XLK")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (current-price "EQUITIES::SVXY//USD" 10) (moving-average-price "EQUITIES::SVXY//USD" 24)) [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 20) (select-top 1) [
                                                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                            (asset "EQUITIES::VTI//USD" "VTI")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                      (group "TINA" [
                                                        (weight-equal [
                                                          (if (> (current-price "EQUITIES::QQQ//USD" 3) (moving-average-price "EQUITIES::QQQ//USD" 20)) [
                                                            (weight-equal [
                                                              (if (> (cumulative-return "EQUITIES::QQQ//USD" 10) 5.5) [
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              ] [
                                                                (weight-equal [
                                                                  (if (< (cumulative-return "EQUITIES::TQQQ//USD" 62) -33) [
                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::SHV//USD" "SHV")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::QQQ//USD" 10) 30) [
                                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                              ] [
                                                                (weight-equal [
                                                                  (if (< (cumulative-return "EQUITIES::TQQQ//USD" 62) -33) [
                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (filter (rsi 20) (select-top 1) [
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::BSV//USD" "BSV")
                                                                        (asset "EQUITIES::TLT//USD" "TLT")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                      (group "Shorting SPY" [
                                                        (weight-equal [
                                                          (group "20d BND vs 60d SH Logic To Go Short" [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                (weight-equal [
                                                                  (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::SHV//USD" "SHV")
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (< (rsi "EQUITIES::QQQ//USD" 10) 30) [
                                                                        (asset "EQUITIES::XLK//USD" "XLK")
                                                                      ] [
                                                                        (asset "EQUITIES::SHV//USD" "SHV")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (< (rsi "EQUITIES::QQQ//USD" 10) 30) [
                                                                    (asset "EQUITIES::XLK//USD" "XLK")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (< (exponential-moving-average-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 10)) [
                                                                        (asset "EQUITIES::SH//USD" "SH")
                                                                      ] [
                                                                        (asset "EQUITIES::SHV//USD" "SHV")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                      (group "SVXY FTLT | V2" [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::QQQ//USD" 10) 80) [
                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                          ] [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                                              ] [
                                                                (weight-equal [
                                                                  (if (< (rsi "EQUITIES::QQQ//USD" 10) 30) [
                                                                    (asset "EQUITIES::XLK//USD" "XLK")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (current-price "EQUITIES::SVXY//USD" 10) (moving-average-price "EQUITIES::SVXY//USD" 21)) [
                                                                        (weight-specified [70 30] [
                                                                          (filter (moving-average-return 20) (select-top 1) [
                                                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                            (asset "EQUITIES::VTI//USD" "VTI")
                                                                          ])
                                                                          (weight-equal [
                                                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 20) (select-top 1) [
                                                                            (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                            (group "Sohail - BIL FR> Agressive Battleship III Sort WM 74" [
                                              (weight-equal [
                                                (group "Vol->BIL Frontrunner" [
                                                  (weight-equal [
                                                    (if (> (rsi "EQUITIES::IOO//USD" 10) 80) [
                                                      (asset "EQUITIES::BIL//USD" "BIL")
                                                    ] [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::TQQQ//USD" 10) 81) [
                                                          (weight-equal [
                                                            (if (> (rsi "EQUITIES::UVXY//USD" 60) 40) [
                                                              (asset "EQUITIES::BIL//USD" "BIL")
                                                            ] [
                                                              (weight-equal [
                                                                (if (> (rsi "EQUITIES::RETL//USD" 10) 82) [
                                                                  (group "Scale-In | BTAL -> VIX" [
                                                                    (weight-equal [
                                                                      (if (> (rsi "EQUITIES::RETL//USD" 10) 85) [
                                                                        (group "VIX Blend" [
                                                                          (weight-equal [
                                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (group "BTAL/BIL" [
                                                                          (weight-equal [
                                                                            (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                            (asset "EQUITIES::SHV//USD" "SHV")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (> (rsi "EQUITIES::XLF//USD" 10) 81) [
                                                                      (group "Scale-In | VIX -> VIX+" [
                                                                        (weight-equal [
                                                                          (if (> (rsi "EQUITIES::XLF//USD" 10) 85) [
                                                                            (group "VIX Blend+" [
                                                                              (weight-equal [
                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (group "VIX Blend" [
                                                                              (weight-equal [
                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (asset "EQUITIES::SHV//USD" "SHV")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                              (weight-equal [
                                                                (if (> (rsi "EQUITIES::UVXY//USD" 60) 40) [
                                                                  (asset "EQUITIES::BIL//USD" "BIL")
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (> (rsi "EQUITIES::RETL//USD" 10) 82) [
                                                                      (group "Scale-In | BTAL -> VIX" [
                                                                        (weight-equal [
                                                                          (if (> (rsi "EQUITIES::RETL//USD" 10) 85) [
                                                                            (group "VIX Blend" [
                                                                              (weight-equal [
                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (group "BTAL/BIL" [
                                                                              (weight-equal [
                                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                (asset "EQUITIES::SHV//USD" "SHV")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (> (rsi "EQUITIES::XLF//USD" 10) 81) [
                                                                          (group "Scale-In | VIX -> VIX+" [
                                                                            (weight-equal [
                                                                              (if (> (rsi "EQUITIES::XLF//USD" 10) 85) [
                                                                                (group "VIX Blend+" [
                                                                                  (weight-equal [
                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                  ])
                                                                                ])
                                                                              ] [
                                                                                (group "VIX Blend" [
                                                                                  (weight-equal [
                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (asset "EQUITIES::SHV//USD" "SHV")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::SOXL//USD" 14) 30) [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::TECL//USD" 14) 30) [
                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::LABU//USD" 10) 22) [
                                                                          (weight-equal [
                                                                            (filter (cumulative-return 1) (select-bottom 1) [
                                                                              (asset "EQUITIES::LABU//USD" "LABU")
                                                                              (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::QQQ//USD" 14) 30) [
                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::SMH//USD" 10) 25) [
                                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (> (rsi "EQUITIES::TQQQ//USD" 14) 80) [
                                                                                      (asset "EQUITIES::TECS//USD" "TECS")
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (> (rsi "EQUITIES::SOXL//USD" 14) 80) [
                                                                                          (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                                        ] [
                                                                                          (weight-equal [
                                                                                            (if (> (rsi "EQUITIES::TMV//USD" 14) 80) [
                                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                                            ] [
                                                                                              (weight-equal [
                                                                                                (if (> (rsi "EQUITIES::SMH//USD" 10) 80) [
                                                                                                  (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                                                ] [
                                                                                                  (weight-equal [
                                                                                                    (group "V1 BWC: Ultimate Frontrunner" [
                                                                                                      (weight-equal [
                                                                                                        (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                                                                                                          (group "BWC Scale In VIX w/ VIXY RSI Check " [
                                                                                                            (weight-equal [
                                                                                                              (if (> (rsi "EQUITIES::VIXY//USD" 60) 40) [
                                                                                                                (group "1.5x VIX Group" [
                                                                                                                  (weight-equal [
                                                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ] [
                                                                                                                (weight-equal [
                                                                                                                  (if (> (rsi "EQUITIES::SPY//USD" 10) 82.5) [
                                                                                                                    (group "1.5x VIX Group" [
                                                                                                                      (weight-equal [
                                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ] [
                                                                                                                    (group "VIX Blend" [
                                                                                                                      (weight-specified {"BIL" 45 "BIL" 20 "BIL" 35} [
                                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ])
                                                                                                            ])
                                                                                                          ])
                                                                                                        ] [
                                                                                                          (weight-equal [
                                                                                                            (if (> (rsi "EQUITIES::SPY//USD" 10) 79) [
                                                                                                              (weight-equal [
                                                                                                                (group "BWC Scale In VIX w/ VIXY RSI Check " [
                                                                                                                  (weight-equal [
                                                                                                                    (if (> (rsi "EQUITIES::VIXY//USD" 60) 40) [
                                                                                                                      (group "1.5x VIX Group" [
                                                                                                                        (weight-equal [
                                                                                                                          (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                          (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ] [
                                                                                                                      (weight-equal [
                                                                                                                        (if (> (rsi "EQUITIES::QQQ//USD" 10) 82.5) [
                                                                                                                          (group "1.5x VIX Group" [
                                                                                                                            (weight-equal [
                                                                                                                              (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                              (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ] [
                                                                                                                          (group "VIX Blend" [
                                                                                                                            (weight-specified {"BIL" 45 "BIL" 20 "BIL" 35} [
                                                                                                                              (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                              (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                              (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ])
                                                                                                            ] [
                                                                                                              (weight-equal [
                                                                                                                (if (> (rsi "EQUITIES::IOO//USD" 10) 80) [
                                                                                                                  (weight-equal [
                                                                                                                    (group "BWC Scale In VIX w/ VIXY RSI Check " [
                                                                                                                      (weight-equal [
                                                                                                                        (if (> (rsi "EQUITIES::VIXY//USD" 60) 40) [
                                                                                                                          (group "1.5x VIX Group" [
                                                                                                                            (weight-equal [
                                                                                                                              (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                              (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ] [
                                                                                                                          (weight-equal [
                                                                                                                            (if (> (rsi "EQUITIES::IOO//USD" 10) 82.5) [
                                                                                                                              (group "1.5x VIX Group" [
                                                                                                                                (weight-equal [
                                                                                                                                  (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                  (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ] [
                                                                                                                              (group "1x VIX" [
                                                                                                                                (weight-equal [
                                                                                                                                  (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ] [
                                                                                                                  (weight-equal [
                                                                                                                    (if (> (rsi "EQUITIES::XLP//USD" 10) 77) [
                                                                                                                      (group "BWC Scale In VIX " [
                                                                                                                        (weight-equal [
                                                                                                                          (if (> (rsi "EQUITIES::XLP//USD" 10) 82.5) [
                                                                                                                            (group "1.5x VIX Group" [
                                                                                                                              (weight-equal [
                                                                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ] [
                                                                                                                            (group "1x VIX" [
                                                                                                                              (weight-equal [
                                                                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ] [
                                                                                                                      (weight-equal [
                                                                                                                        (if (> (rsi "EQUITIES::VTV//USD" 10) 79) [
                                                                                                                          (group "BWC Scale In VIX " [
                                                                                                                            (weight-equal [
                                                                                                                              (if (> (rsi "EQUITIES::VTV//USD" 10) 82.5) [
                                                                                                                                (group "1.5x VIX Group" [
                                                                                                                                  (weight-equal [
                                                                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ] [
                                                                                                                                (group "1x VIX" [
                                                                                                                                  (weight-equal [
                                                                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ] [
                                                                                                                          (weight-equal [
                                                                                                                            (if (> (rsi "EQUITIES::XLF//USD" 10) 81) [
                                                                                                                              (group "BWC Scale In VIX " [
                                                                                                                                (weight-equal [
                                                                                                                                  (if (> (rsi "EQUITIES::XLF//USD" 10) 85) [
                                                                                                                                    (group "1.5x VIX Group" [
                                                                                                                                      (weight-equal [
                                                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ] [
                                                                                                                                    (group "1x VIX" [
                                                                                                                                      (weight-equal [
                                                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ] [
                                                                                                                              (weight-equal [
                                                                                                                                (if (> (rsi "EQUITIES::VOX//USD" 10) 79) [
                                                                                                                                  (group "BWC Scale In VIX " [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (rsi "EQUITIES::VOX//USD" 10) 82.5) [
                                                                                                                                        (group "1.5x VIX Group" [
                                                                                                                                          (weight-equal [
                                                                                                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (group "1x VIX" [
                                                                                                                                          (weight-equal [
                                                                                                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ] [
                                                                                                                                  (weight-equal [
                                                                                                                                    (if (> (rsi "EQUITIES::CURE//USD" 10) 82) [
                                                                                                                                      (group "BWC Scale In VIX " [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (rsi "EQUITIES::CURE//USD" 10) 85) [
                                                                                                                                            (group "1.5x VIX Group" [
                                                                                                                                              (weight-equal [
                                                                                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                              ])
                                                                                                                                            ])
                                                                                                                                          ] [
                                                                                                                                            (group "1x VIX" [
                                                                                                                                              (weight-equal [
                                                                                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                              ])
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ] [
                                                                                                                                      (weight-equal [
                                                                                                                                        (if (> (rsi "EQUITIES::RETL//USD" 10) 82) [
                                                                                                                                          (group "BWC Scale In VIX " [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (rsi "EQUITIES::RETL//USD" 10) 85) [
                                                                                                                                                (group "1.5x VIX Group" [
                                                                                                                                                  (weight-equal [
                                                                                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ] [
                                                                                                                                                (group "1x VIX" [
                                                                                                                                                  (weight-equal [
                                                                                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ])
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                        ] [
                                                                                                                                          (weight-equal [
                                                                                                                                            (if (> (rsi "EQUITIES::LABU//USD" 10) 79) [
                                                                                                                                              (weight-equal [
                                                                                                                                                (asset "EQUITIES::LABD//USD" "LABD")
                                                                                                                                              ])
                                                                                                                                            ] [
                                                                                                                                              (weight-equal [
                                                                                                                                                (if (> (rsi "EQUITIES::SPY//USD" 70) 62) [
                                                                                                                                                  (group "Overbought" [
                                                                                                                                                    (weight-equal [
                                                                                                                                                      (group "AGG > QQQ" [
                                                                                                                                                        (weight-equal [
                                                                                                                                                          (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                                                                                            (group "All 3x Tech" [
                                                                                                                                                              (weight-equal [
                                                                                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                                                (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                                                                                (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                                                (asset "EQUITIES::ERX//USD" "ERX")
                                                                                                                                                              ])
                                                                                                                                                            ])
                                                                                                                                                          ] [
                                                                                                                                                            (group "GLD/SLV/PDBC" [
                                                                                                                                                              (weight-specified {"GLD" 50 "SLV" 25 "PDBC" 25} [
                                                                                                                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                                                                                                                (asset "EQUITIES::SLV//USD" "SLV")
                                                                                                                                                                (asset "EQUITIES::PDBC//USD" "PDBC")
                                                                                                                                                              ])
                                                                                                                                                            ])
                                                                                                                                                          ])
                                                                                                                                                        ])
                                                                                                                                                      ])
                                                                                                                                                      (group "VIX or Commodities" [
                                                                                                                                                        (weight-equal [
                                                                                                                                                          (if (> (rsi "EQUITIES::QQQ//USD" 90) 60) [
                                                                                                                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                          ] [
                                                                                                                                                            (weight-equal [
                                                                                                                                                              (if (> (rsi "EQUITIES::QQQ//USD" 14) 80) [
                                                                                                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                              ] [
                                                                                                                                                                (weight-equal [
                                                                                                                                                                  (if (> (rsi "EQUITIES::QQQ//USD" 5) 90) [
                                                                                                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                                  ] [
                                                                                                                                                                    (weight-equal [
                                                                                                                                                                      (if (> (rsi "EQUITIES::QQQ//USD" 3) 95) [
                                                                                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                                      ] [
                                                                                                                                                                        (group "GLD/SLV/PDBC" [
                                                                                                                                                                          (weight-specified {"GLD" 50 "SLV" 25 "PDBC" 25} [
                                                                                                                                                                            (asset "EQUITIES::GLD//USD" "GLD")
                                                                                                                                                                            (asset "EQUITIES::SLV//USD" "SLV")
                                                                                                                                                                            (asset "EQUITIES::PDBC//USD" "PDBC")
                                                                                                                                                                          ])
                                                                                                                                                                        ])
                                                                                                                                                                      ])
                                                                                                                                                                    ])
                                                                                                                                                                  ])
                                                                                                                                                                ])
                                                                                                                                                              ])
                                                                                                                                                            ])
                                                                                                                                                          ])
                                                                                                                                                        ])
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                  ])
                                                                                                                                                ] [
                                                                                                                                                  (group "Oversold Checks " [
                                                                                                                                                    (weight-equal [
                                                                                                                                                      (if (< (rsi "EQUITIES::SOXL//USD" 10) 25) [
                                                                                                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                                      ] [
                                                                                                                                                        (weight-equal [
                                                                                                                                                          (if (< (rsi "EQUITIES::SOXL//USD" 10) 25) [
                                                                                                                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                                          ] [
                                                                                                                                                            (weight-equal [
                                                                                                                                                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 28) [
                                                                                                                                                                (weight-equal [
                                                                                                                                                                  (filter (rsi 10) (select-bottom 2) [
                                                                                                                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                                                  ])
                                                                                                                                                                ])
                                                                                                                                                              ] [
                                                                                                                                                                (weight-equal [
                                                                                                                                                                  (if (< (rsi "EQUITIES::TECL//USD" 14) 25) [
                                                                                                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                                  ] [
                                                                                                                                                                    (weight-equal [
                                                                                                                                                                      (if (< (rsi "EQUITIES::UPRO//USD" 10) 25) [
                                                                                                                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                                                                                                      ] [
                                                                                                                                                                        (group "Isolated Volatility Bomb Block to catch extreme events (Overfit signal from COVID crash)" [
                                                                                                                                                                          (weight-equal [
                                                                                                                                                                            (if (> (rsi "EQUITIES::UVXY//USD" 21) 65) [
                                                                                                                                                                              (weight-equal [
                                                                                                                                                                                (if (> (rsi "EQUITIES::UVXY//USD" 10) 74) [
                                                                                                                                                                                  (weight-equal [
                                                                                                                                                                                    (if (< (rsi "EQUITIES::UVXY//USD" 10) 84) [
                                                                                                                                                                                      (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                                                    ] [
                                                                                                                                                                                      (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                                                    ])
                                                                                                                                                                                  ])
                                                                                                                                                                                ] [
                                                                                                                                                                                  (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                                                ])
                                                                                                                                                                              ])
                                                                                                                                                                            ] [
                                                                                                                                                                              (group "OOS Stuff but VIX -> BIL" [
                                                                                                                                                                                (weight-equal [
                                                                                                                                                                                  (weight-equal [
                                                                                                                                                                                    (group "Aggressive Battleship III Sort" [
                                                                                                                                                                                      (weight-equal [
                                                                                                                                                                                        (weight-equal [
                                                                                                                                                                                          (filter (max-drawdown 20) (select-top 1) [
                                                                                                                                                                                            (group "Battleship 1" [
                                                                                                                                                                                              (weight-equal [
                                                                                                                                                                                                (weight-equal [
                                                                                                                                                                                                  (if (> (rsi "EQUITIES::VIXM//USD" 40) 68) [
                                                                                                                                                                                                    (weight-equal [
                                                                                                                                                                                                      (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                                                                                                                                                    ])
                                                                                                                                                                                                  ] [
                                                                                                                                                                                                    (weight-equal [
                                                                                                                                                                                                      (if (< (cumulative-return "EQUITIES::QQQ//USD" 5) -4) [
                                                                                                                                                                                                        (weight-equal [
                                                                                                                                                                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5) [
                                                                                                                                                                                                            (asset "EQUITIES::BSV//USD" "BSV")
                                                                                                                                                                                                          ] [
                                                                                                                                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                                                                                          ])
                                                                                                                                                                                                        ])
                                                                                                                                                                                                      ] [
                                                                                                                                                                                                        (weight-equal [
                                                                                                                                                                                                          (filter (moving-average-return 20) (select-top 2) [
                                                                                                                                                                                                            (asset "EQUITIES::SPY//USD" "SPY")
                                                                                                                                                                                                            (asset "EQUITIES::DBC//USD" "DBC")
                                                                                                                                                                                                            (asset "EQUITIES::SHV//USD" "SHV")
                                                                                                                                                                                                            (asset "EQUITIES::IAU//USD" "IAU")
                                                                                                                                                                                                            (asset "EQUITIES::VEA//USD" "VEA")
                                                                                                                                                                                                            (asset "EQUITIES::UTSL//USD" "UTSL")
                                                                                                                                                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                                                                                                                                          ])
                                                                                                                                                                                                        ])
                                                                                                                                                                                                      ])
                                                                                                                                                                                                    ])
                                                                                                                                                                                                  ])
                                                                                                                                                                                                ])
                                                                                                                                                                                              ])
                                                                                                                                                                                            ])
                                                                                                                                                                                            (group "Battleship 2" [
                                                                                                                                                                                              (weight-equal [
                                                                                                                                                                                                (weight-equal [
                                                                                                                                                                                                  (if (> (rsi "EQUITIES::VIXM//USD" 40) 68) [
                                                                                                                                                                                                    (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                                                                                                                                                  ] [
                                                                                                                                                                                                    (weight-equal [
                                                                                                                                                                                                      (if (> (rsi "EQUITIES::SPY//USD" 100) (rsi "EQUITIES::XLP//USD" 100)) [
                                                                                                                                                                                                        (weight-equal [
                                                                                                                                                                                                          (if (> (exponential-moving-average-price "EQUITIES::SPY//USD" 100) (exponential-moving-average-price "EQUITIES::SPY//USD" 400)) [
                                                                                                                                                                                                            (weight-equal [
                                                                                                                                                                                                              (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                                                                                                                                                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                                                                                              ] [
                                                                                                                                                                                                                (weight-equal [
                                                                                                                                                                                                                  (if (< (cumulative-return "EQUITIES::SPY//USD" 5) -2.5) [
                                                                                                                                                                                                                    (weight-equal [
                                                                                                                                                                                                                      (if (> (cumulative-return "EQUITIES::SPY//USD" 1) 4) [
                                                                                                                                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                                                                                      ] [
                                                                                                                                                                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                                                                                                                                                      ])
                                                                                                                                                                                                                    ])
                                                                                                                                                                                                                  ] [
                                                                                                                                                                                                                    (weight-equal [
                                                                                                                                                                                                                      (filter (cumulative-return 20) (select-top 2) [
                                                                                                                                                                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                                                                                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                                                                                                      ])
                                                                                                                                                                                                                    ])
                                                                                                                                                                                                                  ])
                                                                                                                                                                                                                ])
                                                                                                                                                                                                              ])
                                                                                                                                                                                                            ])
                                                                                                                                                                                                          ] [
                                                                                                                                                                                                            (weight-equal [
                                                                                                                                                                                                              (filter (moving-average-return 20) (select-top 2) [
                                                                                                                                                                                                                (asset "EQUITIES::EFA//USD" "EFA")
                                                                                                                                                                                                                (asset "EQUITIES::EEM//USD" "EEM")
                                                                                                                                                                                                                (asset "EQUITIES::TLT//USD" "TLT")
                                                                                                                                                                                                                (asset "EQUITIES::SHY//USD" "SHY")
                                                                                                                                                                                                              ])
                                                                                                                                                                                                            ])
                                                                                                                                                                                                          ])
                                                                                                                                                                                                        ])
                                                                                                                                                                                                      ] [
                                                                                                                                                                                                        (group "DBC&others Bullish" [
                                                                                                                                                                                                          (weight-equal [
                                                                                                                                                                                                            (if (> (exponential-moving-average-price "EQUITIES::DBC//USD" 20) (exponential-moving-average-price "EQUITIES::DBC//USD" 50)) [
                                                                                                                                                                                                              (weight-equal [
                                                                                                                                                                                                                (filter (moving-average-return 20) (select-top 5) [
                                                                                                                                                                                                                  (asset "EQUITIES::DBC//USD" "DBC")
                                                                                                                                                                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                                                                                                                                                                  (asset "EQUITIES::SLV//USD" "SLV")
                                                                                                                                                                                                                  (asset "EQUITIES::USO//USD" "USO")
                                                                                                                                                                                                                  (asset "EQUITIES::WEAT//USD" "WEAT")
                                                                                                                                                                                                                  (asset "EQUITIES::CORN//USD" "CORN")
                                                                                                                                                                                                                  (asset "EQUITIES::SH//USD" "SH")
                                                                                                                                                                                                                  (asset "EQUITIES::DRN//USD" "DRN")
                                                                                                                                                                                                                  (asset "EQUITIES::PDBC//USD" "PDBC")
                                                                                                                                                                                                                  (asset "EQUITIES::COMT//USD" "COMT")
                                                                                                                                                                                                                  (asset "EQUITIES::KOLD//USD" "KOLD")
                                                                                                                                                                                                                  (asset "EQUITIES::BOIL//USD" "BOIL")
                                                                                                                                                                                                                  (asset "EQUITIES::ESPO//USD" "ESPO")
                                                                                                                                                                                                                  (asset "EQUITIES::PEJ//USD" "PEJ")
                                                                                                                                                                                                                ])
                                                                                                                                                                                                              ])
                                                                                                                                                                                                            ] [
                                                                                                                                                                                                              (group "Inflation Hedge  What did well Sep-Nov 20?" [
                                                                                                                                                                                                                (weight-equal [
                                                                                                                                                                                                                  (asset "EQUITIES::UGL//USD" "UGL")
                                                                                                                                                                                                                  (asset "EQUITIES::URE//USD" "URE")
                                                                                                                                                                                                                  (asset "EQUITIES::VXX//USD" "VXX")
                                                                                                                                                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                                                                                                  (asset "EQUITIES::UUP//USD" "UUP")
                                                                                                                                                                                                                ])
                                                                                                                                                                                                              ])
                                                                                                                                                                                                            ])
                                                                                                                                                                                                          ])
                                                                                                                                                                                                        ])
                                                                                                                                                                                                      ])
                                                                                                                                                                                                    ])
                                                                                                                                                                                                  ])
                                                                                                                                                                                                ])
                                                                                                                                                                                              ])
                                                                                                                                                                                            ])
                                                                                                                                                                                            (group "Battleship 3" [
                                                                                                                                                                                              (weight-equal [
                                                                                                                                                                                                (weight-equal [
                                                                                                                                                                                                  (weight-equal [
                                                                                                                                                                                                    (if (> (rsi "EQUITIES::VIXM//USD" 40) 68) [
                                                                                                                                                                                                      (weight-equal [
                                                                                                                                                                                                        (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                                                                                                                                                      ])
                                                                                                                                                                                                    ] [
                                                                                                                                                                                                      (weight-equal [
                                                                                                                                                                                                        (if (>= (cumulative-return "EQUITIES::BND//USD" 19) (cumulative-return "EQUITIES::BIL//USD" 19)) [
                                                                                                                                                                                                          (group "JEB! Risk On  Built off the JEB Dragon Equity Mod with a different lower part... to have wide sectors" [
                                                                                                                                                                                                            (weight-equal [
                                                                                                                                                                                                              (weight-equal [
                                                                                                                                                                                                                (if (> (moving-average-return "EQUITIES::QQQ//USD" 5) (moving-average-return "EQUITIES::QQQ//USD" 20)) [
                                                                                                                                                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                                                                                                ] [
                                                                                                                                                                                                                  (weight-equal [
                                                                                                                                                                                                                    (if (>= (moving-average-return "EQUITIES::SPY//USD" 5) (moving-average-return "EQUITIES::SPY//USD" 20)) [
                                                                                                                                                                                                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                                                                                                                                                    ] [
                                                                                                                                                                                                                      (weight-equal [
                                                                                                                                                                                                                        (if (>= (cumulative-return "EQUITIES::BND//USD" 10) (cumulative-return "EQUITIES::SPY//USD" 10)) [
                                                                                                                                                                                                                          (weight-equal [
                                                                                                                                                                                                                            (filter (moving-average-return 20) (select-top 9) [
                                                                                                                                                                                                                              (asset "EQUITIES::DUST//USD" "DUST")
                                                                                                                                                                                                                              (asset "EQUITIES::JDST//USD" "JDST")
                                                                                                                                                                                                                              (asset "EQUITIES::JNUG//USD" "JNUG")
                                                                                                                                                                                                                              (asset "EQUITIES::GUSH//USD" "GUSH")
                                                                                                                                                                                                                              (asset "EQUITIES::GLD//USD" "GLD")
                                                                                                                                                                                                                              (asset "EQUITIES::DBA//USD" "DBA")
                                                                                                                                                                                                                              (asset "EQUITIES::DBB//USD" "DBB")
                                                                                                                                                                                                                              (asset "EQUITIES::COM//USD" "COM")
                                                                                                                                                                                                                              (asset "EQUITIES::PALL//USD" "PALL")
                                                                                                                                                                                                                              (asset "EQUITIES::SLV//USD" "SLV")
                                                                                                                                                                                                                              (asset "EQUITIES::KOLD//USD" "KOLD")
                                                                                                                                                                                                                              (asset "EQUITIES::BOIL//USD" "BOIL")
                                                                                                                                                                                                                              (asset "EQUITIES::PDBC//USD" "PDBC")
                                                                                                                                                                                                                              (asset "EQUITIES::AGQ//USD" "AGQ")
                                                                                                                                                                                                                              (asset "EQUITIES::CORN//USD" "CORN")
                                                                                                                                                                                                                              (asset "EQUITIES::WEAT//USD" "WEAT")
                                                                                                                                                                                                                              (asset "EQUITIES::WOOD//USD" "WOOD")
                                                                                                                                                                                                                              (asset "EQUITIES::URA//USD" "URA")
                                                                                                                                                                                                                              (asset "EQUITIES::SCO//USD" "SCO")
                                                                                                                                                                                                                              (asset "EQUITIES::UCO//USD" "UCO")
                                                                                                                                                                                                                              (asset "EQUITIES::DBO//USD" "DBO")
                                                                                                                                                                                                                              (asset "EQUITIES::TAGS//USD" "TAGS")
                                                                                                                                                                                                                              (asset "EQUITIES::CANE//USD" "CANE")
                                                                                                                                                                                                                              (asset "EQUITIES::REMX//USD" "REMX")
                                                                                                                                                                                                                              (asset "EQUITIES::COPX//USD" "COPX")
                                                                                                                                                                                                                              (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                                                                                              (asset "EQUITIES::SPY//USD" "SPY")
                                                                                                                                                                                                                              (asset "EQUITIES::IEF//USD" "IEF")
                                                                                                                                                                                                                              (asset "EQUITIES::SPDN//USD" "SPDN")
                                                                                                                                                                                                                              (asset "EQUITIES::DRIP//USD" "DRIP")
                                                                                                                                                                                                                              (asset "EQUITIES::SPUU//USD" "SPUU")
                                                                                                                                                                                                                              (asset "EQUITIES::INDL//USD" "INDL")
                                                                                                                                                                                                                              (asset "EQUITIES::BRZU//USD" "BRZU")
                                                                                                                                                                                                                              (asset "EQUITIES::ERX//USD" "ERX")
                                                                                                                                                                                                                              (asset "EQUITIES::ERY//USD" "ERY")
                                                                                                                                                                                                                              (asset "EQUITIES::CWEB//USD" "CWEB")
                                                                                                                                                                                                                              (asset "EQUITIES::CHAU//USD" "CHAU")
                                                                                                                                                                                                                              (asset "EQUITIES::KORU//USD" "KORU")
                                                                                                                                                                                                                              (asset "EQUITIES::MEXX//USD" "MEXX")
                                                                                                                                                                                                                              (asset "EQUITIES::EDZ//USD" "EDZ")
                                                                                                                                                                                                                              (asset "EQUITIES::EURL//USD" "EURL")
                                                                                                                                                                                                                              (asset "EQUITIES::YINN//USD" "YINN")
                                                                                                                                                                                                                              (asset "EQUITIES::YANG//USD" "YANG")
                                                                                                                                                                                                                              (asset "EQUITIES::TNA//USD" "TNA")
                                                                                                                                                                                                                              (asset "EQUITIES::TZA//USD" "TZA")
                                                                                                                                                                                                                              (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                                                                                                                                              (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                                                                                                                                                                              (asset "EQUITIES::MIDU//USD" "MIDU")
                                                                                                                                                                                                                              (asset "EQUITIES::TYD//USD" "TYD")
                                                                                                                                                                                                                              (asset "EQUITIES::TYO//USD" "TYO")
                                                                                                                                                                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                                                                                                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                                                                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                                                                                              (asset "EQUITIES::TECS//USD" "TECS")
                                                                                                                                                                                                                              (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                                                                                                              (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                                                                                                                                                                              (asset "EQUITIES::LABU//USD" "LABU")
                                                                                                                                                                                                                              (asset "EQUITIES::LABD//USD" "LABD")
                                                                                                                                                                                                                              (asset "EQUITIES::RETL//USD" "RETL")
                                                                                                                                                                                                                              (asset "EQUITIES::DPST//USD" "DPST")
                                                                                                                                                                                                                              (asset "EQUITIES::DRN//USD" "DRN")
                                                                                                                                                                                                                              (asset "EQUITIES::DRV//USD" "DRV")
                                                                                                                                                                                                                              (asset "EQUITIES::PILL//USD" "PILL")
                                                                                                                                                                                                                              (asset "EQUITIES::CURE//USD" "CURE")
                                                                                                                                                                                                                              (asset "EQUITIES::FAZ//USD" "FAZ")
                                                                                                                                                                                                                              (asset "EQUITIES::FAS//USD" "FAS")
                                                                                                                                                                                                                              (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                                                                                                                                                              (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                                                                                                              (asset "EQUITIES::EWA//USD" "EWA")
                                                                                                                                                                                                                              (asset "EQUITIES::EWG//USD" "EWG")
                                                                                                                                                                                                                              (asset "EQUITIES::EWP//USD" "EWP")
                                                                                                                                                                                                                              (asset "EQUITIES::EWQ//USD" "EWQ")
                                                                                                                                                                                                                              (asset "EQUITIES::EWU//USD" "EWU")
                                                                                                                                                                                                                              (asset "EQUITIES::EWJ//USD" "EWJ")
                                                                                                                                                                                                                              (asset "EQUITIES::EWI//USD" "EWI")
                                                                                                                                                                                                                              (asset "EQUITIES::EWN//USD" "EWN")
                                                                                                                                                                                                                              (asset "EQUITIES::ECC//USD" "ECC")
                                                                                                                                                                                                                              (asset "EQUITIES::NURE//USD" "NURE")
                                                                                                                                                                                                                              (asset "EQUITIES::VNQI//USD" "VNQI")
                                                                                                                                                                                                                              (asset "EQUITIES::VNQ//USD" "VNQ")
                                                                                                                                                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                                                                                              (asset "EQUITIES::DBC//USD" "DBC")
                                                                                                                                                                                                                              (asset "EQUITIES::SPY//USD" "SPY")
                                                                                                                                                                                                                              (asset "EQUITIES::VDC//USD" "VDC")
                                                                                                                                                                                                                              (asset "EQUITIES::VIS//USD" "VIS")
                                                                                                                                                                                                                              (asset "EQUITIES::VGT//USD" "VGT")
                                                                                                                                                                                                                              (asset "EQUITIES::VAW//USD" "VAW")
                                                                                                                                                                                                                              (asset "EQUITIES::VPU//USD" "VPU")
                                                                                                                                                                                                                              (asset "EQUITIES::VOX//USD" "VOX")
                                                                                                                                                                                                                              (asset "EQUITIES::VFH//USD" "VFH")
                                                                                                                                                                                                                              (asset "EQUITIES::VHT//USD" "VHT")
                                                                                                                                                                                                                              (asset "EQUITIES::VNQ//USD" "VNQ")
                                                                                                                                                                                                                              (asset "EQUITIES::VDE//USD" "VDE")
                                                                                                                                                                                                                            ])
                                                                                                                                                                                                                          ])
                                                                                                                                                                                                                        ] [
                                                                                                                                                                                                                          (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                                                                                        ])
                                                                                                                                                                                                                      ])
                                                                                                                                                                                                                    ])
                                                                                                                                                                                                                  ])
                                                                                                                                                                                                                ])
                                                                                                                                                                                                              ])
                                                                                                                                                                                                            ])
                                                                                                                                                                                                          ])
                                                                                                                                                                                                        ] [
                                                                                                                                                                                                          (group "Inflation Hedge  What did well Sep-Nov 20?" [
                                                                                                                                                                                                            (weight-equal [
                                                                                                                                                                                                              (asset "EQUITIES::UGL//USD" "UGL")
                                                                                                                                                                                                              (asset "EQUITIES::URE//USD" "URE")
                                                                                                                                                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                                                                                              (asset "EQUITIES::ERX//USD" "ERX")
                                                                                                                                                                                                              (asset "EQUITIES::VXX//USD" "VXX")
                                                                                                                                                                                                              (asset "EQUITIES::UTSL//USD" "UTSL")
                                                                                                                                                                                                            ])
                                                                                                                                                                                                          ])
                                                                                                                                                                                                        ])
                                                                                                                                                                                                      ])
                                                                                                                                                                                                    ])
                                                                                                                                                                                                  ])
                                                                                                                                                                                                ])
                                                                                                                                                                                              ])
                                                                                                                                                                                            ])
                                                                                                                                                                                          ])
                                                                                                                                                                                        ])
                                                                                                                                                                                      ])
                                                                                                                                                                                    ])
                                                                                                                                                                                  ])
                                                                                                                                                                                ])
                                                                                                                                                                              ])
                                                                                                                                                                            ])
                                                                                                                                                                          ])
                                                                                                                                                                        ])
                                                                                                                                                                      ])
                                                                                                                                                                    ])
                                                                                                                                                                  ])
                                                                                                                                                                ])
                                                                                                                                                              ])
                                                                                                                                                            ])
                                                                                                                                                          ])
                                                                                                                                                        ])
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ])
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ])
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                            (group "Single Pops (Medium Leverage - No Black Swan Catcher) l 2 Nov 2011" [
                                              (weight-equal [
                                                (if (> (rsi "EQUITIES::QQQ//USD" 10) 83) [
                                                  (group "UVXY/VIXM" [
                                                    (weight-equal [
                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (if (> (rsi "EQUITIES::VTV//USD" 10) 79) [
                                                      (group "UVXY/VIXM" [
                                                        (weight-equal [
                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::VOOG//USD" 10) 79) [
                                                          (group "UVXY/VIXM" [
                                                            (weight-equal [
                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (> (rsi "EQUITIES::VOOV//USD" 10) 82) [
                                                              (group "UVXY/VIXM" [
                                                                (weight-equal [
                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (> (rsi "EQUITIES::XLP//USD" 10) 80) [
                                                                  (group "UVXY/VIXM" [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (> (rsi "EQUITIES::XLY//USD" 10) 82) [
                                                                      (group "UVXY/VIXM" [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (> (rsi "EQUITIES::SPY//USD" 10) 79) [
                                                                          (group "UVXY/VIXM" [
                                                                            (weight-equal [
                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::XLK//USD" 10) 28) [
                                                                              (group "TECL" [
                                                                                (weight-equal [
                                                                                  (filter (rsi 20) (select-bottom 1) [
                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                    (asset "EQUITIES::BSV//USD" "BSV")
                                                                                  ])
                                                                                  (filter (rsi 20) (select-top 1) [
                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                    (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::QQQ//USD" 10) 28) [
                                                                                  (group "TECL" [
                                                                                    (weight-equal [
                                                                                      (filter (rsi 20) (select-bottom 1) [
                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                        (asset "EQUITIES::BSV//USD" "BSV")
                                                                                      ])
                                                                                      (filter (rsi 20) (select-top 1) [
                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (< (rsi "EQUITIES::SPY//USD" 10) 29) [
                                                                                      (group "SPXL" [
                                                                                        (weight-equal [
                                                                                          (filter (rsi 20) (select-bottom 1) [
                                                                                            (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                            (asset "EQUITIES::BSV//USD" "BSV")
                                                                                          ])
                                                                                          (filter (rsi 20) (select-top 1) [
                                                                                            (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (asset "EQUITIES::SHV//USD" "SHV")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                            (group "Vol + TQQQ/TECL + SPXL + SOXL" [
                                              (weight-equal [
                                                (weight-specified [40 20 40] [
                                                  (group "TQQQ + TECL" [
                                                    (weight-equal [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                        ] [
                                                          (weight-equal [
                                                            (if (> (rsi "EQUITIES::SPXL//USD" 10) 80) [
                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::QQQ//USD" 10) 31) [
                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                ] [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::GLD//USD" "GLD")
                                                                    (asset "EQUITIES::SHY//USD" "SHY")
                                                                    (asset "EQUITIES::UUP//USD" "UUP")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                  (group "SPXL" [
                                                    (weight-equal [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::SPXL//USD" 10) 79) [
                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                        ] [
                                                          (weight-equal [
                                                            (if (> (rsi "EQUITIES::SPXL//USD" 10) 80) [
                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::SPXL//USD" 10) 31) [
                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                ] [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::GLD//USD" "GLD")
                                                                    (asset "EQUITIES::SHY//USD" "SHY")
                                                                    (asset "EQUITIES::UUP//USD" "UUP")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                  (group "SOXL" [
                                                    (weight-equal [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::SOXL//USD" 10) 79) [
                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                        ] [
                                                          (weight-equal [
                                                            (if (> (rsi "EQUITIES::SPXL//USD" 10) 80) [
                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::SOXL//USD" 10) 31) [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ] [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::GLD//USD" "GLD")
                                                                    (asset "EQUITIES::SHY//USD" "SHY")
                                                                    (asset "EQUITIES::UUP//USD" "UUP")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                    (group "Vol Catcher Wraps SOXL Twice(26%, 26% DD)" [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::UVXY//USD" 21) 65) [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::UVXY//USD" 10) 74) [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::UVXY//USD" 10) 84) [
                                  (weight-equal [
                                    (if (< (cumulative-return "EQUITIES::UVXY//USD" 2) 4.5) [
                                      (asset "EQUITIES::SPXS//USD" "SPXS")
                                    ] [
                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                      (asset "EQUITIES::BIL//USD" "BIL")
                                    ])
                                  ])
                                ] [
                                  (weight-equal [
                                    (if (< (rsi "EQUITIES::SOXL//USD" 14) 30) [
                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                    ] [
                                      (asset "EQUITIES::BIL//USD" "BIL")
                                    ])
                                  ])
                                ])
                              ])
                            ] [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::SOXL//USD" 14) 30) [
                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                ] [
                                  (asset "EQUITIES::BIL//USD" "BIL")
                                ])
                              ])
                            ])
                          ])
                        ] [
                          (asset "EQUITIES::BIL//USD" "BIL")
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
        ])
      ])
    ])
  ])
