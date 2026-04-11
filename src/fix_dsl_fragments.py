"""
fix_dsl_fragments.py — Apply all corrections to kb/patterns_dsl/ fragments.

Rewrites the DSL section (lines after "; DSL:") of each broken fragment.
Headers (comment lines) are preserved intact.
"""

import sys
from pathlib import Path

KB_DSL = Path.home() / '.openclaw' / 'workspace' / 'learning' / 'kb' / 'patterns_dsl'


def replace_dsl_section(filepath: Path, new_dsl: str) -> None:
    """Preserve all lines up to and including '; DSL:', replace the rest."""
    content = filepath.read_text()
    lines = content.splitlines()
    header = []
    for i, line in enumerate(lines):
        header.append(line)
        if line.strip() == '; DSL:':
            break
    filepath.write_text('\n'.join(header) + '\n' + new_dsl + '\n')


# ── Corrected DSL for each fragment ───────────────────────────────────────────

FIXES = {}

# pat-001: TQQQ Bull Entry Gate
# window=1 (not 10), true branch = TQQQ slot, else = BIL
FIXES['guards/pat-001_tqqq_bull_entry_gate.dsl'] = """\
(if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5)
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")]
  [(asset "EQUITIES::BIL//USD" "BIL")])"""

# pat-002: RSI Window 10 Default (selection — no specific asset)
# Both branches were empty; use $TICKER placeholder with comment
FIXES['selection/pat-002_rsi_window_10_default.dsl'] = """\
; NOTE: Replace $TICKER and $THRESHOLD with target asset and threshold value.
; Default window is 10. Use window=7 for fast-response variant.
(if (> (rsi "EQUITIES::$TICKER//USD" 10) $THRESHOLD)
  [(asset "EQUITIES::$TICKER//USD" "$TICKER")]
  [(asset "EQUITIES::BIL//USD" "BIL")])"""

# pat-003: SVXY Crash Guard Mandatory
# window=2 (not 10), comparator=gt (not lt): if drawdown > 10 → BIL
FIXES['guards/pat-003_svxy_crash_guard_mandatory.dsl'] = """\
(if (> (max-drawdown "EQUITIES::SVXY//USD" 2) 10)
  [(asset "EQUITIES::BIL//USD" "BIL")]
  [(asset "EQUITIES::SVXY//USD" "SVXY")])"""

# pat-004: SPY EMA 210 Long-Term Trend Filter
# Dynamic: current-price(2) > EMA(210) → bull; else → BIL
FIXES['guards/pat-004_spy_ema_210_long_term_trend_filter.dsl'] = """\
(if (> (current-price "EQUITIES::SPY//USD" 2)
       (exponential-moving-average-price "EQUITIES::SPY//USD" 210))
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")]
  [(asset "EQUITIES::BIL//USD" "BIL")])"""

# pat-005: BIL RSI vs IEF Rate Stress Signal
# Dynamic: RSI(BIL, 4) > RSI(IEF, 9) → no stress → bull; else → BIL
# (task-specified windows: BIL=4, IEF=9)
FIXES['guards/pat-005_bil_rsi_vs_ief_rate_stress_signal.dsl'] = """\
(if (> (rsi "EQUITIES::BIL//USD" 4) (rsi "EQUITIES::IEF//USD" 9))
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")]
  [(asset "EQUITIES::BIL//USD" "BIL")])"""

# pat-006: UVXY VIXM Paired Volatility Hedge (allocation)
# DSL was correct — only regex bug caused false positive. Preserve as-is.
# (No change needed — handled by regex fix in detection script)

# pat-007: SPY Max Drawdown Hard Floor
# window=20 (not 10), else was empty → TQQQ placeholder
FIXES['guards/pat-007_spy_max_drawdown_hard_floor.dsl'] = """\
(if (> (max-drawdown "EQUITIES::SPY//USD" 20) 6)
  [(asset "EQUITIES::BIL//USD" "BIL")]
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")])"""

# pat-008: Triple Confirmation Before Leverage
# Fix: cumulative-return window=1 (not 10), current-price window=2 (not 10)
# Structure is otherwise correct; regex fix handles remaining false positives
FIXES['guards/pat-008_triple_confirmation_before_leverage.dsl'] = """\
(if (> (cumulative-return "EQUITIES::TQQQ//USD" 1) 5.5)
  [(if (> (current-price "EQUITIES::SPY//USD" 2)
          (exponential-moving-average-price "EQUITIES::SPY//USD" 210))
    [(if (< (standard-deviation-return "EQUITIES::UVXY//USD" 10) 10)
      [(asset "EQUITIES::TQQQ//USD" "TQQQ")]
      [(asset "EQUITIES::BIL//USD" "BIL")])]
    [(asset "EQUITIES::QQQ//USD" "QQQ")])]
  [(asset "EQUITIES::SPY//USD" "SPY")])"""

# pat-009: UVXY Cumulative Return Spike Detector
# window=10, threshold=20 correct; else was empty → TQQQ when no spike
FIXES['guards/pat-009_uvxy_cumulative_return_spike_detector.dsl'] = """\
(if (> (cumulative-return "EQUITIES::UVXY//USD" 10) 20)
  [(asset "EQUITIES::BIL//USD" "BIL")]
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")])"""

# pat-010: SPY RSI Overbought Exhaustion Exit
# DSL was correct — only regex false positive. Preserve as-is.
# (No change needed — handled by regex fix)

# pat-011: Max Drawdown Black Swan Catch and Recover
# max-drawdown SPY window=20 (not 10); else was empty → TQQQ (normal bull routing)
FIXES['guards/pat-011_max_drawdown_black_swan_catch_and_recover.dsl'] = """\
(if (> (max-drawdown "EQUITIES::SPY//USD" 20) 6)
  [(if (< (rsi "EQUITIES::SOXL//USD" 10) 30)
    [(asset "EQUITIES::TQQQ//USD" "TQQQ")]
    [(asset "EQUITIES::BIL//USD" "BIL")])]
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")])"""

# pat-012: SVXY Triple Crash Guard Compound
# Fix: SVXY cumulative-return window=1 (not 10); fill empty else branches
# TLT used as bond proxy (not in allocation universe but valid for signal use)
FIXES['guards/pat-012_svxy_triple_crash_guard_compound.dsl'] = """\
(if (< (rsi "EQUITIES::SVXY//USD" 10) 31)
  [(if (< (cumulative-return "EQUITIES::SVXY//USD" 1) -6)
    [(if (> (max-drawdown "EQUITIES::TLT//USD" 10) 7)
      [(asset "EQUITIES::BIL//USD" "BIL")]
      [(asset "EQUITIES::TQQQ//USD" "TQQQ")])]
    [(asset "EQUITIES::TQQQ//USD" "TQQQ")])]
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")])"""

# pat-013: UVXY Moving Average Return vs VIXM Trending Signal
# Fix: bare VIXM → dynamic moving-average-return(VIXM, 3); fill empty else
FIXES['selection/pat-013_uvxy_moving_average_return_vs_vixm_trending_signal.dsl'] = """\
(if (> (moving-average-return "EQUITIES::UVXY//USD" 3)
       (moving-average-return "EQUITIES::VIXM//USD" 3))
  [(asset "EQUITIES::BIL//USD" "BIL")]
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")])"""

# pat-015: UVXY RSI Overbought Vol Exhaustion Exit
# window=10, threshold=84 correct; else was empty → UVXY (continuing vol hold)
FIXES['guards/pat-015_uvxy_rsi_overbought_vol_exhaustion_exit.dsl'] = """\
(if (> (rsi "EQUITIES::UVXY//USD" 10) 84)
  [(asset "EQUITIES::BIL//USD" "BIL")]
  [(asset "EQUITIES::UVXY//USD" "UVXY")])"""

# pat-016: SPY MA3 Plus EMA210 Dual Timeframe
# Fix: bare SPY → current-price(2) on both RHS; EMA window=210 (not 10); MA window=3 (not 10)
FIXES['guards/pat-016_spy_ma3_plus_ema210_dual_timeframe.dsl'] = """\
(if (> (current-price "EQUITIES::SPY//USD" 2)
       (exponential-moving-average-price "EQUITIES::SPY//USD" 210))
  [(if (> (current-price "EQUITIES::SPY//USD" 2)
          (moving-average-price "EQUITIES::SPY//USD" 3))
    [(asset "EQUITIES::TQQQ//USD" "TQQQ")]
    [(asset "EQUITIES::QQQ//USD" "QQQ")])]
  [(asset "EQUITIES::BIL//USD" "BIL")])"""

# pat-017: BND RSI Long Window Bond Stress
# Fix: bare SPY → rsi(SPY, 45); window=45 (not 10) on BND too
FIXES['guards/pat-017_bnd_rsi_long_window_bond_stress.dsl'] = """\
(if (> (rsi "EQUITIES::BND//USD" 45) (rsi "EQUITIES::SPY//USD" 45))
  [(asset "EQUITIES::QQQ//USD" "QQQ")]
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")])"""

# pat-018: TQQQ Extreme Crash Circuit Breaker
# window=10 correct; replace comment-only else placeholder with TQQQ asset
FIXES['guards/pat-018_tqqq_extreme_crash_circuit_breaker.dsl'] = """\
(if (< (cumulative-return "EQUITIES::TQQQ//USD" 10) -33)
  [(asset "EQUITIES::BIL//USD" "BIL")]
  [(asset "EQUITIES::TQQQ//USD" "TQQQ")])"""

# pat-019: SVXY RSI Bull Health Confirmation
# DSL was correct — only regex false positive. Preserve as-is.
# (No change needed — handled by regex fix)


def main():
    print(f"\nApplying DSL fixes → {KB_DSL}")
    print(f"{'─'*60}")

    ok = skip = err = 0
    for rel_path, new_dsl in sorted(FIXES.items()):
        fpath = KB_DSL / rel_path
        if not fpath.exists():
            print(f"  ✗  MISSING: {rel_path}")
            err += 1
            continue
        try:
            replace_dsl_section(fpath, new_dsl)
            print(f"  ✓  {rel_path}")
            ok += 1
        except Exception as e:
            print(f"  ✗  {rel_path}: {e}")
            err += 1

    unchanged = ['guards/pat-006_uvxy_vixm_paired_volatility_hedge.dsl — correct DSL (regex fix only)',
                 'guards/pat-010_spy_rsi_overbought_exhaustion_exit.dsl — correct DSL (regex fix only)',
                 'guards/pat-019_svxy_rsi_bull_health_confirmation.dsl — correct DSL (regex fix only)']
    for u in unchanged:
        print(f"  —  {u}")
        skip += 1

    print(f"\n  {ok} files updated, {skip} skipped (correct), {err} errors")
    return 0 if err == 0 else 1


if __name__ == '__main__':
    sys.exit(main())
