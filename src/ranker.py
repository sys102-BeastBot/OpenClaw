"""
ranker.py — Sort generation results, identify parents, compute generation stats.

Pure computation — no API calls, no file I/O.

Schema reference: Section 2.1 (summary block), Section 1.3 (best_ever).
"""

from __future__ import annotations

import statistics
from collections import defaultdict
from datetime import datetime, timezone
from typing import Optional


# ---------------------------------------------------------------------------
# Utility
# ---------------------------------------------------------------------------

def _now_iso() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _get_fitness(strategy: dict) -> Optional[float]:
    """Extract final composite fitness, trying multiple locations."""
    for block in ("final_result", "nominal_result"):
        b = strategy.get(block) or {}
        f = (b.get("composite_fitness") or {}).get("final_composite")
        if f is not None:
            return float(f)
    return strategy.get("summary", {}).get("final_composite_fitness")


def _is_disqualified(strategy: dict) -> bool:
    return bool(strategy.get("summary", {}).get("disqualified", False))


# ---------------------------------------------------------------------------
# rank_generation
# ---------------------------------------------------------------------------

def rank_generation(results: list[dict], meta: dict) -> list[dict]:
    """Sort strategies by final_composite_fitness descending.

    Completed strategies (with fitness) come first, sorted by score.
    Disqualified strategies are sorted to the bottom.

    Args:
        results: List of strategy dicts for this generation.
        meta:    Full meta.json (reserved for future weight overrides).

    Returns:
        Sorted list — best first, disqualified last.
    """
    def sort_key(s: dict):
        disq    = _is_disqualified(s)
        fitness = _get_fitness(s)
        # Primary: disqualified last (False < True → non-disq first)
        # Secondary: fitness descending (negate for ascending sort)
        return (disq, -(fitness if fitness is not None else float("-inf")))

    return sorted(results, key=sort_key)


# ---------------------------------------------------------------------------
# compute_generation_stats
# ---------------------------------------------------------------------------

def compute_generation_stats(results: list[dict]) -> dict:
    """Compute summary statistics for a generation.

    Only completed (non-disqualified) strategies with fitness scores
    contribute to the statistics.

    Args:
        results: Full list of strategy dicts for the generation.

    Returns:
        Dict with avg_fitness, std_dev_fitness, best_fitness, worst_fitness,
        best_strategy_id, worst_strategy_id, archetype_avg_fitness,
        total_strategies, total_completed, total_disqualified.
    """
    completed = [s for s in results if not _is_disqualified(s)]
    disq_count = len(results) - len(completed)

    fitness_scores = [_get_fitness(s) for s in completed]
    fitness_scores = [f for f in fitness_scores if f is not None]

    n = len(fitness_scores)
    avg_fitness   = round(sum(fitness_scores) / n, 4)       if n > 0 else None
    std_dev       = round(statistics.stdev(fitness_scores), 4) if n > 1 else 0.0
    best_fitness  = round(max(fitness_scores), 4)            if n > 0 else None
    worst_fitness = round(min(fitness_scores), 4)            if n > 0 else None

    best_id  = None
    worst_id = None
    for s in completed:
        f = _get_fitness(s)
        sid = s.get("summary", {}).get("strategy_id", "")
        if f is not None:
            if f == best_fitness  and best_id  is None:
                best_id  = sid
            if f == worst_fitness and worst_id is None:
                worst_id = sid

    # Per-archetype averages (completed only)
    arch_buckets: dict[str, list[float]] = defaultdict(list)
    for s in completed:
        arch = s.get("summary", {}).get("archetype", "UNKNOWN")
        f    = _get_fitness(s)
        if f is not None:
            arch_buckets[arch].append(f)

    archetype_avg = {
        arch: round(sum(scores) / len(scores), 4)
        for arch, scores in arch_buckets.items()
    }

    return {
        "total_strategies":     len(results),
        "total_completed":      len(completed),
        "total_disqualified":   disq_count,
        "avg_fitness":          avg_fitness,
        "std_dev_fitness":      std_dev,
        "best_fitness":         best_fitness,
        "worst_fitness":        worst_fitness,
        "best_strategy_id":     best_id,
        "worst_strategy_id":    worst_id,
        "archetype_avg_fitness": archetype_avg,
    }


# ---------------------------------------------------------------------------
# identify_parents
# ---------------------------------------------------------------------------

PARENT_SCORE_THRESHOLD: float = 70.0
MAX_PARENTS:            int   = 6


def identify_parents(ranked_results: list[dict], meta: dict) -> list[str]:
    """Return strategy IDs of top performers eligible as parents.

    Eligibility: fitness >= PARENT_SCORE_THRESHOLD (70.0).
    Returns up to MAX_PARENTS (6) IDs, best first.

    Args:
        ranked_results: Already-ranked list (best first).
        meta:           Full meta.json (reserved for threshold overrides).

    Returns:
        List of strategy_id strings.
    """
    parents: list[str] = []
    for s in ranked_results:
        if _is_disqualified(s):
            continue
        f = _get_fitness(s)
        if f is not None and f >= PARENT_SCORE_THRESHOLD:
            sid = s.get("summary", {}).get("strategy_id", "")
            if sid:
                parents.append(sid)
        if len(parents) >= MAX_PARENTS:
            break
    return parents


# ---------------------------------------------------------------------------
# check_new_best
# ---------------------------------------------------------------------------

def check_new_best(
    ranked_results: list[dict],
    meta: dict,
) -> tuple[bool, Optional[dict]]:
    """Check if any strategy beats the all-time best or per-archetype best.

    Args:
        ranked_results: Ranked strategy list for this generation.
        meta:           Full meta.json with best_ever and best_per_archetype.

    Returns:
        Tuple of (is_new_best, strategy_dict_or_none).
        is_new_best is True when any strategy beats best_ever or any archetype record.
        strategy_dict is the new record-holder (or None if no new best).
    """
    if not ranked_results:
        return False, None

    best_ever       = meta.get("best_ever") or {}
    best_ever_score = float(best_ever.get("fitness_score", 0)) if best_ever else 0.0

    is_new = False
    new_best_strat: Optional[dict] = None

    for s in ranked_results:
        if _is_disqualified(s):
            continue
        f = _get_fitness(s)
        if f is None:
            continue

        # Check global best
        if f > best_ever_score:
            is_new = True
            best_ever_score = f
            new_best_strat  = s

        # Check per-archetype best
        arch       = s.get("summary", {}).get("archetype", "")
        arch_bests = meta.get("best_per_archetype") or {}
        arch_best  = arch_bests.get(arch) or {}
        arch_score = float(arch_best.get("fitness_score", 0)) if arch_best else 0.0
        if f > arch_score:
            is_new = True
            if new_best_strat is None:
                new_best_strat = s

    return is_new, new_best_strat
