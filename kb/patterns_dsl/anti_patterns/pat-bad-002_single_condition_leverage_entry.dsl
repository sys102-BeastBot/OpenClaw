; Single Condition Leverage Entry — pat-bad-002
; category: signal_quality
;
; NEVER DO: Never create a path to TQQQ, SOXL, TECL, SPXL, or UPRO with fewer than 3 nested if-child conditions along the true branch. Each condition must test a distinct regime dimension: (1) short-term momentum (cumulative-return 1-5 days), (2) long-term trend (EMA/MA 200+ days), (3) volatility regime (UVXY or SVXY indicator).
;
; WHY IT FAILS: Leveraged ETFs suffer from volatility decay (beta slippage) in sideways and whipsaw markets. A single condition like 'RSI > 50' or 'price > MA(200)' fires during bear market rallies, which are the most dangerous periods for leveraged longs. All 202 mini-strategies across the 5 research symphonies that successfully deploy leveraged bulls use 3+ chained conditions. For example, NOVA Best ms-001 chains: (1) TQQQ cumulative-return 1-day > 5.5%, (2) SPY current-price > EMA(210), (3) vol regime check via UVXY. This multi-gate approach filters false signals. Single-condition entries were found in zero high-Sharpe strategies.
;
; EVIDENCE:
;   - 2022 bear market rallies: SPY rallied 10%+ multiple times while still in downtrend; single-condition entries triggered then suffered 20%+ drawdowns
;   - 2018 Q4: Single momentum conditions fired long during the 20% correction
;   - 2020 March: RSI oversold signals triggered leveraged longs days before the actual bottom
;   - Research corpus: 0 of 202 mini-strategies use single-condition leverage entry; minimum observed is 3 conditions
