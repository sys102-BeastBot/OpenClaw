"""
learner_prep.py — Pre-process backtest results into a clean brief for the Learner Agent.

READ ONLY — never writes to the KB. Pure data transformation.

Claude never sees raw results files. This module summarises everything into
a single structured dict (the brief) that stays under ~8000 tokens when
serialised to JSON.

Inputs:
    results       : list of fully-scored strategy dicts (loaded by caller)
    active_lessons: list of lesson dicts from lessons/active.json (loaded by caller)
    generation    : int generation number

Output:
    dict — the brief, containing six sections as described in the module
           docstring and matching the spec in SKILL.md.

Schema reference: Section 2 (results file), Section 3 (period stats block).
"""

import json
import math
import statistics
from collections import Counter, defaultdict
from typing import Any, Optional

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

BRIEF_TOKEN_BUDGET = 8000   # approximate token target for the serialised brief
CHARS_PER_TOKEN    = 4      # rough estimate: 1 token ≈ 4 chars

MAX_RANKED_STRATEGIES    = 12   # cap to control brief size
MAX_PARAM_VALUES_SHOWN   = 5    # top N winning parameter values per param
MAX_COMPACTION_HINTS     = 10   # per category
MAX_LESSON_CHARS         = 200  # truncate individual lesson text in brief

DELTA_THRESHOLDS = {
    "strong_gain":   5.0,
    "moderate_gain": 2.0,
    "minimal_gain":  0.0,
    "minimal_loss": -2.0,
    "significant_loss": -5.0,
}

# ---------------------------------------------------------------------------
# Exceptions
# ---------------------------------------------------------------------------

class LearnerPrepError(Exception):
    """Raised when brief assembly fails due to malformed input data."""


# ---------------------------------------------------------------------------
# Main entry point
# ---------------------------------------------------------------------------

def build_brief(
    results: list[dict],
    active_lessons: list[dict],
    generation: int,
) -> dict:
    """Assemble the Learner Agent brief from a generation's scored results.

    Args:
        results: List of fully-scored strategy dicts for this generation.
                 Both completed and disqualified strategies should be included.
        active_lessons: List of lesson dicts from lessons/active.json.
                        Passed in by caller — not read from disk here.
        generation: Generation number (int).

    Returns:
        Dict with keys: generation_summary, ranked_strategies,
        parameter_sensitivity, disqualified_summary, active_lessons,
        compaction_hints.

    Raises:
        LearnerPrepError: If results is empty or malformed.
    """
    if not isinstance(results, list):
        raise LearnerPrepError(
            f"results must be a list, got {type(results).__name__}"
        )

    completed    = _completed_strategies(results)
    disqualified = _disqualified_strategies(results)

    brief = {
        "generation": generation,
        "generation_summary":    _build_generation_summary(results, completed, disqualified, generation),
        "ranked_strategies":     _build_ranked_strategies(completed),
        "parameter_sensitivity": _build_parameter_sensitivity(completed),
        "disqualified_summary":  _build_disqualified_summary(disqualified),
        "active_lessons":        _build_active_lessons_section(active_lessons),
        "compaction_hints":      _build_compaction_hints(completed, disqualified, active_lessons),
    }

    # Token budget check — warn in the brief itself if over budget
    serialised_len = len(json.dumps(brief))
    estimated_tokens = serialised_len // CHARS_PER_TOKEN
    brief["_meta"] = {
        "estimated_tokens": estimated_tokens,
        "over_budget": estimated_tokens > BRIEF_TOKEN_BUDGET,
        "budget": BRIEF_TOKEN_BUDGET,
    }

    return brief


# ---------------------------------------------------------------------------
# Section 1: Generation summary
# ---------------------------------------------------------------------------

def _build_generation_summary(
    all_results: list[dict],
    completed: list[dict],
    disqualified: list[dict],
    generation: int,
) -> dict:
    """Build section 1: generation-level statistics."""
    fitness_scores = [_get_fitness(s) for s in completed if _get_fitness(s) is not None]

    n = len(fitness_scores)
    avg_fitness  = round(sum(fitness_scores) / n, 4)       if n > 0 else None
    std_dev      = round(statistics.stdev(fitness_scores), 4) if n > 1 else 0.0
    best_fitness = round(max(fitness_scores), 4)           if n > 0 else None
    worst_fitness = round(min(fitness_scores), 4)          if n > 0 else None

    best_strat   = None
    worst_strat  = None
    for s in completed:
        f = _get_fitness(s)
        if f is not None:
            if f == best_fitness and best_strat is None:
                best_strat = s["summary"]["strategy_id"]
            if f == worst_fitness and worst_strat is None:
                worst_strat = s["summary"]["strategy_id"]

    archetype_stats = _archetype_stats(completed)

    return {
        "generation": generation,
        "total_strategies": len(all_results),
        "total_completed": len(completed),
        "total_disqualified": len(disqualified),
        "avg_fitness": avg_fitness,
        "std_dev_fitness": std_dev,
        "best_fitness": best_fitness,
        "worst_fitness": worst_fitness,
        "best_strategy_id": best_strat,
        "worst_strategy_id": worst_strat,
        "archetype_stats": archetype_stats,
    }


def _archetype_stats(completed: list[dict]) -> dict:
    """Per-archetype count and avg fitness."""
    buckets: dict[str, list[float]] = defaultdict(list)
    for s in completed:
        arch = s["summary"].get("archetype", "UNKNOWN")
        f = _get_fitness(s)
        if f is not None:
            buckets[arch].append(f)
    return {
        arch: {
            "count": len(scores),
            "avg_fitness": round(sum(scores) / len(scores), 4) if scores else None,
        }
        for arch, scores in buckets.items()
    }


# ---------------------------------------------------------------------------
# Section 2: Ranked strategy results
# ---------------------------------------------------------------------------

def _build_ranked_strategies(completed: list[dict]) -> list[dict]:
    """Build section 2: ranked list from best to worst fitness."""
    scored = sorted(
        completed,
        key=lambda s: (_get_fitness(s) or 0.0),
        reverse=True,
    )[:MAX_RANKED_STRATEGIES]

    return [_summarise_strategy(s, rank + 1) for rank, s in enumerate(scored)]


def _summarise_strategy(strategy: dict, rank: int) -> dict:
    """Extract the key fields for one ranked strategy entry."""
    summary  = strategy.get("summary", {})
    strat_b  = strategy.get("strategy", {})
    desc     = strat_b.get("description", {})
    opt_data = strategy.get("optimizer_data") or {}
    nom_res  = strategy.get("nominal_result") or {}
    fin_res  = strategy.get("final_result")   or {}

    # Use final_result if available, otherwise nominal_result
    active_result = fin_res if fin_res else nom_res
    periods  = active_result.get("periods", {})
    comp_fit = active_result.get("composite_fitness", {}) or {}
    p1y      = periods.get("1Y", {})
    core_1y  = p1y.get("core_metrics", {}) or {}

    # Optimization delta
    opt_delta = summary.get("optimization_delta")
    delta_interp = _interpret_delta(opt_delta)

    # Generator deviation from KB priors
    deviated_from_priors = _check_generator_deviation(opt_data)

    # top_level_structure from description summary or composer_json
    top_structure = desc.get("logic_explanation") or desc.get("summary") or ""
    composer_json = strat_b.get("composer_json", {})
    if not top_structure and composer_json:
        top_structure = _quick_structure(composer_json)

    return {
        "rank": rank,
        "strategy_id": summary.get("strategy_id", ""),
        "name": summary.get("name", ""),
        "archetype": summary.get("archetype", ""),
        "final_composite_fitness": _get_fitness(strategy),
        "period_scores": comp_fit.get("period_scores", {}),
        "std_dev": comp_fit.get("std_dev"),
        "sharpe_1Y": core_1y.get("sharpe"),
        "return_1Y": core_1y.get("annualized_return"),
        "drawdown_1Y": core_1y.get("max_drawdown"),
        "passed_rough_cut": summary.get("passed_rough_cut"),
        "optimization_delta": opt_delta,
        "delta_interpretation": delta_interp,
        "top_level_structure": top_structure[:300],   # truncate for token budget
        "parameter_choices": _trim_dict(desc.get("parameter_choices", {}), max_chars=400),
        "deviated_from_priors": deviated_from_priors,
        "rebalance_frequency": summary.get("rebalance_frequency", "daily"),
    }


def _interpret_delta(delta: Optional[str]) -> str:
    """Translate a numeric optimization delta string to a human label."""
    if delta is None:
        return "not_optimized"
    try:
        val = float(delta.lstrip("+"))
    except (ValueError, AttributeError):
        return "unknown"
    if val >= DELTA_THRESHOLDS["strong_gain"]:
        return "strong_gain"
    if val >= DELTA_THRESHOLDS["moderate_gain"]:
        return "moderate_gain"
    if val >= DELTA_THRESHOLDS["minimal_gain"]:
        return "minimal_gain"
    if val >= DELTA_THRESHOLDS["minimal_loss"]:
        return "minimal_loss"
    return "significant_loss"


def _check_generator_deviation(optimizer_data: dict) -> Optional[bool]:
    """Return True if any parameter search_basis was 'generator_deviation_targeted'."""
    if not optimizer_data:
        return None
    basis = optimizer_data.get("search_basis", {})
    return any(v == "generator_deviation_targeted" for v in basis.values())


def _quick_structure(composer_json: dict) -> str:
    """One-liner description of the top-level composer step."""
    step = composer_json.get("step", "unknown")
    children = composer_json.get("children", [])
    if step == "wt-cash-equal":
        tickers = [c.get("ticker", "?") for c in children if c.get("step") == "asset"]
        return f"wt-cash-equal → [{', '.join(tickers)}]"
    if step == "if":
        return f"if-guard ({len(children)} branches)"
    if step == "filter":
        return f"filter top-{composer_json.get('select-n','?')}"
    return step


# ---------------------------------------------------------------------------
# Section 3: Parameter sensitivity summary
# ---------------------------------------------------------------------------

def _build_parameter_sensitivity(completed: list[dict]) -> dict:
    """Build section 3: which parameters were searched and which values won."""
    # Collect all parameter data from optimizer_data.search_basis and
    # optimal_parameters across all strategies
    param_value_counts:    dict[str, Counter] = defaultdict(Counter)
    param_archetype_bests: dict[str, dict[str, list]] = defaultdict(lambda: defaultdict(list))
    params_searched: set[str] = set()

    for s in completed:
        opt = s.get("optimizer_data") or {}
        arch = s["summary"].get("archetype", "UNKNOWN")
        f    = _get_fitness(s)

        # Which params were searched
        basis = opt.get("search_basis", {})
        for param, how in basis.items():
            if how not in ("locked",):
                params_searched.add(param)

        # Winning parameter values
        optimal = opt.get("optimal_parameters", {})
        for param, val in optimal.items():
            if val is not None:
                param_value_counts[param][str(val)] += 1
                if f is not None:
                    param_archetype_bests[param][arch].append((f, val))

    # Build output
    sensitivity: dict[str, Any] = {}
    for param in params_searched:
        top_values = param_value_counts[param].most_common(MAX_PARAM_VALUES_SHOWN)
        arch_optima = {}
        for arch, entries in param_archetype_bests[param].items():
            if entries:
                best_val = max(entries, key=lambda x: x[0])[1]
                arch_optima[arch] = best_val

        sensitivity[param] = {
            "times_searched": sum(param_value_counts[param].values()),
            "top_winning_values": [
                {"value": v, "count": c} for v, c in top_values
            ],
            "archetype_optima": arch_optima,
        }

    # Also note parameters NOT optimized (all locked)
    all_params: set[str] = set()
    for s in completed:
        opt = s.get("optimizer_data") or {}
        all_params.update(opt.get("search_basis", {}).keys())
        all_params.update((s.get("nominal_result") or {}).get("parameters_used", {}).keys())

    locked_params = sorted(all_params - params_searched)

    return {
        "parameters_searched": sorted(params_searched),
        "locked_parameters": locked_params,
        "sensitivity": sensitivity,
        "strategies_with_optimizer_data": sum(
            1 for s in completed if s.get("optimizer_data")
        ),
    }


# ---------------------------------------------------------------------------
# Section 4: Disqualified strategies summary
# ---------------------------------------------------------------------------

def _build_disqualified_summary(disqualified: list[dict]) -> dict:
    """Build section 4: disqualified strategy patterns."""
    reason_counts: Counter = Counter()
    structural_patterns: list[str] = []

    for s in disqualified:
        pipeline = s.get("pipeline", {})
        reason = pipeline.get("disqualification_reason") or \
                 s.get("summary", {}).get("status", "UNKNOWN")
        reason_counts[reason] += 1

        # Structural pattern: top-level composer step
        composer = s.get("strategy", {}).get("composer_json", {})
        pattern  = _quick_structure(composer)
        if pattern and pattern not in structural_patterns:
            structural_patterns.append(pattern)

    # Per-strategy brief
    entries = []
    for s in disqualified:
        summary  = s.get("summary", {})
        pipeline = s.get("pipeline", {})
        nom_res  = s.get("nominal_result") or {}
        periods  = nom_res.get("periods", {})
        p1y_core = (periods.get("1Y") or {}).get("core_metrics") or {}
        entries.append({
            "strategy_id": summary.get("strategy_id", ""),
            "name": summary.get("name", ""),
            "archetype": summary.get("archetype", ""),
            "reason": pipeline.get("disqualification_reason", "UNKNOWN"),
            "max_drawdown_1Y": p1y_core.get("max_drawdown"),
            "sharpe_1Y": p1y_core.get("sharpe"),
            "return_1Y": p1y_core.get("annualized_return"),
        })

    return {
        "total_disqualified": len(disqualified),
        "reason_counts": dict(reason_counts),
        "structural_patterns_failed": structural_patterns,
        "entries": entries,
    }


# ---------------------------------------------------------------------------
# Section 5: Active lessons
# ---------------------------------------------------------------------------

def _build_active_lessons_section(active_lessons: list[dict]) -> list[dict]:
    """Build section 5: trimmed active lessons for Learner context."""
    trimmed = []
    for lesson in active_lessons:
        trimmed.append({
            "lesson_id": lesson.get("lesson_id", lesson.get("id", "")),
            "type": lesson.get("type", ""),
            "text": str(lesson.get("text", lesson.get("content", "")))[:MAX_LESSON_CHARS],
            "confidence": lesson.get("confidence"),
            "times_confirmed": lesson.get("times_confirmed", 0),
            "times_contradicted": lesson.get("times_contradicted", 0),
        })
    return trimmed


# ---------------------------------------------------------------------------
# Section 6: Compaction hints
# ---------------------------------------------------------------------------

def _build_compaction_hints(
    completed: list[dict],
    disqualified: list[dict],
    active_lessons: list[dict],
) -> dict:
    """Build section 6: lessons confirmed/contradicted + new patterns."""
    confirmed:    list[str] = []
    contradicted: list[str] = []
    new_patterns: list[str] = []

    fitness_scores = [_get_fitness(s) for s in completed if _get_fitness(s) is not None]
    avg_fitness = sum(fitness_scores) / len(fitness_scores) if fitness_scores else None

    for lesson in active_lessons:
        lid   = lesson.get("lesson_id", lesson.get("id", ""))
        ltype = lesson.get("type", "")
        text  = str(lesson.get("text", lesson.get("content", "")))

        # Heuristic: check if the lesson's claim holds across this generation
        hint = _evaluate_lesson_against_results(lesson, completed, disqualified)
        if hint == "confirmed" and len(confirmed) < MAX_COMPACTION_HINTS:
            confirmed.append(f"{lid}: {text[:80]}")
        elif hint == "contradicted" and len(contradicted) < MAX_COMPACTION_HINTS:
            contradicted.append(f"{lid}: {text[:80]}")

    # New patterns: recurring structural elements in high scorers
    if avg_fitness is not None:
        high_scorers = [s for s in completed if (_get_fitness(s) or 0) > avg_fitness]
        for pattern in _extract_structural_patterns(high_scorers):
            if len(new_patterns) < MAX_COMPACTION_HINTS:
                new_patterns.append(pattern)

    # Patterns from disqualified (structural failures worth noting)
    for s in disqualified:
        composer = s.get("strategy", {}).get("composer_json", {})
        pattern  = _quick_structure(composer)
        note = f"FAILED: {pattern} ({s['summary'].get('archetype','')})"
        if note not in new_patterns and len(new_patterns) < MAX_COMPACTION_HINTS:
            new_patterns.append(note)

    return {
        "lessons_confirmed": confirmed,
        "lessons_contradicted": contradicted,
        "new_patterns_worth_extracting": new_patterns,
    }


def _evaluate_lesson_against_results(
    lesson: dict,
    completed: list[dict],
    disqualified: list[dict],
) -> Optional[str]:
    """Heuristic evaluation of whether a lesson holds in this generation.

    Returns 'confirmed', 'contradicted', or None (inconclusive).
    This is a lightweight signal — the Learner Agent makes the final call.
    """
    ltype = lesson.get("type", "")

    # Lessons about crash guards being important
    if "crash_guard" in ltype.lower() or "crash_guard" in str(lesson.get("text", "")):
        guard_scores = []
        no_guard_scores = []
        for s in completed:
            composer = s.get("strategy", {}).get("composer_json", {})
            has_guard = composer.get("step") == "if"
            f = _get_fitness(s)
            if f is None:
                continue
            if has_guard:
                guard_scores.append(f)
            else:
                no_guard_scores.append(f)
        if guard_scores and no_guard_scores:
            avg_guard    = sum(guard_scores)    / len(guard_scores)
            avg_no_guard = sum(no_guard_scores) / len(no_guard_scores)
            if avg_guard > avg_no_guard:
                return "confirmed"
            else:
                return "contradicted"

    # Lessons about disqualification being high
    if "disqualif" in str(lesson.get("text", "")).lower():
        disq_rate = len(disqualified) / max(len(completed) + len(disqualified), 1)
        if disq_rate > 0.3:
            return "confirmed"

    return None


def _extract_structural_patterns(high_scorers: list[dict]) -> list[str]:
    """Extract recurring structural patterns from high-scoring strategies."""
    patterns: Counter = Counter()
    for s in high_scorers:
        composer = s.get("strategy", {}).get("composer_json", {})
        step     = composer.get("step", "unknown")

        patterns[f"top_level={step}"] += 1

        # Guard presence
        if step == "if":
            patterns["has_if_guard"] += 1

        # Asset usage
        assets = _extract_all_tickers(composer)
        for ticker in assets:
            patterns[f"uses_{ticker}"] += 1

        # Rebalance frequency
        freq = s["summary"].get("rebalance_frequency", "")
        if freq:
            patterns[f"rebalance={freq}"] += 1

    n = len(high_scorers)
    # Only report patterns that appear in >50% of high scorers
    return [
        f"{pattern} ({count}/{n} top strategies)"
        for pattern, count in patterns.most_common(10)
        if count > n / 2
    ]


def _extract_all_tickers(composer_json: dict) -> list[str]:
    """Recursively extract all ticker values."""
    tickers = []
    if composer_json.get("step") == "asset":
        t = composer_json.get("ticker")
        if t:
            tickers.append(t)
    for child in composer_json.get("children", []):
        tickers.extend(_extract_all_tickers(child))
    return tickers


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _completed_strategies(results: list[dict]) -> list[dict]:
    """Return strategies that completed scoring (not disqualified)."""
    return [
        s for s in results
        if not s.get("summary", {}).get("disqualified", False)
        and s.get("summary", {}).get("status") not in {"PENDING", "DISQUALIFIED"}
    ]


def _disqualified_strategies(results: list[dict]) -> list[dict]:
    """Return strategies that were disqualified."""
    return [
        s for s in results
        if s.get("summary", {}).get("disqualified", False)
        or s.get("summary", {}).get("status") == "DISQUALIFIED"
    ]


def _get_fitness(strategy: dict) -> Optional[float]:
    """Extract final composite fitness from a strategy dict."""
    # Try final_result first, then nominal_result, then summary
    for block_name in ("final_result", "nominal_result"):
        block = strategy.get(block_name) or {}
        comp  = block.get("composite_fitness") or {}
        f     = comp.get("final_composite")
        if f is not None:
            return f
    return strategy.get("summary", {}).get("final_composite_fitness")


def _trim_dict(d: dict, max_chars: int = 400) -> dict:
    """Trim a dict's string values so total serialised size stays under max_chars."""
    if not d:
        return {}
    serialised = json.dumps(d)
    if len(serialised) <= max_chars:
        return d
    # Truncate individual values
    trimmed = {}
    budget = max_chars // max(len(d), 1)
    for k, v in d.items():
        if isinstance(v, str) and len(v) > budget:
            trimmed[k] = v[:budget] + "…"
        else:
            trimmed[k] = v
    return trimmed
