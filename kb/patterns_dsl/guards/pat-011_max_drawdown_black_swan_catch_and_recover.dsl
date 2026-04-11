; Max Drawdown Black Swan Catch and Recover — pat-011
; confidence: 0.8 | seen: 12x
; category: guard
; archetypes: ALL
; regimes effective: vix_spike, bear_sustained, sideways_chop
; regimes less effective: bull_low_vol
;
; DESCRIPTION: Two-phase crash response system derived from v2 Community Discovery NOVA ms-004 named 'Max Drawdown Black Swan Catcher'. Phase 1 uses SPY max-drawdown over 20 days exceeding 6% to detect active crash conditions and immediately routes to BIL for capital preservation. Phase 2 is NESTED inside the crash branch: when SOXL RSI(10) drops below 30, the crash is near exhaustion and recovery is imminent, so it allocates to TQQQ to capture the bounce. This nested structure ensures you only attempt recovery entries AFTER crash conditions are confirmed, preventing premature re-entry during cascading selloffs.
;
; USAGE: Apply as outermost guard on any strategy holding leveraged bull assets. The nested structure is critical: the SOXL RSI check only fires when already in crash mode (SPY drawdown > 6%). Do not flatten this into sequential if-children or the logic breaks. The else branch of the outer if-child should contain normal bull routing logic.
;
; GENERATOR INSTRUCTION: Generator: When constructing any strategy holding TQQQ, SOXL, TECL, SPXL, or UPRO, wrap the entire leveraged bull allocation tree inside this two-phase structure. Create an outer if-child with lhs-fn=max-drawdown, lhs-val=SPY, window=20, comparator=gt, rhs-val=6, rhs-fixed-value=true, is-else-condition=false. Inside this if-child's children array, create a nested if step containing two if-children: first if-child has lhs-fn=relative-strength-index, lhs-val=SOXL, window=10, comparator=lt, rhs-val=30, rhs-fixed-value=true, is-else-condition=false with children containing asset step for TQQQ; second if-child has is-else-condition=true with children containing asset step for BIL. The outer if's else branch (is-else-condition=true) contains your normal bull routing logic.
;
; DSL:
(if (> (max-drawdown "EQUITIES::SPY//USD" 20) 6)
  [(if (< (rsi "EQUITIES::SOXL//USD" 10) 30)
    [(asset "EQUITIES::TQQQ//USD" "TQQQ")]
    [(asset "EQUITIES::BIL//USD" "BIL")])]
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")])
