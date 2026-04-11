"""
test_backtest_runner.py — Full test suite for backtest_runner.py.

ALL HTTP CALLS ARE MOCKED — never calls the real Composer API.
Uses @patch decorators to mock _create_temp_symphony, _delete_symphony,
and _post cleanly, decoupled from internal implementation details.
"""

import copy
import json
import os
import sys
import time
from datetime import date, timedelta
from unittest.mock import patch, MagicMock

import pytest

# ---------------------------------------------------------------------------
# Path setup
# ---------------------------------------------------------------------------
WORKSPACE = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SRC_DIR   = os.path.join(os.path.dirname(__file__), "..", "src")
MOCK_DIR  = os.path.join(WORKSPACE, "skills", "learning-agent-builder", "mock-data")
sys.path.insert(0, SRC_DIR)

import backtest_runner as br
from backtest_runner import (  # noqa: E402
    BacktestRunnerError,
    ComposerAPIError,
    _get_period_dates,
    _inject_parameters,
    _parse_period_stats,
    run_nominal_backtest,
    run_validation_backtest,
)


# ---------------------------------------------------------------------------
# Mock API response fixtures
# ---------------------------------------------------------------------------

def _make_raw_stats(
    ann_return: float = 0.637,
    cumulative: float = 0.637,
    sharpe: float     = 2.28,
    max_dd: float     = 0.094,
    std_dev: float    = 0.184,
    win_rate: float   = 0.631,
    bench_ann: float  = 0.241,
    alpha: float      = 0.41,
    beta: float       = 0.72,
    r_square: float   = 0.68,
    pearson_r: float  = 0.82,
) -> dict:
    """Build a mock Composer API stats object matching the real API format."""
    return {
        "annualized_rate_of_return": ann_return,
        "cumulative_return":         cumulative,
        "sharpe_ratio":              sharpe,
        "max_drawdown":              max_dd,
        "standard_deviation":        std_dev,
        "win_rate":                  win_rate,
        "sortino_ratio":             3.1,
        "calmar_ratio":              6.8,
        "annualized_turnover":       12.4,
        "tail_ratio":                1.2,
        "herfindahl_index":          0.5,
        "trailing_one_month_return": 0.05,
        "trailing_three_month_return": 0.12,
        "benchmarks": {
            "SPY": {
                "annualized_rate_of_return": bench_ann,
                "sharpe_ratio": 1.2,
                "max_drawdown": 0.15,
                "standard_deviation": 0.18,
                "percent": {
                    "alpha":     alpha,
                    "beta":      beta,
                    "r_square":  r_square,
                    "pearson_r": pearson_r,
                }
            }
        }
    }


def _make_api_response(stats: dict = None) -> dict:
    return {"stats": stats or _make_raw_stats()}


def _make_mock_response(status_code: int = 200, json_data: dict = None, text: str = "") -> MagicMock:
    resp = MagicMock()
    resp.status_code = status_code
    resp.json.return_value = json_data or _make_api_response()
    resp.text = text
    return resp


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

def load_mock(filename: str) -> dict:
    with open(os.path.join(MOCK_DIR, filename)) as f:
        return json.load(f)


@pytest.fixture()
def mock_strategy() -> dict:
    return copy.deepcopy(load_mock("mock-strategy-pending.json"))


@pytest.fixture()
def mock_meta() -> dict:
    return load_mock("mock-meta.json")


@pytest.fixture(autouse=True)
def no_sleep(monkeypatch):
    """Suppress time.sleep in all tests."""
    monkeypatch.setattr(br, "RATE_LIMIT_SLEEP_S", 0.0)
    monkeypatch.setattr(time, "sleep", lambda _: None)


@pytest.fixture(autouse=True)
def mock_credentials(monkeypatch):
    """Suppress real credential loading in all tests."""
    monkeypatch.setattr(
        br, "_get_headers",
        lambda: {"x-api-key-id": "test-id", "authorization": "Bearer test-secret",
                 "Content-Type": "application/json"}
    )


# ---------------------------------------------------------------------------
# _get_period_dates()
# ---------------------------------------------------------------------------

class TestGetPeriodDates:
    def test_end_date_is_today(self):
        today = date.today().isoformat()
        _, end = _get_period_dates("1Y")
        assert end == today

    def test_6m_start_date(self):
        start, _ = _get_period_dates("6M")
        assert start == (date.today() - timedelta(days=183)).isoformat()

    def test_1y_start_date(self):
        start, _ = _get_period_dates("1Y")
        assert start == (date.today() - timedelta(days=365)).isoformat()

    def test_2y_start_date(self):
        start, _ = _get_period_dates("2Y")
        assert start == (date.today() - timedelta(days=730)).isoformat()

    def test_3y_start_date(self):
        start, _ = _get_period_dates("3Y")
        assert start == (date.today() - timedelta(days=1095)).isoformat()

    def test_unknown_period_raises(self):
        with pytest.raises(BacktestRunnerError, match="Unknown period"):
            _get_period_dates("5Y")

    def test_returns_iso_strings(self):
        start, end = _get_period_dates("2Y")
        assert len(start) == 10 and start[4] == "-"
        assert len(end) == 10   and end[4]   == "-"


# ---------------------------------------------------------------------------
# _parse_period_stats()
# ---------------------------------------------------------------------------

class TestParsePeriodStats:
    def test_annualized_return_scaled(self):
        result = _parse_period_stats(_make_raw_stats(ann_return=0.637), "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["core_metrics"]["annualized_return"] == pytest.approx(63.7)

    def test_total_return_scaled(self):
        result = _parse_period_stats(_make_raw_stats(cumulative=0.50), "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["core_metrics"]["total_return"] == pytest.approx(50.0)

    def test_sharpe_not_scaled(self):
        result = _parse_period_stats(_make_raw_stats(sharpe=2.28), "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["core_metrics"]["sharpe"] == pytest.approx(2.28)

    def test_max_drawdown_scaled(self):
        result = _parse_period_stats(_make_raw_stats(max_dd=0.094), "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["core_metrics"]["max_drawdown"] == pytest.approx(9.4)

    def test_volatility_scaled(self):
        result = _parse_period_stats(_make_raw_stats(std_dev=0.184), "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["core_metrics"]["volatility"] == pytest.approx(18.4)

    def test_win_rate_scaled(self):
        result = _parse_period_stats(_make_raw_stats(win_rate=0.631), "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["core_metrics"]["win_rate"] == pytest.approx(63.1)

    def test_benchmark_return_scaled(self):
        result = _parse_period_stats(_make_raw_stats(bench_ann=0.241), "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["benchmark_metrics"]["benchmark_annualized_return"] == pytest.approx(24.1)

    def test_beats_benchmark_true(self):
        result = _parse_period_stats(_make_raw_stats(ann_return=0.637, bench_ann=0.241), "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["benchmark_metrics"]["beats_benchmark"] is True

    def test_beats_benchmark_false(self):
        result = _parse_period_stats(_make_raw_stats(ann_return=0.10, bench_ann=0.241), "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["benchmark_metrics"]["beats_benchmark"] is False

    def test_alpha_field(self):
        result = _parse_period_stats(_make_raw_stats(alpha=0.41), "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["benchmark_metrics"]["alpha"] == pytest.approx(0.41)

    def test_beta_field(self):
        result = _parse_period_stats(_make_raw_stats(beta=0.72), "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["benchmark_metrics"]["beta"] == pytest.approx(0.72)

    def test_r_squared_from_r_square(self):
        """API field is r_square (no d) → mapped to r_squared."""
        result = _parse_period_stats(_make_raw_stats(r_square=0.68), "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["benchmark_metrics"]["r_squared"] == pytest.approx(0.68)

    def test_correlation_from_pearson_r(self):
        result = _parse_period_stats(_make_raw_stats(pearson_r=0.82), "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["benchmark_metrics"]["correlation"] == pytest.approx(0.82)

    def test_raw_api_fields_preserved_unscaled(self):
        result = _parse_period_stats(_make_raw_stats(ann_return=0.637), "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["raw_api_fields"]["annualized_rate_of_return"] == pytest.approx(0.637)

    def test_fitness_starts_none(self):
        result = _parse_period_stats(_make_raw_stats(), "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["fitness"] is None

    def test_period_and_dates_stored(self):
        result = _parse_period_stats(_make_raw_stats(), "SPY", "2Y", "2024-03-21", "2026-03-21")
        assert result["period"] == "2Y"
        assert result["start_date"] == "2024-03-21"
        assert result["end_date"] == "2026-03-21"

    def test_missing_fields_return_none(self):
        result = _parse_period_stats({}, "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["core_metrics"]["annualized_return"] is None
        assert result["core_metrics"]["sharpe"] is None

    def test_missing_benchmark_returns_none(self):
        result = _parse_period_stats({}, "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["benchmark_metrics"]["alpha"] is None
        assert result["benchmark_metrics"]["beats_benchmark"] is None

    def test_trailing_returns_scaled(self):
        stats = _make_raw_stats()
        stats["trailing_one_month_return"]   = 0.05
        stats["trailing_three_month_return"] = 0.12
        result = _parse_period_stats(stats, "SPY", "1Y", "2025-03-21", "2026-03-21")
        assert result["raw_api_fields"]["trailing_1m_return"] == pytest.approx(5.0)
        assert result["raw_api_fields"]["trailing_3m_return"] == pytest.approx(12.0)


# ---------------------------------------------------------------------------
# _inject_parameters()
# ---------------------------------------------------------------------------

class TestInjectParameters:
    def test_empty_params_returns_deep_copy(self):
        cj = {"step": "asset", "ticker": "TQQQ", "children": []}
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
        _inject_parameters(cj, {"max-drawdown_SVXY_threshold": "9"})
        assert cj["rhs-val"] == "10"  # not mutated

    def test_returns_dict(self):
        assert isinstance(_inject_parameters({}, {}), dict)


# ---------------------------------------------------------------------------
# run_nominal_backtest() — clean @patch mocking
# ---------------------------------------------------------------------------

class TestRunNominalBacktest:
    """Tests use @patch to mock _create_temp_symphony, _delete_symphony, _post
    directly. Decoupled from the internal create-backtest-delete flow."""

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_returns_dict(self, mock_post, mock_create, mock_delete,
                          mock_strategy, mock_meta):
        mock_create.return_value = "fake-sym-id"
        mock_post.return_value   = _make_api_response()
        mock_delete.return_value = None
        result = run_nominal_backtest(mock_strategy, ["1Y"], mock_meta)
        assert isinstance(result, dict)

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_nominal_result_populated(self, mock_post, mock_create, mock_delete,
                                      mock_strategy, mock_meta):
        mock_create.return_value = "fake-sym-id"
        mock_post.return_value   = _make_api_response()
        mock_delete.return_value = None
        result = run_nominal_backtest(mock_strategy, ["1Y"], mock_meta)
        assert result["nominal_result"] is not None
        assert "periods" in result["nominal_result"]

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_all_periods_returned(self, mock_post, mock_create, mock_delete,
                                  mock_strategy, mock_meta):
        mock_create.return_value = "fake-sym-id"
        mock_post.return_value   = _make_api_response()
        mock_delete.return_value = None
        result = run_nominal_backtest(mock_strategy, ["6M", "1Y", "2Y", "3Y"], mock_meta)
        for p in ["6M", "1Y", "2Y", "3Y"]:
            assert p in result["nominal_result"]["periods"]

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_pipeline_status_nominal_complete(self, mock_post, mock_create, mock_delete,
                                              mock_strategy, mock_meta):
        mock_create.return_value = "fake-sym-id"
        mock_post.return_value   = _make_api_response()
        mock_delete.return_value = None
        result = run_nominal_backtest(mock_strategy, ["1Y"], mock_meta)
        assert result["pipeline"]["current_status"] == "NOMINAL_COMPLETE"
        assert result["summary"]["status"] == "NOMINAL_COMPLETE"

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_api_call_count_tracked(self, mock_post, mock_create, mock_delete,
                                    mock_strategy, mock_meta):
        mock_create.return_value = "fake-sym-id"
        mock_post.return_value   = _make_api_response()
        mock_delete.return_value = None
        result = run_nominal_backtest(mock_strategy, ["1Y", "2Y"], mock_meta)
        assert result["nominal_result"]["api_calls_used"] == 2

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_period_data_has_core_metrics(self, mock_post, mock_create, mock_delete,
                                          mock_strategy, mock_meta):
        mock_create.return_value = "fake-sym-id"
        mock_post.return_value   = _make_api_response()
        mock_delete.return_value = None
        result = run_nominal_backtest(mock_strategy, ["1Y"], mock_meta)
        p1y = result["nominal_result"]["periods"]["1Y"]
        assert "core_metrics" in p1y
        assert p1y["core_metrics"]["annualized_return"] is not None

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_composite_fitness_starts_none(self, mock_post, mock_create, mock_delete,
                                           mock_strategy, mock_meta):
        mock_create.return_value = "fake-sym-id"
        mock_post.return_value   = _make_api_response()
        mock_delete.return_value = None
        result = run_nominal_backtest(mock_strategy, ["1Y"], mock_meta)
        assert result["nominal_result"]["composite_fitness"] is None

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_does_not_mutate_input(self, mock_post, mock_create, mock_delete,
                                   mock_strategy, mock_meta):
        mock_create.return_value = "fake-sym-id"
        mock_post.return_value   = _make_api_response()
        mock_delete.return_value = None
        original_status = mock_strategy["summary"]["status"]
        run_nominal_backtest(mock_strategy, ["1Y"], mock_meta)
        assert mock_strategy["summary"]["status"] == original_status

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_400_causes_disqualification(self, mock_post, mock_create, mock_delete,
                                         mock_strategy, mock_meta):
        """400 → DISQUALIFIED with reason INVALID_JSON."""
        mock_create.return_value = "fake-sym-id"
        mock_delete.return_value = None
        mock_post.side_effect = ComposerAPIError("bad request", status_code=400, body="bad json")
        result = run_nominal_backtest(mock_strategy, ["1Y"], mock_meta)
        assert result["summary"]["disqualified"] is True
        assert result["pipeline"]["disqualification_reason"] == "INVALID_JSON"
        assert result["pipeline"]["current_status"] == "DISQUALIFIED"

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_422_causes_disqualification(self, mock_post, mock_create, mock_delete,
                                         mock_strategy, mock_meta):
        """422 → DISQUALIFIED with reason INVALID_JSON."""
        mock_create.return_value = "fake-sym-id"
        mock_delete.return_value = None
        mock_post.side_effect = ComposerAPIError("unprocessable", status_code=422)
        result = run_nominal_backtest(mock_strategy, ["1Y"], mock_meta)
        assert result["summary"]["disqualified"] is True
        assert result["pipeline"]["disqualification_reason"] == "INVALID_JSON"

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_other_error_sets_error_status(self, mock_post, mock_create, mock_delete,
                                           mock_strategy, mock_meta):
        mock_create.return_value = "fake-sym-id"
        mock_delete.return_value = None
        mock_post.side_effect = ComposerAPIError("server error", status_code=500)
        result = run_nominal_backtest(mock_strategy, ["1Y"], mock_meta)
        assert result["pipeline"]["current_status"] == "ERROR"
        assert not result["summary"].get("disqualified", False)


# ---------------------------------------------------------------------------
# run_validation_backtest() — clean @patch mocking
# ---------------------------------------------------------------------------

class TestRunValidationBacktest:

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_final_result_populated(self, mock_post, mock_create, mock_delete,
                                    mock_strategy, mock_meta):
        mock_create.return_value = "fake-sym-id"
        mock_post.return_value   = _make_api_response()
        mock_delete.return_value = None
        result = run_validation_backtest(mock_strategy, {}, ["1Y"], mock_meta)
        assert result["final_result"] is not None
        assert "periods" in result["final_result"]

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_pipeline_status_validating(self, mock_post, mock_create, mock_delete,
                                        mock_strategy, mock_meta):
        mock_create.return_value = "fake-sym-id"
        mock_post.return_value   = _make_api_response()
        mock_delete.return_value = None
        result = run_validation_backtest(mock_strategy, {}, ["1Y"], mock_meta)
        assert result["pipeline"]["current_status"] == "VALIDATING"

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_optimal_params_stored(self, mock_post, mock_create, mock_delete,
                                   mock_strategy, mock_meta):
        mock_create.return_value = "fake-sym-id"
        mock_post.return_value   = _make_api_response()
        mock_delete.return_value = None
        params = {"max-drawdown_SVXY_threshold": "9", "filter_cumulative-return_window": "15"}
        result = run_validation_backtest(mock_strategy, params, ["1Y"], mock_meta)
        assert result["final_result"]["parameters_used"] == params

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_400_causes_disqualification(self, mock_post, mock_create, mock_delete,
                                         mock_strategy, mock_meta):
        mock_create.return_value = "fake-sym-id"
        mock_delete.return_value = None
        mock_post.side_effect = ComposerAPIError("bad", status_code=400)
        result = run_validation_backtest(mock_strategy, {}, ["1Y"], mock_meta)
        assert result["summary"]["disqualified"] is True

    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_does_not_mutate_original_composer_json(self, mock_post, mock_create, mock_delete,
                                                    mock_strategy, mock_meta):
        """Injected params must not mutate the original strategy."""
        mock_create.return_value = "fake-sym-id"
        mock_post.return_value   = _make_api_response()
        mock_delete.return_value = None
        original_cj = copy.deepcopy(mock_strategy["strategy"]["composer_json"])
        run_validation_backtest(mock_strategy, {"max-drawdown_SVXY_threshold": "9"}, ["1Y"], mock_meta)
        assert mock_strategy["strategy"]["composer_json"] == original_cj


# ---------------------------------------------------------------------------
# _post() — allowlist, retry, and error handling
# ---------------------------------------------------------------------------

class TestPostAllowlist:
    def test_disallowed_path_raises(self):
        with pytest.raises(BacktestRunnerError, match="allowlist"):
            br._post("/api/v0.1/secrets", {}, {})

    def test_allowed_backtest_path(self, monkeypatch):
        monkeypatch.setattr("requests.post", lambda *a, **kw: _make_mock_response(200))
        result = br._post("/api/v0.1/backtest", {}, {})
        assert "stats" in result

    def test_symphony_sub_path_allowed(self, monkeypatch):
        monkeypatch.setattr("requests.post", lambda *a, **kw: _make_mock_response(200))
        result = br._post("/api/v0.1/symphonies/abc123/backtest", {}, {})
        assert result is not None

    def test_400_raises_composer_api_error(self, monkeypatch):
        monkeypatch.setattr("requests.post", lambda *a, **kw: _make_mock_response(400, text="bad json"))
        with pytest.raises(ComposerAPIError) as exc_info:
            br._post("/api/v0.1/backtest", {}, {})
        assert exc_info.value.status_code == 400

    def test_422_raises_composer_api_error(self, monkeypatch):
        monkeypatch.setattr("requests.post", lambda *a, **kw: _make_mock_response(422))
        with pytest.raises(ComposerAPIError) as exc_info:
            br._post("/api/v0.1/backtest", {}, {})
        assert exc_info.value.status_code == 422

    def test_429_retries_then_raises(self, monkeypatch):
        """429 → retries MAX_RETRIES times then raises."""
        call_count = [0]
        def mock_post_429(*a, **kw):
            call_count[0] += 1
            return _make_mock_response(429)
        monkeypatch.setattr("requests.post", mock_post_429)
        monkeypatch.setattr(br, "MAX_RETRIES", 2)
        monkeypatch.setattr(br, "RETRY_BASE_DELAY_S", 0.0)
        with pytest.raises(ComposerAPIError) as exc_info:
            br._post("/api/v0.1/backtest", {}, {})
        assert exc_info.value.status_code == 429
        assert call_count[0] == 3  # 1 initial + 2 retries

    def test_429_succeeds_on_retry(self, monkeypatch):
        """429 first call, 200 on second → success."""
        attempts = [0]
        def mock_post_retry(*a, **kw):
            attempts[0] += 1
            return _make_mock_response(429) if attempts[0] == 1 else _make_mock_response(200)
        monkeypatch.setattr("requests.post", mock_post_retry)
        monkeypatch.setattr(br, "RETRY_BASE_DELAY_S", 0.0)
        result = br._post("/api/v0.1/backtest", {}, {})
        assert "stats" in result
        assert attempts[0] == 2

    def test_network_error_raises_backtest_runner_error(self, monkeypatch):
        import requests as req_lib
        monkeypatch.setattr("requests.post",
                            lambda *a, **kw: (_ for _ in ()).throw(req_lib.ConnectionError("refused")))
        with pytest.raises(BacktestRunnerError, match="Network error"):
            br._post("/api/v0.1/backtest", {}, {})


# ---------------------------------------------------------------------------
# Rate limiting
# ---------------------------------------------------------------------------

class TestRateLimiting:
    @patch("backtest_runner._delete_symphony")
    @patch("backtest_runner._create_temp_symphony")
    @patch("backtest_runner._post")
    def test_sleep_called_between_periods(self, mock_post, mock_create, mock_delete,
                                          mock_strategy, mock_meta, monkeypatch):
        """time.sleep must be called once per period."""
        monkeypatch.setattr(br, "RATE_LIMIT_SLEEP_S", 1.0)
        mock_create.return_value = "fake-sym-id"
        mock_post.return_value   = _make_api_response()
        mock_delete.return_value = None

        sleep_calls = []
        monkeypatch.setattr(time, "sleep", lambda s: sleep_calls.append(s))

        run_nominal_backtest(mock_strategy, ["1Y", "2Y", "3Y"], mock_meta)
        assert len(sleep_calls) == 3
        assert all(s == 1.0 for s in sleep_calls)
