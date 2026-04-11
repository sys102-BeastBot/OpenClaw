"""
orchestrator.py — Chains all phases of one complete generation of the learning loop.

Called by cron via run_generation.sh. Never called directly by other modules.

NEVER calls Claude API directly — delegates to generator_agent.py and learner_agent.py.
NEVER writes to KB directly — delegates to kb_writer.py.
READS meta.json at the start of every generation — never caches it.
"""

from __future__ import annotations

import copy
import json
import os
import sys
import time
import traceback
from datetime import datetime, timezone
from typing import Optional

_SRC_DIR = os.path.dirname(os.path.abspath(__file__))
if _SRC_DIR not in sys.path:
    sys.path.insert(0, _SRC_DIR)

from kb_writer import (
    META_PATH,
    LESSONS_ACTIVE_PATH,
    LESSONS_INDEX_PATH,
    LESSONS_RAW_DIR,
    read_json,
    write_json_atomic,
    update_meta,
    archive_to_history,
    KBNotFoundError,
)
from monitor_agent import log_event, send_telegram_alert, get_daily_spend, get_monthly_spend
from credentials import CredentialManager

# ---------------------------------------------------------------------------
# Locked configuration
# ---------------------------------------------------------------------------

STRATEGIES_PER_GENERATION:     int        = 6
PERIODS:                        list[str]  = ["6M", "1Y", "2Y", "3Y"]
OPTIMIZER_COMBINATION_CAP:      int        = 200
PARTIAL_FAILURE_THRESHOLD:      int        = 3   # min scored strategies to continue
COMPACTION_INTERVAL:            int        = 3   # run compactor every N generations

# ---------------------------------------------------------------------------
# Utility
# ---------------------------------------------------------------------------

def _now_iso() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _elapsed(start: float) -> float:
    return round(time.monotonic() - start, 1)


def _safe_import(name: str):
    """Import a module by name, returning None on failure."""
    try:
        import importlib
        return importlib.import_module(name)
    except ImportError:
        return None


# ---------------------------------------------------------------------------
# Phase 0 — Safety checks
# ---------------------------------------------------------------------------

def _check_system_state(meta: dict) -> tuple[bool, str]:
    """Check if system is safe to run.

    Args:
        meta: Full meta.json contents.

    Returns:
        Tuple of (can_run: bool, reason: str).
    """
    system = meta.get("system", {})

    if system.get("halted", False):
        reason = system.get("halt_reason", "unknown")
        return False, f"System halted: {reason}"

    if not system.get("execution_permitted", False):
        return False, "Execution not permitted"

    if system.get("system_mode") == "DEPLOY":
        return False, "Cannot run in DEPLOY mode"

    return True, "OK"


# ---------------------------------------------------------------------------
# Dry-run mock helpers
# ---------------------------------------------------------------------------

def _make_mock_strategy(archetype: str, generation: int, slot: int) -> dict:
    """Return a minimal valid mock strategy for dry-run mode."""
    sid = f"gen-{generation:03d}-strat-{slot:02d}"
    return {
        "summary": {
            "strategy_id": sid,
            "name": f"DryRun {archetype} S{slot}",
            "archetype": archetype,
            "generation": generation,
            "final_composite_fitness": None,
            "final_sharpe_1Y": None,
            "final_return_1Y": None,
            "final_max_drawdown_1Y": None,
            "final_std_dev": None,
            "optimization_delta": None,
            "passed_rough_cut": None,
            "disqualified": False,
            "status": "PENDING",
            "rebalance_frequency": "daily",
        },
        "identity": {
            "strategy_id": sid,
            "name": f"DryRun {archetype} S{slot}",
            "generation": generation,
            "archetype": archetype,
            "slot_number": slot,
            "created_at": _now_iso(),
            "rebalance_frequency": "daily",
            "composer_rebalance_value": {"asset-class": "EQUITIES", "rebalance-frequency": "daily"},
            "composer_symphony_id": None,
        },
        "strategy": {
            "description": {"summary": "Dry run strategy", "logic_explanation": "Mock",
                            "regime_behavior": {"crash": "BIL", "normal": "TQQQ"},
                            "archetype_rationale": "test", "parameter_choices": {}},
            "composer_json": {"step": "wt-cash-equal", "children": [
                {"step": "asset", "ticker": "BIL", "children": []},
            ]},
        },
        "lineage": {"parent_ids": [], "parent_patterns": [], "generation_type": "NOVEL",
                    "mutation_description": None, "is_seed": False, "seed_source": None},
        "nominal_result": None,
        "optimizer_data": None,
        "final_result": None,
        "pipeline": {
            "current_status": "PENDING",
            "status_history": [{"status": "PENDING", "timestamp": _now_iso()}],
            "error_log": [],
            "retry_count": 0,
            "disqualified": False,
            "disqualification_reason": None,
            "disqualified_at": None,
            "archived": False,
            "archived_at": None,
            "archive_path": None,
        },
        "learner_metadata": {
            "processed": False, "processed_at": None, "lessons_extracted": 0,
            "lesson_ids": [], "patterns_contributed": [],
            "contributed_to_graveyard": False, "graveyard_entry_id": None,
            "contributed_to_lineage": True, "notes": None,
        },
    }


def _make_mock_period_stats(period: str) -> dict:
    return {
        "period": period,
        "start_date": "2025-03-22",
        "end_date": "2026-03-22",
        "core_metrics": {
            "annualized_return": 45.0, "total_return": 45.0,
            "sharpe": 1.8, "max_drawdown": 12.0,
            "volatility": 18.0, "win_rate": 60.0,
        },
        "benchmark_metrics": {
            "benchmark_ticker": "SPY",
            "benchmark_annualized_return": 24.1,
            "beats_benchmark": True,
            "alpha": None, "beta": None, "r_squared": None, "correlation": None,
        },
        "fitness": None,
        "raw_api_fields": {},
    }


def _apply_mock_nominal_result(strategy: dict, meta: dict) -> dict:
    """Fill a strategy with mock backtest results for dry-run mode.

    Populates composite_fitness and passes rough cut so the strategy proceeds
    through scoring, optimizer, and validation phases.
    """
    import copy as _copy
    result = _copy.deepcopy(strategy)
    rough_cut = float(meta.get("config", {}).get("optimizer_rough_cut_threshold", 40.0))
    mock_fitness = rough_cut + 25.0  # well above rough cut

    periods_data = {}
    for p in PERIODS:
        pd = _make_mock_period_stats(p)
        pd["fitness"] = {
            "sharpe_component": 18.0, "return_component": 18.0,
            "drawdown_penalty": 3.0,
            "bonuses_applied": {"sharpe_bonus": False, "drawdown_bonus": False,
                                 "return_bonus": False, "benchmark_bonus": False},
            "total_bonus_points": 0,
            "period_fitness_score": mock_fitness,
        }
        periods_data[p] = pd

    period_scores = {p: mock_fitness for p in PERIODS}
    result["nominal_result"] = {
        "status": "COMPLETE",
        "completed_at": _now_iso(),
        "parameters_used": {},
        "periods": periods_data,
        "composite_fitness": {
            "period_scores":         period_scores,
            "weighted_composite":    mock_fitness - 2.0,
            "std_dev":               0.0,
            "consistency_adjustment": 2.0,
            "final_composite":       mock_fitness,
            "passed_rough_cut":      True,
        },
        "api_calls_used": 0,
        "api_call_ms": 0,
    }
    result["pipeline"]["current_status"] = "NOMINAL_COMPLETE"
    result["summary"]["status"] = "NOMINAL_COMPLETE"
    result["summary"]["final_composite_fitness"] = mock_fitness
    result["summary"]["passed_rough_cut"] = True
    return result


# ---------------------------------------------------------------------------
# Phase helpers
# ---------------------------------------------------------------------------

def _file_disqualified(strategy: dict, reason: str, trigger: dict, errors: list[str]) -> dict:
    """Attempt to file a strategy in the graveyard. Errors are non-fatal."""
    try:
        import graveyard
        graveyard.file_disqualified(strategy, reason, trigger)
    except Exception as exc:
        errors.append(f"graveyard.file_disqualified failed: {exc}")
    s = copy.deepcopy(strategy)
    s["summary"]["disqualified"] = True
    s["summary"]["status"] = "DISQUALIFIED"
    s["pipeline"]["current_status"] = "DISQUALIFIED"
    s["pipeline"]["disqualified"] = True
    s["pipeline"]["disqualification_reason"] = reason
    s["pipeline"]["disqualified_at"] = _now_iso()
    return s


def _score_strategy(strategy: dict, meta: dict, errors: list[str]) -> tuple[dict, bool]:
    """Score a strategy's nominal result. Returns (updated_strategy, was_disqualified)."""
    try:
        import scorer
        periods = strategy.get("nominal_result", {}).get("periods", {})
        period_scores = {}
        archetype = strategy["summary"]["archetype"]

        for period, period_data in periods.items():
            # Check disqualifiers per period
            is_disq, reason = scorer.check_disqualifiers(period_data, meta)
            if is_disq:
                trigger = _build_disq_trigger(period_data, meta, reason, period)
                strategy = _file_disqualified(strategy, reason, trigger, errors)
                return strategy, True

            # Score the period
            scored_period = scorer.score_period(period_data, archetype, meta)
            strategy["nominal_result"]["periods"][period] = scored_period
            fit = scored_period.get("fitness", {}) or {}
            period_scores[period] = fit.get("period_fitness_score", 0.0)

        # Compute composite
        if len(period_scores) == len(PERIODS):
            composite = scorer.compute_composite(period_scores, meta)
            strategy["nominal_result"]["composite_fitness"] = composite

            final = composite.get("final_composite", 0.0)
            strategy["summary"]["final_composite_fitness"] = final
            passed = final >= meta.get("config", {}).get("optimizer_rough_cut_threshold", 40.0)
            strategy["summary"]["passed_rough_cut"] = passed
            strategy["nominal_result"]["composite_fitness"]["passed_rough_cut"] = passed

    except Exception as exc:
        errors.append(f"Scoring failed for {strategy['summary']['strategy_id']}: {exc}")

    return strategy, False


def _build_disq_trigger(period_data: dict, meta: dict, reason: str, period: str) -> dict:
    """Build a graveyard trigger dict from a period stats block."""
    disq = meta.get("fitness", {}).get("disqualifiers", {})
    core = period_data.get("core_metrics", {})
    metric_map = {
        "CATASTROPHIC_LOSS":  ("annualized_return", disq.get("min_return", -20.0)),
        "UNACCEPTABLE_RISK":  ("max_drawdown",      disq.get("max_drawdown", 65.0)),
        "WORSE_THAN_RANDOM":  ("sharpe",            disq.get("min_sharpe", -1.0)),
    }
    metric, threshold = metric_map.get(reason, ("unknown", 0.0))
    return {
        "metric":    metric,
        "value":     core.get(metric),
        "threshold": threshold,
        "period":    period,
    }


# ---------------------------------------------------------------------------
# Phase 10 helper — build generation summary and Telegram message
# ---------------------------------------------------------------------------

def _build_generation_summary(
    generation: int,
    ranked: list[dict],
    gen_stats: dict,
    graveyarded: list[dict],
    quarantined: list[dict],
    lessons_result: dict,
    compaction_summary: Optional[dict],
    elapsed_seconds: float,
    new_best: bool,
    next_allocation: dict,
    errors: list[str],
    dry_run: bool = False,
) -> dict:
    """Build the generation summary dict and format the Telegram scorecard."""
    scored_count = len(ranked)
    grav_count   = len(graveyarded)
    quar_count   = len(quarantined)
    total        = scored_count + grav_count + quar_count

    best_fitness   = gen_stats.get("best_fitness")
    avg_fitness    = gen_stats.get("avg_fitness")
    std_dev        = gen_stats.get("std_dev_fitness", 0.0)
    best_sid       = gen_stats.get("best_strategy_id", "")
    best_name      = ""
    best_archetype = ""
    for s in ranked:
        if s.get("summary", {}).get("strategy_id") == best_sid:
            best_name      = s["summary"].get("name", "")
            best_archetype = s["summary"].get("archetype", "")
            break

    # Cost from monitor
    try:
        daily_cost   = get_daily_spend()
        monthly_cost = get_monthly_spend()
    except Exception:
        daily_cost   = 0.0
        monthly_cost = 0.0

    # Lessons breakdown
    lessons_data    = lessons_result or {}
    extracted_count = lessons_data.get("lessons_extracted", 0)
    skipped         = lessons_data.get("_skipped", False)
    skip_reason     = lessons_data.get("_skip_reason", None)

    lesson_cats = {"indicator": 0, "structure": 0, "anti_pattern": 0}
    for lesson in lessons_data.get("lessons", []):
        cat = lesson.get("category", "")
        if cat in lesson_cats:
            lesson_cats[cat] += 1

    # Active lesson count
    active_total = 0
    try:
        active = read_json(LESSONS_ACTIVE_PATH)
        active_total = active.get("total_lessons", 0)
    except Exception:
        pass

    # Compaction
    compaction_ran    = compaction_summary is not None
    lessons_before_c  = compaction_summary.get("lessons_before") if compaction_ran else None
    lessons_after_c   = compaction_summary.get("lessons_after")  if compaction_ran else None

    status = "COMPLETE"
    if scored_count == 0:
        status = "FAILED"
    elif scored_count < PARTIAL_FAILURE_THRESHOLD:
        status = "PARTIAL"

    summary = {
        "generation":     generation,
        "status":         status,
        "elapsed_seconds": elapsed_seconds,
        "strategies": {
            "total":       total,
            "scored":      scored_count,
            "graveyarded": grav_count,
            "quarantined": quar_count,
        },
        "fitness": {
            "best":              best_fitness,
            "avg":               avg_fitness,
            "std_dev":           std_dev,
            "best_strategy_id":  best_sid,
            "best_strategy_name": best_name,
            "best_archetype":    best_archetype,
        },
        "new_best_ever": new_best,
        "lessons": {
            "extracted":  extracted_count,
            "active_total": active_total,
            "skipped":    skipped,
            "skip_reason": skip_reason,
        },
        "compaction": {
            "ran":            compaction_ran,
            "lessons_before": lessons_before_c,
            "lessons_after":  lessons_after_c,
        },
        "cost": {
            "this_generation_usd": daily_cost,
            "total_spend_usd":     monthly_cost,
        },
        "next_allocation": next_allocation,
        "errors": errors,
    }

    # Format Telegram scorecard
    prefix = "[DRY RUN] " if dry_run else ""
    status_emoji = "✅" if status == "COMPLETE" else ("⚠️" if status == "PARTIAL" else "❌")
    new_best_str = "🏆 YES" if new_best else "NO"
    elapsed_str  = f"{int(elapsed_seconds)}s"
    best_str     = f"{best_fitness:.1f}" if best_fitness else "N/A"
    avg_str      = f"{avg_fitness:.1f}"  if avg_fitness  else "N/A"

    alloc_line = "  ".join(
        f"{arch[:2]}: {slots}"
        for arch, slots in (next_allocation or {}).items()
    )

    telegram_msg = (
        f"{prefix}{status_emoji} Generation {generation} Complete ({elapsed_str})\n"
        f"─────────────────────────────────────\n"
        f"Strategies: {scored_count} scored, {grav_count} graveyarded\n"
        f"Best fitness: {best_str} — {best_name} ({best_archetype})\n"
        f"Avg fitness: {avg_str} | StdDev: {std_dev:.1f}\n"
        f"New best ever: {new_best_str}\n"
        f"─────────────────────────────────────\n"
        f"Lessons: {extracted_count} extracted\n"
        f"  {lesson_cats['indicator']} indicator  "
        f"{lesson_cats['structure']} structure  "
        f"{lesson_cats['anti_pattern']} anti-pattern\n"
        f"Active lessons: {active_total}\n"
        f"─────────────────────────────────────\n"
        f"Cost this gen: ~${daily_cost:.2f}\n"
        f"Total spend:   ~${monthly_cost:.2f}\n"
        f"─────────────────────────────────────\n"
        f"Next gen allocation:\n  {alloc_line}"
    )

    summary["_telegram_message"] = telegram_msg
    return summary


# ---------------------------------------------------------------------------
# Main entry point
# ---------------------------------------------------------------------------

def run_generation(
    generation: int,
    anthropic_key: str,
    dry_run: bool = False,
) -> dict:
    """Run one complete generation of the learning loop.

    Args:
        generation:    Generation number.
        anthropic_key: Anthropic API key string.
        dry_run:       If True, skip real API calls; use mock responses.

    Returns:
        generation_summary dict. Never raises — all errors caught and logged.
    """
    start_time = time.monotonic()
    errors: list[str] = []
    graveyarded:  list[dict] = []
    quarantined:  list[dict] = []
    all_results:  list[dict] = []
    ranked:       list[dict] = []
    gen_stats:    dict       = {}
    lessons_result: dict     = {"_skipped": True, "_skip_reason": "not_started",
                                "lessons_extracted": 0, "lessons": []}
    compaction_summary: Optional[dict] = None
    new_best      = False
    next_allocation: dict = {}

    tag = f"[DRY RUN] " if dry_run else ""

    # ── Phase 0: Safety checks ─────────────────────────────────────────────────
    try:
        meta = read_json(META_PATH)
    except Exception as exc:
        err = f"Phase 0: Cannot read meta.json: {exc}"
        errors.append(err)
        log_event("CRITICAL", "orchestrator", err)
        return {
            "generation": generation, "status": "FAILED",
            "elapsed_seconds": _elapsed(start_time),
            "strategies": {"total": 0, "scored": 0, "graveyarded": 0, "quarantined": 0},
            "fitness": {"best": None, "avg": None, "std_dev": 0.0,
                        "best_strategy_id": "", "best_strategy_name": "", "best_archetype": ""},
            "new_best_ever": False,
            "lessons": {"extracted": 0, "active_total": 0, "skipped": True, "skip_reason": err},
            "compaction": {"ran": False, "lessons_before": None, "lessons_after": None},
            "cost": {"this_generation_usd": 0.0, "total_spend_usd": 0.0},
            "next_allocation": {}, "errors": errors,
        }

    can_run, reason = _check_system_state(meta)
    if not can_run:
        log_event("WARNING", "orchestrator", f"Safety check failed: {reason}")
        send_telegram_alert("WARNING", f"Generation {generation} blocked: {reason}")
        return {
            "generation": generation, "status": "BLOCKED",
            "elapsed_seconds": _elapsed(start_time),
            "strategies": {"total": 0, "scored": 0, "graveyarded": 0, "quarantined": 0},
            "fitness": {"best": None, "avg": None, "std_dev": 0.0,
                        "best_strategy_id": "", "best_strategy_name": "", "best_archetype": ""},
            "new_best_ever": False,
            "lessons": {"extracted": 0, "active_total": 0, "skipped": True, "skip_reason": reason},
            "compaction": {"ran": False, "lessons_before": None, "lessons_after": None},
            "cost": {"this_generation_usd": 0.0, "total_spend_usd": 0.0},
            "next_allocation": {}, "errors": [reason],
        }

    log_event("INFO", "orchestrator", f"{tag}Starting generation {generation}")

    # ── Phase 1: Slot allocation ───────────────────────────────────────────────
    allocation = meta.get("archetype_allocation", {}).get("current", {})
    try:
        import archetype_router
        new_allocation = archetype_router.compute_next_allocation(meta)
        # Only update if the result is non-trivial (total slots > 0)
        if sum(new_allocation.values()) > 0:
            allocation = new_allocation
            log_event("INFO", "orchestrator", f"Slot allocation: {allocation}")
            update_meta({"archetype_allocation": {
                **meta.get("archetype_allocation", {}),
                "current": allocation,
            }})
            meta = read_json(META_PATH)  # re-read after update
    except Exception as exc:
        errors.append(f"Phase 1 (allocation) error: {exc}")
        log_event("WARNING", "orchestrator", f"Phase 1 error: {exc}\n{traceback.format_exc()}")

    # ── Phase 2: Strategy generation ──────────────────────────────────────────
    strategies: list[dict] = []
    try:
        if dry_run:
            slot = 1
            for arch, count in meta.get("archetype_allocation", {}).get("current", {}).items():
                for _ in range(count):
                    strategies.append(_make_mock_strategy(arch, generation, slot))
                    slot += 1
        else:
            import generator_agent
            strategies = generator_agent.run_generation(generation, anthropic_key, meta)
    except Exception as exc:
        errors.append(f"Phase 2 (generation) error: {exc}")
        log_event("CRITICAL", "orchestrator", f"Phase 2 error: {exc}\n{traceback.format_exc()}")
        strategies = []

    if not strategies:
        err = "zero_strategies_generated"
        log_event("CRITICAL", "orchestrator", f"{tag}Phase 2: {err}")
        send_telegram_alert("CRITICAL", f"{tag}Generation {generation} FAILED: {err}")
        return {
            "generation": generation, "status": "FAILED",
            "elapsed_seconds": _elapsed(start_time),
            "strategies": {"total": 0, "scored": 0, "graveyarded": 0, "quarantined": 0},
            "fitness": {"best": None, "avg": None, "std_dev": 0.0,
                        "best_strategy_id": "", "best_strategy_name": "", "best_archetype": ""},
            "new_best_ever": False,
            "lessons": {"extracted": 0, "active_total": 0, "skipped": True, "skip_reason": err},
            "compaction": {"ran": False, "lessons_before": None, "lessons_after": None},
            "cost": {"this_generation_usd": 0.0, "total_spend_usd": 0.0},
            "next_allocation": allocation if "allocation" in dir() else {},
            "errors": errors,
        }

    # ── Phase 3: Nominal backtest + score + rough cut ─────────────────────────
    scored_strategies: list[dict] = []

    for strategy in strategies:
        sid = strategy["summary"]["strategy_id"]
        try:
            if dry_run:
                strategy = _apply_mock_nominal_result(strategy, meta)
            else:
                import backtest_runner
                strategy = backtest_runner.run_nominal_backtest(strategy, PERIODS, meta)

            # Check if backtest itself disqualified (e.g. INVALID_JSON)
            if strategy["pipeline"].get("current_status") == "DISQUALIFIED":
                graveyarded.append(strategy)
                all_results.append(strategy)
                continue

            # Score periods and check disqualifiers (skip in dry_run — mock data already scored)
            was_disqualified = False
            if not dry_run:
                strategy, was_disqualified = _score_strategy(strategy, meta, errors)
            if was_disqualified:
                graveyarded.append(strategy)
                all_results.append(strategy)
                continue

            # Rough cut check
            composite = (strategy.get("nominal_result") or {}).get("composite_fitness") or {}
            final_score = composite.get("final_composite", 0.0)
            rough_cut = meta.get("config", {}).get("optimizer_rough_cut_threshold", 40.0)

            if not composite.get("passed_rough_cut", False) and final_score < rough_cut:
                log_event("INFO", "orchestrator",
                          f"{sid} failed rough cut (score={final_score:.1f})")
                # File as poor performer candidate — goes to graveyard via ranker/graveyard
                try:
                    import graveyard as gv_mod
                    import ranker
                    gen_stats_tmp = {
                        "avg_fitness": final_score,
                        "std_dev_fitness": 0.0,
                    }
                    if gv_mod.is_poor_performer(final_score, gen_stats_tmp, meta):
                        perf = {
                            "nominal_composite_fitness": final_score,
                            "final_composite_fitness": None,
                            "optimization_delta": None,
                            "best_period_score": max(composite.get("period_scores", {}).values(), default=0.0),
                            "worst_period_score": min(composite.get("period_scores", {}).values(), default=0.0),
                            "annualized_return_1Y": (strategy.get("nominal_result", {}) or {})
                                .get("periods", {}).get("1Y", {}).get("core_metrics", {})
                                .get("annualized_return"),
                            "sharpe_1Y": (strategy.get("nominal_result", {}) or {})
                                .get("periods", {}).get("1Y", {}).get("core_metrics", {})
                                .get("sharpe"),
                            "max_drawdown_1Y": (strategy.get("nominal_result", {}) or {})
                                .get("periods", {}).get("1Y", {}).get("core_metrics", {})
                                .get("max_drawdown"),
                        }
                        gv_mod.file_poor_performer(strategy, perf)
                        graveyarded.append(strategy)
                        all_results.append(strategy)
                        continue
                except Exception as exc:
                    errors.append(f"Rough cut filing error for {sid}: {exc}")

            scored_strategies.append(strategy)

        except Exception as exc:
            errors.append(f"Phase 3 error for {sid}: {exc}")
            log_event("WARNING", "orchestrator",
                      f"Phase 3 error for {sid}: {exc}\n{traceback.format_exc()}")
            all_results.append(strategy)

    # ── Partial failure check ──────────────────────────────────────────────────
    scored_count = len(scored_strategies)
    if scored_count < PARTIAL_FAILURE_THRESHOLD:
        msg = (f"{tag}Gen {generation}: only {scored_count} strategies scored "
               f"(threshold={PARTIAL_FAILURE_THRESHOLD})")
        log_event("WARNING", "orchestrator", msg)
        if scored_count <= 1:
            send_telegram_alert("CRITICAL" if scored_count == 0 else "WARNING", msg)
        else:
            send_telegram_alert("WARNING", msg)

    # ── Phase 4: Optimizer ────────────────────────────────────────────────────
    optimized_strategies: list[dict] = []
    for strategy in scored_strategies:
        sid = strategy["summary"]["strategy_id"]
        try:
            if dry_run:
                strategy["optimizer_data"] = {
                    "status": "COMPLETE",
                    "total_combinations_tested": 0,
                    "api_calls_used": 0,
                    "search_basis": {},
                    "parameter_sensitivity": {},
                    "optimal_parameters": {},
                    "parameter_diff": {},
                    "fitness_delta": {"delta": "+0.0", "delta_interpretation": "NEGLIGIBLE",
                                     "nominal_composite": 0.0, "optimized_composite": 0.0},
                    "started_at": _now_iso(),
                    "completed_at": _now_iso(),
                }
                strategy["summary"]["optimization_delta"] = "+0.0"
            else:
                composite = (strategy.get("nominal_result") or {}).get("composite_fitness") or {}
                if composite.get("passed_rough_cut", False):
                    import optimizer
                    strategy = optimizer.run_optimizer(strategy, meta)
        except Exception as exc:
            errors.append(f"Phase 4 (optimizer) error for {sid}: {exc}")
            log_event("WARNING", "orchestrator",
                      f"Phase 4 error for {sid}: {exc}\n{traceback.format_exc()}")
        optimized_strategies.append(strategy)

    # ── Phase 5: Validation backtest ──────────────────────────────────────────
    validated_strategies: list[dict] = []
    for strategy in optimized_strategies:
        sid = strategy["summary"]["strategy_id"]
        try:
            opt_data = strategy.get("optimizer_data") or {}
            optimal  = opt_data.get("optimal_parameters") or {}
            if not dry_run and optimal:
                import backtest_runner
                strategy = backtest_runner.run_validation_backtest(
                    strategy, optimal, PERIODS, meta)
            strategy["summary"]["status"] = "COMPLETE"
            strategy["pipeline"]["current_status"] = "COMPLETE"
        except Exception as exc:
            errors.append(f"Phase 5 (validation) error for {sid}: {exc}")
            log_event("WARNING", "orchestrator",
                      f"Phase 5 error for {sid}: {exc}\n{traceback.format_exc()}")
        validated_strategies.append(strategy)

    all_results.extend(validated_strategies)

    # ── Phase 6: Rank ─────────────────────────────────────────────────────────
    try:
        import ranker
        ranked    = ranker.rank_generation(all_results, meta)
        gen_stats = ranker.compute_generation_stats(all_results)
        new_best, _ = ranker.check_new_best(ranked, meta)
    except Exception as exc:
        errors.append(f"Phase 6 (ranking) error: {exc}")
        log_event("WARNING", "orchestrator", f"Phase 6 error: {exc}")
        ranked    = validated_strategies
        gen_stats = {}

    if new_best:
        log_event("INFO", "orchestrator",
                  f"{tag}Gen {generation}: NEW BEST EVER strategy!")

    # ── Phase 7: Learner ──────────────────────────────────────────────────────
    if scored_count <= 1:
        lessons_result = {
            "_skipped": True,
            "_skip_reason": f"insufficient_scored_strategies ({scored_count})",
            "lessons_extracted": 0,
            "lessons": [],
        }
        log_event("WARNING", "orchestrator",
                  f"{tag}Learner skipped — insufficient scored strategies ({scored_count})")
    else:
        try:
            # Load active lessons for context
            try:
                active_lessons = read_json(LESSONS_ACTIVE_PATH)
            except KBNotFoundError:
                active_lessons = {"lessons": []}

            from learner_prep import build_brief
            brief = build_brief(all_results, active_lessons.get("lessons", []), generation)

            if dry_run:
                lessons_result = {
                    "_skipped": False,
                    "_skip_reason": None,
                    "generation": generation,
                    "created_at": _now_iso(),
                    "strategies_analyzed": len(all_results),
                    "strategy_ids_analyzed": [s["summary"]["strategy_id"] for s in all_results],
                    "claude_model": "dry-run",
                    "prompt_tokens": 0,
                    "completion_tokens": 0,
                    "lessons_extracted": 2,
                    "lessons": [
                        {"id": "tmp-001", "category": "indicator", "lesson": "Mock lesson 1",
                         "confidence": 0.6, "decay": True, "times_reinforced": 1,
                         "times_contradicted": 0, "archetypes": ["ALL"],
                         "apply_to_active": True, "merge_candidate_ids": [],
                         "source": "generation", "subcategory": "test",
                         "first_seen_generation": generation, "last_seen_generation": generation,
                         "created_at": _now_iso(), "last_updated_at": _now_iso(),
                         "supporting_evidence": [], "parameter_data": None,
                         "regime_context": None, "apply_to_next": True},
                        {"id": "tmp-002", "category": "structure", "lesson": "Mock lesson 2",
                         "confidence": 0.6, "decay": True, "times_reinforced": 1,
                         "times_contradicted": 0, "archetypes": ["ALL"],
                         "apply_to_active": True, "merge_candidate_ids": [],
                         "source": "generation", "subcategory": "test",
                         "first_seen_generation": generation, "last_seen_generation": generation,
                         "created_at": _now_iso(), "last_updated_at": _now_iso(),
                         "supporting_evidence": [], "parameter_data": None,
                         "regime_context": None, "apply_to_next": True},
                    ],
                    "compaction_notes": {
                        "confirmed_lesson_ids": [], "contradicted_lesson_ids": [],
                        "merge_suggestions": [], "retire_suggestions": [],
                        "promote_suggestions": [],
                    },
                    "_extraction_failed": False,
                }
            else:
                import learner_agent
                lessons_result = learner_agent.run_learner_agent(
                    generation, brief, active_lessons, anthropic_key)

            if not lessons_result.get("_extraction_failed", False):
                lessons_result["_skipped"] = False
                lessons_result["_skip_reason"] = None
                # Write raw lessons file
                raw_path = os.path.join(LESSONS_RAW_DIR,
                                        f"gen-{generation:03d}-lessons.json")
                write_json_atomic(raw_path, lessons_result)

                # Update lessons/index.json
                try:
                    from kb_writer import read_json as _rj
                    idx = _rj(LESSONS_INDEX_PATH)
                except KBNotFoundError:
                    idx = {"version": "1.0", "last_updated": _now_iso(),
                           "summary": {"total_raw_files": 0, "total_raw_lessons": 0,
                                       "total_active_lessons": 0,
                                       "last_compacted_generation": 0,
                                       "next_compaction_generation": 3,
                                       "compaction_count": 0},
                           "raw_files": [], "active_lesson_coverage": {},
                           "compaction_history": []}

                raw_files = idx.setdefault("raw_files", [])
                raw_files.append({
                    "filename": f"gen-{generation:03d}-lessons.json",
                    "generation": generation,
                    "lessons_count": lessons_result.get("lessons_extracted", 0),
                    "created_at": _now_iso(),
                    "fully_processed": False,
                    "compacted_into_generation": None,
                })
                idx["last_updated"] = _now_iso()
                idx_summary = idx.setdefault("summary", {})
                idx_summary["total_raw_files"] = len(raw_files)
                idx_summary["total_raw_lessons"] = sum(
                    e.get("lessons_count", 0) for e in raw_files)
                write_json_atomic(LESSONS_INDEX_PATH, idx)
            else:
                lessons_result["_skipped"] = True
                lessons_result["_skip_reason"] = "extraction_failed"

        except Exception as exc:
            errors.append(f"Phase 7 (learner) error: {exc}")
            log_event("WARNING", "orchestrator",
                      f"Phase 7 error: {exc}\n{traceback.format_exc()}")

    # ── Phase 8: Compact (if due) ─────────────────────────────────────────────
    if generation % COMPACTION_INTERVAL == 0:
        try:
            import compactor
            meta = read_json(META_PATH)  # fresh read
            compaction_summary = compactor.run_compaction(generation, meta)
            log_event("INFO", "orchestrator",
                      f"Compaction ran: {compaction_summary['lessons_after']} active lessons")
        except Exception as exc:
            errors.append(f"Phase 8 (compaction) error: {exc}")
            log_event("WARNING", "orchestrator",
                      f"Phase 8 error: {exc}\n{traceback.format_exc()}")

    # ── Phase 9: Archive + cleanup ────────────────────────────────────────────
    for strategy in all_results:
        sid = strategy["summary"]["strategy_id"]
        try:
            archive_to_history(sid, generation)
        except Exception as exc:
            errors.append(f"Phase 9 archive error for {sid}: {exc}")

    # Update archetype performance history
    try:
        meta = read_json(META_PATH)
        import archetype_router
        updated_meta = archetype_router.update_performance_history(meta, gen_stats)
        next_allocation = archetype_router.compute_next_allocation(updated_meta)
        update_meta({
            "archetype_allocation": updated_meta.get("archetype_allocation", {}),
            "generations": {
                **meta.get("generations", {}),
                "total_completed": meta.get("generations", {}).get("total_completed", 0) + 1,
                "total_strategies_generated":
                    meta.get("generations", {}).get("total_strategies_generated", 0)
                    + len(all_results),
                "total_strategies_disqualified":
                    meta.get("generations", {}).get("total_strategies_disqualified", 0)
                    + len(graveyarded),
                "last_generation_completed_at": _now_iso(),
            },
        })
    except Exception as exc:
        errors.append(f"Phase 9 meta update error: {exc}")
        log_event("WARNING", "orchestrator",
                  f"Phase 9 meta update error: {exc}\n{traceback.format_exc()}")

    # ── Phase 10: Generation summary + Telegram ───────────────────────────────
    elapsed = _elapsed(start_time)
    summary = _build_generation_summary(
        generation=generation,
        ranked=ranked,
        gen_stats=gen_stats,
        graveyarded=graveyarded,
        quarantined=quarantined,
        lessons_result=lessons_result,
        compaction_summary=compaction_summary,
        elapsed_seconds=elapsed,
        new_best=new_best,
        next_allocation=next_allocation,
        errors=errors,
        dry_run=dry_run,
    )

    telegram_msg = summary.pop("_telegram_message", "")
    level = "INFO" if summary["status"] == "COMPLETE" else "WARNING"
    send_telegram_alert(level, telegram_msg)
    log_event("INFO", "orchestrator",
              f"{tag}Generation {generation} {summary['status']} in {elapsed}s")

    return summary


# ---------------------------------------------------------------------------
# CLI entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Run one generation of the learning loop.")
    parser.add_argument("--generation", type=int, default=None,
                        help="Generation number. If not set, reads from meta.json")
    parser.add_argument("--dry-run", action="store_true",
                        help="Skip real API calls. Uses mock responses.")
    args = parser.parse_args()

    if args.generation is None:
        meta = read_json(META_PATH)
        generation = meta["generations"]["current"]
    else:
        generation = args.generation

    key     = CredentialManager().get_anthropic_key()
    summary = run_generation(generation, key, dry_run=args.dry_run)
    print(json.dumps(summary, indent=2))
