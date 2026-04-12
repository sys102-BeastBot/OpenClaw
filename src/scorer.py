"""
scorer.py — Compute fitness scores from raw backtest data.

Pure math module: no API calls, no file I/O. All weights and thresholds
are read from meta.json at runtime — never hardcoded here.

Schema reference: Section 1.5 (fitness block), Section 3 (period stats block).
"""

import copy
import math
import statistics
from typing import Optional


# ---------------------------------------------------------------------------
# Archetype enum values (validation only — weights come from meta.json)
# ---------------------------------------------------------------------------
VALID_ARCHETYPES = {"SHARPE_HUNTER", "RETURN_CHASER", "RISK_MINIMIZER", "CONSISTENCY"}


# ---------------------------------------------------------------------------
# Utility
# ---------------------------------------------------------------------------

def clamp(value: float, min_val: float, max_val: float) -> float:
    """Clamp value to [min_val, max_val] inclusive.

    Args:
        value: The float to clamp.
        min_val: Lower bound (inclusive).
        max_val: Upper bound (inclusive).

    Returns:
        The clamped float.
    """
    return max(min_val, min(max_val, value))


# ---------------------------------------------------------------------------
# Disqualifier check
# ---------------------------------------------------------------------------

def check_disqualifiers(period_data: dict, meta: dict) -> tuple[bool, str]:
    """Check whether a period stats block breaches any hard disqualifier.

    Disqualifiers come from meta['fitness']['disqualifiers']. If ANY period
    breaches a disqualifier the strategy goes directly to the graveyard.
    Disqualified strategies receive a null score — not 0.

    Args:
        period_data: One period stats block (Section 3 schema).
        meta: Full meta.json contents.

    Returns:
        Tuple of (is_disqualified: bool, reason_code: str).
        reason_code is '' when not disqualified.

    Raises:
        KeyError: If required fields are missing from period_data or meta.
        ValueError: If archetype or data types are invalid.
    """
    disq = meta["fitness"]["disqualifiers"]
    core = period_data["core_metrics"]

    ann_return: float = core["annualized_return"]
    max_dd: float = core["max_drawdown"]
    sharpe: float = core["sharpe"]

    if ann_return < disq["min_return"]:
        return True, "CATASTROPHIC_LOSS"
    if max_dd >= disq["max_drawdown"]:
        return True, "UNACCEPTABLE_RISK"
    if sharpe < disq["min_sharpe"]:
        return True, "WORSE_THAN_RANDOM"

    return False, ""


# ---------------------------------------------------------------------------
# Drawdown penalty curve
# ---------------------------------------------------------------------------

def tiered_drawdown_penalty(max_drawdown: float, weight: float) -> float:
    """Compute the tiered drawdown penalty score component.

    Penalty curve (dd = max_drawdown percent value, e.g. 9.4 for 9.4%):
        dd <= 5%:   penalty = 0
        dd <= 15%:  penalty = (dd - 5) / 10 * 0.48 * weight * 100
        dd <= 30%:  penalty = (0.48 + (dd - 15) / 15 * 0.52) * weight * 100
        dd > 30%:   penalty = weight * 100  (full deduction)

    Args:
        max_drawdown: Max drawdown as a percent (e.g. 9.4 means 9.4%).
        weight: Drawdown weight from archetype config (e.g. 0.25).

    Returns:
        Penalty as a float (always >= 0).
    """
    dd = max_drawdown
    if dd <= 5.0:
        return 0.0
    elif dd <= 15.0:
        return (dd - 5.0) / 10.0 * 0.48 * weight * 100.0
    elif dd <= 30.0:
        return (0.48 + (dd - 15.0) / 15.0 * 0.52) * weight * 100.0
    else:
        return weight * 100.0


# ---------------------------------------------------------------------------
# Bonus computation
# ---------------------------------------------------------------------------

def compute_bonuses(
    core_metrics: dict,
    benchmark_metrics: dict,
    period_scores: Optional[dict],
    meta: dict,
) -> dict:
    """Compute all applicable bonuses for a period or composite score.

    Bonuses come from meta['fitness']['bonuses']. All five bonus types are
    evaluated independently and may be stacked.

    Note: consistency_bonus uses std_dev of period_scores (composite-level).
    At the per-period level, pass period_scores=None to skip that bonus.

    Args:
        core_metrics: core_metrics block from a period stats block.
        benchmark_metrics: benchmark_metrics block from a period stats block.
        period_scores: Dict of {period: score} for consistency_bonus check,
                       or None when called at per-period level.
        meta: Full meta.json contents.

    Returns:
        Dict with keys:
            sharpe_bonus (bool), drawdown_bonus (bool), return_bonus (bool),
            consistency_bonus (bool), beats_benchmark_bonus (bool),
            total_bonus_points (int).
    """
    b = meta["fitness"]["bonuses"]

    sharpe_bonus = core_metrics["sharpe"] >= b["sharpe_min_threshold"]
    drawdown_bonus = core_metrics["max_drawdown"] <= b["drawdown_threshold"]
    return_bonus = core_metrics["annualized_return"] >= b["return_threshold"]
    beats_benchmark_bonus = bool(benchmark_metrics.get("beats_benchmark", False))

    # Consistency bonus: only computable at composite level when all 4 periods present
    consistency_bonus = False
    if period_scores is not None and len(period_scores) == 4:
        std_dev = statistics.stdev(period_scores.values())
        consistency_bonus = std_dev < b["consistency_std_dev_threshold"]

    total = (
        (b["sharpe_bonus"] if sharpe_bonus else 0)
        + (b["drawdown_bonus"] if drawdown_bonus else 0)
        + (b["return_bonus"] if return_bonus else 0)
        + (b["consistency_bonus"] if consistency_bonus else 0)
        + (b["beats_benchmark_bonus"] if beats_benchmark_bonus else 0)
    )

    return {
        "sharpe_bonus": sharpe_bonus,
        "drawdown_bonus": drawdown_bonus,
        "return_bonus": return_bonus,
        "consistency_bonus": consistency_bonus,
        "beats_benchmark_bonus": beats_benchmark_bonus,
        "total_bonus_points": total,
    }


# ---------------------------------------------------------------------------
# Per-period scoring
# ---------------------------------------------------------------------------

def score_period(period_data: dict, archetype: str, meta: dict) -> dict:
    """Compute fitness score for a single period stats block.

    Reads archetype weights from meta['fitness']['archetype_weights'].
    Writes the fitness sub-block into a copy of period_data and returns it.

    Formulas:
        sharpe_component  = clamp(sharpe / 3.0, 0, 1) × sharpe_weight × 100
        return_component  = clamp(log(1 + r/100) / log(2.5), 0, 1) × return_weight × 100
        drawdown_penalty  = tiered_curve(max_drawdown) × drawdown_weight × 100
        period_fitness    = sharpe_component + return_component - drawdown_penalty
                            + total_bonus_points   (clamped 0–112)

    Args:
        period_data: One period stats block (Section 3 schema). fitness field
                     may be null — it will be populated here.
        archetype: One of SHARPE_HUNTER | RETURN_CHASER | RISK_MINIMIZER | CONSISTENCY.
        meta: Full meta.json contents.

    Returns:
        Copy of period_data with fitness sub-block fully populated.

    Raises:
        ValueError: If archetype is not a valid enum value.
        KeyError: If required fields are absent.
    """
    if archetype not in VALID_ARCHETYPES:
        raise ValueError(
            f"Invalid archetype '{archetype}'. "
            f"Must be one of: {sorted(VALID_ARCHETYPES)}"
        )

    weights = meta["fitness"]["archetype_weights"][archetype]
    sharpe_w: float = weights["sharpe"]
    return_w: float = weights["return"]
    drawdown_w: float = weights["drawdown"]

    core = period_data["core_metrics"]
    bench = period_data["benchmark_metrics"]

    sharpe: float = core["sharpe"]
    ann_return: float = core["annualized_return"]
    max_dd: float = core["max_drawdown"]

    # Score components
    sharpe_component = clamp(sharpe / 3.0, 0.0, 1.0) * sharpe_w * 100.0
    # Guard against domain error: log(1 + r/100) requires r > -100%.
    # Clamp the argument floor at a small positive epsilon to avoid math domain error.
    log_arg = max(1.0 + ann_return / 100.0, 1e-9)
    return_component = clamp(
        math.log(log_arg) / math.log(2.5), 0.0, 1.0
    ) * return_w * 100.0
    drawdown_penalty = tiered_drawdown_penalty(max_dd, drawdown_w)

    # Bonuses (consistency_bonus not applicable per-period — no cross-period std_dev)
    bonuses = compute_bonuses(core, bench, None, meta)

    raw_score = sharpe_component + return_component - drawdown_penalty + bonuses["total_bonus_points"]
    period_fitness_score = clamp(raw_score, 0.0, 112.0)

    result = copy.deepcopy(period_data)
    result["fitness"] = {
        "sharpe_component": round(sharpe_component, 4),
        "return_component": round(return_component, 4),
        "drawdown_penalty": round(drawdown_penalty, 4),
        "bonuses_applied": {
            "sharpe_bonus": bonuses["sharpe_bonus"],
            "drawdown_bonus": bonuses["drawdown_bonus"],
            "return_bonus": bonuses["return_bonus"],
            "benchmark_bonus": bonuses["beats_benchmark_bonus"],
        },
        "total_bonus_points": bonuses["total_bonus_points"],
        "period_fitness_score": round(period_fitness_score, 4),
    }
    return result


# ---------------------------------------------------------------------------
# Composite scoring (across all periods)
# ---------------------------------------------------------------------------

def compute_composite(period_scores: dict, meta: dict) -> dict:
    """Compute the weighted composite fitness score across all backtest periods.

    Period weighting from meta['fitness']['period_weights']:
        6M×0.10 + 1Y×0.30 + 2Y×0.30 + 3Y×0.30

    Consistency adjustment:
        std_dev < 10:  +2
        std_dev > 25:  -5
        otherwise:      0

    Args:
        period_scores: Dict mapping period keys ('6M','1Y','2Y','3Y') to
                       float fitness scores (period_fitness_score values).
        meta: Full meta.json contents.

    Returns:
        Dict with keys:
            period_scores (dict), weighted_composite (float),
            std_dev (float), consistency_adjustment (float),
            final_composite (float).

    Raises:
        ValueError: If not all four periods are present in period_scores.
        KeyError: If period_weights are missing from meta.
    """
    required_periods = {"6M", "1Y", "2Y", "3Y"}
    if not required_periods.issubset(period_scores.keys()):
        missing = required_periods - set(period_scores.keys())
        raise ValueError(
            f"Missing period scores for: {sorted(missing)}. "
            "All four periods (6M, 1Y, 2Y, 3Y) are required."
        )

    pw = meta["fitness"]["period_weights"]
    weighted_composite = sum(period_scores[p] * pw[p] for p in required_periods)

    scores_list = [period_scores[p] for p in sorted(required_periods)]
    std_dev = statistics.stdev(scores_list)

    if std_dev < 10.0:
        consistency_adjustment = 2.0
    elif std_dev > 25.0:
        consistency_adjustment = -5.0
    else:
        consistency_adjustment = 0.0

    final_composite = weighted_composite + consistency_adjustment

    return {
        "period_scores": dict(period_scores),
        "weighted_composite": round(weighted_composite, 4),
        "std_dev": round(std_dev, 4),
        "consistency_adjustment": consistency_adjustment,
        "final_composite": round(final_composite, 4),
    }


# ---------------------------------------------------------------------------
# Simple composite fitness helpers (used by learner/scorer pipeline)
# ---------------------------------------------------------------------------

def score_from_metrics(sharpe: float, maxdd_pct: float, annret_pct: float) -> float:
    """Simple fitness formula: sharpe * max(0, 1 - maxdd/50) * 10.

    Args:
        sharpe: Sharpe ratio (e.g. 5.21)
        maxdd_pct: Max drawdown as percentage (e.g. 7.8)
        annret_pct: Annualized return as percentage (e.g. 337.6)
    Returns:
        Composite fitness score
    """
    if sharpe <= 0:
        return round(sharpe * 10, 2)  # scale negative scores
    dd_penalty = max(0.0, 1.0 - maxdd_pct / 50.0)
    return round(sharpe * dd_penalty * 10, 2)


def score_strategy_file(strategy_file: dict) -> float:
    """Extract 1Y metrics from strategy file and compute simple fitness."""
    p1y = (strategy_file
           .get('nominal_result', {})
           .get('periods', {})
           .get('1Y', {})
           .get('core_metrics', {}))
    sharpe  = p1y.get('sharpe', 0) or 0
    maxdd   = abs(p1y.get('max_drawdown', 1) or 1) * 100
    annret  = (p1y.get('annualized_return', 0) or 0) * 100
    return score_from_metrics(sharpe, maxdd, annret)


def attach_fitness_to_file(strategy_file: dict) -> dict:
    """Compute and attach simple fitness score to strategy file in-place."""
    fitness = score_strategy_file(strategy_file)
    strategy_file['summary']['final_composite_fitness'] = fitness
    if strategy_file.get('nominal_result'):
        if 'composite_fitness' not in strategy_file['nominal_result']:
            strategy_file['nominal_result']['composite_fitness'] = {}
        strategy_file['nominal_result']['composite_fitness']['score'] = fitness
        strategy_file['nominal_result']['composite_fitness']['formula'] = \
            'sharpe * max(0, 1 - maxdd/50) * 10'
    return strategy_file
