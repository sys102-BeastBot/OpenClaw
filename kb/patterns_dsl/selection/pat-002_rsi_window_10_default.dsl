; RSI Window 10 Default — pat-002
; confidence: 0.97 | seen: 89x
; category: selection
; archetypes: ALL
; regimes effective: bull_low_vol, bear_sustained, sideways_chop, vix_spike
; regimes less effective: none
;
; DESCRIPTION: Standardized RSI window of 10 days across all symphonies. Found in 40+ mini-strategies spanning all 5 analyzed symphonies. Window 7 appears as deliberate fast variant in FNGG and Sisyphus. Window 25 appears exactly once (NOVA ms-037) as an outlier. No RSI window exceeds 14 in the entire 202 mini-strategy corpus, confirming short-term RSI is preferred for this leveraged/volatility universe.
;
; USAGE: Default all RSI indicators to window=10 unless specifically implementing a fast-response variant (use window=7) or a regime detection variant (window=14 maximum). Never use RSI windows above 14 in this universe—longer windows lose signal relevance for the fast-moving leveraged ETF dynamics.
;
; GENERATOR INSTRUCTION: Generator: When generating any relative-strength-index indicator node, set lhs-fn-params={'window-days':10} as the default. Only deviate to window=7 when the strategy description explicitly requires 'fast RSI' or 'reactive RSI'. Never generate RSI with window > 14. If comparing RSI across assets (e.g., BIL RSI vs IEF RSI), both must use identical windows.
;
; DSL:
; NOTE: Replace $TICKER and $THRESHOLD with target asset and threshold value.
; Default window is 10. Use window=7 for fast-response variant.
(if (> (rsi "EQUITIES::$TICKER//USD" 10) $THRESHOLD)
  [(asset "EQUITIES::$TICKER//USD" "$TICKER")]
  [(asset "EQUITIES::BIL//USD" "BIL")])
