defsymphony "v2 | Community Discovery Symphony | NOVA (Invest Copy)" {:rebalance-frequency :daily}
  (weight-equal [
    (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 20)) [
      (weight-equal [
        (group "Max Drawdown Black Swan Catcher" [
          (weight-equal [
            (if (> (max-drawdown "EQUITIES::SPY//USD" 10) 6) [
              (weight-equal [
                (group "v2.1.0 Pop Bots l (DONT REPLACE $BIL)" [
                  (weight-equal [
                    (group "SPY Pop Bot" [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::SPXL//USD" 10) 80) [
                          (asset "EQUITIES::UVXY//USD" "UVXY")
                        ] [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                              (asset "EQUITIES::SSO//USD" "SSO")
                            ] [
                              (asset "EQUITIES::BIL//USD" "BIL")
                            ])
                          ])
                        ])
                      ])
                    ])
                    (group "QQQ Pop Bot" [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::TQQQ//USD" 10) 80) [
                          (asset "EQUITIES::UVXY//USD" "UVXY")
                        ] [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                              (asset "EQUITIES::QLD//USD" "QLD")
                            ] [
                              (asset "EQUITIES::BIL//USD" "BIL")
                            ])
                          ])
                        ])
                      ])
                    ])
                    (group "SMH Pop Bot" [
                      (weight-equal [
                        (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                          (asset "EQUITIES::USD//USD" "USD")
                        ] [
                          (asset "EQUITIES::BIL//USD" "BIL")
                        ])
                      ])
                    ])
                  ])
                ])
              ])
            ] [
              (group "Not a black Swan Event" [
                (weight-equal [
                  (group "v2.1.0 Pop Bots l (can replace $BIL with another symphony)" [
                    (weight-equal [
                      (group "SPY Pop Bot" [
                        (weight-equal [
                          (if (> (rsi "EQUITIES::SPXL//USD" 10) 80) [
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ] [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                (asset "EQUITIES::SSO//USD" "SSO")
                              ] [
                                (asset "EQUITIES::BIL//USD" "BIL")
                              ])
                            ])
                          ])
                        ])
                      ])
                      (group "QQQ Pop Bot" [
                        (weight-equal [
                          (if (> (rsi "EQUITIES::TQQQ//USD" 10) 80) [
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ] [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                (asset "EQUITIES::QLD//USD" "QLD")
                              ] [
                                (asset "EQUITIES::BIL//USD" "BIL")
                              ])
                            ])
                          ])
                        ])
                      ])
                      (group "SMH Pop Bot" [
                        (weight-equal [
                          (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                            (asset "EQUITIES::USD//USD" "USD")
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
        (group "Basic Portfolio | 2011-09-13" [
          (weight-equal [
            (group "Equities" [
              (weight-specified [80 20] [
                (group "FTLT" [
                  (weight-equal [
                    (if (> (current-price "EQUITIES::SPY//USD" 8) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                          (asset "EQUITIES::VIXY//USD" "VIXY")
                        ] [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                              (asset "EQUITIES::VIXY//USD" "VIXY")
                            ] [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::XLK//USD" 10) 79) [
                                  (asset "EQUITIES::VIXY//USD" "VIXY")
                                ] [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::IYY//USD" 10) 79) [
                                      (asset "EQUITIES::VIXY//USD" "VIXY")
                                    ] [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::VTV//USD" 10) 79) [
                                          (asset "EQUITIES::VIXY//USD" "VIXY")
                                        ] [
                                          (weight-equal [
                                            (if (> (rsi "EQUITIES::XLP//USD" 10) 75) [
                                              (asset "EQUITIES::VIXY//USD" "VIXY")
                                            ] [
                                              (weight-equal [
                                                (if (> (rsi "EQUITIES::XLF//USD" 10) 80) [
                                                  (asset "EQUITIES::VIXY//USD" "VIXY")
                                                ] [
                                                  (weight-equal [
                                                    (if (> (rsi "EQUITIES::VOX//USD" 10) 79) [
                                                      (asset "EQUITIES::VIXY//USD" "VIXY")
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
                    ] [
                      (weight-equal [
                        (if (< (rsi "EQUITIES::SOXX//USD" 10) 30) [
                          (asset "EQUITIES::SOXX//USD" "SOXX")
                        ] [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::QQQ//USD" 10) 30) [
                              (asset "EQUITIES::XLK//USD" "XLK")
                            ] [
                              (weight-equal [
                                (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 30)) [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::PSQ//USD" 10) 35) [
                                      (asset "EQUITIES::SPHB//USD" "SPHB")
                                    ] [
                                      (asset "EQUITIES::BTAL//USD" "BTAL")
                                    ])
                                  ])
                                ] [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::PSQ//USD" 10) 65) [
                                      (asset "EQUITIES::SPHB//USD" "SPHB")
                                    ] [
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
                (group "XLP Momentum" [
                  (weight-equal [
                    (if (> (exponential-moving-average-price "EQUITIES::XLP//USD" 8) (moving-average-price "EQUITIES::XLP//USD" 70)) [
                      (asset "EQUITIES::XLP//USD" "XLP")
                    ] [
                      (asset "EQUITIES::BIL//USD" "BIL")
                    ])
                  ])
                ])
              ])
            ])
            (group "Ballast Block" [
              (weight-specified [70 30] [
                (group "Bond Block" [
                  (weight-equal [
                    (group "TMF Simplified Momentum" [
                      (weight-equal [
                        (if (< (rsi "EQUITIES::TMF//USD" 10) 32) [
                          (asset "EQUITIES::TMF//USD" "TMF")
                        ] [
                          (weight-equal [
                            (if (> (moving-average-price "EQUITIES::TMF//USD" 15) (moving-average-price "EQUITIES::TMF//USD" 50)) [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::TMF//USD" 10) 75) [
                                  (asset "EQUITIES::TMF//USD" "TMF")
                                  (asset "EQUITIES::BIL//USD" "BIL")
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
                    (group "TMV Simplified Momentum" [
                      (weight-equal [
                        (if (> (moving-average-price "EQUITIES::TMV//USD" 15) (moving-average-price "EQUITIES::TMV//USD" 50)) [
                          (weight-equal [
                            (if (< (rsi "EQUITIES::TMV//USD" 10) 70) [
                              (weight-equal [
                                (if (< (standard-deviation-return "EQUITIES::TMV//USD" 10) 3) [
                                  (asset "EQUITIES::TMV//USD" "TMV")
                                ] [
                                  (asset "EQUITIES::BIL//USD" "BIL")
                                ])
                              ])
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
                (group "Commodity Block" [
                  (weight-specified [35 25 20 20] [
                    (group "Commodities" [
                      (weight-equal [
                        (if (< (rsi "EQUITIES::DBC//USD" 10) 15) [
                          (group "Commodity Bundle" [
                            (weight-equal [
                              (asset "EQUITIES::DBC//USD" "DBC")
                              (asset "EQUITIES::XME//USD" "XME")
                            ])
                          ])
                        ] [
                          (group "Short-Term Momentum" [
                            (weight-equal [
                              (if (> (exponential-moving-average-price "EQUITIES::DBC//USD" 8) (moving-average-price "EQUITIES::DBC//USD" 70)) [
                                (group "Commodity Bundle" [
                                  (weight-equal [
                                    (asset "EQUITIES::DBC//USD" "DBC")
                                    (asset "EQUITIES::XME//USD" "XME")
                                  ])
                                ])
                              ] [
                                (asset "EQUITIES::BIL//USD" "BIL")
                              ])
                            ])
                          ])
                          (group "Long-Term Momentum" [
                            (weight-equal [
                              (if (> (moving-average-price "EQUITIES::DBC//USD" 100) (moving-average-price "EQUITIES::DBC//USD" 252)) [
                                (weight-equal [
                                  (if (> (moving-average-price "EQUITIES::DBC//USD" 50) (moving-average-price "EQUITIES::DBC//USD" 100)) [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::DBC//USD" 60) 60) [
                                        (group "Commodity Bundle" [
                                          (weight-equal [
                                            (asset "EQUITIES::DBC//USD" "DBC")
                                            (asset "EQUITIES::XME//USD" "XME")
                                          ])
                                        ])
                                      ] [
                                        (asset "EQUITIES::BIL//USD" "BIL")
                                      ])
                                    ])
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
                    (group "Natural Gas" [
                      (weight-equal [
                        (if (> (moving-average-price "EQUITIES::FCG//USD" 100) (moving-average-price "EQUITIES::FCG//USD" 500)) [
                          (asset "EQUITIES::BIL//USD" "BIL")
                        ] [
                          (weight-equal [
                            (if (> (moving-average-price "EQUITIES::FCG//USD" 50) (moving-average-price "EQUITIES::FCG//USD" 400)) [
                              (asset "EQUITIES::FCG//USD" "FCG")
                            ] [
                              (group "Long/Short" [
                                (weight-equal [
                                  (if (> (current-price "EQUITIES::FCG//USD" 10) (moving-average-price "EQUITIES::FCG//USD" 10)) [
                                    (asset "EQUITIES::FCG//USD" "FCG")
                                  ] [
                                    (group "KOLD Wrapper" [
                                      (weight-equal [
                                        (if (< (rsi "EQUITIES::UNG//USD" 10) 25) [
                                          (asset "EQUITIES::BIL//USD" "BIL")
                                        ] [
                                          (asset "EQUITIES::KOLD//USD" "KOLD")
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                              (asset "EQUITIES::BIL//USD" "BIL")
                            ])
                          ])
                        ])
                      ])
                    ])
                    (group "Gold" [
                      (weight-equal [
                        (if (> (moving-average-price "EQUITIES::GLD//USD" 200) (moving-average-price "EQUITIES::GLD//USD" 350)) [
                          (weight-equal [
                            (if (> (moving-average-price "EQUITIES::GLD//USD" 60) (moving-average-price "EQUITIES::GLD//USD" 150)) [
                              (asset "EQUITIES::GLD//USD" "GLD")
                            ] [
                              (asset "EQUITIES::BIL//USD" "BIL")
                            ])
                          ])
                        ] [
                          (asset "EQUITIES::BIL//USD" "BIL")
                        ])
                      ])
                    ])
                    (group "Oil" [
                      (weight-equal [
                        (if (< (rsi "EQUITIES::UCO//USD" 10) 15) [
                          (asset "EQUITIES::DBO//USD" "DBO")
                        ] [
                          (weight-equal [
                            (if (> (current-price "EQUITIES::DBO//USD" 10) (moving-average-price "EQUITIES::DBO//USD" 130)) [
                              (weight-equal [
                                (if (> (exponential-moving-average-price "EQUITIES::DBO//USD" 8) (moving-average-price "EQUITIES::DBO//USD" 70)) [
                                  (asset "EQUITIES::DBO//USD" "DBO")
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
        (group "Safety Town v1.4 w/ Pop Bots v1.0" [
          (weight-equal [
            (group "SPY" [
              (weight-equal [
                (group "UVXY (4x88 is best level)" [
                  (weight-equal [
                    (if (> (rsi "EQUITIES::SPXL//USD" 4) 88) [
                      (asset "EQUITIES::UVXY//USD" "UVXY")
                    ] [
                      (group "Pop Bots" [
                        (weight-equal [
                          (group "TQQQ Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                          (group "SPXL Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                (asset "EQUITIES::SPXL//USD" "SPXL")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                          (group "SOXL Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                (asset "EQUITIES::SOXL//USD" "SOXL")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                ])
                (group "UVXY (7x85 is best level)" [
                  (weight-equal [
                    (if (> (rsi "EQUITIES::SPXL//USD" 7) 85) [
                      (asset "EQUITIES::UVXY//USD" "UVXY")
                    ] [
                      (group "Pop Bots" [
                        (weight-equal [
                          (group "TQQQ Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                          (group "SPXL Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                (asset "EQUITIES::SPXL//USD" "SPXL")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                          (group "SOXL Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                (asset "EQUITIES::SOXL//USD" "SOXL")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                ])
                (group "UVXY (10x80 or higher is best level)" [
                  (weight-equal [
                    (if (> (rsi "EQUITIES::SPXL//USD" 10) 80) [
                      (asset "EQUITIES::UVXY//USD" "UVXY")
                    ] [
                      (group "Pop Bots" [
                        (weight-equal [
                          (group "TQQQ Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                          (group "SPXL Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                (asset "EQUITIES::SPXL//USD" "SPXL")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                          (group "SOXL Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                (asset "EQUITIES::SOXL//USD" "SOXL")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                ])
              ])
            ])
            (group "QQQ" [
              (weight-equal [
                (group "UVXY (3x95 is best level)" [
                  (weight-equal [
                    (if (> (rsi "EQUITIES::TQQQ//USD" 3) 95) [
                      (asset "EQUITIES::UVXY//USD" "UVXY")
                    ] [
                      (group "Pop Bots" [
                        (weight-equal [
                          (group "TQQQ Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                          (group "SPXL Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                (asset "EQUITIES::SPXL//USD" "SPXL")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                          (group "SOXL Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                (asset "EQUITIES::SOXL//USD" "SOXL")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                ])
                (group "UVXY (5x89-91 is best level)" [
                  (weight-equal [
                    (if (> (rsi "EQUITIES::TQQQ//USD" 5) 90) [
                      (asset "EQUITIES::UVXY//USD" "UVXY")
                    ] [
                      (group "Pop Bots" [
                        (weight-equal [
                          (group "TQQQ Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                          (group "SPXL Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                (asset "EQUITIES::SPXL//USD" "SPXL")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                          (group "SOXL Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                (asset "EQUITIES::SOXL//USD" "SOXL")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                ])
                (group "UVXY (7x85-87 is best level)" [
                  (weight-equal [
                    (if (> (rsi "EQUITIES::TQQQ//USD" 7) 85) [
                      (asset "EQUITIES::UVXY//USD" "UVXY")
                    ] [
                      (group "Pop Bots" [
                        (weight-equal [
                          (group "TQQQ Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                          (group "SPXL Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                (asset "EQUITIES::SPXL//USD" "SPXL")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                          (group "SOXL Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                (asset "EQUITIES::SOXL//USD" "SOXL")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                ])
                (group "UVXY (10x76+ is best level)" [
                  (weight-equal [
                    (if (> (rsi "EQUITIES::TQQQ//USD" 10) 76) [
                      (asset "EQUITIES::UVXY//USD" "UVXY")
                    ] [
                      (group "Pop Bots" [
                        (weight-equal [
                          (group "TQQQ Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                          (group "SPXL Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SPXL//USD" 10) 30) [
                                (asset "EQUITIES::SPXL//USD" "SPXL")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                          (group "SOXL Pop" [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                (asset "EQUITIES::SOXL//USD" "SOXL")
                              ] [
                                (group "[!] Safety Town v1.4" [
                                  (weight-specified [75 25] [
                                    (group "Safe Haven" [
                                      (weight-equal [
                                        (weight-specified [35 65] [
                                          (weight-equal [
                                            (asset "EQUITIES::GLD//USD" "GLD")
                                            (asset "EQUITIES::XLP//USD" "XLP")
                                            (asset "EQUITIES::DBMF//USD" "DBMF")
                                          ])
                                          (weight-inverse-vol 30 [
                                            (asset "EQUITIES::UUP//USD" "UUP")
                                            (asset "EQUITIES::SHY//USD" "SHY")
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ])
                                    ])
                                    (group "VIX Hack" [
                                      (weight-specified [15 15 50 20] [
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-specified [50 50] [
                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                            (group "VIXM & BTAL" [
                                              (weight-equal [
                                                (asset "EQUITIES::BTAL//USD" "BTAL")
                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                              ])
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 14) 65) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (filter (standard-deviation-price 20) (select-top 2) [
                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                            ])
                                          ])
                                        ])
                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                          (weight-specified {"UVXY" 50 "VIXM" 50} [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ] [
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
                ])
              ])
            ])
          ])
        ])
        (group "SPY FTLT | Hedged Feaver Mods | v1" [
          (weight-equal [
            (weight-specified [40 60] [
              (group "SPY FTLT" [
                (weight-equal [
                  (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                    (weight-equal [
                      (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                        (asset "EQUITIES::SHV//USD" "SHV")
                      ] [
                        (weight-equal [
                          (if (> (rsi "EQUITIES::QQQ//USD" 10) 80) [
                            (asset "EQUITIES::SHV//USD" "SHV")
                          ] [
                            (weight-equal [
                              (if (> (rsi "EQUITIES::SPY//USD" 60) 60) [
                                (weight-equal [
                                  (asset "EQUITIES::GLD//USD" "GLD")
                                  (asset "EQUITIES::SHY//USD" "SHY")
                                ])
                              ] [
                                (asset "EQUITIES::SPY//USD" "SPY")
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ] [
                    (group "Bear Market Strategy" [
                      (weight-equal [
                        (weight-equal [
                          (if (< (rsi "EQUITIES::QQQ//USD" 10) 30) [
                            (asset "EQUITIES::QLD//USD" "QLD")
                          ] [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                (asset "EQUITIES::SSO//USD" "SSO")
                              ] [
                                (weight-equal [
                                  (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 20)) [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::PSQ//USD" 10) 30) [
                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                      ] [
                                        (asset "EQUITIES::QQQ//USD" "QQQ")
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
              (group "Hedging" [
                (weight-equal [
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
                  (group "IFF Fund: Hedge Block" [
                    (weight-equal [
                      (if (> (rsi "EQUITIES::UVXY//USD" 60) 40) [
                        (weight-equal [
                          (if (> (rsi "EQUITIES::TQQQ//USD" 10) 81) [
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ] [
                            (weight-equal [
                              (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                (asset "EQUITIES::UVXY//USD" "UVXY")
                              ] [
                                (group "Bond Block" [
                                  (weight-equal [
                                    (group "TMF Simplified Momentum" [
                                      (weight-equal [
                                        (if (< (rsi "EQUITIES::TMF//USD" 10) 32) [
                                          (asset "EQUITIES::TMF//USD" "TMF")
                                        ] [
                                          (weight-equal [
                                            (if (> (moving-average-price "EQUITIES::TMF//USD" 15) (moving-average-price "EQUITIES::TMF//USD" 50)) [
                                              (weight-equal [
                                                (if (< (rsi "EQUITIES::TMF//USD" 10) 75) [
                                                  (asset "EQUITIES::TMF//USD" "TMF")
                                                  (asset "EQUITIES::BIL//USD" "BIL")
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
                                    (group "TMV Simplified Momentum" [
                                      (weight-equal [
                                        (if (> (moving-average-price "EQUITIES::TMV//USD" 15) (moving-average-price "EQUITIES::TMV//USD" 50)) [
                                          (weight-equal [
                                            (if (< (rsi "EQUITIES::TMV//USD" 10) 70) [
                                              (weight-equal [
                                                (if (< (standard-deviation-return "EQUITIES::TMV//USD" 10) 3) [
                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                ] [
                                                  (asset "EQUITIES::BIL//USD" "BIL")
                                                ])
                                              ])
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
                      ] [
                        (group "Bond Block" [
                          (weight-equal [
                            (group "TMF Simplified Momentum" [
                              (weight-equal [
                                (if (< (rsi "EQUITIES::TMF//USD" 10) 32) [
                                  (asset "EQUITIES::TMF//USD" "TMF")
                                ] [
                                  (weight-equal [
                                    (if (> (moving-average-price "EQUITIES::TMF//USD" 15) (moving-average-price "EQUITIES::TMF//USD" 50)) [
                                      (weight-equal [
                                        (if (< (rsi "EQUITIES::TMF//USD" 10) 75) [
                                          (asset "EQUITIES::TMF//USD" "TMF")
                                          (asset "EQUITIES::BIL//USD" "BIL")
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
                            (group "TMV Simplified Momentum" [
                              (weight-equal [
                                (if (> (moving-average-price "EQUITIES::TMV//USD" 15) (moving-average-price "EQUITIES::TMV//USD" 50)) [
                                  (weight-equal [
                                    (if (< (rsi "EQUITIES::TMV//USD" 10) 70) [
                                      (weight-equal [
                                        (if (< (standard-deviation-return "EQUITIES::TMV//USD" 10) 3) [
                                          (asset "EQUITIES::TMV//USD" "TMV")
                                        ] [
                                          (asset "EQUITIES::BIL//USD" "BIL")
                                        ])
                                      ])
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
                  (group "IFF Fund: Correction Stopper" [
                    (weight-equal [
                      (if (> (rsi "EQUITIES::IEF//USD" 20) (rsi "EQUITIES::PSQ//USD" 60)) [
                        (weight-equal [
                          (filter (max-drawdown 10) (select-bottom 1) [
                            (asset "EQUITIES::QLD//USD" "QLD")
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ])
                          (if (< (rsi "EQUITIES::TMV//USD" 14) 70) [
                            (weight-equal [
                              (if (> (moving-average-price "EQUITIES::TMV//USD" 15) (moving-average-price "EQUITIES::TMV//USD" 50)) [
                                (asset "EQUITIES::TMV//USD" "TMV")
                              ] [
                                (asset "EQUITIES::BIL//USD" "BIL")
                              ])
                            ])
                          ] [
                            (asset "EQUITIES::BIL//USD" "BIL")
                          ])
                        ])
                      ] [
                        (asset "EQUITIES::BIL//USD" "BIL")
                      ])
                    ])
                  ])
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
                ])
              ])
            ])
          ])
        ])
      ])
    ] [
      (weight-specified [50 50] [
        (if (< (current-price "EQUITIES::SPY//USD" 10) (exponential-moving-average-price "EQUITIES::SPY//USD" 9)) [
          (weight-equal [
            (group "Hedge Group 1" [
              (weight-inverse-vol 2 [
                (group "DereckN Hedge System | Modified" [
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
                  ])
                ])
                (group "Simple Portfolio (UVXY) + v4 Pops + V1a TQQQ or not" [
                  (weight-equal [
                    (group "Single Popped Dividends (UVXY)" [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::QQQE//USD" 10) 79) [
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
                                        (if (> (rsi "EQUITIES::VOOG//USD" 10) 79) [
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
                                                    (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                      (weight-equal [
                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::XLY//USD" 10) 80) [
                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                        ] [
                                                          (weight-equal [
                                                            (if (> (rsi "EQUITIES::FAS//USD" 10) 80) [
                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                            ] [
                                                              (weight-equal [
                                                                (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                ] [
                                                                  (weight-equal [
                                                                    (group "Single Popped Dividends" [
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
                                                                          (weight-equal [
                                                                            (group "Combined Pop Bot" [
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
                                                                                            (group "Dividends" [
                                                                                              (weight-equal [
                                                                                                (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                                (asset "EQUITIES::DGRO//USD" "DGRO")
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                    (group "SVXY/VMS'd - SCHD-Jedi (UVXY)" [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::QQQE//USD" 10) 79) [
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
                                        (if (> (rsi "EQUITIES::VOOG//USD" 10) 79) [
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
                                                    (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                      (weight-equal [
                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::XLY//USD" 10) 80) [
                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                        ] [
                                                          (weight-equal [
                                                            (if (> (rsi "EQUITIES::FAS//USD" 10) 80) [
                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                            ] [
                                                              (weight-equal [
                                                                (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                ] [
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
                                                                      (weight-equal [
                                                                        (group "VMS'd JEPI Jedi (UVXY)" [
                                                                          (weight-equal [
                                                                            (if (> (rsi "EQUITIES::XLK//USD" 126) (rsi "EQUITIES::XLP//USD" 126)) [
                                                                              (weight-equal [
                                                                                (group "Bullish Market Conditions" [
                                                                                  (weight-equal [
                                                                                    (if (> (rsi "EQUITIES::TQQQ//USD" 10) 80) [
                                                                                      (weight-equal [
                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                      ])
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                                          (weight-equal [
                                                                                            (filter (moving-average-return 20) (select-bottom 1) [
                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                              (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                                            ])
                                                                                          ])
                                                                                        ] [
                                                                                          (weight-equal [
                                                                                            (if (> (rsi "EQUITIES::VIXY//USD" 10) 50) [
                                                                                              (weight-equal [
                                                                                                (if (< (moving-average-return "EQUITIES::VIXY//USD" 5) 0) [
                                                                                                  (group "1st Block" [
                                                                                                    (weight-equal [
                                                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                        (weight-equal [
                                                                                                          (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                        ])
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (group "v1.2 | JEPI Jedi (BSC)" [
                                                                                                            (weight-equal [
                                                                                                              (if (> (moving-average-return "EQUITIES::BND//USD" 10) (moving-average-return "EQUITIES::TBX//USD" 10)) [
                                                                                                                (weight-equal [
                                                                                                                  (group "Risk ON" [
                                                                                                                    (weight-specified [30 50 20] [
                                                                                                                      (group "Dividends" [
                                                                                                                        (weight-equal [
                                                                                                                          (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                                                          (asset "EQUITIES::DGRO//USD" "DGRO")
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                      (filter (rsi 20) (select-bottom 1) [
                                                                                                                        (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ] [
                                                                                                                (weight-equal [
                                                                                                                  (group "Risk OFF" [
                                                                                                                    (weight-specified [30 50 20] [
                                                                                                                      (group "Dividends" [
                                                                                                                        (weight-equal [
                                                                                                                          (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                                                          (asset "EQUITIES::DGRO//USD" "DGRO")
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                      (filter (rsi 20) (select-bottom 1) [
                                                                                                                        (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                                        (asset "EQUITIES::UGL//USD" "UGL")
                                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                      ])
                                                                                                                      (filter (rsi 20) (select-bottom 1) [
                                                                                                                        (asset "EQUITIES::DBC//USD" "DBC")
                                                                                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                                      ])
                                                                                                                    ])
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
                                                                                                  (group "2nd Block" [
                                                                                                    (weight-equal [
                                                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                        (weight-equal [
                                                                                                          (filter (exponential-moving-average-price 20) (select-bottom 1) [
                                                                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                            (asset "EQUITIES::TECS//USD" "TECS")
                                                                                                          ])
                                                                                                        ])
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (group "v1.2 | JEPI Jedi (BSC)" [
                                                                                                            (weight-equal [
                                                                                                              (if (> (moving-average-return "EQUITIES::BND//USD" 10) (moving-average-return "EQUITIES::TBX//USD" 10)) [
                                                                                                                (weight-equal [
                                                                                                                  (group "Risk ON" [
                                                                                                                    (weight-specified [30 50 20] [
                                                                                                                      (group "Dividends" [
                                                                                                                        (weight-equal [
                                                                                                                          (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                                                          (asset "EQUITIES::DGRO//USD" "DGRO")
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                      (filter (rsi 20) (select-bottom 1) [
                                                                                                                        (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ] [
                                                                                                                (weight-equal [
                                                                                                                  (group "Risk OFF" [
                                                                                                                    (weight-specified [30 50 20] [
                                                                                                                      (group "Dividends" [
                                                                                                                        (weight-equal [
                                                                                                                          (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                                                          (asset "EQUITIES::DGRO//USD" "DGRO")
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                      (filter (rsi 20) (select-bottom 1) [
                                                                                                                        (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                                        (asset "EQUITIES::UGL//USD" "UGL")
                                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                      ])
                                                                                                                      (filter (rsi 20) (select-bottom 1) [
                                                                                                                        (asset "EQUITIES::DBC//USD" "DBC")
                                                                                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
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
                                                                                                (if (< (moving-average-return "EQUITIES::VIXY//USD" 5) 0) [
                                                                                                  (group "3rd Block" [
                                                                                                    (weight-equal [
                                                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                        (weight-equal [
                                                                                                          (filter (exponential-moving-average-price 20) (select-bottom 1) [
                                                                                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                            (asset "EQUITIES::TECS//USD" "TECS")
                                                                                                          ])
                                                                                                        ])
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (group "v1.2 | JEPI Jedi (BSC)" [
                                                                                                            (weight-equal [
                                                                                                              (if (> (moving-average-return "EQUITIES::BND//USD" 10) (moving-average-return "EQUITIES::TBX//USD" 10)) [
                                                                                                                (weight-equal [
                                                                                                                  (group "Risk ON" [
                                                                                                                    (weight-specified [30 50 20] [
                                                                                                                      (group "Dividends" [
                                                                                                                        (weight-equal [
                                                                                                                          (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                                                          (asset "EQUITIES::DGRO//USD" "DGRO")
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                      (filter (rsi 20) (select-bottom 1) [
                                                                                                                        (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ] [
                                                                                                                (weight-equal [
                                                                                                                  (group "Risk OFF" [
                                                                                                                    (weight-specified [30 50 20] [
                                                                                                                      (group "Dividends" [
                                                                                                                        (weight-equal [
                                                                                                                          (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                                                          (asset "EQUITIES::DGRO//USD" "DGRO")
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                      (filter (rsi 20) (select-bottom 1) [
                                                                                                                        (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                                        (asset "EQUITIES::UGL//USD" "UGL")
                                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                      ])
                                                                                                                      (filter (rsi 20) (select-bottom 1) [
                                                                                                                        (asset "EQUITIES::DBC//USD" "DBC")
                                                                                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                                      ])
                                                                                                                    ])
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
                                                                                                  (group "4th Block" [
                                                                                                    (weight-equal [
                                                                                                      (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                        (weight-equal [
                                                                                                          (filter (exponential-moving-average-price 20) (select-top 1) [
                                                                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                            (asset "EQUITIES::TECS//USD" "TECS")
                                                                                                          ])
                                                                                                        ])
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (group "v1.2 | JEPI Jedi (BSC)" [
                                                                                                            (weight-equal [
                                                                                                              (if (> (moving-average-return "EQUITIES::BND//USD" 10) (moving-average-return "EQUITIES::TBX//USD" 10)) [
                                                                                                                (weight-equal [
                                                                                                                  (group "Risk ON" [
                                                                                                                    (weight-specified [30 50 20] [
                                                                                                                      (group "Dividends" [
                                                                                                                        (weight-equal [
                                                                                                                          (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                                                          (asset "EQUITIES::DGRO//USD" "DGRO")
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                      (filter (rsi 20) (select-bottom 1) [
                                                                                                                        (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ] [
                                                                                                                (weight-equal [
                                                                                                                  (group "Risk OFF" [
                                                                                                                    (weight-specified [30 50 20] [
                                                                                                                      (group "Dividends" [
                                                                                                                        (weight-equal [
                                                                                                                          (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                                                          (asset "EQUITIES::DGRO//USD" "DGRO")
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                      (filter (rsi 20) (select-bottom 1) [
                                                                                                                        (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                                        (asset "EQUITIES::UGL//USD" "UGL")
                                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                      ])
                                                                                                                      (filter (rsi 20) (select-bottom 1) [
                                                                                                                        (asset "EQUITIES::DBC//USD" "DBC")
                                                                                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ])
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
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
                                                                                (group "Danger Market Conditions" [
                                                                                  (weight-equal [
                                                                                    (if (> (rsi "EQUITIES::TQQQ//USD" 10) 80) [
                                                                                      (weight-equal [
                                                                                        (filter (cumulative-return 20) (select-bottom 1) [
                                                                                          (asset "EQUITIES::TMV//USD" "TMV")
                                                                                          (asset "EQUITIES::UGL//USD" "UGL")
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (> (rsi "EQUITIES::VIXY//USD" 10) 50) [
                                                                                          (weight-equal [
                                                                                            (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                                              (weight-equal [
                                                                                                (filter (standard-deviation-price 20) (select-bottom 1) [
                                                                                                  (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                  (asset "EQUITIES::ERX//USD" "ERX")
                                                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                ])
                                                                                              ])
                                                                                            ] [
                                                                                              (weight-equal [
                                                                                                (if (< (moving-average-return "EQUITIES::VIXY//USD" 5) 0) [
                                                                                                  (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                ] [
                                                                                                  (weight-equal [
                                                                                                    (group "v1.2 | JEPI Jedi (BSC)" [
                                                                                                      (weight-equal [
                                                                                                        (if (> (moving-average-return "EQUITIES::BND//USD" 10) (moving-average-return "EQUITIES::TBX//USD" 10)) [
                                                                                                          (weight-equal [
                                                                                                            (group "Risk ON" [
                                                                                                              (weight-specified [30 50 20] [
                                                                                                                (group "Dividends" [
                                                                                                                  (weight-equal [
                                                                                                                    (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                                                    (asset "EQUITIES::DGRO//USD" "DGRO")
                                                                                                                  ])
                                                                                                                ])
                                                                                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                (filter (rsi 20) (select-bottom 1) [
                                                                                                                  (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                                  (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                ])
                                                                                                              ])
                                                                                                            ])
                                                                                                          ])
                                                                                                        ] [
                                                                                                          (weight-equal [
                                                                                                            (group "Risk OFF" [
                                                                                                              (weight-specified [30 50 20] [
                                                                                                                (group "Dividends" [
                                                                                                                  (weight-equal [
                                                                                                                    (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                                                    (asset "EQUITIES::DGRO//USD" "DGRO")
                                                                                                                  ])
                                                                                                                ])
                                                                                                                (filter (rsi 20) (select-bottom 1) [
                                                                                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                                  (asset "EQUITIES::UGL//USD" "UGL")
                                                                                                                  (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                                ])
                                                                                                                (filter (rsi 20) (select-bottom 1) [
                                                                                                                  (asset "EQUITIES::DBC//USD" "DBC")
                                                                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                                ])
                                                                                                              ])
                                                                                                            ])
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
                                                                                              (weight-equal [
                                                                                                (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                              ])
                                                                                            ] [
                                                                                              (weight-equal [
                                                                                                (group "v1.2 | JEPI Jedi (BSC)" [
                                                                                                  (weight-equal [
                                                                                                    (if (> (moving-average-return "EQUITIES::BND//USD" 10) (moving-average-return "EQUITIES::TBX//USD" 10)) [
                                                                                                      (weight-equal [
                                                                                                        (group "Risk ON" [
                                                                                                          (weight-specified [30 50 20] [
                                                                                                            (group "Dividends" [
                                                                                                              (weight-equal [
                                                                                                                (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                                                (asset "EQUITIES::DGRO//USD" "DGRO")
                                                                                                              ])
                                                                                                            ])
                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                            (filter (rsi 20) (select-bottom 1) [
                                                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ] [
                                                                                                      (weight-equal [
                                                                                                        (group "Risk OFF" [
                                                                                                          (weight-specified [30 50 20] [
                                                                                                            (group "Dividends" [
                                                                                                              (weight-equal [
                                                                                                                (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                                                (asset "EQUITIES::DGRO//USD" "DGRO")
                                                                                                              ])
                                                                                                            ])
                                                                                                            (filter (rsi 20) (select-bottom 1) [
                                                                                                              (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                              (asset "EQUITIES::UGL//USD" "UGL")
                                                                                                              (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                            ])
                                                                                                            (filter (rsi 20) (select-bottom 1) [
                                                                                                              (asset "EQUITIES::DBC//USD" "DBC")
                                                                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
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
                        (if (> (rsi "EQUITIES::QQQE//USD" 10) 79) [
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
                                        (if (> (rsi "EQUITIES::VOOG//USD" 10) 79) [
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
                                                    (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                      (weight-equal [
                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                      ])
                                                    ] [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::XLY//USD" 10) 80) [
                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                        ] [
                                                          (weight-equal [
                                                            (if (> (rsi "EQUITIES::FAS//USD" 10) 80) [
                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                            ] [
                                                              (weight-equal [
                                                                (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -12) [
                                                                      (weight-equal [
                                                                        (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                          (weight-equal [
                                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                          ])
                                                                        ] [
                                                                          (weight-equal [
                                                                            (group "FTLT or Safety Town" [
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
                                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                            ])
                                                                                                          ])
                                                                                                        ] [
                                                                                                          (weight-equal [
                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
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
                                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                            ] [
                                                                                                              (weight-equal [
                                                                                                                (group "Safety Town l AR 41.9% DD 11.5% B -0.11" [
                                                                                                                  (weight-equal [
                                                                                                                    (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                                                                                                      (weight-equal [
                                                                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                      ])
                                                                                                                    ] [
                                                                                                                      (weight-equal [
                                                                                                                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                                                                                                          (weight-equal [
                                                                                                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                        ])
                                                                                                      ])
                                                                                                    ] [
                                                                                                      (weight-equal [
                                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
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
                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                        ] [
                                                                                                          (weight-equal [
                                                                                                            (group "Safety Town l AR 41.9% DD 11.5% B -0.11" [
                                                                                                              (weight-equal [
                                                                                                                (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                                                                                                  (weight-equal [
                                                                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                  ])
                                                                                                                ] [
                                                                                                                  (weight-equal [
                                                                                                                    (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                                                                                                                      (weight-equal [
                                                                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                    (group "Safety Town l AR 41.9% DD 11.5% B -0.11" [
                      (weight-equal [
                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                          (weight-equal [
                            (asset "EQUITIES::VIXM//USD" "VIXM")
                            (asset "EQUITIES::UVXY//USD" "UVXY")
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
                    (group "Safety Town l AR 26.3% DD 8.3% B -0.01" [
                      (weight-equal [
                        (if (>= (rsi "EQUITIES::SPY//USD" 10) 70) [
                          (weight-equal [
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
                    (group "v4 Pops" [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::QQQE//USD" 10) 79) [
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
                                    (if (<= (max-drawdown "EQUITIES::SPY//USD" 9) 0) [
                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                    ] [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::TECL//USD" 10) 79) [
                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                        ] [
                                          (weight-equal [
                                            (if (> (rsi "EQUITIES::VOOG//USD" 10) 79) [
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
                                                        (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                          (weight-equal [
                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (> (rsi "EQUITIES::XLY//USD" 10) 80) [
                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                            ] [
                                                              (weight-equal [
                                                                (if (> (rsi "EQUITIES::FAS//USD" 10) 80) [
                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                ] [
                                                                  (weight-equal [
                                                                    (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                    ] [
                                                                      (weight-equal [
                                                                        (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -12) [
                                                                          (weight-equal [
                                                                            (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                              (weight-equal [
                                                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                              ])
                                                                            ] [
                                                                              (weight-equal [
                                                                                (group "VMS popped TECL or Not" [
                                                                                  (weight-equal [
                                                                                    (if (> (rsi "EQUITIES::XLK//USD" 126) (rsi "EQUITIES::XLP//USD" 126)) [
                                                                                      (weight-equal [
                                                                                        (group "Bullish Market Conditions" [
                                                                                          (weight-equal [
                                                                                            (if (> (rsi "EQUITIES::TQQQ//USD" 10) 80) [
                                                                                              (weight-equal [
                                                                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                              ])
                                                                                            ] [
                                                                                              (weight-equal [
                                                                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                                                  (weight-equal [
                                                                                                    (filter (moving-average-return 20) (select-bottom 1) [
                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                      (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                    ])
                                                                                                  ])
                                                                                                ] [
                                                                                                  (weight-equal [
                                                                                                    (if (> (rsi "EQUITIES::VIXY//USD" 10) 50) [
                                                                                                      (weight-equal [
                                                                                                        (if (< (moving-average-return "EQUITIES::VIXY//USD" 5) 0) [
                                                                                                          (group "1st Block" [
                                                                                                            (weight-equal [
                                                                                                              (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                                (weight-equal [
                                                                                                                  (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                                ])
                                                                                                              ] [
                                                                                                                (weight-equal [
                                                                                                                  (group "TECL or Not" [
                                                                                                                    (weight-equal [
                                                                                                                      (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                      ] [
                                                                                                                        (weight-equal [
                                                                                                                          (group "Huge volatility" [
                                                                                                                            (weight-equal [
                                                                                                                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -13) [
                                                                                                                                (weight-equal [
                                                                                                                                  (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 6) [
                                                                                                                                    (weight-equal [
                                                                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                    ])
                                                                                                                                  ] [
                                                                                                                                    (weight-equal [
                                                                                                                                      (group "Mean Rev" [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (< (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                                (asset "EQUITIES::TECL//USD" "TECL")
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
                                                                                                                                        (weight-equal [
                                                                                                                                          (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                            (weight-equal [
                                                                                                                                              (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                            ])
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 25)) [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                ])
                                                                                                                                              ] [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (if (> (rsi "EQUITIES::SPY//USD" 60) 50) [
                                                                                                                                                    (group "Bond > Stock" [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                        ] [
                                                                                                                                                          (weight-equal [
                                                                                                                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                          ])
                                                                                                                                                        ])
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                  ] [
                                                                                                                                                    (group "Bond Mid-term < Long-term" [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (if (< (rsi "EQUITIES::IEF//USD" 200) (rsi "EQUITIES::TLT//USD" 200)) [
                                                                                                                                                          (weight-equal [
                                                                                                                                                            (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                            ] [
                                                                                                                                                              (weight-equal [
                                                                                                                                                                (asset "EQUITIES::BIL//USD" "BIL")
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
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
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
                                                                                                          (group "2nd Block" [
                                                                                                            (weight-equal [
                                                                                                              (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                                (weight-equal [
                                                                                                                  (filter (exponential-moving-average-price 20) (select-bottom 1) [
                                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                    (asset "EQUITIES::TECS//USD" "TECS")
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ] [
                                                                                                                (weight-equal [
                                                                                                                  (group "TECL or Not" [
                                                                                                                    (weight-equal [
                                                                                                                      (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                      ] [
                                                                                                                        (weight-equal [
                                                                                                                          (group "Huge volatility" [
                                                                                                                            (weight-equal [
                                                                                                                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -13) [
                                                                                                                                (weight-equal [
                                                                                                                                  (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 6) [
                                                                                                                                    (weight-equal [
                                                                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                    ])
                                                                                                                                  ] [
                                                                                                                                    (weight-equal [
                                                                                                                                      (group "Mean Rev" [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (< (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                                (asset "EQUITIES::TECL//USD" "TECL")
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
                                                                                                                                        (weight-equal [
                                                                                                                                          (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                            (weight-equal [
                                                                                                                                              (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                            ])
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 25)) [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                ])
                                                                                                                                              ] [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (if (> (rsi "EQUITIES::SPY//USD" 60) 50) [
                                                                                                                                                    (group "Bond > Stock" [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                        ] [
                                                                                                                                                          (weight-equal [
                                                                                                                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                          ])
                                                                                                                                                        ])
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                  ] [
                                                                                                                                                    (group "Bond Mid-term < Long-term" [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (if (< (rsi "EQUITIES::IEF//USD" 200) (rsi "EQUITIES::TLT//USD" 200)) [
                                                                                                                                                          (weight-equal [
                                                                                                                                                            (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                            ] [
                                                                                                                                                              (weight-equal [
                                                                                                                                                                (asset "EQUITIES::BIL//USD" "BIL")
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
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
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
                                                                                                        (if (< (moving-average-return "EQUITIES::VIXY//USD" 5) 0) [
                                                                                                          (group "3rd Block" [
                                                                                                            (weight-equal [
                                                                                                              (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                                (weight-equal [
                                                                                                                  (filter (exponential-moving-average-price 20) (select-bottom 1) [
                                                                                                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                                    (asset "EQUITIES::TECS//USD" "TECS")
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ] [
                                                                                                                (weight-equal [
                                                                                                                  (group "TECL or Not" [
                                                                                                                    (weight-equal [
                                                                                                                      (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                      ] [
                                                                                                                        (weight-equal [
                                                                                                                          (group "Huge volatility" [
                                                                                                                            (weight-equal [
                                                                                                                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -13) [
                                                                                                                                (weight-equal [
                                                                                                                                  (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 6) [
                                                                                                                                    (weight-equal [
                                                                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                    ])
                                                                                                                                  ] [
                                                                                                                                    (weight-equal [
                                                                                                                                      (group "Mean Rev" [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (< (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                                (asset "EQUITIES::TECL//USD" "TECL")
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
                                                                                                                                        (weight-equal [
                                                                                                                                          (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                            (weight-equal [
                                                                                                                                              (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                            ])
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 25)) [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                ])
                                                                                                                                              ] [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (if (> (rsi "EQUITIES::SPY//USD" 60) 50) [
                                                                                                                                                    (group "Bond > Stock" [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                        ] [
                                                                                                                                                          (weight-equal [
                                                                                                                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                          ])
                                                                                                                                                        ])
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                  ] [
                                                                                                                                                    (group "Bond Mid-term < Long-term" [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (if (< (rsi "EQUITIES::IEF//USD" 200) (rsi "EQUITIES::TLT//USD" 200)) [
                                                                                                                                                          (weight-equal [
                                                                                                                                                            (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                            ] [
                                                                                                                                                              (weight-equal [
                                                                                                                                                                (asset "EQUITIES::BIL//USD" "BIL")
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
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
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
                                                                                                          (group "4th Block" [
                                                                                                            (weight-equal [
                                                                                                              (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                                (weight-equal [
                                                                                                                  (filter (exponential-moving-average-price 20) (select-top 1) [
                                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                    (asset "EQUITIES::TECS//USD" "TECS")
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ] [
                                                                                                                (weight-equal [
                                                                                                                  (group "TECL or Not" [
                                                                                                                    (weight-equal [
                                                                                                                      (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                      ] [
                                                                                                                        (weight-equal [
                                                                                                                          (group "Huge volatility" [
                                                                                                                            (weight-equal [
                                                                                                                              (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -13) [
                                                                                                                                (weight-equal [
                                                                                                                                  (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 6) [
                                                                                                                                    (weight-equal [
                                                                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                    ])
                                                                                                                                  ] [
                                                                                                                                    (weight-equal [
                                                                                                                                      (group "Mean Rev" [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (< (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                                (asset "EQUITIES::TECL//USD" "TECL")
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
                                                                                                                                        (weight-equal [
                                                                                                                                          (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                            (weight-equal [
                                                                                                                                              (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                            ])
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 25)) [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                ])
                                                                                                                                              ] [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (if (> (rsi "EQUITIES::SPY//USD" 60) 50) [
                                                                                                                                                    (group "Bond > Stock" [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                        ] [
                                                                                                                                                          (weight-equal [
                                                                                                                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                          ])
                                                                                                                                                        ])
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                  ] [
                                                                                                                                                    (group "Bond Mid-term < Long-term" [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (if (< (rsi "EQUITIES::IEF//USD" 200) (rsi "EQUITIES::TLT//USD" 200)) [
                                                                                                                                                          (weight-equal [
                                                                                                                                                            (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                            ] [
                                                                                                                                                              (weight-equal [
                                                                                                                                                                (asset "EQUITIES::BIL//USD" "BIL")
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
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ])
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
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
                                                                                        (group "Danger Market Conditions" [
                                                                                          (weight-equal [
                                                                                            (if (> (rsi "EQUITIES::TQQQ//USD" 10) 80) [
                                                                                              (weight-equal [
                                                                                                (filter (cumulative-return 20) (select-bottom 1) [
                                                                                                  (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                  (asset "EQUITIES::UGL//USD" "UGL")
                                                                                                ])
                                                                                              ])
                                                                                            ] [
                                                                                              (weight-equal [
                                                                                                (if (> (rsi "EQUITIES::VIXY//USD" 10) 50) [
                                                                                                  (weight-equal [
                                                                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                                                      (weight-equal [
                                                                                                        (filter (standard-deviation-price 20) (select-bottom 1) [
                                                                                                          (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                          (asset "EQUITIES::ERX//USD" "ERX")
                                                                                                          (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                        ])
                                                                                                      ])
                                                                                                    ] [
                                                                                                      (weight-equal [
                                                                                                        (if (< (moving-average-return "EQUITIES::VIXY//USD" 5) 0) [
                                                                                                          (weight-equal [
                                                                                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                          ])
                                                                                                        ] [
                                                                                                          (weight-equal [
                                                                                                            (group "TECL or Not" [
                                                                                                              (weight-equal [
                                                                                                                (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                ] [
                                                                                                                  (weight-equal [
                                                                                                                    (group "Huge volatility" [
                                                                                                                      (weight-equal [
                                                                                                                        (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -13) [
                                                                                                                          (weight-equal [
                                                                                                                            (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 6) [
                                                                                                                              (weight-equal [
                                                                                                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                              ])
                                                                                                                            ] [
                                                                                                                              (weight-equal [
                                                                                                                                (group "Mean Rev" [
                                                                                                                                  (weight-equal [
                                                                                                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                    ] [
                                                                                                                                      (weight-equal [
                                                                                                                                        (if (< (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
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
                                                                                                                                  (weight-equal [
                                                                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                  ])
                                                                                                                                ] [
                                                                                                                                  (weight-equal [
                                                                                                                                    (if (> (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                      (weight-equal [
                                                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                      ])
                                                                                                                                    ] [
                                                                                                                                      (weight-equal [
                                                                                                                                        (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 25)) [
                                                                                                                                          (weight-equal [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                          ])
                                                                                                                                        ] [
                                                                                                                                          (weight-equal [
                                                                                                                                            (if (> (rsi "EQUITIES::SPY//USD" 60) 50) [
                                                                                                                                              (group "Bond > Stock" [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                  ] [
                                                                                                                                                    (weight-equal [
                                                                                                                                                      (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                    ])
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ])
                                                                                                                                            ] [
                                                                                                                                              (group "Bond Mid-term < Long-term" [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (if (< (rsi "EQUITIES::IEF//USD" 200) (rsi "EQUITIES::TLT//USD" 200)) [
                                                                                                                                                    (weight-equal [
                                                                                                                                                      (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                      ] [
                                                                                                                                                        (weight-equal [
                                                                                                                                                          (asset "EQUITIES::BIL//USD" "BIL")
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
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ])
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
                                                                                                      (weight-equal [
                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                      ])
                                                                                                    ] [
                                                                                                      (weight-equal [
                                                                                                        (group "TECL or Not" [
                                                                                                          (weight-equal [
                                                                                                            (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                            ] [
                                                                                                              (weight-equal [
                                                                                                                (group "Huge volatility" [
                                                                                                                  (weight-equal [
                                                                                                                    (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -13) [
                                                                                                                      (weight-equal [
                                                                                                                        (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 6) [
                                                                                                                          (weight-equal [
                                                                                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                          ])
                                                                                                                        ] [
                                                                                                                          (weight-equal [
                                                                                                                            (group "Mean Rev" [
                                                                                                                              (weight-equal [
                                                                                                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                ] [
                                                                                                                                  (weight-equal [
                                                                                                                                    (if (< (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
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
                                                                                                                              (weight-equal [
                                                                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                              ])
                                                                                                                            ] [
                                                                                                                              (weight-equal [
                                                                                                                                (if (> (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                  (weight-equal [
                                                                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                  ])
                                                                                                                                ] [
                                                                                                                                  (weight-equal [
                                                                                                                                    (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 25)) [
                                                                                                                                      (weight-equal [
                                                                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                      ])
                                                                                                                                    ] [
                                                                                                                                      (weight-equal [
                                                                                                                                        (if (> (rsi "EQUITIES::SPY//USD" 60) 50) [
                                                                                                                                          (group "Bond > Stock" [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                              ] [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                ])
                                                                                                                                              ])
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                        ] [
                                                                                                                                          (group "Bond Mid-term < Long-term" [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (< (rsi "EQUITIES::IEF//USD" 200) (rsi "EQUITIES::TLT//USD" 200)) [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                  ] [
                                                                                                                                                    (weight-equal [
                                                                                                                                                      (asset "EQUITIES::BIL//USD" "BIL")
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
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ])
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
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
                                                                            (group "VMS popped TECL or Not" [
                                                                              (weight-equal [
                                                                                (if (> (rsi "EQUITIES::XLK//USD" 126) (rsi "EQUITIES::XLP//USD" 126)) [
                                                                                  (weight-equal [
                                                                                    (group "Bullish Market Conditions" [
                                                                                      (weight-equal [
                                                                                        (if (> (rsi "EQUITIES::TQQQ//USD" 10) 80) [
                                                                                          (weight-equal [
                                                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                          ])
                                                                                        ] [
                                                                                          (weight-equal [
                                                                                            (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                                              (weight-equal [
                                                                                                (filter (moving-average-return 20) (select-bottom 1) [
                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                  (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                ])
                                                                                              ])
                                                                                            ] [
                                                                                              (weight-equal [
                                                                                                (if (> (rsi "EQUITIES::VIXY//USD" 10) 50) [
                                                                                                  (weight-equal [
                                                                                                    (if (< (moving-average-return "EQUITIES::VIXY//USD" 5) 0) [
                                                                                                      (group "1st Block" [
                                                                                                        (weight-equal [
                                                                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                            (weight-equal [
                                                                                                              (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                            ])
                                                                                                          ] [
                                                                                                            (weight-equal [
                                                                                                              (group "TECL or Not" [
                                                                                                                (weight-equal [
                                                                                                                  (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                  ] [
                                                                                                                    (weight-equal [
                                                                                                                      (group "Huge volatility" [
                                                                                                                        (weight-equal [
                                                                                                                          (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -13) [
                                                                                                                            (weight-equal [
                                                                                                                              (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 6) [
                                                                                                                                (weight-equal [
                                                                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                ])
                                                                                                                              ] [
                                                                                                                                (weight-equal [
                                                                                                                                  (group "Mean Rev" [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (< (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
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
                                                                                                                                    (weight-equal [
                                                                                                                                      (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                    ])
                                                                                                                                  ] [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                        (weight-equal [
                                                                                                                                          (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 25)) [
                                                                                                                                            (weight-equal [
                                                                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                            ])
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (rsi "EQUITIES::SPY//USD" 60) 50) [
                                                                                                                                                (group "Bond > Stock" [
                                                                                                                                                  (weight-equal [
                                                                                                                                                    (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                    ] [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ] [
                                                                                                                                                (group "Bond Mid-term < Long-term" [
                                                                                                                                                  (weight-equal [
                                                                                                                                                    (if (< (rsi "EQUITIES::IEF//USD" 200) (rsi "EQUITIES::TLT//USD" 200)) [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                        ] [
                                                                                                                                                          (weight-equal [
                                                                                                                                                            (asset "EQUITIES::BIL//USD" "BIL")
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
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
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
                                                                                                      (group "2nd Block" [
                                                                                                        (weight-equal [
                                                                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                            (weight-equal [
                                                                                                              (filter (exponential-moving-average-price 20) (select-bottom 1) [
                                                                                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                (asset "EQUITIES::TECS//USD" "TECS")
                                                                                                              ])
                                                                                                            ])
                                                                                                          ] [
                                                                                                            (weight-equal [
                                                                                                              (group "TECL or Not" [
                                                                                                                (weight-equal [
                                                                                                                  (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                  ] [
                                                                                                                    (weight-equal [
                                                                                                                      (group "Huge volatility" [
                                                                                                                        (weight-equal [
                                                                                                                          (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -13) [
                                                                                                                            (weight-equal [
                                                                                                                              (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 6) [
                                                                                                                                (weight-equal [
                                                                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                ])
                                                                                                                              ] [
                                                                                                                                (weight-equal [
                                                                                                                                  (group "Mean Rev" [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (< (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
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
                                                                                                                                    (weight-equal [
                                                                                                                                      (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                    ])
                                                                                                                                  ] [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                        (weight-equal [
                                                                                                                                          (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 25)) [
                                                                                                                                            (weight-equal [
                                                                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                            ])
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (rsi "EQUITIES::SPY//USD" 60) 50) [
                                                                                                                                                (group "Bond > Stock" [
                                                                                                                                                  (weight-equal [
                                                                                                                                                    (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                    ] [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ] [
                                                                                                                                                (group "Bond Mid-term < Long-term" [
                                                                                                                                                  (weight-equal [
                                                                                                                                                    (if (< (rsi "EQUITIES::IEF//USD" 200) (rsi "EQUITIES::TLT//USD" 200)) [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                        ] [
                                                                                                                                                          (weight-equal [
                                                                                                                                                            (asset "EQUITIES::BIL//USD" "BIL")
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
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ])
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
                                                                                                    (if (< (moving-average-return "EQUITIES::VIXY//USD" 5) 0) [
                                                                                                      (group "3rd Block" [
                                                                                                        (weight-equal [
                                                                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                            (weight-equal [
                                                                                                              (filter (exponential-moving-average-price 20) (select-bottom 1) [
                                                                                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                                (asset "EQUITIES::TECS//USD" "TECS")
                                                                                                              ])
                                                                                                            ])
                                                                                                          ] [
                                                                                                            (weight-equal [
                                                                                                              (group "TECL or Not" [
                                                                                                                (weight-equal [
                                                                                                                  (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                  ] [
                                                                                                                    (weight-equal [
                                                                                                                      (group "Huge volatility" [
                                                                                                                        (weight-equal [
                                                                                                                          (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -13) [
                                                                                                                            (weight-equal [
                                                                                                                              (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 6) [
                                                                                                                                (weight-equal [
                                                                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                ])
                                                                                                                              ] [
                                                                                                                                (weight-equal [
                                                                                                                                  (group "Mean Rev" [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (< (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
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
                                                                                                                                    (weight-equal [
                                                                                                                                      (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                    ])
                                                                                                                                  ] [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                        (weight-equal [
                                                                                                                                          (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 25)) [
                                                                                                                                            (weight-equal [
                                                                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                            ])
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (rsi "EQUITIES::SPY//USD" 60) 50) [
                                                                                                                                                (group "Bond > Stock" [
                                                                                                                                                  (weight-equal [
                                                                                                                                                    (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                    ] [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ] [
                                                                                                                                                (group "Bond Mid-term < Long-term" [
                                                                                                                                                  (weight-equal [
                                                                                                                                                    (if (< (rsi "EQUITIES::IEF//USD" 200) (rsi "EQUITIES::TLT//USD" 200)) [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                        ] [
                                                                                                                                                          (weight-equal [
                                                                                                                                                            (asset "EQUITIES::BIL//USD" "BIL")
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
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
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
                                                                                                      (group "4th Block" [
                                                                                                        (weight-equal [
                                                                                                          (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                                            (weight-equal [
                                                                                                              (filter (exponential-moving-average-price 20) (select-top 1) [
                                                                                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                (asset "EQUITIES::TECS//USD" "TECS")
                                                                                                              ])
                                                                                                            ])
                                                                                                          ] [
                                                                                                            (weight-equal [
                                                                                                              (group "TECL or Not" [
                                                                                                                (weight-equal [
                                                                                                                  (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                  ] [
                                                                                                                    (weight-equal [
                                                                                                                      (group "Huge volatility" [
                                                                                                                        (weight-equal [
                                                                                                                          (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -13) [
                                                                                                                            (weight-equal [
                                                                                                                              (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 6) [
                                                                                                                                (weight-equal [
                                                                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                ])
                                                                                                                              ] [
                                                                                                                                (weight-equal [
                                                                                                                                  (group "Mean Rev" [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (< (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
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
                                                                                                                                    (weight-equal [
                                                                                                                                      (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                    ])
                                                                                                                                  ] [
                                                                                                                                    (weight-equal [
                                                                                                                                      (if (> (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                        (weight-equal [
                                                                                                                                          (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                        ])
                                                                                                                                      ] [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 25)) [
                                                                                                                                            (weight-equal [
                                                                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                            ])
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (rsi "EQUITIES::SPY//USD" 60) 50) [
                                                                                                                                                (group "Bond > Stock" [
                                                                                                                                                  (weight-equal [
                                                                                                                                                    (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                    ] [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                      ])
                                                                                                                                                    ])
                                                                                                                                                  ])
                                                                                                                                                ])
                                                                                                                                              ] [
                                                                                                                                                (group "Bond Mid-term < Long-term" [
                                                                                                                                                  (weight-equal [
                                                                                                                                                    (if (< (rsi "EQUITIES::IEF//USD" 200) (rsi "EQUITIES::TLT//USD" 200)) [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                        ] [
                                                                                                                                                          (weight-equal [
                                                                                                                                                            (asset "EQUITIES::BIL//USD" "BIL")
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
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ])
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ])
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
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
                                                                                    (group "Danger Market Conditions" [
                                                                                      (weight-equal [
                                                                                        (if (> (rsi "EQUITIES::TQQQ//USD" 10) 80) [
                                                                                          (weight-equal [
                                                                                            (filter (cumulative-return 20) (select-bottom 1) [
                                                                                              (asset "EQUITIES::TMV//USD" "TMV")
                                                                                              (asset "EQUITIES::UGL//USD" "UGL")
                                                                                            ])
                                                                                          ])
                                                                                        ] [
                                                                                          (weight-equal [
                                                                                            (if (> (rsi "EQUITIES::VIXY//USD" 10) 50) [
                                                                                              (weight-equal [
                                                                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                                                  (weight-equal [
                                                                                                    (filter (standard-deviation-price 20) (select-bottom 1) [
                                                                                                      (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                      (asset "EQUITIES::ERX//USD" "ERX")
                                                                                                      (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                    ])
                                                                                                  ])
                                                                                                ] [
                                                                                                  (weight-equal [
                                                                                                    (if (< (moving-average-return "EQUITIES::VIXY//USD" 5) 0) [
                                                                                                      (weight-equal [
                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                      ])
                                                                                                    ] [
                                                                                                      (weight-equal [
                                                                                                        (group "TECL or Not" [
                                                                                                          (weight-equal [
                                                                                                            (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                            ] [
                                                                                                              (weight-equal [
                                                                                                                (group "Huge volatility" [
                                                                                                                  (weight-equal [
                                                                                                                    (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -13) [
                                                                                                                      (weight-equal [
                                                                                                                        (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 6) [
                                                                                                                          (weight-equal [
                                                                                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                          ])
                                                                                                                        ] [
                                                                                                                          (weight-equal [
                                                                                                                            (group "Mean Rev" [
                                                                                                                              (weight-equal [
                                                                                                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                ] [
                                                                                                                                  (weight-equal [
                                                                                                                                    (if (< (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
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
                                                                                                                              (weight-equal [
                                                                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                              ])
                                                                                                                            ] [
                                                                                                                              (weight-equal [
                                                                                                                                (if (> (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                  (weight-equal [
                                                                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                  ])
                                                                                                                                ] [
                                                                                                                                  (weight-equal [
                                                                                                                                    (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 25)) [
                                                                                                                                      (weight-equal [
                                                                                                                                        (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                      ])
                                                                                                                                    ] [
                                                                                                                                      (weight-equal [
                                                                                                                                        (if (> (rsi "EQUITIES::SPY//USD" 60) 50) [
                                                                                                                                          (group "Bond > Stock" [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                              ] [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                                ])
                                                                                                                                              ])
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                        ] [
                                                                                                                                          (group "Bond Mid-term < Long-term" [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (< (rsi "EQUITIES::IEF//USD" 200) (rsi "EQUITIES::TLT//USD" 200)) [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                  ] [
                                                                                                                                                    (weight-equal [
                                                                                                                                                      (asset "EQUITIES::BIL//USD" "BIL")
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
                                                                                                                                  ])
                                                                                                                                ])
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
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
                                                                                                  (weight-equal [
                                                                                                    (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                  ])
                                                                                                ] [
                                                                                                  (weight-equal [
                                                                                                    (group "TECL or Not" [
                                                                                                      (weight-equal [
                                                                                                        (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                        ] [
                                                                                                          (weight-equal [
                                                                                                            (group "Huge volatility" [
                                                                                                              (weight-equal [
                                                                                                                (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -13) [
                                                                                                                  (weight-equal [
                                                                                                                    (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 6) [
                                                                                                                      (weight-equal [
                                                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                      ])
                                                                                                                    ] [
                                                                                                                      (weight-equal [
                                                                                                                        (group "Mean Rev" [
                                                                                                                          (weight-equal [
                                                                                                                            (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                            ] [
                                                                                                                              (weight-equal [
                                                                                                                                (if (< (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                                  (asset "EQUITIES::TECL//USD" "TECL")
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
                                                                                                                          (weight-equal [
                                                                                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                          ])
                                                                                                                        ] [
                                                                                                                          (weight-equal [
                                                                                                                            (if (> (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                                                                                              (weight-equal [
                                                                                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                              ])
                                                                                                                            ] [
                                                                                                                              (weight-equal [
                                                                                                                                (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 25)) [
                                                                                                                                  (weight-equal [
                                                                                                                                    (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                  ])
                                                                                                                                ] [
                                                                                                                                  (weight-equal [
                                                                                                                                    (if (> (rsi "EQUITIES::SPY//USD" 60) 50) [
                                                                                                                                      (group "Bond > Stock" [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                            (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                          ] [
                                                                                                                                            (weight-equal [
                                                                                                                                              (asset "EQUITIES::BIL//USD" "BIL")
                                                                                                                                            ])
                                                                                                                                          ])
                                                                                                                                        ])
                                                                                                                                      ])
                                                                                                                                    ] [
                                                                                                                                      (group "Bond Mid-term < Long-term" [
                                                                                                                                        (weight-equal [
                                                                                                                                          (if (< (rsi "EQUITIES::IEF//USD" 200) (rsi "EQUITIES::TLT//USD" 200)) [
                                                                                                                                            (weight-equal [
                                                                                                                                              (if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45)) [
                                                                                                                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                              ] [
                                                                                                                                                (weight-equal [
                                                                                                                                                  (asset "EQUITIES::BIL//USD" "BIL")
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
                                                                                                                              ])
                                                                                                                            ])
                                                                                                                          ])
                                                                                                                        ])
                                                                                                                      ])
                                                                                                                    ])
                                                                                                                  ])
                                                                                                                ])
                                                                                                              ])
                                                                                                            ])
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                    (group "V1a TQQQ or not" [
                      (weight-equal [
                        (group "bsmr230105 | TQQQ or not | BlackSwan MeanRev BondSignal" [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                              (asset "EQUITIES::UVXY//USD" "UVXY")
                            ] [
                              (weight-equal [
                                (group "Huge volatility" [
                                  (weight-equal [
                                    (if (< (cumulative-return "EQUITIES::TQQQ//USD" 6) -12) [
                                      (weight-equal [
                                        (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                          (weight-equal [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                          ])
                                        ] [
                                          (weight-equal [
                                            (group "Mean Rev" [
                                              (weight-equal [
                                                (if (< (rsi "EQUITIES::TQQQ//USD" 10) 32) [
                                                  (asset "EQUITIES::SOXL//USD" "SOXL")
                                                ] [
                                                  (weight-equal [
                                                    (if (< (max-drawdown "EQUITIES::TMF//USD" 10) 7) [
                                                      (asset "EQUITIES::SOXL//USD" "SOXL")
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
                      ])
                    ])
                  ])
                ])
                (group "Four Corners v1.2 | nicomavis" [
                  (weight-equal [
                    (if (< (rsi "EQUITIES::QQQ//USD" 10) 30) [
                      (group "[Quick] Oversold Bounce" [
                        (weight-equal [
                          (asset "EQUITIES::TECL//USD" "TECL")
                          (asset "EQUITIES::TQQQ//USD" "TQQQ")
                          (asset "EQUITIES::IEF//USD" "IEF")
                          (asset "EQUITIES::UUP//USD" "UUP")
                        ])
                      ])
                    ] [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                          (group "[Quick] Overbought Pop" [
                            (weight-equal [
                              (asset "EQUITIES::TMF//USD" "TMF")
                              (asset "EQUITIES::BTAL//USD" "BTAL")
                              (asset "EQUITIES::VIXY//USD" "VIXY")
                            ])
                          ])
                        ] [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::VTV//USD" 10) 79) [
                              (group "[Quick] Overbought Pop" [
                                (weight-equal [
                                  (asset "EQUITIES::TMF//USD" "TMF")
                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                  (asset "EQUITIES::VIXY//USD" "VIXY")
                                ])
                              ])
                            ] [
                              (group "Core Logic (2x2)" [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::QQQ//USD" 100) (rsi "EQUITIES::VPU//USD" 100)) [
                                    (weight-equal [
                                      (if (> (cumulative-return "EQUITIES::CORP//USD" 60) (cumulative-return "EQUITIES::BIL//USD" 60)) [
                                        (group "Bull Market" [
                                          (weight-equal [
                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                            (asset "EQUITIES::UPRO//USD" "UPRO")
                                            (asset "EQUITIES::EEMS//USD" "EEMS")
                                            (asset "EQUITIES::BLV//USD" "BLV")
                                          ])
                                        ])
                                      ] [
                                        (group "Hedge" [
                                          (weight-equal [
                                            (asset "EQUITIES::VT//USD" "VT")
                                            (asset "EQUITIES::LQD//USD" "LQD")
                                            (group "IEF vs PSQ => TQQQ/PICK or BTAL" [
                                              (weight-equal [
                                                (if (> (rsi "EQUITIES::IEF//USD" 7) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                  (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                  (asset "EQUITIES::PICK//USD" "PICK")
                                                ] [
                                                  (asset "EQUITIES::BTAL//USD" "BTAL")
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ] [
                                    (weight-equal [
                                      (if (> (cumulative-return "EQUITIES::CORP//USD" 60) (cumulative-return "EQUITIES::BIL//USD" 60)) [
                                        (group "Hedge" [
                                          (weight-equal [
                                            (asset "EQUITIES::VT//USD" "VT")
                                            (asset "EQUITIES::VWO//USD" "VWO")
                                            (asset "EQUITIES::BLV//USD" "BLV")
                                            (group "Materials + Mining" [
                                              (weight-equal [
                                                (asset "EQUITIES::VAW//USD" "VAW")
                                                (asset "EQUITIES::PICK//USD" "PICK")
                                                (asset "EQUITIES::GDX//USD" "GDX")
                                              ])
                                            ])
                                          ])
                                        ])
                                      ] [
                                        (group "Bear Market" [
                                          (weight-equal [
                                            (asset "EQUITIES::BTAL//USD" "BTAL")
                                            (group "IEF vs PSQ => VPU/GDX or PSQ" [
                                              (weight-equal [
                                                (if (> (rsi "EQUITIES::IEF//USD" 7) (rsi "EQUITIES::PSQ//USD" 20)) [
                                                  (asset "EQUITIES::VT//USD" "VT")
                                                  (asset "EQUITIES::GDX//USD" "GDX")
                                                ] [
                                                  (asset "EQUITIES::PSQ//USD" "PSQ")
                                                  (asset "EQUITIES::FMF//USD" "FMF")
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
                (group "The Enigma of the Financial Universe 1.1" [
                  (weight-equal [
                    (weight-specified [100] [
                      (if (> (rsi "EQUITIES::TTT//USD" 30) (rsi "EQUITIES::SHYG//USD" 30)) [
                        (group "Bond yield risk off" [
                          (weight-equal [
                            (filter (exponential-moving-average-price 20) (select-bottom 3) [
                              (asset "EQUITIES::USDU//USD" "USDU")
                              (asset "EQUITIES::BTAL//USD" "BTAL")
                              (asset "EQUITIES::HDGE//USD" "HDGE")
                              (asset "EQUITIES::SJB//USD" "SJB")
                              (asset "EQUITIES::URTY//USD" "URTY")
                              (asset "EQUITIES::TZA//USD" "TZA")
                              (asset "EQUITIES::ERX//USD" "ERX")
                            ])
                            (weight-equal [
                              (filter (rsi 20) (select-bottom 2) [
                                (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                (asset "EQUITIES::TBF//USD" "TBF")
                                (asset "EQUITIES::TBT//USD" "TBT")
                                (asset "EQUITIES::SDY//USD" "SDY")
                              ])
                              (filter (rsi 20) (select-top 2) [
                                (asset "EQUITIES::SHV//USD" "SHV")
                                (asset "EQUITIES::SPLV//USD" "SPLV")
                                (asset "EQUITIES::FAS//USD" "FAS")
                                (asset "EQUITIES::PDBC//USD" "PDBC")
                                (asset "EQUITIES::XLY//USD" "XLY")
                              ])
                            ])
                          ])
                        ])
                      ] [
                        (weight-equal [
                          (if (> (standard-deviation-return "EQUITIES::SPY//USD" 30) (standard-deviation-return "EQUITIES::SPY//USD" 252)) [
                            (group "Vol risk OFF" [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::VIXM//USD" 40) 69) [
                                  (group "Black Swan Catcher" [
                                    (weight-equal [
                                      (filter (standard-deviation-return 20) (select-bottom 3) [
                                        (asset "EQUITIES::SQQQ//USD" "SQQQ")
                                        (asset "EQUITIES::TTT//USD" "TTT")
                                        (asset "EQUITIES::SDS//USD" "SDS")
                                        (asset "EQUITIES::BTAL//USD" "BTAL")
                                        (asset "EQUITIES::TMV//USD" "TMV")
                                        (asset "EQUITIES::XLU//USD" "XLU")
                                      ])
                                    ])
                                  ])
                                ] [
                                  (asset "EQUITIES::SHY//USD" "SHY")
                                ])
                              ])
                            ])
                          ] [
                            (weight-equal [
                              (if (< (cumulative-return "EQUITIES::BND//USD" 60) -1) [
                                (asset "EQUITIES::SHY//USD" "SHY")
                              ] [
                                (asset "EQUITIES::SPY//USD" "SPY")
                              ])
                            ])
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
          (asset "EQUITIES::BIL//USD" "BIL")
        ])
        (group "Almost Pure Cash | Modified" [
          (weight-equal [
            (weight-specified [25 25 25 15 10] [
              (asset "EQUITIES::GSY//USD" "GSY")
              (asset "EQUITIES::PULS//USD" "PULS")
              (asset "EQUITIES::BIL//USD" "BIL")
              (group "NOVA | Tangency Portfolio 19.1 (213/6.7)" [
                (weight-equal [
                  (weight-specified [45 15 25 15] [
                    (weight-specified [65 35] [
                      (group "U.S. Equities " [
                        (weight-equal [
                          (group "Small Cap | AutoTuned" [
                            (weight-equal [
                              (if (> (rsi "EQUITIES::IDLV//USD" 10) 74) [
                                (group "Catch Basket" [
                                  (weight-equal [
                                    (asset "EQUITIES::VIXY//USD" "VIXY")
                                    (asset "EQUITIES::EDZ//USD" "EDZ")
                                    (asset "EQUITIES::ZSL//USD" "ZSL")
                                  ])
                                ])
                              ] [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::RZV//USD" 10) 74) [
                                    (group "Catch Basket" [
                                      (weight-equal [
                                        (asset "EQUITIES::VIXY//USD" "VIXY")
                                        (asset "EQUITIES::EDZ//USD" "EDZ")
                                        (asset "EQUITIES::ZSL//USD" "ZSL")
                                      ])
                                    ])
                                  ] [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::PSCU//USD" 10) 75) [
                                        (group "Catch Basket" [
                                          (weight-equal [
                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                            (asset "EQUITIES::EDZ//USD" "EDZ")
                                            (asset "EQUITIES::ZSL//USD" "ZSL")
                                          ])
                                        ])
                                      ] [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::IWM//USD" 14) 20) [
                                            (asset "EQUITIES::TNA//USD" "TNA")
                                          ] [
                                            (weight-equal [
                                              (if (> (current-price "EQUITIES::RINF//USD" 10) (moving-average-price "EQUITIES::RINF//USD" 50)) [
                                                (weight-equal [
                                                  (if (> (current-price "EQUITIES::IWM//USD" 10) (moving-average-price "EQUITIES::IWM//USD" 200)) [
                                                    (weight-equal [
                                                      (group "SMMUvMXI" [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::SMMU//USD" 10) (rsi "EQUITIES::MXI//USD" 10)) [
                                                            (asset "EQUITIES::TNA//USD" "TNA")
                                                          ] [
                                                            (group "SMMUvMXI ELSE" [
                                                              (weight-equal [
                                                                (asset "EQUITIES::DRV//USD" "DRV")
                                                                (asset "EQUITIES::EDZ//USD" "EDZ")
                                                                (asset "EQUITIES::BIS//USD" "BIS")
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ] [
                                                    (group "AGGvXPP" [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::AGG//USD" 10) (rsi "EQUITIES::XPP//USD" 10)) [
                                                          (asset "EQUITIES::TNA//USD" "TNA")
                                                        ] [
                                                          (group "AGGvXPP ELSE" [
                                                            (weight-equal [
                                                              (asset "EQUITIES::TZA//USD" "TZA")
                                                              (asset "EQUITIES::EDZ//USD" "EDZ")
                                                              (asset "EQUITIES::SMDD//USD" "SMDD")
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ] [
                                                (group "PHBvEMLP" [
                                                  (weight-equal [
                                                    (if (> (rsi "EQUITIES::IFLN//USD" 10) (rsi "EQUITIES::EMLP//USD" 10)) [
                                                      (asset "EQUITIES::TNA//USD" "TNA")
                                                    ] [
                                                      (group "PHBvEMLP ELSE" [
                                                        (weight-equal [
                                                          (asset "EQUITIES::TYD//USD" "TYD")
                                                          (asset "EQUITIES::EDV//USD" "EDV")
                                                          (asset "EQUITIES::SPTL//USD" "SPTL")
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                          (group "US | AutoSignals" [
                            (weight-equal [
                              (if (> (rsi "EQUITIES::QABA//USD" 10) 81) [
                                (group "Catch Basket" [
                                  (weight-equal [
                                    (asset "EQUITIES::ECON//USD" "ECON")
                                    (asset "EQUITIES::BTAL//USD" "BTAL")
                                    (asset "EQUITIES::VIXM//USD" "VIXM")
                                  ])
                                ])
                              ] [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::EEV//USD" 10) 77) [
                                    (group "Catch Basket" [
                                      (weight-equal [
                                        (asset "EQUITIES::ECON//USD" "ECON")
                                        (asset "EQUITIES::BTAL//USD" "BTAL")
                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                      ])
                                    ])
                                  ] [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::IEF//USD" 10) 77) [
                                        (group "Catch Basket" [
                                          (weight-equal [
                                            (asset "EQUITIES::ECON//USD" "ECON")
                                            (asset "EQUITIES::BTAL//USD" "BTAL")
                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                          ])
                                        ])
                                      ] [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::QQQ//USD" 14) 30) [
                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                          ] [
                                            (weight-equal [
                                              (if (> (current-price "EQUITIES::RINF//USD" 10) (moving-average-price "EQUITIES::RINF//USD" 50)) [
                                                (weight-equal [
                                                  (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 200)) [
                                                    (weight-equal [
                                                      (group "STIPvRPG" [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::STIP//USD" 10) (rsi "EQUITIES::RPG//USD" 10)) [
                                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                          ] [
                                                            (group "STIPvRPG ELSE" [
                                                              (weight-equal [
                                                                (asset "EQUITIES::EEV//USD" "EEV")
                                                                (asset "EQUITIES::EPV//USD" "EPV")
                                                                (asset "EQUITIES::SRS//USD" "SRS")
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ] [
                                                    (group "AGZvIDU" [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::AGZ//USD" 10) (rsi "EQUITIES::IDU//USD" 10)) [
                                                          (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                        ] [
                                                          (group "AGZvIDU ELSE" [
                                                            (weight-equal [
                                                              (asset "EQUITIES::QID//USD" "QID")
                                                              (asset "EQUITIES::REW//USD" "REW")
                                                              (asset "EQUITIES::SPXS//USD" "SPXS")
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ] [
                                                (group "CORPvMOAT" [
                                                  (weight-equal [
                                                    (if (> (rsi "EQUITIES::CORP//USD" 10) (rsi "EQUITIES::MOAT//USD" 10)) [
                                                      (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                    ] [
                                                      (group "CORPvMOAT ELSE" [
                                                        (weight-equal [
                                                          (asset "EQUITIES::EDZ//USD" "EDZ")
                                                          (asset "EQUITIES::TECS//USD" "TECS")
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
                      (group "International Equities" [
                        (weight-equal [
                          (group "EM | AutoTuned" [
                            (weight-equal [
                              (if (> (rsi "EQUITIES::SHY//USD" 10) 78) [
                                (group "Catch Basket" [
                                  (weight-equal [
                                    (asset "EQUITIES::KOLD//USD" "KOLD")
                                    (asset "EQUITIES::SCO//USD" "SCO")
                                    (asset "EQUITIES::EEMO//USD" "EEMO")
                                  ])
                                ])
                              ] [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::ISTB//USD" 10) 80) [
                                    (group "Catch Basket" [
                                      (weight-equal [
                                        (asset "EQUITIES::KOLD//USD" "KOLD")
                                        (asset "EQUITIES::SCO//USD" "SCO")
                                        (asset "EQUITIES::EEMO//USD" "EEMO")
                                      ])
                                    ])
                                  ] [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::VMBS//USD" 10) 74) [
                                        (group "Catch Basket" [
                                          (weight-equal [
                                            (asset "EQUITIES::KOLD//USD" "KOLD")
                                            (asset "EQUITIES::SCO//USD" "SCO")
                                            (asset "EQUITIES::EEMO//USD" "EEMO")
                                          ])
                                        ])
                                      ] [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::EEM//USD" 14) 30) [
                                            (asset "EQUITIES::EDC//USD" "EDC")
                                          ] [
                                            (weight-equal [
                                              (if (> (current-price "EQUITIES::RINF//USD" 10) (moving-average-price "EQUITIES::RINF//USD" 50)) [
                                                (weight-equal [
                                                  (if (> (current-price "EQUITIES::EEM//USD" 10) (moving-average-price "EQUITIES::EEM//USD" 200)) [
                                                    (weight-equal [
                                                      (group "SHYvIWM" [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::SHY//USD" 10) (rsi "EQUITIES::IWM//USD" 10)) [
                                                            (asset "EQUITIES::EDC//USD" "EDC")
                                                          ] [
                                                            (asset "EQUITIES::EDZ//USD" "EDZ")
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ] [
                                                    (weight-equal [
                                                      (group "IGIBvVPL" [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::IGIB//USD" 10) (rsi "EQUITIES::VPL//USD" 10)) [
                                                            (asset "EQUITIES::EDC//USD" "EDC")
                                                          ] [
                                                            (asset "EQUITIES::EDZ//USD" "EDZ")
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ] [
                                                (weight-equal [
                                                  (group "CORPvIMCV" [
                                                    (weight-equal [
                                                      (if (> (rsi "EQUITIES::CORP//USD" 10) (rsi "EQUITIES::IMCV//USD" 10)) [
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
                    (group "Bonds" [
                      (weight-specified [100] [
                        (group "Treasury Bonds" [
                          (weight-specified [100] [
                            (weight-specified [20 10 10 20 20 20] [
                              (group "BIL" [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                  ] [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::VTV//USD" 10) 79) [
                                        (asset "EQUITIES::BIL//USD" "BIL")
                                      ] [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::VOX//USD" 10) 79) [
                                            (asset "EQUITIES::BIL//USD" "BIL")
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::TECL//USD" 10) 79) [
                                                (asset "EQUITIES::BIL//USD" "BIL")
                                              ] [
                                                (weight-equal [
                                                  (if (> (rsi "EQUITIES::VOOG//USD" 10) 79) [
                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                  ] [
                                                    (weight-equal [
                                                      (if (> (rsi "EQUITIES::VOOV//USD" 10) 79) [
                                                        (asset "EQUITIES::BIL//USD" "BIL")
                                                      ] [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::XLP//USD" 10) 75) [
                                                            (asset "EQUITIES::BIL//USD" "BIL")
                                                          ] [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::TQQQ//USD" 10) 79) [
                                                                (asset "EQUITIES::BIL//USD" "BIL")
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (rsi "EQUITIES::FAS//USD" 10) 80) [
                                                                    (asset "EQUITIES::BIL//USD" "BIL")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (rsi "EQUITIES::UVXY//USD" 21) 65) [
                                                                            (weight-equal [
                                                                              (if (> (rsi "EQUITIES::SPY//USD" 21) 30) [
                                                                                (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                              ] [
                                                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                              ])
                                                                            ])
                                                                          ] [
                                                                            (group "Dividends" [
                                                                              (weight-equal [
                                                                                (group "Dividends Jedi" [
                                                                                  (weight-equal [
                                                                                    (if (> (rsi "EQUITIES::XLK//USD" 126) (rsi "EQUITIES::XLP//USD" 126)) [
                                                                                      (weight-equal [
                                                                                        (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                                          (weight-equal [
                                                                                            (filter (moving-average-return 5) (select-bottom 1) [
                                                                                              (asset "EQUITIES::TECL//USD" "TECL")
                                                                                              (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                              (asset "EQUITIES::TMF//USD" "TMF")
                                                                                            ])
                                                                                          ])
                                                                                        ] [
                                                                                          (weight-equal [
                                                                                            (if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5) [
                                                                                              (group "Volatility or Short" [
                                                                                                (weight-equal [
                                                                                                  (if (< (moving-average-return "EQUITIES::VIXY//USD" 5) 0) [
                                                                                                    (weight-equal [
                                                                                                      (if (> (rsi "EQUITIES::VIXY//USD" 10) 50) [
                                                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                      ] [
                                                                                                        (weight-equal [
                                                                                                          (filter (exponential-moving-average-price 5) (select-bottom 1) [
                                                                                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                            (asset "EQUITIES::SH//USD" "SH")
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ] [
                                                                                                    (weight-equal [
                                                                                                      (filter (exponential-moving-average-price 5) (select-bottom 1) [
                                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                        (asset "EQUITIES::SH//USD" "SH")
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ] [
                                                                                              (group "v1.2 | Jedi" [
                                                                                                (weight-specified [70 30] [
                                                                                                  (group "Bull or Safety" [
                                                                                                    (weight-equal [
                                                                                                      (if (> (moving-average-return "EQUITIES::BND//USD" 10) (moving-average-return "EQUITIES::PST//USD" 10)) [
                                                                                                        (weight-specified [70 30] [
                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                          (filter (rsi 12) (select-bottom 1) [
                                                                                                            (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                          ])
                                                                                                        ])
                                                                                                      ] [
                                                                                                        (weight-specified [70 30] [
                                                                                                          (filter (rsi 12) (select-bottom 1) [
                                                                                                            (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                            (asset "EQUITIES::UGL//USD" "UGL")
                                                                                                            (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                          ])
                                                                                                          (filter (rsi 12) (select-bottom 1) [
                                                                                                            (asset "EQUITIES::DBC//USD" "DBC")
                                                                                                            (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                            (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                          ])
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                  (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                                                                          (group "Dip Buy" [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::VIXY//USD" 10) 50) [
                                                                                                (weight-equal [
                                                                                                  (filter (standard-deviation-price 5) (select-bottom 1) [
                                                                                                    (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                    (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                    (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                  ])
                                                                                                ])
                                                                                              ] [
                                                                                                (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ] [
                                                                                          (group "v1.2 | Jedi" [
                                                                                            (weight-specified [70 30] [
                                                                                              (group "Bull or Safety" [
                                                                                                (weight-equal [
                                                                                                  (if (> (moving-average-return "EQUITIES::BND//USD" 10) (moving-average-return "EQUITIES::PST//USD" 10)) [
                                                                                                    (weight-specified [70 30] [
                                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                      (filter (rsi 12) (select-bottom 1) [
                                                                                                        (asset "EQUITIES::TMF//USD" "TMF")
                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                      ])
                                                                                                    ])
                                                                                                  ] [
                                                                                                    (weight-specified [70 30] [
                                                                                                      (filter (rsi 12) (select-bottom 1) [
                                                                                                        (asset "EQUITIES::BTAL//USD" "BTAL")
                                                                                                        (asset "EQUITIES::UGL//USD" "UGL")
                                                                                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                                                                                      ])
                                                                                                      (filter (rsi 12) (select-bottom 1) [
                                                                                                        (asset "EQUITIES::DBC//USD" "DBC")
                                                                                                        (asset "EQUITIES::TMV//USD" "TMV")
                                                                                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                              (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                                (group "Dip Buy + Dividends" [
                                                                                  (weight-equal [
                                                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 30) [
                                                                                      (asset "EQUITIES::TECL//USD" "TECL")
                                                                                    ] [
                                                                                      (weight-equal [
                                                                                        (if (< (rsi "EQUITIES::SOXL//USD" 10) 30) [
                                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                        ] [
                                                                                          (weight-equal [
                                                                                            (if (< (rsi "EQUITIES::UPRO//USD" 10) 30) [
                                                                                              (asset "EQUITIES::UPRO//USD" "UPRO")
                                                                                            ] [
                                                                                              (asset "EQUITIES::SCHD//USD" "SCHD")
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                              (group "IEI" [
                                (weight-equal [
                                  (if (> (exponential-moving-average-price "EQUITIES::IEI//USD" 50) (exponential-moving-average-price "EQUITIES::IEI//USD" 25)) [
                                    (weight-equal [
                                      (if (> (exponential-moving-average-price "EQUITIES::IEI//USD" 25) (exponential-moving-average-price "EQUITIES::IEI//USD" 9)) [
                                        (weight-equal [
                                          (if (> (exponential-moving-average-price "EQUITIES::IEI//USD" 9) (exponential-moving-average-price "EQUITIES::IEI//USD" 5)) [
                                            (asset "EQUITIES::BIL//USD" "BIL")
                                          ] [
                                            (asset "EQUITIES::IEI//USD" "IEI")
                                          ])
                                        ])
                                      ] [
                                        (asset "EQUITIES::BIL//USD" "BIL")
                                      ])
                                    ])
                                  ] [
                                    (asset "EQUITIES::BIL//USD" "BIL")
                                  ])
                                ])
                              ])
                              (group "IEF" [
                                (weight-equal [
                                  (weight-equal [
                                    (if (> (exponential-moving-average-price "EQUITIES::IEI//USD" 50) (exponential-moving-average-price "EQUITIES::IEI//USD" 25)) [
                                      (weight-equal [
                                        (if (> (exponential-moving-average-price "EQUITIES::IEI//USD" 25) (exponential-moving-average-price "EQUITIES::IEI//USD" 9)) [
                                          (weight-equal [
                                            (if (> (exponential-moving-average-price "EQUITIES::IEI//USD" 9) (exponential-moving-average-price "EQUITIES::IEI//USD" 5)) [
                                              (asset "EQUITIES::BIL//USD" "BIL")
                                            ] [
                                              (asset "EQUITIES::IEF//USD" "IEF")
                                            ])
                                          ])
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
                              (group "TLT" [
                                (weight-equal [
                                  (weight-equal [
                                    (if (> (moving-average-price "EQUITIES::TLT//USD" 350) (moving-average-price "EQUITIES::TLT//USD" 550)) [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::TLT//USD" 60) 62) [
                                          (asset "EQUITIES::SHY//USD" "SHY")
                                        ] [
                                          (asset "EQUITIES::TLT//USD" "TLT")
                                        ])
                                      ])
                                    ] [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::TLT//USD" 60) 53) [
                                          (asset "EQUITIES::TLT//USD" "TLT")
                                        ] [
                                          (asset "EQUITIES::SHV//USD" "SHV")
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                              (group "TIP" [
                                (weight-equal [
                                  (weight-equal [
                                    (if (> (exponential-moving-average-price "EQUITIES::IEI//USD" 50) (exponential-moving-average-price "EQUITIES::IEI//USD" 25)) [
                                      (weight-equal [
                                        (if (> (exponential-moving-average-price "EQUITIES::IEI//USD" 25) (exponential-moving-average-price "EQUITIES::IEI//USD" 9)) [
                                          (weight-equal [
                                            (if (> (exponential-moving-average-price "EQUITIES::IEI//USD" 9) (exponential-moving-average-price "EQUITIES::IEI//USD" 5)) [
                                              (asset "EQUITIES::BIL//USD" "BIL")
                                            ] [
                                              (asset "EQUITIES::TIP//USD" "TIP")
                                            ])
                                          ])
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
                              (group "TIP/TMV" [
                                (weight-equal [
                                  (weight-equal [
                                    (if (> (current-price "EQUITIES::TLT//USD" 10) (moving-average-price "EQUITIES::TLT//USD" 200)) [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::QLD//USD" 10) 79) [
                                          (asset "EQUITIES::TMF//USD" "TMF")
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
                                                      (asset "EQUITIES::QLD//USD" "QLD")
                                                    ])
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::QLD//USD" 10) 31) [
                                                      (asset "EQUITIES::QLD//USD" "QLD")
                                                    ] [
                                                      (asset "EQUITIES::ILCG//USD" "ILCG")
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
                            ])
                          ])
                        ])
                      ])
                    ])
                    (group "Commodities and Volatility " [
                      (weight-specified [100] [
                        (weight-equal [
                          (group "US Dollar Strength" [
                            (weight-equal [
                              (if (> (moving-average-price "EQUITIES::UUP//USD" 21) (moving-average-price "EQUITIES::UUP//USD" 210)) [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::SPY//USD" 60) 60) [
                                    (weight-equal [
                                      (asset "EQUITIES::TLT//USD" "TLT")
                                    ])
                                  ] [
                                    (asset "EQUITIES::UUP//USD" "UUP")
                                  ])
                                ])
                              ] [
                                (asset "EQUITIES::SHY//USD" "SHY")
                              ])
                            ])
                          ])
                          (group "Commodities Macro Momentum" [
                            (weight-equal [
                              (if (> (moving-average-price "EQUITIES::DBC//USD" 100) (moving-average-price "EQUITIES::DBC//USD" 252)) [
                                (weight-equal [
                                  (if (> (moving-average-price "EQUITIES::DBC//USD" 50) (moving-average-price "EQUITIES::DBC//USD" 100)) [
                                    (asset "EQUITIES::DBC//USD" "DBC")
                                  ] [
                                    (asset "EQUITIES::SHY//USD" "SHY")
                                  ])
                                ])
                              ] [
                                (asset "EQUITIES::SHY//USD" "SHY")
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
                          (group "Codebreaker (10d OILU) | Highest AR" [
                            (weight-equal [
                              (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                (group "Above 200d" [
                                  (weight-equal [
                                    (group "WTMF > CANE" [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::WTMF//USD" 10) (rsi "EQUITIES::CANE//USD" 10)) [
                                          (asset "EQUITIES::OILU//USD" "OILU")
                                        ] [
                                          (asset "EQUITIES::OILD//USD" "OILD")
                                        ])
                                      ])
                                    ])
                                    (group "IVE > UPV" [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::IVE//USD" 10) (rsi "EQUITIES::UPV//USD" 10)) [
                                          (asset "EQUITIES::OILU//USD" "OILU")
                                        ] [
                                          (asset "EQUITIES::OILD//USD" "OILD")
                                        ])
                                      ])
                                    ])
                                    (group "KIE > SVXY" [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::KIE//USD" 10) (rsi "EQUITIES::SVXY//USD" 10)) [
                                          (asset "EQUITIES::OILU//USD" "OILU")
                                        ] [
                                          (asset "EQUITIES::OILD//USD" "OILD")
                                        ])
                                      ])
                                    ])
                                    (group "GGME > YANG (?)" [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::GGME//USD" 10) (rsi "EQUITIES::YANG//USD" 10)) [
                                          (asset "EQUITIES::OILU//USD" "OILU")
                                        ] [
                                          (asset "EQUITIES::OILD//USD" "OILD")
                                        ])
                                      ])
                                    ])
                                    (group "UYG > SPLV" [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::UYG//USD" 10) (rsi "EQUITIES::SPLV//USD" 10)) [
                                          (asset "EQUITIES::OILU//USD" "OILU")
                                        ] [
                                          (asset "EQUITIES::OILD//USD" "OILD")
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ] [
                                (group "Below 200d" [
                                  (weight-equal [
                                    (group "PBE > RXI" [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::PBE//USD" 10) (rsi "EQUITIES::RXI//USD" 10)) [
                                          (asset "EQUITIES::OILU//USD" "OILU")
                                        ] [
                                          (asset "EQUITIES::OILD//USD" "OILD")
                                        ])
                                      ])
                                    ])
                                    (group "VOT > ITA" [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::VOT//USD" 10) (rsi "EQUITIES::ITA//USD" 10)) [
                                          (asset "EQUITIES::OILU//USD" "OILU")
                                        ] [
                                          (asset "EQUITIES::OILD//USD" "OILD")
                                        ])
                                      ])
                                    ])
                                    (group "SPSB > EWH" [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::SPSB//USD" 10) (rsi "EQUITIES::EWH//USD" 10)) [
                                          (asset "EQUITIES::OILU//USD" "OILU")
                                        ] [
                                          (asset "EQUITIES::OILD//USD" "OILD")
                                        ])
                                      ])
                                    ])
                                    (group "PHB > FXC" [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::IFLN//USD" 10) (rsi "EQUITIES::FXC//USD" 10)) [
                                          (asset "EQUITIES::OILU//USD" "OILU")
                                        ] [
                                          (asset "EQUITIES::OILD//USD" "OILD")
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                    (group "Infrastructure/Hedge" [
                      (weight-equal [
                        (group "Black Swan Catcher" [
                          (weight-equal [
                            (weight-equal [
                              (if (< (cumulative-return "EQUITIES::SPY//USD" 20) -10) [
                                (weight-equal [
                                  (if (< (cumulative-return "EQUITIES::SPY//USD" 20) -25) [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                        (asset "EQUITIES::TECL//USD" "TECL")
                                      ] [
                                        (asset "EQUITIES::BIL//USD" "BIL")
                                      ])
                                    ])
                                  ] [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::TQQQ//USD" 10) 31) [
                                        (asset "EQUITIES::TECL//USD" "TECL")
                                      ] [
                                        (asset "EQUITIES::VIXM//USD" "VIXM")
                                      ])
                                    ])
                                  ])
                                ])
                              ] [
                                (weight-equal [
                                  (group "100% Win Rate UVXY" [
                                    (weight-equal [
                                      (if (> (rsi "EQUITIES::TQQQ//USD" 10) 81) [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::UVXY//USD" 60) 40) [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                          ] [
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                          ])
                                        ])
                                      ] [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::UVXY//USD" 60) 40) [
                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                              ] [
                                                (asset "EQUITIES::SHV//USD" "SHV")
                                              ])
                                            ])
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
                        ])
                        (group "Hedge" [
                          (weight-equal [
                            (weight-equal [
                              (weight-specified [10 10 10 40 20 10] [
                                (group "Commodities Macro Momentum" [
                                  (weight-equal [
                                    (if (> (moving-average-price "EQUITIES::DBC//USD" 100) (moving-average-price "EQUITIES::DBC//USD" 252)) [
                                      (weight-equal [
                                        (if (> (moving-average-price "EQUITIES::DBC//USD" 50) (moving-average-price "EQUITIES::DBC//USD" 100)) [
                                          (asset "EQUITIES::DBC//USD" "DBC")
                                        ] [
                                          (asset "EQUITIES::SHV//USD" "SHV")
                                        ])
                                      ])
                                    ] [
                                      (asset "EQUITIES::SHV//USD" "SHV")
                                    ])
                                  ])
                                ])
                                (group "GLD Macro Momentum" [
                                  (weight-equal [
                                    (if (> (moving-average-price "EQUITIES::GLD//USD" 200) (moving-average-price "EQUITIES::GLD//USD" 350)) [
                                      (weight-equal [
                                        (if (> (moving-average-price "EQUITIES::GLD//USD" 60) (moving-average-price "EQUITIES::GLD//USD" 150)) [
                                          (asset "EQUITIES::GLD//USD" "GLD")
                                        ] [
                                          (asset "EQUITIES::SHV//USD" "SHV")
                                        ])
                                      ])
                                    ] [
                                      (asset "EQUITIES::SHV//USD" "SHV")
                                    ])
                                  ])
                                ])
                                (group "IEF Macro Momentum" [
                                  (weight-equal [
                                    (if (> (moving-average-price "EQUITIES::IEF//USD" 200) (moving-average-price "EQUITIES::IEF//USD" 450)) [
                                      (asset "EQUITIES::IEF//USD" "IEF")
                                    ] [
                                      (asset "EQUITIES::SHV//USD" "SHV")
                                    ])
                                  ])
                                ])
                                (group "Equities Momentum" [
                                  (weight-equal [
                                    (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::QQQ//USD" 10) 80) [
                                          (asset "EQUITIES::SHV//USD" "SHV")
                                        ] [
                                          (weight-equal [
                                            (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                              (asset "EQUITIES::SHV//USD" "SHV")
                                            ] [
                                              (weight-equal [
                                                (if (> (rsi "EQUITIES::SPY//USD" 60) 60) [
                                                  (weight-equal [
                                                    (asset "EQUITIES::SHV//USD" "SHV")
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (asset "EQUITIES::QQQ//USD" "QQQ")
                                                    (asset "EQUITIES::SPY//USD" "SPY")
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ] [
                                      (weight-equal [
                                        (if (< (rsi "EQUITIES::QQQ//USD" 10) 30) [
                                          (asset "EQUITIES::XLK//USD" "XLK")
                                        ] [
                                          (weight-specified [60 40] [
                                            (asset "EQUITIES::SHV//USD" "SHV")
                                            (group "Bear Market Sideways Protection 2008 Edition" [
                                              (weight-equal [
                                                (weight-equal [
                                                  (if (< (cumulative-return "EQUITIES::QQQ//USD" 252) -20) [
                                                    (weight-equal [
                                                      (group "Nasdaq In Crash Territory, Time to Deleverage" [
                                                        (weight-equal [
                                                          (if (< (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 20)) [
                                                            (weight-equal [
                                                              (if (<= (cumulative-return "EQUITIES::QQQ//USD" 60) -12) [
                                                                (group "Sideways Market Deleverage" [
                                                                  (weight-equal [
                                                                    (weight-equal [
                                                                      (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 20)) [
                                                                        (asset "EQUITIES::SPY//USD" "SPY")
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (rsi "EQUITIES::TLT//USD" 10) (rsi "EQUITIES::PSQ//USD" 10)) [
                                                                            (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                          ] [
                                                                            (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                          ])
                                                                        ])
                                                                      ])
                                                                      (if (> (rsi "EQUITIES::TLT//USD" 10) (rsi "EQUITIES::PSQ//USD" 10)) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                      ] [
                                                                        (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (rsi "EQUITIES::TLT//USD" 10) (rsi "EQUITIES::PSQ//USD" 10)) [
                                                                    (asset "EQUITIES::QLD//USD" "QLD")
                                                                  ] [
                                                                    (asset "EQUITIES::QID//USD" "QID")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ] [
                                                            (weight-equal [
                                                              (if (< (rsi "EQUITIES::PSQ//USD" 10) 31) [
                                                                (asset "EQUITIES::PSQ//USD" "PSQ")
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (cumulative-return "EQUITIES::QQQ//USD" 10) 5.5) [
                                                                    (asset "EQUITIES::PSQ//USD" "PSQ")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (filter (rsi 10) (select-top 1) [
                                                                        (asset "EQUITIES::QQQ//USD" "QQQ")
                                                                        (asset "EQUITIES::SOXX//USD" "SOXX")
                                                                      ])
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
                                                      (if (< (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 20)) [
                                                        (weight-equal [
                                                          (weight-equal [
                                                            (if (> (rsi "EQUITIES::TLT//USD" 10) (rsi "EQUITIES::PSQ//USD" 10)) [
                                                              (asset "EQUITIES::QLD//USD" "QLD")
                                                            ] [
                                                              (asset "EQUITIES::QID//USD" "QID")
                                                            ])
                                                          ])
                                                        ])
                                                      ] [
                                                        (weight-equal [
                                                          (if (< (rsi "EQUITIES::PSQ//USD" 10) 31) [
                                                            (asset "EQUITIES::QID//USD" "QID")
                                                          ] [
                                                            (weight-equal [
                                                              (if (> (cumulative-return "EQUITIES::QQQ//USD" 10) 5.5) [
                                                                (asset "EQUITIES::QID//USD" "QID")
                                                              ] [
                                                                (weight-equal [
                                                                  (filter (rsi 10) (select-top 1) [
                                                                    (asset "EQUITIES::QLD//USD" "QLD")
                                                                    (asset "EQUITIES::USD//USD" "USD")
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                                (group "U.S. Dollar" [
                                  (weight-equal [
                                    (if (> (exponential-moving-average-price "EQUITIES::UUP//USD" 50) (exponential-moving-average-price "EQUITIES::UUP//USD" 100)) [
                                      (asset "EQUITIES::UUP//USD" "UUP")
                                    ] [
                                      (asset "EQUITIES::SHV//USD" "SHV")
                                    ])
                                  ])
                                ])
                                (group "XLP Easy Money" [
                                  (weight-equal [
                                    (if (> (exponential-moving-average-price "EQUITIES::XLP//USD" 8) (moving-average-price "EQUITIES::XLP//USD" 50)) [
                                      (weight-equal [
                                        (asset "EQUITIES::XLP//USD" "XLP")
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
                        (group "VIX BALLER UVXY | SPY & GLD | v1" [
                          (weight-equal [
                            (group "Volatility Bomb Block from Ease Up on the Gas V2a (add a little nitro)" [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::UVXY//USD" 21) 65) [
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
                                ] [
                                  (weight-equal [
                                    (group "VIX Baller v1" [
                                      (weight-equal [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::IOO//USD" 10) 80) [
                                            (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                ] [
                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                    ] [
                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                                          (group "Upleveraged V1 BWC: Ultimate Frontrunner" [
                                                                                            (weight-equal [
                                                                                              (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                                                                                                (group "Upleveraged Mod of BWC Scale In VIX w/ VIXY RSI Check " [
                                                                                                  (weight-equal [
                                                                                                    (if (> (rsi "EQUITIES::VIXY//USD" 60) 40) [
                                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                    ] [
                                                                                                      (weight-equal [
                                                                                                        (if (> (rsi "EQUITIES::SPY//USD" 10) 82.5) [
                                                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                        ] [
                                                                                                          (group "1.5x VIX Group" [
                                                                                                            (weight-equal [
                                                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                                                      (group "Upleveraged Mod of BWC Scale In VIX w/ VIXY RSI Check " [
                                                                                                        (weight-equal [
                                                                                                          (if (> (rsi "EQUITIES::VIXY//USD" 60) 40) [
                                                                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                          ] [
                                                                                                            (weight-equal [
                                                                                                              (if (> (rsi "EQUITIES::QQQ//USD" 10) 82.5) [
                                                                                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                              ] [
                                                                                                                (group "1.5x VIX Group" [
                                                                                                                  (weight-equal [
                                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                                                                (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                              ] [
                                                                                                                (weight-equal [
                                                                                                                  (if (> (rsi "EQUITIES::IOO//USD" 10) 82.5) [
                                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                  ] [
                                                                                                                    (group "1.5x VIX Group" [
                                                                                                                      (weight-equal [
                                                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                ] [
                                                                                                                  (group "1.5x VIX Group" [
                                                                                                                    (weight-equal [
                                                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                    ] [
                                                                                                                      (group "1.5x VIX Group" [
                                                                                                                        (weight-equal [
                                                                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                        ] [
                                                                                                                          (group "1.5x VIX Group" [
                                                                                                                            (weight-equal [
                                                                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                            ] [
                                                                                                                              (group "1.5x VIX Group" [
                                                                                                                                (weight-equal [
                                                                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                ] [
                                                                                                                                  (group "1.5x VIX Group" [
                                                                                                                                    (weight-equal [
                                                                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                                                                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                    ] [
                                                                                                                                      (group "1.5x VIX Group" [
                                                                                                                                        (weight-equal [
                                                                                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                          (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                                                                                                      (asset "EQUITIES::FNGG//USD" "FNGG")
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
                                                                                                                                                (if (< (rsi "EQUITIES::FNGG//USD" 10) 25) [
                                                                                                                                                  (asset "EQUITIES::FNGG//USD" "FNGG")
                                                                                                                                                ] [
                                                                                                                                                  (weight-equal [
                                                                                                                                                    (if (< (rsi "EQUITIES::TQQQ//USD" 10) 28) [
                                                                                                                                                      (weight-equal [
                                                                                                                                                        (filter (rsi 10) (select-bottom 2) [
                                                                                                                                                          (asset "EQUITIES::SOXL//USD" "SOXL")
                                                                                                                                                          (asset "EQUITIES::TECL//USD" "TECL")
                                                                                                                                                          (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                                                                                                                          (asset "EQUITIES::FNGG//USD" "FNGG")
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
                                                                                                                                                              (group "Upleveraged Anansi's Scale-in" [
                                                                                                                                                                (weight-equal [
                                                                                                                                                                  (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                                                                                                                                    (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                                                  ] [
                                                                                                                                                                    (weight-equal [
                                                                                                                                                                      (if (> (rsi "EQUITIES::IOO//USD" 10) 80) [
                                                                                                                                                                        (group "Scale-In | VIX+ -> VIX++" [
                                                                                                                                                                          (weight-equal [
                                                                                                                                                                            (if (> (rsi "EQUITIES::IOO//USD" 10) 82.5) [
                                                                                                                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                                                            ] [
                                                                                                                                                                              (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                                                            ])
                                                                                                                                                                          ])
                                                                                                                                                                        ])
                                                                                                                                                                      ] [
                                                                                                                                                                        (weight-equal [
                                                                                                                                                                          (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                                                                                                                                                                            (group "Scale-In | VIX+ -> VIX++" [
                                                                                                                                                                              (weight-equal [
                                                                                                                                                                                (if (> (rsi "EQUITIES::QQQ//USD" 10) 82.5) [
                                                                                                                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                                                                ] [
                                                                                                                                                                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                                                                ])
                                                                                                                                                                              ])
                                                                                                                                                                            ])
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
                                                                                                                                                                                      (if (> (rsi "EQUITIES::XLF//USD" 10) 81) [
                                                                                                                                                                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                                                                                                                                                                      ] [
                                                                                                                                                                                        (weight-equal [
                                                                                                                                                                                          (if (> (rsi "EQUITIES::FNGG//USD" 10) 83) [
                                                                                                                                                                                            (asset "EQUITIES::UVXY//USD" "UVXY")
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
                                                                                                                                                                                                                          (group "SVXY" [
                                                                                                                                                                                                                            (weight-equal [
                                                                                                                                                                                                                              (if (> (max-drawdown "EQUITIES::SVXY//USD" 3) 20) [
                                                                                                                                                                                                                                (group "Volmageddon Protection" [
                                                                                                                                                                                                                                  (weight-equal [
                                                                                                                                                                                                                                    (asset "EQUITIES::BIL//USD" "BIL")
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
                                                                                                                                                                                                    (weight-equal [
                                                                                                                                                                                                      (asset "EQUITIES::SPY//USD" "SPY")
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
                                                                                                        ])
                                                                                                      ])
                                                                                                    ])
                                                                                                  ])
                                                                                                ])
                                                                                              ])
                                                                                            ])
                                                                                          ])
                                                                                        ])
                                                                                      ])
                                                                                    ])
                                                                                  ])
                                                                                ])
                                                                              ])
                                                                            ])
                                                                          ])
                                                                        ])
                                                                      ])
                                                                    ])
                                                                  ])
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                        (group "Tail Risk VIXM vs. SVXY" [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::VIXM//USD" 6) (rsi "EQUITIES::SVXY//USD" 12)) [
                              (weight-equal [
                                (if (> (current-price "EQUITIES::BTAL//USD" 10) (moving-average-price "EQUITIES::BTAL//USD" 300)) [
                                  (weight-equal [
                                    (asset "EQUITIES::BTAL//USD" "BTAL")
                                    (group "Risk Off Equities" [
                                      (weight-equal [
                                        (filter (moving-average-return 5) (select-top 3) [
                                          (asset "EQUITIES::XLU//USD" "XLU")
                                          (asset "EQUITIES::XLP//USD" "XLP")
                                          (asset "EQUITIES::ERX//USD" "ERX")
                                          (asset "EQUITIES::SCO//USD" "SCO")
                                        ])
                                      ])
                                    ])
                                    (filter (cumulative-return 7) (select-top 1) [
                                      (weight-specified {"SVXY" 65 "VIXY" 35} [
                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                        (asset "EQUITIES::VIXY//USD" "VIXY")
                                      ])
                                      (weight-specified {"SVXY" 35 "VIXY" 65} [
                                        (asset "EQUITIES::SVXY//USD" "SVXY")
                                        (asset "EQUITIES::VIXY//USD" "VIXY")
                                      ])
                                    ])
                                  ])
                                ] [
                                  (weight-equal [
                                    (group "DeETF FTLT | 2013-01-09" [
                                      (weight-equal [
                                        (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                          (group "Frontrunner -> DeETF" [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                              ] [
                                                (weight-equal [
                                                  (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                                                    (asset "EQUITIES::VIXY//USD" "VIXY")
                                                  ] [
                                                    (weight-equal [
                                                      (if (> (rsi "EQUITIES::XLK//USD" 10) 79) [
                                                        (asset "EQUITIES::VIXY//USD" "VIXY")
                                                      ] [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::IYY//USD" 10) 79) [
                                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                                          ] [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::VTV//USD" 10) 79) [
                                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (rsi "EQUITIES::XLP//USD" 10) 75) [
                                                                    (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (rsi "EQUITIES::XLF//USD" 10) 80) [
                                                                        (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                      ] [
                                                                        (weight-equal [
                                                                          (if (> (rsi "EQUITIES::VOX//USD" 10) 79) [
                                                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                          ] [
                                                                            (group "DeETF (20d CR - T3)" [
                                                                              (weight-equal [
                                                                                (filter (cumulative-return 20) (select-top 3) [
                                                                                  (asset "EQUITIES::MSFT//USD" "MSFT")
                                                                                  (asset "EQUITIES::AAPL//USD" "AAPL")
                                                                                  (asset "EQUITIES::NVDA//USD" "NVDA")
                                                                                  (asset "EQUITIES::AMZN//USD" "AMZN")
                                                                                  (asset "EQUITIES::GOOGL//USD" "GOOGL")
                                                                                  (asset "EQUITIES::META//USD" "META")
                                                                                  (asset "EQUITIES::BRK/B//USD" "BRK/B")
                                                                                  (asset "EQUITIES::LLY//USD" "LLY")
                                                                                  (asset "EQUITIES::NVO//USD" "NVO")
                                                                                  (asset "EQUITIES::TSLA//USD" "TSLA")
                                                                                  (asset "EQUITIES::PG//USD" "PG")
                                                                                  (asset "EQUITIES::COST//USD" "COST")
                                                                                  (asset "EQUITIES::MRK//USD" "MRK")
                                                                                  (asset "EQUITIES::ABBV//USD" "ABBV")
                                                                                  (asset "EQUITIES::AMD//USD" "AMD")
                                                                                  (asset "EQUITIES::ADBE//USD" "ADBE")
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
                                        ] [
                                          (group "High ROI Stocks, Bear Market Dip Buy" [
                                            (weight-equal [
                                              (filter (rsi 20) (select-bottom 2) [
                                                (asset "EQUITIES::CSCO//USD" "CSCO")
                                                (asset "EQUITIES::LOW//USD" "LOW")
                                                (asset "EQUITIES::BX//USD" "BX")
                                                (asset "EQUITIES::TECL//USD" "TECL")
                                                (asset "EQUITIES::SOXL//USD" "SOXL")
                                                (asset "EQUITIES::CURE//USD" "CURE")
                                                (asset "EQUITIES::BHP//USD" "BHP")
                                                (asset "EQUITIES::TMF//USD" "TMF")
                                                (asset "EQUITIES::COST//USD" "COST")
                                                (asset "EQUITIES::TSM//USD" "TSM")
                                                (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                                (asset "EQUITIES::TLT//USD" "TLT")
                                                (asset "EQUITIES::AGG//USD" "AGG")
                                                (asset "EQUITIES::AGG//USD" "AGG")
                                                (asset "EQUITIES::NKE//USD" "NKE")
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
                                (group "DeETF FTLT | 2013-01-09" [
                                  (weight-equal [
                                    (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
                                      (group "Frontrunner -> DeETF" [
                                        (weight-equal [
                                          (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                          ] [
                                            (weight-equal [
                                              (if (> (rsi "EQUITIES::QQQ//USD" 10) 79) [
                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                              ] [
                                                (weight-equal [
                                                  (if (> (rsi "EQUITIES::XLK//USD" 10) 79) [
                                                    (asset "EQUITIES::VIXY//USD" "VIXY")
                                                  ] [
                                                    (weight-equal [
                                                      (if (> (rsi "EQUITIES::IYY//USD" 10) 79) [
                                                        (asset "EQUITIES::VIXY//USD" "VIXY")
                                                      ] [
                                                        (weight-equal [
                                                          (if (> (rsi "EQUITIES::VTV//USD" 10) 79) [
                                                            (asset "EQUITIES::VIXY//USD" "VIXY")
                                                          ] [
                                                            (weight-equal [
                                                              (if (> (rsi "EQUITIES::XLP//USD" 10) 75) [
                                                                (asset "EQUITIES::VIXY//USD" "VIXY")
                                                              ] [
                                                                (weight-equal [
                                                                  (if (> (rsi "EQUITIES::XLF//USD" 10) 80) [
                                                                    (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                  ] [
                                                                    (weight-equal [
                                                                      (if (> (rsi "EQUITIES::VOX//USD" 10) 79) [
                                                                        (asset "EQUITIES::VIXY//USD" "VIXY")
                                                                      ] [
                                                                        (group "DeETF (20d CR - T3)" [
                                                                          (weight-equal [
                                                                            (filter (cumulative-return 20) (select-top 3) [
                                                                              (asset "EQUITIES::MSFT//USD" "MSFT")
                                                                              (asset "EQUITIES::AAPL//USD" "AAPL")
                                                                              (asset "EQUITIES::NVDA//USD" "NVDA")
                                                                              (asset "EQUITIES::AMZN//USD" "AMZN")
                                                                              (asset "EQUITIES::GOOGL//USD" "GOOGL")
                                                                              (asset "EQUITIES::META//USD" "META")
                                                                              (asset "EQUITIES::BRK/B//USD" "BRK/B")
                                                                              (asset "EQUITIES::LLY//USD" "LLY")
                                                                              (asset "EQUITIES::NVO//USD" "NVO")
                                                                              (asset "EQUITIES::TSLA//USD" "TSLA")
                                                                              (asset "EQUITIES::PG//USD" "PG")
                                                                              (asset "EQUITIES::COST//USD" "COST")
                                                                              (asset "EQUITIES::MRK//USD" "MRK")
                                                                              (asset "EQUITIES::ABBV//USD" "ABBV")
                                                                              (asset "EQUITIES::AMD//USD" "AMD")
                                                                              (asset "EQUITIES::ADBE//USD" "ADBE")
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
                                    ] [
                                      (group "High ROI Stocks, Bear Market Dip Buy" [
                                        (weight-equal [
                                          (filter (rsi 20) (select-bottom 2) [
                                            (asset "EQUITIES::CSCO//USD" "CSCO")
                                            (asset "EQUITIES::LOW//USD" "LOW")
                                            (asset "EQUITIES::BX//USD" "BX")
                                            (asset "EQUITIES::TECL//USD" "TECL")
                                            (asset "EQUITIES::SOXL//USD" "SOXL")
                                            (asset "EQUITIES::CURE//USD" "CURE")
                                            (asset "EQUITIES::BHP//USD" "BHP")
                                            (asset "EQUITIES::TMF//USD" "TMF")
                                            (asset "EQUITIES::COST//USD" "COST")
                                            (asset "EQUITIES::TSM//USD" "TSM")
                                            (asset "EQUITIES::TQQQ//USD" "TQQQ")
                                            (asset "EQUITIES::TLT//USD" "TLT")
                                            (asset "EQUITIES::AGG//USD" "AGG")
                                            (asset "EQUITIES::AGG//USD" "AGG")
                                            (asset "EQUITIES::NKE//USD" "NKE")
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
              ])
              (group "IFF Fund: 100% Win Rate UVXY 40%" [
                (weight-equal [
                  (if (> (rsi "EQUITIES::UVXY//USD" 60) 40) [
                    (weight-equal [
                      (if (> (rsi "EQUITIES::TQQQ//USD" 10) 81) [
                        (asset "EQUITIES::UVXY//USD" "UVXY")
                      ] [
                        (weight-equal [
                          (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ] [
                            (asset "EQUITIES::SHV//USD" "SHV")
                          ])
                        ])
                      ])
                    ])
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