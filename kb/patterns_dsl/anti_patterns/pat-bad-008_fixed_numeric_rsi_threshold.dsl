; Fixed Numeric RSI Threshold — pat-bad-008
; category: signal_comparison
;
; NEVER DO: Never use generic fixed RSI thresholds like 50, 70, or 30 as condition triggers. When RSI appears in conditions, it should compare RSI of one asset against RSI of another asset (e.g., rsi-of operator with lhs as one asset's RSI and rhs as another asset's RSI), or use the specifically calibrated thresholds: SVXY RSI < 31 for vol-product crash detection, UVXY RSI > 84 for vol exhaustion. If the Generator produces an RSI condition with a generic threshold, convert it to a cross-asset RSI comparison using appropriate signal-universe assets.
;
; WHY IT FAILS: RSI is a relative measure that varies in meaning across regimes. In a strong bull market, RSI 50 on an equity ETF might indicate a buying opportunity; in a bear market, RSI 50 might be the top of a relief rally. All 5 research symphonies solve this by comparing RSI across assets: BIL RSI vs IEF RSI detects rate stress regardless of absolute levels, SVXY RSI vs threshold 31 is specifically calibrated to vol-product behavior, IGIB RSI vs SPY RSI detects credit stress relative to equity. The only fixed threshold that appears consistently is SVXY RSI < 31, which is empirically calibrated to vol-product crash behavior specifically. Generic fixed thresholds like 50/70/30 appear in zero of the 202 mini-strategies.
;
; EVIDENCE:
;   - Beta Baller ms-003/004/005/007 use BIL RSI(7-10) < IEF RSI as rate stress signal
;   - FNGG ms-046/050 use RSI cross-asset comparison for regime detection
;   - NOVA Best ms-034/036 use dynamic RSI comparison between safe and risk assets
;   - The only fixed RSI threshold in corpus is SVXY RSI < 31, calibrated specifically to vol-product crash
;   - UVXY RSI > 84 for vol exhaustion is the other fixed threshold, calibrated to vol-spike exhaustion
;   - Zero instances of generic RSI > 70 overbought or RSI < 30 oversold patterns in any symphony
