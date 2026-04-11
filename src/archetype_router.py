"""
archetype_router.py — Dynamically allocate generation slots per archetype.

Pure computation — no API calls, no file I/O.
All thresholds and weights come from meta.json.

Schema reference: Section 1.6 (archetype_allocation block).
"""

from __future__ import annotations

from collections import defaultdict
from typing import Optional

ARCHETYPES: tuple[str, ...] = (
    "SHARPE_HUNTER",
    "RETURN_CHASER",
    "RISK_MINIMIZER",
    "CONSISTENCY",
)


# ---------------------------------------------------------------------------
# get_current_window_size
# ---------------------------------------------------------------------------

def get_current_window_size(meta: dict) -> int:
    """Return the correct window size for the current generation count.

    Reads window_size_schedule from meta.archetype_allocation.
    Schedule keys are generation thresholds (int strings or ints).
    Returns the window size for the highest threshold <= current generation.
    Falls back to meta.archetype_allocation.window_size if no match.

    Args:
        meta: Full meta.json dict.

    Returns:
        Current window size (int).
    """
    alloc    = meta.get("archetype_allocation", {})
    base     = int(alloc.get("window_size", 5))
    schedule = alloc.get("window_size_schedule", {})
    current_gen = int(meta.get("generations", {}).get("current", 0))

    # Find the highest threshold that has been reached
    applicable = [
        (int(threshold), size)
        for threshold, size in schedule.items()
        if current_gen >= int(threshold)
    ]

    if not applicable:
        return base

    _, size = max(applicable, key=lambda x: x[0])
    return int(size)


# ---------------------------------------------------------------------------
# compute_next_allocation
# ---------------------------------------------------------------------------

def compute_next_allocation(meta: dict) -> dict:
    """Compute archetype slot allocation for the next generation.

    Reads performance_history from meta.archetype_allocation.
    Applies recency-weighted scoring when weighting='recency',
    otherwise equal weighting.

    Recency weighting: most recent entry gets weight N, oldest gets weight 1
    (linear ramp). If window is 5: weights [1, 2, 3, 4, 5] (oldest → newest).

    Allocation is proportional to weighted average fitness, subject to:
    - minimum_per_archetype slots per archetype (enforced first)
    - total slots must equal strategies_per_generation

    Args:
        meta: Full meta.json dict.

    Returns:
        Dict mapping archetype name → slot count.
        E.g. {"SHARPE_HUNTER": 2, "RETURN_CHASER": 2, "RISK_MINIMIZER": 1, "CONSISTENCY": 1}
    """
    alloc      = meta.get("archetype_allocation", {})
    config     = meta.get("config", {})
    total_slots = int(config.get("strategies_per_generation", 6))
    min_per     = int(alloc.get("minimum_per_archetype", 1))
    weighting   = alloc.get("weighting", "recency")
    history     = alloc.get("performance_history", {})
    window_size = get_current_window_size(meta)

    # Compute weighted average fitness per archetype
    scores: dict[str, float] = {}
    for arch in ARCHETYPES:
        arch_history = (history.get(arch) or [])[-window_size:]
        if not arch_history:
            scores[arch] = 50.0  # neutral default when no history
            continue

        n = len(arch_history)
        if weighting == "recency":
            # Weights: 1, 2, ..., n (oldest to newest)
            weights = list(range(1, n + 1))
        else:
            weights = [1] * n

        total_w   = sum(weights)
        weighted  = sum(v * w for v, w in zip(arch_history, weights))
        scores[arch] = weighted / total_w if total_w > 0 else 50.0

    # Allocate proportionally, enforcing minimum
    # Step 1: give everyone their minimum
    allocation = {arch: min_per for arch in ARCHETYPES}
    remaining  = total_slots - (min_per * len(ARCHETYPES))

    if remaining < 0:
        # minimum_per_archetype × 4 > total — just give everyone minimum and cap
        return {arch: min_per for arch in ARCHETYPES}

    # Step 2: distribute remaining slots proportionally to scores
    total_score = sum(scores.values())
    if total_score <= 0:
        # Equal distribution of remaining
        per_arch = remaining // len(ARCHETYPES)
        leftover = remaining % len(ARCHETYPES)
        for i, arch in enumerate(ARCHETYPES):
            allocation[arch] += per_arch + (1 if i < leftover else 0)
    else:
        # Proportional distribution
        raw_extras: dict[str, float] = {
            arch: (scores[arch] / total_score) * remaining
            for arch in ARCHETYPES
        }
        # Floor each extra
        floored = {arch: int(raw_extras[arch]) for arch in ARCHETYPES}
        distributed = sum(floored.values())
        leftover = remaining - distributed

        # Give leftover to archetypes with highest fractional remainders
        remainders = sorted(
            ARCHETYPES,
            key=lambda a: raw_extras[a] - floored[a],
            reverse=True,
        )
        for i, arch in enumerate(remainders):
            floored[arch] += 1 if i < leftover else 0

        for arch in ARCHETYPES:
            allocation[arch] += floored[arch]

    # Sanity check: total must equal strategies_per_generation
    actual_total = sum(allocation.values())
    if actual_total != total_slots:
        # Fix rounding discrepancy by adjusting the highest-scoring archetype
        diff = total_slots - actual_total
        best_arch = max(ARCHETYPES, key=lambda a: scores[a])
        allocation[best_arch] += diff

    return allocation


# ---------------------------------------------------------------------------
# update_performance_history
# ---------------------------------------------------------------------------

def update_performance_history(
    meta: dict,
    generation_stats: dict,
) -> dict:
    """Append this generation's per-archetype avg_fitness to performance_history.

    Trims each archetype's history to window_size after appending.
    Does NOT write to disk — caller handles persistence via kb_writer.

    Args:
        meta:             Full meta.json dict (deep-copied internally).
        generation_stats: Dict with archetype_avg_fitness key (from ranker.py).

    Returns:
        Updated meta dict with new performance_history entries.
    """
    import copy
    result = copy.deepcopy(meta)

    alloc       = result.setdefault("archetype_allocation", {})
    history     = alloc.setdefault("performance_history", {})
    window_size = get_current_window_size(result)

    arch_avg = generation_stats.get("archetype_avg_fitness", {})

    for arch in ARCHETYPES:
        arch_history = history.setdefault(arch, [])
        avg = arch_avg.get(arch)
        if avg is not None:
            arch_history.append(float(avg))
        # Trim to window_size
        if len(arch_history) > window_size:
            history[arch] = arch_history[-window_size:]

    return result
