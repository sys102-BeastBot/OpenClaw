defsymphony "Beta Baller with Rotators Final_(Reduced Leverage) (Buy Copy)" {:rebalance-frequency :daily}
  (weight-equal [
    (if (< (rsi "EQUITIES::BIL//USD" 4) (rsi "EQUITIES::IEF//USD" 9)) [
      (weight-inverse-vol 10 [
        (filter (standard-deviation-return 10) (select-top 1) [
          (group "Extended Frontrunner | TCCC Basic Logic" [
            (weight-equal [
              (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                (asset "EQUITIES::VIXM//USD" "VIXM")
              ] [
                (weight-equal [
                  (if (or (> (rsi "EQUITIES::VTV//USD" 10) 79.0) (> (rsi "EQUITIES::VOX//USD" 10) 79.0)) [
                    (asset "EQUITIES::VIXM//USD" "VIXM")
                  ] [
                    (weight-equal [
                      (if (> (rsi "EQUITIES::TECL//USD" 10) 79) [
                        (asset "EQUITIES::VIXM//USD" "VIXM")
                      ] [
                        (weight-equal [
                          (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                            (asset "EQUITIES::VIXM//USD" "VIXM")
                          ] [
                            (weight-equal [
                              (if (or (or (> (rsi "EQUITIES::XLY//USD" 10) 80.0) (> (rsi "EQUITIES::FAS//USD" 10) 80.0) (> (rsi "EQUITIES::SPY//USD" 10) 80.0)) (> (rsi "EQUITIES::XLP//USD" 10) 75.0)) [
                                (asset "EQUITIES::VIXM//USD" "VIXM")
                              ] [
                                (weight-equal [
                                  (if (< (max-drawdown "EQUITIES::SPY//USD" 9) 0.1) [
                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                  ] [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                      ] [
                                        (weight-equal [
                                          (if (> (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                            (weight-equal [
                                              (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                (weight-equal [
                                                  (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -12) [
                                                    (weight-equal [
                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                      ] [
                                                        (group "TQQQ/SOXL/UPRO/TMV (5d MAR B1)" [
                                                          (weight-equal [
                                                            (filter (moving-average-return 20) (select-bottom 1) [
                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              (asset "EQUITIES::SMH//USD" "SMH")
                                                              (asset "EQUITIES::SMH//USD" "SMH")
                                                              (asset "EQUITIES::UPRO//USD" "UPRO")
                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ] [
                                                    (group "TQQQ/SOXL/UPRO/TMV (5d MAR T1)" [
                                                      (weight-equal [
                                                        (filter (moving-average-return 20) (select-top 1) [
                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                          (asset "EQUITIES::UPRO//USD" "UPRO")
                                                          (asset "EQUITIES::TMV//USD" "TMV")
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ] [
                                                (weight-equal [
                                                  (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                    (group "TQQQ/SOXL/UPRO/VWO (5d MAR B1)" [
                                                      (weight-equal [
                                                        (filter (moving-average-return 20) (select-bottom 1) [
                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                          (asset "EQUITIES::UPRO//USD" "UPRO")
                                                          (asset "EQUITIES::VWO//USD" "VWO")
                                                        ])
                                                      ])
                                                    ])
                                                  ] [
                                                    (group "SQQQ/SOXS/SPXU/VWO (5d MAR T1)" [
                                                      (weight-equal [
                                                        (filter (moving-average-return 5) (select-top 1) [
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::SH//USD" "SH")
                                                          (asset "EQUITIES::VWO//USD" "VWO")
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ] [
                                            (group "50% Safety Mix / 50% Long or Short Momentum" [
                                              (weight-equal [
                                                (group "SPLV/UUP/TMF (21d RSI - B1)" [
                                                  (weight-equal [
                                                    (filter (rsi 20) (select-bottom 1) [
                                                      (asset "EQUITIES::TMF//USD" "TMF")
                                                      (asset "EQUITIES::SPLV//USD" "SPLV")
                                                      (asset "EQUITIES::UUP//USD" "UUP")
                                                    ])
                                                  ])
                                                ])
                                                (group "Long or Short - Momentum" [
                                                  (weight-equal [
                                                    (if (> (cumulative-return "EQUITIES::UPRO//USD" 5) (cumulative-return "EQUITIES::SPXU//USD" 5)) [
                                                      (group "TQQQ/SOXL/USD/UPRO/BIL (5d MAR B1)" [
                                                        (weight-equal [
                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (group "SQQQ/SOXS/SSG/SPXU/VWO (5d MAR T1)" [
                                                        (weight-equal [
                                                          (filter (moving-average-return 5) (select-top 1) [
                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                            (asset "EQUITIES::SSG//USD" "SSG")
                                                            (asset "EQUITIES::SH//USD" "SH")
                                                            (asset "EQUITIES::VWO//USD" "VWO")
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
          (group "BWC Modified Madness" [
            (weight-equal [
              (weight-equal [
                (if (> (rsi "EQUITIES::SOXL//USD" 8) (rsi "EQUITIES::UPRO//USD" 9)) [
                  (weight-equal [
                    (group "\"V3.0.4.2a\" [HTX anti-twitch]| Beta Baller + TCCC | Deez, BrianE, HinnomTX, DereckN, Garen, DJKeyhole, comrade" [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::SPY//USD" 10) 79) [
                          (group "Overbought S&P. Sell the rip. Buy volatility." [
                            (weight-equal [
                              (filter (rsi 20) (select-bottom 1) [
                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                (asset "EQUITIES::VIXM//USD" "VIXM")
                              ])
                            ])
                          ])
                        ] [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::BIL//USD" 10) (rsi "EQUITIES::TLH//USD" 10)) [
                              (weight-equal [
                                (if (<= (rsi "EQUITIES::SOXX//USD" 10) 80) [
                                  (weight-equal [
                                    (filter (max-drawdown 5) (select-top 1) [
                                      (asset "EQUITIES::SMH//USD" "SMH")
                                      (asset "EQUITIES::TYO//USD" "TYO")
                                    ])
                                  ])
                                ] [
                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                ])
                              ])
                            ] [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::SPY//USD" 6) 27) [
                                  (group "Extremely oversold S&P (low RSI). Double check with bond mkt before going long" [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::BSV//USD" 7) (rsi "EQUITIES::SPHB//USD" 7)) [
                                        (weight-equal [
                                          (filter (rsi 20) (select-bottom 1) [
                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                          ])
                                        ])
                                      ] [
                                        (weight-equal [
                                          (filter (rsi 20) (select-bottom 1) [
                                            (asset "EQUITIES::SMH//USD" "SMH")
                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ] [
                                  (group "V0.2.1 | TCCC Stop the Bleed | DJKeyhole | 1/2 of Momentum Mean Reversion" [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                        (group "V1.2 | Five and Below | DJKeyhole | No Low Volume LETFs" [
                                          (weight-equal [
                                            (filter (rsi 10) (select-bottom 1) [
                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                              (asset "EQUITIES::SPHB//USD" "SPHB")
                                              (asset "EQUITIES::SMH//USD" "SMH")
                                              (asset "EQUITIES::UPRO//USD" "UPRO")
                                              (asset "EQUITIES::SHY//USD" "SHY")
                                            ])
                                          ])
                                        ])
                                      ] [
                                        (weight-equal [
                                          (group "Bear Stock Market - High Inflation - [STRIPPED] V2.0.2b | A Better LETF Basket | DJKeyhole | BIL and TMV" [
                                            (weight-equal [
                                              (if (> (moving-average-return "EQUITIES::TLT//USD" 100) (moving-average-return "EQUITIES::BIL//USD" 100)) [
                                                (group "A.B: Medium term TLT may be overbought*" [
                                                  (weight-equal [
                                                    (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                                      (group "A.B.B.A: Risk Off, Rising Rates (TMV)*" [
                                                        (weight-equal [
                                                          (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (<= (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::TLH//USD" 5)) [
                                                                    (weight-equal [
                                                                      (filter (cumulative-return 20) (select-top 1) [
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::EUO//USD" "EUO")
                                                                        (asset "EQUITIES::YCS//USD" "YCS")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::CURE//USD" "CURE")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ] [
                                                            (group "Go Do Something Else" [
                                                              (weight-specified [50 0 50] [
                                                                (filter (moving-average-return 21) (select-bottom 1) [
                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                  (asset "EQUITIES::UGL//USD" "UGL")
                                                                ])
                                                                (filter (moving-average-return 20) (select-bottom 1) [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                  (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                ])
                                                                (asset "EQUITIES::UUP//USD" "UUP")
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (group "A.B.B.B: Risk Off, Falling Rates (TMF)*" [
                                                        (weight-equal [
                                                          (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                                    (weight-equal [
                                                                      (filter (cumulative-return 20) (select-top 1) [
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (cumulative-return "EQUITIES::SPY//USD" 1) 1) [
                                                                        (weight-equal [
                                                                          (filter (cumulative-return 20) (select-top 1) [
                                                                            (asset "EQUITIES::ERX//USD" "ERX")
                                                                            (asset "EQUITIES::EUO//USD" "EUO")
                                                                            (asset "EQUITIES::YCS//USD" "YCS")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                                            (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                            (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
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
                                                              (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                                (weight-equal [
                                                                  (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                    (weight-equal [
                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (filter (cumulative-return 20) (select-top 1) [
                                                                                (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                                (asset "EQUITIES::UUP//USD" "UUP")
                                                                                (asset "EQUITIES::TMF//USD" "TMF")
                                                                                (asset "EQUITIES::UCO//USD" "UCO")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (filter (cumulative-return 20) (select-top 1) [
                                                                            (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                            (asset "EQUITIES::UUP//USD" "UUP")
                                                                            (asset "EQUITIES::TMF//USD" "TMF")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (group "Defense | Modified" [
                                                                  (weight-equal [
                                                                    (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                                      (weight-equal [
                                                                        (filter (rsi 20) (select-bottom 1) [
                                                                          (asset "EQUITIES::SHY//USD" "SHY")
                                                                          (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                          (asset "EQUITIES::GLD//USD" "GLD")
                                                                          (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::UCO//USD" "UCO")
                                                                          (asset "EQUITIES::YCS//USD" "YCS")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                          (weight-equal [
                                                                            (filter (moving-average-return 20) (select-bottom 1) [
                                                                              (asset "EQUITIES::SMH//USD" "SMH")
                                                                              (asset "EQUITIES::SMH//USD" "SMH")
                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (filter (cumulative-return 20) (select-top 1) [
                                                                              (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                              (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::UCO//USD" "UCO")
                                                                              (asset "EQUITIES::YCS//USD" "YCS")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
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
                                                (group "B: If long term TLT is trending down, safety: Long Term, 2 Least Volatile*" [
                                                  (weight-equal [
                                                    (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                                      (group "B.A.A: Risk Off, Rising Rates (TMV)* - LETF Basket^" [
                                                        (weight-equal [
                                                          (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 20) (select-top 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                                    (weight-equal [
                                                                      (filter (cumulative-return 20) (select-bottom 1) [
                                                                        (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::ERX//USD" "ERX")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (>= (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                                        (weight-equal [
                                                                          (filter (cumulative-return 20) (select-top 1) [
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            (asset "EQUITIES::EPI//USD" "EPI")
                                                                            (asset "EQUITIES::TMV//USD" "TMV")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (moving-average-return "EQUITIES::TMF//USD" 5) 0) [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                                (asset "EQUITIES::TNA//USD" "TNA")
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                                (asset "EQUITIES::TMV//USD" "TMV")
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
                                                          ] [
                                                            (weight-equal [
                                                              (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                                (weight-equal [
                                                                  (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                        (weight-equal [
                                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                            (weight-equal [
                                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                                (asset "EQUITIES::TMV//USD" "TMV")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (< (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 5) (select-top 2) [
                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                                (asset "EQUITIES::TNA//USD" "TNA")
                                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                (asset "EQUITIES::TMV//USD" "TMV")
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
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
                                                                (group "Defense | Modified" [
                                                                  (weight-equal [
                                                                    (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                                      (weight-equal [
                                                                        (if (>= (standard-deviation-return "EQUITIES::DBC//USD" 10) 3) [
                                                                          (weight-equal [
                                                                            (if (<= (standard-deviation-return "EQUITIES::TMV//USD" 5) (standard-deviation-return "EQUITIES::DBC//USD" 5)) [
                                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                                            ] [
                                                                              (asset "EQUITIES::DBC//USD" "DBC")
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                              (weight-equal [
                                                                                (filter (moving-average-return 20) (select-top 1) [
                                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                  (asset "EQUITIES::SH//USD" "SH")
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (filter (cumulative-return 20) (select-bottom 1) [
                                                                                  (asset "EQUITIES::EFA//USD" "EFA")
                                                                                  (asset "EQUITIES::EEM//USD" "EEM")
                                                                                  (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                  (asset "EQUITIES::UCO//USD" "UCO")
                                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                          (weight-equal [
                                                                            (filter (moving-average-return 20) (select-bottom 1) [
                                                                              (asset "EQUITIES::EPI//USD" "EPI")
                                                                              (asset "EQUITIES::SMH//USD" "SMH")
                                                                              (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (filter (cumulative-return 20) (select-top 1) [
                                                                              (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::EUO//USD" "EUO")
                                                                              (asset "EQUITIES::YCS//USD" "YCS")
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
                                                    ] [
                                                      (group "B.A.B: Risk Off, Falling Rates (TMF)* - LETF Basket" [
                                                        (weight-equal [
                                                          (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                            (weight-equal [
                                                              (if (<= (cumulative-return "EQUITIES::SPY//USD" 1) -2) [
                                                                (weight-equal [
                                                                  (filter (cumulative-return 20) (select-top 1) [
                                                                    (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (< (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                    (weight-equal [
                                                                      (filter (cumulative-return 20) (select-top 1) [
                                                                        (asset "EQUITIES::TMF//USD" "TMF")
                                                                        (asset "EQUITIES::TYO//USD" "TYO")
                                                                        (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 5) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::BRZU//USD" "BRZU")
                                                                        (asset "EQUITIES::TMF//USD" "TMF")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                                (weight-equal [
                                                                  (if (> (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (exponential-moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                                    (weight-equal [
                                                                      (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                        (weight-equal [
                                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                            (weight-equal [
                                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                                (asset "EQUITIES::EPI//USD" "EPI")
                                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                                (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                                (asset "EQUITIES::PUI//USD" "PUI")
                                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                                (asset "EQUITIES::TMF//USD" "TMF")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 5) (select-bottom 1) [
                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                                (asset "EQUITIES::EPI//USD" "EPI")
                                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                              ])
                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (filter (cumulative-return 20) (select-top 1) [
                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                (asset "EQUITIES::TMF//USD" "TMF")
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
                                                                  ] [
                                                                    (group "Unreachable" [
                                                                      (weight-specified [100 0] [
                                                                        (asset "EQUITIES::SHY//USD" "SHY")
                                                                        (filter (rsi 20) (select-bottom 1) [
                                                                          (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (group "Defense | Modified" [
                                                                  (weight-equal [
                                                                    (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                                      (weight-equal [
                                                                        (filter (rsi 20) (select-bottom 1) [
                                                                          (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                          (asset "EQUITIES::EPI//USD" "EPI")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 20) (select-top 1) [
                                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          (asset "EQUITIES::SMH//USD" "SMH")
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
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
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
                    (group "V4.0.0.3 | ?? Beta Baller + Modded TCCC  | Anansi + BWC + WHSmacon + HTX" [
                      (weight-equal [
                        (if (or (> (rsi "EQUITIES::TQQQ//USD" 10) 79.0) (> (rsi "EQUITIES::XLK//USD" 10) 79.0) (> (rsi "EQUITIES::VOX//USD" 10) 79.0) (> (rsi "EQUITIES::VTV//USD" 10) 79.0)) [
                          (asset "EQUITIES::VIXM//USD" "VIXM")
                        ] [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::TQQQ//USD" 14) 30) [
                              (asset "EQUITIES::QQQ//USD" "QQQ")
                            ] [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::SMH//USD" 14) 30) [
                                  (asset "EQUITIES::SMH//USD" "SMH")
                                ] [
                                  (group "Beta Baller + TCCC | Modded" [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::BIL//USD" 10) (rsi "EQUITIES::TLT//USD" 10)) [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::SPY//USD" 10) 75) [
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::SOXX//USD" 5) 80) [
                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                              ] [
                                                (asset "EQUITIES::SMH//USD" "SMH")
                                              ])
                                            ])
                                          ])
                                        ])
                                      ] [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::SPY//USD" 5) 25) [
                                            (weight-equal [
                                              (if (< (rsi "EQUITIES::BSV//USD" 10) (rsi "EQUITIES::SPHB//USD" 10)) [
                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                              ] [
                                                (asset "EQUITIES::SMH//USD" "SMH")
                                              ])
                                            ])
                                          ] [
                                            (group "Vegan TCCC Wrapper | Modded" [
                                              (weight-equal [
                                                (if (< (moving-average-return "EQUITIES::BIL//USD" 100) (moving-average-return "EQUITIES::TLT//USD" 100)) [
                                                  (weight-equal [
                                                    (if (and (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10.0) (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5)) [
                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                    ] [
                                                      (weight-equal [
                                                        (if (> (standard-deviation-return "EQUITIES::SPY//USD" 10) 3) [
                                                          (weight-equal [
                                                            (filter (rsi 5) (select-top 1) [
                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                              (asset "EQUITIES::TLT//USD" "TLT")
                                                              (asset "EQUITIES::SH//USD" "SH")
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (group "Rotator - TQQQ/TLT (Top 1)" [
                                                              (weight-equal [
                                                                (filter (moving-average-return 15) (select-top 1) [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::TLT//USD" "TLT")
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ] [
                                                  (group "B: If long term TLT is trending down, safety: Long Term, 2 Least Volatile*" [
                                                    (weight-equal [
                                                      (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                                        (group "B.A.A: Risk Off, Rising Rates (TMV)* - LETF Basket^" [
                                                          (weight-equal [
                                                            (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 5) (select-top 1) [
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                                      (weight-equal [
                                                                        (filter (cumulative-return 5) (select-bottom 1) [
                                                                          (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::ERX//USD" "ERX")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (>= (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                                          (weight-equal [
                                                                            (filter (cumulative-return 5) (select-top 1) [
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::EEM//USD" "EEM")
                                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (> (moving-average-return "EQUITIES::TMF//USD" 5) 0) [
                                                                              (weight-equal [
                                                                                (filter (moving-average-return 5) (select-bottom 1) [
                                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                                  (asset "EQUITIES::TNA//USD" "TNA")
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (filter (moving-average-return 3) (select-bottom 1) [
                                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                                  (asset "EQUITIES::TMV//USD" "TMV")
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
                                                            ] [
                                                              (weight-equal [
                                                                (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                                  (weight-equal [
                                                                    (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                                      (weight-equal [
                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                          (weight-equal [
                                                                            (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                              (weight-equal [
                                                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (filter (moving-average-return 5) (select-bottom 1) [
                                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                                              (weight-equal [
                                                                                (filter (moving-average-return 5) (select-top 2) [
                                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                                  (asset "EQUITIES::TNA//USD" "TNA")
                                                                                  (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
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
                                                                  (group "Defense | Modified" [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                                        (weight-equal [
                                                                          (if (>= (standard-deviation-return "EQUITIES::DBC//USD" 10) 3) [
                                                                            (weight-equal [
                                                                              (if (<= (standard-deviation-return "EQUITIES::TMV//USD" 5) (standard-deviation-return "EQUITIES::DBC//USD" 5)) [
                                                                                (asset "EQUITIES::TMV//USD" "TMV")
                                                                              ] [
                                                                                (asset "EQUITIES::DBC//USD" "DBC")
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 5) (select-top 1) [
                                                                                    (asset "EQUITIES::TMV//USD" "TMV")
                                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                    (asset "EQUITIES::SH//USD" "SH")
                                                                                  ])
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (filter (cumulative-return 5) (select-bottom 1) [
                                                                                    (asset "EQUITIES::EFA//USD" "EFA")
                                                                                    (asset "EQUITIES::EEM//USD" "EEM")
                                                                                    (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                    (asset "EQUITIES::UCO//USD" "UCO")
                                                                                    (asset "EQUITIES::TMV//USD" "TMV")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 5) (select-bottom 1) [
                                                                                (asset "EQUITIES::EEM//USD" "EEM")
                                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (filter (cumulative-return 5) (select-top 1) [
                                                                                (asset "EQUITIES::EEM//USD" "EEM")
                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                      ] [
                                                        (group "B.A.B: Risk Off, Falling Rates (TMF)* - LETF Basket" [
                                                          (weight-equal [
                                                            (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                              (weight-equal [
                                                                (if (<= (cumulative-return "EQUITIES::SPY//USD" 1) -2) [
                                                                  (weight-equal [
                                                                    (filter (cumulative-return 5) (select-top 1) [
                                                                      (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (< (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                      (weight-equal [
                                                                        (filter (cumulative-return 10) (select-top 1) [
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                                          (asset "EQUITIES::TYO//USD" "TYO")
                                                                          (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 5) (select-bottom 1) [
                                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                                          (asset "EQUITIES::EEM//USD" "EEM")
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                                  (weight-equal [
                                                                    (if (> (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (exponential-moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                                      (weight-equal [
                                                                        (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                          (weight-equal [
                                                                            (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                              (weight-equal [
                                                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (filter (moving-average-return 7) (select-bottom 1) [
                                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                  (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                                  (asset "EQUITIES::EEM//USD" "EEM")
                                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                                  (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                  (asset "EQUITIES::EEMV//USD" "EEMV")
                                                                                  (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                                  (asset "EQUITIES::PUI//USD" "PUI")
                                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                                  (asset "EQUITIES::TMF//USD" "TMF")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (> (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                              (weight-equal [
                                                                                (filter (moving-average-return 5) (select-bottom 1) [
                                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                  (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                                  (asset "EQUITIES::EEM//USD" "EEM")
                                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                                  (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                  (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                                ])
                                                                                (asset "EQUITIES::TMF//USD" "TMF")
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (filter (cumulative-return 5) (select-top 1) [
                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                  (asset "EQUITIES::TMF//USD" "TMF")
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
                                                                    ] [
                                                                      (group "Unreachable" [
                                                                        (weight-specified [100 0] [
                                                                          (asset "EQUITIES::SHY//USD" "SHY")
                                                                          (filter (rsi 5) (select-bottom 1) [
                                                                            (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (group "Defense | Modified" [
                                                                    (weight-equal [
                                                                      (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                                        (weight-equal [
                                                                          (filter (rsi 5) (select-bottom 1) [
                                                                            (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                            (asset "EQUITIES::EEM//USD" "EEM")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 5) (select-top 1) [
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
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
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
          (group "\"V3.0.4.2a\" [HTX anti-twitch]| Beta Baller + TCCC | Deez, BrianE, HinnomTX, DereckN, Garen, DJKeyhole, comrade" [
            (weight-equal [
              (if (> (rsi "EQUITIES::SPY//USD" 10) 79) [
                (group "Overbought S&P. Sell the rip. Buy volatility." [
                  (weight-equal [
                    (filter (rsi 20) (select-bottom 1) [
                      (asset "EQUITIES::VIXM//USD" "VIXM")
                      (asset "EQUITIES::VIXM//USD" "VIXM")
                    ])
                  ])
                ])
              ] [
                (weight-equal [
                  (if (< (rsi "EQUITIES::BIL//USD" 10) (rsi "EQUITIES::TLH//USD" 10)) [
                    (weight-equal [
                      (if (<= (rsi "EQUITIES::SOXX//USD" 10) 80) [
                        (weight-equal [
                          (filter (max-drawdown 5) (select-top 1) [
                            (asset "EQUITIES::SMH//USD" "SMH")
                            (asset "EQUITIES::TYO//USD" "TYO")
                          ])
                        ])
                      ] [
                        (asset "EQUITIES::PSQ//USD" "PSQ")
                      ])
                    ])
                  ] [
                    (weight-equal [
                      (if (< (rsi "EQUITIES::SPY//USD" 6) 27) [
                        (group "Extremely oversold S&P (low RSI). Double check with bond mkt before going long" [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::BSV//USD" 7) (rsi "EQUITIES::SPHB//USD" 7)) [
                              (weight-equal [
                                (filter (rsi 20) (select-bottom 1) [
                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                ])
                              ])
                            ] [
                              (weight-equal [
                                (filter (rsi 20) (select-bottom 1) [
                                  (asset "EQUITIES::SMH//USD" "SMH")
                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                ])
                              ])
                            ])
                          ])
                        ])
                      ] [
                        (group "V0.2.1 | TCCC Stop the Bleed | DJKeyhole | 1/2 of Momentum Mean Reversion" [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                              (group "V1.2 | Five and Below | DJKeyhole | No Low Volume LETFs" [
                                (weight-equal [
                                  (filter (rsi 10) (select-bottom 1) [
                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                    (asset "EQUITIES::SPHB//USD" "SPHB")
                                    (asset "EQUITIES::SMH//USD" "SMH")
                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                    (asset "EQUITIES::SHY//USD" "SHY")
                                  ])
                                ])
                              ])
                            ] [
                              (weight-equal [
                                (group "Bear Stock Market - High Inflation - [STRIPPED] V2.0.2b | A Better LETF Basket | DJKeyhole | BIL and TMV" [
                                  (weight-equal [
                                    (if (> (moving-average-return "EQUITIES::TLT//USD" 100) (moving-average-return "EQUITIES::BIL//USD" 100)) [
                                      (group "A.B: Medium term TLT may be overbought*" [
                                        (weight-equal [
                                          (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                            (group "A.B.B.A: Risk Off, Rising Rates (TMV)*" [
                                              (weight-equal [
                                                (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                      (weight-equal [
                                                        (filter (moving-average-return 20) (select-bottom 1) [
                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                          (asset "EQUITIES::UPRO//USD" "UPRO")
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (<= (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::TLH//USD" 5)) [
                                                          (weight-equal [
                                                            (filter (cumulative-return 20) (select-top 1) [
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::EUO//USD" "EUO")
                                                              (asset "EQUITIES::YCS//USD" "YCS")
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (filter (moving-average-return 20) (select-bottom 1) [
                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              (asset "EQUITIES::SMH//USD" "SMH")
                                                              (asset "EQUITIES::CURE//USD" "CURE")
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ] [
                                                  (group "Go Do Something Else" [
                                                    (weight-specified [50 0 50] [
                                                      (filter (moving-average-return 21) (select-bottom 1) [
                                                        (asset "EQUITIES::BTAL//USD" "BTAL")
                                                        (asset "EQUITIES::UGL//USD" "UGL")
                                                      ])
                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                      ])
                                                      (asset "EQUITIES::UUP//USD" "UUP")
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ] [
                                            (group "A.B.B.B: Risk Off, Falling Rates (TMF)*" [
                                              (weight-equal [
                                                (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                      (weight-equal [
                                                        (filter (moving-average-return 20) (select-bottom 1) [
                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                          (weight-equal [
                                                            (filter (cumulative-return 20) (select-top 1) [
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (> (cumulative-return "EQUITIES::SPY//USD" 1) 1) [
                                                              (weight-equal [
                                                                (filter (cumulative-return 20) (select-top 1) [
                                                                  (asset "EQUITIES::ERX//USD" "ERX")
                                                                  (asset "EQUITIES::EUO//USD" "EUO")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (filter (moving-average-return 20) (select-bottom 1) [
                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                  (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                  (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                  (asset "EQUITIES::SMH//USD" "SMH")
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
                                                    (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                      (weight-equal [
                                                        (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                          (weight-equal [
                                                            (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                              (weight-equal [
                                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 20) (select-bottom 1) [
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (filter (cumulative-return 20) (select-top 1) [
                                                                      (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                      (asset "EQUITIES::UUP//USD" "UUP")
                                                                      (asset "EQUITIES::TMF//USD" "TMF")
                                                                      (asset "EQUITIES::UCO//USD" "UCO")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                              (weight-equal [
                                                                (filter (moving-average-return 20) (select-bottom 1) [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (filter (cumulative-return 20) (select-top 1) [
                                                                  (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                  (asset "EQUITIES::UUP//USD" "UUP")
                                                                  (asset "EQUITIES::TMF//USD" "TMF")
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (group "Defense | Modified" [
                                                        (weight-equal [
                                                          (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                            (weight-equal [
                                                              (filter (rsi 20) (select-bottom 1) [
                                                                (asset "EQUITIES::SHY//USD" "SHY")
                                                                (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                (asset "EQUITIES::UCO//USD" "UCO")
                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                    (asset "EQUITIES::TMF//USD" "TMF")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (filter (cumulative-return 20) (select-top 1) [
                                                                    (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                    (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::UCO//USD" "UCO")
                                                                    (asset "EQUITIES::YCS//USD" "YCS")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
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
                                      (group "B: If long term TLT is trending down, safety: Long Term, 2 Least Volatile*" [
                                        (weight-equal [
                                          (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                            (group "B.A.A: Risk Off, Rising Rates (TMV)* - LETF Basket^" [
                                              (weight-equal [
                                                (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                      (weight-equal [
                                                        (filter (moving-average-return 20) (select-top 1) [
                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                          (asset "EQUITIES::UPRO//USD" "UPRO")
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                          (weight-equal [
                                                            (filter (cumulative-return 20) (select-bottom 1) [
                                                              (asset "EQUITIES::SPXS//USD" "SPXS")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::ERX//USD" "ERX")
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (>= (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                              (weight-equal [
                                                                (filter (cumulative-return 20) (select-top 1) [
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::EPI//USD" "EPI")
                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (> (moving-average-return "EQUITIES::TMF//USD" 5) 0) [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 20) (select-bottom 1) [
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                      (asset "EQUITIES::TNA//USD" "TNA")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 20) (select-bottom 1) [
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                      (asset "EQUITIES::TMV//USD" "TMV")
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
                                                ] [
                                                  (weight-equal [
                                                    (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                          (weight-equal [
                                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                              (weight-equal [
                                                                (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 20) (select-bottom 1) [
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                      (asset "EQUITIES::TMV//USD" "TMV")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 5) (select-top 2) [
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                      (asset "EQUITIES::TNA//USD" "TNA")
                                                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::TMV//USD" "TMV")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
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
                                                      (group "Defense | Modified" [
                                                        (weight-equal [
                                                          (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                            (weight-equal [
                                                              (if (>= (standard-deviation-return "EQUITIES::DBC//USD" 10) 3) [
                                                                (weight-equal [
                                                                  (if (<= (standard-deviation-return "EQUITIES::TMV//USD" 5) (standard-deviation-return "EQUITIES::DBC//USD" 5)) [
                                                                    (asset "EQUITIES::TMV//USD" "TMV")
                                                                  ] [
                                                                    (asset "EQUITIES::DBC//USD" "DBC")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 20) (select-top 1) [
                                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::SH//USD" "SH")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (filter (cumulative-return 20) (select-bottom 1) [
                                                                        (asset "EQUITIES::EFA//USD" "EFA")
                                                                        (asset "EQUITIES::EEM//USD" "EEM")
                                                                        (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::UCO//USD" "UCO")
                                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::EPI//USD" "EPI")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (filter (cumulative-return 20) (select-top 1) [
                                                                    (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::EUO//USD" "EUO")
                                                                    (asset "EQUITIES::YCS//USD" "YCS")
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
                                          ] [
                                            (group "B.A.B: Risk Off, Falling Rates (TMF)* - LETF Basket" [
                                              (weight-equal [
                                                (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                  (weight-equal [
                                                    (if (<= (cumulative-return "EQUITIES::SPY//USD" 1) -2) [
                                                      (weight-equal [
                                                        (filter (cumulative-return 20) (select-top 1) [
                                                          (asset "EQUITIES::SPXS//USD" "SPXS")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (< (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                          (weight-equal [
                                                            (filter (cumulative-return 20) (select-top 1) [
                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                              (asset "EQUITIES::TYO//USD" "TYO")
                                                              (asset "EQUITIES::SPXS//USD" "SPXS")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (filter (moving-average-return 5) (select-bottom 1) [
                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              (asset "EQUITIES::SMH//USD" "SMH")
                                                              (asset "EQUITIES::BRZU//USD" "BRZU")
                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                      (weight-equal [
                                                        (if (> (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (exponential-moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                          (weight-equal [
                                                            (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                              (weight-equal [
                                                                (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 20) (select-bottom 1) [
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                      (asset "EQUITIES::EPI//USD" "EPI")
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                      (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                      (asset "EQUITIES::PUI//USD" "PUI")
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                      (asset "EQUITIES::TMF//USD" "TMF")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (> (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 5) (select-bottom 1) [
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                      (asset "EQUITIES::EPI//USD" "EPI")
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                      (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                    ])
                                                                    (asset "EQUITIES::TMF//USD" "TMF")
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (filter (cumulative-return 20) (select-top 1) [
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      (asset "EQUITIES::TMF//USD" "TMF")
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
                                                        ] [
                                                          (group "Unreachable" [
                                                            (weight-specified [100 0] [
                                                              (asset "EQUITIES::SHY//USD" "SHY")
                                                              (filter (rsi 20) (select-bottom 1) [
                                                                (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (group "Defense | Modified" [
                                                        (weight-equal [
                                                          (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                            (weight-equal [
                                                              (filter (rsi 20) (select-bottom 1) [
                                                                (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                (asset "EQUITIES::EPI//USD" "EPI")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (filter (moving-average-return 20) (select-top 1) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::SMH//USD" "SMH")
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
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
          (group "V3.0.4.5 | ?? Beta Baller + TCCC | Anansi Clean Up | 2011-10-04" [
            (weight-equal [
              (if (> (rsi "EQUITIES::SOXL//USD" 8) (rsi "EQUITIES::UPRO//USD" 9)) [
                (group "V3.0.4.5 | ?? Beta Baller + TCCC | Cleaned Up | 2011-10-04" [
                  (weight-equal [
                    (if (< (rsi "EQUITIES::BIL//USD" 10) (rsi "EQUITIES::TLH//USD" 10)) [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::SPY//USD" 6) 75) [
                          (asset "EQUITIES::VIXM//USD" "VIXM")
                        ] [
                          (weight-equal [
                            (if (<= (rsi "EQUITIES::SOXL//USD" 5) 75) [
                              (asset "EQUITIES::SMH//USD" "SMH")
                            ] [
                              (asset "EQUITIES::PSQ//USD" "PSQ")
                            ])
                          ])
                        ])
                      ])
                    ] [
                      (weight-equal [
                        (if (< (rsi "EQUITIES::SPY//USD" 6) 27) [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::BSV//USD" 7) (rsi "EQUITIES::SPHB//USD" 7)) [
                              (weight-equal [
                                (filter (rsi 20) (select-bottom 1) [
                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                ])
                              ])
                            ] [
                              (weight-equal [
                                (filter (rsi 20) (select-bottom 1) [
                                  (asset "EQUITIES::SMH//USD" "SMH")
                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                  (asset "EQUITIES::TMF//USD" "TMF")
                                ])
                              ])
                            ])
                          ])
                        ] [
                          (group "V0.2.1 | TCCC ? | Version A" [
                            (weight-equal [
                              (if (> (rsi "EQUITIES::UVXY//USD" 10) 74) [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::UVXY//USD" 10) 84) [
                                    (asset "EQUITIES::SMH//USD" "SMH")
                                  ] [
                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                  ])
                                ])
                              ] [
                                (weight-equal [
                                  (if (> (moving-average-return "EQUITIES::SPTL//USD" 100) (moving-average-return "EQUITIES::BIL//USD" 100)) [
                                    (weight-equal [
                                      (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                        (group "A.B.B.A: Rising Rates (BIL)" [
                                          (weight-equal [
                                            (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                              (weight-equal [
                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                  (group "TQQQ/SOXL/UPRO (5d MAR B1)" [
                                                    (weight-equal [
                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                      ])
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (if (<= (cumulative-return "EQUITIES::SPXU//USD" 6) (cumulative-return "EQUITIES::UPRO//USD" 3)) [
                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                    ] [
                                                      (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                        (weight-equal [
                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
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
                                                (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                ] [
                                                  (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                    (weight-equal [
                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
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
                                        (group "A.B.B.B: Falling Rates (TMF)" [
                                          (weight-equal [
                                            (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                              (weight-equal [
                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                  (group "TQQQ/SOXL/UPRO (5d MAR B1)" [
                                                    (weight-equal [
                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                      ])
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                      (weight-equal [
                                                        (filter (cumulative-return 20) (select-top 1) [
                                                          (asset "EQUITIES::SH//USD" "SH")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                        ])
                                                      ])
                                                    ] [
                                                      (asset "EQUITIES::ERX//USD" "ERX")
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ] [
                                              (weight-equal [
                                                (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                  (weight-equal [
                                                    (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                    ] [
                                                      (weight-equal [
                                                        (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                          (weight-equal [
                                                            (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                  (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (filter (cumulative-return 20) (select-top 1) [
                                                                      (asset "EQUITIES::UUP//USD" "UUP")
                                                                      (asset "EQUITIES::TMF//USD" "TMF")
                                                                      (asset "EQUITIES::UCO//USD" "UCO")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                              (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (filter (cumulative-return 20) (select-top 1) [
                                                                  (asset "EQUITIES::UUP//USD" "UUP")
                                                                  (asset "EQUITIES::TMF//USD" "TMF")
                                                                  (asset "EQUITIES::EEM//USD" "EEM")
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
                                                    (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                      (weight-equal [
                                                        (filter (rsi 20) (select-bottom 1) [
                                                          (asset "EQUITIES::SHY//USD" "SHY")
                                                          (asset "EQUITIES::GLD//USD" "GLD")
                                                          (asset "EQUITIES::SH//USD" "SH")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::UCO//USD" "UCO")
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                          (group "TQQQ/SOXL/UPRO/TMF (5d MAR B1)" [
                                                            (weight-equal [
                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                (asset "EQUITIES::TMF//USD" "TMF")
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (filter (cumulative-return 20) (select-top 1) [
                                                              (asset "EQUITIES::SH//USD" "SH")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::UCO//USD" "UCO")
                                                            ])
                                                          ])
                                                        ])
                                                      ])
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
                                      (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                        (group "B.A.A: Rising Rates (TMV)" [
                                          (weight-equal [
                                            (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                              (weight-equal [
                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                  (group "TQQQ/SOXL/UPRO (5d MAR T1)" [
                                                    (weight-equal [
                                                      (filter (moving-average-return 20) (select-top 1) [
                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                      ])
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                      (weight-equal [
                                                        (filter (cumulative-return 20) (select-bottom 1) [
                                                          (asset "EQUITIES::SH//USD" "SH")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::ERX//USD" "ERX")
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (>= (cumulative-return "EQUITIES::SPXU//USD" 5) (cumulative-return "EQUITIES::UPRO//USD" 4)) [
                                                          (weight-equal [
                                                            (filter (cumulative-return 20) (select-top 1) [
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::EEM//USD" "EEM")
                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (>= (cumulative-return "EQUITIES::BIL//USD" 3) (cumulative-return "EQUITIES::TMV//USD" 3)) [
                                                              (group "TQQQ/SOXL/TNA (5d MAR B1)" [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                    (asset "EQUITIES::TNA//USD" "TNA")
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (group "TQQQ/SOXL/UPRO/TMV (3d MAR B1)" [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 3) (select-bottom 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
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
                                            ] [
                                              (weight-equal [
                                                (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                  (weight-equal [
                                                    (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                    ] [
                                                      (weight-equal [
                                                        (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                          (weight-equal [
                                                            (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                            ] [
                                                              (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                              (group "TQQQ/SOXL/UPRO/TMV (5d MAR T1)" [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 20) (select-top 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                    (asset "EQUITIES::TMV//USD" "TMV")
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (group "TQQQ/SOXL (20d MAR B1)" [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
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
                                                    (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                      (weight-equal [
                                                        (if (>= (standard-deviation-return "EQUITIES::DBC//USD" 10) 3) [
                                                          (weight-equal [
                                                            (if (<= (standard-deviation-return "EQUITIES::TMV//USD" 5) (standard-deviation-return "EQUITIES::DBC//USD" 5)) [
                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                            ] [
                                                              (asset "EQUITIES::UCO//USD" "UCO")
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                              (weight-equal [
                                                                (filter (moving-average-return 20) (select-top 1) [
                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::SH//USD" "SH")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (filter (cumulative-return 20) (select-bottom 1) [
                                                                  (asset "EQUITIES::EEM//USD" "EEM")
                                                                  (asset "EQUITIES::SH//USD" "SH")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::UCO//USD" "UCO")
                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                          (group "TQQQ/SOXL/UPRO (5d MAR B1)" [
                                                            (weight-equal [
                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (filter (cumulative-return 20) (select-top 1) [
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::EEM//USD" "EEM")
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
                                      ] [
                                        (group "B.A.B: Falling Rates (TMF)" [
                                          (weight-equal [
                                            (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                              (weight-equal [
                                                (if (<= (cumulative-return "EQUITIES::SPY//USD" 1) -2) [
                                                  (weight-equal [
                                                    (filter (cumulative-return 20) (select-top 1) [
                                                      (asset "EQUITIES::SH//USD" "SH")
                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (if (>= (cumulative-return "EQUITIES::SPXU//USD" 6) (cumulative-return "EQUITIES::UPRO//USD" 3)) [
                                                      (weight-equal [
                                                        (filter (cumulative-return 20) (select-top 1) [
                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                          (asset "EQUITIES::TMV//USD" "TMV")
                                                          (asset "EQUITIES::SH//USD" "SH")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                        ])
                                                      ])
                                                    ] [
                                                      (group "TQQQ/SOXL/UPRO/EEM/TMF (5d MAR B1)" [
                                                        (weight-equal [
                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                            (asset "EQUITIES::EEM//USD" "EEM")
                                                            (asset "EQUITIES::TMF//USD" "TMF")
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
                                                  (weight-equal [
                                                    (if (> (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (exponential-moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                        ] [
                                                          (weight-equal [
                                                            (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                              (weight-equal [
                                                                (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                ] [
                                                                  (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                  (group "TQQQ/SOXL/UPRO/TNA (5d MAR B1)" [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                        (asset "EQUITIES::TNA//USD" "TNA")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (filter (cumulative-return 20) (select-top 1) [
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      (asset "EQUITIES::TMF//USD" "TMF")
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
                                                        (filter (rsi 20) (select-bottom 1) [
                                                          (asset "EQUITIES::SH//USD" "SH")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                      (weight-equal [
                                                        (filter (rsi 20) (select-bottom 1) [
                                                          (asset "EQUITIES::SH//USD" "SH")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::EEM//USD" "EEM")
                                                        ])
                                                      ])
                                                    ] [
                                                      (group "TQQQ/SOXL/UPRO/TMF (5d MAR T1)" [
                                                        (weight-equal [
                                                          (filter (moving-average-return 20) (select-top 1) [
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
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
                                        ])
                                      ])
                                    ])
                                  ])
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
                (group "V3.0.4e | ?? Beta Baller + TCCC | Cleaned Up | 2011-10-04" [
                  (weight-equal [
                    (if (< (rsi "EQUITIES::BIL//USD" 42) (rsi "EQUITIES::IEF//USD" 70)) [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::SPY//USD" 7) 75) [
                          (asset "EQUITIES::VIXM//USD" "VIXM")
                        ] [
                          (weight-equal [
                            (if (> (current-price "EQUITIES::SOXL//USD" 5) (moving-average-return "EQUITIES::SOXL//USD" 2)) [
                              (weight-equal [
                                (filter (moving-average-return 20) (select-top 1) [
                                  (asset "EQUITIES::SMH//USD" "SMH")
                                  (asset "EQUITIES::UPRO//USD" "UPRO")
                                ])
                              ])
                            ] [
                              (asset "EQUITIES::PSQ//USD" "PSQ")
                            ])
                          ])
                        ])
                      ])
                    ] [
                      (weight-equal [
                        (if (< (rsi "EQUITIES::SPY//USD" 6) 27) [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::BSV//USD" 8) (rsi "EQUITIES::SPHB//USD" 8)) [
                              (weight-equal [
                                (filter (rsi 20) (select-bottom 1) [
                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                ])
                              ])
                            ] [
                              (weight-equal [
                                (filter (rsi 20) (select-bottom 1) [
                                  (asset "EQUITIES::SMH//USD" "SMH")
                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                  (asset "EQUITIES::TMF//USD" "TMF")
                                ])
                              ])
                            ])
                          ])
                        ] [
                          (group "V0.2.1 | TCCC ?" [
                            (weight-equal [
                              (if (> (current-price "EQUITIES::TLT//USD" 10) (moving-average-price "EQUITIES::TLT//USD" 200)) [
                                (weight-equal [
                                  (if (> (moving-average-return "EQUITIES::TLT//USD" 20) 0) [
                                    (group "A.B.B.B: Falling Rates (BIL)" [
                                      (weight-equal [
                                        (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                          (weight-equal [
                                            (if (>= (cumulative-return "EQUITIES::SPXU//USD" 5) (cumulative-return "EQUITIES::UPRO//USD" 4)) [
                                              (asset "EQUITIES::ERX//USD" "ERX")
                                            ] [
                                              (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                (weight-equal [
                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ] [
                                          (weight-equal [
                                            (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                              (weight-equal [
                                                (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                ] [
                                                  (weight-equal [
                                                    (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                      (weight-equal [
                                                        (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                        ] [
                                                          (group "7d BIL vs 7d IEF RSI" [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                (group "TQQQ/SOXL/UPRO (5d MAR B1)" [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 20) (select-bottom 1) [
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (filter (cumulative-return 20) (select-top 1) [
                                                                    (asset "EQUITIES::UUP//USD" "UUP")
                                                                    (asset "EQUITIES::TMF//USD" "TMF")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (group "7d BIL vs 7d IEF RSI" [
                                                        (weight-equal [
                                                          (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                            (group "TQQQ/SOXL/UPRO (5d MAR B1)" [
                                                              (weight-equal [
                                                                (filter (moving-average-return 20) (select-bottom 1) [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                  (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                ])
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (filter (cumulative-return 20) (select-top 1) [
                                                                (asset "EQUITIES::UUP//USD" "UUP")
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
                                            ] [
                                              (weight-equal [
                                                (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                  (weight-equal [
                                                    (filter (rsi 20) (select-bottom 1) [
                                                      (asset "EQUITIES::SHY//USD" "SHY")
                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                      (asset "EQUITIES::UCO//USD" "UCO")
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                      (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                        (weight-equal [
                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (filter (cumulative-return 20) (select-top 1) [
                                                          (asset "EQUITIES::SH//USD" "SH")
                                                          (asset "EQUITIES::UCO//USD" "UCO")
                                                        ])
                                                      ])
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
                                    (group "A.B.B.A: Rising Rates (TMV)" [
                                      (weight-equal [
                                        (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                          (weight-equal [
                                            (if (>= (cumulative-return "EQUITIES::SPXU//USD" 6) (cumulative-return "EQUITIES::UPRO//USD" 3)) [
                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                            ] [
                                              (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                (weight-equal [
                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ] [
                                          (weight-equal [
                                            (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                            ] [
                                              (group "TQQQ/SOXL/UPRO/TMV (5d MAR B1)" [
                                                (weight-equal [
                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
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
                              ] [
                                (weight-equal [
                                  (if (> (moving-average-return "EQUITIES::TLT//USD" 20) 0) [
                                    (group "B.A.B: Falling Rates (TMF)" [
                                      (weight-equal [
                                        (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                          (weight-equal [
                                            (if (<= (cumulative-return "EQUITIES::SPY//USD" 1) -2) [
                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                            ] [
                                              (weight-equal [
                                                (if (>= (cumulative-return "EQUITIES::SPXU//USD" 6) (cumulative-return "EQUITIES::UPRO//USD" 3)) [
                                                  (asset "EQUITIES::AGG//USD" "AGG")
                                                ] [
                                                  (group "TQQQ/SOXL/UPRO/EEM/TMF (5d MAR B1)" [
                                                    (weight-equal [
                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                        (asset "EQUITIES::EEM//USD" "EEM")
                                                        (asset "EQUITIES::TMF//USD" "TMF")
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
                                              (weight-equal [
                                                (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                ] [
                                                  (weight-equal [
                                                    (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                      (weight-equal [
                                                        (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                        ] [
                                                          (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                            (weight-equal [
                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                          (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                            (weight-equal [
                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (filter (cumulative-return 20) (select-top 1) [
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::TMF//USD" "TMF")
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
                                                (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                  (weight-equal [
                                                    (filter (rsi 20) (select-bottom 1) [
                                                      (asset "EQUITIES::SH//USD" "SH")
                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                    ])
                                                  ])
                                                ] [
                                                  (group "TQQQ/SOXL/UPRO/BIL (5d MAR T1)" [
                                                    (weight-equal [
                                                      (filter (moving-average-return 20) (select-top 1) [
                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
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
                                  ] [
                                    (group "B.A.A: Rising Rates (TMV)" [
                                      (weight-equal [
                                        (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                          (weight-equal [
                                            (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                              (asset "EQUITIES::SMH//USD" "SMH")
                                            ] [
                                              (weight-equal [
                                                (if (<= (cumulative-return "EQUITIES::SPY//USD" 2) -2) [
                                                  (weight-equal [
                                                    (filter (cumulative-return 20) (select-bottom 1) [
                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                      (asset "EQUITIES::BIL//USD" "BIL")
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (if (>= (cumulative-return "EQUITIES::SPXU//USD" 6) (cumulative-return "EQUITIES::UPRO//USD" 3)) [
                                                      (weight-equal [
                                                        (filter (cumulative-return 20) (select-top 1) [
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::EEM//USD" "EEM")
                                                        ])
                                                      ])
                                                    ] [
                                                      (group "TQQQ/SOXL/TMV (5d MAR B1)" [
                                                        (weight-equal [
                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::SMH//USD" "SMH")
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
                                        ] [
                                          (weight-equal [
                                            (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                              (weight-equal [
                                                (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                ] [
                                                  (weight-equal [
                                                    (if (and (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10.0) (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5)) [
                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                    ] [
                                                      (group "SOXL/UPRO (22d MAR B1)" [
                                                        (weight-equal [
                                                          (filter (moving-average-return 22) (select-bottom 1) [
                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ] [
                                              (weight-equal [
                                                (if (and (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) (>= (standard-deviation-return "EQUITIES::DBC//USD" 10) 3.0)) [
                                                  (weight-equal [
                                                    (if (<= (standard-deviation-return "EQUITIES::TMV//USD" 5) (standard-deviation-return "EQUITIES::DBC//USD" 5)) [
                                                      (asset "EQUITIES::TMV//USD" "TMV")
                                                    ] [
                                                      (asset "EQUITIES::UCO//USD" "UCO")
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (filter (cumulative-return 20) (select-top 1) [
                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
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
          (group "V4.0.0.3 | ?? Beta Baller + Modded TCCC  | Anansi + BWC + WHSmacon + HTX" [
            (weight-equal [
              (if (or (> (rsi "EQUITIES::TQQQ//USD" 10) 79.0) (> (rsi "EQUITIES::XLK//USD" 10) 79.0) (> (rsi "EQUITIES::VOX//USD" 10) 79.0) (> (rsi "EQUITIES::VTV//USD" 10) 79.0)) [
                (asset "EQUITIES::VIXM//USD" "VIXM")
              ] [
                (weight-equal [
                  (if (< (rsi "EQUITIES::TQQQ//USD" 14) 30) [
                    (asset "EQUITIES::QQQ//USD" "QQQ")
                  ] [
                    (weight-equal [
                      (if (< (rsi "EQUITIES::SMH//USD" 14) 30) [
                        (asset "EQUITIES::SMH//USD" "SMH")
                      ] [
                        (group "Beta Baller + TCCC | Modded" [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::BIL//USD" 10) (rsi "EQUITIES::TLT//USD" 10)) [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::SPY//USD" 10) 75) [
                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                ] [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::SOXX//USD" 5) 80) [
                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                    ] [
                                      (asset "EQUITIES::SMH//USD" "SMH")
                                    ])
                                  ])
                                ])
                              ])
                            ] [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::SPY//USD" 5) 25) [
                                  (weight-equal [
                                    (if (< (rsi "EQUITIES::BSV//USD" 10) (rsi "EQUITIES::SPHB//USD" 10)) [
                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                    ] [
                                      (asset "EQUITIES::SMH//USD" "SMH")
                                    ])
                                  ])
                                ] [
                                  (group "Vegan TCCC Wrapper | Modded" [
                                    (weight-equal [
                                      (if (< (moving-average-return "EQUITIES::BIL//USD" 100) (moving-average-return "EQUITIES::TLT//USD" 100)) [
                                        (weight-equal [
                                          (if (and (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10.0) (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5)) [
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ] [
                                            (weight-equal [
                                              (if (> (standard-deviation-return "EQUITIES::SPY//USD" 10) 3) [
                                                (weight-equal [
                                                  (filter (rsi 5) (select-top 1) [
                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                    (asset "EQUITIES::TLT//USD" "TLT")
                                                    (asset "EQUITIES::SH//USD" "SH")
                                                  ])
                                                ])
                                              ] [
                                                (weight-equal [
                                                  (group "Rotator - TQQQ/TLT (Top 1)" [
                                                    (weight-equal [
                                                      (filter (moving-average-return 15) (select-top 1) [
                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                        (asset "EQUITIES::TLT//USD" "TLT")
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ] [
                                        (group "B: If long term TLT is trending down, safety: Long Term, 2 Least Volatile*" [
                                          (weight-equal [
                                            (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                              (group "B.A.A: Risk Off, Rising Rates (TMV)* - LETF Basket^" [
                                                (weight-equal [
                                                  (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                    (weight-equal [
                                                      (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                        (weight-equal [
                                                          (filter (moving-average-return 5) (select-top 1) [
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                          ])
                                                        ])
                                                      ] [
                                                        (weight-equal [
                                                          (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                            (weight-equal [
                                                              (filter (cumulative-return 5) (select-bottom 1) [
                                                                (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                (asset "EQUITIES::ERX//USD" "ERX")
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (if (>= (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                                (weight-equal [
                                                                  (filter (cumulative-return 5) (select-top 1) [
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::EEM//USD" "EEM")
                                                                    (asset "EQUITIES::TMV//USD" "TMV")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (moving-average-return "EQUITIES::TMF//USD" 5) 0) [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 5) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::TNA//USD" "TNA")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 3) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::TMV//USD" "TMV")
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
                                                  ] [
                                                    (weight-equal [
                                                      (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                            (weight-equal [
                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                (weight-equal [
                                                                  (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 5) (select-bottom 1) [
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (< (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 5) (select-top 2) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::TNA//USD" "TNA")
                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
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
                                                        (group "Defense | Modified" [
                                                          (weight-equal [
                                                            (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                              (weight-equal [
                                                                (if (>= (standard-deviation-return "EQUITIES::DBC//USD" 10) 3) [
                                                                  (weight-equal [
                                                                    (if (<= (standard-deviation-return "EQUITIES::TMV//USD" 5) (standard-deviation-return "EQUITIES::DBC//USD" 5)) [
                                                                      (asset "EQUITIES::TMV//USD" "TMV")
                                                                    ] [
                                                                      (asset "EQUITIES::DBC//USD" "DBC")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 5) (select-top 1) [
                                                                          (asset "EQUITIES::TMV//USD" "TMV")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::SH//USD" "SH")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (filter (cumulative-return 5) (select-bottom 1) [
                                                                          (asset "EQUITIES::EFA//USD" "EFA")
                                                                          (asset "EQUITIES::EEM//USD" "EEM")
                                                                          (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::UCO//USD" "UCO")
                                                                          (asset "EQUITIES::TMV//USD" "TMV")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 5) (select-bottom 1) [
                                                                      (asset "EQUITIES::EEM//USD" "EEM")
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (filter (cumulative-return 5) (select-top 1) [
                                                                      (asset "EQUITIES::EEM//USD" "EEM")
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                            ] [
                                              (group "B.A.B: Risk Off, Falling Rates (TMF)* - LETF Basket" [
                                                (weight-equal [
                                                  (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                    (weight-equal [
                                                      (if (<= (cumulative-return "EQUITIES::SPY//USD" 1) -2) [
                                                        (weight-equal [
                                                          (filter (cumulative-return 5) (select-top 1) [
                                                            (asset "EQUITIES::SPXS//USD" "SPXS")
                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          ])
                                                        ])
                                                      ] [
                                                        (weight-equal [
                                                          (if (< (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                            (weight-equal [
                                                              (filter (cumulative-return 10) (select-top 1) [
                                                                (asset "EQUITIES::TMF//USD" "TMF")
                                                                (asset "EQUITIES::TYO//USD" "TYO")
                                                                (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (filter (moving-average-return 5) (select-bottom 1) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                (asset "EQUITIES::EEM//USD" "EEM")
                                                                (asset "EQUITIES::TMF//USD" "TMF")
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ] [
                                                    (weight-equal [
                                                      (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                        (weight-equal [
                                                          (if (> (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (exponential-moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                            (weight-equal [
                                                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                (weight-equal [
                                                                  (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 7) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                        (asset "EQUITIES::EEM//USD" "EEM")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::EEMV//USD" "EEMV")
                                                                        (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                        (asset "EQUITIES::PUI//USD" "PUI")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::TMF//USD" "TMF")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 5) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                        (asset "EQUITIES::EEM//USD" "EEM")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                        (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                      ])
                                                                      (asset "EQUITIES::TMF//USD" "TMF")
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (filter (cumulative-return 5) (select-top 1) [
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::TMF//USD" "TMF")
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
                                                          ] [
                                                            (group "Unreachable" [
                                                              (weight-specified [100 0] [
                                                                (asset "EQUITIES::SHY//USD" "SHY")
                                                                (filter (rsi 5) (select-bottom 1) [
                                                                  (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ] [
                                                        (group "Defense | Modified" [
                                                          (weight-equal [
                                                            (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                              (weight-equal [
                                                                (filter (rsi 5) (select-bottom 1) [
                                                                  (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                  (asset "EQUITIES::EEM//USD" "EEM")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (filter (moving-average-return 5) (select-top 1) [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::SMH//USD" "SMH")
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
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
          (group "Base 2 - FTLT or Bull or Bonds (UVXY)" [
            (weight-equal [
              (if (or (or (> (rsi "EQUITIES::QQQE//USD" 10) 79.0) (> (rsi "EQUITIES::VTV//USD" 10) 79.0) (> (rsi "EQUITIES::VOX//USD" 10) 79.0) (> (rsi "EQUITIES::TECL//USD" 10) 79.0) (> (rsi "EQUITIES::VOOG//USD" 10) 79.0) (> (rsi "EQUITIES::VOOV//USD" 10) 79.0)) (> (rsi "EQUITIES::XLP//USD" 10) 75.0)) [
                (group "Group" [
                  (weight-specified {"VIXM" 90 "PSQ" 10} [
                    (asset "EQUITIES::VIXM//USD" "VIXM")
                    (asset "EQUITIES::PSQ//USD" "PSQ")
                  ])
                ])
              ] [
                (weight-equal [
                  (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                    (weight-equal [
                      (group "Group" [
                        (weight-specified {"VIXM" 90 "PSQ" 10} [
                          (asset "EQUITIES::VIXM//USD" "VIXM")
                          (asset "EQUITIES::PSQ//USD" "PSQ")
                        ])
                      ])
                    ])
                  ] [
                    (weight-equal [
                      (if (or (> (rsi "EQUITIES::XLY//USD" 10) 80.0) (> (rsi "EQUITIES::FAS//USD" 10) 80.0) (> (rsi "EQUITIES::SPY//USD" 10) 80.0)) [
                        (group "Group" [
                          (weight-specified {"VIXM" 90 "PSQ" 10} [
                            (asset "EQUITIES::VIXM//USD" "VIXM")
                            (asset "EQUITIES::PSQ//USD" "PSQ")
                          ])
                        ])
                      ] [
                        (weight-equal [
                          (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -12) [
                            (weight-equal [
                              (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                (weight-equal [
                                  (group "Group" [
                                    (weight-specified {"VIXM" 90 "PSQ" 10} [
                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                    ])
                                  ])
                                ])
                              ] [
                                (weight-equal [
                                  (group "FTLT or Safety Town" [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                      ] [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                            (asset "EQUITIES::SMH//USD" "SMH")
                                          ] [
                                            (weight-equal [
                                              (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                                (asset "EQUITIES::SPHB//USD" "SPHB")
                                              ] [
                                                (weight-equal [
                                                  (group "Bull or Safety Town - Base 2" [
                                                    (weight-equal [
                                                      (if (> (rsi "EQUITIES::SPY//USD" 126) (rsi "EQUITIES::XLU//USD" 126)) [
                                                        (weight-equal [
                                                          (group "Bull (Commodities?)" [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::XLK//USD" 126) (rsi "EQUITIES::DBC//USD" 126)) [
                                                                (weight-equal [
                                                                  (filter (cumulative-return 20) (select-top 1) [
                                                                    (asset "EQUITIES::ERX//USD" "ERX")
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ] [
                                                        (weight-equal [
                                                          (if (< (rsi "EQUITIES::TLT//USD" 126) 50) [
                                                            (weight-equal [
                                                              (group "TECL (18.3-13.7)" [
                                                                (weight-equal [
                                                                  (if (< (rsi "EQUITIES::TECL//USD" 21) (rsi "EQUITIES::AGG//USD" 21)) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (group "Safety Town l AR 41.9% DD 11.5% B -0.11" [
                                                                        (weight-equal [
                                                                          (if (>= (rsi "EQUITIES::SPY//USD" 10) 70.0) [
                                                                            (weight-equal [
                                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (> (rsi "EQUITIES::SPY//USD" 126) (rsi "EQUITIES::XLU//USD" 126)) [
                                                                                (weight-equal [
                                                                                  (group "A" [
                                                                                    (weight-equal [
                                                                                      (filter (standard-deviation-price 20) (select-top 2) [
                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                        (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                  (group "B" [
                                                                                    (weight-equal [
                                                                                      (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                      (group "VIXM & BTAL" [
                                                                                        (weight-equal [
                                                                                          (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (group "A" [
                                                                                    (weight-equal [
                                                                                      (filter (standard-deviation-price 20) (select-top 2) [
                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
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
                                                          ] [
                                                            (weight-equal [
                                                              (group "TMF or USDU" [
                                                                (weight-equal [
                                                                  (filter (rsi 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::TMF//USD" "TMF")
                                                                    (asset "EQUITIES::USDU//USD" "USDU")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
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
                              (group "FTLT or Safety Town" [
                                (weight-equal [
                                  (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                  ] [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                        (asset "EQUITIES::SMH//USD" "SMH")
                                      ] [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                            (asset "EQUITIES::SPHB//USD" "SPHB")
                                          ] [
                                            (weight-equal [
                                              (group "Bull or Safety Town - Base 2" [
                                                (weight-equal [
                                                  (if (> (rsi "EQUITIES::SPY//USD" 126) (rsi "EQUITIES::XLU//USD" 126)) [
                                                    (weight-equal [
                                                      (group "Bull (Commodities?)" [
                                                        (weight-equal [
                                                          (if (< (rsi "EQUITIES::XLK//USD" 126) (rsi "EQUITIES::DBC//USD" 126)) [
                                                            (weight-equal [
                                                              (filter (cumulative-return 20) (select-top 1) [
                                                                (asset "EQUITIES::ERX//USD" "ERX")
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ] [
                                                    (weight-equal [
                                                      (if (< (rsi "EQUITIES::TLT//USD" 126) 50) [
                                                        (weight-equal [
                                                          (group "TECL (18.3-13.7)" [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::TECL//USD" 21) (rsi "EQUITIES::AGG//USD" 21)) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              ] [
                                                                (weight-equal [
                                                                  (group "Safety Town l AR 41.9% DD 11.5% B -0.11" [
                                                                    (weight-equal [
                                                                      (if (>= (rsi "EQUITIES::SPY//USD" 10) 70.0) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (rsi "EQUITIES::SPY//USD" 126) (rsi "EQUITIES::XLU//USD" 126)) [
                                                                            (weight-equal [
                                                                              (group "A" [
                                                                                (weight-equal [
                                                                                  (filter (standard-deviation-price 20) (select-top 2) [
                                                                                    (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                    (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                              (group "B" [
                                                                                (weight-equal [
                                                                                  (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                  (group "VIXM & BTAL" [
                                                                                    (weight-equal [
                                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (group "A" [
                                                                                (weight-equal [
                                                                                  (filter (standard-deviation-price 20) (select-top 2) [
                                                                                    (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
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
                                                      ] [
                                                        (weight-equal [
                                                          (group "TMF or USDU" [
                                                            (weight-equal [
                                                              (filter (rsi 20) (select-bottom 1) [
                                                                (asset "EQUITIES::TMF//USD" "TMF")
                                                                (asset "EQUITIES::USDU//USD" "USDU")
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
          (group "KMLM switcher (single pops)| BT 4/13/22 = A.R. 466% / D.D. 22%" [
            (weight-equal [
              (if (or (or (> (rsi "EQUITIES::QQQE//USD" 10) 79.0) (> (rsi "EQUITIES::VTV//USD" 10) 79.0) (> (rsi "EQUITIES::VOX//USD" 10) 79.0) (> (rsi "EQUITIES::TECL//USD" 10) 79.0) (> (rsi "EQUITIES::VOOG//USD" 10) 79.0) (> (rsi "EQUITIES::VOOV//USD" 10) 79.0)) (> (rsi "EQUITIES::XLP//USD" 10) 75.0)) [
                (asset "EQUITIES::VIXM//USD" "VIXM")
              ] [
                (weight-equal [
                  (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                    (weight-equal [
                      (asset "EQUITIES::VIXM//USD" "VIXM")
                    ])
                  ] [
                    (weight-equal [
                      (if (or (> (rsi "EQUITIES::XLY//USD" 10) 80.0) (> (rsi "EQUITIES::FAS//USD" 10) 80.0) (> (rsi "EQUITIES::SPY//USD" 10) 80.0)) [
                        (asset "EQUITIES::VIXM//USD" "VIXM")
                      ] [
                        (weight-equal [
                          (group "Single Popped KMLM" [
                            (weight-equal [
                              (if (> (rsi "EQUITIES::UVXY//USD" 21) 65) [
                                (weight-equal [
                                  (group "BSC" [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::SPY//USD" 21) 30) [
                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                      ] [
                                        (asset "EQUITIES::SPHB//USD" "SPHB")
                                      ])
                                    ])
                                  ])
                                ])
                              ] [
                                (weight-equal [
                                  (group "Combined Pop Bot" [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                      ] [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                            (asset "EQUITIES::SMH//USD" "SMH")
                                          ] [
                                            (weight-equal [
                                              (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                                (asset "EQUITIES::SPHB//USD" "SPHB")
                                              ] [
                                                (weight-equal [
                                                  (group "Copypasta YOLO GainZs Here" [
                                                    (weight-equal [
                                                      (group "KMLM switcher: TECL, SVIX, or L/S Rotator | BT 4/13/22 = AR 164% / DD 22.2%" [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::XLK//USD" 10) (rsi "EQUITIES::KMLM//USD" 10)) [
                                                            (weight-equal [
                                                              (filter (rsi 10) (select-bottom 1) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::SVXY//USD" "SVXY")
                                                              ])
                                                            ])
                                                          ] [
                                                            (group "Long/Short Rotator with FTLS KMLM SSO UUP | BT 12/10/20 | 15.1/3.5  " [
                                                              (weight-equal [
                                                                (filter (standard-deviation-return 6) (select-bottom 3) [
                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                  (asset "EQUITIES::TMF//USD" "TMF")
                                                                  (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  (asset "EQUITIES::FTLS//USD" "FTLS")
                                                                  (asset "EQUITIES::KMLM//USD" "KMLM")
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
                ])
              ])
            ])
          ])
        ])
      ])
    ] [
      (weight-equal [
        (if (< (rsi "EQUITIES::SBND//USD" 9) (rsi "EQUITIES::HIBL//USD" 10)) [
          (weight-specified [89 11] [
            (filter (rsi 7) (select-bottom 1) [
              (asset "EQUITIES::PSQ//USD" "PSQ")
            ])
            (asset "EQUITIES::VIXM//USD" "VIXM")
          ])
        ] [
          (weight-inverse-vol 10 [
            (filter (standard-deviation-return 10) (select-top 1) [
              (group "Extended Frontrunner | TCCC Basic Logic" [
                (weight-equal [
                  (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                    (asset "EQUITIES::VIXM//USD" "VIXM")
                  ] [
                    (weight-equal [
                      (if (or (> (rsi "EQUITIES::VTV//USD" 10) 79.0) (> (rsi "EQUITIES::VOX//USD" 10) 79.0)) [
                        (asset "EQUITIES::VIXM//USD" "VIXM")
                      ] [
                        (weight-equal [
                          (if (> (rsi "EQUITIES::TECL//USD" 10) 79) [
                            (asset "EQUITIES::VIXM//USD" "VIXM")
                          ] [
                            (weight-equal [
                              (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                (asset "EQUITIES::VIXM//USD" "VIXM")
                              ] [
                                (weight-equal [
                                  (if (or (or (> (rsi "EQUITIES::XLY//USD" 10) 80.0) (> (rsi "EQUITIES::FAS//USD" 10) 80.0) (> (rsi "EQUITIES::SPY//USD" 10) 80.0)) (> (rsi "EQUITIES::XLP//USD" 10) 75.0)) [
                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                  ] [
                                    (weight-equal [
                                      (if (< (max-drawdown "EQUITIES::SPY//USD" 9) 0.1) [
                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                      ] [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                          ] [
                                            (weight-equal [
                                              (if (> (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                (weight-equal [
                                                  (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                    (weight-equal [
                                                      (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -12) [
                                                        (weight-equal [
                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                                          ] [
                                                            (group "TQQQ/SOXL/UPRO/TMV (5d MAR B1)" [
                                                              (weight-equal [
                                                                (filter (moving-average-return 20) (select-bottom 1) [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                  (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ] [
                                                        (group "TQQQ/SOXL/UPRO/TMV (5d MAR T1)" [
                                                          (weight-equal [
                                                            (filter (moving-average-return 20) (select-top 1) [
                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              (asset "EQUITIES::SMH//USD" "SMH")
                                                              (asset "EQUITIES::SMH//USD" "SMH")
                                                              (asset "EQUITIES::UPRO//USD" "UPRO")
                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ] [
                                                    (weight-equal [
                                                      (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                        (group "TQQQ/SOXL/UPRO/VWO (5d MAR B1)" [
                                                          (weight-equal [
                                                            (filter (moving-average-return 20) (select-bottom 1) [
                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              (asset "EQUITIES::SMH//USD" "SMH")
                                                              (asset "EQUITIES::UPRO//USD" "UPRO")
                                                              (asset "EQUITIES::VWO//USD" "VWO")
                                                            ])
                                                          ])
                                                        ])
                                                      ] [
                                                        (group "SQQQ/SOXS/SPXU/VWO (5d MAR T1)" [
                                                          (weight-equal [
                                                            (filter (moving-average-return 5) (select-top 1) [
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::SH//USD" "SH")
                                                              (asset "EQUITIES::VWO//USD" "VWO")
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ] [
                                                (group "50% Safety Mix / 50% Long or Short Momentum" [
                                                  (weight-equal [
                                                    (group "SPLV/UUP/TMF (21d RSI - B1)" [
                                                      (weight-equal [
                                                        (filter (rsi 20) (select-bottom 1) [
                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                          (asset "EQUITIES::SPLV//USD" "SPLV")
                                                          (asset "EQUITIES::UUP//USD" "UUP")
                                                        ])
                                                      ])
                                                    ])
                                                    (group "Long or Short - Momentum" [
                                                      (weight-equal [
                                                        (if (> (cumulative-return "EQUITIES::UPRO//USD" 5) (cumulative-return "EQUITIES::SPXU//USD" 5)) [
                                                          (group "TQQQ/SOXL/USD/UPRO/BIL (5d MAR B1)" [
                                                            (weight-equal [
                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (group "SQQQ/SOXS/SSG/SPXU/VWO (5d MAR T1)" [
                                                            (weight-equal [
                                                              (filter (moving-average-return 5) (select-top 1) [
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                (asset "EQUITIES::SSG//USD" "SSG")
                                                                (asset "EQUITIES::SH//USD" "SH")
                                                                (asset "EQUITIES::VWO//USD" "VWO")
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
              (group "BWC Modified Madness" [
                (weight-equal [
                  (weight-equal [
                    (if (> (rsi "EQUITIES::SOXL//USD" 8) (rsi "EQUITIES::UPRO//USD" 9)) [
                      (weight-equal [
                        (group "\"V3.0.4.2a\" [HTX anti-twitch]| Beta Baller + TCCC | Deez, BrianE, HinnomTX, DereckN, Garen, DJKeyhole, comrade" [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::SPY//USD" 10) 79) [
                              (group "Overbought S&P. Sell the rip. Buy volatility." [
                                (weight-equal [
                                  (filter (rsi 20) (select-bottom 1) [
                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                  ])
                                ])
                              ])
                            ] [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::BIL//USD" 10) (rsi "EQUITIES::TLH//USD" 10)) [
                                  (weight-equal [
                                    (if (<= (rsi "EQUITIES::SOXX//USD" 10) 80) [
                                      (weight-equal [
                                        (filter (max-drawdown 5) (select-top 1) [
                                          (asset "EQUITIES::SMH//USD" "SMH")
                                          (asset "EQUITIES::TYO//USD" "TYO")
                                        ])
                                      ])
                                    ] [
                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                    ])
                                  ])
                                ] [
                                  (weight-equal [
                                    (if (< (rsi "EQUITIES::SPY//USD" 6) 27) [
                                      (group "Extremely oversold S&P (low RSI). Double check with bond mkt before going long" [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::BSV//USD" 7) (rsi "EQUITIES::SPHB//USD" 7)) [
                                            (weight-equal [
                                              (filter (rsi 20) (select-bottom 1) [
                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                              ])
                                            ])
                                          ] [
                                            (weight-equal [
                                              (filter (rsi 20) (select-bottom 1) [
                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ] [
                                      (group "V0.2.1 | TCCC Stop the Bleed | DJKeyhole | 1/2 of Momentum Mean Reversion" [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                            (group "V1.2 | Five and Below | DJKeyhole | No Low Volume LETFs" [
                                              (weight-equal [
                                                (filter (rsi 10) (select-bottom 1) [
                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                  (asset "EQUITIES::SPHB//USD" "SPHB")
                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                  (asset "EQUITIES::UPRO//USD" "UPRO")
                                                  (asset "EQUITIES::SHY//USD" "SHY")
                                                ])
                                              ])
                                            ])
                                          ] [
                                            (weight-equal [
                                              (group "Bear Stock Market - High Inflation - [STRIPPED] V2.0.2b | A Better LETF Basket | DJKeyhole | BIL and TMV" [
                                                (weight-equal [
                                                  (if (> (moving-average-return "EQUITIES::TLT//USD" 100) (moving-average-return "EQUITIES::BIL//USD" 100)) [
                                                    (group "A.B: Medium term TLT may be overbought*" [
                                                      (weight-equal [
                                                        (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                                          (group "A.B.B.A: Risk Off, Rising Rates (TMV)*" [
                                                            (weight-equal [
                                                              (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                                (weight-equal [
                                                                  (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (<= (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::TLH//USD" 5)) [
                                                                        (weight-equal [
                                                                          (filter (cumulative-return 20) (select-top 1) [
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            (asset "EQUITIES::EUO//USD" "EUO")
                                                                            (asset "EQUITIES::YCS//USD" "YCS")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                                            (asset "EQUITIES::CURE//USD" "CURE")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (group "Go Do Something Else" [
                                                                  (weight-specified [50 0 50] [
                                                                    (filter (moving-average-return 21) (select-bottom 1) [
                                                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                      (asset "EQUITIES::UGL//USD" "UGL")
                                                                    ])
                                                                    (filter (moving-average-return 20) (select-bottom 1) [
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                      (asset "EQUITIES::TMV//USD" "TMV")
                                                                    ])
                                                                    (asset "EQUITIES::UUP//USD" "UUP")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (group "A.B.B.B: Risk Off, Falling Rates (TMF)*" [
                                                            (weight-equal [
                                                              (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                                (weight-equal [
                                                                  (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                                        (weight-equal [
                                                                          (filter (cumulative-return 20) (select-top 1) [
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (cumulative-return "EQUITIES::SPY//USD" 1) 1) [
                                                                            (weight-equal [
                                                                              (filter (cumulative-return 20) (select-top 1) [
                                                                                (asset "EQUITIES::ERX//USD" "ERX")
                                                                                (asset "EQUITIES::EUO//USD" "EUO")
                                                                                (asset "EQUITIES::YCS//USD" "YCS")
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                                (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                                (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                                (asset "EQUITIES::SMH//USD" "SMH")
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
                                                                  (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                                    (weight-equal [
                                                                      (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                        (weight-equal [
                                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                            (weight-equal [
                                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                                  ])
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (filter (cumulative-return 20) (select-top 1) [
                                                                                    (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                                    (asset "EQUITIES::UUP//USD" "UUP")
                                                                                    (asset "EQUITIES::TMF//USD" "TMF")
                                                                                    (asset "EQUITIES::UCO//USD" "UCO")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (filter (cumulative-return 20) (select-top 1) [
                                                                                (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                                (asset "EQUITIES::UUP//USD" "UUP")
                                                                                (asset "EQUITIES::TMF//USD" "TMF")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (group "Defense | Modified" [
                                                                      (weight-equal [
                                                                        (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                                          (weight-equal [
                                                                            (filter (rsi 20) (select-bottom 1) [
                                                                              (asset "EQUITIES::SHY//USD" "SHY")
                                                                              (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                              (asset "EQUITIES::GLD//USD" "GLD")
                                                                              (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::UCO//USD" "UCO")
                                                                              (asset "EQUITIES::YCS//USD" "YCS")
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                              (weight-equal [
                                                                                (filter (moving-average-return 20) (select-bottom 1) [
                                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                                  (asset "EQUITIES::TMF//USD" "TMF")
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (filter (cumulative-return 20) (select-top 1) [
                                                                                  (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                                  (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                  (asset "EQUITIES::UCO//USD" "UCO")
                                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
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
                                                    (group "B: If long term TLT is trending down, safety: Long Term, 2 Least Volatile*" [
                                                      (weight-equal [
                                                        (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                                          (group "B.A.A: Risk Off, Rising Rates (TMV)* - LETF Basket^" [
                                                            (weight-equal [
                                                              (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                                (weight-equal [
                                                                  (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 20) (select-top 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                                        (weight-equal [
                                                                          (filter (cumulative-return 20) (select-bottom 1) [
                                                                            (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            (asset "EQUITIES::ERX//USD" "ERX")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (>= (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                                            (weight-equal [
                                                                              (filter (cumulative-return 20) (select-top 1) [
                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                (asset "EQUITIES::EPI//USD" "EPI")
                                                                                (asset "EQUITIES::TMV//USD" "TMV")
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (> (moving-average-return "EQUITIES::TMF//USD" 5) 0) [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                                    (asset "EQUITIES::TNA//USD" "TNA")
                                                                                  ])
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                                    (asset "EQUITIES::TMV//USD" "TMV")
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
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                                    (weight-equal [
                                                                      (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                            (weight-equal [
                                                                              (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                (weight-equal [
                                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                                    (asset "EQUITIES::TMV//USD" "TMV")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (< (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 5) (select-top 2) [
                                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                                    (asset "EQUITIES::TNA//USD" "TNA")
                                                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                    (asset "EQUITIES::TMV//USD" "TMV")
                                                                                  ])
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
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
                                                                    (group "Defense | Modified" [
                                                                      (weight-equal [
                                                                        (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                                          (weight-equal [
                                                                            (if (>= (standard-deviation-return "EQUITIES::DBC//USD" 10) 3) [
                                                                              (weight-equal [
                                                                                (if (<= (standard-deviation-return "EQUITIES::TMV//USD" 5) (standard-deviation-return "EQUITIES::DBC//USD" 5)) [
                                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                                ] [
                                                                                  (asset "EQUITIES::DBC//USD" "DBC")
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                                  (weight-equal [
                                                                                    (filter (moving-average-return 20) (select-top 1) [
                                                                                      (asset "EQUITIES::TMV//USD" "TMV")
                                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                      (asset "EQUITIES::SH//USD" "SH")
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (filter (cumulative-return 20) (select-bottom 1) [
                                                                                      (asset "EQUITIES::EFA//USD" "EFA")
                                                                                      (asset "EQUITIES::EEM//USD" "EEM")
                                                                                      (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                      (asset "EQUITIES::UCO//USD" "UCO")
                                                                                      (asset "EQUITIES::TMV//USD" "TMV")
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                              (weight-equal [
                                                                                (filter (moving-average-return 20) (select-bottom 1) [
                                                                                  (asset "EQUITIES::EPI//USD" "EPI")
                                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                                  (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (filter (cumulative-return 20) (select-top 1) [
                                                                                  (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                  (asset "EQUITIES::EUO//USD" "EUO")
                                                                                  (asset "EQUITIES::YCS//USD" "YCS")
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
                                                        ] [
                                                          (group "B.A.B: Risk Off, Falling Rates (TMF)* - LETF Basket" [
                                                            (weight-equal [
                                                              (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                                (weight-equal [
                                                                  (if (<= (cumulative-return "EQUITIES::SPY//USD" 1) -2) [
                                                                    (weight-equal [
                                                                      (filter (cumulative-return 20) (select-top 1) [
                                                                        (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (< (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                        (weight-equal [
                                                                          (filter (cumulative-return 20) (select-top 1) [
                                                                            (asset "EQUITIES::TMF//USD" "TMF")
                                                                            (asset "EQUITIES::TYO//USD" "TYO")
                                                                            (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 5) (select-bottom 1) [
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                                            (asset "EQUITIES::BRZU//USD" "BRZU")
                                                                            (asset "EQUITIES::TMF//USD" "TMF")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                                    (weight-equal [
                                                                      (if (> (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (exponential-moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                                        (weight-equal [
                                                                          (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                            (weight-equal [
                                                                              (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                (weight-equal [
                                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                    (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                                    (asset "EQUITIES::EPI//USD" "EPI")
                                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                    (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                                    (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                                    (asset "EQUITIES::PUI//USD" "PUI")
                                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                                    (asset "EQUITIES::TMF//USD" "TMF")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (> (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 5) (select-bottom 1) [
                                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                    (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                                    (asset "EQUITIES::EPI//USD" "EPI")
                                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                    (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                                  ])
                                                                                  (asset "EQUITIES::TMF//USD" "TMF")
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (filter (cumulative-return 20) (select-top 1) [
                                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                    (asset "EQUITIES::TMF//USD" "TMF")
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
                                                                      ] [
                                                                        (group "Unreachable" [
                                                                          (weight-specified [100 0] [
                                                                            (asset "EQUITIES::SHY//USD" "SHY")
                                                                            (filter (rsi 20) (select-bottom 1) [
                                                                              (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (group "Defense | Modified" [
                                                                      (weight-equal [
                                                                        (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                                          (weight-equal [
                                                                            (filter (rsi 20) (select-bottom 1) [
                                                                              (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                              (asset "EQUITIES::EPI//USD" "EPI")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (filter (moving-average-return 20) (select-top 1) [
                                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                              (asset "EQUITIES::SMH//USD" "SMH")
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
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
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
                        (group "V4.0.0.3 | ?? Beta Baller + Modded TCCC  | Anansi + BWC + WHSmacon + HTX" [
                          (weight-equal [
                            (if (or (> (rsi "EQUITIES::TQQQ//USD" 10) 79.0) (> (rsi "EQUITIES::XLK//USD" 10) 79.0) (> (rsi "EQUITIES::VOX//USD" 10) 79.0) (> (rsi "EQUITIES::VTV//USD" 10) 79.0)) [
                              (asset "EQUITIES::VIXM//USD" "VIXM")
                            ] [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::TQQQ//USD" 14) 30) [
                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                ] [
                                  (weight-equal [
                                    (if (< (rsi "EQUITIES::SMH//USD" 14) 30) [
                                      (asset "EQUITIES::SMH//USD" "SMH")
                                    ] [
                                      (group "Beta Baller + TCCC | Modded" [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::BIL//USD" 10) (rsi "EQUITIES::TLT//USD" 10)) [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::SPY//USD" 10) 75) [
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ] [
                                                (weight-equal [
                                                  (if (> (rsi "EQUITIES::SOXX//USD" 5) 80) [
                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                  ] [
                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ] [
                                            (weight-equal [
                                              (if (< (rsi "EQUITIES::SPY//USD" 5) 25) [
                                                (weight-equal [
                                                  (if (< (rsi "EQUITIES::BSV//USD" 10) (rsi "EQUITIES::SPHB//USD" 10)) [
                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                  ] [
                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                  ])
                                                ])
                                              ] [
                                                (group "Vegan TCCC Wrapper | Modded" [
                                                  (weight-equal [
                                                    (if (< (moving-average-return "EQUITIES::BIL//USD" 100) (moving-average-return "EQUITIES::TLT//USD" 100)) [
                                                      (weight-equal [
                                                        (if (and (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10.0) (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5)) [
                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                        ] [
                                                          (weight-equal [
                                                            (if (> (standard-deviation-return "EQUITIES::SPY//USD" 10) 3) [
                                                              (weight-equal [
                                                                (filter (rsi 5) (select-top 1) [
                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  (asset "EQUITIES::TLT//USD" "TLT")
                                                                  (asset "EQUITIES::SH//USD" "SH")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (group "Rotator - TQQQ/TLT (Top 1)" [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 15) (select-top 1) [
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::TLT//USD" "TLT")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (group "B: If long term TLT is trending down, safety: Long Term, 2 Least Volatile*" [
                                                        (weight-equal [
                                                          (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                                            (group "B.A.A: Risk Off, Rising Rates (TMV)* - LETF Basket^" [
                                                              (weight-equal [
                                                                (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 5) (select-top 1) [
                                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                                          (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                                          (weight-equal [
                                                                            (filter (cumulative-return 5) (select-bottom 1) [
                                                                              (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::ERX//USD" "ERX")
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (>= (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                                              (weight-equal [
                                                                                (filter (cumulative-return 5) (select-top 1) [
                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                  (asset "EQUITIES::EEM//USD" "EEM")
                                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (> (moving-average-return "EQUITIES::TMF//USD" 5) 0) [
                                                                                  (weight-equal [
                                                                                    (filter (moving-average-return 5) (select-bottom 1) [
                                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                                      (asset "EQUITIES::TNA//USD" "TNA")
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (filter (moving-average-return 3) (select-bottom 1) [
                                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                                      (asset "EQUITIES::TMV//USD" "TMV")
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
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                                      (weight-equal [
                                                                        (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                                          (weight-equal [
                                                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                              (weight-equal [
                                                                                (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                  (weight-equal [
                                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (filter (moving-average-return 5) (select-bottom 1) [
                                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                                      (asset "EQUITIES::TMV//USD" "TMV")
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (< (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                                                  (weight-equal [
                                                                                    (filter (moving-average-return 5) (select-top 2) [
                                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                                      (asset "EQUITIES::TNA//USD" "TNA")
                                                                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                      (asset "EQUITIES::TMV//USD" "TMV")
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
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
                                                                      (group "Defense | Modified" [
                                                                        (weight-equal [
                                                                          (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                                            (weight-equal [
                                                                              (if (>= (standard-deviation-return "EQUITIES::DBC//USD" 10) 3) [
                                                                                (weight-equal [
                                                                                  (if (<= (standard-deviation-return "EQUITIES::TMV//USD" 5) (standard-deviation-return "EQUITIES::DBC//USD" 5)) [
                                                                                    (asset "EQUITIES::TMV//USD" "TMV")
                                                                                  ] [
                                                                                    (asset "EQUITIES::DBC//USD" "DBC")
                                                                                  ])
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                                    (weight-equal [
                                                                                      (filter (moving-average-return 5) (select-top 1) [
                                                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                        (asset "EQUITIES::SH//USD" "SH")
                                                                                      ])
                                                                                    ])
                                                                                  ] [
                                                                                    (weight-equal [
                                                                                      (filter (cumulative-return 5) (select-bottom 1) [
                                                                                        (asset "EQUITIES::EFA//USD" "EFA")
                                                                                        (asset "EQUITIES::EEM//USD" "EEM")
                                                                                        (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                        (asset "EQUITIES::UCO//USD" "UCO")
                                                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                                (weight-equal [
                                                                                  (filter (moving-average-return 5) (select-bottom 1) [
                                                                                    (asset "EQUITIES::EEM//USD" "EEM")
                                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                  ])
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (filter (cumulative-return 5) (select-top 1) [
                                                                                    (asset "EQUITIES::EEM//USD" "EEM")
                                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                          ] [
                                                            (group "B.A.B: Risk Off, Falling Rates (TMF)* - LETF Basket" [
                                                              (weight-equal [
                                                                (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                                  (weight-equal [
                                                                    (if (<= (cumulative-return "EQUITIES::SPY//USD" 1) -2) [
                                                                      (weight-equal [
                                                                        (filter (cumulative-return 5) (select-top 1) [
                                                                          (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (< (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                          (weight-equal [
                                                                            (filter (cumulative-return 10) (select-top 1) [
                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                              (asset "EQUITIES::TYO//USD" "TYO")
                                                                              (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (filter (moving-average-return 5) (select-bottom 1) [
                                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                              (asset "EQUITIES::SMH//USD" "SMH")
                                                                              (asset "EQUITIES::EEM//USD" "EEM")
                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                                      (weight-equal [
                                                                        (if (> (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (exponential-moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                                          (weight-equal [
                                                                            (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                              (weight-equal [
                                                                                (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                  (weight-equal [
                                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (filter (moving-average-return 7) (select-bottom 1) [
                                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                      (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                                      (asset "EQUITIES::EEM//USD" "EEM")
                                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                      (asset "EQUITIES::EEMV//USD" "EEMV")
                                                                                      (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                                      (asset "EQUITIES::PUI//USD" "PUI")
                                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                                      (asset "EQUITIES::TMF//USD" "TMF")
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (> (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                                  (weight-equal [
                                                                                    (filter (moving-average-return 5) (select-bottom 1) [
                                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                      (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                                      (asset "EQUITIES::EEM//USD" "EEM")
                                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                      (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                                    ])
                                                                                    (asset "EQUITIES::TMF//USD" "TMF")
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (filter (cumulative-return 5) (select-top 1) [
                                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                      (asset "EQUITIES::TMF//USD" "TMF")
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
                                                                        ] [
                                                                          (group "Unreachable" [
                                                                            (weight-specified [100 0] [
                                                                              (asset "EQUITIES::SHY//USD" "SHY")
                                                                              (filter (rsi 5) (select-bottom 1) [
                                                                                (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (group "Defense | Modified" [
                                                                        (weight-equal [
                                                                          (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                                            (weight-equal [
                                                                              (filter (rsi 5) (select-bottom 1) [
                                                                                (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                                (asset "EQUITIES::EEM//USD" "EEM")
                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (filter (moving-average-return 5) (select-top 1) [
                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                                (asset "EQUITIES::SMH//USD" "SMH")
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
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
              (group "\"V3.0.4.2a\" [HTX anti-twitch]| Beta Baller + TCCC | Deez, BrianE, HinnomTX, DereckN, Garen, DJKeyhole, comrade" [
                (weight-equal [
                  (if (> (rsi "EQUITIES::SPY//USD" 10) 79) [
                    (group "Overbought S&P. Sell the rip. Buy volatility." [
                      (weight-equal [
                        (filter (rsi 20) (select-bottom 1) [
                          (asset "EQUITIES::VIXM//USD" "VIXM")
                          (asset "EQUITIES::VIXM//USD" "VIXM")
                        ])
                      ])
                    ])
                  ] [
                    (weight-equal [
                      (if (< (rsi "EQUITIES::BIL//USD" 10) (rsi "EQUITIES::TLH//USD" 10)) [
                        (weight-equal [
                          (if (<= (rsi "EQUITIES::SOXX//USD" 10) 80) [
                            (weight-equal [
                              (filter (max-drawdown 5) (select-top 1) [
                                (asset "EQUITIES::SMH//USD" "SMH")
                                (asset "EQUITIES::TYO//USD" "TYO")
                              ])
                            ])
                          ] [
                            (asset "EQUITIES::PSQ//USD" "PSQ")
                          ])
                        ])
                      ] [
                        (weight-equal [
                          (if (< (rsi "EQUITIES::SPY//USD" 6) 27) [
                            (group "Extremely oversold S&P (low RSI). Double check with bond mkt before going long" [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::BSV//USD" 7) (rsi "EQUITIES::SPHB//USD" 7)) [
                                  (weight-equal [
                                    (filter (rsi 20) (select-bottom 1) [
                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                    ])
                                  ])
                                ] [
                                  (weight-equal [
                                    (filter (rsi 20) (select-bottom 1) [
                                      (asset "EQUITIES::SMH//USD" "SMH")
                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ] [
                            (group "V0.2.1 | TCCC Stop the Bleed | DJKeyhole | 1/2 of Momentum Mean Reversion" [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                  (group "V1.2 | Five and Below | DJKeyhole | No Low Volume LETFs" [
                                    (weight-equal [
                                      (filter (rsi 10) (select-bottom 1) [
                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                        (asset "EQUITIES::SPHB//USD" "SPHB")
                                        (asset "EQUITIES::SMH//USD" "SMH")
                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                        (asset "EQUITIES::SHY//USD" "SHY")
                                      ])
                                    ])
                                  ])
                                ] [
                                  (weight-equal [
                                    (group "Bear Stock Market - High Inflation - [STRIPPED] V2.0.2b | A Better LETF Basket | DJKeyhole | BIL and TMV" [
                                      (weight-equal [
                                        (if (> (moving-average-return "EQUITIES::TLT//USD" 100) (moving-average-return "EQUITIES::BIL//USD" 100)) [
                                          (group "A.B: Medium term TLT may be overbought*" [
                                            (weight-equal [
                                              (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                                (group "A.B.B.A: Risk Off, Rising Rates (TMV)*" [
                                                  (weight-equal [
                                                    (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                      (weight-equal [
                                                        (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                          (weight-equal [
                                                            (filter (moving-average-return 20) (select-bottom 1) [
                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              (asset "EQUITIES::SMH//USD" "SMH")
                                                              (asset "EQUITIES::UPRO//USD" "UPRO")
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (<= (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::TLH//USD" 5)) [
                                                              (weight-equal [
                                                                (filter (cumulative-return 20) (select-top 1) [
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::EUO//USD" "EUO")
                                                                  (asset "EQUITIES::YCS//USD" "YCS")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (filter (moving-average-return 20) (select-bottom 1) [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                  (asset "EQUITIES::CURE//USD" "CURE")
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (group "Go Do Something Else" [
                                                        (weight-specified [50 0 50] [
                                                          (filter (moving-average-return 21) (select-bottom 1) [
                                                            (asset "EQUITIES::BTAL//USD" "BTAL")
                                                            (asset "EQUITIES::UGL//USD" "UGL")
                                                          ])
                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                            (asset "EQUITIES::TMV//USD" "TMV")
                                                          ])
                                                          (asset "EQUITIES::UUP//USD" "UUP")
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ] [
                                                (group "A.B.B.B: Risk Off, Falling Rates (TMF)*" [
                                                  (weight-equal [
                                                    (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                      (weight-equal [
                                                        (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                          (weight-equal [
                                                            (filter (moving-average-return 20) (select-bottom 1) [
                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              (asset "EQUITIES::SMH//USD" "SMH")
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                              (weight-equal [
                                                                (filter (cumulative-return 20) (select-top 1) [
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (> (cumulative-return "EQUITIES::SPY//USD" 1) 1) [
                                                                  (weight-equal [
                                                                    (filter (cumulative-return 20) (select-top 1) [
                                                                      (asset "EQUITIES::ERX//USD" "ERX")
                                                                      (asset "EQUITIES::EUO//USD" "EUO")
                                                                      (asset "EQUITIES::YCS//USD" "YCS")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 20) (select-bottom 1) [
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                      (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                      (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
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
                                                        (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                          (weight-equal [
                                                            (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                              (weight-equal [
                                                                (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 20) (select-bottom 1) [
                                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (filter (cumulative-return 20) (select-top 1) [
                                                                          (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                          (asset "EQUITIES::UUP//USD" "UUP")
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                                          (asset "EQUITIES::UCO//USD" "UCO")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 20) (select-bottom 1) [
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (filter (cumulative-return 20) (select-top 1) [
                                                                      (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                      (asset "EQUITIES::UUP//USD" "UUP")
                                                                      (asset "EQUITIES::TMF//USD" "TMF")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (group "Defense | Modified" [
                                                            (weight-equal [
                                                              (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                                (weight-equal [
                                                                  (filter (rsi 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::SHY//USD" "SHY")
                                                                    (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                    (asset "EQUITIES::GLD//USD" "GLD")
                                                                    (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::UCO//USD" "UCO")
                                                                    (asset "EQUITIES::YCS//USD" "YCS")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::TMF//USD" "TMF")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (filter (cumulative-return 20) (select-top 1) [
                                                                        (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                        (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::UCO//USD" "UCO")
                                                                        (asset "EQUITIES::YCS//USD" "YCS")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
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
                                          (group "B: If long term TLT is trending down, safety: Long Term, 2 Least Volatile*" [
                                            (weight-equal [
                                              (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                                (group "B.A.A: Risk Off, Rising Rates (TMV)* - LETF Basket^" [
                                                  (weight-equal [
                                                    (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                      (weight-equal [
                                                        (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                          (weight-equal [
                                                            (filter (moving-average-return 20) (select-top 1) [
                                                              (asset "EQUITIES::QQQ//USD" "QQQ")
                                                              (asset "EQUITIES::SMH//USD" "SMH")
                                                              (asset "EQUITIES::UPRO//USD" "UPRO")
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                              (weight-equal [
                                                                (filter (cumulative-return 20) (select-bottom 1) [
                                                                  (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::ERX//USD" "ERX")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (>= (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                                  (weight-equal [
                                                                    (filter (cumulative-return 20) (select-top 1) [
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      (asset "EQUITIES::EPI//USD" "EPI")
                                                                      (asset "EQUITIES::TMV//USD" "TMV")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (> (moving-average-return "EQUITIES::TMF//USD" 5) 0) [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 20) (select-bottom 1) [
                                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                                          (asset "EQUITIES::TNA//USD" "TNA")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 20) (select-bottom 1) [
                                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                                          (asset "EQUITIES::TMV//USD" "TMV")
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
                                                    ] [
                                                      (weight-equal [
                                                        (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                          (weight-equal [
                                                            (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                              (weight-equal [
                                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                  (weight-equal [
                                                                    (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                      (weight-equal [
                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 20) (select-bottom 1) [
                                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                                          (asset "EQUITIES::TMV//USD" "TMV")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (< (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 5) (select-top 2) [
                                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                                          (asset "EQUITIES::TNA//USD" "TNA")
                                                                          (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          (asset "EQUITIES::TMV//USD" "TMV")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
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
                                                          (group "Defense | Modified" [
                                                            (weight-equal [
                                                              (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                                (weight-equal [
                                                                  (if (>= (standard-deviation-return "EQUITIES::DBC//USD" 10) 3) [
                                                                    (weight-equal [
                                                                      (if (<= (standard-deviation-return "EQUITIES::TMV//USD" 5) (standard-deviation-return "EQUITIES::DBC//USD" 5)) [
                                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                                      ] [
                                                                        (asset "EQUITIES::DBC//USD" "DBC")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 20) (select-top 1) [
                                                                            (asset "EQUITIES::TMV//USD" "TMV")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            (asset "EQUITIES::SH//USD" "SH")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (filter (cumulative-return 20) (select-bottom 1) [
                                                                            (asset "EQUITIES::EFA//USD" "EFA")
                                                                            (asset "EQUITIES::EEM//USD" "EEM")
                                                                            (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            (asset "EQUITIES::UCO//USD" "UCO")
                                                                            (asset "EQUITIES::TMV//USD" "TMV")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                                        (asset "EQUITIES::EPI//USD" "EPI")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (filter (cumulative-return 20) (select-top 1) [
                                                                        (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::EUO//USD" "EUO")
                                                                        (asset "EQUITIES::YCS//USD" "YCS")
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
                                              ] [
                                                (group "B.A.B: Risk Off, Falling Rates (TMF)* - LETF Basket" [
                                                  (weight-equal [
                                                    (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                      (weight-equal [
                                                        (if (<= (cumulative-return "EQUITIES::SPY//USD" 1) -2) [
                                                          (weight-equal [
                                                            (filter (cumulative-return 20) (select-top 1) [
                                                              (asset "EQUITIES::SPXS//USD" "SPXS")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (< (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                              (weight-equal [
                                                                (filter (cumulative-return 20) (select-top 1) [
                                                                  (asset "EQUITIES::TMF//USD" "TMF")
                                                                  (asset "EQUITIES::TYO//USD" "TYO")
                                                                  (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (filter (moving-average-return 5) (select-bottom 1) [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                                  (asset "EQUITIES::BRZU//USD" "BRZU")
                                                                  (asset "EQUITIES::TMF//USD" "TMF")
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                          (weight-equal [
                                                            (if (> (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (exponential-moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                              (weight-equal [
                                                                (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                  (weight-equal [
                                                                    (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                      (weight-equal [
                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 20) (select-bottom 1) [
                                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                          (asset "EQUITIES::EPI//USD" "EPI")
                                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                                          (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          (asset "EQUITIES::EWZ//USD" "EWZ")
                                                                          (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                          (asset "EQUITIES::PUI//USD" "PUI")
                                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (> (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 5) (select-bottom 1) [
                                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                          (asset "EQUITIES::EPI//USD" "EPI")
                                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                                          (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                          (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                        ])
                                                                        (asset "EQUITIES::TMF//USD" "TMF")
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (filter (cumulative-return 20) (select-top 1) [
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
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
                                                            ] [
                                                              (group "Unreachable" [
                                                                (weight-specified [100 0] [
                                                                  (asset "EQUITIES::SHY//USD" "SHY")
                                                                  (filter (rsi 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (group "Defense | Modified" [
                                                            (weight-equal [
                                                              (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                                (weight-equal [
                                                                  (filter (rsi 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                    (asset "EQUITIES::EPI//USD" "EPI")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 20) (select-top 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
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
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
              (group "V3.0.4.5 | ?? Beta Baller + TCCC | Anansi Clean Up | 2011-10-04" [
                (weight-equal [
                  (if (> (rsi "EQUITIES::SOXL//USD" 8) (rsi "EQUITIES::UPRO//USD" 9)) [
                    (group "V3.0.4.5 | ?? Beta Baller + TCCC | Cleaned Up | 2011-10-04" [
                      (weight-equal [
                        (if (< (rsi "EQUITIES::BIL//USD" 10) (rsi "EQUITIES::TLH//USD" 10)) [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::SPY//USD" 6) 75) [
                              (asset "EQUITIES::VIXM//USD" "VIXM")
                            ] [
                              (weight-equal [
                                (if (<= (rsi "EQUITIES::SOXL//USD" 5) 75) [
                                  (asset "EQUITIES::SMH//USD" "SMH")
                                ] [
                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                ])
                              ])
                            ])
                          ])
                        ] [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::SPY//USD" 6) 27) [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::BSV//USD" 7) (rsi "EQUITIES::SPHB//USD" 7)) [
                                  (weight-equal [
                                    (filter (rsi 20) (select-bottom 1) [
                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                    ])
                                  ])
                                ] [
                                  (weight-equal [
                                    (filter (rsi 20) (select-bottom 1) [
                                      (asset "EQUITIES::SMH//USD" "SMH")
                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                      (asset "EQUITIES::TMF//USD" "TMF")
                                    ])
                                  ])
                                ])
                              ])
                            ] [
                              (group "V0.2.1 | TCCC ? | Version A" [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::UVXY//USD" 10) 74) [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::UVXY//USD" 10) 84) [
                                        (asset "EQUITIES::SMH//USD" "SMH")
                                      ] [
                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                      ])
                                    ])
                                  ] [
                                    (weight-equal [
                                      (if (> (moving-average-return "EQUITIES::SPTL//USD" 100) (moving-average-return "EQUITIES::BIL//USD" 100)) [
                                        (weight-equal [
                                          (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                            (group "A.B.B.A: Rising Rates (BIL)" [
                                              (weight-equal [
                                                (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                      (group "TQQQ/SOXL/UPRO (5d MAR B1)" [
                                                        (weight-equal [
                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (<= (cumulative-return "EQUITIES::SPXU//USD" 6) (cumulative-return "EQUITIES::UPRO//USD" 3)) [
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                        ] [
                                                          (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                            (weight-equal [
                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
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
                                                    (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                    ] [
                                                      (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                        (weight-equal [
                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
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
                                            (group "A.B.B.B: Falling Rates (TMF)" [
                                              (weight-equal [
                                                (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                      (group "TQQQ/SOXL/UPRO (5d MAR B1)" [
                                                        (weight-equal [
                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                          (weight-equal [
                                                            (filter (cumulative-return 20) (select-top 1) [
                                                              (asset "EQUITIES::SH//USD" "SH")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                            ])
                                                          ])
                                                        ] [
                                                          (asset "EQUITIES::ERX//USD" "ERX")
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                        ] [
                                                          (weight-equal [
                                                            (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                              (weight-equal [
                                                                (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                      (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (filter (cumulative-return 20) (select-top 1) [
                                                                          (asset "EQUITIES::UUP//USD" "UUP")
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                                          (asset "EQUITIES::UCO//USD" "UCO")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                  (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (filter (cumulative-return 20) (select-top 1) [
                                                                      (asset "EQUITIES::UUP//USD" "UUP")
                                                                      (asset "EQUITIES::TMF//USD" "TMF")
                                                                      (asset "EQUITIES::EEM//USD" "EEM")
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
                                                        (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                          (weight-equal [
                                                            (filter (rsi 20) (select-bottom 1) [
                                                              (asset "EQUITIES::SHY//USD" "SHY")
                                                              (asset "EQUITIES::GLD//USD" "GLD")
                                                              (asset "EQUITIES::SH//USD" "SH")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::UCO//USD" "UCO")
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                              (group "TQQQ/SOXL/UPRO/TMF (5d MAR B1)" [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                    (asset "EQUITIES::TMF//USD" "TMF")
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (filter (cumulative-return 20) (select-top 1) [
                                                                  (asset "EQUITIES::SH//USD" "SH")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::UCO//USD" "UCO")
                                                                ])
                                                              ])
                                                            ])
                                                          ])
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
                                          (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                            (group "B.A.A: Rising Rates (TMV)" [
                                              (weight-equal [
                                                (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                      (group "TQQQ/SOXL/UPRO (5d MAR T1)" [
                                                        (weight-equal [
                                                          (filter (moving-average-return 20) (select-top 1) [
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                          (weight-equal [
                                                            (filter (cumulative-return 20) (select-bottom 1) [
                                                              (asset "EQUITIES::SH//USD" "SH")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::ERX//USD" "ERX")
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (>= (cumulative-return "EQUITIES::SPXU//USD" 5) (cumulative-return "EQUITIES::UPRO//USD" 4)) [
                                                              (weight-equal [
                                                                (filter (cumulative-return 20) (select-top 1) [
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::EEM//USD" "EEM")
                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (>= (cumulative-return "EQUITIES::BIL//USD" 3) (cumulative-return "EQUITIES::TMV//USD" 3)) [
                                                                  (group "TQQQ/SOXL/TNA (5d MAR B1)" [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::TNA//USD" "TNA")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (group "TQQQ/SOXL/UPRO/TMV (3d MAR B1)" [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 3) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
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
                                                ] [
                                                  (weight-equal [
                                                    (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                        ] [
                                                          (weight-equal [
                                                            (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                              (weight-equal [
                                                                (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                ] [
                                                                  (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                  (group "TQQQ/SOXL/UPRO/TMV (5d MAR T1)" [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 20) (select-top 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (group "TQQQ/SOXL (20d MAR B1)" [
                                                                    (weight-equal [
                                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SMH//USD" "SMH")
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
                                                        (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                          (weight-equal [
                                                            (if (>= (standard-deviation-return "EQUITIES::DBC//USD" 10) 3) [
                                                              (weight-equal [
                                                                (if (<= (standard-deviation-return "EQUITIES::TMV//USD" 5) (standard-deviation-return "EQUITIES::DBC//USD" 5)) [
                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                ] [
                                                                  (asset "EQUITIES::UCO//USD" "UCO")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 20) (select-top 1) [
                                                                      (asset "EQUITIES::TMV//USD" "TMV")
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      (asset "EQUITIES::SH//USD" "SH")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (filter (cumulative-return 20) (select-bottom 1) [
                                                                      (asset "EQUITIES::EEM//USD" "EEM")
                                                                      (asset "EQUITIES::SH//USD" "SH")
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      (asset "EQUITIES::UCO//USD" "UCO")
                                                                      (asset "EQUITIES::TMV//USD" "TMV")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                              (group "TQQQ/SOXL/UPRO (5d MAR B1)" [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (filter (cumulative-return 20) (select-top 1) [
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::EEM//USD" "EEM")
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
                                          ] [
                                            (group "B.A.B: Falling Rates (TMF)" [
                                              (weight-equal [
                                                (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                  (weight-equal [
                                                    (if (<= (cumulative-return "EQUITIES::SPY//USD" 1) -2) [
                                                      (weight-equal [
                                                        (filter (cumulative-return 20) (select-top 1) [
                                                          (asset "EQUITIES::SH//USD" "SH")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (>= (cumulative-return "EQUITIES::SPXU//USD" 6) (cumulative-return "EQUITIES::UPRO//USD" 3)) [
                                                          (weight-equal [
                                                            (filter (cumulative-return 20) (select-top 1) [
                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                              (asset "EQUITIES::SH//USD" "SH")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                            ])
                                                          ])
                                                        ] [
                                                          (group "TQQQ/SOXL/UPRO/EEM/TMF (5d MAR B1)" [
                                                            (weight-equal [
                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                (asset "EQUITIES::EEM//USD" "EEM")
                                                                (asset "EQUITIES::TMF//USD" "TMF")
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
                                                      (weight-equal [
                                                        (if (> (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (exponential-moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                          (weight-equal [
                                                            (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                  (weight-equal [
                                                                    (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                    ] [
                                                                      (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                      (group "TQQQ/SOXL/UPRO/TNA (5d MAR B1)" [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                            (asset "EQUITIES::TNA//USD" "TNA")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (filter (cumulative-return 20) (select-top 1) [
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
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
                                                            (filter (rsi 20) (select-bottom 1) [
                                                              (asset "EQUITIES::SH//USD" "SH")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                          (weight-equal [
                                                            (filter (rsi 20) (select-bottom 1) [
                                                              (asset "EQUITIES::SH//USD" "SH")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::EEM//USD" "EEM")
                                                            ])
                                                          ])
                                                        ] [
                                                          (group "TQQQ/SOXL/UPRO/TMF (5d MAR T1)" [
                                                            (weight-equal [
                                                              (filter (moving-average-return 20) (select-top 1) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
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
                                            ])
                                          ])
                                        ])
                                      ])
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
                    (group "V3.0.4e | ?? Beta Baller + TCCC | Cleaned Up | 2011-10-04" [
                      (weight-equal [
                        (if (< (rsi "EQUITIES::BIL//USD" 42) (rsi "EQUITIES::IEF//USD" 70)) [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::SPY//USD" 7) 75) [
                              (asset "EQUITIES::VIXM//USD" "VIXM")
                            ] [
                              (weight-equal [
                                (if (> (current-price "EQUITIES::SOXL//USD" 5) (moving-average-return "EQUITIES::SOXL//USD" 2)) [
                                  (weight-equal [
                                    (filter (moving-average-return 20) (select-top 1) [
                                      (asset "EQUITIES::SMH//USD" "SMH")
                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                    ])
                                  ])
                                ] [
                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                ])
                              ])
                            ])
                          ])
                        ] [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::SPY//USD" 6) 27) [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::BSV//USD" 8) (rsi "EQUITIES::SPHB//USD" 8)) [
                                  (weight-equal [
                                    (filter (rsi 20) (select-bottom 1) [
                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                    ])
                                  ])
                                ] [
                                  (weight-equal [
                                    (filter (rsi 20) (select-bottom 1) [
                                      (asset "EQUITIES::SMH//USD" "SMH")
                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                      (asset "EQUITIES::TMF//USD" "TMF")
                                    ])
                                  ])
                                ])
                              ])
                            ] [
                              (group "V0.2.1 | TCCC ?" [
                                (weight-equal [
                                  (if (> (current-price "EQUITIES::TLT//USD" 10) (moving-average-price "EQUITIES::TLT//USD" 200)) [
                                    (weight-equal [
                                      (if (> (moving-average-return "EQUITIES::TLT//USD" 20) 0) [
                                        (group "A.B.B.B: Falling Rates (BIL)" [
                                          (weight-equal [
                                            (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                              (weight-equal [
                                                (if (>= (cumulative-return "EQUITIES::SPXU//USD" 5) (cumulative-return "EQUITIES::UPRO//USD" 4)) [
                                                  (asset "EQUITIES::ERX//USD" "ERX")
                                                ] [
                                                  (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                    (weight-equal [
                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ] [
                                              (weight-equal [
                                                (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                  (weight-equal [
                                                    (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                    ] [
                                                      (weight-equal [
                                                        (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                          (weight-equal [
                                                            (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                            ] [
                                                              (group "7d BIL vs 7d IEF RSI" [
                                                                (weight-equal [
                                                                  (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                    (group "TQQQ/SOXL/UPRO (5d MAR B1)" [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 20) (select-bottom 1) [
                                                                          (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                                          (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (filter (cumulative-return 20) (select-top 1) [
                                                                        (asset "EQUITIES::UUP//USD" "UUP")
                                                                        (asset "EQUITIES::TMF//USD" "TMF")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (group "7d BIL vs 7d IEF RSI" [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                (group "TQQQ/SOXL/UPRO (5d MAR B1)" [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 20) (select-bottom 1) [
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
                                                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (filter (cumulative-return 20) (select-top 1) [
                                                                    (asset "EQUITIES::UUP//USD" "UUP")
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
                                                ] [
                                                  (weight-equal [
                                                    (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                      (weight-equal [
                                                        (filter (rsi 20) (select-bottom 1) [
                                                          (asset "EQUITIES::SHY//USD" "SHY")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::UCO//USD" "UCO")
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                          (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                            (weight-equal [
                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (filter (cumulative-return 20) (select-top 1) [
                                                              (asset "EQUITIES::SH//USD" "SH")
                                                              (asset "EQUITIES::UCO//USD" "UCO")
                                                            ])
                                                          ])
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
                                        (group "A.B.B.A: Rising Rates (TMV)" [
                                          (weight-equal [
                                            (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                              (weight-equal [
                                                (if (>= (cumulative-return "EQUITIES::SPXU//USD" 6) (cumulative-return "EQUITIES::UPRO//USD" 3)) [
                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                ] [
                                                  (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                    (weight-equal [
                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ] [
                                              (weight-equal [
                                                (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                ] [
                                                  (group "TQQQ/SOXL/UPRO/TMV (5d MAR B1)" [
                                                    (weight-equal [
                                                      (filter (moving-average-return 20) (select-bottom 1) [
                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                        (asset "EQUITIES::SMH//USD" "SMH")
                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
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
                                  ] [
                                    (weight-equal [
                                      (if (> (moving-average-return "EQUITIES::TLT//USD" 20) 0) [
                                        (group "B.A.B: Falling Rates (TMF)" [
                                          (weight-equal [
                                            (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                              (weight-equal [
                                                (if (<= (cumulative-return "EQUITIES::SPY//USD" 1) -2) [
                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                ] [
                                                  (weight-equal [
                                                    (if (>= (cumulative-return "EQUITIES::SPXU//USD" 6) (cumulative-return "EQUITIES::UPRO//USD" 3)) [
                                                      (asset "EQUITIES::AGG//USD" "AGG")
                                                    ] [
                                                      (group "TQQQ/SOXL/UPRO/EEM/TMF (5d MAR B1)" [
                                                        (weight-equal [
                                                          (filter (moving-average-return 20) (select-bottom 1) [
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                            (asset "EQUITIES::EEM//USD" "EEM")
                                                            (asset "EQUITIES::TMF//USD" "TMF")
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
                                                  (weight-equal [
                                                    (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                    ] [
                                                      (weight-equal [
                                                        (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                          (weight-equal [
                                                            (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                            ] [
                                                              (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                              (group "TQQQ/SOXL/UPRO/BIL (5d MAR B1)" [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                  ])
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (filter (cumulative-return 20) (select-top 1) [
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  (asset "EQUITIES::TMF//USD" "TMF")
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
                                                    (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                      (weight-equal [
                                                        (filter (rsi 20) (select-bottom 1) [
                                                          (asset "EQUITIES::SH//USD" "SH")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                        ])
                                                      ])
                                                    ] [
                                                      (group "TQQQ/SOXL/UPRO/BIL (5d MAR T1)" [
                                                        (weight-equal [
                                                          (filter (moving-average-return 20) (select-top 1) [
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
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
                                      ] [
                                        (group "B.A.A: Rising Rates (TMV)" [
                                          (weight-equal [
                                            (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                              (weight-equal [
                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                  (asset "EQUITIES::SMH//USD" "SMH")
                                                ] [
                                                  (weight-equal [
                                                    (if (<= (cumulative-return "EQUITIES::SPY//USD" 2) -2) [
                                                      (weight-equal [
                                                        (filter (cumulative-return 20) (select-bottom 1) [
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                          (asset "EQUITIES::BIL//USD" "BIL")
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (>= (cumulative-return "EQUITIES::SPXU//USD" 6) (cumulative-return "EQUITIES::UPRO//USD" 3)) [
                                                          (weight-equal [
                                                            (filter (cumulative-return 20) (select-top 1) [
                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              (asset "EQUITIES::EEM//USD" "EEM")
                                                            ])
                                                          ])
                                                        ] [
                                                          (group "TQQQ/SOXL/TMV (5d MAR B1)" [
                                                            (weight-equal [
                                                              (filter (moving-average-return 20) (select-bottom 1) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::SMH//USD" "SMH")
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
                                            ] [
                                              (weight-equal [
                                                (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                  (weight-equal [
                                                    (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                    ] [
                                                      (weight-equal [
                                                        (if (and (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10.0) (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5)) [
                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                        ] [
                                                          (group "SOXL/UPRO (22d MAR B1)" [
                                                            (weight-equal [
                                                              (filter (moving-average-return 22) (select-bottom 1) [
                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (if (and (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) (>= (standard-deviation-return "EQUITIES::DBC//USD" 10) 3.0)) [
                                                      (weight-equal [
                                                        (if (<= (standard-deviation-return "EQUITIES::TMV//USD" 5) (standard-deviation-return "EQUITIES::DBC//USD" 5)) [
                                                          (asset "EQUITIES::TMV//USD" "TMV")
                                                        ] [
                                                          (asset "EQUITIES::UCO//USD" "UCO")
                                                        ])
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (filter (cumulative-return 20) (select-top 1) [
                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
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
              (group "V4.0.0.3 | ?? Beta Baller + Modded TCCC  | Anansi + BWC + WHSmacon + HTX" [
                (weight-equal [
                  (if (or (> (rsi "EQUITIES::TQQQ//USD" 10) 79.0) (> (rsi "EQUITIES::XLK//USD" 10) 79.0) (> (rsi "EQUITIES::VOX//USD" 10) 79.0) (> (rsi "EQUITIES::VTV//USD" 10) 79.0)) [
                    (asset "EQUITIES::VIXM//USD" "VIXM")
                  ] [
                    (weight-equal [
                      (if (< (rsi "EQUITIES::TQQQ//USD" 14) 30) [
                        (asset "EQUITIES::QQQ//USD" "QQQ")
                      ] [
                        (weight-equal [
                          (if (< (rsi "EQUITIES::SMH//USD" 14) 30) [
                            (asset "EQUITIES::SMH//USD" "SMH")
                          ] [
                            (group "Beta Baller + TCCC | Modded" [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::BIL//USD" 10) (rsi "EQUITIES::TLT//USD" 10)) [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::SPY//USD" 10) 75) [
                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                    ] [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::SOXX//USD" 5) 80) [
                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                        ] [
                                          (asset "EQUITIES::SMH//USD" "SMH")
                                        ])
                                      ])
                                    ])
                                  ])
                                ] [
                                  (weight-equal [
                                    (if (< (rsi "EQUITIES::SPY//USD" 5) 25) [
                                      (weight-equal [
                                        (if (< (rsi "EQUITIES::BSV//USD" 10) (rsi "EQUITIES::SPHB//USD" 10)) [
                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                        ] [
                                          (asset "EQUITIES::SMH//USD" "SMH")
                                        ])
                                      ])
                                    ] [
                                      (group "Vegan TCCC Wrapper | Modded" [
                                        (weight-equal [
                                          (if (< (moving-average-return "EQUITIES::BIL//USD" 100) (moving-average-return "EQUITIES::TLT//USD" 100)) [
                                            (weight-equal [
                                              (if (and (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10.0) (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5)) [
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ] [
                                                (weight-equal [
                                                  (if (> (standard-deviation-return "EQUITIES::SPY//USD" 10) 3) [
                                                    (weight-equal [
                                                      (filter (rsi 5) (select-top 1) [
                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                        (asset "EQUITIES::TLT//USD" "TLT")
                                                        (asset "EQUITIES::SH//USD" "SH")
                                                      ])
                                                    ])
                                                  ] [
                                                    (weight-equal [
                                                      (group "Rotator - TQQQ/TLT (Top 1)" [
                                                        (weight-equal [
                                                          (filter (moving-average-return 15) (select-top 1) [
                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                            (asset "EQUITIES::TLT//USD" "TLT")
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ] [
                                            (group "B: If long term TLT is trending down, safety: Long Term, 2 Least Volatile*" [
                                              (weight-equal [
                                                (if (< (moving-average-return "EQUITIES::SPTL//USD" 20) 0) [
                                                  (group "B.A.A: Risk Off, Rising Rates (TMV)* - LETF Basket^" [
                                                    (weight-equal [
                                                      (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                        (weight-equal [
                                                          (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                            (weight-equal [
                                                              (filter (moving-average-return 5) (select-top 1) [
                                                                (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                (asset "EQUITIES::SMH//USD" "SMH")
                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (if (>= (cumulative-return "EQUITIES::UUP//USD" 2) 1) [
                                                                (weight-equal [
                                                                  (filter (cumulative-return 5) (select-bottom 1) [
                                                                    (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    (asset "EQUITIES::ERX//USD" "ERX")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (>= (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                                    (weight-equal [
                                                                      (filter (cumulative-return 5) (select-top 1) [
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                        (asset "EQUITIES::EEM//USD" "EEM")
                                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (moving-average-return "EQUITIES::TMF//USD" 5) 0) [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 5) (select-bottom 1) [
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                                            (asset "EQUITIES::TNA//USD" "TNA")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 3) (select-bottom 1) [
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                                            (asset "EQUITIES::TMV//USD" "TMV")
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
                                                      ] [
                                                        (weight-equal [
                                                          (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::TQQQ//USD" 11) 77) [
                                                                (weight-equal [
                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                    (weight-equal [
                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 5) (select-bottom 1) [
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                                            (asset "EQUITIES::TMV//USD" "TMV")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (< (moving-average-return "EQUITIES::SH//USD" 5) (moving-average-return "EQUITIES::STIP//USD" 5)) [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 5) (select-top 2) [
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                                            (asset "EQUITIES::TNA//USD" "TNA")
                                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::TMV//USD" "TMV")
                                                                          ])
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
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
                                                            (group "Defense | Modified" [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                                  (weight-equal [
                                                                    (if (>= (standard-deviation-return "EQUITIES::DBC//USD" 10) 3) [
                                                                      (weight-equal [
                                                                        (if (<= (standard-deviation-return "EQUITIES::TMV//USD" 5) (standard-deviation-return "EQUITIES::DBC//USD" 5)) [
                                                                          (asset "EQUITIES::TMV//USD" "TMV")
                                                                        ] [
                                                                          (asset "EQUITIES::DBC//USD" "DBC")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                          (weight-equal [
                                                                            (filter (moving-average-return 5) (select-top 1) [
                                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::SH//USD" "SH")
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (filter (cumulative-return 5) (select-bottom 1) [
                                                                              (asset "EQUITIES::EFA//USD" "EFA")
                                                                              (asset "EQUITIES::EEM//USD" "EEM")
                                                                              (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                              (asset "EQUITIES::UCO//USD" "UCO")
                                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::BIL//USD" 7) (rsi "EQUITIES::IEF//USD" 7)) [
                                                                      (weight-equal [
                                                                        (filter (moving-average-return 5) (select-bottom 1) [
                                                                          (asset "EQUITIES::EEM//USD" "EEM")
                                                                          (asset "EQUITIES::SMH//USD" "SMH")
                                                                          (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (filter (cumulative-return 5) (select-top 1) [
                                                                          (asset "EQUITIES::EEM//USD" "EEM")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          (asset "EQUITIES::PSQ//USD" "PSQ")
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
                                                ] [
                                                  (group "B.A.B: Risk Off, Falling Rates (TMF)* - LETF Basket" [
                                                    (weight-equal [
                                                      (if (<= (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                        (weight-equal [
                                                          (if (<= (cumulative-return "EQUITIES::SPY//USD" 1) -2) [
                                                            (weight-equal [
                                                              (filter (cumulative-return 5) (select-top 1) [
                                                                (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (if (< (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                (weight-equal [
                                                                  (filter (cumulative-return 10) (select-top 1) [
                                                                    (asset "EQUITIES::TMF//USD" "TMF")
                                                                    (asset "EQUITIES::TYO//USD" "TYO")
                                                                    (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (filter (moving-average-return 5) (select-bottom 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SMH//USD" "SMH")
                                                                    (asset "EQUITIES::EEM//USD" "EEM")
                                                                    (asset "EQUITIES::TMF//USD" "TMF")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ] [
                                                        (weight-equal [
                                                          (if (> (moving-average-return "EQUITIES::SPY//USD" 210) (moving-average-return "EQUITIES::DBC//USD" 360)) [
                                                            (weight-equal [
                                                              (if (> (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (exponential-moving-average-price "EQUITIES::SPY//USD" 360)) [
                                                                (weight-equal [
                                                                  (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -10) [
                                                                    (weight-equal [
                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 7) (select-bottom 1) [
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                            (asset "EQUITIES::EEM//USD" "EEM")
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::EEMV//USD" "EEMV")
                                                                            (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                            (asset "EQUITIES::PUI//USD" "PUI")
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                                            (asset "EQUITIES::TMF//USD" "TMF")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (moving-average-return "EQUITIES::IEF//USD" 10) (moving-average-return "EQUITIES::SH//USD" 10)) [
                                                                        (weight-equal [
                                                                          (filter (moving-average-return 5) (select-bottom 1) [
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                            (asset "EQUITIES::SPHB//USD" "SPHB")
                                                                            (asset "EQUITIES::EEM//USD" "EEM")
                                                                            (asset "EQUITIES::SMH//USD" "SMH")
                                                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                            (asset "EQUITIES::UMDD//USD" "UMDD")
                                                                          ])
                                                                          (asset "EQUITIES::TMF//USD" "TMF")
                                                                        ])
                                                                      ] [
                                                                        (weight-equal [
                                                                          (filter (cumulative-return 5) (select-top 1) [
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                            (asset "EQUITIES::TMF//USD" "TMF")
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
                                                              ] [
                                                                (group "Unreachable" [
                                                                  (weight-specified [100 0] [
                                                                    (asset "EQUITIES::SHY//USD" "SHY")
                                                                    (filter (rsi 5) (select-bottom 1) [
                                                                      (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ] [
                                                            (group "Defense | Modified" [
                                                              (weight-equal [
                                                                (if (> (standard-deviation-return "EQUITIES::DBC//USD" 20) (standard-deviation-return "EQUITIES::SPY//USD" 20)) [
                                                                  (weight-equal [
                                                                    (filter (rsi 5) (select-bottom 1) [
                                                                      (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                      (asset "EQUITIES::EEM//USD" "EEM")
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (filter (moving-average-return 5) (select-top 1) [
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::SMH//USD" "SMH")
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
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
              (group "Base 2 - FTLT or Bull or Bonds (UVXY)" [
                (weight-equal [
                  (if (or (or (> (rsi "EQUITIES::QQQE//USD" 10) 79.0) (> (rsi "EQUITIES::VTV//USD" 10) 79.0) (> (rsi "EQUITIES::VOX//USD" 10) 79.0) (> (rsi "EQUITIES::TECL//USD" 10) 79.0) (> (rsi "EQUITIES::VOOG//USD" 10) 79.0) (> (rsi "EQUITIES::VOOV//USD" 10) 79.0)) (> (rsi "EQUITIES::XLP//USD" 10) 75.0)) [
                    (group "Group" [
                      (weight-specified {"VIXM" 90 "PSQ" 10} [
                        (asset "EQUITIES::VIXM//USD" "VIXM")
                        (asset "EQUITIES::PSQ//USD" "PSQ")
                      ])
                    ])
                  ] [
                    (weight-equal [
                      (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                        (weight-equal [
                          (group "Group" [
                            (weight-specified {"VIXM" 90 "PSQ" 10} [
                              (asset "EQUITIES::VIXM//USD" "VIXM")
                              (asset "EQUITIES::PSQ//USD" "PSQ")
                            ])
                          ])
                        ])
                      ] [
                        (weight-equal [
                          (if (or (> (rsi "EQUITIES::XLY//USD" 10) 80.0) (> (rsi "EQUITIES::FAS//USD" 10) 80.0) (> (rsi "EQUITIES::SPY//USD" 10) 80.0)) [
                            (group "Group" [
                              (weight-specified {"VIXM" 90 "PSQ" 10} [
                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                (asset "EQUITIES::PSQ//USD" "PSQ")
                              ])
                            ])
                          ] [
                            (weight-equal [
                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -12) [
                                (weight-equal [
                                  (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                    (weight-equal [
                                      (group "Group" [
                                        (weight-specified {"VIXM" 90 "PSQ" 10} [
                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                          (asset "EQUITIES::PSQ//USD" "PSQ")
                                        ])
                                      ])
                                    ])
                                  ] [
                                    (weight-equal [
                                      (group "FTLT or Safety Town" [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                          ] [
                                            (weight-equal [
                                              (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                                (asset "EQUITIES::SMH//USD" "SMH")
                                              ] [
                                                (weight-equal [
                                                  (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                                    (asset "EQUITIES::SPHB//USD" "SPHB")
                                                  ] [
                                                    (weight-equal [
                                                      (group "Bull or Safety Town - Base 2" [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::SPY//USD" 126) (rsi "EQUITIES::XLU//USD" 126)) [
                                                            (weight-equal [
                                                              (group "Bull (Commodities?)" [
                                                                (weight-equal [
                                                                  (if (< (rsi "EQUITIES::XLK//USD" 126) (rsi "EQUITIES::DBC//USD" 126)) [
                                                                    (weight-equal [
                                                                      (filter (cumulative-return 20) (select-top 1) [
                                                                        (asset "EQUITIES::ERX//USD" "ERX")
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (weight-equal [
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::TLT//USD" 126) 50) [
                                                                (weight-equal [
                                                                  (group "TECL (18.3-13.7)" [
                                                                    (weight-equal [
                                                                      (if (< (rsi "EQUITIES::TECL//USD" 21) (rsi "EQUITIES::AGG//USD" 21)) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ] [
                                                                        (weight-equal [
                                                                          (group "Safety Town l AR 41.9% DD 11.5% B -0.11" [
                                                                            (weight-equal [
                                                                              (if (>= (rsi "EQUITIES::SPY//USD" 10) 70.0) [
                                                                                (weight-equal [
                                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (if (> (rsi "EQUITIES::SPY//USD" 126) (rsi "EQUITIES::XLU//USD" 126)) [
                                                                                    (weight-equal [
                                                                                      (group "A" [
                                                                                        (weight-equal [
                                                                                          (filter (standard-deviation-price 20) (select-top 2) [
                                                                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                            (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                      (group "B" [
                                                                                        (weight-equal [
                                                                                          (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                          (group "VIXM & BTAL" [
                                                                                            (weight-equal [
                                                                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ] [
                                                                                    (weight-equal [
                                                                                      (group "A" [
                                                                                        (weight-equal [
                                                                                          (filter (standard-deviation-price 20) (select-top 2) [
                                                                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                            (asset "EQUITIES::VIXM//USD" "VIXM")
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
                                                              ] [
                                                                (weight-equal [
                                                                  (group "TMF or USDU" [
                                                                    (weight-equal [
                                                                      (filter (rsi 20) (select-bottom 1) [
                                                                        (asset "EQUITIES::TMF//USD" "TMF")
                                                                        (asset "EQUITIES::USDU//USD" "USDU")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
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
                                  (group "FTLT or Safety Town" [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                      ] [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                            (asset "EQUITIES::SMH//USD" "SMH")
                                          ] [
                                            (weight-equal [
                                              (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                                (asset "EQUITIES::SPHB//USD" "SPHB")
                                              ] [
                                                (weight-equal [
                                                  (group "Bull or Safety Town - Base 2" [
                                                    (weight-equal [
                                                      (if (> (rsi "EQUITIES::SPY//USD" 126) (rsi "EQUITIES::XLU//USD" 126)) [
                                                        (weight-equal [
                                                          (group "Bull (Commodities?)" [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::XLK//USD" 126) (rsi "EQUITIES::DBC//USD" 126)) [
                                                                (weight-equal [
                                                                  (filter (cumulative-return 20) (select-top 1) [
                                                                    (asset "EQUITIES::ERX//USD" "ERX")
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ] [
                                                        (weight-equal [
                                                          (if (< (rsi "EQUITIES::TLT//USD" 126) 50) [
                                                            (weight-equal [
                                                              (group "TECL (18.3-13.7)" [
                                                                (weight-equal [
                                                                  (if (< (rsi "EQUITIES::TECL//USD" 21) (rsi "EQUITIES::AGG//USD" 21)) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (group "Safety Town l AR 41.9% DD 11.5% B -0.11" [
                                                                        (weight-equal [
                                                                          (if (>= (rsi "EQUITIES::SPY//USD" 10) 70.0) [
                                                                            (weight-equal [
                                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (if (> (rsi "EQUITIES::SPY//USD" 126) (rsi "EQUITIES::XLU//USD" 126)) [
                                                                                (weight-equal [
                                                                                  (group "A" [
                                                                                    (weight-equal [
                                                                                      (filter (standard-deviation-price 20) (select-top 2) [
                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                        (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                  (group "B" [
                                                                                    (weight-equal [
                                                                                      (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                      (group "VIXM & BTAL" [
                                                                                        (weight-equal [
                                                                                          (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (group "A" [
                                                                                    (weight-equal [
                                                                                      (filter (standard-deviation-price 20) (select-top 2) [
                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
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
                                                          ] [
                                                            (weight-equal [
                                                              (group "TMF or USDU" [
                                                                (weight-equal [
                                                                  (filter (rsi 20) (select-bottom 1) [
                                                                    (asset "EQUITIES::TMF//USD" "TMF")
                                                                    (asset "EQUITIES::USDU//USD" "USDU")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
              (group "KMLM switcher (single pops)| BT 4/13/22 = A.R. 466% / D.D. 22%" [
                (weight-equal [
                  (if (or (or (> (rsi "EQUITIES::QQQE//USD" 10) 79.0) (> (rsi "EQUITIES::VTV//USD" 10) 79.0) (> (rsi "EQUITIES::VOX//USD" 10) 79.0) (> (rsi "EQUITIES::TECL//USD" 10) 79.0) (> (rsi "EQUITIES::VOOG//USD" 10) 79.0) (> (rsi "EQUITIES::VOOV//USD" 10) 79.0)) (> (rsi "EQUITIES::XLP//USD" 10) 75.0)) [
                    (asset "EQUITIES::VIXM//USD" "VIXM")
                  ] [
                    (weight-equal [
                      (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                        (weight-equal [
                          (asset "EQUITIES::VIXM//USD" "VIXM")
                        ])
                      ] [
                        (weight-equal [
                          (if (or (> (rsi "EQUITIES::XLY//USD" 10) 80.0) (> (rsi "EQUITIES::FAS//USD" 10) 80.0) (> (rsi "EQUITIES::SPY//USD" 10) 80.0)) [
                            (asset "EQUITIES::VIXM//USD" "VIXM")
                          ] [
                            (weight-equal [
                              (group "Single Popped KMLM" [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::UVXY//USD" 21) 65) [
                                    (weight-equal [
                                      (group "BSC" [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::SPY//USD" 21) 30) [
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ] [
                                            (asset "EQUITIES::SPHB//USD" "SPHB")
                                          ])
                                        ])
                                      ])
                                    ])
                                  ] [
                                    (weight-equal [
                                      (group "Combined Pop Bot" [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                          ] [
                                            (weight-equal [
                                              (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                                (asset "EQUITIES::SMH//USD" "SMH")
                                              ] [
                                                (weight-equal [
                                                  (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                                    (asset "EQUITIES::SPHB//USD" "SPHB")
                                                  ] [
                                                    (weight-equal [
                                                      (group "Copypasta YOLO GainZs Here" [
                                                        (weight-equal [
                                                          (group "KMLM switcher: TECL, SVIX, or L/S Rotator | BT 4/13/22 = AR 164% / DD 22.2%" [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::XLK//USD" 10) (rsi "EQUITIES::KMLM//USD" 10)) [
                                                                (weight-equal [
                                                                  (filter (rsi 10) (select-bottom 1) [
                                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                    (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                  ])
                                                                ])
                                                              ] [
                                                                (group "Long/Short Rotator with FTLS KMLM SSO UUP | BT 12/10/20 | 15.1/3.5  " [
                                                                  (weight-equal [
                                                                    (filter (standard-deviation-return 6) (select-bottom 3) [
                                                                      (asset "EQUITIES::TMV//USD" "TMV")
                                                                      (asset "EQUITIES::TMF//USD" "TMF")
                                                                      (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                      (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                      (asset "EQUITIES::FTLS//USD" "FTLS")
                                                                      (asset "EQUITIES::KMLM//USD" "KMLM")
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
                    ])
                  ])
                ])
              ])
            ])
          ])
        ])
      ])
    ])
  ])
