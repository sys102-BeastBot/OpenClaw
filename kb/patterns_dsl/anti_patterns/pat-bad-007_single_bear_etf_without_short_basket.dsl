; Single Bear ETF Without Short Basket — pat-bad-007
; category: bear_allocation
;
; NEVER DO: Never route to SQQQ, TECS, or SOXS as a standalone terminal allocation in bear-regime branches. When the Generator needs bear-market exposure, always use a wt-cash-specified group containing all three (TECS, SOXS, SQQQ) with equal weights (0.333 each) or use wt-inverse-vol with window-days 10 across the three. If a single leveraged bear appears as an asset leaf, replace it with the full short basket group.
;
; WHY IT FAILS: Individual leveraged bears carry concentrated sector risk: SQQQ is pure Nasdaq, TECS is technology sector, SOXS is semiconductors. In a rotation bear market where tech holds up while other sectors fall, SQQQ underperforms. In a semiconductor-specific downturn, only SOXS captures the move. The equal-weight basket of all three provides sector diversification within the bear allocation, reducing the risk that the strategy is short the wrong sector. Additionally, leveraged ETFs suffer from volatility decay; spreading across three reduces the impact of any single ETF's decay characteristics. FNGG's named SHORT GROUP architecture confirms this is not accidental but a deliberate design pattern. Zero of the 202 extracted mini-strategies route to a single leveraged bear as a terminal allocation in bear regimes.
;
; EVIDENCE:
;   - FNGG defines explicit SHORT GROUP with exactly TECS+SOXS+SQQQ in equal weight
;   - No mini-strategy across all 5 symphonies uses SQQQ alone as bear-regime terminal allocation
;   - No mini-strategy uses TECS alone or SOXS alone as standalone bear allocation
;   - When bear allocation appears, it is either the 3-asset basket or a pivot to safe-haven (BIL/SPY)
;   - The SHORT GROUP pattern appears in FNGG ms-008 through ms-015 bear branches consistently
