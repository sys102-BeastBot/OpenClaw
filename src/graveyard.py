"""
graveyard.py — Rule-based filing of failed strategies.

No judgment — all rules are explicit and deterministic. All threshold
values are read from meta.json at runtime; none are hardcoded here.

Schema reference: Section 6 (graveyard.json).
"""

import os
import sys
from datetime import datetime, timezone
from typing import Optional

# Resolve src dir so we can import sibling modules
_SRC_DIR = os.path.dirname(os.path.abspath(__file__))
if _SRC_DIR not in sys.path:
    sys.path.insert(0, _SRC_DIR)

from kb_writer import (  # noqa: E402
    GRAVEYARD_PATH,
    KBNotFoundError,
    read_json,
    write_json_atomic,
)

# ---------------------------------------------------------------------------
# Exceptions
# ---------------------------------------------------------------------------

class GraveyardError(Exception):
    """Raised when a graveyard filing operation fails."""


# ---------------------------------------------------------------------------
# Entry ID generation
# ---------------------------------------------------------------------------

_entry_counter: int = 0  # module-level counter; reset only by tests


def _next_entry_id(graveyard: dict) -> str:
    """Return the next sequential graveyard entry ID.

    Derives the next ID from the current total_entries count so it is
    stable across process restarts — not from the in-memory counter.

    Args:
        graveyard: Current graveyard dict (already loaded from disk).

    Returns:
        e.g. "grave-001", "grave-042"
    """
    total = graveyard.get("total_entries", 0)
    return f"grave-{total + 1:03d}"


def get_entry_id() -> str:
    """Return the next sequential entry ID based on current graveyard state.

    Reads the graveyard file to determine the correct next ID, so IDs are
    always sequential and never reused across restarts.

    Returns:
        Next entry ID string (e.g. "grave-007").

    Raises:
        GraveyardError: If the graveyard file cannot be read.
    """
    try:
        graveyard = _load_graveyard()
    except Exception as exc:
        raise GraveyardError(f"Cannot determine next entry ID: {exc}") from exc
    return _next_entry_id(graveyard)


# ---------------------------------------------------------------------------
# Disqualifier check
# ---------------------------------------------------------------------------

def check_disqualifiers(
    period_data: dict,
    meta: dict,
) -> tuple[bool, str, dict]:
    """Check whether a period stats block breaches any hard disqualifier.

    All thresholds read from meta['fitness']['disqualifiers'].

    Args:
        period_data: One period stats block (Section 3 schema).
        meta: Full meta.json contents.

    Returns:
        Tuple of (is_disqualified: bool, reason_code: str, trigger: dict).
        trigger contains metric, value, threshold, period keys.
        reason_code and trigger are empty/empty-dict when not disqualified.

    Raises:
        KeyError: If required fields are missing.
    """
    disq = meta["fitness"]["disqualifiers"]
    core = period_data["core_metrics"]
    period = period_data.get("period", "unknown")

    ann_return: float = core["annualized_return"]
    max_dd: float     = core["max_drawdown"]
    sharpe: float     = core["sharpe"]

    if ann_return < disq["min_return"]:
        return True, "CATASTROPHIC_LOSS", {
            "metric": "annualized_return",
            "value": ann_return,
            "threshold": disq["min_return"],
            "period": period,
        }

    if max_dd >= disq["max_drawdown"]:
        return True, "UNACCEPTABLE_RISK", {
            "metric": "max_drawdown",
            "value": max_dd,
            "threshold": disq["max_drawdown"],
            "period": period,
        }

    if sharpe < disq["min_sharpe"]:
        return True, "WORSE_THAN_RANDOM", {
            "metric": "sharpe",
            "value": sharpe,
            "threshold": disq["min_sharpe"],
            "period": period,
        }

    return False, "", {}


# ---------------------------------------------------------------------------
# Poor performer gate
# ---------------------------------------------------------------------------

def is_poor_performer(
    fitness_score: float,
    generation_stats: dict,
    meta: dict,
) -> bool:
    """Determine whether a strategy qualifies as a poor performer.

    Uses BOTH-gate logic when meta specifies logic=BOTH (default):
    both the absolute gate AND the std_dev gate must be true to file.

    Args:
        fitness_score: Composite fitness score of the strategy.
        generation_stats: Dict with avg_fitness and std_dev_fitness keys.
        meta: Full meta.json contents.

    Returns:
        True if the strategy meets the poor performer criteria.

    Raises:
        KeyError: If graveyard_thresholds are missing from meta.
    """
    thresholds = meta["fitness"]["graveyard_thresholds"]

    absolute_gate: bool = fitness_score < thresholds["poor_performer_absolute"]
    std_dev_gate: bool  = fitness_score < (
        generation_stats["avg_fitness"]
        - thresholds["poor_performer_std_dev_multiplier"]
        * generation_stats["std_dev_fitness"]
    )

    if thresholds.get("poor_performer_logic", "BOTH") == "BOTH":
        return absolute_gate and std_dev_gate
    return absolute_gate or std_dev_gate


# ---------------------------------------------------------------------------
# Filing helpers
# ---------------------------------------------------------------------------

def _load_graveyard() -> dict:
    """Load graveyard.json, returning empty structure if file doesn't exist."""
    if not os.path.exists(GRAVEYARD_PATH):
        return {
            "version": "1.0",
            "last_updated": _now_iso(),
            "total_entries": 0,
            "entries_by_type": {
                "DISQUALIFIED_STRATEGY": 0,
                "POOR_PERFORMER": 0,
                "API_ERROR": 0,
            },
            "entries": [],
        }
    return read_json(GRAVEYARD_PATH)


def _save_graveyard(graveyard: dict) -> None:
    """Atomically save graveyard to disk."""
    graveyard["last_updated"] = _now_iso()
    write_json_atomic(GRAVEYARD_PATH, graveyard)


def _common_fields(strategy: dict, entry_id: str, entry_type: str) -> dict:
    """Build the fields common to all graveyard entry types.

    Args:
        strategy: Full strategy dict (must have summary and strategy blocks).
        entry_id: Pre-computed entry ID string.
        entry_type: DISQUALIFIED_STRATEGY | POOR_PERFORMER | API_ERROR.

    Returns:
        Dict with all common graveyard entry fields populated.
    """
    summary = strategy.get("summary", {})
    strat_block = strategy.get("strategy", {})
    desc = strat_block.get("description", {})
    composer_json = strat_block.get("composer_json", {})

    top_level_structure = _top_level_structure(composer_json)
    had_guard = _has_guard(composer_json)
    assets_used = _extract_assets(composer_json)

    return {
        "id": entry_id,
        "type": entry_type,
        "strategy_id": summary.get("strategy_id", ""),
        "strategy_name": summary.get("name", ""),
        "archetype": summary.get("archetype", ""),
        "generation": summary.get("generation", 0),
        "recorded_at": _now_iso(),
        "failure_analysis": {
            "structural_failure": None,  # written by Learner Agent later
            "losing_pattern_ids": [],
            "lesson_written": False,     # starts as false per schema
            "lesson_ids": [],
        },
        "strategy_summary": {
            "top_level_structure": top_level_structure,
            "had_guard": had_guard,
            "assets_used": assets_used,
            "rebalance_frequency": summary.get("rebalance_frequency", "daily"),
        },
    }


def _now_iso() -> str:
    """Return current UTC time as ISO 8601 string."""
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _top_level_structure(composer_json: dict) -> str:
    """Return a readable description of the top-level composer_json node type."""
    step = composer_json.get("step", "unknown")
    if step == "wt-cash-equal":
        tickers = [c.get("ticker", "?") for c in composer_json.get("children", [])
                   if c.get("step") == "asset"]
        return f"wt-cash-equal → [{', '.join(tickers)}]"
    if step == "if":
        return "if-guard → [...children...]"
    if step == "filter":
        fn = composer_json.get("sort-by-fn", "")
        return f"filter({fn}) → top-{composer_json.get('select-n', '?')}"
    return step


def _has_guard(composer_json: dict) -> bool:
    """Return True if the top-level composer step is an if-guard."""
    return composer_json.get("step") == "if"


def _extract_assets(composer_json: dict) -> list[str]:
    """Recursively extract all ticker values from a composer_json tree."""
    tickers = []
    if composer_json.get("step") == "asset":
        ticker = composer_json.get("ticker")
        if ticker:
            tickers.append(ticker)
    for child in composer_json.get("children", []):
        tickers.extend(_extract_assets(child))
    return list(dict.fromkeys(tickers))  # deduplicate, preserve order


def _get_1y_core(strategy: dict) -> dict:
    """Extract 1Y core_metrics from nominal_result.periods, or empty dict."""
    try:
        return strategy["nominal_result"]["periods"]["1Y"]["core_metrics"]
    except (KeyError, TypeError):
        return {}


# ---------------------------------------------------------------------------
# Public filing functions
# ---------------------------------------------------------------------------

def file_disqualified(
    strategy: dict,
    reason_code: str,
    trigger: dict,
) -> str:
    """File a strategy that breached a hard disqualifier into the graveyard.

    Args:
        strategy: Full strategy dict.
        reason_code: One of CATASTROPHIC_LOSS | UNACCEPTABLE_RISK |
                     WORSE_THAN_RANDOM | INVALID_JSON.
        trigger: Dict with metric, value, threshold, period keys.

    Returns:
        The graveyard entry ID assigned (e.g. "grave-007").

    Raises:
        GraveyardError: If the filing operation fails.
    """
    try:
        graveyard = _load_graveyard()
        entry_id = _next_entry_id(graveyard)
        core = _get_1y_core(strategy)

        entry = _common_fields(strategy, entry_id, "DISQUALIFIED_STRATEGY")
        entry["disqualification"] = {
            "reason_code": reason_code,
            "trigger_metric": trigger.get("metric", ""),
            "trigger_value": trigger.get("value"),
            "trigger_threshold": trigger.get("threshold"),
            "period": trigger.get("period", ""),
        }
        entry["core_stats"] = {
            "annualized_return": core.get("annualized_return"),
            "sharpe": core.get("sharpe"),
            "max_drawdown": core.get("max_drawdown"),
        }

        graveyard["entries"].append(entry)
        graveyard["total_entries"] = graveyard.get("total_entries", 0) + 1
        graveyard["entries_by_type"]["DISQUALIFIED_STRATEGY"] = (
            graveyard["entries_by_type"].get("DISQUALIFIED_STRATEGY", 0) + 1
        )
        _save_graveyard(graveyard)
        return entry_id
    except Exception as exc:
        raise GraveyardError(
            f"Failed to file disqualified strategy "
            f"'{strategy.get('summary', {}).get('strategy_id', '?')}': {exc}"
        ) from exc


def file_poor_performer(
    strategy: dict,
    performance: dict,
) -> str:
    """File a strategy that passed disqualifiers but scored too low.

    Args:
        strategy: Full strategy dict.
        performance: Dict matching the POOR_PERFORMER performance block schema
                     (Section 6.3). Must include nominal_composite_fitness,
                     best_period_score, worst_period_score, annualized_return_1Y,
                     sharpe_1Y, max_drawdown_1Y.

    Returns:
        The graveyard entry ID assigned.

    Raises:
        GraveyardError: If the filing operation fails.
    """
    try:
        graveyard = _load_graveyard()
        entry_id = _next_entry_id(graveyard)

        entry = _common_fields(strategy, entry_id, "POOR_PERFORMER")
        entry["performance"] = {
            "nominal_composite_fitness": performance.get("nominal_composite_fitness"),
            "final_composite_fitness": performance.get("final_composite_fitness"),
            "optimization_delta": performance.get("optimization_delta"),
            "best_period_score": performance.get("best_period_score"),
            "worst_period_score": performance.get("worst_period_score"),
            "annualized_return_1Y": performance.get("annualized_return_1Y"),
            "sharpe_1Y": performance.get("sharpe_1Y"),
            "max_drawdown_1Y": performance.get("max_drawdown_1Y"),
        }

        graveyard["entries"].append(entry)
        graveyard["total_entries"] = graveyard.get("total_entries", 0) + 1
        graveyard["entries_by_type"]["POOR_PERFORMER"] = (
            graveyard["entries_by_type"].get("POOR_PERFORMER", 0) + 1
        )
        _save_graveyard(graveyard)
        return entry_id
    except Exception as exc:
        raise GraveyardError(
            f"Failed to file poor performer "
            f"'{strategy.get('summary', {}).get('strategy_id', '?')}': {exc}"
        ) from exc


def file_api_error(
    strategy: dict,
    error: dict,
) -> str:
    """File a strategy that failed due to an API error.

    Args:
        strategy: Full strategy dict.
        error: Dict with http_status, error_message, and optional
               error_field and raw_error keys.

    Returns:
        The graveyard entry ID assigned.

    Raises:
        GraveyardError: If the filing operation fails.
    """
    try:
        graveyard = _load_graveyard()
        entry_id = _next_entry_id(graveyard)

        entry = _common_fields(strategy, entry_id, "API_ERROR")
        entry["api_error"] = {
            "http_status": error.get("http_status"),
            "error_message": error.get("error_message", ""),
            "error_field": error.get("error_field"),
            "raw_error": error.get("raw_error"),
        }

        graveyard["entries"].append(entry)
        graveyard["total_entries"] = graveyard.get("total_entries", 0) + 1
        graveyard["entries_by_type"]["API_ERROR"] = (
            graveyard["entries_by_type"].get("API_ERROR", 0) + 1
        )
        _save_graveyard(graveyard)
        return entry_id
    except Exception as exc:
        raise GraveyardError(
            f"Failed to file API error for "
            f"'{strategy.get('summary', {}).get('strategy_id', '?')}': {exc}"
        ) from exc
