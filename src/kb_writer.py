"""
kb_writer.py — All file I/O to the Knowledge Base (KB).

Single gateway for all KB writes. No other module writes KB files directly.
All writes use atomic operations (write temp → os.replace) to guarantee
that a crashed write never leaves a partial file.

Schema reference: Document map (cover page) for all file locations.
"""

import json
import os
import shutil
import tempfile
from datetime import datetime, timezone
from typing import Any

# ---------------------------------------------------------------------------
# KB directory layout — all paths relative to KB_ROOT
# ---------------------------------------------------------------------------

KB_ROOT = os.path.expanduser("~/.openclaw/workspace/learning/kb")
PENDING_DIR = os.path.expanduser("~/.openclaw/workspace/learning/pending")
RESULTS_DIR = os.path.expanduser("~/.openclaw/workspace/learning/results")
HISTORY_DIR = os.path.expanduser("~/.openclaw/workspace/learning/history")

META_PATH = os.path.join(KB_ROOT, "meta.json")
PATTERNS_PATH = os.path.join(KB_ROOT, "patterns.json")
GRAVEYARD_PATH = os.path.join(KB_ROOT, "graveyard.json")
LINEAGE_PATH = os.path.join(KB_ROOT, "lineage.json")
LESSONS_ACTIVE_PATH = os.path.join(KB_ROOT, "lessons", "active.json")
LESSONS_INDEX_PATH = os.path.join(KB_ROOT, "lessons", "index.json")
LESSONS_RAW_DIR = os.path.join(KB_ROOT, "lessons", "raw")


# ---------------------------------------------------------------------------
# Exceptions
# ---------------------------------------------------------------------------

class KBWriteError(Exception):
    """Raised when a KB write operation fails."""


class KBReadError(Exception):
    """Raised when a KB file cannot be read or is invalid JSON."""


class KBNotFoundError(Exception):
    """Raised when an expected KB file or strategy is not found."""


# ---------------------------------------------------------------------------
# Atomic JSON I/O
# ---------------------------------------------------------------------------

def write_json_atomic(path: str, data: dict) -> None:
    """Write data to path as JSON using an atomic temp-file + rename pattern.

    Writes to a sibling temp file in the same directory, then renames it to
    the target path. On POSIX systems os.replace() is atomic — a crashed
    write will never leave a partial file at the target path.

    Args:
        path: Absolute path to the target JSON file.
        data: Dict to serialise as JSON.

    Raises:
        KBWriteError: If the write or rename fails for any reason.
    """
    dir_path = os.path.dirname(path)
    if not dir_path:
        dir_path = "."
    tmp_path: str | None = None
    try:
        os.makedirs(dir_path, exist_ok=True)
        with tempfile.NamedTemporaryFile(
            mode="w",
            dir=dir_path,
            suffix=".tmp",
            delete=False,
            encoding="utf-8",
        ) as f:
            tmp_path = f.name
            json.dump(data, f, indent=2)
        os.replace(tmp_path, path)  # atomic on POSIX
    except Exception as exc:
        # Clean up orphaned temp file if rename has not yet happened
        if tmp_path is not None:
            try:
                os.unlink(tmp_path)
            except OSError:
                pass
        raise KBWriteError(
            f"Atomic write failed for '{path}': {exc}"
        ) from exc


def read_json(path: str) -> dict:
    """Read and parse a JSON file from the KB.

    Args:
        path: Absolute path to the JSON file.

    Returns:
        Parsed dict.

    Raises:
        KBNotFoundError: If the file does not exist.
        KBReadError: If the file cannot be read or is not valid JSON.
    """
    if not os.path.exists(path):
        raise KBNotFoundError(f"KB file not found: '{path}'")
    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except json.JSONDecodeError as exc:
        raise KBReadError(
            f"Invalid JSON in KB file '{path}': {exc}"
        ) from exc
    except OSError as exc:
        raise KBReadError(
            f"Cannot read KB file '{path}': {exc}"
        ) from exc


# ---------------------------------------------------------------------------
# meta.json helpers
# ---------------------------------------------------------------------------

def update_meta(updates: dict) -> None:
    """Merge updates into meta.json without overwriting unrelated fields.

    Performs a shallow merge at the top level. To update nested fields,
    include the full nested dict in updates (it will replace that top-level
    key entirely). Writes last_updated_at automatically.

    Args:
        updates: Dict of top-level keys to merge into meta.json.

    Raises:
        KBNotFoundError: If meta.json does not exist yet.
        KBReadError: If meta.json is invalid JSON.
        KBWriteError: If the atomic write fails.
    """
    meta = read_json(META_PATH)
    meta.update(updates)
    meta["system"]["last_updated_at"] = _now_iso()
    write_json_atomic(META_PATH, meta)


def update_kb_health(meta: dict) -> None:
    """Write updated kb_health fields into meta.json.

    Convenience wrapper: merges only the kb_health sub-block and writes.

    Args:
        meta: Full meta.json dict with an updated kb_health block.

    Raises:
        KBWriteError: If the atomic write fails.
    """
    existing = read_json(META_PATH)
    existing["kb_health"] = meta["kb_health"]
    existing["system"]["last_updated_at"] = _now_iso()
    write_json_atomic(META_PATH, existing)


# ---------------------------------------------------------------------------
# Strategy file lifecycle
# ---------------------------------------------------------------------------

def write_strategy_file(strategy: dict, stage: str) -> str:
    """Write a strategy dict to the appropriate pipeline directory.

    Stages:
        "pending"  → pending/{strategy_id}.json
        "results"  → results/{strategy_id}.json
        "complete" → results/{strategy_id}.json  (same location, updated content)

    Args:
        strategy: Full strategy dict (must include summary.strategy_id).
        stage: Pipeline stage — one of "pending", "results", "complete".

    Returns:
        Absolute path where the file was written.

    Raises:
        ValueError: If stage is not recognised or strategy_id is missing.
        KBWriteError: If the atomic write fails.
    """
    valid_stages = {"pending", "results", "complete"}
    if stage not in valid_stages:
        raise ValueError(
            f"Invalid stage '{stage}'. Must be one of: {sorted(valid_stages)}"
        )

    try:
        strategy_id = strategy["summary"]["strategy_id"]
    except (KeyError, TypeError) as exc:
        raise ValueError(
            f"strategy dict must contain summary.strategy_id: {exc}"
        ) from exc

    if not strategy_id:
        raise ValueError("summary.strategy_id must not be empty.")

    if stage == "pending":
        target_dir = PENDING_DIR
    else:
        target_dir = RESULTS_DIR

    os.makedirs(target_dir, exist_ok=True)
    target_path = os.path.join(target_dir, f"{strategy_id}.json")
    write_json_atomic(target_path, strategy)
    return target_path


def move_to_results(strategy_id: str) -> str:
    """Move a strategy file from pending/ to results/.

    Args:
        strategy_id: e.g. "gen-001-strat-02"

    Returns:
        Absolute path of the file in results/.

    Raises:
        KBNotFoundError: If the file is not found in pending/.
        KBWriteError: If the move fails.
    """
    src = os.path.join(PENDING_DIR, f"{strategy_id}.json")
    if not os.path.exists(src):
        raise KBNotFoundError(
            f"Strategy '{strategy_id}' not found in pending/. "
            f"Expected: '{src}'"
        )
    os.makedirs(RESULTS_DIR, exist_ok=True)
    dst = os.path.join(RESULTS_DIR, f"{strategy_id}.json")
    try:
        shutil.move(src, dst)
    except OSError as exc:
        raise KBWriteError(
            f"Failed to move '{strategy_id}' from pending/ to results/: {exc}"
        ) from exc
    return dst


def archive_to_history(strategy_id: str, generation: int) -> str:
    """Move a strategy file from results/ to history/gen-NNN/.

    Args:
        strategy_id: e.g. "gen-002-strat-03"
        generation: Generation number (used to construct the history subdirectory).

    Returns:
        Absolute path of the archived file.

    Raises:
        KBNotFoundError: If the file is not found in results/.
        KBWriteError: If the move fails.
    """
    src = os.path.join(RESULTS_DIR, f"{strategy_id}.json")
    if not os.path.exists(src):
        raise KBNotFoundError(
            f"Strategy '{strategy_id}' not found in results/. "
            f"Expected: '{src}'"
        )
    gen_dir = os.path.join(HISTORY_DIR, f"gen-{generation:03d}")
    os.makedirs(gen_dir, exist_ok=True)
    dst = os.path.join(gen_dir, f"{strategy_id}.json")
    try:
        shutil.move(src, dst)
    except OSError as exc:
        raise KBWriteError(
            f"Failed to archive '{strategy_id}' to history/gen-{generation:03d}/: {exc}"
        ) from exc
    return dst


# ---------------------------------------------------------------------------
# KB initialisation
# ---------------------------------------------------------------------------

def initialize_kb_structure() -> None:
    """Create all required KB directories and seed files if they don't exist.

    Idempotent — safe to call on an already-initialised KB. Existing files
    are never overwritten. All initialised JSON files match the schema shapes
    defined in the schema reference document.

    Raises:
        KBWriteError: If any directory or file cannot be created.
    """
    # Directories
    dirs = [
        KB_ROOT,
        os.path.join(KB_ROOT, "lessons"),
        LESSONS_RAW_DIR,
        PENDING_DIR,
        RESULTS_DIR,
        HISTORY_DIR,
        os.path.join(os.path.dirname(KB_ROOT), "monitor"),
    ]
    for d in dirs:
        try:
            os.makedirs(d, exist_ok=True)
        except OSError as exc:
            raise KBWriteError(f"Cannot create directory '{d}': {exc}") from exc

    # Seed files — only write if absent
    _init_file_if_absent(META_PATH, _empty_meta())
    _init_file_if_absent(PATTERNS_PATH, _empty_patterns())
    _init_file_if_absent(GRAVEYARD_PATH, _empty_graveyard())
    _init_file_if_absent(LINEAGE_PATH, _empty_lineage())
    _init_file_if_absent(LESSONS_ACTIVE_PATH, _empty_lessons_active())
    _init_file_if_absent(LESSONS_INDEX_PATH, _empty_lessons_index())


# ---------------------------------------------------------------------------
# Private helpers
# ---------------------------------------------------------------------------

def _now_iso() -> str:
    """Return current UTC time as ISO 8601 string."""
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _init_file_if_absent(path: str, data: dict) -> None:
    """Write data to path only if path does not already exist."""
    if not os.path.exists(path):
        write_json_atomic(path, data)


def _empty_meta() -> dict:
    """Return a minimal valid meta.json seed matching the schema shape."""
    now = _now_iso()
    return {
        "system": {
            "version": "1.0.0",
            "created_at": now,
            "last_updated_at": now,
            "system_mode": "RESEARCH",
            "execution_permitted": False,
            "deploy_permitted": False,
            "halted": False,
            "halt_reason": None,
            "halted_at": None,
        },
        "generations": {
            "current": 0,
            "total_completed": 0,
            "total_strategies_generated": 0,
            "total_strategies_backtested": 0,
            "total_strategies_disqualified": 0,
            "total_backtest_api_calls": 0,
            "total_optimizer_api_calls": 0,
            "last_generation_completed_at": None,
        },
        "best_ever": None,
        "best_per_archetype": {
            "SHARPE_HUNTER": None,
            "RETURN_CHASER": None,
            "RISK_MINIMIZER": None,
            "CONSISTENCY": None,
        },
        "config": {
            "strategies_per_generation": 6,
            "backtest_periods": ["6M", "1Y", "2Y", "3Y"],
            "optimizer_rough_cut_threshold": 40.0,
            "optimizer_combination_cap": 200,
            "default_rebalance_frequency": "daily",
            "rebalance_frequency_options": [],
            "asset_universe": [],
            "broker": "ALPACA_WHITE_LABEL",
            "benchmark": "SPY",
            "capital": 10000,
        },
        "fitness": {
            "global_weights": {"sharpe": 0.35, "return": 0.40, "drawdown": 0.25},
            "archetype_weights": {
                "SHARPE_HUNTER":  {"sharpe": 0.45, "return": 0.30, "drawdown": 0.25},
                "RETURN_CHASER":  {"sharpe": 0.30, "return": 0.45, "drawdown": 0.25},
                "RISK_MINIMIZER": {"sharpe": 0.25, "return": 0.30, "drawdown": 0.45},
                "CONSISTENCY":    {"sharpe": 0.25, "return": 0.25, "drawdown": 0.50},
            },
            "period_weights": {"6M": 0.10, "1Y": 0.30, "2Y": 0.30, "3Y": 0.30},
            "bonuses": {
                "sharpe_min_threshold": 2.0,
                "sharpe_bonus": 3,
                "drawdown_threshold": 15.0,
                "drawdown_bonus": 3,
                "return_threshold": 40.0,
                "return_bonus": 3,
                "consistency_std_dev_threshold": 10.0,
                "consistency_bonus": 2,
                "beats_benchmark_bonus": 1,
            },
            "disqualifiers": {
                "min_return": -20.0,
                "max_drawdown": 65.0,
                "min_sharpe": -1.0,
            },
            "graveyard_thresholds": {
                "poor_performer_absolute": 20,
                "poor_performer_std_dev_multiplier": 1.5,
                "poor_performer_logic": "BOTH",
            },
        },
        "archetype_allocation": {
            "window_size": 5,
            "window_size_schedule": {"20": 5, "50": 10, "100": 15, "200": 20},
            "weighting": "recency",
            "minimum_per_archetype": 1,
            "current": {
                "SHARPE_HUNTER": 2,
                "RETURN_CHASER": 2,
                "RISK_MINIMIZER": 1,
                "CONSISTENCY": 1,
            },
            "last_rebalanced_generation": 0,
            "performance_history": {
                "SHARPE_HUNTER": [],
                "RETURN_CHASER": [],
                "RISK_MINIMIZER": [],
                "CONSISTENCY": [],
            },
        },
        "kb_health": {
            "last_compacted_generation": 0,
            "next_compaction_due_generation": 3,
            "active_lesson_count": 0,
            "total_raw_lessons": 0,
            "graveyard_count": 0,
            "pattern_count": {"winning": 0, "losing": 0},
            "last_quarterly_refresh": None,
            "next_quarterly_refresh": None,
            "current_market_regime": "UNKNOWN",
            "regime_history": [],
        },
    }


def _empty_patterns() -> dict:
    """Return a minimal valid patterns.json seed."""
    return {
        "version": "1.0.0",
        "last_updated_at": _now_iso(),
        "winning": [],
        "losing": [],
    }


def _empty_graveyard() -> dict:
    """Return a minimal valid graveyard.json seed."""
    return {
        "version": "1.0.0",
        "last_updated_at": _now_iso(),
        "entries": [],
    }


def _empty_lineage() -> dict:
    """Return a minimal valid lineage.json seed."""
    return {
        "version": "1.0.0",
        "last_updated_at": _now_iso(),
        "strategies": {},
        "elite_registry": {
            "global_top_10": [],
            "per_archetype": {
                "SHARPE_HUNTER": [],
                "RETURN_CHASER": [],
                "RISK_MINIMIZER": [],
                "CONSISTENCY": [],
            },
        },
        "generation_summaries": {},
    }


def _empty_lessons_active() -> dict:
    """Return a minimal valid lessons/active.json seed."""
    return {
        "version": "1.0.0",
        "last_updated_at": _now_iso(),
        "lessons": [],
    }


def _empty_lessons_index() -> dict:
    """Return a minimal valid lessons/index.json seed."""
    return {
        "version": "1.0.0",
        "last_updated_at": _now_iso(),
        "raw_files": [],
        "total_lessons": 0,
    }
