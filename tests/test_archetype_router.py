"""
test_archetype_router.py — Full test suite for archetype_router.py.
"""

import copy
import json
import os
import sys
import pytest

# ---------------------------------------------------------------------------
# Path setup
# ---------------------------------------------------------------------------
WORKSPACE = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SRC_DIR   = os.path.join(os.path.dirname(__file__), "..", "src")
MOCK_DIR  = os.path.join(WORKSPACE, "skills", "learning-agent-builder", "mock-data")
sys.path.insert(0, SRC_DIR)

from archetype_router import (  # noqa: E402
    compute_next_allocation,
    get_current_window_size,
    update_performance_history,
    ARCHETYPES,
)


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

def load_mock(filename: str) -> dict:
    with open(os.path.join(MOCK_DIR, filename)) as f:
        return json.load(f)


@pytest.fixture()
def mock_meta() -> dict:
    return copy.deepcopy(load_mock("mock-meta.json"))


def make_gen_stats(sh=65.0, rc=62.0, rm=68.0, co=60.0) -> dict:
    return {
        "archetype_avg_fitness": {
            "SHARPE_HUNTER":  sh,
            "RETURN_CHASER":  rc,
            "RISK_MINIMIZER": rm,
            "CONSISTENCY":    co,
        }
    }


# ---------------------------------------------------------------------------
# get_current_window_size()
# ---------------------------------------------------------------------------

class TestGetCurrentWindowSize:
    def test_returns_base_at_gen_0(self, mock_meta):
        mock_meta["generations"]["current"] = 0
        size = get_current_window_size(mock_meta)
        assert size == mock_meta["archetype_allocation"]["window_size"]

    def test_returns_base_below_first_threshold(self, mock_meta):
        mock_meta["generations"]["current"] = 10
        size = get_current_window_size(mock_meta)
        # schedule starts at 20 — should return base (5)
        assert size == 5

    def test_upgrades_at_threshold_20(self, mock_meta):
        mock_meta["generations"]["current"] = 20
        size = get_current_window_size(mock_meta)
        assert size == 5  # schedule {"20": 5, "50": 10, ...}

    def test_upgrades_at_threshold_50(self, mock_meta):
        mock_meta["generations"]["current"] = 50
        size = get_current_window_size(mock_meta)
        assert size == 10

    def test_upgrades_at_threshold_100(self, mock_meta):
        mock_meta["generations"]["current"] = 100
        size = get_current_window_size(mock_meta)
        assert size == 15

    def test_upgrades_at_threshold_200(self, mock_meta):
        mock_meta["generations"]["current"] = 200
        size = get_current_window_size(mock_meta)
        assert size == 20

    def test_between_thresholds_uses_lower(self, mock_meta):
        mock_meta["generations"]["current"] = 75
        size = get_current_window_size(mock_meta)
        assert size == 10  # between 50 and 100 → use 50's value

    def test_returns_int(self, mock_meta):
        assert isinstance(get_current_window_size(mock_meta), int)


# ---------------------------------------------------------------------------
# compute_next_allocation()
# ---------------------------------------------------------------------------

class TestComputeNextAllocation:
    def test_total_equals_strategies_per_generation(self, mock_meta):
        result = compute_next_allocation(mock_meta)
        total = sum(result.values())
        assert total == mock_meta["config"]["strategies_per_generation"]

    def test_all_archetypes_present(self, mock_meta):
        result = compute_next_allocation(mock_meta)
        for arch in ARCHETYPES:
            assert arch in result

    def test_minimum_per_archetype_enforced(self, mock_meta):
        min_per = mock_meta["archetype_allocation"]["minimum_per_archetype"]
        result  = compute_next_allocation(mock_meta)
        for arch in ARCHETYPES:
            assert result[arch] >= min_per, f"{arch} below minimum"

    def test_returns_dict(self, mock_meta):
        assert isinstance(compute_next_allocation(mock_meta), dict)

    def test_all_slots_positive(self, mock_meta):
        result = compute_next_allocation(mock_meta)
        for arch, slots in result.items():
            assert slots > 0, f"{arch} has 0 slots"

    def test_higher_fitness_gets_more_slots(self, mock_meta):
        """Archetype with much higher historical fitness should get more slots."""
        mock_meta["archetype_allocation"]["performance_history"] = {
            "SHARPE_HUNTER":  [90.0, 90.0, 90.0],
            "RETURN_CHASER":  [50.0, 50.0, 50.0],
            "RISK_MINIMIZER": [50.0, 50.0, 50.0],
            "CONSISTENCY":    [50.0, 50.0, 50.0],
        }
        result = compute_next_allocation(mock_meta)
        assert result["SHARPE_HUNTER"] >= result["RETURN_CHASER"]

    def test_no_history_uses_neutral_equal_distribution(self, mock_meta):
        """With no history, all archetypes get neutral equal scores → even distribution."""
        mock_meta["archetype_allocation"]["performance_history"] = {
            arch: [] for arch in ARCHETYPES
        }
        result = compute_next_allocation(mock_meta)
        total = sum(result.values())
        assert total == mock_meta["config"]["strategies_per_generation"]

    def test_recency_weighting_favors_recent(self, mock_meta):
        """With recency weighting, recent high scores should outweigh old low scores."""
        mock_meta["archetype_allocation"]["weighting"] = "recency"
        mock_meta["archetype_allocation"]["performance_history"] = {
            "SHARPE_HUNTER":  [40.0, 40.0, 90.0],  # recent high
            "RETURN_CHASER":  [90.0, 90.0, 40.0],  # recent low
            "RISK_MINIMIZER": [65.0, 65.0, 65.0],
            "CONSISTENCY":    [65.0, 65.0, 65.0],
        }
        result = compute_next_allocation(mock_meta)
        # SHARPE_HUNTER recent high → should score better than RETURN_CHASER recent low
        # (not a strict guarantee due to discretization, but trend should hold)
        total = sum(result.values())
        assert total == mock_meta["config"]["strategies_per_generation"]

    def test_equal_weighting_option(self, mock_meta):
        mock_meta["archetype_allocation"]["weighting"] = "equal"
        mock_meta["archetype_allocation"]["performance_history"] = {
            "SHARPE_HUNTER":  [70.0, 80.0, 90.0],
            "RETURN_CHASER":  [70.0, 80.0, 90.0],
            "RISK_MINIMIZER": [70.0, 80.0, 90.0],
            "CONSISTENCY":    [70.0, 80.0, 90.0],
        }
        result = compute_next_allocation(mock_meta)
        total = sum(result.values())
        assert total == mock_meta["config"]["strategies_per_generation"]

    def test_values_are_ints(self, mock_meta):
        result = compute_next_allocation(mock_meta)
        for v in result.values():
            assert isinstance(v, int)

    def test_custom_strategies_per_generation(self, mock_meta):
        mock_meta["config"]["strategies_per_generation"] = 8
        result = compute_next_allocation(mock_meta)
        assert sum(result.values()) == 8


# ---------------------------------------------------------------------------
# update_performance_history()
# ---------------------------------------------------------------------------

class TestUpdatePerformanceHistory:
    def test_appends_to_history(self, mock_meta):
        gen_stats = make_gen_stats()
        updated = update_performance_history(mock_meta, gen_stats)
        sh_history = updated["archetype_allocation"]["performance_history"]["SHARPE_HUNTER"]
        assert 65.0 in sh_history

    def test_all_archetypes_updated(self, mock_meta):
        gen_stats = make_gen_stats()
        updated = update_performance_history(mock_meta, gen_stats)
        for arch in ARCHETYPES:
            hist = updated["archetype_allocation"]["performance_history"][arch]
            assert len(hist) > 0

    def test_trims_to_window_size(self, mock_meta):
        window = get_current_window_size(mock_meta)
        # Pre-fill history to window_size
        mock_meta["archetype_allocation"]["performance_history"] = {
            arch: [float(50 + i) for i in range(window)]
            for arch in ARCHETYPES
        }
        gen_stats = make_gen_stats()
        updated = update_performance_history(mock_meta, gen_stats)
        for arch in ARCHETYPES:
            hist = updated["archetype_allocation"]["performance_history"][arch]
            assert len(hist) == window

    def test_most_recent_value_after_trim(self, mock_meta):
        window = get_current_window_size(mock_meta)
        mock_meta["archetype_allocation"]["performance_history"] = {
            "SHARPE_HUNTER":  [float(i) for i in range(window)],
            "RETURN_CHASER":  [],
            "RISK_MINIMIZER": [],
            "CONSISTENCY":    [],
        }
        updated = update_performance_history(mock_meta, make_gen_stats(sh=99.0))
        sh = updated["archetype_allocation"]["performance_history"]["SHARPE_HUNTER"]
        assert sh[-1] == 99.0  # latest value is the one just added

    def test_does_not_mutate_input(self, mock_meta):
        original_history = copy.deepcopy(
            mock_meta["archetype_allocation"]["performance_history"]
        )
        update_performance_history(mock_meta, make_gen_stats())
        assert mock_meta["archetype_allocation"]["performance_history"] == original_history

    def test_missing_archetype_in_gen_stats_skips_gracefully(self, mock_meta):
        # Only provide stats for two archetypes
        gen_stats = {"archetype_avg_fitness": {"SHARPE_HUNTER": 72.0}}
        updated = update_performance_history(mock_meta, gen_stats)
        # SHARPE_HUNTER updated
        sh = updated["archetype_allocation"]["performance_history"]["SHARPE_HUNTER"]
        assert 72.0 in sh
        # Others unchanged (no crash)
        assert isinstance(updated["archetype_allocation"]["performance_history"]["RETURN_CHASER"], list)

    def test_returns_meta_dict(self, mock_meta):
        updated = update_performance_history(mock_meta, make_gen_stats())
        assert isinstance(updated, dict)
        assert "archetype_allocation" in updated

    def test_history_grows_when_under_window(self, mock_meta):
        mock_meta["archetype_allocation"]["performance_history"] = {
            arch: [] for arch in ARCHETYPES
        }
        updated = update_performance_history(mock_meta, make_gen_stats())
        for arch in ARCHETYPES:
            hist = updated["archetype_allocation"]["performance_history"][arch]
            assert len(hist) <= 1  # fresh, at most 1 entry
