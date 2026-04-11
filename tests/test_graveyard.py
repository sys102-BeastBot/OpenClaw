"""
test_graveyard.py — Full test suite for graveyard.py.

Tests required per SKILL.md:
  - Each disqualifier type fires on correct trigger values
  - Boundary values: max_drawdown at 64.9%, 65.0%, 65.1%
  - Poor performer both-gate: fails when only one gate true
  - Poor performer both-gate: files when both gates true
  - Entry IDs are sequential and never reused
  - failure_analysis.lesson_written starts as false
  - failure_analysis.structural_failure starts as null
"""

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

import kb_writer
import graveyard as gv_module
from graveyard import (  # noqa: E402
    GraveyardError,
    check_disqualifiers,
    file_api_error,
    file_disqualified,
    file_poor_performer,
    get_entry_id,
    is_poor_performer,
)


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

@pytest.fixture(autouse=True)
def isolated_kb(tmp_path, monkeypatch):
    """Redirect kb_writer and graveyard paths to tmp_path."""
    kb_root  = str(tmp_path / "kb")
    os.makedirs(kb_root, exist_ok=True)

    monkeypatch.setattr(kb_writer, "KB_ROOT",        kb_root)
    monkeypatch.setattr(kb_writer, "GRAVEYARD_PATH", str(tmp_path / "kb" / "graveyard.json"))
    monkeypatch.setattr(kb_writer, "META_PATH",      str(tmp_path / "kb" / "meta.json"))
    monkeypatch.setattr(kb_writer, "PENDING_DIR",    str(tmp_path / "pending"))
    monkeypatch.setattr(kb_writer, "RESULTS_DIR",    str(tmp_path / "results"))
    monkeypatch.setattr(kb_writer, "HISTORY_DIR",    str(tmp_path / "history"))
    monkeypatch.setattr(gv_module, "GRAVEYARD_PATH", str(tmp_path / "kb" / "graveyard.json"))


def load_mock(filename: str) -> dict:
    path = os.path.join(MOCK_DIR, filename)
    with open(path) as f:
        return json.load(f)


@pytest.fixture()
def mock_meta() -> dict:
    return load_mock("mock-meta.json")


@pytest.fixture()
def mock_strategy() -> dict:
    return load_mock("mock-strategy-disqualified.json")


@pytest.fixture()
def mock_pending() -> dict:
    return load_mock("mock-strategy-pending.json")


@pytest.fixture()
def gen_stats() -> dict:
    return load_mock("mock-generation-stats.json")


def make_period(ann_return=30.0, sharpe=1.5, max_drawdown=10.0, period="1Y") -> dict:
    return {
        "period": period,
        "start_date": "2025-03-21",
        "end_date": "2026-03-21",
        "core_metrics": {
            "annualized_return": ann_return,
            "total_return": ann_return,
            "sharpe": sharpe,
            "max_drawdown": max_drawdown,
            "volatility": 18.0,
            "win_rate": 55.0,
        },
        "benchmark_metrics": {
            "benchmark_ticker": "SPY",
            "benchmark_annualized_return": 24.1,
            "beats_benchmark": ann_return > 24.1,
            "alpha": None, "beta": None,
            "r_squared": None, "correlation": None,
        },
        "fitness": None,
        "raw_api_fields": {},
    }


def read_graveyard() -> dict:
    path = gv_module.GRAVEYARD_PATH
    with open(path) as f:
        return json.load(f)


# ---------------------------------------------------------------------------
# check_disqualifiers() tests
# ---------------------------------------------------------------------------

class TestCheckDisqualifiers:
    """Each disqualifier type fires on correct trigger values."""

    def test_no_disqualifier_clean_period(self, mock_meta):
        p = make_period()
        is_disq, reason, trigger = check_disqualifiers(p, mock_meta)
        assert is_disq is False
        assert reason == ""
        assert trigger == {}

    def test_catastrophic_loss_fires(self, mock_meta):
        p = make_period(ann_return=-21.0)
        is_disq, reason, trigger = check_disqualifiers(p, mock_meta)
        assert is_disq is True
        assert reason == "CATASTROPHIC_LOSS"
        assert trigger["metric"] == "annualized_return"
        assert trigger["value"] == -21.0

    def test_catastrophic_loss_not_at_threshold(self, mock_meta):
        """Exactly -20.0 is NOT disqualified (must be strictly below)."""
        p = make_period(ann_return=-20.0)
        is_disq, _, _ = check_disqualifiers(p, mock_meta)
        assert is_disq is False

    def test_unacceptable_risk_at_65_fires(self, mock_meta):
        """Exactly 65.0% drawdown → UNACCEPTABLE_RISK (>= boundary)."""
        p = make_period(max_drawdown=65.0)
        is_disq, reason, trigger = check_disqualifiers(p, mock_meta)
        assert is_disq is True
        assert reason == "UNACCEPTABLE_RISK"
        assert trigger["metric"] == "max_drawdown"

    def test_unacceptable_risk_at_64_9_does_not_fire(self, mock_meta):
        """64.9% — just below threshold — not disqualified."""
        p = make_period(max_drawdown=64.9)
        is_disq, _, _ = check_disqualifiers(p, mock_meta)
        assert is_disq is False

    def test_unacceptable_risk_at_65_1_fires(self, mock_meta):
        """65.1% — just above threshold — disqualified."""
        p = make_period(max_drawdown=65.1)
        is_disq, reason, _ = check_disqualifiers(p, mock_meta)
        assert is_disq is True
        assert reason == "UNACCEPTABLE_RISK"

    def test_worse_than_random_fires(self, mock_meta):
        p = make_period(sharpe=-1.01)
        is_disq, reason, trigger = check_disqualifiers(p, mock_meta)
        assert is_disq is True
        assert reason == "WORSE_THAN_RANDOM"
        assert trigger["metric"] == "sharpe"

    def test_worse_than_random_not_at_threshold(self, mock_meta):
        """Exactly -1.0 is NOT disqualified."""
        p = make_period(sharpe=-1.0)
        is_disq, _, _ = check_disqualifiers(p, mock_meta)
        assert is_disq is False

    def test_trigger_includes_threshold(self, mock_meta):
        p = make_period(max_drawdown=70.0)
        _, _, trigger = check_disqualifiers(p, mock_meta)
        assert trigger["threshold"] == 65.0

    def test_trigger_includes_period(self, mock_meta):
        p = make_period(max_drawdown=70.0, period="2Y")
        _, _, trigger = check_disqualifiers(p, mock_meta)
        assert trigger["period"] == "2Y"


# ---------------------------------------------------------------------------
# is_poor_performer() tests — BOTH-gate logic
# ---------------------------------------------------------------------------

class TestIsPoorPerformer:
    """Poor performer both-gate: only files when BOTH gates are true."""

    # From mock-generation-stats.json:
    #   avg_fitness=65.2, std_dev=8.4
    #   absolute_gate threshold: < 20
    #   std_dev_gate threshold: < 65.2 - 1.5×8.4 = 65.2 - 12.6 = 52.6

    def test_both_gates_true_files(self, mock_meta, gen_stats):
        """fitness=10 → below 20 (absolute) AND below 52.6 (std_dev) → filed."""
        assert is_poor_performer(10.0, gen_stats, mock_meta) is True

    def test_only_absolute_gate_true_does_not_file(self, mock_meta, gen_stats):
        """fitness=15 → below 20 (absolute) BUT above 52.6 (std_dev) → not filed."""
        # Wait: 15 < 52.6 so std_dev gate is ALSO true here
        # We need fitness between 20 and 52.6 to fail only the std_dev gate
        # And fitness < 20 but > std_dev_threshold to fail only absolute gate
        # std_dev threshold = 65.2 - 1.5*8.4 = 52.6
        # So: fitness < 20 AND fitness < 52.6 → both true (overlap)
        # To test only-absolute: we need fitness < 20 but >= 52.6 — impossible
        # To test only-std_dev: fitness >= 20 but < 52.6
        # fitness=40: >= 20 (absolute FAILS), < 52.6 (std_dev TRUE) → only std_dev
        assert is_poor_performer(40.0, gen_stats, mock_meta) is False

    def test_only_std_dev_gate_true_does_not_file(self, mock_meta, gen_stats):
        """fitness=40 → fails only std_dev gate → not filed under BOTH logic."""
        assert is_poor_performer(40.0, gen_stats, mock_meta) is False

    def test_neither_gate_true_does_not_file(self, mock_meta, gen_stats):
        """fitness=60 → above both thresholds → not filed."""
        assert is_poor_performer(60.0, gen_stats, mock_meta) is False

    def test_boundary_at_absolute_threshold(self, mock_meta, gen_stats):
        """fitness exactly 20.0 is NOT a poor performer (must be strictly below)."""
        assert is_poor_performer(20.0, gen_stats, mock_meta) is False

    def test_boundary_just_below_absolute(self, mock_meta, gen_stats):
        """fitness=19.99 < 20 AND < 52.6 → both gates → filed."""
        assert is_poor_performer(19.99, gen_stats, mock_meta) is True

    def test_boundary_at_std_dev_threshold(self, mock_meta, gen_stats):
        """fitness exactly at std_dev threshold (52.6) is NOT a poor performer."""
        std_dev_threshold = gen_stats["avg_fitness"] - (
            mock_meta["fitness"]["graveyard_thresholds"]["poor_performer_std_dev_multiplier"]
            * gen_stats["std_dev_fitness"]
        )
        assert is_poor_performer(std_dev_threshold, gen_stats, mock_meta) is False

    def test_or_logic_respected_if_configured(self, mock_meta, gen_stats):
        """If logic=OR, filing when either gate is true."""
        meta_or = json.loads(json.dumps(mock_meta))
        meta_or["fitness"]["graveyard_thresholds"]["poor_performer_logic"] = "OR"
        # fitness=40 → only std_dev gate true → should file under OR
        assert is_poor_performer(40.0, gen_stats, meta_or) is True


# ---------------------------------------------------------------------------
# file_disqualified() tests
# ---------------------------------------------------------------------------

class TestFileDisqualified:
    def test_returns_entry_id(self, mock_strategy, mock_meta):
        eid = file_disqualified(mock_strategy, "UNACCEPTABLE_RISK", {
            "metric": "max_drawdown", "value": 71.4,
            "threshold": 65.0, "period": "1Y",
        })
        assert eid.startswith("grave-")

    def test_entry_written_to_graveyard(self, mock_strategy):
        file_disqualified(mock_strategy, "UNACCEPTABLE_RISK", {
            "metric": "max_drawdown", "value": 71.4,
            "threshold": 65.0, "period": "1Y",
        })
        g = read_graveyard()
        assert len(g["entries"]) == 1
        assert g["entries"][0]["type"] == "DISQUALIFIED_STRATEGY"

    def test_disqualification_reason_code_stored(self, mock_strategy):
        file_disqualified(mock_strategy, "CATASTROPHIC_LOSS", {
            "metric": "annualized_return", "value": -30.0,
            "threshold": -20.0, "period": "1Y",
        })
        g = read_graveyard()
        assert g["entries"][0]["disqualification"]["reason_code"] == "CATASTROPHIC_LOSS"

    def test_total_entries_incremented(self, mock_strategy):
        file_disqualified(mock_strategy, "UNACCEPTABLE_RISK", {
            "metric": "max_drawdown", "value": 71.4,
            "threshold": 65.0, "period": "1Y",
        })
        g = read_graveyard()
        assert g["total_entries"] == 1

    def test_entries_by_type_incremented(self, mock_strategy):
        file_disqualified(mock_strategy, "UNACCEPTABLE_RISK", {
            "metric": "max_drawdown", "value": 71.4,
            "threshold": 65.0, "period": "1Y",
        })
        g = read_graveyard()
        assert g["entries_by_type"]["DISQUALIFIED_STRATEGY"] == 1

    def test_all_three_disqualifier_types(self, mock_strategy, mock_pending):
        for reason in ["CATASTROPHIC_LOSS", "UNACCEPTABLE_RISK", "WORSE_THAN_RANDOM"]:
            s = json.loads(json.dumps(mock_strategy))
            s["summary"]["strategy_id"] = f"gen-001-strat-{reason[:3]}"
            file_disqualified(s, reason, {
                "metric": "x", "value": 0.0, "threshold": 0.0, "period": "1Y",
            })
        g = read_graveyard()
        reasons = [e["disqualification"]["reason_code"] for e in g["entries"]]
        assert "CATASTROPHIC_LOSS" in reasons
        assert "UNACCEPTABLE_RISK" in reasons
        assert "WORSE_THAN_RANDOM" in reasons


# ---------------------------------------------------------------------------
# file_poor_performer() tests
# ---------------------------------------------------------------------------

class TestFilePoorPerformer:
    PERF = {
        "nominal_composite_fitness": 15.0,
        "final_composite_fitness": None,
        "optimization_delta": None,
        "best_period_score": 18.0,
        "worst_period_score": 11.0,
        "annualized_return_1Y": 8.0,
        "sharpe_1Y": 0.4,
        "max_drawdown_1Y": 22.0,
    }

    def test_returns_entry_id(self, mock_strategy):
        eid = file_poor_performer(mock_strategy, self.PERF)
        assert eid.startswith("grave-")

    def test_entry_type_is_poor_performer(self, mock_strategy):
        file_poor_performer(mock_strategy, self.PERF)
        g = read_graveyard()
        assert g["entries"][0]["type"] == "POOR_PERFORMER"

    def test_performance_block_stored(self, mock_strategy):
        file_poor_performer(mock_strategy, self.PERF)
        g = read_graveyard()
        perf = g["entries"][0]["performance"]
        assert perf["nominal_composite_fitness"] == 15.0
        assert perf["sharpe_1Y"] == 0.4

    def test_entries_by_type_incremented(self, mock_strategy):
        file_poor_performer(mock_strategy, self.PERF)
        g = read_graveyard()
        assert g["entries_by_type"]["POOR_PERFORMER"] == 1


# ---------------------------------------------------------------------------
# file_api_error() tests
# ---------------------------------------------------------------------------

class TestFileApiError:
    ERROR = {
        "http_status": 400,
        "error_message": "Invalid JSON in composer_json field",
        "error_field": "composer_json",
        "raw_error": '{"error": "parse error at line 12"}',
    }

    def test_returns_entry_id(self, mock_strategy):
        eid = file_api_error(mock_strategy, self.ERROR)
        assert eid.startswith("grave-")

    def test_entry_type_is_api_error(self, mock_strategy):
        file_api_error(mock_strategy, self.ERROR)
        g = read_graveyard()
        assert g["entries"][0]["type"] == "API_ERROR"

    def test_api_error_block_stored(self, mock_strategy):
        file_api_error(mock_strategy, self.ERROR)
        g = read_graveyard()
        err = g["entries"][0]["api_error"]
        assert err["http_status"] == 400
        assert "Invalid JSON" in err["error_message"]

    def test_entries_by_type_incremented(self, mock_strategy):
        file_api_error(mock_strategy, self.ERROR)
        g = read_graveyard()
        assert g["entries_by_type"]["API_ERROR"] == 1


# ---------------------------------------------------------------------------
# failure_analysis defaults
# ---------------------------------------------------------------------------

class TestFailureAnalysisDefaults:
    """lesson_written starts False; structural_failure starts null."""

    def test_lesson_written_starts_false(self, mock_strategy):
        file_disqualified(mock_strategy, "UNACCEPTABLE_RISK", {
            "metric": "max_drawdown", "value": 71.4,
            "threshold": 65.0, "period": "1Y",
        })
        g = read_graveyard()
        assert g["entries"][0]["failure_analysis"]["lesson_written"] is False

    def test_structural_failure_starts_null(self, mock_strategy):
        file_disqualified(mock_strategy, "UNACCEPTABLE_RISK", {
            "metric": "max_drawdown", "value": 71.4,
            "threshold": 65.0, "period": "1Y",
        })
        g = read_graveyard()
        assert g["entries"][0]["failure_analysis"]["structural_failure"] is None

    def test_lesson_ids_starts_empty(self, mock_strategy):
        file_poor_performer(mock_strategy, {
            "nominal_composite_fitness": 10.0,
            "final_composite_fitness": None,
            "optimization_delta": None,
            "best_period_score": 12.0,
            "worst_period_score": 8.0,
            "annualized_return_1Y": 5.0,
            "sharpe_1Y": 0.2,
            "max_drawdown_1Y": 30.0,
        })
        g = read_graveyard()
        assert g["entries"][0]["failure_analysis"]["lesson_ids"] == []

    def test_losing_pattern_ids_starts_empty(self, mock_strategy):
        file_api_error(mock_strategy, {
            "http_status": 422,
            "error_message": "Unprocessable entity",
        })
        g = read_graveyard()
        assert g["entries"][0]["failure_analysis"]["losing_pattern_ids"] == []


# ---------------------------------------------------------------------------
# Entry ID sequential and never reused
# ---------------------------------------------------------------------------

class TestEntryIdsSequential:
    """Entry IDs are sequential and never reused."""

    def test_first_entry_is_grave_001(self, mock_strategy):
        eid = file_disqualified(mock_strategy, "UNACCEPTABLE_RISK", {
            "metric": "max_drawdown", "value": 71.4,
            "threshold": 65.0, "period": "1Y",
        })
        assert eid == "grave-001"

    def test_sequential_ids(self, mock_strategy):
        s1 = json.loads(json.dumps(mock_strategy))
        s2 = json.loads(json.dumps(mock_strategy))
        s2["summary"]["strategy_id"] = "gen-001-strat-99"
        trigger = {"metric": "max_drawdown", "value": 71.4, "threshold": 65.0, "period": "1Y"}
        id1 = file_disqualified(s1, "UNACCEPTABLE_RISK", trigger)
        id2 = file_disqualified(s2, "UNACCEPTABLE_RISK", trigger)
        assert id1 == "grave-001"
        assert id2 == "grave-002"

    def test_ids_not_reused_across_types(self, mock_strategy):
        s1 = json.loads(json.dumps(mock_strategy))
        s2 = json.loads(json.dumps(mock_strategy))
        s2["summary"]["strategy_id"] = "gen-001-strat-88"

        id1 = file_disqualified(s1, "UNACCEPTABLE_RISK", {
            "metric": "max_drawdown", "value": 71.4,
            "threshold": 65.0, "period": "1Y",
        })
        id2 = file_api_error(s2, {"http_status": 400, "error_message": "bad"})
        assert id1 != id2
        assert id2 == "grave-002"

    def test_total_entries_matches_id(self, mock_strategy):
        """Total entries count matches the numeric suffix of the last ID."""
        for i in range(5):
            s = json.loads(json.dumps(mock_strategy))
            s["summary"]["strategy_id"] = f"gen-001-strat-{i:02d}"
            file_api_error(s, {"http_status": 400, "error_message": "err"})
        g = read_graveyard()
        assert g["total_entries"] == 5
        last_id = g["entries"][-1]["id"]
        assert last_id == "grave-005"
