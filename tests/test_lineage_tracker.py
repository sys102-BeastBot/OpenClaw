"""
test_lineage_tracker.py — Full test suite for lineage_tracker.py.

Tests required per SKILL.md:
  - back_fill_children correctly updates parent entries
  - update_elite_registry maintains sorted top-10 order
  - update_elite_registry trims to 10 when 11th entry added
  - update_elite_registry maintains top-3 per archetype separately
  - get_parents_for_archetype returns empty list gracefully when no entries
  - tree_to_string produces readable output for all valid node type combinations
  - Generation summary stats computed correctly (avg, std_dev, best)
"""

import json
import os
import sys
import statistics
import pytest

# ---------------------------------------------------------------------------
# Path setup
# ---------------------------------------------------------------------------
WORKSPACE = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SRC_DIR   = os.path.join(os.path.dirname(__file__), "..", "src")
MOCK_DIR  = os.path.join(WORKSPACE, "skills", "learning-agent-builder", "mock-data")
sys.path.insert(0, SRC_DIR)

import kb_writer
import lineage_tracker as lt_module
from lineage_tracker import (  # noqa: E402
    LineageError,
    back_fill_children,
    get_parents_for_archetype,
    register_generation_complete,
    register_strategy,
    tree_to_string,
    update_elite_registry,
)


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

@pytest.fixture(autouse=True)
def isolated_lineage(tmp_path, monkeypatch):
    kb_root = str(tmp_path / "kb")
    os.makedirs(kb_root, exist_ok=True)
    monkeypatch.setattr(kb_writer, "KB_ROOT",        kb_root)
    monkeypatch.setattr(kb_writer, "LINEAGE_PATH",   str(tmp_path / "kb" / "lineage.json"))
    monkeypatch.setattr(kb_writer, "GRAVEYARD_PATH", str(tmp_path / "kb" / "graveyard.json"))
    monkeypatch.setattr(kb_writer, "META_PATH",      str(tmp_path / "kb" / "meta.json"))
    monkeypatch.setattr(kb_writer, "PENDING_DIR",    str(tmp_path / "pending"))
    monkeypatch.setattr(kb_writer, "RESULTS_DIR",    str(tmp_path / "results"))
    monkeypatch.setattr(kb_writer, "HISTORY_DIR",    str(tmp_path / "history"))
    monkeypatch.setattr(lt_module, "LINEAGE_PATH",   str(tmp_path / "kb" / "lineage.json"))


def load_mock(filename: str) -> dict:
    with open(os.path.join(MOCK_DIR, filename)) as f:
        return json.load(f)


@pytest.fixture()
def mock_strategy() -> dict:
    return load_mock("mock-strategy-pending.json")


def read_lineage() -> dict:
    path = lt_module.LINEAGE_PATH
    with open(path) as f:
        return json.load(f)


def make_strategy(
    sid: str = "gen-001-strat-01",
    name: str = "Test Strategy",
    archetype: str = "SHARPE_HUNTER",
    generation: int = 1,
    fitness: float = 72.0,
    sharpe: float = 2.1,
    ann_return: float = 45.0,
    max_drawdown: float = 12.0,
    disqualified: bool = False,
    status: str = "COMPLETE",
) -> dict:
    """Build a minimal complete strategy dict for testing."""
    return {
        "summary": {
            "strategy_id": sid,
            "name": name,
            "archetype": archetype,
            "generation": generation,
            "final_composite_fitness": None if disqualified else fitness,
            "final_sharpe_1Y": None if disqualified else sharpe,
            "final_return_1Y": None if disqualified else ann_return,
            "final_max_drawdown_1Y": None if disqualified else max_drawdown,
            "final_std_dev": None,
            "optimization_delta": None,
            "passed_rough_cut": not disqualified,
            "disqualified": disqualified,
            "status": "DISQUALIFIED" if disqualified else status,
            "rebalance_frequency": "daily",
        },
        "identity": {
            "strategy_id": sid,
            "name": name,
            "generation": generation,
            "archetype": archetype,
            "slot_number": 1,
            "created_at": "2026-03-21T10:00:00Z",
            "rebalance_frequency": "daily",
            "composer_rebalance_value": {"asset-class": "EQUITIES", "rebalance-frequency": "daily"},
            "composer_symphony_id": None,
        },
        "strategy": {
            "description": {"summary": "test"},
            "composer_json": {
                "step": "wt-cash-equal",
                "children": [
                    {"step": "asset", "ticker": "TQQQ", "children": []},
                    {"step": "asset", "ticker": "BIL",  "children": []},
                ],
            },
        },
        "lineage": {
            "parent_ids": [],
            "parent_patterns": [],
            "generation_type": "NOVEL",
            "mutation_description": None,
            "is_seed": False,
            "seed_source": None,
        },
        "nominal_result": {
            "periods": {
                "1Y": {
                    "period": "1Y",
                    "core_metrics": {
                        "annualized_return": ann_return,
                        "total_return": ann_return,
                        "sharpe": sharpe,
                        "max_drawdown": max_drawdown,
                        "volatility": 18.0,
                        "win_rate": 60.0,
                    },
                    "benchmark_metrics": {
                        "benchmark_ticker": "SPY",
                        "benchmark_annualized_return": 24.1,
                        "beats_benchmark": True,
                        "alpha": None, "beta": None,
                        "r_squared": None, "correlation": None,
                    },
                    "fitness": None,
                    "raw_api_fields": {},
                }
            },
            "composite_fitness": {
                "period_scores": {},
                "weighted_composite": fitness,
                "std_dev": 2.0,
                "consistency_adjustment": 2.0,
                "final_composite": fitness,
            },
        },
        "optimizer_data": None,
        "final_result": None,
    }


# ---------------------------------------------------------------------------
# tree_to_string() tests
# ---------------------------------------------------------------------------

class TestTreeToString:
    """tree_to_string produces readable output for all valid node type combinations."""

    def test_wt_cash_equal_simple(self):
        node = {
            "step": "wt-cash-equal",
            "children": [
                {"step": "asset", "ticker": "TQQQ", "children": []},
                {"step": "asset", "ticker": "BIL",  "children": []},
            ],
        }
        result = tree_to_string(node)
        assert "wt-cash-equal" in result
        assert "TQQQ" in result
        assert "BIL" in result

    def test_filter_node(self):
        node = {
            "step": "filter",
            "sort-by-fn": "cumulative-return",
            "sort-by-fn-params": {"window": 20},
            "select-fn": "top",
            "select-n": "1",
            "children": [
                {"step": "asset", "ticker": "TQQQ", "children": []},
                {"step": "asset", "ticker": "SOXL", "children": []},
                {"step": "asset", "ticker": "UPRO", "children": []},
            ],
        }
        result = tree_to_string(node)
        assert "filter" in result
        assert "TQQQ" in result

    def test_if_guard_simple(self, mock_strategy):
        """if-guard with crash condition + else."""
        node = mock_strategy["strategy"]["composer_json"]
        result = tree_to_string(node)
        assert "if" in result.lower() or "crash" in result.lower() or "SVXY" in result

    def test_asset_node_returns_ticker(self):
        node = {"step": "asset", "ticker": "SPY", "children": []}
        result = tree_to_string(node)
        assert "SPY" in result

    def test_empty_node_returns_something(self):
        result = tree_to_string({})
        assert result  # not empty string

    def test_nested_if_elif_else(self):
        """Nested if → elif → else produces readable multi-condition string."""
        node = {
            "step": "if",
            "children": [
                {
                    "step": "if-child",
                    "lhs-fn": "max-drawdown",
                    "lhs-fn-params": {"window": 2},
                    "lhs-val": "SVXY",
                    "comparator": "gt",
                    "rhs-val": "10",
                    "rhs-fixed-value?": True,
                    "is-else-condition?": False,
                    "children": [{"step": "asset", "ticker": "BIL", "children": []}],
                },
                {
                    "step": "if-child",
                    "lhs-fn": "relative-strength-index",
                    "lhs-fn-params": {"window": 10},
                    "lhs-val": "QQQ",
                    "comparator": "gt",
                    "rhs-val": "79",
                    "rhs-fixed-value?": True,
                    "is-else-condition?": False,
                    "children": [{"step": "asset", "ticker": "VIXM", "children": []}],
                },
                {
                    "step": "if-child",
                    "is-else-condition?": True,
                    "children": [{"step": "asset", "ticker": "UPRO", "children": []}],
                },
            ],
        }
        result = tree_to_string(node)
        assert "if" in result
        assert "BIL" in result
        assert "VIXM" in result
        assert "UPRO" in result
        assert "else" in result

    def test_returns_string_type(self):
        node = {"step": "wt-cash-equal", "children": []}
        assert isinstance(tree_to_string(node), str)


# ---------------------------------------------------------------------------
# register_strategy() tests
# ---------------------------------------------------------------------------

class TestRegisterStrategy:
    def test_registers_entry(self, mock_strategy):
        register_strategy(mock_strategy)
        lin = read_lineage()
        sid = mock_strategy["summary"]["strategy_id"]
        assert sid in lin["strategies"]

    def test_total_strategies_incremented(self, mock_strategy):
        register_strategy(mock_strategy)
        lin = read_lineage()
        assert lin["total_strategies"] == 1

    def test_entry_has_correct_fields(self, mock_strategy):
        register_strategy(mock_strategy)
        lin = read_lineage()
        entry = lin["strategies"][mock_strategy["summary"]["strategy_id"]]
        assert "name" in entry
        assert "archetype" in entry
        assert "generation" in entry
        assert "child_ids" in entry
        assert "parent_ids" in entry
        assert "top_level_structure" in entry
        assert "recorded_at" in entry

    def test_child_ids_starts_empty(self, mock_strategy):
        register_strategy(mock_strategy)
        lin = read_lineage()
        entry = lin["strategies"][mock_strategy["summary"]["strategy_id"]]
        assert entry["child_ids"] == []

    def test_top_level_structure_populated(self, mock_strategy):
        register_strategy(mock_strategy)
        lin = read_lineage()
        entry = lin["strategies"][mock_strategy["summary"]["strategy_id"]]
        assert entry["top_level_structure"] != ""


# ---------------------------------------------------------------------------
# back_fill_children() tests
# ---------------------------------------------------------------------------

class TestBackFillChildren:
    """back_fill_children correctly updates parent entries."""

    def test_updates_parent_child_ids(self):
        parent = make_strategy(sid="gen-001-strat-01", fitness=70.0)
        child  = make_strategy(sid="gen-002-strat-01", fitness=75.0,
                               generation=2)
        register_strategy(parent)
        register_strategy(child)
        back_fill_children(["gen-001-strat-01"], "gen-002-strat-01")
        lin = read_lineage()
        assert "gen-002-strat-01" in lin["strategies"]["gen-001-strat-01"]["child_ids"]

    def test_multiple_parents_updated(self):
        p1 = make_strategy(sid="gen-001-strat-01", fitness=70.0)
        p2 = make_strategy(sid="gen-001-strat-02", fitness=68.0)
        child = make_strategy(sid="gen-002-strat-01", fitness=75.0, generation=2)
        register_strategy(p1)
        register_strategy(p2)
        register_strategy(child)
        back_fill_children(["gen-001-strat-01", "gen-001-strat-02"], "gen-002-strat-01")
        lin = read_lineage()
        assert "gen-002-strat-01" in lin["strategies"]["gen-001-strat-01"]["child_ids"]
        assert "gen-002-strat-01" in lin["strategies"]["gen-001-strat-02"]["child_ids"]

    def test_no_duplicate_child_ids(self):
        parent = make_strategy(sid="gen-001-strat-01", fitness=70.0)
        child  = make_strategy(sid="gen-002-strat-01", fitness=75.0, generation=2)
        register_strategy(parent)
        register_strategy(child)
        back_fill_children(["gen-001-strat-01"], "gen-002-strat-01")
        back_fill_children(["gen-001-strat-01"], "gen-002-strat-01")  # duplicate call
        lin = read_lineage()
        assert lin["strategies"]["gen-001-strat-01"]["child_ids"].count("gen-002-strat-01") == 1

    def test_empty_parent_list_is_noop(self):
        child = make_strategy(sid="gen-001-strat-01", fitness=70.0)
        register_strategy(child)
        back_fill_children([], "gen-001-strat-01")  # no error
        lin = read_lineage()
        assert lin["strategies"]["gen-001-strat-01"]["child_ids"] == []

    def test_missing_parent_raises(self):
        child = make_strategy(sid="gen-002-strat-01", generation=2)
        register_strategy(child)
        with pytest.raises(LineageError, match="not found"):
            back_fill_children(["gen-001-strat-nonexistent"], "gen-002-strat-01")


# ---------------------------------------------------------------------------
# update_elite_registry() tests
# ---------------------------------------------------------------------------

class TestUpdateEliteRegistry:
    """Top-10 sorted; trims at 11; top-3 per archetype maintained."""

    def test_adds_to_global_top_10(self):
        s = make_strategy(fitness=80.0)
        update_elite_registry(s)
        lin = read_lineage()
        assert len(lin["elite_registry"]["all_time_top_10"]) == 1

    def test_sorted_descending(self):
        for i, fitness in enumerate([70.0, 80.0, 60.0]):
            s = make_strategy(sid=f"gen-001-strat-0{i}", fitness=fitness)
            update_elite_registry(s)
        lin = read_lineage()
        scores = [e["fitness"] for e in lin["elite_registry"]["all_time_top_10"]]
        assert scores == sorted(scores, reverse=True)

    def test_trims_to_10_when_11th_added(self):
        for i in range(11):
            s = make_strategy(sid=f"gen-001-strat-{i:02d}", fitness=float(50 + i))
            update_elite_registry(s)
        lin = read_lineage()
        assert len(lin["elite_registry"]["all_time_top_10"]) == 10

    def test_lowest_score_dropped_when_trimmed(self):
        for i in range(11):
            s = make_strategy(sid=f"gen-001-strat-{i:02d}", fitness=float(50 + i))
            update_elite_registry(s)
        lin = read_lineage()
        scores = [e["fitness"] for e in lin["elite_registry"]["all_time_top_10"]]
        assert 50.0 not in scores  # the lowest (50.0) should be dropped

    def test_updates_existing_entry_for_same_strategy(self):
        """Updating same strategy with higher score replaces old entry."""
        s1 = make_strategy(sid="gen-001-strat-01", fitness=60.0)
        s2 = make_strategy(sid="gen-001-strat-01", fitness=75.0)
        update_elite_registry(s1)
        update_elite_registry(s2)
        lin = read_lineage()
        top10 = lin["elite_registry"]["all_time_top_10"]
        matching = [e for e in top10 if e["strategy_id"] == "gen-001-strat-01"]
        assert len(matching) == 1
        assert matching[0]["fitness"] == 75.0

    def test_per_archetype_top_3_maintained_separately(self):
        """top_3_per_archetype keeps each archetype's top 3 independent."""
        archetypes = ["SHARPE_HUNTER", "RETURN_CHASER", "RISK_MINIMIZER", "CONSISTENCY"]
        for arch in archetypes:
            for i in range(4):
                s = make_strategy(
                    sid=f"gen-001-{arch[:4]}-{i:02d}",
                    archetype=arch,
                    fitness=float(60 + i),
                )
                update_elite_registry(s)
        lin = read_lineage()
        per_arch = lin["elite_registry"]["top_3_per_archetype"]
        for arch in archetypes:
            assert len(per_arch[arch]) == 3

    def test_per_archetype_sorted_descending(self):
        for i, fitness in enumerate([65.0, 72.0, 68.0]):
            s = make_strategy(
                sid=f"gen-001-strat-{i:02d}",
                archetype="SHARPE_HUNTER",
                fitness=fitness,
            )
            update_elite_registry(s)
        lin = read_lineage()
        scores = [e["fitness"] for e in lin["elite_registry"]["top_3_per_archetype"]["SHARPE_HUNTER"]]
        assert scores == sorted(scores, reverse=True)

    def test_disqualified_strategy_ignored(self):
        """Disqualified strategy (fitness=None) must not appear in elite registry."""
        # First register a valid strategy so the lineage file exists
        valid = make_strategy(sid="gen-001-strat-00", fitness=70.0)
        update_elite_registry(valid)
        # Now try to add a disqualified one — its summary.final_composite_fitness is None
        disq = make_strategy(sid="gen-001-strat-01", disqualified=True)
        disq["summary"]["final_composite_fitness"] = None
        update_elite_registry(disq)
        lin = read_lineage()
        ids = [e["strategy_id"] for e in lin["elite_registry"]["all_time_top_10"]]
        assert "gen-001-strat-01" not in ids
        assert len(lin["elite_registry"]["all_time_top_10"]) == 1

    def test_archetypes_dont_bleed_into_each_other(self):
        sh = make_strategy(sid="gen-001-strat-01", archetype="SHARPE_HUNTER", fitness=90.0)
        rc = make_strategy(sid="gen-001-strat-02", archetype="RETURN_CHASER", fitness=85.0)
        update_elite_registry(sh)
        update_elite_registry(rc)
        lin = read_lineage()
        pa = lin["elite_registry"]["top_3_per_archetype"]
        sh_ids = [e["strategy_id"] for e in pa["SHARPE_HUNTER"]]
        rc_ids = [e["strategy_id"] for e in pa["RETURN_CHASER"]]
        assert "gen-001-strat-01" in sh_ids
        assert "gen-001-strat-02" in rc_ids
        assert "gen-001-strat-02" not in sh_ids
        assert "gen-001-strat-01" not in rc_ids


# ---------------------------------------------------------------------------
# get_parents_for_archetype() tests
# ---------------------------------------------------------------------------

class TestGetParentsForArchetype:
    """Returns empty list gracefully when no entries exist."""

    def test_returns_empty_list_when_no_entries(self):
        result = get_parents_for_archetype("SHARPE_HUNTER")
        assert result == []

    def test_returns_empty_list_for_unknown_archetype(self):
        result = get_parents_for_archetype("NONEXISTENT")
        assert result == []

    def test_returns_correct_archetype_entries(self):
        s = make_strategy(sid="gen-001-strat-01", archetype="SHARPE_HUNTER", fitness=80.0)
        update_elite_registry(s)
        result = get_parents_for_archetype("SHARPE_HUNTER")
        assert len(result) == 1
        assert result[0]["strategy_id"] == "gen-001-strat-01"

    def test_does_not_return_other_archetypes(self):
        sh = make_strategy(sid="gen-001-strat-01", archetype="SHARPE_HUNTER", fitness=80.0)
        rc = make_strategy(sid="gen-001-strat-02", archetype="RETURN_CHASER", fitness=75.0)
        update_elite_registry(sh)
        update_elite_registry(rc)
        result = get_parents_for_archetype("SHARPE_HUNTER")
        ids = [e["strategy_id"] for e in result]
        assert "gen-001-strat-01" in ids
        assert "gen-001-strat-02" not in ids

    def test_respects_limit_parameter(self):
        for i in range(3):
            s = make_strategy(
                sid=f"gen-001-strat-{i:02d}",
                archetype="SHARPE_HUNTER",
                fitness=float(70 + i),
            )
            update_elite_registry(s)
        result = get_parents_for_archetype("SHARPE_HUNTER", limit=2)
        assert len(result) == 2

    def test_returns_list_type(self):
        result = get_parents_for_archetype("CONSISTENCY")
        assert isinstance(result, list)


# ---------------------------------------------------------------------------
# register_generation_complete() tests
# ---------------------------------------------------------------------------

class TestRegisterGenerationComplete:
    """Generation summary stats computed correctly (avg, std_dev, best)."""

    def _make_results(self, fitnesses: list[float], generation: int = 1) -> list[dict]:
        return [
            make_strategy(
                sid=f"gen-{generation:03d}-strat-{i:02d}",
                fitness=f,
                generation=generation,
            )
            for i, f in enumerate(fitnesses)
        ]

    def test_avg_fitness_correct(self):
        fitnesses = [60.0, 70.0, 80.0]
        results = self._make_results(fitnesses)
        register_generation_complete(1, results)
        lin = read_lineage()
        gen_summary = lin["generations"]["gen-001"]
        assert gen_summary["avg_fitness"] == pytest.approx(sum(fitnesses) / len(fitnesses))

    def test_std_dev_correct(self):
        fitnesses = [60.0, 70.0, 80.0]
        results = self._make_results(fitnesses)
        register_generation_complete(1, results)
        lin = read_lineage()
        gen_summary = lin["generations"]["gen-001"]
        expected_std = statistics.stdev(fitnesses)
        assert gen_summary["std_dev_fitness"] == pytest.approx(expected_std, abs=1e-3)

    def test_best_fitness_correct(self):
        fitnesses = [60.0, 70.0, 80.0]
        results = self._make_results(fitnesses)
        register_generation_complete(1, results)
        lin = read_lineage()
        gen_summary = lin["generations"]["gen-001"]
        assert gen_summary["best_fitness"] == pytest.approx(80.0)

    def test_best_strategy_id_correct(self):
        results = self._make_results([60.0, 80.0, 70.0])
        register_generation_complete(1, results)
        lin = read_lineage()
        gen_summary = lin["generations"]["gen-001"]
        assert gen_summary["best_strategy_id"] == "gen-001-strat-01"  # index 1, fitness=80

    def test_disqualified_excluded_from_stats(self):
        completed = [
            make_strategy(sid="gen-001-strat-00", fitness=70.0),
            make_strategy(sid="gen-001-strat-01", fitness=80.0),
        ]
        disq = make_strategy(sid="gen-001-strat-02", fitness=10.0, disqualified=True)
        results = completed + [disq]
        register_generation_complete(1, results)
        lin = read_lineage()
        gen_summary = lin["generations"]["gen-001"]
        # avg should be (70+80)/2=75, not include 10
        assert gen_summary["avg_fitness"] == pytest.approx(75.0)

    def test_strategies_generated_count(self):
        results = self._make_results([60.0, 70.0, 80.0])
        register_generation_complete(1, results)
        lin = read_lineage()
        assert lin["generations"]["gen-001"]["strategies_generated"] == 3

    def test_strategies_disqualified_count(self):
        completed = [make_strategy(sid=f"gen-001-strat-{i:02d}", fitness=70.0) for i in range(4)]
        disq = [make_strategy(sid=f"gen-001-strat-{i+4:02d}", fitness=10.0, disqualified=True) for i in range(2)]
        register_generation_complete(1, completed + disq)
        lin = read_lineage()
        assert lin["generations"]["gen-001"]["strategies_disqualified"] == 2

    def test_total_generations_incremented(self):
        results = self._make_results([70.0, 75.0])
        register_generation_complete(1, results)
        lin = read_lineage()
        assert lin["total_generations"] == 1

    def test_single_strategy_std_dev_is_zero(self):
        """Single completed strategy → std_dev = 0 (no variance)."""
        results = self._make_results([75.0])
        register_generation_complete(1, results)
        lin = read_lineage()
        assert lin["generations"]["gen-001"]["std_dev_fitness"] == pytest.approx(0.0)

    def test_archetype_avg_fitness_computed(self):
        results = [
            make_strategy(sid="gen-001-strat-00", archetype="SHARPE_HUNTER", fitness=70.0),
            make_strategy(sid="gen-001-strat-01", archetype="SHARPE_HUNTER", fitness=80.0),
            make_strategy(sid="gen-001-strat-02", archetype="RETURN_CHASER", fitness=65.0),
        ]
        register_generation_complete(1, results)
        lin = read_lineage()
        arch_avg = lin["generations"]["gen-001"]["archetype_avg_fitness"]
        assert arch_avg["SHARPE_HUNTER"] == pytest.approx(75.0)
        assert arch_avg["RETURN_CHASER"] == pytest.approx(65.0)
