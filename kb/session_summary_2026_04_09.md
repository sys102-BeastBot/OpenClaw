# OpenClaw Session Summary — 2026-04-09

## BREAKTHROUGH: DSL Pipeline Working End-to-End

### What Changed Today

**The Core Problem Solved:**
The Composer API `PUT` endpoint silently ignores strategy changes — backtest always
runs the live/deployed version. This blocked all automated backtesting for 6 weeks.

**The Solution:**
1. Composer's editor has a "Def" tab showing a Clojure-style DSL
2. We built `dsl_compiler.py` — a deterministic Python parser (39/39 tests passing)
3. Pipeline: Natural language → Composer AI generates DSL → compiler → JSON → import
   to Composer UI → save → backtest by ID
4. JSON imports and saves reliably every time ✓

### Files Created Today
- `src/dsl_compiler.py` — DSL-to-JSON compiler (620 lines, 39 tests passing)
- `kb/pilot/leveraged_etf_momentum_v1-v4.json` — 4 strategy iterations

### DSL Grammar (Confirmed Working)
```clojure
defsymphony "Name" {:rebalance-frequency :daily}
  (weight-equal [...])
  (weight-inverse-vol <window> [...])
  (filter (rsi <window>) (select-top <n>) [...])
  (if <condition> [<true>] [<false>])
  (asset "EQUITIES::<TICKER>//USD" "<name>")
  (or <cond1> <cond2>)       ; → compound/any Any/All condition
  (and <cond1> <cond2>)      ; → compound/all Any/All condition
  (> (rsi "EQUITIES::SPY//USD" 10) 50)
  (< (cumulative-return "EQUITIES::SVXY//USD" 1) -8)
  (> (current-price "EQUITIES::SPY//USD" 2) (moving-average-price "EQUITIES::SPY//USD" 200))
```

### Iteration Results (v1-v4)

| Version | Regime Filter | 2022 Sharpe | 2022 MaxDD | Key Issue |
|---|---|---|---|---|
| v1 | EMA(210) > MA(200) | 0.92 | 6.9% | Both slow — always true, stays leveraged |
| v2 | EMA(210) > price | -0.50 | 48.3% | Inverted logic |
| v3 | price > EMA(210) | -1.79 | 32.0% | Still wrong EMA vs MA |
| v4 | price(2d) > MA(200) | -1.39 | 24.8% | Slightly better but wrong direction in 2022 |

**Reference benchmarks:**
| Symphony | 2022 Sharpe | 2022 MaxDD |
|---|---|---|
| Sisyphus | 5.61 | 7.3% |
| NOVA Best | 6.71 | 4.5% |
| Beta Baller | 5.07 | 16.2% |

### Critical Insight: Why Sisyphus Works

Sisyphus has 386 asset paths across 58 tickers. UVXY appears in 61 paths — it's
the PRIMARY profit center, not a guard. Sisyphus MAKES MONEY in bear markets via
short volatility and long volatility plays. Our strategies only AVOID bear markets.

The architectural gap: our strategies go BIL in bear mode. Sisyphus goes UVXY/UVIX.
That single difference explains the 5x Sharpe difference in 2022.

**Sisyphus's proven regime formula:**
`current-price(SPY, 2d) > moving-average-price(SPY, 200d)`

### Symphony IDs Created Today
- v1: m36cKalUklvsyCG0JGcC  (EMA vs MA200)
- v2: y2CPPxd6f4LsMI1oC86W  (inverted — broken)
- v3: eIsUqvvWwPnGE040g1hX  (price > EMA — wrong type)
- v4: p8Xc6tqoxC9yh5GNGRGy  (price > MA200 — nearly same as v3)

### v5 Direction (Next Session)
Add UVXY profit layer in bear branch:
```clojure
; Bear regime branch — instead of BIL, profit from vol
(if (> (relative-strength-index "EQUITIES::UVXY//USD" 10) 30)
  [(asset "EQUITIES::UVXY//USD" "UVXY")]
  [(asset "EQUITIES::BIL//USD" "BIL")])
```

### Architecture Decisions Made

1. **DSL is the right representation for the generator** — not JSON
   - DSL is 10x more compact than JSON
   - Claude generates DSL reliably (Composer AI proved it)
   - Compiler handles correctness deterministically
   - Should replace JSON patterns in KB

2. **KB should store DSL fragments, not JSON patterns**
   - Each pattern becomes a named DSL building block
   - Generator assembles fragments, never writes JSON
   - Far more reliable than monolithic JSON generation

3. **JSON-to-DSL converter needed** (reverse of compiler)
   - Allows community symphonies to be expressed as DSL
   - Every community strategy becomes a KB pattern
   - ~200 lines of Python, similar to the compiler

### Knowledge Sources to Mine (Next Session)
1. Composer community database (composer.trade/trading-strategies) — 3000+ strategies
2. Reddit r/Composer and r/algotrading — strategy discussions with DSL snippets
3. Quantopian/Zipline strategy archives — translated to DSL concepts
4. Academic papers on regime-switching volatility strategies
5. VIX/vol trading literature — how professionals trade UVXY/SVXY
6. Composer's own blog/learn section — documented strategy patterns

### Next Steps (Priority Order)

**IMMEDIATE (next session):**
1. Compile and test v5 (UVXY bear profit layer)
2. Build community scanner — collect top 30 IDs from composer.trade/trading-strategies
3. Backtest community IDs, find strategies beating Sisyphus
4. Build JSON-to-DSL converter

**SHORT TERM (this week):**
5. Rebuild KB in DSL format — convert patterns.json to DSL fragments
6. Update generator to produce DSL instead of JSON
7. Build structured iteration log (DSL, ID, metrics, lessons per version)
8. Parameter optimizer for Sisyphus (grid search thresholds)

**MEDIUM TERM:**
9. Batch API support for generator (50% cost savings)
10. Automated learner loop on DSL iterations
11. Systematic vol strategy research (UVXY/SVXY mechanics)
