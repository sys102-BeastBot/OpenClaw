; SVXY Triple Crash Guard Compound — pat-012
; confidence: 0.9 | seen: 8x
; category: guard
; archetypes: vol-harvest, leveraged-bull, hybrid
; regimes effective: vix_spike, bear_sustained
; regimes less effective: bull_low_vol
;
; DESCRIPTION: Three-part compound crash detection combining SVXY momentum collapse (RSI<31), SVXY acute drawdown (1-day return<-6%), and bond stress (TMF max-drawdown>7%). These three conditions appear together as a unified crash-detection unit in FNGG ms-001, ms-010, ms-017, ms-019, ms-027, and ms-029. When all three fire simultaneously, it indicates a genuine market crash rather than normal volatility. SVXY RSI below 31 shows short-vol momentum has collapsed. SVXY 1-day return below -6% confirms acute same-day damage. TMF max-drawdown above 7% shows flight-to-quality bonds are also stressed, indicating systemic risk rather than isolated vol spike.
;
; USAGE: Place this compound guard at the outermost level of any strategy holding SVXY, SVIX, or leveraged bull ETFs. When the compound fires (all 3 true), immediately route to BIL. Do not wait for additional confirmation. This is a circuit breaker, not a trading signal.
;
; GENERATOR INSTRUCTION: Generator: When building any branch that terminates in SVXY, SVIX, TQQQ, SOXL, TECL, SPXL, or UPRO, wrap the entire branch in an if-node where the first if-child contains three nested conditions: (1) lhs-fn=relative-strength-index, lhs-fn-params.window=10, lhs-val=SVXY, comparator=lt, rhs-val=31, rhs-fixed-value=true; (2) lhs-fn=cumulative-return, lhs-fn-params.window=1, lhs-val=SVXY, comparator=lt, rhs-val=-6, rhs-fixed-value=true; (3) lhs-fn=max-drawdown, lhs-fn-params.window=10, lhs-val=TLT, comparator=gt, rhs-val=7, rhs-fixed-value=true. The first if-child routes to BIL when crash detected. The else-child contains the original branch.
;
; DSL:
(if (< (rsi "EQUITIES::SVXY//USD" 10) 31)
  [(if (< (cumulative-return "EQUITIES::SVXY//USD" 1) -6)
    [(if (> (max-drawdown "EQUITIES::TLT//USD" 10) 7)
      [(asset "EQUITIES::BIL//USD" "BIL")]
      [(asset "EQUITIES::TQQQ//USD" "TQQQ")])]
    [(asset "EQUITIES::TQQQ//USD" "TQQQ")])]
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")])
