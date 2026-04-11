"""
lineage_tracker.py — Maintain the lineage.json family tree index.

Enables fast parent selection and dashboard visualization without reading
individual results files. All writes go through kb_writer.py.

Schema reference: Section 7 (lineage.json).
"""

import math
import os
import statistics
import sys
from datetime import datetime, timezone
from typing import Optional

_SRC_DIR = os.path.dirname(os.path.abspath(__file__))
if _SRC_DIR not in sys.path:
    sys.path.insert(0, _SRC_DIR)

from kb_writer import (  # noqa: E402
    LINEAGE_PATH,
    KBNotFoundError,
    read_json,
    write_json_atomic,
)

# ---------------------------------------------------------------------------
# Exceptions
# ---------------------------------------------------------------------------

class LineageError(Exception):
    """Raised when a lineage operation fails."""


# ---------------------------------------------------------------------------
# I/O helpers
# ---------------------------------------------------------------------------

def _now_iso() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _load_lineage() -> dict:
    """Load lineage.json, returning an empty scaffold if absent."""
    if not os.path.exists(LINEAGE_PATH):
        return _empty_lineage()
    return read_json(LINEAGE_PATH)


def _save_lineage(lineage: dict) -> None:
    lineage["last_updated"] = _now_iso()
    write_json_atomic(LINEAGE_PATH, lineage)


def _empty_lineage() -> dict:
    return {
        "version": "1.0",
        "last_updated": _now_iso(),
        "total_strategies": 0,
        "total_generations": 0,
        "generations": {},
        "strategies": {},
        "elite_registry": {
            "all_time_top_10": [],
            "top_3_per_archetype": {
                "SHARPE_HUNTER": [],
                "RETURN_CHASER": [],
                "RISK_MINIMIZER": [],
                "CONSISTENCY": [],
            },
            "last_updated": _now_iso(),
        },
    }


# ---------------------------------------------------------------------------
# tree_to_string utility
# ---------------------------------------------------------------------------

def tree_to_string(composer_json: dict) -> str:
    """Convert a composer_json tree to a compact human-readable string.

    Examples:
        Simple:   "wt-cash-equal → [TQQQ, BIL]"
        With if:  "if SVXY crash → BIL else filter top-1 [TQQQ, SOXL, UPRO]"
        Nested:   "if SVXY crash → BIL elif RSI(QQQ)>79 → VIXM else UPRO"

    Args:
        composer_json: The root node of a Composer symphony JSON tree.

    Returns:
        Human-readable string description of the tree structure.
    """
    if not composer_json:
        return "empty"
    return _node_to_str(composer_json)


def _node_to_str(node: dict) -> str:
    """Recursively render a composer node to a string."""
    step = node.get("step", "unknown")
    children = node.get("children", [])

    if step == "wt-cash-equal":
        tickers = [c.get("ticker", "?") for c in children if c.get("step") == "asset"]
        return f"wt-cash-equal → [{', '.join(tickers)}]"

    if step == "asset":
        return node.get("ticker", "?")

    if step == "filter":
        fn   = node.get("sort-by-fn", "fn")
        n    = node.get("select-n", "?")
        sel  = node.get("select-fn", "top")
        tickers = [c.get("ticker", "?") for c in children if c.get("step") == "asset"]
        if tickers:
            return f"filter top-{n} [{', '.join(tickers)}]"
        # Nested children (e.g. nested filter inside if)
        inner = ", ".join(_node_to_str(c) for c in children)
        return f"filter({sel}-{n} by {fn}) [{inner}]"

    if step == "if":
        return _if_to_str(children)

    # Fallback
    return step


def _if_to_str(children: list) -> str:
    """Render an if-node's children as a readable conditional string."""
    parts = []
    for i, child in enumerate(children):
        is_else = child.get("is-else-condition?", False)
        grandchildren = child.get("children", [])
        child_str = ", ".join(_node_to_str(gc) for gc in grandchildren) if grandchildren else "?"

        if is_else:
            parts.append(f"else {child_str}")
        else:
            # Build condition string
            lhs_fn     = child.get("lhs-fn", "")
            lhs_val    = child.get("lhs-val", "")
            comparator = child.get("comparator", "")
            rhs_val    = child.get("rhs-val", "")
            lhs_params = child.get("lhs-fn-params", {})

            if lhs_fn:
                fn_short = _short_fn(lhs_fn, lhs_params, lhs_val)
                cmp_sym  = _cmp_sym(comparator, rhs_val)
                condition = f"{fn_short}{cmp_sym}"
            else:
                condition = "condition"

            keyword = "if" if i == 0 else "elif"
            parts.append(f"{keyword} {condition} → {child_str}")

    return " ".join(parts)


def _short_fn(fn_name: str, params: dict, asset: str) -> str:
    """Shorten a function name to a compact readable form."""
    window = params.get("window", "")
    fn_map = {
        "max-drawdown": f"{asset} crash",
        "relative-strength-index": f"RSI({asset})" + (f">{window}" if window else ""),
        "cumulative-return": f"cum-return({asset})",
        "moving-average": f"MA({asset},{window})",
    }
    label = fn_map.get(fn_name, f"{fn_name}({asset})")
    return label


def _cmp_sym(comparator: str, rhs_val: str) -> str:
    """Convert comparator enum to symbol string."""
    sym_map = {
        "gt": f">{rhs_val}",
        "lt": f"<{rhs_val}",
        "gte": f">={rhs_val}",
        "lte": f"<={rhs_val}",
        "eq": f"={rhs_val}",
    }
    sym = sym_map.get(comparator, f" {comparator} {rhs_val}")
    return sym


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def register_strategy(strategy: dict) -> None:
    """Add a strategy entry to lineage.json.

    Reads strategy fields from the summary, identity, lineage, and
    final_result blocks. For disqualified strategies, fitness and
    performance fields will be null.

    Args:
        strategy: Full strategy dict.

    Raises:
        LineageError: If the strategy is missing required fields or the
                      write fails.
    """
    try:
        summary  = strategy["summary"]
        identity = strategy["identity"]
        lineage  = strategy["lineage"]
        composer = strategy.get("strategy", {}).get("composer_json", {})

        sid = summary["strategy_id"]
        generation = summary["generation"]

        # Determine final fitness / stats (null for disqualified)
        final_result = strategy.get("final_result") or {}
        nominal_result = strategy.get("nominal_result") or {}
        composite = (final_result.get("composite_fitness") or
                     nominal_result.get("composite_fitness") or {})

        # 1Y stats
        periods = (final_result.get("periods") or
                   nominal_result.get("periods") or {})
        p1y = periods.get("1Y", {})
        core_1y = p1y.get("core_metrics", {})

        fitness    = composite.get("final_composite") if composite else None
        sharpe_1y  = core_1y.get("sharpe")   if core_1y else None
        return_1y  = core_1y.get("annualized_return") if core_1y else None
        drawdown_1y = core_1y.get("max_drawdown") if core_1y else None

        gen_dir = f"history/gen-{generation:03d}/{sid}.json"

        entry = {
            "name": summary.get("name", ""),
            "generation": generation,
            "archetype": summary.get("archetype", ""),
            "fitness": fitness,
            "sharpe_1Y": sharpe_1y,
            "return_1Y": return_1y,
            "drawdown_1Y": drawdown_1y,
            "rebalance_frequency": summary.get("rebalance_frequency", "daily"),
            "status": summary.get("status", ""),
            "is_seed": lineage.get("is_seed", False),
            "parent_ids": lineage.get("parent_ids", []),
            "child_ids": [],
            "generation_type": lineage.get("generation_type", "NOVEL"),
            "mutation_description": lineage.get("mutation_description"),
            "top_level_structure": tree_to_string(composer),
            "patterns_used": lineage.get("parent_patterns", []),
            "recorded_at": _now_iso(),
            "archive_path": gen_dir,
        }

        lin = _load_lineage()
        lin["strategies"][sid] = entry
        lin["total_strategies"] = len(lin["strategies"])
        _save_lineage(lin)

    except (KeyError, TypeError) as exc:
        raise LineageError(
            f"register_strategy failed for "
            f"'{strategy.get('summary', {}).get('strategy_id', '?')}': {exc}"
        ) from exc


def back_fill_children(parent_ids: list[str], child_id: str) -> None:
    """Update parent strategy entries to include child_id in their child_ids list.

    Called after a new strategy is registered to wire up the family tree.

    Args:
        parent_ids: List of parent strategy IDs to update.
        child_id: The strategy ID to add to each parent's child_ids list.

    Raises:
        LineageError: If a parent_id is not found in lineage.json.
    """
    if not parent_ids:
        return
    lin = _load_lineage()
    for pid in parent_ids:
        if pid not in lin["strategies"]:
            raise LineageError(
                f"back_fill_children: parent '{pid}' not found in lineage.json. "
                "Register parent before calling back_fill_children."
            )
        if child_id not in lin["strategies"][pid]["child_ids"]:
            lin["strategies"][pid]["child_ids"].append(child_id)
    _save_lineage(lin)


def register_generation_complete(
    generation: int,
    results: list[dict],
) -> None:
    """Write a generation summary entry after all strategies are processed.

    Computes avg_fitness, std_dev_fitness, best_fitness, and per-archetype
    averages from the list of completed strategy results.

    Args:
        generation: Generation number (int).
        results: List of strategy dicts that reached COMPLETE status
                 (disqualified strategies are excluded from stats).

    Raises:
        LineageError: If the write fails.
    """
    try:
        # Filter to completed (non-disqualified) strategies with fitness scores
        completed = [
            r for r in results
            if not r.get("summary", {}).get("disqualified", False)
            and r.get("summary", {}).get("status") in {"COMPLETE", "LEARNED"}
        ]

        fitness_scores = []
        archetype_scores: dict[str, list[float]] = {}

        for r in completed:
            summary = r.get("summary", {})
            fitness = summary.get("final_composite_fitness")
            arch    = summary.get("archetype", "UNKNOWN")
            if fitness is not None:
                fitness_scores.append(fitness)
                archetype_scores.setdefault(arch, []).append(fitness)

        n = len(fitness_scores)
        avg_fitness   = sum(fitness_scores) / n if n > 0 else 0.0
        std_dev       = statistics.stdev(fitness_scores) if n > 1 else 0.0
        best_fitness  = max(fitness_scores) if fitness_scores else 0.0
        best_strat_id = ""
        for r in completed:
            if r.get("summary", {}).get("final_composite_fitness") == best_fitness:
                best_strat_id = r["summary"]["strategy_id"]
                break

        archetype_avg = {
            arch: (sum(scores) / len(scores))
            for arch, scores in archetype_scores.items()
        }

        total_disq = sum(
            1 for r in results
            if r.get("summary", {}).get("disqualified", False)
        )

        gen_key = f"gen-{generation:03d}"
        summary_entry = {
            "completed_at": _now_iso(),
            "strategies_generated": len(results),
            "strategies_completed": len(completed),
            "strategies_disqualified": total_disq,
            "avg_fitness": round(avg_fitness, 4),
            "std_dev_fitness": round(std_dev, 4),
            "best_fitness": round(best_fitness, 4),
            "best_strategy_id": best_strat_id,
            "archetype_avg_fitness": archetype_avg,
        }

        lin = _load_lineage()
        lin["generations"][gen_key] = summary_entry
        lin["total_generations"] = len(lin["generations"])
        _save_lineage(lin)

    except Exception as exc:
        raise LineageError(
            f"register_generation_complete failed for generation {generation}: {exc}"
        ) from exc


def update_elite_registry(strategy: dict) -> None:
    """Update the elite_registry with a newly scored strategy.

    Maintains sorted top-10 global list and top-3 per archetype.
    Trims to 10/3 when exceeded. Disqualified strategies (fitness=None)
    are ignored.

    Args:
        strategy: Full strategy dict with final composite fitness in summary.

    Raises:
        LineageError: If the update fails.
    """
    try:
        summary  = strategy["summary"]
        fitness  = summary.get("final_composite_fitness")
        if fitness is None:
            return  # Disqualified — skip

        sid      = summary["strategy_id"]
        name     = summary.get("name", "")
        arch     = summary.get("archetype", "")
        gen      = summary.get("generation", 0)

        # Pull 1Y stats from results
        final_result = strategy.get("final_result") or strategy.get("nominal_result") or {}
        periods  = final_result.get("periods", {})
        p1y      = periods.get("1Y", {})
        core_1y  = p1y.get("core_metrics", {})

        entry = {
            "strategy_id": sid,
            "name": name,
            "fitness": fitness,
            "archetype": arch,
            "generation": gen,
            "sharpe_1Y": core_1y.get("sharpe"),
            "return_1Y": core_1y.get("annualized_return"),
            "drawdown_1Y": core_1y.get("max_drawdown"),
        }

        lin = _load_lineage()
        er  = lin["elite_registry"]

        # --- Global top-10 ---
        top10 = er.get("all_time_top_10", [])
        # Remove existing entry for this strategy (fitness may have improved)
        top10 = [e for e in top10 if e["strategy_id"] != sid]
        top10.append(entry)
        top10.sort(key=lambda e: e["fitness"], reverse=True)
        er["all_time_top_10"] = top10[:10]

        # --- Per-archetype top-3 ---
        per_arch = er.get("top_3_per_archetype", {})
        arch_list = per_arch.get(arch, [])
        arch_list = [e for e in arch_list if e["strategy_id"] != sid]
        arch_list.append(entry)
        arch_list.sort(key=lambda e: e["fitness"], reverse=True)
        per_arch[arch] = arch_list[:3]
        er["top_3_per_archetype"] = per_arch

        er["last_updated"] = _now_iso()
        lin["elite_registry"] = er
        _save_lineage(lin)

    except (KeyError, TypeError) as exc:
        raise LineageError(
            f"update_elite_registry failed for "
            f"'{strategy.get('summary', {}).get('strategy_id', '?')}': {exc}"
        ) from exc


def get_parents_for_archetype(
    archetype: str,
    limit: int = 3,
) -> list[dict]:
    """Return top strategies for a given archetype from the elite registry.

    Args:
        archetype: One of SHARPE_HUNTER | RETURN_CHASER | RISK_MINIMIZER | CONSISTENCY.
        limit: Maximum number of entries to return (default 3).

    Returns:
        List of elite registry entry dicts, sorted by fitness descending.
        Returns empty list if no entries exist for the archetype.
    """
    try:
        lin = _load_lineage()
        per_arch = lin.get("elite_registry", {}).get("top_3_per_archetype", {})
        return per_arch.get(archetype, [])[:limit]
    except Exception:
        return []
