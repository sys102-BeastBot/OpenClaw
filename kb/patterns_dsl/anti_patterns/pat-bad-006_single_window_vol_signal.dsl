; Single Window Vol Signal — pat-bad-006
; category: volatility_detection
;
; NEVER DO: Never build a crash-protection branch with only one volatility or stress indicator. Always combine at least two independent signals from different domains: vol-product health (SVXY RSI, UVXY std-dev), rate stress (BIL vs IEF RSI, IEF MA-return), and equity stress (SPY std-dev-return, QQQ cumulative-return). If the Generator produces a defensive branch with a single indicator, add a second independent signal as an additional if-child condition.
;
; WHY IT FAILS: Each crash archetype has a different leading indicator. Volmageddon was a vol-product structural failure that showed in SVXY before VIX itself spiked. Rate shocks show in bond spreads (IEF vs BIL, BND RSI) before equity vol responds. Liquidity crises show in UVXY spike behavior. Using only one signal means the strategy is protected against one crash type but exposed to others. All 5 research symphonies with Sharpe > 3.4 use minimum 2-3 independent stress signals from different asset classes. FNGG uses SVXY RSI + SVXY return + TMF drawdown as a compound unit. Beta Baller combines BIL vs IEF with IEF vs SH. Single-signal strategies in backtest show 15-25% deeper drawdowns during the crash type their signal misses.
;
; EVIDENCE:
;   - FNGG ms-001/010/017/019/027/029 all use triple crash guard: SVXY RSI(10) < 31 AND SVXY 1-day return < -6% AND TMF max-DD > 7%
;   - Beta Baller ms-003/004/005/007 combine BIL RSI vs IEF with IEF MA-return vs SH and SPY std-dev vs DBC
;   - Sisyphus uses UVXY std-dev + RSI exhaustion signals together, never alone
;   - NOVA Best ms-034/036/038 layer SPY std-dev-return with bond trend gates
;   - v2 Community Discovery uses 95 mini-strategies with cross-asset signal confirmation throughout
