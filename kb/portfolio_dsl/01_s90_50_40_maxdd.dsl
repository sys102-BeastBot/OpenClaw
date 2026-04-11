defsymphony "01 s90 50/40 maxDD (190/40 s10-18-11) 2.36sh 50.2sd" {:rebalance-frequency :none}
  (weight-equal [
    (group "s90 50/40 maxDD " [
      (weight-equal [
        (if (> (current-price "EQUITIES::SPY//USD" 10) (moving-average-price "EQUITIES::SPY//USD" 200)) [
          (weight-equal [
            (if (> (rsi "EQUITIES::UVXY//USD" 10) 84) [
              (asset "EQUITIES::SOXL//USD" "SOXL")
            ] [
              (weight-specified [79 21] [
                (if (> (rsi "EQUITIES::XLP//USD" 10) 77) [
                  (asset "EQUITIES::UVXY//USD" "UVXY")
                ] [
                  (weight-equal [
                    (if (> (rsi "EQUITIES::QQQ//USD" 10) 81) [
                      (weight-equal [
                        (asset "EQUITIES::UVXY//USD" "UVXY")
                      ])
                    ] [
                      (weight-equal [
                        (if (> (rsi "EQUITIES::SPY//USD" 10) 80) [
                          (asset "EQUITIES::UVXY//USD" "UVXY")
                        ] [
                          (weight-equal [
                            (if (> (rsi "EQUITIES::SPY//USD" 5) 88) [
                              (asset "EQUITIES::UVXY//USD" "UVXY")
                            ] [
                              (weight-equal [
                                (if (> (rsi "EQUITIES::QQQ//USD" 5) 92) [
                                  (asset "EQUITIES::UVXY//USD" "UVXY")
                                ] [
                                  (weight-equal [
                                    (if (> (rsi "EQUITIES::SPY//USD" 60) 65) [
                                      (asset "EQUITIES::UVXY//USD" "UVXY")
                                    ] [
                                      (weight-equal [
                                        (if (> (rsi "EQUITIES::SPY//USD" 200) 57) [
                                          (asset "EQUITIES::UVXY//USD" "UVXY")
                                          (asset "EQUITIES::BIL//USD" "BIL")
                                        ] [
                                          (weight-equal [
                                            (if (> (rsi "EQUITIES::SPY//USD" 10) 69) [
                                              (weight-equal [
                                                (asset "EQUITIES::UPRO//USD" "UPRO")
                                              ])
                                            ] [
                                              (weight-equal [
                                                (if (> (rsi "EQUITIES::QQQ//USD" 10) 53) [
                                                  (weight-equal [
                                                    (asset "EQUITIES::UPRO//USD" "UPRO")
                                                  ])
                                                ] [
                                                  (weight-equal [
                                                    (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                                      (asset "EQUITIES::UPRO//USD" "UPRO")
                                                    ] [
                                                      (weight-equal [
                                                        (if (< (rsi "EQUITIES::QQQ//USD" 10) 30) [
                                                          (asset "EQUITIES::UPRO//USD" "UPRO")
                                                        ] [
                                                          (asset "EQUITIES::UPRO//USD" "UPRO")
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                ])
                (asset "EQUITIES::XLP//USD" "XLP")
              ])
            ])
          ])
        ] [
          (group "Bear Market" [
            (weight-equal [
              (if (> (rsi "EQUITIES::UVXY//USD" 10) 84) [
                (asset "EQUITIES::SOXL//USD" "SOXL")
              ] [
                (weight-specified [79 7 7 7] [
                  (if (> (rsi "EQUITIES::XLP//USD" 10) 76) [
                    (asset "EQUITIES::UVXY//USD" "UVXY")
                  ] [
                    (weight-equal [
                      (if (> (rsi "EQUITIES::SPY//USD" 10) 72) [
                        (asset "EQUITIES::UVXY//USD" "UVXY")
                      ] [
                        (weight-equal [
                          (if (> (rsi "EQUITIES::QQQ//USD" 10) 77) [
                            (asset "EQUITIES::UVXY//USD" "UVXY")
                          ] [
                            (weight-equal [
                              (if (< (rsi "EQUITIES::QQQ//USD" 10) 28) [
                                (asset "EQUITIES::QLD//USD" "QLD")
                              ] [
                                (weight-equal [
                                  (if (> (rsi "EQUITIES::UVXY//USD" 10) 74) [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::UVXY//USD" 10) 84) [
                                        (asset "EQUITIES::UVXY//USD" "UVXY")
                                      ] [
                                        (asset "EQUITIES::SOXL//USD" "SOXL")
                                      ])
                                    ])
                                  ] [
                                    (weight-equal [
                                      (if (< (rsi "EQUITIES::QQQ//USD" 10) 28) [
                                        (weight-equal [
                                          (asset "EQUITIES::QLD//USD" "QLD")
                                        ])
                                      ] [
                                        (weight-equal [
                                          (if (< (rsi "EQUITIES::SPY//USD" 10) 30) [
                                            (asset "EQUITIES::QLD//USD" "QLD")
                                          ] [
                                            (weight-equal [
                                              (if (> (current-price "EQUITIES::QQQ//USD" 10) (moving-average-price "EQUITIES::QQQ//USD" 20)) [
                                                (weight-equal [
                                                  (if (< (rsi "EQUITIES::PSQ//USD" 10) 34) [
                                                    (weight-equal [
                                                      (asset "EQUITIES::QID//USD" "QID")
                                                    ])
                                                  ] [
                                                    (weight-equal [
                                                      (asset "EQUITIES::QLD//USD" "QLD")
                                                    ])
                                                  ])
                                                ])
                                              ] [
                                                (weight-equal [
                                                  (if (< (rsi "EQUITIES::QQQ//USD" 10) 31) [
                                                    (asset "EQUITIES::QLD//USD" "QLD")
                                                  ] [
                                                    (weight-equal [
                                                      (weight-equal [
                                                        (if (> (rsi "EQUITIES::PSQ//USD" 10) 65) [
                                                          (weight-equal [
                                                            (if (> (rsi "EQUITIES::QQQ//USD" 10) (rsi "EQUITIES::TLT//USD" 10)) [
                                                              (asset "EQUITIES::QLD//USD" "QLD")
                                                            ] [
                                                              (asset "EQUITIES::XLP//USD" "XLP")
                                                            ])
                                                          ])
                                                        ] [
                                                          (weight-equal [
                                                            (if (> (rsi "EQUITIES::PSQ//USD" 10) (rsi "EQUITIES::TLT//USD" 10)) [
                                                              (weight-equal [
                                                                (filter (rsi 20) (select-top 1) [
                                                                  (asset "EQUITIES::QID//USD" "QID")
                                                                ])
                                                              ])
                                                            ] [
                                                              (weight-equal [
                                                                (if (> (current-price "EQUITIES::TLT//USD" 10) (moving-average-price "EQUITIES::TLT//USD" 200)) [
                                                                  (asset "EQUITIES::XLP//USD" "XLP")
                                                                ] [
                                                                  (asset "EQUITIES::QLD//USD" "QLD")
                                                                ])
                                                              ])
                                                            ])
                                                          ])
                                                        ])
                                                      ])
                                                    ])
                                                  ])
                                                ])
                                              ])
                                            ])
                                          ])
                                        ])
                                      ])
                                    ])
                                  ])
                                ])
                              ])
                            ])
                          ])
                        ])
                      ])
                    ])
                  ])
                  (asset "EQUITIES::BIL//USD" "BIL")
                  (asset "EQUITIES::GLD//USD" "GLD")
                  (if (> (current-price "EQUITIES::TLT//USD" 10) (moving-average-price "EQUITIES::TLT//USD" 200)) [
                    (asset "EQUITIES::TLT//USD" "TLT")
                  ] [
                    (asset "EQUITIES::GLD//USD" "GLD")
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
