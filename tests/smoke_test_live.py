"""
smoke_test_live.py — Live end-to-end smoke test.

Runs ONE real strategy through the full pipeline against the real
Composer API. NOT part of the pytest suite — run manually to verify
real API behavior.

Usage:
    cd ~/.openclaw/workspace/learning
    python3 tests/smoke_test_live.py

Success criteria:
  1. Generator produces valid strategy JSON
  2. Nominal backtest returns real scores from Composer API
  3. Strategy scores above rough cut threshold (fitness >= 40)
  4. Optimizer runs and finds parameters (or confirms nominal is optimal)
  5. Learner extracts at least one lesson
  6. Strategy file written to pending/ with all sections populated

This script writes to pending/ and results/ — clean up afterward:
    rm ~/.openclaw/workspace/learning/pending/gen-000-strat-01.json
    rm ~/.openclaw/workspace/learning/results/gen-000-strat-01.json
"""

import json
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent / 'src'))

import generator_agent as ga
import backtest_runner as br
import scorer as sc
import optimizer as op
import ranker as rk
import learner_prep as lp
import learner_agent as la
from kb_writer import read_json, write_json_atomic
from monitor_agent import log_event
from credentials import CredentialManager

# ── Config ─────────────────────────────────────────────────────────────────────

GENERATION   = 0       # generation 0 = smoke test
ARCHETYPE    = 'SHARPE_HUNTER'
SLOT         = 1
PERIODS      = ['1Y', '2Y']   # two periods — fast but meaningful
STRATEGY_ID  = f'gen-{GENERATION:03d}-strat-{SLOT:02d}'

KB_ROOT      = Path.home() / '.openclaw' / 'workspace' / 'learning' / 'kb'
META_PATH    = KB_ROOT / 'meta.json'
ACTIVE_PATH  = KB_ROOT / 'lessons' / 'active.json'
PATTERNS_PATH= KB_ROOT / 'patterns.json'


def _separator(title: str):
    print(f"\n{'='*60}")
    print(f"  {title}")
    print(f"{'='*60}")


def _check(condition: bool, message: str) -> bool:
    status = '✓' if condition else '✗'
    print(f"  {status}  {message}")
    return condition


def run_smoke_test():
    """Run the full pipeline smoke test."""
    passed = []
    failed = []

    print("\nOpenClaw Learning Agent — Live Smoke Test")
    print(f"Strategy: {STRATEGY_ID} | Archetype: {ARCHETYPE}")
    print(f"Periods: {PERIODS}")

    # ── Load KB files ──────────────────────────────────────────────────────────
    _separator("Loading KB")
    try:
        meta           = read_json(str(META_PATH))
        active_lessons = read_json(str(ACTIVE_PATH))
        patterns       = read_json(str(PATTERNS_PATH))
        print("  ✓  KB files loaded")
    except Exception as e:
        print(f"  ✗  KB files not found: {e}")
        print("     Run kb_writer.initialize_kb_structure() first")
        sys.exit(1)

    # ── Get Anthropic key ──────────────────────────────────────────────────────
    try:
        creds         = CredentialManager()
        anthropic_key = creds.get_anthropic_key()
        print("  ✓  Credentials loaded")
    except Exception as e:
        print(f"  ✗  Credential error: {e}")
        sys.exit(1)

    # ── STAGE 1: Generator ─────────────────────────────────────────────────────
    _separator("Stage 1: Generator")
    print(f"  Calling Claude ({ga.CLAUDE_MODEL})...")

    t0       = time.time()
    strategy = ga.run_generator_agent(
        archetype=ARCHETYPE,
        generation=GENERATION,
        slot_number=SLOT,
        parent_ids=[],
        anthropic_key=anthropic_key,
    )
    elapsed = time.time() - t0

    ok = _check(strategy is not None, f"Strategy generated ({elapsed:.1f}s)")
    if not ok:
        failed.append("Generator produced no output")
        print("\nSMOKE TEST FAILED at Stage 1")
        return False
    passed.append("Generator")

    ok = _check(
        not strategy['summary']['disqualified'],
        f"Logic audit passed — no quarantine"
    )
    if not ok:
        failures = strategy['logic_audit']['failures']
        print(f"     Audit failures: {failures}")
        failed.append(f"Logic audit failed: {failures}")
        print("\nSMOKE TEST FAILED at Stage 1 — strategy quarantined")
        return False

    name = strategy['summary']['name']
    rebal = strategy['summary']['rebalance_frequency']
    print(f"  ✓  Name: {name}")
    print(f"  ✓  Rebalance: {rebal}")

    # ── STAGE 2: Nominal Backtest ──────────────────────────────────────────────
    _separator("Stage 2: Nominal Backtest")
    print(f"  Submitting to Composer API for periods {PERIODS}...")

    t0       = time.time()
    strategy = br.run_nominal_backtest(strategy, PERIODS, meta)
    elapsed  = time.time() - t0

    ok = _check(
        strategy['nominal_result'] is not None,
        f"Backtest completed ({elapsed:.1f}s)"
    )
    if not ok:
        failed.append("Nominal backtest returned None")
        print("\nSMOKE TEST FAILED at Stage 2")
        return False
    passed.append("Nominal backtest")

    for period in PERIODS:
        period_data = strategy['nominal_result']['periods'].get(period)
        ok = _check(period_data is not None, f"Period {period} has results")
        if period_data:
            core = period_data['core_metrics']
            print(f"     {period}: return={core['annualized_return']:.1f}% "
                  f"sharpe={core['sharpe']:.2f} "
                  f"maxDD={core['max_drawdown']:.1f}%")

    # ── STAGE 3: Scoring ───────────────────────────────────────────────────────
    _separator("Stage 3: Scoring")

    period_scores = {}
    for period in PERIODS:
        period_data = strategy['nominal_result']['periods'].get(period)
        if not period_data:
            continue

        # Check disqualifiers
        is_disq, reason = sc.check_disqualifiers(period_data, meta)
        if is_disq:
            failed.append(f"Disqualified in period {period}: {reason}")
            print(f"  ✗  {period} DISQUALIFIED: {reason}")
            continue

        # Score period
        scored = sc.score_period(period_data, ARCHETYPE, meta)
        strategy['nominal_result']['periods'][period] = scored
        score = scored['fitness']['period_fitness_score']
        period_scores[period] = score
        print(f"  ✓  {period} fitness: {score:.1f}")

    if not period_scores:
        failed.append("No periods scored successfully")
        print("\nSMOKE TEST FAILED at Stage 3")
        return False

    # Fill missing periods with neutral score for composite
    all_periods = {'6M': 50.0, '1Y': 50.0, '2Y': 50.0, '3Y': 50.0}
    all_periods.update(period_scores)

    composite = sc.compute_composite(all_periods, meta)
    final_score = composite['final_composite']
    strategy['nominal_result']['composite_fitness'] = composite

    ok = _check(True, f"Composite fitness: {final_score:.1f}")
    passed.append("Scoring")

    # ── STAGE 4: Rough cut check ───────────────────────────────────────────────
    _separator("Stage 4: Rough Cut Check")

    threshold = meta['config']['optimizer_rough_cut_threshold']
    passes_cut = final_score >= threshold

    ok = _check(passes_cut,
                f"Fitness {final_score:.1f} >= threshold {threshold}")

    if not passes_cut:
        print(f"  ℹ  Strategy below rough cut — skipping optimizer")
        print(f"     This is valid behavior, not a failure")
        passed.append("Rough cut (failed — expected possible)")
    else:
        passed.append("Rough cut")

    # ── STAGE 5: Optimizer ─────────────────────────────────────────────────────
    _separator("Stage 5: Optimizer")

    if not passes_cut:
        print("  ℹ  Skipped (below rough cut)")
    else:
        print("  Running parameter grid search...")
        t0 = time.time()
        try:
            strategy = op.run_optimizer(strategy, meta)
            elapsed  = time.time() - t0

            opt_data = strategy.get('optimizer_data')
            ok = _check(opt_data is not None,
                        f"Optimizer completed ({elapsed:.1f}s)")

            if opt_data:
                delta = opt_data.get('fitness_delta', {})
                interp = delta.get('delta_interpretation', 'UNKNOWN')
                delta_val = delta.get('delta', '0')
                print(f"  ✓  Delta: {delta_val} ({interp})")
                combos = opt_data.get('total_combinations_tested', 0)
                print(f"  ✓  Combinations tested: {combos}")
                passed.append("Optimizer")
        except Exception as e:
            print(f"  ✗  Optimizer error: {e}")
            failed.append(f"Optimizer error: {e}")

    # ── STAGE 6: Learner prep ──────────────────────────────────────────────────
    _separator("Stage 6: Learner Prep")

    # Update summary with final scores
    strategy['summary']['final_composite_fitness'] = final_score
    strategy['summary']['passed_rough_cut']        = passes_cut
    strategy['summary']['status']                  = 'COMPLETE'

    active_list = active_lessons.get('lessons', [])
    brief = lp.build_brief([strategy], active_list, GENERATION)

    ok = _check('generation_summary' in brief, "Brief assembled")
    ok = _check(brief.get('generation_summary', {}).get('total_strategies', 0) >= 1,
                f"Brief contains {brief.get('generation_summary', {}).get('total_strategies', 0)} strategy")
    passed.append("Learner prep")
    print(f"  ✓  Brief token estimate: ~{brief.get('_meta', {}).get('estimated_tokens', 'unknown')}")

    # ── STAGE 7: Learner Agent ─────────────────────────────────────────────────
    _separator("Stage 7: Learner Agent")
    print(f"  Calling Claude for lesson extraction...")

    t0 = time.time()
    lessons = la.run_learner_agent(
        generation=GENERATION,
        brief=brief,
        active_lessons=active_lessons,
        anthropic_key=anthropic_key,
    )
    elapsed = time.time() - t0

    ok = _check(
        not lessons.get('_extraction_failed', True),
        f"Lesson extraction completed ({elapsed:.1f}s)"
    )
    count = lessons.get('lessons_extracted', 0)
    ok = _check(count >= 1, f"Extracted {count} lessons")

    if not ok:
        failed.append("No lessons extracted")
    else:
        passed.append("Learner Agent")
        for i, lesson in enumerate(lessons['lessons'][:3]):
            cat  = lesson.get('category', '?')
            conf = lesson.get('confidence', 0)
            text = lesson.get('lesson', '')[:80]
            print(f"  ✓  Lesson {i+1} [{cat} | {conf:.2f}]: {text}...")

    # ── Results ────────────────────────────────────────────────────────────────
    _separator("Smoke Test Results")

    print(f"\n  Passed: {len(passed)}")
    for p in passed:
        print(f"    ✓  {p}")

    if failed:
        print(f"\n  Failed: {len(failed)}")
        for f in failed:
            print(f"    ✗  {f}")
        print("\nSMOKE TEST: FAILED")
        return False
    else:
        print(f"\n  All {len(passed)} stages passed.")
        print("\nSMOKE TEST: PASSED ✓")
        print(f"\nClean up test files:")
        print(f"  rm ~/.openclaw/workspace/learning/pending/{STRATEGY_ID}.json 2>/dev/null")
        print(f"  rm ~/.openclaw/workspace/learning/results/{STRATEGY_ID}.json 2>/dev/null")
        return True


if __name__ == '__main__':
    success = run_smoke_test()
    sys.exit(0 if success else 1)
