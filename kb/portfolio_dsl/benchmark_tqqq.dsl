defsymphony "Benchmark_TQQQ" {:rebalance-frequency :daily}
  (weight-equal [
    (asset "EQUITIES::TQQQ//USD" "TQQQ")
  ])
