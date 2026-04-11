defsymphony "Sisyphus V0.0 (291,7,2022) (Invest Copy)" {:rebalance-frequency :daily}
  (weight-equal [
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
                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                      (weight-equal [
                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                      ])
                    ] [
                      (weight-equal [
                        (if (< (rsi "EQUITIES::UPRO//USD" 10) 31) [
                          (weight-equal [
                            (asset "EQUITIES::UPRO//USD" "UPRO")
                          ])
                        ] [
                          (asset "EQUITIES::BOND//USD" "BOND")
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
            (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
              (weight-equal [
                (asset "EQUITIES::BIL//USD" "BIL")
              ])
            ] [
              (weight-equal [
                (if (< (rsi "EQUITIES::UPRO//USD" 10) 31) [
                  (weight-equal [
                    (asset "EQUITIES::BIL//USD" "BIL")
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
    (group "HWRT 3 (225,19,2022)" [
      (weight-equal [
        (if (> (rsi "EQUITIES::UVXY//USD" 21) 65) [
          (weight-equal [
            (group "BSC 1" [
              (weight-equal [
                (if (> (rsi "EQUITIES::SPY//USD" 21) 30) [
                  (asset "EQUITIES::VIXM//USD" "VIXM")
                ] [
                  (asset "EQUITIES::SPXL//USD" "SPXL")
                ])
              ])
            ])
            (group "BSC 2" [
              (weight-equal [
                (if (> (rsi "EQUITIES::UVXY//USD" 10) 74) [
                  (weight-equal [
                    (if (< (rsi "EQUITIES::UVXY//USD" 10) 84) [
                      (asset "EQUITIES::UVXY//USD" "UVXY")
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
        ] [
          (weight-equal [
            (group "High Win Rates + Anansi's Scale-in" [
              (weight-equal [
                (if (> (rsi "EQUITIES::IOO//USD" 10) 80) [
                  (group "Scale-In | VIX+ -> VIX++" [
                    (weight-equal [
                      (if (> (rsi "EQUITIES::IOO//USD" 10) 82.5) [
                        (group "VIX Blend++" [
                          (weight-equal [
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ])
                        ])
                      ] [
                        (group "VIX Blend+" [
                          (weight-equal [
                            (asset "EQUITIES::VIXY//USD" "VIXY")
                          ])
                        ])
                      ])
                    ])
                  ])
                ] [
                  (weight-equal [
                    (if (> (rsi "EQUITIES::TQQQ//USD" 10) 81) [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::UVXY//USD" 60) 40) [
                          (asset "EQUITIES::UVXY//USD" "UVXY")
                        ] [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::RETL//USD" 10) 82) [
                              (group "Scale-In | BTAL -> VIX" [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::RETL//USD" 10) 85) [
                                    (group "VIX Blend" [
                                      (weight-equal [
                                        (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                          ])
                                        ])
                                      ] [
                                        (group "VIX Blend" [
                                          (weight-equal [
                                            (asset "EQUITIES::VIXY//USD" "VIXY")
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
                              (asset "EQUITIES::UVXY//USD" "UVXY")
                            ] [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::RETL//USD" 10) 82) [
                                  (group "Scale-In | BTAL -> VIX" [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::RETL//USD" 10) 85) [
                                        (group "VIX Blend" [
                                          (weight-equal [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                              ])
                                            ])
                                          ] [
                                            (group "VIX Blend" [
                                              (weight-equal [
                                                (asset "EQUITIES::VIXY//USD" "VIXY")
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
                                            (if (> (rsi "EQUITIES::RETL//USD" 10) 82) [
                                              (group "Scale-In | BTAL -> VIX" [
                                                (weight-equal [
                                                  (if (> (rsi "EQUITIES::RETL//USD" 10) 85) [
                                                    (group "VIX Blend" [
                                                      (weight-equal [
                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                          ])
                                                        ])
                                                      ] [
                                                        (group "VIX Blend" [
                                                          (weight-equal [
                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                      (group "VIX Blend++" [
                                                        (weight-equal [
                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                  ])
                                                                ])
                                                              ] [
                                                                (group "VIX Blend+" [
                                                                  (weight-equal [
                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                      ])
                                                                    ])
                                                                  ] [
                                                                    (group "VIX Blend+" [
                                                                      (weight-equal [
                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (> (rsi "EQUITIES::XLP//USD" 10) 77) [
                                                                      (group "VIX Blend" [
                                                                        (weight-equal [
                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (> (rsi "EQUITIES::XLF//USD" 10) 81) [
                                                                          (group "VIX Blend" [
                                                                            (weight-equal [
                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
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
                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                      ] [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::QQQ//USD" 14) 80) [
                                                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                          ] [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::QQQ//USD" 5) 90) [
                                                                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                              ] [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::QQQ//USD" 3) 95) [
                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                                (if (> (cumulative-return "EQUITIES::VIXY//USD" 9) 20) [
                                                                                  (group "High VIX" [
                                                                                    (weight-equal [
                                                                                      (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                                        (weight-equal [
                                                                                          (if (> (rsi "EQUITIES::UVXY//USD" 21) 65) [
                                                                                            (weight-equal [
                                                                                              (group "BSC 31 RSI" [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::SPY//USD" 10) 31) [
                                                                                                    (weight-equal [
                                                                                                      (if (> (max-drawdown "EQUITIES::SVXY//USD" 5) 15) [
                                                                                                        (group "UVIX Volatility" [
                                                                                                          (weight-specified {"UVIX" 10 "BTAL" 90} [
                                                                                                            (asset "EQUITIES::UVIX//USD" "UVIX")
                                                                                                            (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                          ])
                                                                                                        ])
                                                                                                      ] [
                                                                                                        (group "UVXY Volatility" [
                                                                                                          (weight-specified [10 30 60] [
                                                                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                            (group "VIX Mix" [
                                                                                                              (weight-equal [
                                                                                                                (filter (moving-average-return 10) (select-bottom 2) [
                                                                                                                  (asset "EQUITIES::SOXS//USD" "SOXS")
                                                                                                                  (asset "EQUITIES::TECS//USD" "TECS")
                                                                                                                  (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                                                                                                  (asset "EQUITIES::OILD//USD" "OILD")
                                                                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                                  (asset "EQUITIES::FAZ//USD" "FAZ")
                                                                                                                  (asset "EQUITIES::DRV//USD" "DRV")
                                                                                                                  (asset "EQUITIES::EDZ//USD" "EDZ")
                                                                                                                  (asset "EQUITIES::DXD//USD" "DXD")
                                                                                                                  (asset "EQUITIES::SPXS//USD" "SPXS")
                                                                                                                  (asset "EQUITIES::SDOW//USD" "SDOW")
                                                                                                                  (asset "EQUITIES::FNGD//USD" "FNGD")
                                                                                                                ])
                                                                                                              ])
                                                                                                            ])
                                                                                                            (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ] [
                                                                                                    (group "SVXY" [
                                                                                                      (weight-equal [
                                                                                                        (if (> (max-drawdown "EQUITIES::SVXY//USD" 3) 20) [
                                                                                                          (group "Volmageddon Protection" [
                                                                                                            (weight-equal [
                                                                                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                              (asset "EQUITIES::USMV//USD" "USMV")
                                                                                                              (group "SVIX/SVXY" [
                                                                                                                (weight-equal [
                                                                                                                  (if (> (cumulative-return "EQUITIES::SVXY//USD" 1) 5) [
                                                                                                                    (asset "EQUITIES::SVIX//USD" "SVIX")
                                                                                                                  ] [
                                                                                                                    (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ])
                                                                                                            ])
                                                                                                          ])
                                                                                                        ] [
                                                                                                          (weight-equal [
                                                                                                            (if (> (cumulative-return "EQUITIES::VIXY//USD" 5) 45) [
                                                                                                              (asset "EQUITIES::SVIX//USD" "SVIX")
                                                                                                            ] [
                                                                                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                              (group "Inverse VIX Mix" [
                                                                                                                (weight-equal [
                                                                                                                  (filter (moving-average-return 10) (select-bottom 2) [
                                                                                                                    (asset "EQUITIES::QLD//USD" "QLD")
                                                                                                                    (asset "EQUITIES::UYG//USD" "UYG")
                                                                                                                    (asset "EQUITIES::SAA//USD" "SAA")
                                                                                                                    (asset "EQUITIES::EFO//USD" "EFO")
                                                                                                                    (asset "EQUITIES::SSO//USD" "SSO")
                                                                                                                    (asset "EQUITIES::UDOW//USD" "UDOW")
                                                                                                                    (asset "EQUITIES::UWM//USD" "UWM")
                                                                                                                    (asset "EQUITIES::ROM//USD" "ROM")
                                                                                                                    (asset "EQUITIES::ERX//USD" "ERX")
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ])
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
                                                                                              (group "SVXY" [
                                                                                                (weight-equal [
                                                                                                  (if (> (max-drawdown "EQUITIES::SVXY//USD" 3) 20) [
                                                                                                    (group "Volmageddon Protection" [
                                                                                                      (weight-equal [
                                                                                                        (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                        (asset "EQUITIES::USMV//USD" "USMV")
                                                                                                        (group "SVIX/SVXY" [
                                                                                                          (weight-equal [
                                                                                                            (if (> (cumulative-return "EQUITIES::SVXY//USD" 1) 5) [
                                                                                                              (asset "EQUITIES::SVIX//USD" "SVIX")
                                                                                                            ] [
                                                                                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (if (> (cumulative-return "EQUITIES::VIXY//USD" 5) 45) [
                                                                                                        (asset "EQUITIES::SVIX//USD" "SVIX")
                                                                                                      ] [
                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                        (group "Inverse VIX Mix" [
                                                                                                          (weight-equal [
                                                                                                            (filter (moving-average-return 10) (select-bottom 2) [
                                                                                                              (asset "EQUITIES::QLD//USD" "QLD")
                                                                                                              (asset "EQUITIES::UYG//USD" "UYG")
                                                                                                              (asset "EQUITIES::SAA//USD" "SAA")
                                                                                                              (asset "EQUITIES::EFO//USD" "EFO")
                                                                                                              (asset "EQUITIES::SSO//USD" "SSO")
                                                                                                              (asset "EQUITIES::UDOW//USD" "UDOW")
                                                                                                              (asset "EQUITIES::UWM//USD" "UWM")
                                                                                                              (asset "EQUITIES::ROM//USD" "ROM")
                                                                                                              (asset "EQUITIES::ERX//USD" "ERX")
                                                                                                            ])
                                                                                                          ])
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
                                                                                            (weight-equal [
                                                                                              (if (> (cumulative-return "EQUITIES::VIXY//USD" 10) 25) [
                                                                                                (group "Volmageddon Protection" [
                                                                                                  (weight-equal [
                                                                                                    (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                    (asset "EQUITIES::USMV//USD" "USMV")
                                                                                                  ])
                                                                                                ])
                                                                                              ] [
                                                                                                (group "Inverse VIX Mix" [
                                                                                                  (weight-equal [
                                                                                                    (filter (moving-average-return 10) (select-bottom 2) [
                                                                                                      (asset "EQUITIES::QLD//USD" "QLD")
                                                                                                      (asset "EQUITIES::UYG//USD" "UYG")
                                                                                                      (asset "EQUITIES::SAA//USD" "SAA")
                                                                                                      (asset "EQUITIES::EFO//USD" "EFO")
                                                                                                      (asset "EQUITIES::SSO//USD" "SSO")
                                                                                                      (asset "EQUITIES::UDOW//USD" "UDOW")
                                                                                                      (asset "EQUITIES::UWM//USD" "UWM")
                                                                                                      (asset "EQUITIES::ROM//USD" "ROM")
                                                                                                      (asset "EQUITIES::ERX//USD" "ERX")
                                                                                                    ])
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
                                                                                                            (group "EM Emerging Markets V0.4 (114,69,2009)" [
                                                                                                              (weight-equal [
                                                                                                                (if (< (rsi "EQUITIES::EEM//USD" 15) 30) [
                                                                                                                  (asset "EQUITIES::EDC//USD" "EDC")
                                                                                                                ] [
                                                                                                                  (weight-equal [
                                                                                                                    (if (> (current-price "EQUITIES::SHV//USD" 10) (moving-average-price "EQUITIES::SHV//USD" 50)) [
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
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ] [
                                                                                                                      (group "IGIB vs SPY" [
                                                                                                                        (weight-equal [
                                                                                                                          (if (> (rsi "EQUITIES::IGIB//USD" 10) (rsi "EQUITIES::SPY//USD" 10)) [
                                                                                                                            (asset "EQUITIES::EEM//USD" "EEM")
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
                                                                                                            (group "QQQ FTLT SMA V0.1 - (183,39,2011)" [
                                                                                                              (weight-equal [
                                                                                                                (group "QQQ FTLT SMA V0.1 - (183,39,2011)" [
                                                                                                                  (weight-equal [
                                                                                                                    (group "Over bought" [
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
                                                                                                                                        (if (> (rsi "EQUITIES::XLK//USD" 10) 79) [
                                                                                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                        ] [
                                                                                                                                          (weight-equal [
                                                                                                                                            (if (> (rsi "EQUITIES::XLP//USD" 10) 75) [
                                                                                                                                              (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                                                                                            ] [
                                                                                                                                              (weight-equal [
                                                                                                                                                (if (> (rsi "EQUITIES::XLF//USD" 10) 80) [
                                                                                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                                ] [
                                                                                                                                                  (group "Vol Check" [
                                                                                                                                                    (weight-equal [
                                                                                                                                                      (if (> (rsi "EQUITIES::UVXY//USD" 21) 65) [
                                                                                                                                                        (weight-equal [
                                                                                                                                                          (group "BSC" [
                                                                                                                                                            (weight-equal [
                                                                                                                                                              (if (> (rsi "EQUITIES::SPY//USD" 21) 30) [
                                                                                                                                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                                                                              ] [
                                                                                                                                                                (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                                                                              ])
                                                                                                                                                            ])
                                                                                                                                                          ])
                                                                                                                                                        ])
                                                                                                                                                      ] [
                                                                                                                                                        (group "Vix Low" [
                                                                                                                                                          (weight-equal [
                                                                                                                                                            (if (< (rsi "EQUITIES::SOXX//USD" 10) 30) [
                                                                                                                                                              (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                                            ] [
                                                                                                                                                              (weight-equal [
                                                                                                                                                                (if (< (rsi "EQUITIES::QQQ//USD" 10) 30) [
                                                                                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                                ] [
                                                                                                                                                                  (weight-equal [
                                                                                                                                                                    (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                                                                                                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                                                                                                    ] [
                                                                                                                                                                      (weight-equal [
                                                                                                                                                                        (if (> (rsi "EQUITIES::SPY//USD" 70) 60) [
                                                                                                                                                                          (weight-equal [
                                                                                                                                                                            (filter (rsi 10) (select-bottom 1) [
                                                                                                                                                                              (asset "EQUITIES::UGE//USD" "UGE")
                                                                                                                                                                              (asset "EQUITIES::BOND//USD" "BOND")
                                                                                                                                                                            ])
                                                                                                                                                                          ])
                                                                                                                                                                        ] [
                                                                                                                                                                          (weight-equal [
                                                                                                                                                                            (if (< (cumulative-return "EQUITIES::QQQ//USD" 5) -5) [
                                                                                                                                                                              (group "Oversold" [
                                                                                                                                                                                (weight-equal [
                                                                                                                                                                                  (if (< (rsi "EQUITIES::SPY//USD" 10) 35) [
                                                                                                                                                                                    (weight-equal [
                                                                                                                                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                                                                    ])
                                                                                                                                                                                  ] [
                                                                                                                                                                                    (weight-equal [
                                                                                                                                                                                      (filter (rsi 10) (select-bottom 1) [
                                                                                                                                                                                        (asset "EQUITIES::UGE//USD" "UGE")
                                                                                                                                                                                        (asset "EQUITIES::BOND//USD" "BOND")
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
                                                                                                                                                                                      (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 30)) [
                                                                                                                                                                                        (weight-equal [
                                                                                                                                                                                          (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                                                                        ])
                                                                                                                                                                                      ] [
                                                                                                                                                                                        (weight-equal [
                                                                                                                                                                                          (if (> (cumulative-return "EQUITIES::QQQ//USD" 20) (moving-average-return "EQUITIES::QQQ//USD" 10)) [
                                                                                                                                                                                            (weight-equal [
                                                                                                                                                                                              (filter (rsi 10) (select-bottom 1) [
                                                                                                                                                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                                                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                                                                              ])
                                                                                                                                                                                            ])
                                                                                                                                                                                          ] [
                                                                                                                                                                                            (weight-equal [
                                                                                                                                                                                              (filter (rsi 10) (select-bottom 1) [
                                                                                                                                                                                                (asset "EQUITIES::UGE//USD" "UGE")
                                                                                                                                                                                                (asset "EQUITIES::BOND//USD" "BOND")
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
                                                                                                                                                                                      (filter (rsi 10) (select-bottom 1) [
                                                                                                                                                                                        (asset "EQUITIES::UGE//USD" "UGE")
                                                                                                                                                                                        (asset "EQUITIES::BOND//USD" "BOND")
                                                                                                                                                                                      ])
                                                                                                                                                                                    ])
                                                                                                                                                                                  ])
                                                                                                                                                                                ])
                                                                                                                                                                              ])
                                                                                                                                                                            ])
                                                                                                                                                                          ])
                                                                                                                                                                        ])
                                                                                                                                                                      ])
                                                                                                                                                                    ])
                                                                                                                                                                  ])
                                                                                                                                                                ])
                                                                                                                                                              ])
                                                                                                                                                            ])
                                                                                                                                                          ])
                                                                                                                                                        ])
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ])
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ])
                                                                                                            ])
                                                                                                            (group "QQQ FTLT Bonds - V0.5 - (237,33,2011)" [
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
                                                                                                                                (if (> (rsi "EQUITIES::XLK//USD" 10) 79) [
                                                                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                ] [
                                                                                                                                  (weight-equal [
                                                                                                                                    (if (> (rsi "EQUITIES::XLP//USD" 10) 75) [
                                                                                                                                      (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                                                                                    ] [
                                                                                                                                      (weight-equal [
                                                                                                                                        (if (> (rsi "EQUITIES::XLF//USD" 10) 80) [
                                                                                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                        ] [
                                                                                                                                          (group "Vol Check" [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (rsi "EQUITIES::UVXY//USD" 21) 65) [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (group "BSC" [
                                                                                                                                                    (weight-equal [
                                                                                                                                                      (if (> (rsi "EQUITIES::SPY//USD" 21) 30) [
                                                                                                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                                                                      ] [
                                                                                                                                                        (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ] [
                                                                                                                                                (group "Vix Low" [
                                                                                                                                                  (weight-equal [
                                                                                                                                                    (if (< (rsi "EQUITIES::SOXX//USD" 10) 30) [
                                                                                                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                                    ] [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (if (< (rsi "EQUITIES::QQQ//USD" 10) 30) [
                                                                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                        ] [
                                                                                                                                                          (weight-equal [
                                                                                                                                                            (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                                                                                                                              (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                                                                                            ] [
                                                                                                                                                              (weight-equal [
                                                                                                                                                                (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                                                                                                                  (group "20d AGG vs 60d SH" [
                                                                                                                                                                    (weight-equal [
                                                                                                                                                                      (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                                                                                        (weight-equal [
                                                                                                                                                                          (if (> (moving-average-return "EQUITIES::SPY//USD" 15) (moving-average-return "EQUITIES::SPY//USD" 30)) [
                                                                                                                                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                                                          ] [
                                                                                                                                                                            (weight-equal [
                                                                                                                                                                              (filter (rsi 10) (select-bottom 1) [
                                                                                                                                                                                (asset "EQUITIES::UGE//USD" "UGE")
                                                                                                                                                                                (asset "EQUITIES::BOND//USD" "BOND")
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
                                                                                                                                                                    (if (< (cumulative-return "EQUITIES::QQQ//USD" 60) -12) [
                                                                                                                                                                      (weight-equal [
                                                                                                                                                                        (filter (rsi 10) (select-bottom 1) [
                                                                                                                                                                          (asset "EQUITIES::UGE//USD" "UGE")
                                                                                                                                                                          (asset "EQUITIES::BOND//USD" "BOND")
                                                                                                                                                                        ])
                                                                                                                                                                      ])
                                                                                                                                                                    ] [
                                                                                                                                                                      (weight-equal [
                                                                                                                                                                        (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                                                                                                                          (weight-equal [
                                                                                                                                                                            (if (< (rsi "EQUITIES::PSQ//USD" 10) 35) [
                                                                                                                                                                              (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                                                                                                            ] [
                                                                                                                                                                              (group "20d AGG vs 60d SH" [
                                                                                                                                                                                (weight-equal [
                                                                                                                                                                                  (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                                                                                                                                    (weight-equal [
                                                                                                                                                                                      (if (> (moving-average-return "EQUITIES::SPY//USD" 15) (moving-average-return "EQUITIES::SPY//USD" 30)) [
                                                                                                                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                                                                      ] [
                                                                                                                                                                                        (weight-equal [
                                                                                                                                                                                          (filter (rsi 10) (select-bottom 1) [
                                                                                                                                                                                            (asset "EQUITIES::UGE//USD" "UGE")
                                                                                                                                                                                            (asset "EQUITIES::BOND//USD" "BOND")
                                                                                                                                                                                          ])
                                                                                                                                                                                        ])
                                                                                                                                                                                      ])
                                                                                                                                                                                    ])
                                                                                                                                                                                  ] [
                                                                                                                                                                                    (weight-equal [
                                                                                                                                                                                      (filter (rsi 10) (select-bottom 1) [
                                                                                                                                                                                        (asset "EQUITIES::UGE//USD" "UGE")
                                                                                                                                                                                        (asset "EQUITIES::BOND//USD" "BOND")
                                                                                                                                                                                      ])
                                                                                                                                                                                    ])
                                                                                                                                                                                  ])
                                                                                                                                                                                ])
                                                                                                                                                                              ])
                                                                                                                                                                            ])
                                                                                                                                                                          ])
                                                                                                                                                                        ] [
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
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
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
                                                                                        (group "Bonds Zoop V0.0 (144,38,2011)" [
                                                                                          (weight-equal [
                                                                                            (weight-equal [
                                                                                              (if (> (current-price "EQUITIES::TLT//USD" 10) (moving-average-price "EQUITIES::TLT//USD" 200)) [
                                                                                                (weight-equal [
                                                                                                  (if (> (rsi "EQUITIES::QLD//USD" 10) 79) [
                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (if (< (rsi "EQUITIES::TMF//USD" 10) 32) [
                                                                                                        (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (if (< (rsi "EQUITIES::BIL//USD" 30) (rsi "EQUITIES::TLT//USD" 20)) [
                                                                                                            (weight-equal [
                                                                                                              (if (< (exponential-moving-average-price "EQUITIES::TMF//USD" 8) (moving-average-price "EQUITIES::TMF//USD" 10)) [
                                                                                                                (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                              ] [
                                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                              ])
                                                                                                            ])
                                                                                                          ] [
                                                                                                            (weight-equal [
                                                                                                              (if (< (rsi "EQUITIES::QLD//USD" 10) 31) [
                                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
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
                                                                                                (weight-equal [
                                                                                                  (if (< (rsi "EQUITIES::TMF//USD" 10) 32) [
                                                                                                    (asset "EQUITIES::TMF//USD" "TMF")
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
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
        ])
      ])
    ])
    (group "Four Corners (66,35,2011)" [
      (weight-equal [
        (if (> (rsi "EQUITIES::FAS//USD" 10) 79.5) [
          (group "UVXY  ->  UVIX" [
            (weight-equal [
              (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                (asset "EQUITIES::UVIX//USD" "UVIX")
              ] [
                (asset "EQUITIES::UVXY//USD" "UVXY")
              ])
            ])
          ])
        ] [
          (weight-equal [
            (if (> (rsi "EQUITIES::IOO//USD" 10) 80) [
              (group "UVXY  ->  UVIX" [
                (weight-equal [
                  (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                    (asset "EQUITIES::UVIX//USD" "UVIX")
                  ] [
                    (asset "EQUITIES::UVXY//USD" "UVXY")
                  ])
                ])
              ])
            ] [
              (weight-equal [
                (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                  (group "Scale-In | VIX+ -> VIX++" [
                    (weight-equal [
                      (if (> (rsi "EQUITIES::SPY//USD" 10) 82.5) [
                        (asset "EQUITIES::UVIX//USD" "UVIX")
                      ] [
                        (group "UVXY  ->  UVIX" [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                              (asset "EQUITIES::UVIX//USD" "UVIX")
                            ] [
                              (asset "EQUITIES::UVXY//USD" "UVXY")
                            ])
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
                            (asset "EQUITIES::UVIX//USD" "UVIX")
                          ] [
                            (group "UVXY  ->  UVIX" [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                  (asset "EQUITIES::UVIX//USD" "UVIX")
                                ] [
                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ] [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::XLP//USD" 10) 77) [
                          (group "Scale-In | VIX -> VIX+" [
                            (weight-equal [
                              (if (> (rsi "EQUITIES::XLP//USD" 10) 85) [
                                (asset "EQUITIES::UVIX//USD" "UVIX")
                              ] [
                                (group "UVXY  ->  UVIX" [
                                  (weight-equal [
                                    (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                      (asset "EQUITIES::UVIX//USD" "UVIX")
                                    ] [
                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ] [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::VTV//USD" 10) 79) [
                              (group "Scale-In | VIX -> VIX+" [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::VTV//USD" 10) 85) [
                                    (asset "EQUITIES::UVIX//USD" "UVIX")
                                  ] [
                                    (group "UVXY  ->  UVIX" [
                                      (weight-equal [
                                        (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                          (asset "EQUITIES::UVIX//USD" "UVIX")
                                        ] [
                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                        ])
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
                                        (group "UVXY  ->  UVIX" [
                                          (weight-equal [
                                            (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                              (asset "EQUITIES::UVIX//USD" "UVIX")
                                            ] [
                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                            ])
                                          ])
                                        ])
                                      ] [
                                        (group "UVXY  ->  UVIX" [
                                          (weight-equal [
                                            (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                              (asset "EQUITIES::UVIX//USD" "UVIX")
                                            ] [
                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ] [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::VOX//USD" 10) 79) [
                                      (group "Scale-In | BTAL -> VIX" [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::VOX//USD" 10) 85) [
                                            (asset "EQUITIES::UVIX//USD" "UVIX")
                                          ] [
                                            (group "UVXY  ->  UVIX" [
                                              (weight-equal [
                                                (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                                  (asset "EQUITIES::UVIX//USD" "UVIX")
                                                ] [
                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ] [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::CURE//USD" 10) 82) [
                                          (group "Scale-In | BTAL -> VIX" [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::CURE//USD" 10) 85) [
                                                (group "UVXY  ->  UVIX" [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                                      (asset "EQUITIES::UVIX//USD" "UVIX")
                                                    ] [
                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                    ])
                                                  ])
                                                ])
                                              ] [
                                                (group "UVXY  ->  UVIX" [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                                      (asset "EQUITIES::UVIX//USD" "UVIX")
                                                    ] [
                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ] [
                                          (weight-equal [
                                            (if (> (rsi "EQUITIES::RETL//USD" 10) 82) [
                                              (group "Scale-In | BTAL -> VIX" [
                                                (weight-equal [
                                                  (if (> (rsi "EQUITIES::RETL//USD" 10) 85) [
                                                    (group "UVXY  ->  UVIX" [
                                                      (weight-equal [
                                                        (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                                          (asset "EQUITIES::UVIX//USD" "UVIX")
                                                        ] [
                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                        ])
                                                      ])
                                                    ])
                                                  ] [
                                                    (group "UVXY  ->  UVIX" [
                                                      (weight-equal [
                                                        (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                                          (asset "EQUITIES::UVIX//USD" "UVIX")
                                                        ] [
                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ] [
                                              (weight-equal [
                                                (if (> (rsi "EQUITIES::XLY//USD" 10) 82) [
                                                  (group "UVXY  ->  UVIX" [
                                                    (weight-equal [
                                                      (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                                        (asset "EQUITIES::UVIX//USD" "UVIX")
                                                      ] [
                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                      ])
                                                    ])
                                                  ])
                                                ] [
                                                  (group "Vol Check" [
                                                    (weight-equal [
                                                      (if (> (rsi "EQUITIES::UVXY//USD" 21) 65) [
                                                        (weight-equal [
                                                          (group "BSC" [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::SPY//USD" 21) 30) [
                                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                                              ] [
                                                                (asset "EQUITIES::SPXL//USD" "SPXL")
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ] [
                                                        (group "Oversold Checks " [
                                                          (weight-equal [
                                                            (if (< (rsi "EQUITIES::SOXL//USD" 10) 25) [
                                                              (weight-equal [
                                                                (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                ] [
                                                                  (asset "EQUITIES::BIL//USD" "BIL")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 25) [
                                                                  (weight-equal [
                                                                    (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                    ] [
                                                                      (asset "EQUITIES::BIL//USD" "BIL")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 28) [
                                                                      (weight-equal [
                                                                        (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                          (weight-equal [
                                                                            (filter (rsi 10) (select-bottom 2) [
                                                                              (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                              (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                              (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (asset "EQUITIES::BIL//USD" "BIL")
                                                                        ])
                                                                      ])
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::TECL//USD" 14) 25) [
                                                                          (weight-equal [
                                                                            (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                            ] [
                                                                              (asset "EQUITIES::BIL//USD" "BIL")
                                                                            ])
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::UPRO//USD" 10) 25) [
                                                                              (weight-equal [
                                                                                (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                                  (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                ] [
                                                                                  (asset "EQUITIES::BIL//USD" "BIL")
                                                                                ])
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (if (> (rsi "EQUITIES::QQQ//USD" 120) (rsi "EQUITIES::VPU//USD" 120)) [
                                                                                  (weight-equal [
                                                                                    (if (> (cumulative-return "EQUITIES::CORP//USD" 60) (cumulative-return "EQUITIES::BIL//USD" 60)) [
                                                                                      (group "Bull" [
                                                                                        (weight-equal [
                                                                                          (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (group "Mild Bull" [
                                                                                        (weight-equal [
                                                                                          (group "QQQ or PSQ" [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::IEF//USD" 7) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              ] [
                                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                          (asset "EQUITIES::BIL//USD" "BIL")
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ] [
                                                                                  (weight-equal [
                                                                                    (if (> (cumulative-return "EQUITIES::CORP//USD" 60) (cumulative-return "EQUITIES::BIL//USD" 60)) [
                                                                                      (group "Mild Bear" [
                                                                                        (weight-equal [
                                                                                          (group "QQQ or TLT" [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::XLK//USD" 7) (rsi "EQUITIES::WTMF//USD" 20)) [
                                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                              ] [
                                                                                                (asset "EQUITIES::TLT//USD" "TLT")
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (group "Bear" [
                                                                                        (weight-equal [
                                                                                          (group "TLT or PSQ" [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::IEF//USD" 7) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                                                                (asset "EQUITIES::TLT//USD" "TLT")
                                                                                              ] [
                                                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                          (group "Utilities vs Gold" [
                                                                                            (weight-equal [
                                                                                              (filter (rsi 60) (select-bottom 1) [
                                                                                                (asset "EQUITIES::XLU//USD" "XLU")
                                                                                                (asset "EQUITIES::GLD//USD" "GLD")
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
        ])
      ])
    ])
    (group "Better KMLM (1042,35,2022)" [
      (weight-equal [
        (if (> (rsi "EQUITIES::FAS//USD" 10) 79.5) [
          (group "UVXY  ->  UVIX" [
            (weight-equal [
              (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                (asset "EQUITIES::UVIX//USD" "UVIX")
              ] [
                (asset "EQUITIES::UVXY//USD" "UVXY")
              ])
            ])
          ])
        ] [
          (weight-equal [
            (if (> (rsi "EQUITIES::IOO//USD" 10) 80) [
              (group "UVXY  ->  UVIX" [
                (weight-equal [
                  (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                    (asset "EQUITIES::UVIX//USD" "UVIX")
                  ] [
                    (asset "EQUITIES::UVXY//USD" "UVXY")
                  ])
                ])
              ])
            ] [
              (weight-equal [
                (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                  (group "Scale-In | VIX+ -> VIX++" [
                    (weight-equal [
                      (if (> (rsi "EQUITIES::SPY//USD" 10) 82.5) [
                        (asset "EQUITIES::UVIX//USD" "UVIX")
                      ] [
                        (group "UVXY  ->  UVIX" [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                              (asset "EQUITIES::UVIX//USD" "UVIX")
                            ] [
                              (asset "EQUITIES::UVXY//USD" "UVXY")
                            ])
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
                            (asset "EQUITIES::UVIX//USD" "UVIX")
                          ] [
                            (group "UVXY  ->  UVIX" [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                  (asset "EQUITIES::UVIX//USD" "UVIX")
                                ] [
                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ] [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::XLP//USD" 10) 77) [
                          (group "Scale-In | VIX -> VIX+" [
                            (weight-equal [
                              (if (> (rsi "EQUITIES::XLP//USD" 10) 85) [
                                (asset "EQUITIES::UVIX//USD" "UVIX")
                              ] [
                                (group "UVXY  ->  UVIX" [
                                  (weight-equal [
                                    (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                      (asset "EQUITIES::UVIX//USD" "UVIX")
                                    ] [
                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ] [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::VTV//USD" 10) 79) [
                              (group "Scale-In | VIX -> VIX+" [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::VTV//USD" 10) 85) [
                                    (asset "EQUITIES::UVIX//USD" "UVIX")
                                  ] [
                                    (group "UVXY  ->  UVIX" [
                                      (weight-equal [
                                        (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                          (asset "EQUITIES::UVIX//USD" "UVIX")
                                        ] [
                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                        ])
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
                                        (group "UVXY  ->  UVIX" [
                                          (weight-equal [
                                            (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                              (asset "EQUITIES::UVIX//USD" "UVIX")
                                            ] [
                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                            ])
                                          ])
                                        ])
                                      ] [
                                        (group "UVXY  ->  UVIX" [
                                          (weight-equal [
                                            (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                              (asset "EQUITIES::UVIX//USD" "UVIX")
                                            ] [
                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ] [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::VOX//USD" 10) 79) [
                                      (group "Scale-In | BTAL -> VIX" [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::VOX//USD" 10) 85) [
                                            (asset "EQUITIES::UVIX//USD" "UVIX")
                                          ] [
                                            (group "UVXY  ->  UVIX" [
                                              (weight-equal [
                                                (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                                  (asset "EQUITIES::UVIX//USD" "UVIX")
                                                ] [
                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ] [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::CURE//USD" 10) 82) [
                                          (group "Scale-In | BTAL -> VIX" [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::CURE//USD" 10) 85) [
                                                (group "UVXY  ->  UVIX" [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                                      (asset "EQUITIES::UVIX//USD" "UVIX")
                                                    ] [
                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                    ])
                                                  ])
                                                ])
                                              ] [
                                                (group "UVXY  ->  UVIX" [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                                      (asset "EQUITIES::UVIX//USD" "UVIX")
                                                    ] [
                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ] [
                                          (weight-equal [
                                            (if (> (rsi "EQUITIES::RETL//USD" 10) 82) [
                                              (group "Scale-In | BTAL -> VIX" [
                                                (weight-equal [
                                                  (if (> (rsi "EQUITIES::RETL//USD" 10) 85) [
                                                    (group "UVXY  ->  UVIX" [
                                                      (weight-equal [
                                                        (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                                          (asset "EQUITIES::UVIX//USD" "UVIX")
                                                        ] [
                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                        ])
                                                      ])
                                                    ])
                                                  ] [
                                                    (group "UVXY  ->  UVIX" [
                                                      (weight-equal [
                                                        (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                                          (asset "EQUITIES::UVIX//USD" "UVIX")
                                                        ] [
                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ] [
                                              (weight-equal [
                                                (if (> (rsi "EQUITIES::XLY//USD" 10) 82) [
                                                  (group "UVXY  ->  UVIX" [
                                                    (weight-equal [
                                                      (if (< (rsi "EQUITIES::UVXY//USD" 10) 40) [
                                                        (asset "EQUITIES::UVIX//USD" "UVIX")
                                                      ] [
                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                      ])
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (group "BSC" [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::UVXY//USD" 21) 65) [
                                                          (weight-equal [
                                                            (group "BSC 1" [
                                                              (weight-equal [
                                                                (if (> (rsi "EQUITIES::SPY//USD" 21) 30) [
                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                ] [
                                                                  (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                ])
                                                              ])
                                                            ])
                                                            (group "BSC 2" [
                                                              (weight-equal [
                                                                (if (> (rsi "EQUITIES::UVXY//USD" 10) 74) [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::UVXY//USD" 10) 84) [
                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                        ] [
                                                          (weight-equal [
                                                            (group "Oversold Checks" [
                                                              (weight-equal [
                                                                (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                        ] [
                                                                          (weight-equal [
                                                                            (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                                                              (asset "EQUITIES::SPXL//USD" "SPXL")
                                                                            ] [
                                                                              (weight-equal [
                                                                                (group "Copypasta YOLO GainZs Here" [
                                                                                  (weight-equal [
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
                                                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
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
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
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
                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
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
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
        ])
      ])
    ])
    (group "EM ftlt (148,72,2007)" [
      (weight-equal [
        (if (< (rsi "EQUITIES::EEM//USD" 14) 30) [
          (asset "EQUITIES::EDC//USD" "EDC")
        ] [
          (weight-equal [
            (if (> (current-price "EQUITIES::SHV//USD" 10) (moving-average-price "EQUITIES::SHV//USD" 50)) [
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
                      (if (> (rsi "EQUITIES::IGIB//USD" 10) (rsi "EQUITIES::SPY//USD" 10)) [
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
                  (if (> (rsi "EQUITIES::IGIB//USD" 10) (rsi "EQUITIES::SPY//USD" 10)) [
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
    (group "QQQ FTLT Bonds - V0.5 - (237,33,2011)" [
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
                        (if (> (rsi "EQUITIES::XLK//USD" 10) 79) [
                          (asset "EQUITIES::UVXY//USD" "UVXY")
                        ] [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::XLP//USD" 10) 75) [
                              (asset "EQUITIES::VIXY//USD" "VIXY")
                            ] [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::XLF//USD" 10) 80) [
                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                ] [
                                  (group "Vol Check" [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::UVXY//USD" 21) 65) [
                                        (weight-equal [
                                          (group "BSC" [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::SPY//USD" 21) 30) [
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ] [
                                                (asset "EQUITIES::SPXL//USD" "SPXL")
                                              ])
                                            ])
                                          ])
                                        ])
                                      ] [
                                        (group "Vix Low" [
                                          (weight-equal [
                                            (if (< (rsi "EQUITIES::SOXX//USD" 10) 30) [
                                              (asset "EQUITIES::SOXL//USD" "SOXL")
                                            ] [
                                              (weight-equal [
                                                (if (< (rsi "EQUITIES::QQQ//USD" 10) 30) [
                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                ] [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                                    ] [
                                                      (weight-equal [
                                                        (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                                          (group "20d AGG vs 60d SH" [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                (weight-equal [
                                                                  (if (> (moving-average-return "EQUITIES::SPY//USD" 15) (moving-average-return "EQUITIES::SPY//USD" 30)) [
                                                                    (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (filter (rsi 10) (select-bottom 1) [
                                                                        (asset "EQUITIES::UGE//USD" "UGE")
                                                                        (asset "EQUITIES::BOND//USD" "BOND")
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
                                                            (if (< (cumulative-return "EQUITIES::QQQ//USD" 60) -12) [
                                                              (weight-equal [
                                                                (filter (rsi 10) (select-bottom 1) [
                                                                  (asset "EQUITIES::UGE//USD" "UGE")
                                                                  (asset "EQUITIES::BOND//USD" "BOND")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (> (current-price "EQUITIES::TQQQ//USD" 10) (moving-average-price "EQUITIES::TQQQ//USD" 20)) [
                                                                  (weight-equal [
                                                                    (if (< (rsi "EQUITIES::PSQ//USD" 10) 35) [
                                                                      (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                    ] [
                                                                      (group "20d AGG vs 60d SH" [
                                                                        (weight-equal [
                                                                          (if (> (rsi "EQUITIES::AGG//USD" 20) (rsi "EQUITIES::SH//USD" 60)) [
                                                                            (weight-equal [
                                                                              (if (> (moving-average-return "EQUITIES::SPY//USD" 15) (moving-average-return "EQUITIES::SPY//USD" 30)) [
                                                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (filter (rsi 10) (select-bottom 1) [
                                                                                    (asset "EQUITIES::UGE//USD" "UGE")
                                                                                    (asset "EQUITIES::BOND//USD" "BOND")
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (filter (rsi 10) (select-bottom 1) [
                                                                                (asset "EQUITIES::UGE//USD" "UGE")
                                                                                (asset "EQUITIES::BOND//USD" "BOND")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ] [
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
    (group "QQQ FTLT SMA V0.1 - (183,39,2011)" [
      (weight-equal [
        (group "QQQ FTLT SMA V0.1 - (183,39,2011)" [
          (weight-equal [
            (group "Over bought" [
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
                                (if (> (rsi "EQUITIES::XLK//USD" 10) 79) [
                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                ] [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::XLP//USD" 10) 75) [
                                      (asset "EQUITIES::VIXY//USD" "VIXY")
                                    ] [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::XLF//USD" 10) 80) [
                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                        ] [
                                          (group "Vol Check" [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::UVXY//USD" 21) 65) [
                                                (weight-equal [
                                                  (group "BSC" [
                                                    (weight-equal [
                                                      (if (> (rsi "EQUITIES::SPY//USD" 21) 30) [
                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                      ] [
                                                        (asset "EQUITIES::SPXL//USD" "SPXL")
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ] [
                                                (group "Vix Low" [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::SOXX//USD" 10) 30) [
                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                    ] [
                                                      (weight-equal [
                                                        (if (< (rsi "EQUITIES::QQQ//USD" 10) 30) [
                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                        ] [
                                                          (weight-equal [
                                                            (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                              (asset "EQUITIES::UPRO//USD" "UPRO")
                                                            ] [
                                                              (weight-equal [
                                                                (if (> (rsi "EQUITIES::SPY//USD" 70) 60) [
                                                                  (weight-equal [
                                                                    (filter (rsi 10) (select-bottom 1) [
                                                                      (asset "EQUITIES::UGE//USD" "UGE")
                                                                      (asset "EQUITIES::BOND//USD" "BOND")
                                                                    ])
                                                                  ])
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (< (cumulative-return "EQUITIES::QQQ//USD" 5) -5) [
                                                                      (group "Oversold" [
                                                                        (weight-equal [
                                                                          (if (< (rsi "EQUITIES::SPY//USD" 10) 35) [
                                                                            (weight-equal [
                                                                              (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                            ])
                                                                          ] [
                                                                            (weight-equal [
                                                                              (filter (rsi 10) (select-bottom 1) [
                                                                                (asset "EQUITIES::UGE//USD" "UGE")
                                                                                (asset "EQUITIES::BOND//USD" "BOND")
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
                                                                              (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 30)) [
                                                                                (weight-equal [
                                                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                ])
                                                                              ] [
                                                                                (weight-equal [
                                                                                  (if (> (cumulative-return "EQUITIES::QQQ//USD" 20) (moving-average-return "EQUITIES::QQQ//USD" 10)) [
                                                                                    (weight-equal [
                                                                                      (filter (rsi 10) (select-bottom 1) [
                                                                                        (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                        (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                      ])
                                                                                    ])
                                                                                  ] [
                                                                                    (weight-equal [
                                                                                      (filter (rsi 10) (select-bottom 1) [
                                                                                        (asset "EQUITIES::UGE//USD" "UGE")
                                                                                        (asset "EQUITIES::BOND//USD" "BOND")
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
                                                                              (filter (rsi 10) (select-bottom 1) [
                                                                                (asset "EQUITIES::UGE//USD" "UGE")
                                                                                (asset "EQUITIES::BOND//USD" "BOND")
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
        ])
      ])
    ])
    (group "EM Emerging Markets V0.4 (114,69,2009)" [
      (weight-equal [
        (if (< (rsi "EQUITIES::EEM//USD" 15) 30) [
          (asset "EQUITIES::EDC//USD" "EDC")
        ] [
          (weight-equal [
            (if (> (current-price "EQUITIES::SHV//USD" 10) (moving-average-price "EQUITIES::SHV//USD" 50)) [
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
                ])
              ])
            ] [
              (group "IGIB vs SPY" [
                (weight-equal [
                  (if (> (rsi "EQUITIES::IGIB//USD" 10) (rsi "EQUITIES::SPY//USD" 10)) [
                    (asset "EQUITIES::EEM//USD" "EEM")
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
    (group "Bonds Zoop V0.0 (144,38,2011)" [
      (weight-equal [
        (weight-equal [
          (if (> (current-price "EQUITIES::TLT//USD" 10) (moving-average-price "EQUITIES::TLT//USD" 200)) [
            (weight-equal [
              (if (> (rsi "EQUITIES::QLD//USD" 10) 79) [
                (asset "EQUITIES::UVXY//USD" "UVXY")
              ] [
                (weight-equal [
                  (if (< (rsi "EQUITIES::TMF//USD" 10) 32) [
                    (asset "EQUITIES::TMF//USD" "TMF")
                  ] [
                    (weight-equal [
                      (if (< (rsi "EQUITIES::BIL//USD" 30) (rsi "EQUITIES::TLT//USD" 20)) [
                        (weight-equal [
                          (if (< (exponential-moving-average-price "EQUITIES::TMF//USD" 8) (moving-average-price "EQUITIES::TMF//USD" 10)) [
                            (asset "EQUITIES::TMF//USD" "TMF")
                          ] [
                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                          ])
                        ])
                      ] [
                        (weight-equal [
                          (if (< (rsi "EQUITIES::QLD//USD" 10) 31) [
                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
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
            (weight-equal [
              (if (< (rsi "EQUITIES::TMF//USD" 10) 32) [
                (asset "EQUITIES::TMF//USD" "TMF")
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
  ])
