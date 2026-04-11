; UVXY Cumulative Return Spike Detector — pat-009
; confidence: 0.85 | seen: 9x
; category: guard
; archetypes: ALL
; regimes effective: vix_spike, bear_sustained
; regimes less effective: bull_low_vol
;
; DESCRIPTION: Use cumulative-return on UVXY with a 10-day window and threshold of 20-25% to detect sustained volatility spikes, triggering immediate exit to BIL. NOVA Best Leverage Mashup ms-001 uses threshold 20% as the trigger point. v2 Community Discovery NOVA ms-006 uses a more conservative threshold of 25%. Unlike single-day return checks, the 10-day cumulative return catches multi-day vol buildups that precede major corrections. When UVXY has gained 20%+ over 10 days, volatility regime has shifted materially.
;
; USAGE: Place this guard after initial macro regime checks but before leveraged asset selection. When triggered, exit to BIL immediately. Use 20% threshold for earlier exit (more conservative) or 25% for later exit (captures only severe spikes).
;
; GENERATOR INSTRUCTION: Generator: Add a UVXY cumulative return spike detector as a guard condition in every symphony. Insert an if-child with: lhs-fn=cumulative-return, lhs-fn-params.window=10, lhs-val=UVXY, comparator=gt, rhs-val=20 (standard) or rhs-val=25 (permissive). When this condition is true (UVXY up 20%+ in 10 days), route directly to {"step":"asset","symbol":"BIL"}. Place this condition before any branch containing TQQQ, SOXL, TECL, SPXL, UPRO, SVIX, or SVXY.
;
; DSL:
(if (> (cumulative-return "EQUITIES::UVXY//USD" 10) 20)
  [(asset "EQUITIES::BIL//USD" "BIL")]
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")])
