"""
test_ranker.py — Full test suite for ranker.py.
"""

import json
import os
import statistics
import sys
import pytest

# ---------------------------------------------------------------------------
# Path setup
# ---------------------------------------------------------------------------
WORKSPACE = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SRC_DIR   = os.path.join(os.path.dirname(__file__), "..", "src")
MOCK_DIR  = os.path.join(WORKSPACE, "skills", "learning-agent-builder", "mock-data")
sys.path.insert(0, SRC_DIR)

from ranker import (  # noqa: E402
    check_new_best,
    compute_generation_stats,
    identify_parents,
    rank_generation,
)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def load_mock(filename: str) -> dict:
    with open(os.path.join(MOCK_DIR, filename)) as f:
        return json.load(f)


def make_strategy(
    sid: str = "gen-001-strat-01",
    fitness: float = 70.0,
    archetype: str = "SHARPE_HUNTER",
    disqualified: bool = False,
) -> dict:
    return {
        "summary": {
            "strategy_id": sid,
            "archetype": archetype,
            "final_composite_fitness": None if disqualified else fitness,
            "disqualified": disqualified,
            "status": "DISQUALIFIED" if disqualified else "COMPLETE",
        },
        "nominal_result": {
            "composite_fitness": {
                "final_composite": None if disqualified else fitness,
            }
        },
    }


@pytest.fixture()
def mock_meta():
    return load_mock("mock-meta.json")


# ---------------------------------------------------------------------------
# rank_generation()
# ---------------------------------------------------------------------------

class TestRankGeneration:
    def test_sorted_best_to_worst(self, mock_meta):
        results = [
            make_strategy("s-01", fitness=60.0),
            make_strategy("s-02", fitness=80.0),
            make_strategy("s-03", fitness=70.0),
        ]
        ranked = rank_generation(results, mock_meta)
        scores = [r["summary"]["final_composite_fitness"] for r in ranked]
        assert scores == sorted(scores, reverse=True)

    def test_disqualified_sorted_to_bottom(self, mock_meta):
        results = [
            make_strategy("s-01", fitness=60.0),
            make_strategy("s-02", disqualified=True),
            make_strategy("s-03", fitness=80.0),
        ]
        ranked = rank_generation(results, mock_meta)
        assert ranked[-1]["summary"]["disqualified"] is True

    def test_multiple_disqualified_all_at_bottom(self, mock_meta):
        results = [
            make_strategy("s-01", fitness=70.0),
            make_strategy("s-02", disqualified=True),
            make_strategy("s-03", disqualified=True),
        ]
        ranked = rank_generation(results, mock_meta)
        assert ranked[0]["summary"]["disqualified"] is False
        assert all(r["summary"]["disqualified"] for r in ranked[1:])

    def test_empty_list_returns_empty(self, mock_meta):
        assert rank_generation([], mock_meta) == []

    def test_single_item_returned(self, mock_meta):
        results = [make_strategy("s-01", fitness=75.0)]
        ranked = rank_generation(results, mock_meta)
        assert len(ranked) == 1

    def test_preserves_all_items(self, mock_meta):
        results = [make_strategy(f"s-{i:02d}", fitness=float(50+i)) for i in range(6)]
        ranked = rank_generation(results, mock_meta)
        assert len(ranked) == 6


# ---------------------------------------------------------------------------
# compute_generation_stats()
# ---------------------------------------------------------------------------

class TestComputeGenerationStats:
    def test_avg_fitness_correct(self):
        fitnesses = [60.0, 70.0, 80.0]
        results = [make_strategy(f"s-{i}", f) for i, f in enumerate(fitnesses)]
        stats = compute_generation_stats(results)
        assert stats["avg_fitness"] == pytest.approx(sum(fitnesses) / len(fitnesses))

    def test_std_dev_correct(self):
        fitnesses = [60.0, 70.0, 80.0]
        results = [make_strategy(f"s-{i}", f) for i, f in enumerate(fitnesses)]
        stats = compute_generation_stats(results)
        assert stats["std_dev_fitness"] == pytest.approx(statistics.stdev(fitnesses), abs=1e-3)

    def test_best_and_worst_fitness(self):
        results = [
            make_strategy("s-00", 60.0),
            make_strategy("s-01", 80.0),
            make_strategy("s-02", 70.0),
        ]
        stats = compute_generation_stats(results)
        assert stats["best_fitness"] == pytest.approx(80.0)
        assert stats["worst_fitness"] == pytest.approx(60.0)
        assert stats["best_strategy_id"] == "s-01"
        assert stats["worst_strategy_id"] == "s-00"

    def test_disqualified_excluded_from_stats(self):
        results = [
            make_strategy("s-00", 70.0),
            make_strategy("s-01", 80.0),
            make_strategy("s-02", 10.0, disqualified=True),
        ]
        stats = compute_generation_stats(results)
        assert stats["avg_fitness"] == pytest.approx(75.0)
        assert stats["best_fitness"] == pytest.approx(80.0)

    def test_counts_correct(self):
        results = [
            make_strategy("s-00", 70.0),
            make_strategy("s-01", 80.0),
            make_strategy("s-02", disqualified=True),
        ]
        stats = compute_generation_stats(results)
        assert stats["total_strategies"] == 3
        assert stats["total_completed"] == 2
        assert stats["total_disqualified"] == 1

    def test_archetype_avg_fitness(self):
        results = [
            make_strategy("s-00", 70.0, archetype="SHARPE_HUNTER"),
            make_strategy("s-01", 80.0, archetype="SHARPE_HUNTER"),
            make_strategy("s-02", 65.0, archetype="RETURN_CHASER"),
        ]
        stats = compute_generation_stats(results)
        assert stats["archetype_avg_fitness"]["SHARPE_HUNTER"] == pytest.approx(75.0)
        assert stats["archetype_avg_fitness"]["RETURN_CHASER"] == pytest.approx(65.0)

    def test_empty_results(self):
        stats = compute_generation_stats([])
        assert stats["avg_fitness"] is None
        assert stats["total_strategies"] == 0

    def test_single_strategy_std_dev_zero(self):
        stats = compute_generation_stats([make_strategy("s-00", 75.0)])
        assert stats["std_dev_fitness"] == pytest.approx(0.0)

    def test_all_disqualified(self):
        results = [make_strategy(f"s-{i}", disqualified=True) for i in range(3)]
        stats = compute_generation_stats(results)
        assert stats["avg_fitness"] is None
        assert stats["total_disqualified"] == 3

    def test_has_all_required_keys(self):
        results = [make_strategy("s-00", 70.0)]
        stats = compute_generation_stats(results)
        for key in ["total_strategies", "total_completed", "total_disqualified",
                    "avg_fitness", "std_dev_fitness", "best_fitness", "worst_fitness",
                    "best_strategy_id", "worst_strategy_id", "archetype_avg_fitness"]:
            assert key in stats, f"Missing key: {key}"


# ---------------------------------------------------------------------------
# identify_parents()
# ---------------------------------------------------------------------------

class TestIdentifyParents:
    def test_returns_ids_above_threshold(self, mock_meta):
        results = [
            make_strategy("s-00", fitness=75.0),
            make_strategy("s-01", fitness=80.0),
            make_strategy("s-02", fitness=65.0),  # below threshold
        ]
        ranked = rank_generation(results, mock_meta)
        parents = identify_parents(ranked, mock_meta)
        assert "s-00" in parents
        assert "s-01" in parents
        assert "s-02" not in parents

    def test_max_6_parents_returned(self, mock_meta):
        results = [make_strategy(f"s-{i:02d}", fitness=float(71+i)) for i in range(10)]
        ranked = rank_generation(results, mock_meta)
        parents = identify_parents(ranked, mock_meta)
        assert len(parents) <= 6

    def test_disqualified_excluded(self, mock_meta):
        results = [
            make_strategy("s-00", fitness=80.0),
            make_strategy("s-01", disqualified=True),
        ]
        ranked = rank_generation(results, mock_meta)
        parents = identify_parents(ranked, mock_meta)
        assert "s-01" not in parents

    def test_empty_when_no_qualifiers(self, mock_meta):
        results = [make_strategy(f"s-{i}", fitness=float(50+i)) for i in range(3)]
        ranked = rank_generation(results, mock_meta)
        parents = identify_parents(ranked, mock_meta)
        assert parents == []

    def test_exact_threshold_qualifies(self, mock_meta):
        results = [make_strategy("s-00", fitness=70.0)]
        ranked = rank_generation(results, mock_meta)
        parents = identify_parents(ranked, mock_meta)
        assert "s-00" in parents

    def test_just_below_threshold_excluded(self, mock_meta):
        results = [make_strategy("s-00", fitness=69.9)]
        ranked = rank_generation(results, mock_meta)
        parents = identify_parents(ranked, mock_meta)
        assert "s-00" not in parents

    def test_returns_list(self, mock_meta):
        parents = identify_parents([], mock_meta)
        assert isinstance(parents, list)


# ---------------------------------------------------------------------------
# check_new_best()
# ---------------------------------------------------------------------------

class TestCheckNewBest:
    def test_new_best_when_exceeds_best_ever(self, mock_meta):
        """meta.best_ever is None — any score is a new best."""
        results = [make_strategy("s-00", fitness=78.0)]
        is_new, strat = check_new_best(results, mock_meta)
        assert is_new is True
        assert strat is not None
        assert strat["summary"]["strategy_id"] == "s-00"

    def test_no_new_best_when_below_existing(self):
        meta = {
            "best_ever": {"fitness_score": 90.0},
            "best_per_archetype": {"SHARPE_HUNTER": {"fitness_score": 85.0}},
        }
        results = [make_strategy("s-00", fitness=80.0, archetype="SHARPE_HUNTER")]
        is_new, strat = check_new_best(results, meta)
        assert is_new is False
        assert strat is None

    def test_new_archetype_best_detected(self):
        meta = {
            "best_ever": {"fitness_score": 90.0},
            "best_per_archetype": {
                "SHARPE_HUNTER": {"fitness_score": 70.0},
                "RETURN_CHASER": None,
            },
        }
        results = [make_strategy("s-00", fitness=75.0, archetype="SHARPE_HUNTER")]
        is_new, strat = check_new_best(results, meta)
        assert is_new is True

    def test_disqualified_excluded(self, mock_meta):
        results = [make_strategy("s-00", disqualified=True)]
        is_new, strat = check_new_best(results, mock_meta)
        assert is_new is False
        assert strat is None

    def test_empty_results(self, mock_meta):
        is_new, strat = check_new_best([], mock_meta)
        assert is_new is False
        assert strat is None

    def test_returns_tuple(self, mock_meta):
        result = check_new_best([], mock_meta)
        assert isinstance(result, tuple)
        assert len(result) == 2

    def test_best_strategy_has_highest_fitness(self, mock_meta):
        results = [
            make_strategy("s-00", fitness=60.0),
            make_strategy("s-01", fitness=85.0),
            make_strategy("s-02", fitness=75.0),
        ]
        is_new, strat = check_new_best(results, mock_meta)
        assert is_new is True
        # Best strategy should be the one with highest fitness
        assert strat["summary"]["final_composite_fitness"] == 85.0
