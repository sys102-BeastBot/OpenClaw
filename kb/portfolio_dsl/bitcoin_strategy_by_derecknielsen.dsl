defsymphony "Bitcoin Strategy by Derecknielsen (BTC and ETH)" {:rebalance-frequency :none}
  (weight-specified {"ETHT" 50 "MSTU" 25 "BITU" 25} [
    (asset "EQUITIES::ETHT//USD" "ETHT")
    (asset "EQUITIES::MSTU//USD" "MSTU")
    (asset "EQUITIES::BITU//USD" "BITU")
  ])
