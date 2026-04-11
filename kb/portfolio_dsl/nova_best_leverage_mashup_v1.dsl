defsymphony "NOVA | Best Leverage Mashup w/Vol Check (VIXM) | v1 (Invest Copy)" {:rebalance-frequency :none}
  (weight-equal [
    (group "NOVA | Best Leverage Mashup w/Vol Check (VIXM) | v1 (Invest Copy)" [
      (weight-equal [
        (group "Volatility Bomb Block from Ease Up on the Gas V2a (VIXM)" [
          (weight-equal [
            (if (> (rsi "EQUITIES::UVXY//USD" 21) 65) [
              (weight-equal [
                (if (> (rsi "EQUITIES::UVXY//USD" 10) 74) [
                  (weight-equal [
                    (if (< (rsi "EQUITIES::UVXY//USD" 10) 84) [
                      (asset "EQUITIES::VIXM//USD" "VIXM")
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
                (group "Best Leverage V2 (Public)" [
                  (weight-equal [
                    (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                      (group "VIX Blend++" [
                        (weight-equal [
                          (asset "EQUITIES::UVXY//USD" "UVXY")
                          (asset "EQUITIES::VIXM//USD" "VIXM")
                        ])
                      ])
                    ] [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::IOO//USD" 10) 80) [
                          (group "Scale-In | VIX+ -> VIX++" [
                            (weight-equal [
                              (if (> (rsi "EQUITIES::IOO//USD" 10) 82.5) [
                                (group "VIX Blend++" [
                                  (weight-equal [
                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                  ])
                                ])
                              ] [
                                (group "VIX Blend+" [
                                  (weight-equal [
                                    (asset "EQUITIES::VXX//USD" "VXX")
                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ] [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                              (group "Scale-In | VIX+ -> VIX++" [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::QQQ//USD" 10) 82.5) [
                                    (group "VIX Blend++" [
                                      (weight-equal [
                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                      ])
                                    ])
                                  ] [
                                    (group "VIX Blend+" [
                                      (weight-equal [
                                        (asset "EQUITIES::VXX//USD" "VXX")
                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ] [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::VTV//USD" 10) 79) [
                                  (group "VIX Blend" [
                                    (weight-equal [
                                      (asset "EQUITIES::VIXY//USD" "VIXY")
                                      (asset "EQUITIES::VXX//USD" "VXX")
                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                    ])
                                  ])
                                ] [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::XLP//USD" 10) 77) [
                                      (group "VIX Blend" [
                                        (weight-equal [
                                          (asset "EQUITIES::VIXY//USD" "VIXY")
                                          (asset "EQUITIES::VXX//USD" "VXX")
                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                        ])
                                      ])
                                    ] [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::XLF//USD" 10) 81) [
                                          (group "VIX Blend" [
                                            (weight-equal [
                                              (asset "EQUITIES::VIXY//USD" "VIXY")
                                              (asset "EQUITIES::VXX//USD" "VXX")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                            ])
                                          ])
                                        ] [
                                          (weight-equal [
                                            (if (> (rsi "EQUITIES::FNGG//USD" 10) 83) [
                                              (group "VIX Blend" [
                                                (weight-equal [
                                                  (asset "EQUITIES::VIXY//USD" "VIXY")
                                                  (asset "EQUITIES::VXX//USD" "VXX")
                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                ])
                                              ])
                                            ] [
                                              (weight-equal [
                                                (if (> (rsi "EQUITIES::SPY//USD" 70) 62) [
                                                  (group "Overbought" [
                                                    (weight-equal [
                                                      (group "AGG > QQQ" [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                            (group "Ticker Mixer" [
                                                              (weight-equal [
                                                                (group "Pick Top 3" [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 15) (select-top 3) [
                                                                      (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                    ])
                                                                  ])
                                                                ])
                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                              ])
                                                            ])
                                                          ] [
                                                            (group "GLD/SLV/DBC" [
                                                              (weight-specified {"GLD" 50 "SLV" 25 "DBC" 25} [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::SLV//USD" "SLV")
                                                                (asset "EQUITIES::DBC//USD" "DBC")
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                      (group "VIX Stuff" [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::QQQ//USD" 90) 60) [
                                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                                          ] [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::QQQ//USD" 14) 80) [
                                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (rsi "EQUITIES::QQQ//USD" 5) 90) [
                                                                    (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (rsi "EQUITIES::QQQ//USD" 3) 95) [
                                                                        (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                          ] [
                                                                            (asset "EQUITIES::SLV//USD" "SLV")
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
                                                    (if (> (cumulative-return "EQUITIES::VIXY//USD" 10) 20) [
                                                      (group "High VIX" [
                                                        (weight-equal [
                                                          (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                (group "SVXY" [
                                                                  (weight-equal [
                                                                    (if (> (max-drawdown "EQUITIES::SVXY//USD" 3) 20) [
                                                                      (group "Volmageddon Protection" [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (asset "EQUITIES::SGOV//USD" "SGOV")
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                (group "Pick Bottom 3 | 1.5x" [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 10) (select-bottom 3) [
                                                                      (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                    (filter (moving-average-return 10) (select-bottom 3) [
                                                                      (asset "EQUITIES::SPY//USD" "SPY")
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::XLK//USD" "XLK")
                                                                      (asset "EQUITIES::SOXX//USD" "SOXX")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (asset "EQUITIES::SGOV//USD" "SGOV")
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (group "Strategies" [
                                                        (weight-equal [
                                                          (group "FTLT/Bull/Bonds" [
                                                            (weight-equal [
                                                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -12) [
                                                                (weight-equal [
                                                                  (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                    (group "VIX Blend+" [
                                                                      (weight-equal [
                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                        (asset "EQUITIES::VXX//USD" "VXX")
                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (group "Mean Reversion" [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                                                          (group "Pick Bottom 3" [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 10) (select-bottom 3) [
                                                                                (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                                                (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::SPXL//USD" 10) 32.5) [
                                                                              (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32.5) [
                                                                                  (group "Pick Bottom 3" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 10) (select-bottom 3) [
                                                                                        (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                        (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (group "15/15" [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                        (group "Ticker Mixer" [
                                                                                          (weight-equal [
                                                                                            (group "Pick Top 3" [
                                                                                              (weight-equal [
                                                                                                (filter (moving-average-return 15) (select-top 3) [
                                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                  (asset "EQUITIES::FNGG//USD" "FNGG")
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
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                    (weight-equal [
                                                                      (if (< (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                        (group "Bull Cross " [
                                                                          (weight-equal [
                                                                            (filter (rsi 10) (select-top 2) [
                                                                              (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                              (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (group "Bull" [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::XLU//USD" 126) (rsi "EQUITIES::SPY//USD" 126)) [
                                                                              (group "20/60 -> 15/15" [
                                                                                (weight-equal [
                                                                                  (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                    (group "Ticker Mixer" [
                                                                                      (weight-equal [
                                                                                        (group "Pick Top 3" [
                                                                                          (weight-equal [
                                                                                            (filter (moving-average-return 15) (select-top 3) [
                                                                                              (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                              (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                              (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                              (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                      ])
                                                                                    ])
                                                                                  ] [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                        (group "Ticker Mixer" [
                                                                                          (weight-equal [
                                                                                            (group "Pick Top 3" [
                                                                                              (weight-equal [
                                                                                                (filter (moving-average-return 15) (select-top 3) [
                                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                  (asset "EQUITIES::FNGG//USD" "FNGG")
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
                                                                                  (group "20/60 -> 15/15" [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                        (group "Ticker Mixer" [
                                                                                          (weight-equal [
                                                                                            (group "Pick Top 3" [
                                                                                              (weight-equal [
                                                                                                (filter (moving-average-return 15) (select-top 3) [
                                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                  (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                          ])
                                                                                        ])
                                                                                      ] [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                            (group "Ticker Mixer" [
                                                                                              (weight-equal [
                                                                                                (group "Pick Top 3" [
                                                                                                  (weight-equal [
                                                                                                    (filter (moving-average-return 15) (select-top 3) [
                                                                                                      (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                      (asset "EQUITIES::FNGG//USD" "FNGG")
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
                                                                                  (group "TMF or UUP" [
                                                                                    (weight-equal [
                                                                                      (filter (rsi 20) (select-bottom 1) [
                                                                                        (asset "EQUITIES::TMF//USD" "TMF")
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
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                        (group "Bear Cross" [
                                                                          (weight-equal [
                                                                            (filter (rsi 10) (select-top 2) [
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (group "Bear" [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::XLU//USD" 126) (rsi "EQUITIES::SPY//USD" 126)) [
                                                                              (group "20/60 -> 15/15" [
                                                                                (weight-equal [
                                                                                  (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                    (group "Ticker Mixer" [
                                                                                      (weight-equal [
                                                                                        (group "Pick Top 3" [
                                                                                          (weight-equal [
                                                                                            (filter (moving-average-return 15) (select-top 3) [
                                                                                              (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                              (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                              (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                              (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                      ])
                                                                                    ])
                                                                                  ] [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                        (group "Ticker Mixer" [
                                                                                          (weight-equal [
                                                                                            (group "Pick Top 3" [
                                                                                              (weight-equal [
                                                                                                (filter (moving-average-return 15) (select-top 3) [
                                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                  (asset "EQUITIES::FNGG//USD" "FNGG")
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
                                                                                  (group "20/60 -> 15/15" [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                        (group "Ticker Mixer" [
                                                                                          (weight-equal [
                                                                                            (group "Pick Top 3" [
                                                                                              (weight-equal [
                                                                                                (filter (moving-average-return 15) (select-top 3) [
                                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                  (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                          ])
                                                                                        ])
                                                                                      ] [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                            (group "Ticker Mixer" [
                                                                                              (weight-equal [
                                                                                                (group "Pick Top 3" [
                                                                                                  (weight-equal [
                                                                                                    (filter (moving-average-return 15) (select-top 3) [
                                                                                                      (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                      (asset "EQUITIES::FNGG//USD" "FNGG")
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
                                                                                  (group "JRT" [
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
                                                          (group "Holy Grail | KMLM" [
                                                            (weight-equal [
                                                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -12) [
                                                                (weight-equal [
                                                                  (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                    (group "VIX Blend+" [
                                                                      (weight-equal [
                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                        (asset "EQUITIES::VXX//USD" "VXX")
                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (group "Mean Reversion" [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                                                          (group "Pick Bottom 3" [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 10) (select-bottom 3) [
                                                                                (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                                                (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::SPXL//USD" 10) 32.5) [
                                                                              (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32.5) [
                                                                                  (group "Pick Bottom 3" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 10) (select-bottom 3) [
                                                                                        (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                        (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (group "15/15" [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                        (group "Ticker Mixer" [
                                                                                          (weight-equal [
                                                                                            (group "Pick Top 3" [
                                                                                              (weight-equal [
                                                                                                (filter (moving-average-return 15) (select-top 3) [
                                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                  (asset "EQUITIES::FNGG//USD" "FNGG")
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
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                    (weight-equal [
                                                                      (if (< (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                        (group "Bull Cross " [
                                                                          (weight-equal [
                                                                            (filter (rsi 10) (select-top 2) [
                                                                              (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                              (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (group "KMLM Switch" [
                                                                          (weight-equal [
                                                                            (if (> (rsi "EQUITIES::XLK//USD" 10) (rsi "EQUITIES::KMLM//USD" 10)) [
                                                                              (group "Ticker Mixer" [
                                                                                (weight-equal [
                                                                                  (group "Pick Top 3" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 15) (select-top 3) [
                                                                                        (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                        (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (group "Ticker Mixer - Short" [
                                                                                (weight-equal [
                                                                                  (group "Pick Bottom 3" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 15) (select-bottom 3) [
                                                                                        (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                        (asset "EQUITIES::TECS//USD" "TECS")
                                                                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                                        (asset "EQUITIES::FNGD//USD" "FNGD")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                  (asset "EQUITIES::QID//USD" "QID")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                        (group "Bear Cross" [
                                                                          (weight-equal [
                                                                            (filter (rsi 10) (select-top 2) [
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (group "Bear" [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::QQQ//USD" 10) 31) [
                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (< (cumulative-return "EQUITIES::QQQ//USD" 60) -12) [
                                                                                      (group "Pick Bottom 3" [
                                                                                        (weight-equal [
                                                                                          (filter (moving-average-return 15) (select-bottom 3) [
                                                                                            (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                            (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                          (weight-equal [
                                                                                            (if (< (rsi "EQUITIES::PSQ//USD" 10) 32.5) [
                                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                            ] [
                                                                                              (group "10/20 -> CR" [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 10) 15) [
                                                                                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (if (< (cumulative-return "EQUITIES::TQQQ//USD" 62) -33) [
                                                                                                            (asset "EQUITIES::QLD//USD" "QLD")
                                                                                                          ] [
                                                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                                                          (group "10/20" [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                              ] [
                                                                                                (asset "EQUITIES::QID//USD" "QID")
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
                                                          (group "FNGU Machine" [
                                                            (weight-equal [
                                                              (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                (weight-equal [
                                                                  (if (< (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                    (group "Bull Cross " [
                                                                      (weight-equal [
                                                                        (filter (rsi 10) (select-top 2) [
                                                                          (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                          (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (group "FNGU Machine" [
                                                                      (weight-equal [
                                                                        (if (> (max-drawdown "EQUITIES::TQQQ//USD" 20) 15) [
                                                                          (group "Drawdown Safety" [
                                                                            (weight-equal [
                                                                              (group "Mean Reversion" [
                                                                                (weight-equal [
                                                                                  (filter (cumulative-return 2) (select-bottom 1) [
                                                                                    (group "2x QQQ" [
                                                                                      (weight-equal [
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                      ])
                                                                                    ])
                                                                                    (group "2x XLK" [
                                                                                      (weight-equal [
                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                        (asset "EQUITIES::XLK//USD" "XLK")
                                                                                      ])
                                                                                    ])
                                                                                    (group "2x XLY" [
                                                                                      (weight-equal [
                                                                                        (asset "EQUITIES::WANT//USD" "WANT")
                                                                                        (asset "EQUITIES::XLY//USD" "XLY")
                                                                                      ])
                                                                                    ])
                                                                                    (group "2x XLV" [
                                                                                      (weight-equal [
                                                                                        (asset "EQUITIES::CURE//USD" "CURE")
                                                                                        (asset "EQUITIES::XLV//USD" "XLV")
                                                                                      ])
                                                                                    ])
                                                                                    (group "1.5x GDX" [
                                                                                      (weight-equal [
                                                                                        (asset "EQUITIES::NUGT//USD" "NUGT")
                                                                                        (asset "EQUITIES::GDX//USD" "GDX")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                              (group "20/60 | JRT Vixation" [
                                                                                (weight-equal [
                                                                                  (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                    (group "JRT" [
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
                                                                                  ] [
                                                                                    (group "Vixation" [
                                                                                      (weight-inverse-vol 3 [
                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                        (group "Short" [
                                                                                          (weight-inverse-vol 10 [
                                                                                            (group "Rotator" [
                                                                                              (weight-equal [
                                                                                                (filter (standard-deviation-return 5) (select-bottom 2) [
                                                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                  (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                            (asset "EQUITIES::SPXU//USD" "SPXU")
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
                                                                            (if (> (cumulative-return "EQUITIES::TBT//USD" 60) 10) [
                                                                              (group "20/60 | JRT" [
                                                                                (weight-equal [
                                                                                  (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                    (group "JRT" [
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
                                                                                  ] [
                                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (group "FNGU Mixer" [
                                                                                (weight-equal [
                                                                                  (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                  (group "Top 1" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 20) (select-top 1) [
                                                                                        (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                        (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                        (asset "EQUITIES::USD//USD" "USD")
                                                                                        (asset "EQUITIES::XLE//USD" "XLE")
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
                                                                  (if (> (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                    (group "Bear Cross" [
                                                                      (weight-equal [
                                                                        (filter (rsi 10) (select-top 2) [
                                                                          (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                          (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                                          (asset "EQUITIES::TMV//USD" "TMV")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (group "Bear" [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::QQQ//USD" 10) 31) [
                                                                          (group "Pick Bottom 3" [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 10) (select-bottom 3) [
                                                                                (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                                                (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                              (group "Pick Bottom 3" [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 10) (select-bottom 3) [
                                                                                    (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                    (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (cumulative-return "EQUITIES::QQQ//USD" 60) -12) [
                                                                                  (group "10/20" [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                      ] [
                                                                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                      (weight-equal [
                                                                                        (if (< (rsi "EQUITIES::PSQ//USD" 10) 32.5) [
                                                                                          (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                        ] [
                                                                                          (group "10/20 -> 20/60 -> CR" [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 10) 15) [
                                                                                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (if (< (cumulative-return "EQUITIES::TQQQ//USD" 62) -33) [
                                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                          ] [
                                                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                                                      (group "10/20" [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                          ] [
                                                                                            (asset "EQUITIES::QID//USD" "QID")
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
                                                          (group "Caesar's TQQQ | Modified" [
                                                            (weight-equal [
                                                              (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                (weight-equal [
                                                                  (if (< (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                    (group "Bull Cross " [
                                                                      (weight-equal [
                                                                        (filter (rsi 10) (select-top 2) [
                                                                          (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                          (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (group "Caesar's Long Blend" [
                                                                      (weight-equal [
                                                                        (if (> (rsi "EQUITIES::SPY//USD" 60) 60) [
                                                                          (group "Safety | Top 1" [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 252) (select-top 1) [
                                                                                (asset "EQUITIES::TMF//USD" "TMF")
                                                                                (asset "EQUITIES::UUP//USD" "UUP")
                                                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                                (asset "EQUITIES::SPLV//USD" "SPLV")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (group "Long Blend" [
                                                                            (weight-specified [40 35 25] [
                                                                              (group "Long or JRT" [
                                                                                (weight-equal [
                                                                                  (if (< (cumulative-return "EQUITIES::TBT//USD" 60) 10) [
                                                                                    (group "Long | Top 1" [
                                                                                      (weight-equal [
                                                                                        (filter (moving-average-return 252) (select-top 1) [
                                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                          (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                          (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                          (asset "EQUITIES::GUSH//USD" "GUSH")
                                                                                          (asset "EQUITIES::DIG//USD" "DIG")
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ] [
                                                                                    (group "20/60 | JRT" [
                                                                                      (weight-equal [
                                                                                        (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                          (group "JRT" [
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
                                                                                        ] [
                                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                              (group "Long | Top 1" [
                                                                                (weight-equal [
                                                                                  (filter (cumulative-return 21) (select-top 1) [
                                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                    (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                    (asset "EQUITIES::DIG//USD" "DIG")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                    (group "Bear Cross" [
                                                                      (weight-equal [
                                                                        (filter (rsi 10) (select-top 2) [
                                                                          (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                          (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                                          (asset "EQUITIES::TMV//USD" "TMV")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (group "JRT Bear+" [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::QQQ//USD" 10) 31) [
                                                                          (group "Pick Bottom 3" [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 10) (select-bottom 3) [
                                                                                (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                                                (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                              (group "Pick Bottom 3" [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 10) (select-bottom 3) [
                                                                                    (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                    (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                                                                  (group "Pick Bottom 3" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 10) (select-bottom 3) [
                                                                                        (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                        (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (< (rsi "EQUITIES::FNGG//USD" 10) 30) [
                                                                                      (group "Pick Bottom 3" [
                                                                                        (weight-equal [
                                                                                          (filter (moving-average-return 10) (select-bottom 3) [
                                                                                            (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                            (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (< (cumulative-return "EQUITIES::QQQ//USD" 60) -12) [
                                                                                          (group "10/20" [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                (group "JRT" [
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
                                                                                              ] [
                                                                                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ] [
                                                                                          (weight-equal [
                                                                                            (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                              (weight-equal [
                                                                                                (if (< (rsi "EQUITIES::PSQ//USD" 10) 32.5) [
                                                                                                  (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                ] [
                                                                                                  (group "10/20 -> CR" [
                                                                                                    (weight-equal [
                                                                                                      (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                        (group "JRT" [
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
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 10) 15) [
                                                                                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                          ] [
                                                                                                            (weight-equal [
                                                                                                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 62) -33) [
                                                                                                                (asset "EQUITIES::QLD//USD" "QLD")
                                                                                                              ] [
                                                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                                                              (group "10/20" [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                  ] [
                                                                                                    (asset "EQUITIES::QID//USD" "QID")
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
                                                          (group "Sometimes TQQQ" [
                                                            (weight-equal [
                                                              (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                (group "TLT vs PSQ" [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::TLT//USD" 20) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                      (group "1" [
                                                                        (weight-equal [
                                                                          (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                            (weight-equal [
                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                                (weight-equal [
                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10.5) [
                                                                                    (weight-equal [
                                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                      ] [
                                                                                        (weight-equal [
                                                                                          (if (> (cumulative-return "EQUITIES::BND//USD" 60) (cumulative-return "EQUITIES::BIL//USD" 60)) [
                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                (weight-equal [
                                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                ])
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ] [
                                                                                    (weight-equal [
                                                                                      (if (> (cumulative-return "EQUITIES::BND//USD" 60) (cumulative-return "EQUITIES::BIL//USD" 60)) [
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                      ] [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::QQQ//USD" 10) 65) [
                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::TQQQ//USD" 25) (rsi "EQUITIES::STIP//USD" 25)) [
                                                                                                    (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                                  ] [
                                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::AGG//USD" 10) (rsi "EQUITIES::QQQ//USD" 10)) [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::BND//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                                    (weight-equal [
                                                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                    ])
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                                        (weight-equal [
                                                                                                          (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                        ])
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                                    (weight-equal [
                                                                                                      (if (> (cumulative-return "EQUITIES::QQQ//USD" 10) 5.5) [
                                                                                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (if (< (cumulative-return "EQUITIES::TQQQ//USD" 62) -33) [
                                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                          ] [
                                                                                                            (weight-equal [
                                                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                                      (group "2" [
                                                                        (weight-equal [
                                                                          (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                            (weight-equal [
                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                                (weight-equal [
                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10.5) [
                                                                                    (weight-equal [
                                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                      ] [
                                                                                        (weight-equal [
                                                                                          (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ] [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::QQQ//USD" 10) 65) [
                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::TQQQ//USD" 25) (rsi "EQUITIES::STIP//USD" 25)) [
                                                                                                (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                              ] [
                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ] [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::QQQ//USD" 10) 65) [
                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::TQQQ//USD" 25) (rsi "EQUITIES::STIP//USD" 25)) [
                                                                                                    (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                                  ] [
                                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (< (cumulative-return "EQUITIES::QQQ//USD" 10) 3) [
                                                                                                (weight-equal [
                                                                                                  (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                ])
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                                (group "Sometimes Bear" [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::QQQ//USD" 10) 31) [
                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                          (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (cumulative-return "EQUITIES::QQQ//USD" 60) -12) [
                                                                              (group "Pick Bottom 3" [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 15) (select-bottom 3) [
                                                                                    (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                    (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                  (weight-equal [
                                                                                    (if (< (rsi "EQUITIES::PSQ//USD" 10) 32.5) [
                                                                                      (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                    ] [
                                                                                      (group "10/20 -> 20/60 -> CR" [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (> (cumulative-return "EQUITIES::TQQQ//USD" 10) 15) [
                                                                                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (if (< (cumulative-return "EQUITIES::TQQQ//USD" 62) -33) [
                                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                      ] [
                                                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                                                  (group "10/20" [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                      ] [
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
                                                          (group "Just Run This" [
                                                            (weight-equal [
                                                              (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                (group "20/60 | JRT" [
                                                                  (weight-equal [
                                                                    (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                      (group "JRT" [
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
                                                                    ] [
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                    (group "Bear Cross" [
                                                                      (weight-equal [
                                                                        (filter (rsi 10) (select-top 2) [
                                                                          (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                          (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                                          (asset "EQUITIES::TMV//USD" "TMV")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (group "JRT Bear" [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::QQQ//USD" 10) 31) [
                                                                          (group "Pick Bottom 3" [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 10) (select-bottom 3) [
                                                                                (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                                                (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                              (group "Pick Bottom 3" [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 10) (select-bottom 3) [
                                                                                    (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                    (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                                                                  (group "Pick Bottom 3" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 10) (select-bottom 3) [
                                                                                        (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                        (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (< (cumulative-return "EQUITIES::QQQ//USD" 60) -12) [
                                                                                      (group "10/20" [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                            (group "JRT" [
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
                                                                                          ] [
                                                                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                          (weight-equal [
                                                                                            (if (< (rsi "EQUITIES::PSQ//USD" 10) 32.5) [
                                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                            ] [
                                                                                              (group "10/20 -> CR" [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                    (group "JRT" [
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
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 10) 15) [
                                                                                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (if (< (cumulative-return "EQUITIES::TQQQ//USD" 62) -33) [
                                                                                                            (asset "EQUITIES::QLD//USD" "QLD")
                                                                                                          ] [
                                                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                                                          (group "10/20" [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                              ] [
                                                                                                (asset "EQUITIES::QID//USD" "QID")
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
                                                          (group "Foreign Rat" [
                                                            (weight-equal [
                                                              (if (> (current-price "EQUITIES::EEM//USD" 10) (moving-average-price "EQUITIES::EEM//USD" 200)) [
                                                                (weight-equal [
                                                                  (if (> (rsi "EQUITIES::IEI//USD" 11) (rsi "EQUITIES::IWM//USD" 16)) [
                                                                    (asset "EQUITIES::EDC//USD" "EDC")
                                                                  ] [
                                                                    (asset "EQUITIES::EDZ//USD" "EDZ")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (rsi "EQUITIES::IEI//USD" 11) (rsi "EQUITIES::EEM//USD" 16)) [
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
                (group "Best Leverage V3 (Public)" [
                  (weight-equal [
                    (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                      (group "VIX Blend++" [
                        (weight-equal [
                          (asset "EQUITIES::UVXY//USD" "UVXY")
                          (asset "EQUITIES::VIXM//USD" "VIXM")
                        ])
                      ])
                    ] [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::IOO//USD" 10) 80) [
                          (group "Scale-In | VIX+ -> VIX++" [
                            (weight-equal [
                              (if (> (rsi "EQUITIES::IOO//USD" 10) 82.5) [
                                (group "VIX Blend++" [
                                  (weight-equal [
                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                  ])
                                ])
                              ] [
                                (group "VIX Blend+" [
                                  (weight-equal [
                                    (asset "EQUITIES::VXX//USD" "VXX")
                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ] [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                              (group "Scale-In | VIX+ -> VIX++" [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::QQQ//USD" 10) 82.5) [
                                    (group "VIX Blend++" [
                                      (weight-equal [
                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                      ])
                                    ])
                                  ] [
                                    (group "VIX Blend+" [
                                      (weight-equal [
                                        (asset "EQUITIES::VXX//USD" "VXX")
                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ] [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::VTV//USD" 10) 79) [
                                  (group "VIX Blend" [
                                    (weight-equal [
                                      (asset "EQUITIES::VIXY//USD" "VIXY")
                                      (asset "EQUITIES::VXX//USD" "VXX")
                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                    ])
                                  ])
                                ] [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::XLP//USD" 10) 77) [
                                      (group "VIX Blend" [
                                        (weight-equal [
                                          (asset "EQUITIES::VIXY//USD" "VIXY")
                                          (asset "EQUITIES::VXX//USD" "VXX")
                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                        ])
                                      ])
                                    ] [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::XLF//USD" 10) 81) [
                                          (group "VIX Blend" [
                                            (weight-equal [
                                              (asset "EQUITIES::VIXY//USD" "VIXY")
                                              (asset "EQUITIES::VXX//USD" "VXX")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                            ])
                                          ])
                                        ] [
                                          (weight-equal [
                                            (if (> (rsi "EQUITIES::FNGG//USD" 10) 83) [
                                              (group "VIX Blend" [
                                                (weight-equal [
                                                  (asset "EQUITIES::VIXY//USD" "VIXY")
                                                  (asset "EQUITIES::VXX//USD" "VXX")
                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                ])
                                              ])
                                            ] [
                                              (weight-equal [
                                                (if (> (rsi "EQUITIES::SPY//USD" 70) 62) [
                                                  (group "Overbought" [
                                                    (weight-equal [
                                                      (group "15/15" [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                            (group "Ticker Mixer" [
                                                              (weight-equal [
                                                                (group "Pick Top 3" [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 15) (select-top 3) [
                                                                      (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                    ])
                                                                  ])
                                                                ])
                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                              ])
                                                            ])
                                                          ] [
                                                            (group "GLD/SLV/DBC" [
                                                              (weight-specified {"GLD" 50 "SLV" 25 "DBC" 25} [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::SLV//USD" "SLV")
                                                                (asset "EQUITIES::DBC//USD" "DBC")
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                      (group "VIX Stuff" [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::QQQ//USD" 90) 60) [
                                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                                          ] [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::QQQ//USD" 14) 80) [
                                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (rsi "EQUITIES::QQQ//USD" 5) 90) [
                                                                    (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (rsi "EQUITIES::QQQ//USD" 3) 95) [
                                                                        (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                            (group "SVXY" [
                                                                              (weight-equal [
                                                                                (if (> (max-drawdown "EQUITIES::SVXY//USD" 3) 20) [
                                                                                  (group "Volmageddon Protection" [
                                                                                    (weight-equal [
                                                                                      (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (asset "EQUITIES::SLV//USD" "SLV")
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
                                                    (if (> (cumulative-return "EQUITIES::VIXY//USD" 10) 20) [
                                                      (group "High VIX" [
                                                        (weight-equal [
                                                          (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                            (weight-equal [
                                                              (if (> (cumulative-return "EQUITIES::VIXY//USD" 10) 27.5) [
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (group "Ticker Mixer" [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 10) (select-bottom 3) [
                                                                      (asset "EQUITIES::SPY//USD" "SPY")
                                                                      (asset "EQUITIES::IWM//USD" "IWM")
                                                                      (asset "EQUITIES::EFA//USD" "EFA")
                                                                      (asset "EQUITIES::XLF//USD" "XLF")
                                                                      (asset "EQUITIES::XHB//USD" "XHB")
                                                                      (asset "EQUITIES::XLE//USD" "XLE")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (group "Ticker Mixer" [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 10) (select-bottom 3) [
                                                                      (asset "EQUITIES::SPY//USD" "SPY")
                                                                      (asset "EQUITIES::IWM//USD" "IWM")
                                                                      (asset "EQUITIES::EFA//USD" "EFA")
                                                                      (asset "EQUITIES::XLF//USD" "XLF")
                                                                      (asset "EQUITIES::XHB//USD" "XHB")
                                                                      (asset "EQUITIES::XLE//USD" "XLE")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                (group "Pick Bottom 3 | 1.5x" [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 10) (select-bottom 3) [
                                                                      (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                    (filter (moving-average-return 10) (select-bottom 3) [
                                                                      (asset "EQUITIES::SPY//USD" "SPY")
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::XLK//USD" "XLK")
                                                                      (asset "EQUITIES::SOXX//USD" "SOXX")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (cumulative-return "EQUITIES::VIXY//USD" 10) 25) [
                                                                    (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  ] [
                                                                    (group "Ticker Mixer" [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 10) (select-bottom 3) [
                                                                          (asset "EQUITIES::SPY//USD" "SPY")
                                                                          (asset "EQUITIES::IWM//USD" "IWM")
                                                                          (asset "EQUITIES::EFA//USD" "EFA")
                                                                          (asset "EQUITIES::XLF//USD" "XLF")
                                                                          (asset "EQUITIES::XHB//USD" "XHB")
                                                                          (asset "EQUITIES::XLE//USD" "XLE")
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
                                                      (group "Strategies" [
                                                        (weight-equal [
                                                          (group "FTLT/Bull/Bonds" [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::SPY//USD" 60) 60) [
                                                                (group "Safety | Top 1" [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 252) (select-top 1) [
                                                                      (asset "EQUITIES::TMF//USD" "TMF")
                                                                      (asset "EQUITIES::UUP//USD" "UUP")
                                                                      (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                      (asset "EQUITIES::SPLV//USD" "SPLV")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -12) [
                                                                    (weight-equal [
                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                        (group "VIX Blend+" [
                                                                          (weight-equal [
                                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                            (asset "EQUITIES::VXX//USD" "VXX")
                                                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (group "Mean Reversion" [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                                                              (group "Pick Bottom 3" [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 10) (select-bottom 3) [
                                                                                    (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                    (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::SPXL//USD" 10) 32.5) [
                                                                                  (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32.5) [
                                                                                      (group "Pick Bottom 3" [
                                                                                        (weight-equal [
                                                                                          (filter (moving-average-return 10) (select-bottom 3) [
                                                                                            (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                            (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (group "15/15" [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                            (group "Ticker Mixer" [
                                                                                              (weight-equal [
                                                                                                (group "Pick Top 3" [
                                                                                                  (weight-equal [
                                                                                                    (filter (moving-average-return 15) (select-top 3) [
                                                                                                      (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                      (asset "EQUITIES::FNGG//USD" "FNGG")
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
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (group "Bull or Bonds" [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::XLU//USD" 126) (rsi "EQUITIES::XLK//USD" 126)) [
                                                                          (group "Compares" [
                                                                            (weight-inverse-vol 45 [
                                                                              (group "15/15" [
                                                                                (weight-equal [
                                                                                  (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                    (group "Ticker Mixer" [
                                                                                      (weight-equal [
                                                                                        (group "Pick Top 3" [
                                                                                          (weight-equal [
                                                                                            (filter (moving-average-return 15) (select-top 3) [
                                                                                              (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                              (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                              (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                              (asset "EQUITIES::FNGG//USD" "FNGG")
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
                                                                              (group "10/20" [
                                                                                (weight-equal [
                                                                                  (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                    (group "Ticker Mixer" [
                                                                                      (weight-equal [
                                                                                        (group "Pick Top 3" [
                                                                                          (weight-equal [
                                                                                            (filter (moving-average-return 15) (select-top 3) [
                                                                                              (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                              (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                              (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                              (asset "EQUITIES::FNGG//USD" "FNGG")
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
                                                                              (group "20/60" [
                                                                                (weight-equal [
                                                                                  (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                    (group "Ticker Mixer" [
                                                                                      (weight-equal [
                                                                                        (group "Pick Top 3" [
                                                                                          (weight-equal [
                                                                                            (filter (moving-average-return 15) (select-top 3) [
                                                                                              (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                              (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                              (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                              (asset "EQUITIES::FNGG//USD" "FNGG")
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
                                                                              (group "All" [
                                                                                (weight-equal [
                                                                                  (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                    (group "Ticker Mixer" [
                                                                                      (weight-equal [
                                                                                        (group "Pick Top 3" [
                                                                                          (weight-equal [
                                                                                            (filter (moving-average-return 15) (select-top 3) [
                                                                                              (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                              (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                              (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                              (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                      ])
                                                                                    ])
                                                                                  ] [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                        (group "Ticker Mixer" [
                                                                                          (weight-equal [
                                                                                            (group "Pick Top 3" [
                                                                                              (weight-equal [
                                                                                                (filter (moving-average-return 15) (select-top 3) [
                                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                  (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                          ])
                                                                                        ])
                                                                                      ] [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                            (group "Ticker Mixer" [
                                                                                              (weight-equal [
                                                                                                (group "Pick Top 3" [
                                                                                                  (weight-equal [
                                                                                                    (filter (moving-average-return 15) (select-top 3) [
                                                                                                      (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                      (asset "EQUITIES::FNGG//USD" "FNGG")
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
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::TLT//USD" 126) 50) [
                                                                              (group "15/15" [
                                                                                (weight-equal [
                                                                                  (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
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
                                                            ])
                                                          ])
                                                          (group "Holy Grail | KMLM" [
                                                            (weight-equal [
                                                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -12) [
                                                                (weight-equal [
                                                                  (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                    (group "VIX Blend+" [
                                                                      (weight-equal [
                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                        (asset "EQUITIES::VXX//USD" "VXX")
                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (group "Mean Reversion" [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                                                          (group "Pick Bottom 3" [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 10) (select-bottom 3) [
                                                                                (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                                                (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::SPXL//USD" 10) 32.5) [
                                                                              (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32.5) [
                                                                                  (group "Pick Bottom 3" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 10) (select-bottom 3) [
                                                                                        (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                        (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (group "15/15" [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                        (group "Ticker Mixer" [
                                                                                          (weight-equal [
                                                                                            (group "Pick Top 3" [
                                                                                              (weight-equal [
                                                                                                (filter (moving-average-return 15) (select-top 3) [
                                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                  (asset "EQUITIES::FNGG//USD" "FNGG")
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
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                    (weight-equal [
                                                                      (if (< (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                        (group "Bull Cross " [
                                                                          (weight-equal [
                                                                            (filter (rsi 10) (select-top 2) [
                                                                              (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                              (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (group "KMLM Switch" [
                                                                          (weight-equal [
                                                                            (if (> (rsi "EQUITIES::XLK//USD" 10) (rsi "EQUITIES::KMLM//USD" 10)) [
                                                                              (group "Ticker Mixer" [
                                                                                (weight-equal [
                                                                                  (group "Pick Top 3" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 15) (select-top 3) [
                                                                                        (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                        (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (group "Ticker Mixer - Short" [
                                                                                (weight-equal [
                                                                                  (group "Pick Bottom 3" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 15) (select-bottom 3) [
                                                                                        (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                        (asset "EQUITIES::TECS//USD" "TECS")
                                                                                        (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                                        (asset "EQUITIES::FNGD//USD" "FNGD")
                                                                                        (asset "EQUITIES::SRTY//USD" "SRTY")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                  (asset "EQUITIES::QID//USD" "QID")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                        (group "Bear Cross" [
                                                                          (weight-equal [
                                                                            (filter (rsi 10) (select-top 2) [
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (group "Bear" [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (< (cumulative-return "EQUITIES::QQQ//USD" 60) -12) [
                                                                                      (group "15/15" [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                            (group "Pick Top 3" [
                                                                                              (weight-equal [
                                                                                                (filter (moving-average-return 15) (select-top 3) [
                                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                  (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ] [
                                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                          (weight-equal [
                                                                                            (if (< (rsi "EQUITIES::PSQ//USD" 10) 32.5) [
                                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                            ] [
                                                                                              (group "10/20 -> CR" [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 10) 15) [
                                                                                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                      ] [
                                                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ] [
                                                                                          (group "10/20" [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                              ] [
                                                                                                (asset "EQUITIES::QID//USD" "QID")
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
                                                          (group "FNGU Machine" [
                                                            (weight-equal [
                                                              (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                (weight-equal [
                                                                  (if (< (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                    (group "Bull Cross " [
                                                                      (weight-equal [
                                                                        (filter (rsi 10) (select-top 2) [
                                                                          (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                          (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (group "FNGU Machine" [
                                                                      (weight-equal [
                                                                        (if (> (max-drawdown "EQUITIES::TQQQ//USD" 20) 15) [
                                                                          (group "Drawdown Safety" [
                                                                            (weight-equal [
                                                                              (group "Mean Reversion" [
                                                                                (weight-equal [
                                                                                  (filter (cumulative-return 3) (select-bottom 1) [
                                                                                    (group "2x XHB" [
                                                                                      (weight-equal [
                                                                                        (asset "EQUITIES::NAIL//USD" "NAIL")
                                                                                        (asset "EQUITIES::XHB//USD" "XHB")
                                                                                      ])
                                                                                    ])
                                                                                    (asset "EQUITIES::XLV//USD" "XLV")
                                                                                    (asset "EQUITIES::XLK//USD" "XLK")
                                                                                    (asset "EQUITIES::NUGT//USD" "NUGT")
                                                                                    (asset "EQUITIES::UBT//USD" "UBT")
                                                                                    (asset "EQUITIES::TBT//USD" "TBT")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                              (group "20/60 | JRT Vixation" [
                                                                                (weight-equal [
                                                                                  (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                    (group "JRT" [
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
                                                                                  ] [
                                                                                    (group "Vixation" [
                                                                                      (weight-inverse-vol 3 [
                                                                                        (asset "EQUITIES::SVIX//USD" "SVIX")
                                                                                        (group "Short" [
                                                                                          (weight-inverse-vol 10 [
                                                                                            (group "Rotator" [
                                                                                              (weight-equal [
                                                                                                (filter (standard-deviation-return 5) (select-bottom 2) [
                                                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                  (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                            (asset "EQUITIES::SPXU//USD" "SPXU")
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
                                                                            (if (> (cumulative-return "EQUITIES::TBT//USD" 60) 10) [
                                                                              (group "20/60 | JRT" [
                                                                                (weight-equal [
                                                                                  (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                    (group "JRT" [
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
                                                                                  ] [
                                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (group "FNGU Mixer" [
                                                                                (weight-equal [
                                                                                  (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                  (group "Top 1" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 20) (select-top 1) [
                                                                                        (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                        (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                        (asset "EQUITIES::USD//USD" "USD")
                                                                                        (asset "EQUITIES::XLE//USD" "XLE")
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
                                                                  (if (> (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                    (group "Bear Cross" [
                                                                      (weight-equal [
                                                                        (filter (rsi 10) (select-top 2) [
                                                                          (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                          (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                                          (asset "EQUITIES::TMV//USD" "TMV")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (group "Bear" [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::QQQ//USD" 10) 31) [
                                                                          (group "Pick Bottom 3" [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 10) (select-bottom 3) [
                                                                                (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                                                (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                              (group "Pick Bottom 3" [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 10) (select-bottom 3) [
                                                                                    (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                    (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (cumulative-return "EQUITIES::QQQ//USD" 60) -12) [
                                                                                  (group "10/20" [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                      ] [
                                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                      (weight-equal [
                                                                                        (if (< (rsi "EQUITIES::PSQ//USD" 10) 32.5) [
                                                                                          (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                        ] [
                                                                                          (group "10/20 -> CR" [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (> (cumulative-return "EQUITIES::TQQQ//USD" 10) 15) [
                                                                                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                  ] [
                                                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (group "10/20" [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                          ] [
                                                                                            (asset "EQUITIES::QID//USD" "QID")
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
                                                          (group "Caesar's TQQQ | Modified" [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::SPY//USD" 60) 60) [
                                                                (group "Safety | Top 1" [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 252) (select-top 1) [
                                                                      (asset "EQUITIES::TMF//USD" "TMF")
                                                                      (asset "EQUITIES::UUP//USD" "UUP")
                                                                      (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                      (asset "EQUITIES::SPLV//USD" "SPLV")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                    (weight-equal [
                                                                      (if (< (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                        (group "Bull Cross " [
                                                                          (weight-equal [
                                                                            (filter (rsi 10) (select-top 2) [
                                                                              (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                              (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (group "Caesar's Long Blend" [
                                                                          (weight-specified [40 35 25] [
                                                                            (group "Long or JRT" [
                                                                              (weight-equal [
                                                                                (if (< (cumulative-return "EQUITIES::TBT//USD" 60) 10) [
                                                                                  (group "Long | Top 1" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 252) (select-top 1) [
                                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                        (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                        (asset "EQUITIES::GUSH//USD" "GUSH")
                                                                                        (asset "EQUITIES::DIG//USD" "DIG")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (group "20/60 | JRT" [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                        (group "JRT" [
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
                                                                                      ] [
                                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                            (group "Long | Top 1" [
                                                                              (weight-equal [
                                                                                (filter (cumulative-return 21) (select-top 1) [
                                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                  (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                  (asset "EQUITIES::DIG//USD" "DIG")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                        (group "Bear Cross" [
                                                                          (weight-equal [
                                                                            (filter (rsi 10) (select-top 2) [
                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                              (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (group "JRT Bear+" [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::QQQ//USD" 10) 31) [
                                                                              (group "Pick Bottom 3" [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 10) (select-bottom 3) [
                                                                                    (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                    (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                                  (group "Pick Bottom 3" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 10) (select-bottom 3) [
                                                                                        (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                        (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                                                                      (group "Pick Bottom 3" [
                                                                                        (weight-equal [
                                                                                          (filter (moving-average-return 10) (select-bottom 3) [
                                                                                            (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                            (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (< (rsi "EQUITIES::FNGG//USD" 10) 30) [
                                                                                          (group "Pick Bottom 3" [
                                                                                            (weight-equal [
                                                                                              (filter (moving-average-return 10) (select-bottom 3) [
                                                                                                (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ] [
                                                                                          (weight-equal [
                                                                                            (if (< (cumulative-return "EQUITIES::QQQ//USD" 60) -12) [
                                                                                              (group "10/20 | JRT" [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                    (group "JRT" [
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
                                                                                                  ] [
                                                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ] [
                                                                                              (weight-equal [
                                                                                                (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                                  (weight-equal [
                                                                                                    (if (< (rsi "EQUITIES::PSQ//USD" 10) 32.5) [
                                                                                                      (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                    ] [
                                                                                                      (group "10/20 -> CR | JRT" [
                                                                                                        (weight-equal [
                                                                                                          (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                            (group "JRT" [
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
                                                                                                          ] [
                                                                                                            (weight-equal [
                                                                                                              (if (> (cumulative-return "EQUITIES::TQQQ//USD" 10) 15) [
                                                                                                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                              ] [
                                                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                              ])
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ] [
                                                                                                  (group "10/20" [
                                                                                                    (weight-equal [
                                                                                                      (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                      ] [
                                                                                                        (asset "EQUITIES::QID//USD" "QID")
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
                                                          (group "Sometimes TQQQ" [
                                                            (weight-equal [
                                                              (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 200)) [
                                                                (group "TLT vs PSQ" [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::TLT//USD" 20) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                      (group "1" [
                                                                        (weight-equal [
                                                                          (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                            (weight-equal [
                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                                (weight-equal [
                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10.5) [
                                                                                    (weight-equal [
                                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                      ] [
                                                                                        (weight-equal [
                                                                                          (if (> (cumulative-return "EQUITIES::BND//USD" 60) (cumulative-return "EQUITIES::BIL//USD" 60)) [
                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                (weight-equal [
                                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                ])
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ] [
                                                                                    (weight-equal [
                                                                                      (if (> (cumulative-return "EQUITIES::BND//USD" 60) (cumulative-return "EQUITIES::BIL//USD" 60)) [
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                      ] [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::QQQ//USD" 10) 65) [
                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::TQQQ//USD" 25) (rsi "EQUITIES::STIP//USD" 25)) [
                                                                                                    (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                                  ] [
                                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::AGG//USD" 10) (rsi "EQUITIES::QQQ//USD" 10)) [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::BND//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                                    (weight-equal [
                                                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                    ])
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                                        (weight-equal [
                                                                                                          (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                        ])
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                                    (weight-equal [
                                                                                                      (if (> (cumulative-return "EQUITIES::QQQ//USD" 10) 5.5) [
                                                                                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (if (< (cumulative-return "EQUITIES::TQQQ//USD" 62) -33) [
                                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                          ] [
                                                                                                            (weight-equal [
                                                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                                      (group "2" [
                                                                        (weight-equal [
                                                                          (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                            (weight-equal [
                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                                (weight-equal [
                                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10.5) [
                                                                                    (weight-equal [
                                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                      ] [
                                                                                        (weight-equal [
                                                                                          (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ] [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::QQQ//USD" 10) 65) [
                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::TQQQ//USD" 25) (rsi "EQUITIES::STIP//USD" 25)) [
                                                                                                (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                              ] [
                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ] [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::QQQ//USD" 10) 65) [
                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::TQQQ//USD" 25) (rsi "EQUITIES::STIP//USD" 25)) [
                                                                                                    (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                                  ] [
                                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (< (cumulative-return "EQUITIES::QQQ//USD" 10) 3) [
                                                                                                (weight-equal [
                                                                                                  (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                ])
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                                (group "Sometimes Bear" [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                                                          (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (cumulative-return "EQUITIES::TQQQ//USD" 60) -37.5) [
                                                                              (group "15/15" [
                                                                                (weight-equal [
                                                                                  (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                  ] [
                                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                  (weight-equal [
                                                                                    (if (< (rsi "EQUITIES::PSQ//USD" 10) 32.5) [
                                                                                      (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                    ] [
                                                                                      (group "10/20 -> CR" [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (> (cumulative-return "EQUITIES::TQQQ//USD" 10) 15) [
                                                                                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                              ] [
                                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (group "10/20" [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                      ] [
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
                                                          (group "Just Run This" [
                                                            (weight-equal [
                                                              (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                (group "20/60 | JRT" [
                                                                  (weight-equal [
                                                                    (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                      (group "JRT" [
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
                                                                    ] [
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                    (group "Bear Cross" [
                                                                      (weight-equal [
                                                                        (filter (rsi 10) (select-top 2) [
                                                                          (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                          (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                                          (asset "EQUITIES::TMV//USD" "TMV")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (group "JRT Bear" [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                          (group "Pick Bottom 3" [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 10) (select-bottom 3) [
                                                                                (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                                                (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                                                              (group "Pick Bottom 3" [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 10) (select-bottom 3) [
                                                                                    (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                    (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                                                                  (group "Pick Bottom 3" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 10) (select-bottom 3) [
                                                                                        (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                        (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (< (cumulative-return "EQUITIES::QQQ//USD" 60) -12) [
                                                                                      (group "10/20 | JRT" [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                            (group "JRT" [
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
                                                                                          ] [
                                                                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                          (weight-equal [
                                                                                            (if (< (rsi "EQUITIES::PSQ//USD" 10) 32.5) [
                                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                            ] [
                                                                                              (group "10/20 -> CR | JRT" [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                    (group "JRT" [
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
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 10) 15) [
                                                                                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                      ] [
                                                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ] [
                                                                                          (group "10/20" [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                              ] [
                                                                                                (asset "EQUITIES::QID//USD" "QID")
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
                                                          (group "Foreign Rat" [
                                                            (weight-equal [
                                                              (if (> (current-price "EQUITIES::EEM//USD" 10) (moving-average-price "EQUITIES::EEM//USD" 200)) [
                                                                (weight-equal [
                                                                  (if (> (rsi "EQUITIES::IEI//USD" 11) (rsi "EQUITIES::IWM//USD" 16)) [
                                                                    (asset "EQUITIES::EDC//USD" "EDC")
                                                                  ] [
                                                                    (asset "EQUITIES::EDZ//USD" "EDZ")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (rsi "EQUITIES::IEI//USD" 11) (rsi "EQUITIES::EEM//USD" 16)) [
                                                                    (asset "EQUITIES::EDC//USD" "EDC")
                                                                  ] [
                                                                    (asset "EQUITIES::EDZ//USD" "EDZ")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                          (group "Beta Baller Sort" [
                                                            (weight-equal [
                                                              (filter (standard-deviation-return 15) (select-top 1) [
                                                                (group "Unholy VIXation" [
                                                                  (weight-equal [
                                                                    (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (> (rsi "EQUITIES::VTV//USD" 10) 79) [
                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (> (rsi "EQUITIES::VOX//USD" 10) 79) [
                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (> (rsi "EQUITIES::TECL//USD" 10) 79) [
                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (> (rsi "EQUITIES::VOOV//USD" 10) 79) [
                                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                        ] [
                                                                                          (weight-equal [
                                                                                            (if (> (rsi "EQUITIES::XLP//USD" 10) 75) [
                                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                            ] [
                                                                                              (weight-equal [
                                                                                                (if (> (rsi "EQUITIES::XLY//USD" 10) 80) [
                                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                ] [
                                                                                                  (weight-equal [
                                                                                                    (if (> (rsi "EQUITIES::XLE//USD" 10) 80) [
                                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                    ] [
                                                                                                      (weight-equal [
                                                                                                        (if (> (rsi "EQUITIES::XLF//USD" 10) 81) [
                                                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                        ] [
                                                                                                          (weight-equal [
                                                                                                            (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                            ] [
                                                                                                              (weight-equal [
                                                                                                                (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                                                                                                  (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                ] [
                                                                                                                  (weight-equal [
                                                                                                                    (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -12) [
                                                                                                                      (group "BSC" [
                                                                                                                        (weight-equal [
                                                                                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                          ] [
                                                                                                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ] [
                                                                                                                      (weight-equal [
                                                                                                                        (if (> (rsi "EQUITIES::VIXM//USD" 10) 70) [
                                                                                                                          (group "BSC" [
                                                                                                                            (weight-equal [
                                                                                                                              (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                              ] [
                                                                                                                                (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ] [
                                                                                                                          (weight-equal [
                                                                                                                            (if (> (standard-deviation-return "EQUITIES::QQQ//USD" 10) 3) [
                                                                                                                              (group "BSC" [
                                                                                                                                (weight-equal [
                                                                                                                                  (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                  ] [
                                                                                                                                    (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ] [
                                                                                                                              (weight-equal [
                                                                                                                                (if (> (standard-deviation-return "EQUITIES::SPY//USD" 5) 2.5) [
                                                                                                                                  (group "BSC" [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                      ] [
                                                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ] [
                                                                                                                                  (weight-equal [
                                                                                                                                    (if (< (rsi "EQUITIES::SVXY//USD" 10) 30) [
                                                                                                                                      (group "BSC" [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                          ] [
                                                                                                                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ] [
                                                                                                                                      (weight-equal [
                                                                                                                                        (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                                                                                          (group "10/20 | SVXY vx SPXU" [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (filter (rsi 5) (select-bottom 1) [
                                                                                                                                                    (group "30/70" [
                                                                                                                                                      (weight-specified {"SPXU" 30.00 "SVXY" 70.00} [
                                                                                                                                                        (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                    (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ] [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (filter (rsi 5) (select-bottom 1) [
                                                                                                                                                    (group "70/30" [
                                                                                                                                                      (weight-specified {"SPXU" 70.00 "SVXY" 30.00} [
                                                                                                                                                        (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                    (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ])
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                        ] [
                                                                                                                                          (group "10/20 | SVXY vx SPXU" [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (filter (rsi 5) (select-bottom 1) [
                                                                                                                                                    (group "30/70" [
                                                                                                                                                      (weight-specified {"SPXU" 30.00 "SVXY" 70.00} [
                                                                                                                                                        (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                    (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ] [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (filter (rsi 5) (select-bottom 1) [
                                                                                                                                                    (group "70/30" [
                                                                                                                                                      (weight-specified {"SPXU" 70.00 "SVXY" 30.00} [
                                                                                                                                                        (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                    (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ])
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                          (group "TQQQ or BIL" [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (< (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                              ] [
                                                                                                                                                (asset "EQUITIES::SGOV//USD" "SGOV")
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
                                                                (group "Beta Baller + A Better LETF  | Anansi + BWC" [
                                                                  (weight-equal [
                                                                    (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (> (rsi "EQUITIES::VOX//USD" 10) 79) [
                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (> (rsi "EQUITIES::VTV//USD" 10) 79) [
                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (> (rsi "EQUITIES::XLP//USD" 10) 77) [
                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (< (rsi "EQUITIES::QQQ//USD" 10) 31) [
                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                        ] [
                                                                                          (weight-equal [
                                                                                            (if (< (rsi "EQUITIES::SMH//USD" 10) 30) [
                                                                                              (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                            ] [
                                                                                              (weight-equal [
                                                                                                (if (> (rsi "EQUITIES::TLT//USD" 10) (rsi "EQUITIES::BIL//USD" 10)) [
                                                                                                  (group "SOXL Baller" [
                                                                                                    (weight-equal [
                                                                                                      (if (> (rsi "EQUITIES::SPY//USD" 10) 75) [
                                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (if (> (rsi "EQUITIES::SOXX//USD" 5) 80) [
                                                                                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                                                          ] [
                                                                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ] [
                                                                                                  (weight-equal [
                                                                                                    (if (< (rsi "EQUITIES::SPY//USD" 5) 25) [
                                                                                                      (group "BSV vs SPHB" [
                                                                                                        (weight-equal [
                                                                                                          (if (< (rsi "EQUITIES::BSV//USD" 10) (rsi "EQUITIES::SPHB//USD" 10)) [
                                                                                                            (asset "EQUITIES::FNGD//USD" "FNGD")
                                                                                                          ] [
                                                                                                            (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ] [
                                                                                                      (weight-equal [
                                                                                                        (if (> (standard-deviation-return "EQUITIES::SPY//USD" 10) 2.5) [
                                                                                                          (group "High Vol" [
                                                                                                            (weight-equal [
                                                                                                              (filter (rsi 5) (select-top 1) [
                                                                                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                (asset "EQUITIES::TLT//USD" "TLT")
                                                                                                                (asset "EQUITIES::SH//USD" "SH")
                                                                                                              ])
                                                                                                            ])
                                                                                                          ])
                                                                                                        ] [
                                                                                                          (weight-equal [
                                                                                                            (if (> (moving-average-return "EQUITIES::TLT//USD" 100) (moving-average-return "EQUITIES::BIL//USD" 100)) [
                                                                                                              (group "MR Block" [
                                                                                                                (weight-equal [
                                                                                                                  (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                                                                    (weight-equal [
                                                                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                      ] [
                                                                                                                        (weight-equal [
                                                                                                                          (filter (moving-average-return 15) (select-top 1) [
                                                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                            (asset "EQUITIES::TLT//USD" "TLT")
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ] [
                                                                                                                    (weight-equal [
                                                                                                                      (filter (moving-average-return 15) (select-top 1) [
                                                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                        (asset "EQUITIES::TLT//USD" "TLT")
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ])
                                                                                                            ] [
                                                                                                              (weight-equal [
                                                                                                                (if (> (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                                                                                                  (group "Falling Rates - TMF" [
                                                                                                                    (weight-equal [
                                                                                                                      (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                                                                                        (group "10d IEF > 10d SH | MAR" [
                                                                                                                          (weight-equal [
                                                                                                                            (if (> (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                                                                              (weight-equal [
                                                                                                                                (filter (moving-average-return 5) (select-bottom 1) [
                                                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                  (asset "EQUITIES::EEM//USD" "EEM")
                                                                                                                                  (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ] [
                                                                                                                              (weight-equal [
                                                                                                                                (filter (cumulative-return 10) (select-top 1) [
                                                                                                                                  (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                                                  (asset "EQUITIES::TYO//USD" "TYO")
                                                                                                                                  (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                                                                                  (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                                                ])
                                                                                                                                (filter (moving-average-return 21) (select-bottom 1) [
                                                                                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                                                  (asset "EQUITIES::UGL//USD" "UGL")
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ] [
                                                                                                                        (weight-equal [
                                                                                                                          (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                                                                                            (group "MR Block" [
                                                                                                                              (weight-equal [
                                                                                                                                (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                                                                                  (weight-equal [
                                                                                                                                    (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                    ] [
                                                                                                                                      (group "Mean Reversion Sort" [
                                                                                                                                        (weight-equal [
                                                                                                                                          (filter (moving-average-return 7) (select-bottom 1) [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                            (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                            (asset "EQUITIES::EEM//USD" "EEM")
                                                                                                                                            (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ] [
                                                                                                                                  (group "10d IEF > 10d SH | MAR" [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                                                                                        (weight-equal [
                                                                                                                                          (filter (moving-average-return 5) (select-bottom 1) [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                            (asset "EQUITIES::EEM//USD" "EEM")
                                                                                                                                            (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (filter (cumulative-return 10) (select-top 1) [
                                                                                                                                            (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                                                            (asset "EQUITIES::TYO//USD" "TYO")
                                                                                                                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                                                                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                                                          ])
                                                                                                                                          (filter (moving-average-return 21) (select-bottom 1) [
                                                                                                                                            (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                                                            (asset "EQUITIES::UGL//USD" "UGL")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ] [
                                                                                                                            (group "20d SPY > 20d DBC | SDR" [
                                                                                                                              (weight-equal [
                                                                                                                                (if (> (standard-deviation-return "EQUITIES::SPY//USD" 20) (standard-deviation-return "EQUITIES::DBC//USD" 20)) [
                                                                                                                                  (weight-equal [
                                                                                                                                    (filter (moving-average-return 5) (select-top 1) [
                                                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                      (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ] [
                                                                                                                                  (weight-equal [
                                                                                                                                    (filter (rsi 5) (select-bottom 1) [
                                                                                                                                      (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                                                                                      (asset "EQUITIES::EEM//USD" "EEM")
                                                                                                                                      (asset "EQUITIES::TECS//USD" "TECS")
                                                                                                                                      (asset "EQUITIES::SOXS//USD" "SOXS")
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
                                                                                                                ] [
                                                                                                                  (group "Rising Rates - TMV" [
                                                                                                                    (weight-equal [
                                                                                                                      (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                                                                                        (weight-equal [
                                                                                                                          (if (> (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                                                                                            (group "Short" [
                                                                                                                              (weight-equal [
                                                                                                                                (filter (cumulative-return 5) (select-bottom 1) [
                                                                                                                                  (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                                                                                  (asset "EQUITIES::TECS//USD" "TECS")
                                                                                                                                  (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                                                                                  (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                                                  (asset "EQUITIES::ERX//USD" "ERX")
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ] [
                                                                                                                            (group "5d STIP > 5d SH | MAR" [
                                                                                                                              (weight-equal [
                                                                                                                                (if (> (moving-average-return "EQUITIES::STIP//USD" 5) (moving-average-return "EQUITIES::SH//USD" 5)) [
                                                                                                                                  (group "Long - TMV or Not" [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (moving-average-return "EQUITIES::TMF//USD" 5) 0) [
                                                                                                                                        (weight-equal [
                                                                                                                                          (filter (moving-average-return 5) (select-bottom 1) [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                            (asset "EQUITIES::TNA//USD" "TNA")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (filter (moving-average-return 5) (select-bottom 1) [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                            (asset "EQUITIES::TNA//USD" "TNA")
                                                                                                                                            (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ] [
                                                                                                                                  (weight-equal [
                                                                                                                                    (filter (cumulative-return 5) (select-top 1) [
                                                                                                                                      (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                                                                                      (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                                                      (asset "EQUITIES::EEM//USD" "EEM")
                                                                                                                                      (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ] [
                                                                                                                        (weight-equal [
                                                                                                                          (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                                                                                            (group "MR Block | Modded" [
                                                                                                                              (weight-equal [
                                                                                                                                (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                                                                                  (weight-equal [
                                                                                                                                    (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                    ] [
                                                                                                                                      (group "Mean Reversion Sort" [
                                                                                                                                        (weight-equal [
                                                                                                                                          (filter (moving-average-return 7) (select-bottom 1) [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                            (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                            (asset "EQUITIES::EEM//USD" "EEM")
                                                                                                                                            (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ] [
                                                                                                                                  (group "10d IEF > 10d SH | MAR" [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                                                                                        (weight-equal [
                                                                                                                                          (filter (moving-average-return 5) (select-bottom 1) [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                            (asset "EQUITIES::EEM//USD" "EEM")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (filter (cumulative-return 10) (select-top 1) [
                                                                                                                                            (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                                                            (asset "EQUITIES::TYO//USD" "TYO")
                                                                                                                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                                                          ])
                                                                                                                                          (filter (moving-average-return 21) (select-bottom 1) [
                                                                                                                                            (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                                                            (asset "EQUITIES::UGL//USD" "UGL")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ] [
                                                                                                                            (group "20d SPY > 20d DBC | SDR" [
                                                                                                                              (weight-equal [
                                                                                                                                (if (< (standard-deviation-return "EQUITIES::SPY//USD" 20) (standard-deviation-return "EQUITIES::DBC//USD" 20)) [
                                                                                                                                  (group "7d IEF > 7d BIL " [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (rsi "EQUITIES::IEF//USD" 7) (rsi "EQUITIES::BIL//USD" 7)) [
                                                                                                                                        (weight-equal [
                                                                                                                                          (filter (moving-average-return 5) (select-top 1) [
                                                                                                                                            (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                                                                                            (asset "EQUITIES::SPXU//USD" "SPXU")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (filter (cumulative-return 5) (select-bottom 1) [
                                                                                                                                            (asset "EQUITIES::EFA//USD" "EFA")
                                                                                                                                            (asset "EQUITIES::EEM//USD" "EEM")
                                                                                                                                            (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                                                                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                                                                                            (asset "EQUITIES::UCO//USD" "UCO")
                                                                                                                                            (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ] [
                                                                                                                                  (group "7d IEF > 7d BIL" [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (rsi "EQUITIES::IEF//USD" 7) (rsi "EQUITIES::BIL//USD" 7)) [
                                                                                                                                        (weight-equal [
                                                                                                                                          (filter (moving-average-return 5) (select-bottom 1) [
                                                                                                                                            (asset "EQUITIES::EEM//USD" "EEM")
                                                                                                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (filter (cumulative-return 5) (select-top 1) [
                                                                                                                                            (asset "EQUITIES::EEM//USD" "EEM")
                                                                                                                                            (asset "EQUITIES::TECS//USD" "TECS")
                                                                                                                                            (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                                                                                            (asset "EQUITIES::UUP//USD" "UUP")
                                                                                                                                            (asset "EQUITIES::TMV//USD" "TMV")
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
                                                                (group "Sometimes TQQQ | Anansi" [
                                                                  (weight-equal [
                                                                    (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                                      (group "VIX Blend++" [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (> (rsi "EQUITIES::IOO//USD" 10) 80) [
                                                                          (group "Scale-In | VIX+ -> VIX++" [
                                                                            (weight-equal [
                                                                              (if (> (rsi "EQUITIES::IOO//USD" 10) 82.5) [
                                                                                (group "VIX Blend++" [
                                                                                  (weight-equal [
                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                  ])
                                                                                ])
                                                                              ] [
                                                                                (group "VIX Blend+" [
                                                                                  (weight-equal [
                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                    (asset "EQUITIES::VXX//USD" "VXX")
                                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                                                                              (group "Scale-In | VIX+ -> VIX++" [
                                                                                (weight-equal [
                                                                                  (if (> (rsi "EQUITIES::QQQ//USD" 10) 82.5) [
                                                                                    (group "VIX Blend++" [
                                                                                      (weight-equal [
                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                      ])
                                                                                    ])
                                                                                  ] [
                                                                                    (group "VIX Blend+" [
                                                                                      (weight-equal [
                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                        (asset "EQUITIES::VXX//USD" "VXX")
                                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (> (rsi "EQUITIES::VTV//USD" 10) 79) [
                                                                                  (group "VIX Blend" [
                                                                                    (weight-equal [
                                                                                      (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                                      (asset "EQUITIES::VXX//USD" "VXX")
                                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (> (rsi "EQUITIES::XLP//USD" 10) 77) [
                                                                                      (group "VIX Blend" [
                                                                                        (weight-equal [
                                                                                          (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                                          (asset "EQUITIES::VXX//USD" "VXX")
                                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (> (rsi "EQUITIES::XLF//USD" 10) 81) [
                                                                                          (group "VIX Blend" [
                                                                                            (weight-equal [
                                                                                              (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                                              (asset "EQUITIES::VXX//USD" "VXX")
                                                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                            ])
                                                                                          ])
                                                                                        ] [
                                                                                          (weight-equal [
                                                                                            (if (> (rsi "EQUITIES::FNGG//USD" 10) 83) [
                                                                                              (group "VIX Blend" [
                                                                                                (weight-equal [
                                                                                                  (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                                                  (asset "EQUITIES::VXX//USD" "VXX")
                                                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                ])
                                                                                              ])
                                                                                            ] [
                                                                                              (weight-equal [
                                                                                                (if (> (rsi "EQUITIES::SPY//USD" 70) 62) [
                                                                                                  (group "Overbought" [
                                                                                                    (weight-equal [
                                                                                                      (group "15/15" [
                                                                                                        (weight-equal [
                                                                                                          (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                                            (group "Ticker Mixer" [
                                                                                                              (weight-equal [
                                                                                                                (group "Pick Top 3" [
                                                                                                                  (weight-equal [
                                                                                                                    (filter (moving-average-return 15) (select-top 3) [
                                                                                                                      (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                      (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                              ])
                                                                                                            ])
                                                                                                          ] [
                                                                                                            (group "GLD/SLV/DBC" [
                                                                                                              (weight-specified {"GLD" 50 "SLV" 25 "DBC" 25} [
                                                                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                                                                (asset "EQUITIES::SLV//USD" "SLV")
                                                                                                                (asset "EQUITIES::DBC//USD" "DBC")
                                                                                                              ])
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                      (group "VIX Stuff" [
                                                                                                        (weight-equal [
                                                                                                          (if (> (rsi "EQUITIES::QQQ//USD" 90) 60) [
                                                                                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                                                          ] [
                                                                                                            (weight-equal [
                                                                                                              (if (> (rsi "EQUITIES::QQQ//USD" 14) 80) [
                                                                                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                                                              ] [
                                                                                                                (weight-equal [
                                                                                                                  (if (> (rsi "EQUITIES::QQQ//USD" 5) 90) [
                                                                                                                    (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                                                                  ] [
                                                                                                                    (weight-equal [
                                                                                                                      (if (> (rsi "EQUITIES::QQQ//USD" 3) 95) [
                                                                                                                        (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                                                                      ] [
                                                                                                                        (weight-equal [
                                                                                                                          (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                                            (group "SVXY" [
                                                                                                                              (weight-equal [
                                                                                                                                (if (> (max-drawdown "EQUITIES::SVXY//USD" 3) 20) [
                                                                                                                                  (group "Volmageddon Protection" [
                                                                                                                                    (weight-equal [
                                                                                                                                      (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ] [
                                                                                                                                  (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ] [
                                                                                                                            (asset "EQUITIES::SLV//USD" "SLV")
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
                                                                                                    (if (> (cumulative-return "EQUITIES::VIXY//USD" 10) 20) [
                                                                                                      (group "High VIX" [
                                                                                                        (weight-equal [
                                                                                                          (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                                                            (group "Safety Bull" [
                                                                                                              (weight-equal [
                                                                                                                (group "Alternative Tickers" [
                                                                                                                  (weight-equal [
                                                                                                                    (asset "EQUITIES::XLE//USD" "XLE")
                                                                                                                    (asset "EQUITIES::XHB//USD" "XHB")
                                                                                                                  ])
                                                                                                                ])
                                                                                                                (group "SVXY" [
                                                                                                                  (weight-equal [
                                                                                                                    (if (> (max-drawdown "EQUITIES::SVXY//USD" 3) 20) [
                                                                                                                      (group "Volmageddon Protection" [
                                                                                                                        (weight-equal [
                                                                                                                          (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ] [
                                                                                                                      (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ])
                                                                                                            ])
                                                                                                          ] [
                                                                                                            (weight-equal [
                                                                                                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                                                                (group "Pick Bottom 3 | 1.5x" [
                                                                                                                  (weight-equal [
                                                                                                                    (filter (moving-average-return 10) (select-bottom 3) [
                                                                                                                      (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                    ])
                                                                                                                    (filter (moving-average-return 10) (select-bottom 3) [
                                                                                                                      (asset "EQUITIES::SPY//USD" "SPY")
                                                                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                                                      (asset "EQUITIES::XLK//USD" "XLK")
                                                                                                                      (asset "EQUITIES::SOXX//USD" "SOXX")
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ] [
                                                                                                                (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                                              ])
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ] [
                                                                                                      (group "Sometimes TQQQ" [
                                                                                                        (weight-equal [
                                                                                                          (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 200)) [
                                                                                                            (group "TLT vs PSQ" [
                                                                                                              (weight-equal [
                                                                                                                (if (< (rsi "EQUITIES::TLT//USD" 20) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                                  (group "1" [
                                                                                                                    (weight-equal [
                                                                                                                      (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                                                        (weight-equal [
                                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                        ])
                                                                                                                      ] [
                                                                                                                        (weight-equal [
                                                                                                                          (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                                                                            (weight-equal [
                                                                                                                              (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                                            ])
                                                                                                                          ] [
                                                                                                                            (weight-equal [
                                                                                                                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10.5) [
                                                                                                                                (weight-equal [
                                                                                                                                  (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                  ] [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (cumulative-return "EQUITIES::BND//USD" 60) (cumulative-return "EQUITIES::BIL//USD" 60)) [
                                                                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                                                            (weight-equal [
                                                                                                                                              (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                            ])
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ] [
                                                                                                                                (weight-equal [
                                                                                                                                  (if (> (cumulative-return "EQUITIES::BND//USD" 60) (cumulative-return "EQUITIES::BIL//USD" 60)) [
                                                                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                  ] [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (rsi "EQUITIES::QQQ//USD" 10) 65) [
                                                                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (rsi "EQUITIES::TQQQ//USD" 25) (rsi "EQUITIES::STIP//USD" 25)) [
                                                                                                                                                (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                                                                              ] [
                                                                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                              ])
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (rsi "EQUITIES::AGG//USD" 10) (rsi "EQUITIES::QQQ//USD" 10)) [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (rsi "EQUITIES::BND//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                                ])
                                                                                                                                              ] [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                                                                                    (weight-equal [
                                                                                                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                                    ])
                                                                                                                                                  ] [
                                                                                                                                                    (weight-equal [
                                                                                                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                                                                    ])
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ])
                                                                                                                                            ])
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (if (> (cumulative-return "EQUITIES::QQQ//USD" 10) 5.5) [
                                                                                                                                                    (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                                                                  ] [
                                                                                                                                                    (weight-equal [
                                                                                                                                                      (if (< (cumulative-return "EQUITIES::TQQQ//USD" 62) -33) [
                                                                                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                                      ] [
                                                                                                                                                        (weight-equal [
                                                                                                                                                          (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                                                                        ])
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ] [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                                                                                  (group "2" [
                                                                                                                    (weight-equal [
                                                                                                                      (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                                                        (weight-equal [
                                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                        ])
                                                                                                                      ] [
                                                                                                                        (weight-equal [
                                                                                                                          (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                                                                            (weight-equal [
                                                                                                                              (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                                            ])
                                                                                                                          ] [
                                                                                                                            (weight-equal [
                                                                                                                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10.5) [
                                                                                                                                (weight-equal [
                                                                                                                                  (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                  ] [
                                                                                                                                    (weight-equal [
                                                                                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ] [
                                                                                                                                (weight-equal [
                                                                                                                                  (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (rsi "EQUITIES::QQQ//USD" 10) 65) [
                                                                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (rsi "EQUITIES::TQQQ//USD" 25) (rsi "EQUITIES::STIP//USD" 25)) [
                                                                                                                                            (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                                                                          ] [
                                                                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ] [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (rsi "EQUITIES::QQQ//USD" 10) 65) [
                                                                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (rsi "EQUITIES::TQQQ//USD" 25) (rsi "EQUITIES::STIP//USD" 25)) [
                                                                                                                                                (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                                                                              ] [
                                                                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                              ])
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (< (cumulative-return "EQUITIES::QQQ//USD" 10) 3) [
                                                                                                                                            (weight-equal [
                                                                                                                                              (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                                                            ])
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                                                                            (group "Sometimes Bear" [
                                                                                                              (weight-equal [
                                                                                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                ] [
                                                                                                                  (weight-equal [
                                                                                                                    (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                                                                                                      (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                                    ] [
                                                                                                                      (weight-equal [
                                                                                                                        (if (< (cumulative-return "EQUITIES::TQQQ//USD" 60) -37.5) [
                                                                                                                          (group "15/15" [
                                                                                                                            (weight-equal [
                                                                                                                              (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                              ] [
                                                                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ] [
                                                                                                                          (weight-equal [
                                                                                                                            (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                                                              (weight-equal [
                                                                                                                                (if (< (rsi "EQUITIES::PSQ//USD" 10) 32.5) [
                                                                                                                                  (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                                                ] [
                                                                                                                                  (group "10/20 -> CR" [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 10) 15) [
                                                                                                                                            (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                                                          ] [
                                                                                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ] [
                                                                                                                              (group "10/20" [
                                                                                                                                (weight-equal [
                                                                                                                                  (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                                                  ] [
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
                                                          (group "Best No Leverage" [
                                                            (weight-equal [
                                                              (group "FTLT/Bull/Bonds" [
                                                                (weight-equal [
                                                                  (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -12) [
                                                                    (weight-equal [
                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                        (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                      ] [
                                                                        (group "Mean Reversion" [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                              (group "Pick Bottom 3" [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 5) (select-bottom 3) [
                                                                                    (asset "EQUITIES::XLK//USD" "XLK")
                                                                                    (asset "EQUITIES::IXN//USD" "IXN")
                                                                                    (asset "EQUITIES::IOO//USD" "IOO")
                                                                                    (asset "EQUITIES::SOXX//USD" "SOXX")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (group "SVXY" [
                                                                                (weight-equal [
                                                                                  (if (> (max-drawdown "EQUITIES::SVXY//USD" 3) 20) [
                                                                                    (group "Volmageddon Protection" [
                                                                                      (weight-equal [
                                                                                        (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                      ])
                                                                                    ])
                                                                                  ] [
                                                                                    (asset "EQUITIES::SVXY//USD" "SVXY")
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
                                                                      (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                        (weight-equal [
                                                                          (if (< (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                            (group "Bull Cross " [
                                                                              (weight-equal [
                                                                                (filter (rsi 10) (select-top 1) [
                                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                  (asset "EQUITIES::TLT//USD" "TLT")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (group "Bull" [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::XLU//USD" 126) (rsi "EQUITIES::SPY//USD" 126)) [
                                                                                  (group "AGG vs QQQ -> 20/60" [
                                                                                    (weight-equal [
                                                                                      (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                        (asset "EQUITIES::XLK//USD" "XLK")
                                                                                      ] [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                            (asset "EQUITIES::XLK//USD" "XLK")
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
                                                                                      (group "AGG vs QQQ -> 20/60" [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                            (asset "EQUITIES::XLK//USD" "XLK")
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                (asset "EQUITIES::XLK//USD" "XLK")
                                                                                              ] [
                                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (group "TLT or UUP" [
                                                                                        (weight-equal [
                                                                                          (filter (rsi 21) (select-bottom 1) [
                                                                                            (asset "EQUITIES::TLT//USD" "TLT")
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
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                            (group "Bear Cross" [
                                                                              (weight-equal [
                                                                                (filter (rsi 10) (select-top 2) [
                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                  (asset "EQUITIES::SH//USD" "SH")
                                                                                  (asset "EQUITIES::TLT//USD" "TLT")
                                                                                  (asset "EQUITIES::TBF//USD" "TBF")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (> (cumulative-return "EQUITIES::VIXY//USD" 10) 20) [
                                                                                (group "High VIX" [
                                                                                  (weight-equal [
                                                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                                      (group "Pick Bottom 3" [
                                                                                        (weight-equal [
                                                                                          (filter (moving-average-return 10) (select-bottom 3) [
                                                                                            (asset "EQUITIES::SPY//USD" "SPY")
                                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                            (asset "EQUITIES::XLK//USD" "XLK")
                                                                                            (asset "EQUITIES::SOXX//USD" "SOXX")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ] [
                                                                                (group "Bear" [
                                                                                  (weight-equal [
                                                                                    (if (< (rsi "EQUITIES::XLU//USD" 126) (rsi "EQUITIES::SPY//USD" 126)) [
                                                                                      (group "AGG vs QQQ -> 20/60" [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                            (asset "EQUITIES::XLK//USD" "XLK")
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                (asset "EQUITIES::XLK//USD" "XLK")
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
                                                                                          (group "AGG vs QQQ -> 20/60" [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                                (asset "EQUITIES::XLK//USD" "XLK")
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                    (asset "EQUITIES::XLK//USD" "XLK")
                                                                                                  ] [
                                                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ] [
                                                                                          (group "JRT" [
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
                                                              (group "Short Vol + FDN" [
                                                                (weight-equal [
                                                                  (if (< (cumulative-return "EQUITIES::TQQQ//USD" 10) -14.5) [
                                                                    (weight-equal [
                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                        (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                      ] [
                                                                        (group "Mean Reversion" [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                              (group "Pick Bottom 3" [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 5) (select-bottom 3) [
                                                                                    (asset "EQUITIES::XLK//USD" "XLK")
                                                                                    (asset "EQUITIES::IXN//USD" "IXN")
                                                                                    (asset "EQUITIES::IOO//USD" "IOO")
                                                                                    (asset "EQUITIES::SOXX//USD" "SOXX")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (group "SVXY" [
                                                                                (weight-equal [
                                                                                  (if (> (max-drawdown "EQUITIES::SVXY//USD" 3) 20) [
                                                                                    (group "Volmageddon Protection" [
                                                                                      (weight-equal [
                                                                                        (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                      ])
                                                                                    ])
                                                                                  ] [
                                                                                    (asset "EQUITIES::SVXY//USD" "SVXY")
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
                                                                      (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                        (weight-equal [
                                                                          (if (< (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                            (group "Bull Cross " [
                                                                              (weight-equal [
                                                                                (filter (rsi 10) (select-top 1) [
                                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                  (asset "EQUITIES::TLT//USD" "TLT")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (group "FDN vs XLU" [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::QQQ//USD" 10) 31) [
                                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (> (rsi "EQUITIES::FDN//USD" 200) (rsi "EQUITIES::XLU//USD" 200)) [
                                                                                      (group "SVXY" [
                                                                                        (weight-equal [
                                                                                          (if (> (max-drawdown "EQUITIES::SVXY//USD" 3) 20) [
                                                                                            (group "Volmageddon Protection" [
                                                                                              (weight-equal [
                                                                                                (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                              ])
                                                                                            ])
                                                                                          ] [
                                                                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                                          (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                        ] [
                                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                                          (if (> (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                            (group "Bear Cross" [
                                                                              (weight-equal [
                                                                                (filter (rsi 10) (select-top 2) [
                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                  (asset "EQUITIES::SH//USD" "SH")
                                                                                  (asset "EQUITIES::TLT//USD" "TLT")
                                                                                  (asset "EQUITIES::TBF//USD" "TBF")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (> (cumulative-return "EQUITIES::VIXY//USD" 10) 20) [
                                                                                (group "High VIX" [
                                                                                  (weight-equal [
                                                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                                      (group "Pick Bottom 3" [
                                                                                        (weight-equal [
                                                                                          (filter (moving-average-return 10) (select-bottom 3) [
                                                                                            (asset "EQUITIES::SPY//USD" "SPY")
                                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                            (asset "EQUITIES::XLK//USD" "XLK")
                                                                                            (asset "EQUITIES::SOXX//USD" "SOXX")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ] [
                                                                                (group "Volmageddon V4b" [
                                                                                  (weight-equal [
                                                                                    (if (< (rsi "EQUITIES::QQQ//USD" 10) 30) [
                                                                                      (group "Pick Bottom 3" [
                                                                                        (weight-equal [
                                                                                          (filter (moving-average-return 5) (select-bottom 3) [
                                                                                            (asset "EQUITIES::XLK//USD" "XLK")
                                                                                            (asset "EQUITIES::IXN//USD" "IXN")
                                                                                            (asset "EQUITIES::IOO//USD" "IOO")
                                                                                            (asset "EQUITIES::SOXX//USD" "SOXX")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (group "Compares | SVXY or PSQ" [
                                                                                        (weight-equal [
                                                                                          (if (> (max-drawdown "EQUITIES::SVXY//USD" 3) 20) [
                                                                                            (group "Volmageddon Protection" [
                                                                                              (weight-equal [
                                                                                                (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                              ])
                                                                                            ])
                                                                                          ] [
                                                                                            (group "Compares | SVXY or PSQ" [
                                                                                              (weight-equal [
                                                                                                (group "15d AGG vs 15d QQQ" [
                                                                                                  (weight-equal [
                                                                                                    (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                                      (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                    ] [
                                                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                                (group "20d AGG vs 60d SH" [
                                                                                                  (weight-equal [
                                                                                                    (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                      (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                    ] [
                                                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                                (group "10d IEF vs 20d PSQ" [
                                                                                                  (weight-equal [
                                                                                                    (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                      (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                    ] [
                                                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                                (group "All Chained" [
                                                                                                  (weight-equal [
                                                                                                    (if (> (rsi "EQUITIES::AGG//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                                      (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                    ] [
                                                                                                      (weight-equal [
                                                                                                        (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                          (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                        ] [
                                                                                                          (weight-equal [
                                                                                                            (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                            ] [
                                                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                              (group "Sometimes QQQ" [
                                                                (weight-equal [
                                                                  (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                    (group "TLT vs PSQ" [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::TLT//USD" 20) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                          (group "1" [
                                                                            (weight-equal [
                                                                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                (asset "EQUITIES::XLK//USD" "XLK")
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                                    (asset "EQUITIES::IOO//USD" "IOO")
                                                                                  ] [
                                                                                    (weight-equal [
                                                                                      (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10.5) [
                                                                                        (weight-equal [
                                                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (> (cumulative-return "EQUITIES::BND//USD" 60) (cumulative-return "EQUITIES::BIL//USD" 60)) [
                                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                    (weight-equal [
                                                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                                    ])
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ] [
                                                                                        (weight-equal [
                                                                                          (if (> (cumulative-return "EQUITIES::BND//USD" 60) (cumulative-return "EQUITIES::BIL//USD" 60)) [
                                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::QQQ//USD" 10) 65) [
                                                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (if (> (rsi "EQUITIES::TQQQ//USD" 25) (rsi "EQUITIES::STIP//USD" 25)) [
                                                                                                        (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                                      ] [
                                                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::AGG//USD" 10) (rsi "EQUITIES::QQQ//USD" 10)) [
                                                                                                    (weight-equal [
                                                                                                      (if (> (rsi "EQUITIES::BND//USD" 15) (rsi "EQUITIES::QQQ//USD" 15)) [
                                                                                                        (weight-equal [
                                                                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                                        ])
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                                            (weight-equal [
                                                                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                                            ])
                                                                                                          ] [
                                                                                                            (weight-equal [
                                                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                                        (weight-equal [
                                                                                                          (if (> (cumulative-return "EQUITIES::QQQ//USD" 10) 5.5) [
                                                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                          ] [
                                                                                                            (weight-equal [
                                                                                                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 62) -33) [
                                                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                                              ] [
                                                                                                                (weight-equal [
                                                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                                ])
                                                                                                              ])
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                                          (group "2" [
                                                                            (weight-equal [
                                                                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                (asset "EQUITIES::XLK//USD" "XLK")
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                                    (asset "EQUITIES::IOO//USD" "IOO")
                                                                                  ] [
                                                                                    (weight-equal [
                                                                                      (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10.5) [
                                                                                        (weight-equal [
                                                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ] [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::QQQ//USD" 10) 65) [
                                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::TQQQ//USD" 25) (rsi "EQUITIES::STIP//USD" 25)) [
                                                                                                    (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                                  ] [
                                                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::QQQ//USD" 10) 65) [
                                                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (if (> (rsi "EQUITIES::TQQQ//USD" 25) (rsi "EQUITIES::STIP//USD" 25)) [
                                                                                                        (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                                      ] [
                                                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (< (cumulative-return "EQUITIES::QQQ//USD" 10) 3) [
                                                                                                    (weight-equal [
                                                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                    ])
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                                      (if (> (cumulative-return "EQUITIES::VIXY//USD" 10) 20) [
                                                                        (group "High VIX" [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                              (group "Pick Bottom 3" [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 10) (select-bottom 3) [
                                                                                    (asset "EQUITIES::SPY//USD" "SPY")
                                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                    (asset "EQUITIES::XLK//USD" "XLK")
                                                                                    (asset "EQUITIES::SOXX//USD" "SOXX")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (group "Bear" [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::QQQ//USD" 10) 31) [
                                                                              (asset "EQUITIES::XLK//USD" "XLK")
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                                  (asset "EQUITIES::IOO//USD" "IOO")
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (< (cumulative-return "EQUITIES::QQQ//USD" 60) -12) [
                                                                                      (group "10/20" [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                          ] [
                                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                          (weight-equal [
                                                                                            (if (< (rsi "EQUITIES::PSQ//USD" 10) 32.5) [
                                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                            ] [
                                                                                              (group "10/20 -> 20/60 -> CR" [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::IEF//USD" 10) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (if (> (rsi "EQUITIES::BND//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 10) 15) [
                                                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                          ] [
                                                                                                            (weight-equal [
                                                                                                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 62) -33) [
                                                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                                              ] [
                                                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                              (group "Just Run This" [
                                                                (weight-equal [
                                                                  (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                    (group "JRT" [
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
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (moving-average-price "EQUITIES::SPY//USD" 3) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                        (group "Bear Cross" [
                                                                          (weight-equal [
                                                                            (filter (rsi 10) (select-top 2) [
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::SH//USD" "SH")
                                                                              (asset "EQUITIES::TLT//USD" "TLT")
                                                                              (asset "EQUITIES::TBF//USD" "TBF")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (cumulative-return "EQUITIES::VIXY//USD" 10) 20) [
                                                                            (group "High VIX" [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                                  (group "Pick Bottom 3" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 10) (select-bottom 3) [
                                                                                        (asset "EQUITIES::SPY//USD" "SPY")
                                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                        (asset "EQUITIES::XLK//USD" "XLK")
                                                                                        (asset "EQUITIES::SOXX//USD" "SOXX")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (group "Bear" [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::QQQ//USD" 10) 31) [
                                                                                  (group "Pick Bottom 3" [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 5) (select-bottom 3) [
                                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                        (asset "EQUITIES::XLK//USD" "XLK")
                                                                                        (asset "EQUITIES::IXN//USD" "IXN")
                                                                                        (asset "EQUITIES::IOO//USD" "IOO")
                                                                                        (asset "EQUITIES::SOXX//USD" "SOXX")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                                      (group "Pick Bottom 3" [
                                                                                        (weight-equal [
                                                                                          (filter (moving-average-return 5) (select-bottom 3) [
                                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                            (asset "EQUITIES::XLK//USD" "XLK")
                                                                                            (asset "EQUITIES::IXN//USD" "IXN")
                                                                                            (asset "EQUITIES::IOO//USD" "IOO")
                                                                                            (asset "EQUITIES::SOXX//USD" "SOXX")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (< (cumulative-return "EQUITIES::QQQ//USD" 60) -12) [
                                                                                          (group "JRT" [
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
                                                                                        ] [
                                                                                          (weight-equal [
                                                                                            (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                              (weight-equal [
                                                                                                (if (< (rsi "EQUITIES::PSQ//USD" 10) 32.5) [
                                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                ] [
                                                                                                  (group "JRT" [
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
                                                                                            ] [
                                                                                              (weight-equal [
                                                                                                (filter (rsi 20) (select-top 1) [
                                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                  (asset "EQUITIES::BSV//USD" "BSV")
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
                                                              (group "Foreign Rat" [
                                                                (weight-equal [
                                                                  (if (> (cumulative-return "EQUITIES::VIXY//USD" 10) 20) [
                                                                    (group "High VIX" [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                          (group "Pick Bottom 3" [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 10) (select-bottom 3) [
                                                                                (asset "EQUITIES::SPY//USD" "SPY")
                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                (asset "EQUITIES::XLK//USD" "XLK")
                                                                                (asset "EQUITIES::SOXX//USD" "SOXX")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (asset "EQUITIES::SGOV//USD" "SGOV")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (current-price "EQUITIES::EEM//USD" 10) (moving-average-price "EQUITIES::EEM//USD" 200)) [
                                                                        (weight-equal [
                                                                          (if (> (rsi "EQUITIES::IEI//USD" 11) (rsi "EQUITIES::IWM//USD" 16)) [
                                                                            (asset "EQUITIES::VWO//USD" "VWO")
                                                                          ] [
                                                                            (asset "EQUITIES::EUM//USD" "EUM")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (rsi "EQUITIES::IEI//USD" 11) (rsi "EQUITIES::EEM//USD" 16)) [
                                                                            (asset "EQUITIES::VWO//USD" "VWO")
                                                                          ] [
                                                                            (asset "EQUITIES::EUM//USD" "EUM")
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
