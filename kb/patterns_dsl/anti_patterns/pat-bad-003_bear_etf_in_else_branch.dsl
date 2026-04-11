; Bear ETF in Else Branch — pat-bad-003
; category: regime_logic
;
; NEVER DO: Never place SQQQ, SPXS, SOXS, or TECS as the else-child of any if-then-else node. Bear ETFs must only appear as the then-child (true branch) of conditions that explicitly confirm bearish regime: (1) QQQ cumulative-return(70) < -15%, or (2) UVXY std-dev-return(10) > 10 combined with SPY below EMA(210). The else branch should route to BIL or SPY, never leveraged bears.
;
; WHY IT FAILS: Leveraged bear ETFs lose 60-70% annually in sustained bull markets and 20-40% annually even in sideways markets due to daily rebalancing decay and contango effects. The absence of a bullish signal does not confirm a bearish regime - it may indicate consolidation, sector rotation, or simply noise. SQQQ lost 70% in 2023 despite multiple periods where bullish conditions were 'not met'. The research corpus shows bear ETFs should only appear after explicitly confirmed bearish signals: QQQ 70-day cumulative return < -15%, UVXY std-dev-return > 10, AND breakdown of long-term MAs. Using else-branch placement inverts this logic.
;
; EVIDENCE:
;   - 2023: SQQQ lost 70% while appearing to be 'safe' during uncertain periods
;   - 2021: SQQQ lost 75% despite intermittent bearish signals throughout the year
;   - 2019: SPXS lost 65% as market consolidated then resumed uptrend
;   - FNGG symphony: Bear ETFs only appear after explicit QQQ 70-day return < -15% check, never in else branches
