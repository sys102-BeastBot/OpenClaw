defsymphony "Combined Wild West and RSI Frankenfest" {:rebalance-frequency :daily}
  (weight-inverse-vol 120 [
    (group "Wild West of High Return High Vol Short-Term Trading" [
      (weight-equal [
        (group "Oil ST Trading" [
          (weight-equal [
            (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
              (weight-equal [
                (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                  (asset "EQUITIES::SCO//USD" "SCO")
                ] [
                  (asset "EQUITIES::GLD//USD" "GLD")
                ])
              ])
            ] [
              (asset "EQUITIES::USO//USD" "USO")
            ])
          ])
        ])
        (group "Natural Gas ST Trading" [
          (weight-equal [
            (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
              (asset "EQUITIES::KOLD//USD" "KOLD")
            ] [
              (asset "EQUITIES::UNG//USD" "UNG")
            ])
            (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
              (asset "EQUITIES::KOLD//USD" "KOLD")
            ] [
              (asset "EQUITIES::UNG//USD" "UNG")
            ])
            (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
              (asset "EQUITIES::KOLD//USD" "KOLD")
            ] [
              (asset "EQUITIES::UNG//USD" "UNG")
            ])
            (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
              (asset "EQUITIES::KOLD//USD" "KOLD")
            ] [
              (asset "EQUITIES::UNG//USD" "UNG")
            ])
            (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
              (asset "EQUITIES::KOLD//USD" "KOLD")
            ] [
              (asset "EQUITIES::UNG//USD" "UNG")
            ])
          ])
        ])
        (group "ST Leveraged Semiconductors Trading" [
          (weight-equal [
            (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
              (weight-equal [
                (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                  (asset "EQUITIES::USD//USD" "USD")
                  (asset "EQUITIES::YCS//USD" "YCS")
                ] [
                  (weight-equal [
                    (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                      (asset "EQUITIES::SOXL//USD" "SOXL")
                      (asset "EQUITIES::YCS//USD" "YCS")
                    ] [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                          (asset "EQUITIES::VIXM//USD" "VIXM")
                        ] [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                              (asset "EQUITIES::VIXY//USD" "VIXY")
                            ] [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                  (asset "EQUITIES::VIXY//USD" "VIXY")
                                ] [
                                  (weight-equal [
                                    (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                      (asset "EQUITIES::REK//USD" "REK")
                                    ] [
                                      (weight-equal [
                                        (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                        ] [
                                          (weight-equal [
                                            (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                              (weight-inverse-vol 50 [
                                                (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                  (weight-equal [
                                                    (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                      (weight-equal [
                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                      ])
                                                    ] [
                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-inverse-vol 20 [
                                                    (asset "EQUITIES::GLD//USD" "GLD")
                                                    (asset "EQUITIES::RWM//USD" "RWM")
                                                    (asset "EQUITIES::YCS//USD" "YCS")
                                                    (asset "EQUITIES::BTAL//USD" "BTAL")
                                                    (asset "EQUITIES::CWB//USD" "CWB")
                                                    (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                      (weight-equal [
                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                      ])
                                                    ] [
                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                    ])
                                                  ])
                                                ])
                                                (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                  (weight-equal [
                                                    (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                      (weight-equal [
                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                      ])
                                                    ] [
                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-inverse-vol 20 [
                                                    (asset "EQUITIES::GLD//USD" "GLD")
                                                    (asset "EQUITIES::RWM//USD" "RWM")
                                                    (asset "EQUITIES::YCS//USD" "YCS")
                                                    (asset "EQUITIES::BTAL//USD" "BTAL")
                                                    (asset "EQUITIES::CWB//USD" "CWB")
                                                    (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                      (weight-equal [
                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                      ])
                                                    ] [
                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                    ])
                                                  ])
                                                ])
                                                (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                  (weight-equal [
                                                    (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                      (weight-equal [
                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                      ])
                                                    ] [
                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-inverse-vol 20 [
                                                    (asset "EQUITIES::GLD//USD" "GLD")
                                                    (asset "EQUITIES::RWM//USD" "RWM")
                                                    (asset "EQUITIES::YCS//USD" "YCS")
                                                    (asset "EQUITIES::BTAL//USD" "BTAL")
                                                    (asset "EQUITIES::CWB//USD" "CWB")
                                                    (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                      (weight-equal [
                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                      ])
                                                    ] [
                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                    ])
                                                  ])
                                                ])
                                                (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                  (weight-equal [
                                                    (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                      (weight-equal [
                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                      ])
                                                    ] [
                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-inverse-vol 20 [
                                                    (asset "EQUITIES::GLD//USD" "GLD")
                                                    (asset "EQUITIES::RWM//USD" "RWM")
                                                    (asset "EQUITIES::YCS//USD" "YCS")
                                                    (asset "EQUITIES::BTAL//USD" "BTAL")
                                                    (asset "EQUITIES::CWB//USD" "CWB")
                                                    (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                      (weight-equal [
                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                      ])
                                                    ] [
                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                    ])
                                                  ])
                                                ])
                                                (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                  (weight-equal [
                                                    (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                      (weight-equal [
                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                      ])
                                                    ] [
                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-inverse-vol 20 [
                                                    (asset "EQUITIES::GLD//USD" "GLD")
                                                    (asset "EQUITIES::RWM//USD" "RWM")
                                                    (asset "EQUITIES::YCS//USD" "YCS")
                                                    (asset "EQUITIES::BTAL//USD" "BTAL")
                                                    (asset "EQUITIES::CWB//USD" "CWB")
                                                    (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                      (weight-equal [
                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                      ])
                                                    ] [
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
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
        ])
        (group "Long Volatility Tests - Layered with OEF vs. SVXY" [
          (weight-equal [
            (if (> (rsi "EQUITIES::OEF//USD" 2) (rsi "EQUITIES::MOO//USD" 2)) [
              (weight-equal [
                (if (> (rsi "EQUITIES::OEF//USD" 2) (rsi "EQUITIES::SVXY//USD" 2)) [
                  (weight-inverse-vol 5 [
                    (asset "EQUITIES::VIXM//USD" "VIXM")
                  ])
                ] [
                  (weight-equal [
                    (group "ST Leveraged Semiconductors Trading" [
                      (weight-equal [
                        (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                              (asset "EQUITIES::USD//USD" "USD")
                              (asset "EQUITIES::YCS//USD" "YCS")
                            ] [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                  (asset "EQUITIES::YCS//USD" "YCS")
                                ] [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                    ] [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                                          (asset "EQUITIES::VIXY//USD" "VIXY")
                                        ] [
                                          (weight-equal [
                                            (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                              (asset "EQUITIES::VIXY//USD" "VIXY")
                                            ] [
                                              (weight-equal [
                                                (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                  (asset "EQUITIES::REK//USD" "REK")
                                                ] [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    ] [
                                                      (weight-equal [
                                                        (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                                          (weight-inverse-vol 50 [
                                                            (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
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
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                    (group "Natural Gas ST Trading" [
                      (weight-equal [
                        (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                      ])
                    ])
                    (group "Oil ST Trading" [
                      (weight-equal [
                        (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
                          (weight-equal [
                            (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                              (asset "EQUITIES::SCO//USD" "SCO")
                            ] [
                              (asset "EQUITIES::GLD//USD" "GLD")
                            ])
                          ])
                        ] [
                          (asset "EQUITIES::USO//USD" "USO")
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ] [
              (weight-equal [
                (if (> (rsi "EQUITIES::OEF//USD" 2) (rsi "EQUITIES::SVXY//USD" 2)) [
                  (weight-inverse-vol 5 [
                    (weight-equal [
                      (group "ST Leveraged Semiconductors Trading" [
                        (weight-equal [
                          (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                                (asset "EQUITIES::USD//USD" "USD")
                                (asset "EQUITIES::YCS//USD" "YCS")
                              ] [
                                (weight-equal [
                                  (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                    (asset "EQUITIES::YCS//USD" "YCS")
                                  ] [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                      ] [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                              ] [
                                                (weight-equal [
                                                  (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    (asset "EQUITIES::REK//USD" "REK")
                                                  ] [
                                                    (weight-equal [
                                                      (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                      ] [
                                                        (weight-equal [
                                                          (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                                            (weight-inverse-vol 50 [
                                                              (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
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
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                      (group "Natural Gas ST Trading" [
                        (weight-equal [
                          (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                        ])
                      ])
                      (group "Oil ST Trading" [
                        (weight-equal [
                          (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
                            (weight-equal [
                              (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                                (asset "EQUITIES::SCO//USD" "SCO")
                              ] [
                                (asset "EQUITIES::GLD//USD" "GLD")
                              ])
                            ])
                          ] [
                            (asset "EQUITIES::USO//USD" "USO")
                          ])
                        ])
                      ])
                    ])
                  ])
                ] [
                  (weight-equal [
                    (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                      (weight-equal [
                        (weight-equal [
                          (group "ST Leveraged Semiconductors Trading" [
                            (weight-equal [
                              (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
                                (weight-equal [
                                  (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                                    (asset "EQUITIES::USD//USD" "USD")
                                    (asset "EQUITIES::YCS//USD" "YCS")
                                  ] [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                        (asset "EQUITIES::YCS//USD" "YCS")
                                      ] [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                              ] [
                                                (weight-equal [
                                                  (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                                    (asset "EQUITIES::VIXY//USD" "VIXY")
                                                  ] [
                                                    (weight-equal [
                                                      (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                        (asset "EQUITIES::REK//USD" "REK")
                                                      ] [
                                                        (weight-equal [
                                                          (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                          ] [
                                                            (weight-equal [
                                                              (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                                                (weight-inverse-vol 50 [
                                                                  (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
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
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                          (group "Natural Gas ST Trading" [
                            (weight-equal [
                              (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                            ])
                          ])
                          (group "Oil ST Trading" [
                            (weight-equal [
                              (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
                                (weight-equal [
                                  (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                                    (asset "EQUITIES::SCO//USD" "SCO")
                                  ] [
                                    (asset "EQUITIES::GLD//USD" "GLD")
                                  ])
                                ])
                              ] [
                                (asset "EQUITIES::USO//USD" "USO")
                              ])
                            ])
                          ])
                        ])
                      ])
                    ] [
                      (asset "EQUITIES::SVXY//USD" "SVXY")
                    ])
                  ])
                ])
              ])
            ])
            (if (> (rsi "EQUITIES::OEF//USD" 2) (rsi "EQUITIES::SVXY//USD" 2)) [
              (weight-inverse-vol 5 [
                (if (> (rsi "EQUITIES::OEF//USD" 2) (rsi "EQUITIES::SVXY//USD" 2)) [
                  (weight-inverse-vol 5 [
                    (asset "EQUITIES::VIXM//USD" "VIXM")
                  ])
                ] [
                  (weight-equal [
                    (group "ST Leveraged Semiconductors Trading" [
                      (weight-equal [
                        (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                              (asset "EQUITIES::USD//USD" "USD")
                              (asset "EQUITIES::YCS//USD" "YCS")
                            ] [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                  (asset "EQUITIES::YCS//USD" "YCS")
                                ] [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                    ] [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                                          (asset "EQUITIES::VIXY//USD" "VIXY")
                                        ] [
                                          (weight-equal [
                                            (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                              (asset "EQUITIES::VIXY//USD" "VIXY")
                                            ] [
                                              (weight-equal [
                                                (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                  (asset "EQUITIES::REK//USD" "REK")
                                                ] [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    ] [
                                                      (weight-equal [
                                                        (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                                          (weight-inverse-vol 50 [
                                                            (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
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
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                    (group "Natural Gas ST Trading" [
                      (weight-equal [
                        (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                      ])
                    ])
                    (group "Oil ST Trading" [
                      (weight-equal [
                        (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
                          (weight-equal [
                            (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                              (asset "EQUITIES::SCO//USD" "SCO")
                            ] [
                              (asset "EQUITIES::GLD//USD" "GLD")
                            ])
                          ])
                        ] [
                          (asset "EQUITIES::USO//USD" "USO")
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ] [
              (weight-equal [
                (if (> (rsi "EQUITIES::OEF//USD" 2) (rsi "EQUITIES::SVXY//USD" 2)) [
                  (weight-inverse-vol 5 [
                    (weight-equal [
                      (group "ST Leveraged Semiconductors Trading" [
                        (weight-equal [
                          (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                                (asset "EQUITIES::USD//USD" "USD")
                                (asset "EQUITIES::YCS//USD" "YCS")
                              ] [
                                (weight-equal [
                                  (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                    (asset "EQUITIES::YCS//USD" "YCS")
                                  ] [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                      ] [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                              ] [
                                                (weight-equal [
                                                  (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    (asset "EQUITIES::REK//USD" "REK")
                                                  ] [
                                                    (weight-equal [
                                                      (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                      ] [
                                                        (weight-equal [
                                                          (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                                            (weight-inverse-vol 50 [
                                                              (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
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
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                      (group "Natural Gas ST Trading" [
                        (weight-equal [
                          (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                        ])
                      ])
                      (group "Oil ST Trading" [
                        (weight-equal [
                          (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
                            (weight-equal [
                              (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                                (asset "EQUITIES::SCO//USD" "SCO")
                              ] [
                                (asset "EQUITIES::GLD//USD" "GLD")
                              ])
                            ])
                          ] [
                            (asset "EQUITIES::USO//USD" "USO")
                          ])
                        ])
                      ])
                    ])
                  ])
                ] [
                  (weight-equal [
                    (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                      (weight-equal [
                        (weight-equal [
                          (group "ST Leveraged Semiconductors Trading" [
                            (weight-equal [
                              (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
                                (weight-equal [
                                  (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                                    (asset "EQUITIES::USD//USD" "USD")
                                    (asset "EQUITIES::YCS//USD" "YCS")
                                  ] [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                        (asset "EQUITIES::YCS//USD" "YCS")
                                      ] [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                              ] [
                                                (weight-equal [
                                                  (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                                    (asset "EQUITIES::VIXY//USD" "VIXY")
                                                  ] [
                                                    (weight-equal [
                                                      (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                        (asset "EQUITIES::REK//USD" "REK")
                                                      ] [
                                                        (weight-equal [
                                                          (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                          ] [
                                                            (weight-equal [
                                                              (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                                                (weight-inverse-vol 50 [
                                                                  (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
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
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                          (group "Natural Gas ST Trading" [
                            (weight-equal [
                              (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                            ])
                          ])
                          (group "Oil ST Trading" [
                            (weight-equal [
                              (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
                                (weight-equal [
                                  (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                                    (asset "EQUITIES::SCO//USD" "SCO")
                                  ] [
                                    (asset "EQUITIES::GLD//USD" "GLD")
                                  ])
                                ])
                              ] [
                                (asset "EQUITIES::USO//USD" "USO")
                              ])
                            ])
                          ])
                        ])
                      ])
                    ] [
                      (asset "EQUITIES::SVXY//USD" "SVXY")
                    ])
                  ])
                ])
              ])
            ])
            (if (> (rsi "EQUITIES::VTI//USD" 2) (rsi "EQUITIES::CUT//USD" 2)) [
              (weight-equal [
                (if (> (rsi "EQUITIES::OEF//USD" 2) (rsi "EQUITIES::SVXY//USD" 2)) [
                  (weight-inverse-vol 5 [
                    (asset "EQUITIES::VIXM//USD" "VIXM")
                  ])
                ] [
                  (weight-equal [
                    (group "ST Leveraged Semiconductors Trading" [
                      (weight-equal [
                        (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                              (asset "EQUITIES::USD//USD" "USD")
                              (asset "EQUITIES::YCS//USD" "YCS")
                            ] [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                  (asset "EQUITIES::YCS//USD" "YCS")
                                ] [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                    ] [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                                          (asset "EQUITIES::VIXY//USD" "VIXY")
                                        ] [
                                          (weight-equal [
                                            (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                              (asset "EQUITIES::VIXY//USD" "VIXY")
                                            ] [
                                              (weight-equal [
                                                (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                  (asset "EQUITIES::REK//USD" "REK")
                                                ] [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    ] [
                                                      (weight-equal [
                                                        (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                                          (weight-inverse-vol 50 [
                                                            (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
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
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                    (group "Natural Gas ST Trading" [
                      (weight-equal [
                        (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                      ])
                    ])
                    (group "Oil ST Trading" [
                      (weight-equal [
                        (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
                          (weight-equal [
                            (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                              (asset "EQUITIES::SCO//USD" "SCO")
                            ] [
                              (asset "EQUITIES::GLD//USD" "GLD")
                            ])
                          ])
                        ] [
                          (asset "EQUITIES::USO//USD" "USO")
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ] [
              (weight-equal [
                (if (> (rsi "EQUITIES::OEF//USD" 2) (rsi "EQUITIES::SVXY//USD" 2)) [
                  (weight-inverse-vol 5 [
                    (weight-equal [
                      (group "ST Leveraged Semiconductors Trading" [
                        (weight-equal [
                          (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                                (asset "EQUITIES::USD//USD" "USD")
                                (asset "EQUITIES::YCS//USD" "YCS")
                              ] [
                                (weight-equal [
                                  (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                    (asset "EQUITIES::YCS//USD" "YCS")
                                  ] [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                      ] [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                              ] [
                                                (weight-equal [
                                                  (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    (asset "EQUITIES::REK//USD" "REK")
                                                  ] [
                                                    (weight-equal [
                                                      (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                      ] [
                                                        (weight-equal [
                                                          (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                                            (weight-inverse-vol 50 [
                                                              (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
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
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                      (group "Natural Gas ST Trading" [
                        (weight-equal [
                          (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                        ])
                      ])
                      (group "Oil ST Trading" [
                        (weight-equal [
                          (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
                            (weight-equal [
                              (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                                (asset "EQUITIES::SCO//USD" "SCO")
                              ] [
                                (asset "EQUITIES::GLD//USD" "GLD")
                              ])
                            ])
                          ] [
                            (asset "EQUITIES::USO//USD" "USO")
                          ])
                        ])
                      ])
                    ])
                  ])
                ] [
                  (weight-equal [
                    (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                      (weight-equal [
                        (weight-equal [
                          (group "ST Leveraged Semiconductors Trading" [
                            (weight-equal [
                              (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
                                (weight-equal [
                                  (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                                    (asset "EQUITIES::USD//USD" "USD")
                                    (asset "EQUITIES::YCS//USD" "YCS")
                                  ] [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                        (asset "EQUITIES::YCS//USD" "YCS")
                                      ] [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                              ] [
                                                (weight-equal [
                                                  (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                                    (asset "EQUITIES::VIXY//USD" "VIXY")
                                                  ] [
                                                    (weight-equal [
                                                      (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                        (asset "EQUITIES::REK//USD" "REK")
                                                      ] [
                                                        (weight-equal [
                                                          (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                          ] [
                                                            (weight-equal [
                                                              (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                                                (weight-inverse-vol 50 [
                                                                  (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
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
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                          (group "Natural Gas ST Trading" [
                            (weight-equal [
                              (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                            ])
                          ])
                          (group "Oil ST Trading" [
                            (weight-equal [
                              (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
                                (weight-equal [
                                  (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                                    (asset "EQUITIES::SCO//USD" "SCO")
                                  ] [
                                    (asset "EQUITIES::GLD//USD" "GLD")
                                  ])
                                ])
                              ] [
                                (asset "EQUITIES::USO//USD" "USO")
                              ])
                            ])
                          ])
                        ])
                      ])
                    ] [
                      (asset "EQUITIES::SVXY//USD" "SVXY")
                    ])
                  ])
                ])
              ])
            ])
            (if (> (rsi "EQUITIES::OEF//USD" 3) (rsi "EQUITIES::RSPT//USD" 3)) [
              (weight-equal [
                (if (> (rsi "EQUITIES::OEF//USD" 2) (rsi "EQUITIES::SVXY//USD" 2)) [
                  (weight-inverse-vol 5 [
                    (asset "EQUITIES::VIXM//USD" "VIXM")
                  ])
                ] [
                  (weight-equal [
                    (group "ST Leveraged Semiconductors Trading" [
                      (weight-equal [
                        (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                              (asset "EQUITIES::USD//USD" "USD")
                              (asset "EQUITIES::YCS//USD" "YCS")
                            ] [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                  (asset "EQUITIES::YCS//USD" "YCS")
                                ] [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                    ] [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                                          (asset "EQUITIES::VIXY//USD" "VIXY")
                                        ] [
                                          (weight-equal [
                                            (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                              (asset "EQUITIES::VIXY//USD" "VIXY")
                                            ] [
                                              (weight-equal [
                                                (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                  (asset "EQUITIES::REK//USD" "REK")
                                                ] [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    ] [
                                                      (weight-equal [
                                                        (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                                          (weight-inverse-vol 50 [
                                                            (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
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
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                    (group "Natural Gas ST Trading" [
                      (weight-equal [
                        (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                      ])
                    ])
                    (group "Oil ST Trading" [
                      (weight-equal [
                        (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
                          (weight-equal [
                            (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                              (asset "EQUITIES::SCO//USD" "SCO")
                            ] [
                              (asset "EQUITIES::GLD//USD" "GLD")
                            ])
                          ])
                        ] [
                          (asset "EQUITIES::USO//USD" "USO")
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ] [
              (weight-equal [
                (if (> (rsi "EQUITIES::OEF//USD" 2) (rsi "EQUITIES::SVXY//USD" 2)) [
                  (weight-inverse-vol 5 [
                    (weight-equal [
                      (group "ST Leveraged Semiconductors Trading" [
                        (weight-equal [
                          (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                                (asset "EQUITIES::USD//USD" "USD")
                                (asset "EQUITIES::YCS//USD" "YCS")
                              ] [
                                (weight-equal [
                                  (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                    (asset "EQUITIES::YCS//USD" "YCS")
                                  ] [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                      ] [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                              ] [
                                                (weight-equal [
                                                  (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    (asset "EQUITIES::REK//USD" "REK")
                                                  ] [
                                                    (weight-equal [
                                                      (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                      ] [
                                                        (weight-equal [
                                                          (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                                            (weight-inverse-vol 50 [
                                                              (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
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
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                      (group "Natural Gas ST Trading" [
                        (weight-equal [
                          (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                        ])
                      ])
                      (group "Oil ST Trading" [
                        (weight-equal [
                          (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
                            (weight-equal [
                              (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                                (asset "EQUITIES::SCO//USD" "SCO")
                              ] [
                                (asset "EQUITIES::GLD//USD" "GLD")
                              ])
                            ])
                          ] [
                            (asset "EQUITIES::USO//USD" "USO")
                          ])
                        ])
                      ])
                    ])
                  ])
                ] [
                  (weight-equal [
                    (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                      (weight-equal [
                        (weight-equal [
                          (group "ST Leveraged Semiconductors Trading" [
                            (weight-equal [
                              (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
                                (weight-equal [
                                  (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                                    (asset "EQUITIES::USD//USD" "USD")
                                    (asset "EQUITIES::YCS//USD" "YCS")
                                  ] [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                        (asset "EQUITIES::YCS//USD" "YCS")
                                      ] [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                              ] [
                                                (weight-equal [
                                                  (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                                    (asset "EQUITIES::VIXY//USD" "VIXY")
                                                  ] [
                                                    (weight-equal [
                                                      (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                        (asset "EQUITIES::REK//USD" "REK")
                                                      ] [
                                                        (weight-equal [
                                                          (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                          ] [
                                                            (weight-equal [
                                                              (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                                                (weight-inverse-vol 50 [
                                                                  (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
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
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                          (group "Natural Gas ST Trading" [
                            (weight-equal [
                              (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                            ])
                          ])
                          (group "Oil ST Trading" [
                            (weight-equal [
                              (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
                                (weight-equal [
                                  (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                                    (asset "EQUITIES::SCO//USD" "SCO")
                                  ] [
                                    (asset "EQUITIES::GLD//USD" "GLD")
                                  ])
                                ])
                              ] [
                                (asset "EQUITIES::USO//USD" "USO")
                              ])
                            ])
                          ])
                        ])
                      ])
                    ] [
                      (asset "EQUITIES::SVXY//USD" "SVXY")
                    ])
                  ])
                ])
              ])
            ])
            (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
              (weight-equal [
                (if (> (rsi "EQUITIES::OEF//USD" 2) (rsi "EQUITIES::SVXY//USD" 2)) [
                  (weight-inverse-vol 5 [
                    (asset "EQUITIES::VIXM//USD" "VIXM")
                  ])
                ] [
                  (weight-equal [
                    (group "ST Leveraged Semiconductors Trading" [
                      (weight-equal [
                        (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                              (asset "EQUITIES::USD//USD" "USD")
                              (asset "EQUITIES::YCS//USD" "YCS")
                            ] [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                  (asset "EQUITIES::YCS//USD" "YCS")
                                ] [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                    ] [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                                          (asset "EQUITIES::VIXY//USD" "VIXY")
                                        ] [
                                          (weight-equal [
                                            (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                              (asset "EQUITIES::VIXY//USD" "VIXY")
                                            ] [
                                              (weight-equal [
                                                (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                  (asset "EQUITIES::REK//USD" "REK")
                                                ] [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    ] [
                                                      (weight-equal [
                                                        (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                                          (weight-inverse-vol 50 [
                                                            (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                            (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ] [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-inverse-vol 20 [
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::RWM//USD" "RWM")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                (asset "EQUITIES::CWB//USD" "CWB")
                                                                (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
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
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                    (group "Natural Gas ST Trading" [
                      (weight-equal [
                        (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                        (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
                          (asset "EQUITIES::KOLD//USD" "KOLD")
                        ] [
                          (asset "EQUITIES::UNG//USD" "UNG")
                        ])
                      ])
                    ])
                    (group "Oil ST Trading" [
                      (weight-equal [
                        (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
                          (weight-equal [
                            (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                              (asset "EQUITIES::SCO//USD" "SCO")
                            ] [
                              (asset "EQUITIES::GLD//USD" "GLD")
                            ])
                          ])
                        ] [
                          (asset "EQUITIES::USO//USD" "USO")
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ] [
              (weight-equal [
                (if (> (rsi "EQUITIES::OEF//USD" 2) (rsi "EQUITIES::SVXY//USD" 2)) [
                  (weight-inverse-vol 5 [
                    (weight-equal [
                      (group "ST Leveraged Semiconductors Trading" [
                        (weight-equal [
                          (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                                (asset "EQUITIES::USD//USD" "USD")
                                (asset "EQUITIES::YCS//USD" "YCS")
                              ] [
                                (weight-equal [
                                  (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                    (asset "EQUITIES::YCS//USD" "YCS")
                                  ] [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                      ] [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                              ] [
                                                (weight-equal [
                                                  (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    (asset "EQUITIES::REK//USD" "REK")
                                                  ] [
                                                    (weight-equal [
                                                      (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                      ] [
                                                        (weight-equal [
                                                          (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                                            (weight-inverse-vol 50 [
                                                              (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ])
                                                              (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                (weight-equal [
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                    ])
                                                                  ] [
                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-inverse-vol 20 [
                                                                  (asset "EQUITIES::GLD//USD" "GLD")
                                                                  (asset "EQUITIES::RWM//USD" "RWM")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::CWB//USD" "CWB")
                                                                  (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
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
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                      (group "Natural Gas ST Trading" [
                        (weight-equal [
                          (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                          (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
                            (asset "EQUITIES::KOLD//USD" "KOLD")
                          ] [
                            (asset "EQUITIES::UNG//USD" "UNG")
                          ])
                        ])
                      ])
                      (group "Oil ST Trading" [
                        (weight-equal [
                          (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
                            (weight-equal [
                              (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                                (asset "EQUITIES::SCO//USD" "SCO")
                              ] [
                                (asset "EQUITIES::GLD//USD" "GLD")
                              ])
                            ])
                          ] [
                            (asset "EQUITIES::USO//USD" "USO")
                          ])
                        ])
                      ])
                    ])
                  ])
                ] [
                  (weight-equal [
                    (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                      (weight-equal [
                        (weight-equal [
                          (group "ST Leveraged Semiconductors Trading" [
                            (weight-equal [
                              (group "First Check Overbought / Oversold Conditions to Avoid Mean Reversion" [
                                (weight-equal [
                                  (if (< (rsi "EQUITIES::JNK//USD" 13) 13) [
                                    (asset "EQUITIES::USD//USD" "USD")
                                    (asset "EQUITIES::YCS//USD" "YCS")
                                  ] [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::QQQ//USD" 10) 29) [
                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                        (asset "EQUITIES::YCS//USD" "YCS")
                                      ] [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::QQQ//USD" 30) 71) [
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::QQQ//USD" 20) 75) [
                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                              ] [
                                                (weight-equal [
                                                  (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                                                    (asset "EQUITIES::VIXY//USD" "VIXY")
                                                  ] [
                                                    (weight-equal [
                                                      (if (< (rsi "EQUITIES::MGV//USD" 20) 31) [
                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                        (asset "EQUITIES::REK//USD" "REK")
                                                      ] [
                                                        (weight-equal [
                                                          (if (< (rsi "EQUITIES::MGV//USD" 10) 24) [
                                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                                          ] [
                                                            (weight-equal [
                                                              (group "NOT oversold / overbought - Proceed to ST Semiconductor Trading" [
                                                                (weight-inverse-vol 50 [
                                                                  (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::IHF//USD" 2)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::EMB//USD" 4) (moving-average-return "EQUITIES::ACWI//USD" 4)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::EMB//USD" 3) (moving-average-return "EQUITIES::OEF//USD" 3)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                  (if (> (moving-average-return "EQUITIES::PICB//USD" 2) (moving-average-return "EQUITIES::OEF//USD" 2)) [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ])
                                                                      ] [
                                                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-inverse-vol 20 [
                                                                      (asset "EQUITIES::GLD//USD" "GLD")
                                                                      (asset "EQUITIES::RWM//USD" "RWM")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::CWB//USD" "CWB")
                                                                      (if (> (standard-deviation-return "EQUITIES::VIXY//USD" 2) (standard-deviation-return "EQUITIES::VIXY//USD" 12)) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
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
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                          (group "Natural Gas ST Trading" [
                            (weight-equal [
                              (if (> (moving-average-return "EQUITIES::RSP//USD" 6) (moving-average-return "EQUITIES::XRT//USD" 6)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::YCL//USD" 6) (moving-average-return "EQUITIES::PICB//USD" 6)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::TLT//USD" 10) (moving-average-return "EQUITIES::ACWI//USD" 10)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::PFF//USD" 3) (moving-average-return "EQUITIES::NEAR//USD" 3)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                              (if (> (moving-average-return "EQUITIES::MDY//USD" 7) (moving-average-return "EQUITIES::XRT//USD" 7)) [
                                (asset "EQUITIES::KOLD//USD" "KOLD")
                              ] [
                                (asset "EQUITIES::UNG//USD" "UNG")
                              ])
                            ])
                          ])
                          (group "Oil ST Trading" [
                            (weight-equal [
                              (if (> (moving-average-return "EQUITIES::SHV//USD" 6) (moving-average-return "EQUITIES::HYG//USD" 6)) [
                                (weight-equal [
                                  (if (> (moving-average-return "EQUITIES::KCE//USD" 2) (moving-average-return "EQUITIES::XME//USD" 2)) [
                                    (asset "EQUITIES::SCO//USD" "SCO")
                                  ] [
                                    (asset "EQUITIES::GLD//USD" "GLD")
                                  ])
                                ])
                              ] [
                                (asset "EQUITIES::USO//USD" "USO")
                              ])
                            ])
                          ])
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
    ])
    (group "RSI Frankenfest" [
      (weight-equal [
        (weight-equal [
          (if (> (current-price "EQUITIES::QQQ//USD" 10) (exponential-moving-average-price "EQUITIES::QQQ//USD" 200)) [
            (weight-equal [
              (if (< (rsi "EQUITIES::TQQQ//USD" 2) 20) [
                (weight-equal [
                  (filter (standard-deviation-price 20) (select-top 2) [
                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                    (asset "EQUITIES::TECL//USD" "TECL")
                    (asset "EQUITIES::SOXL//USD" "SOXL")
                    (asset "EQUITIES::UPRO//USD" "UPRO")
                    (asset "EQUITIES::QLD//USD" "QLD")
                    (asset "EQUITIES::LTL//USD" "LTL")
                    (asset "EQUITIES::ROM//USD" "ROM")
                  ])
                ])
              ] [
                (weight-equal [
                  (if (> (rsi "EQUITIES::XLK//USD" 10) (rsi "EQUITIES::KMLM//USD" 10)) [
                    (weight-specified [80 20] [
                      (if (> (rsi "EQUITIES::CORP//USD" 15) (rsi "EQUITIES::XLK//USD" 10)) [
                        (asset "EQUITIES::QLD//USD" "QLD")
                      ] [
                        (weight-equal [
                          (if (> (rsi "EQUITIES::IYT//USD" 21) (rsi "EQUITIES::SPY//USD" 21)) [
                            (asset "EQUITIES::QLD//USD" "QLD")
                          ] [
                            (weight-equal [
                              (filter (rsi 10) (select-bottom 1) [
                                (asset "EQUITIES::BSV//USD" "BSV")
                                (asset "EQUITIES::TLT//USD" "TLT")
                                (asset "EQUITIES::LQD//USD" "LQD")
                                (asset "EQUITIES::VBF//USD" "VBF")
                                (asset "EQUITIES::XLP//USD" "XLP")
                                (asset "EQUITIES::UGE//USD" "UGE")
                                (asset "EQUITIES::XLU//USD" "XLU")
                                (asset "EQUITIES::XLV//USD" "XLV")
                                (asset "EQUITIES::SPAB//USD" "SPAB")
                                (asset "EQUITIES::ANGL//USD" "ANGL")
                              ])
                            ])
                          ])
                        ])
                      ])
                      (asset "EQUITIES::QLD//USD" "QLD")
                    ])
                  ] [
                    (weight-equal [
                      (filter (rsi 10) (select-bottom 1) [
                        (asset "EQUITIES::BSV//USD" "BSV")
                        (asset "EQUITIES::TLT//USD" "TLT")
                        (asset "EQUITIES::LQD//USD" "LQD")
                        (asset "EQUITIES::VBF//USD" "VBF")
                        (asset "EQUITIES::XLP//USD" "XLP")
                        (asset "EQUITIES::UGE//USD" "UGE")
                        (asset "EQUITIES::XLU//USD" "XLU")
                        (asset "EQUITIES::XLV//USD" "XLV")
                        (asset "EQUITIES::SPAB//USD" "SPAB")
                        (asset "EQUITIES::ANGL//USD" "ANGL")
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ] [
            (weight-equal [
              (filter (rsi 10) (select-bottom 1) [
                (asset "EQUITIES::BSV//USD" "BSV")
                (asset "EQUITIES::TLT//USD" "TLT")
                (asset "EQUITIES::LQD//USD" "LQD")
                (asset "EQUITIES::VBF//USD" "VBF")
                (asset "EQUITIES::XLP//USD" "XLP")
                (asset "EQUITIES::UGE//USD" "UGE")
                (asset "EQUITIES::XLU//USD" "XLU")
                (asset "EQUITIES::XLV//USD" "XLV")
                (asset "EQUITIES::SPAB//USD" "SPAB")
                (asset "EQUITIES::ANGL//USD" "ANGL")
              ])
            ])
          ])
        ])
      ])
    ])
  ])
