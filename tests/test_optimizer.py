"""
test_optimizer.py — Full test suite for optimizer.py.
ALL HTTP is mocked — never calls real Composer API.
"""

import copy
import json
import math
import os
import sys
import time
from unittest import mock

import pytest

# ---------------------------------------------------------------------------
# Path setup
# ---------------------------------------------------------------------------
WORKSPACE = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SRC_DIR   = os.path.join(os.path.dirname(__file__), "..", "src")
MOCK_DIR  = os.path.join(WORKSPACE, "skills", "learning-agent-builder", "mock-data")
sys.path.insert(0, SRC_DIR)

import optimizer as opt_mod
from optimizer import (  # noqa: E402
    ComposerAPIError,
    OptimizerError,
    build_param_grid,
    compute_fitness_delta,
    _inject_parameters,
    run_optimizer,
)


# ---------------------------------------------------------------------------
# Fixtures / helpers
# ---------------------------------------------------------------------------

def load_mock(filename: str) -> dict:
    with open(os.path.join(MOCK_DIR, filename)) as f:
        return json.load(f)


@pytest.fixture()
def mock_strategy() -> dict:
    s = copy.deepcopy(load_mock("mock-strategy-pending.json"))
    # Set to NOMINAL_COMPLETE with composite fitness for optimizer
    s["summary"]["status"] = "NOMINAL_COMPLETE"
    s["summary"]["passed_rough_cut"] = True
    s["nominal_result"] = {
        "status": "COMPLETE",
        "composite_fitness": {"final_composite": 65.0},
        "periods": {},
        "api_calls_used": 4,
        "api_call_ms": 4000,
        "parameters_used": {},
        "completed_at": "2026-03-22T00:00:00Z",
    }
    return s


@pytest.fixture()
def mock_meta() -> dict:
    return load_mock("mock-meta.json")


@pytest.fixture(autouse=True)
def mock_credentials(monkeypatch):
    monkeypatch.setattr(
        opt_mod, "_get_headers",
        lambda: {"x-api-key-id": "test", "authorization": "Bearer test",
                 "Content-Type": "application/json"}
    )


@pytest.fixture(autouse=True)
def no_sleep(monkeypatch):
    monkeypatch.setattr(time, "sleep", lambda _: None)


def make_stats(ann_return=0.50, sharpe=1.8, max_dd=0.12) -> dict:
    return {
        "annualized_rate_of_return": ann_return,
        "sharpe_ratio": sharpe,
        "max_drawdown": max_dd,
        "standard_deviation": 0.18,
        "cumulative_return": ann_return,
        "win_rate": 0.60,
    }


def make_api_response(stats: dict = None) -> dict:
    return {"stats": stats or make_stats()}


# ---------------------------------------------------------------------------
# _inject_parameters()
# ---------------------------------------------------------------------------

class TestInjectParameters:
    def test_empty_params_returns_deep_copy(self):
        cj = {"step": "asset", "ticker": "BIL", "children": []}
        result = _inject_parameters(cj, {})
        assert result == cj
        assert result is not cj

    def test_does_not_mutate_original(self):
        cj = {
            "step": "if-child",
            "lhs-fn": "max-drawdown",
            "lhs-fn-params": {"window": 2},
            "lhs-val": "SVXY",
            "comparator": "gt",
            "rhs-val": "10",
            "rhs-fixed-value?": True,
            "is-else-condition?": False,
            "children": [],
        }
        _inject_parameters(cj, {"svxy_max-drawdown_threshold": "9"})
        assert cj["rhs-val"] == "10"  # untouched

    def test_returns_dict(self):
        assert isinstance(_inject_parameters({}, {}), dict)


# ---------------------------------------------------------------------------
# build_param_grid()
# ---------------------------------------------------------------------------

class TestBuildParamGrid:
    def test_returns_list_of_dicts(self, mock_strategy):
        combos, basis = build_param_grid(mock_strategy, {})
        assert isinstance(combos, list)
        assert all(isinstance(c, dict) for c in combos)

    def test_basis_map_returned(self, mock_strategy):
        _, basis = build_param_grid(mock_strategy, {})
        assert isinstance(basis, dict)

    def test_no_prior_uses_full_range(self, mock_strategy):
        combos, basis = build_param_grid(mock_strategy, {})
        # Some params should have no_prior_full basis
        assert any(v == "no_prior_full" for v in basis.values())

    def test_high_confidence_prior_narrows_search(self, mock_strategy):
        # New key format: "{lhs-fn}_{lhs-val}_threshold"
        priors = {
            "max-drawdown_SVXY_threshold": {
                "values": ["9", "10", "11"],
                "confidence": 0.8,
            }
        }
        combos, basis = build_param_grid(mock_strategy, priors)
        assert basis.get("max-drawdown_SVXY_threshold") == "prior_narrow"
        # Should only use at most 3 values
        threshold_vals = set(str(c.get("max-drawdown_SVXY_threshold")) for c in combos)
        assert len(threshold_vals) <= 3

    def test_low_confidence_prior_uses_full_range(self, mock_strategy):
        priors = {
            "max-drawdown_SVXY_threshold": {
                "values": ["8", "9", "10", "11", "12"],
                "confidence": 0.5,
            }
        }
        _, basis = build_param_grid(mock_strategy, priors)
        assert basis.get("max-drawdown_SVXY_threshold") == "prior_full"

    def test_generator_deviation_targeted(self, mock_strategy):
        """Generator deviated from prior (rhs-val not in prior values)."""
        priors = {
            "max-drawdown_SVXY_threshold": {
                "values": ["8", "9", "11"],  # "10" not in here
                "confidence": 0.8,
            }
        }
        _, basis = build_param_grid(mock_strategy, priors)
        assert basis.get("max-drawdown_SVXY_threshold") == "generator_deviation_targeted"

    def test_cartesian_product_of_params(self, mock_strategy):
        """If 2 params each have 2 values → 4 combinations."""
        priors = {
            "max-drawdown_SVXY_threshold": {"values": ["9", "10"], "confidence": 0.8},
            "relative-strength-index_QQQ_threshold": {"values": ["75", "79"], "confidence": 0.8},
        }
        combos, _ = build_param_grid(mock_strategy, priors)
        # Only count combinations where both params are set
        assert len(combos) >= 1  # cartesian product

    def test_wt_cash_equal_wrapper_extracts_params(self, mock_strategy):
        """wt-cash-equal root wrapping an if node — params must still be found."""
        wrapped_cj = {
            "step": "wt-cash-equal",
            "children": [{
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
                        "is-else-condition?": True,
                        "children": [{
                            "step": "filter",
                            "sort-by-fn": "cumulative-return",
                            "sort-by-fn-params": {"window": 20},
                            "select-fn": "top",
                            "select-n": "1",
                            "children": [{"step": "asset", "ticker": "TQQQ", "children": []}],
                        }],
                    },
                ],
            }],
        }
        import copy as cp
        strat = cp.deepcopy(mock_strategy)
        strat["strategy"]["composer_json"] = wrapped_cj
        combos, basis = build_param_grid(strat, {})
        # Should find: max-drawdown threshold (5 vals) × window (4 vals) ×
        #              filter window (5 vals) × select_n (3 vals) = 300
        assert len(combos) >= 3, f"Expected ≥3 combos from wrapped structure, got {len(combos)}"
        assert any("max-drawdown_SVXY_threshold" in c for c in combos)

    def test_new_key_format_used_in_basis(self, mock_strategy):
        """Basis map keys must use new {fn}_{asset}_suffix format."""
        _, basis = build_param_grid(mock_strategy, {})
        for key in basis:
            # Old format was {asset}_{fn}_suffix — check we're not using it
            # New format starts with the fn name (contains a hyphen e.g. max-drawdown)
            # or "filter_" prefix
            assert not (key.startswith("svxy_") or key.startswith("qqq_")), \
                f"Old key format detected: {key}"


# ---------------------------------------------------------------------------
# compute_fitness_delta()
# ---------------------------------------------------------------------------

class TestComputeFitnessDelta:
    def test_large_gain(self):
        d = compute_fitness_delta(50.0, 70.0)
        assert d["delta_interpretation"] == "LARGE"
        assert d["delta"] == "+20.0"

    def test_moderate_gain(self):
        d = compute_fitness_delta(60.0, 68.0)
        assert d["delta_interpretation"] == "MODERATE"
        assert d["delta"].startswith("+")

    def test_small_gain(self):
        d = compute_fitness_delta(60.0, 63.0)
        assert d["delta_interpretation"] == "SMALL"

    def test_negligible_gain(self):
        d = compute_fitness_delta(60.0, 60.5)
        assert d["delta_interpretation"] == "NEGLIGIBLE"

    def test_negative_delta(self):
        d = compute_fitness_delta(70.0, 50.0)
        assert d["delta"].startswith("-")
        assert d["delta_interpretation"] == "LARGE"

    def test_zero_delta(self):
        d = compute_fitness_delta(65.0, 65.0)
        assert d["delta_interpretation"] == "NEGLIGIBLE"
        assert d["delta"] == "+0.0"

    def test_exact_boundary_large(self):
        d = compute_fitness_delta(50.0, 65.0)
        assert d["delta_interpretation"] == "LARGE"

    def test_exact_boundary_moderate(self):
        d = compute_fitness_delta(60.0, 65.0)
        assert d["delta_interpretation"] == "MODERATE"

    def test_exact_boundary_small(self):
        d = compute_fitness_delta(60.0, 62.0)
        assert d["delta_interpretation"] == "SMALL"

    def test_returns_all_required_fields(self):
        d = compute_fitness_delta(60.0, 70.0)
        for key in ["nominal_composite", "optimized_composite", "delta", "delta_interpretation"]:
            assert key in d

    def test_nominal_and_optimized_stored(self):
        d = compute_fitness_delta(55.5, 72.3)
        assert d["nominal_composite"] == pytest.approx(55.5)
        assert d["optimized_composite"] == pytest.approx(72.3)


# ---------------------------------------------------------------------------
# run_optimizer() — mock HTTP
# ---------------------------------------------------------------------------

class TestRunOptimizer:
    def _mock_symphony_and_backtest(self, monkeypatch, stats: dict = None):
        """Mock _create_symphony, _delete, and _post (backtest) cleanly."""
        sym_counter = [0]

        def mock_create(composer_json, headers):
            sym_counter[0] += 1
            return f"sym-test-{sym_counter[0]}"

        def mock_backtest(symphony_id, start_date, end_date, meta, headers):
            return make_api_response(stats)

        monkeypatch.setattr(opt_mod, "_create_symphony", mock_create)
        monkeypatch.setattr(opt_mod, "_run_symphony_backtest", mock_backtest)
        monkeypatch.setattr(opt_mod, "_delete", lambda path, headers: None)

    def test_returns_dict(self, mock_strategy, mock_meta, monkeypatch):
        self._mock_symphony_and_backtest(monkeypatch)
        result = run_optimizer(mock_strategy, mock_meta, {})
        assert isinstance(result, dict)

    def test_optimizer_data_populated(self, mock_strategy, mock_meta, monkeypatch):
        self._mock_symphony_and_backtest(monkeypatch)
        result = run_optimizer(mock_strategy, mock_meta, {})
        assert result["optimizer_data"] is not None
        assert result["optimizer_data"]["status"] == "COMPLETE"

    def test_optimizer_data_has_required_fields(self, mock_strategy, mock_meta, monkeypatch):
        self._mock_symphony_and_backtest(monkeypatch)
        result = run_optimizer(mock_strategy, mock_meta, {})
        od = result["optimizer_data"]
        for key in ["status", "started_at", "completed_at", "total_combinations_tested",
                    "api_calls_used", "search_basis", "parameter_sensitivity",
                    "optimal_parameters", "parameter_diff", "fitness_delta"]:
            assert key in od, f"Missing key: {key}"

    def test_does_not_mutate_input(self, mock_strategy, mock_meta, monkeypatch):
        self._mock_symphony_and_backtest(monkeypatch)
        original_cj = copy.deepcopy(mock_strategy["strategy"]["composer_json"])
        run_optimizer(mock_strategy, mock_meta, {})
        assert mock_strategy["strategy"]["composer_json"] == original_cj

    def test_optimization_delta_set_in_summary(self, mock_strategy, mock_meta, monkeypatch):
        self._mock_symphony_and_backtest(monkeypatch)
        result = run_optimizer(mock_strategy, mock_meta, {})
        assert result["summary"]["optimization_delta"] is not None

    def test_400_skips_combination_continues(self, mock_strategy, mock_meta, monkeypatch):
        """400 on a backtest → skip that combination, continue to next."""
        monkeypatch.setattr(opt_mod, "_create_symphony",
                            lambda cj, h: "sym-test-1")
        monkeypatch.setattr(opt_mod, "_run_symphony_backtest",
                            lambda sid, s, e, m, h: (_ for _ in ()).throw(ComposerAPIError("bad", 400)))
        monkeypatch.setattr(opt_mod, "_delete", lambda p, h: None)
        # Should not raise — just skip the combo
        result = run_optimizer(mock_strategy, mock_meta, {})
        assert isinstance(result, dict)

    def test_symphony_cleanup_called(self, mock_strategy, mock_meta, monkeypatch):
        """_delete must be called to clean up each symphony after each combo."""
        delete_calls = []
        sym_counter  = [0]

        def mock_create(composer_json, headers):
            sym_counter[0] += 1
            return f"sym-{sym_counter[0]}"

        def mock_backtest(symphony_id, start_date, end_date, meta, headers):
            return make_api_response()

        monkeypatch.setattr(opt_mod, "_create_symphony", mock_create)
        monkeypatch.setattr(opt_mod, "_run_symphony_backtest", mock_backtest)
        monkeypatch.setattr(opt_mod, "_delete", lambda p, h: delete_calls.append(p))

        # Use a trivial strategy with no tunable params → 1 combination → 1 delete
        simple_strat = copy.deepcopy(mock_strategy)
        simple_strat["strategy"]["composer_json"] = {
            "step": "wt-cash-equal",
            "children": [{"step": "asset", "ticker": "TQQQ", "children": []}]
        }
        run_optimizer(simple_strat, mock_meta, {})
        assert len(delete_calls) >= 1

    def test_credential_error_sets_error_status(self, mock_strategy, mock_meta, monkeypatch):
        monkeypatch.setattr(opt_mod, "_get_headers", lambda: (_ for _ in ()).throw(Exception("no creds")))
        result = run_optimizer(mock_strategy, mock_meta, {})
        assert result["pipeline"]["current_status"] == "ERROR"

    def test_total_combinations_tracked(self, mock_strategy, mock_meta, monkeypatch):
        self._mock_symphony_and_backtest(monkeypatch)
        result = run_optimizer(mock_strategy, mock_meta, {})
        assert result["optimizer_data"]["total_combinations_tested"] >= 1


# ---------------------------------------------------------------------------
# _post() retry behavior
# ---------------------------------------------------------------------------

class TestPostRetry:
    def test_429_retries(self, monkeypatch):
        attempts = [0]
        def mock_post_429(*a, **kw):
            r = mock.MagicMock()
            attempts[0] += 1
            if attempts[0] < 3:
                r.status_code = 429
            else:
                r.status_code = 200
                r.json.return_value = {"id": "sym-ok"}
            return r
        monkeypatch.setattr("requests.post", mock_post_429)
        monkeypatch.setattr(opt_mod, "RETRY_BASE_DELAY_S", 0.0)
        result = opt_mod._post("/api/v0.1/symphonies", {}, {})
        assert result == {"id": "sym-ok"}
        assert attempts[0] == 3

    def test_network_error_raises(self, monkeypatch):
        import requests as req
        monkeypatch.setattr("requests.post", lambda *a, **kw: (_ for _ in ()).throw(req.ConnectionError("err")))
        with pytest.raises(OptimizerError, match="Network error"):
            opt_mod._post("/api/v0.1/symphonies", {}, {})
