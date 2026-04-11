; BIL RSI vs IEF Rate Stress Signal — pat-005
; confidence: 0.85 | seen: 18x
; category: guard
; archetypes: adaptive_growth, vol_arb, conservative
; regimes effective: bull_low_vol, sideways_chop
; regimes less effective: vix_spike
;
; DESCRIPTION: Dynamic cross-asset RSI comparison detecting rate stress before it impacts equities. When BIL RSI < IEF RSI, money is flowing to short-duration safety, signaling incoming rate stress or risk-off sentiment. Found in Beta Baller ms-003/004/005/007, NOVA Best ms-034/036, FNGG ms-046/050. This is NOT a fixed RSI threshold—it compares relative momentum between two bond assets.
;
; USAGE: Use as an intermediate guard between macro filters (SPY EMA 210) and momentum gates (TQQQ 5.5%). When rate stress fires, reduce leveraged exposure even if momentum signals remain positive. The signal often precedes equity drawdowns by several days, providing early exit opportunity.
;
; GENERATOR INSTRUCTION: Generator: When building multi-layer guard structures, insert rate stress check between macro trend filters and momentum gates. Create if-child with lhs-fn='relative-strength-index', lhs-fn-params={'window-days':10}, lhs-val='BIL', comparator='gt', rhs-val='IEF', rhs-fixed-value=false. Note: rhs-val='IEF' means compare BIL RSI to IEF RSI dynamically. True branch (BIL RSI > IEF RSI = no stress) continues to momentum gates; else branch routes to defensive.
;
; DSL:
(if (> (rsi "EQUITIES::BIL//USD" 4) (rsi "EQUITIES::IEF//USD" 9))
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")]
  [(asset "EQUITIES::BIL//USD" "BIL")])
