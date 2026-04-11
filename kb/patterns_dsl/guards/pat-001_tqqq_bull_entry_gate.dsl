; TQQQ Bull Entry Gate — pat-001
; confidence: 0.97 | seen: 47x
; category: guard
; archetypes: ALL
; regimes effective: bull_low_vol, sideways_chop
; regimes less effective: bear_sustained, vix_spike
;
; DESCRIPTION: Cumulative return gate requiring TQQQ 1-day return exceeds 5.5% before allowing leveraged bull allocation. Found in 11+ FNGG mini-strategies, Sisyphus ms-009/ms-010, Beta Baller ms-002 through ms-007, NOVA Best ms-001, and v2 ms-005. The 6% variant appears in FNGG ms-041-044 and v2 ms-005 as deliberate ensemble diversity. This is the single most replicated parameter across the 202 mini-strategy corpus, appearing in approximately 23% of all extracted strategies.
;
; USAGE: Apply as the innermost condition before any leveraged bull asset leaf (TQQQ, SOXL, TECL, SPXL, UPRO). The 1-day window is canonical; 60-day window variant exists for sustained trend confirmation but is less common. Never route to leveraged bulls without this gate or an equivalent momentum confirmation.
;
; GENERATOR INSTRUCTION: Generator: Before every if-child that routes to TQQQ, SOXL, TECL, SPXL, or UPRO as a terminal asset, insert an immediately preceding if-child with lhs-fn='cumulative-return', lhs-fn-params={'window-days':1}, lhs-val='TQQQ', comparator='gt', rhs-val=5.5, rhs-fixed-value=true. The else branch of this gate must route to BIL or a defensive asset, never to the leveraged bull directly.
;
; VARIANTS:
;   aggressive:   threshold=5.0
;   conservative: threshold=6.0
;
; DSL:
(if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5)
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")]
  [(asset "EQUITIES::BIL//USD" "BIL")])
