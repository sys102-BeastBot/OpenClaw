; Naked SVXY Hold — pat-bad-001
; category: risk_management
;
; NEVER DO: Never route to SVXY as a leaf node without an outer if-child containing max-drawdown with window <= 3 days and threshold between 7-10%. The max-drawdown condition must be on an outer branch (checked before the SVXY allocation), not a sibling or inner condition.
;
; WHY IT FAILS: Short volatility positions have asymmetric tail risk. In normal markets they slowly accrue premium, but during vol spikes they can lose 50-90% in hours. Without a drawdown circuit breaker, a single event destroys years of gains. All 5 research symphonies that hold SVXY wrap it in max-drawdown conditions (typically window=2, threshold 7-10%). The FNGG symphony specifically uses SVXY RSI(10) < 31 combined with SVXY 1-day return < -6% AND TMF max-drawdown > 7% as a triple crash guard. Naked holds appeared in zero winning strategies across 202 mini-strategies analyzed.
;
; EVIDENCE:
;   - February 5, 2018 (Volmageddon): XIV lost 93% intraday, SVXY lost 90%+, both tracking inverse VIX
;   - February 2020 COVID crash: SVXY dropped 60%+ in under two weeks
;   - August 2015 flash crash: Short-vol products gapped down 30%+ at open
;   - October 2014 VIX spike: SVXY lost 25% in a single session
;   - All 5 analyzed symphonies (FNGG, Sisyphus, Beta Baller, NOVA Best, v2 Community) use protective conditions around SVXY
