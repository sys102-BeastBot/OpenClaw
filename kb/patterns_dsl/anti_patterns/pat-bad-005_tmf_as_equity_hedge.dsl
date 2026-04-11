; TMF as Equity Hedge — pat-bad-005
; category: regime_awareness
;
; NEVER DO: Never use TMF as an asset leaf node for safe-haven or hedge allocation. TMF should only appear in condition nodes (if-child lhs/rhs) as a signal for rate stress detection. For safe-haven allocation, always use BIL. If bond exposure is desired for a specific tactical reason, use IEF (intermediate duration) as a signal-only asset to confirm the regime before any bond-related decision, but still allocate to BIL for actual capital preservation.
;
; WHY IT FAILS: The bond-equity negative correlation is regime-dependent, not structural. In 2022, TMF lost 70% while equities also crashed - the 'hedge' amplified losses instead of offsetting them. This occurred because the Fed was raising rates to fight inflation, causing both asset classes to decline simultaneously. Research symphonies use TMF only as a signal asset (e.g., TMF max-drawdown > 7% indicates rate stress) but never as a holding. For safe-haven allocation, all 5 symphonies route to BIL (short-term T-bills, essentially cash) which has near-zero duration risk. TMF's 17+ year duration makes it a leveraged bet on falling rates, not a hedge.
;
; EVIDENCE:
;   - 2022: TMF lost 70% while SPY lost 25% - correlation flipped positive during Fed tightening
;   - 2021 Q1: TMF lost 25% as rates rose, failing to hedge the tech correction
;   - 1970s stagflation: Bonds and equities declined together for extended periods
;   - Research corpus: TMF appears in 0 allocation leaves, only in condition checks (e.g., FNGG triple crash guard uses TMF max-drawdown as signal)
;   - All 5 symphonies use BIL as safe-haven, never TMF or TLT as holdings
