"""
backtest_runner.py — Submit strategies to the Composer API for backtesting.

Reads strategy files from pending/, calls Composer API via proxy at
http://localhost:8080/composer, writes raw results into the strategy dict
and returns it. Never writes to disk — caller handles persistence.

Schema reference: Section 2 (results file), Section 3 (period stats block),
                  Section 4 (API field mapping).
"""

from __future__ import annotations

import copy
from monitor_agent import log_event
import time
from datetime import date, datetime, timedelta, timezone
from typing import Optional

import requests

# ---------------------------------------------------------------------------
# Module-level configuration (monkeypatchable in tests)
# ---------------------------------------------------------------------------

COMPOSER_PROXY_BASE: str = "http://localhost:8080/composer"
RATE_LIMIT_SLEEP_S:  float = 1.0          # 1 req/sec on /backtest endpoint
MAX_RETRIES:         int   = 3
RETRY_BASE_DELAY_S:  float = 2.0          # exponential backoff base

# Allowed endpoints (security allowlist)
_ALLOWED_PATHS: frozenset[str] = frozenset({
    "/api/v0.1/backtest",
    "/api/v0.1/symphonies",
})

# Period label → relativedelta-equivalent in days
_PERIOD_DAYS: dict[str, int] = {
    "6M": 183,
    "1Y": 365,
    "2Y": 730,
    "3Y": 1095,
}

# ---------------------------------------------------------------------------
# Exceptions
# ---------------------------------------------------------------------------

class BacktestRunnerError(Exception):
    """Raised for unrecoverable backtest errors (not API errors)."""


class ComposerAPIError(Exception):
    """Raised for API errors that should halt the pipeline."""

    def __init__(self, message: str, status_code: int, body: str = "") -> None:
        super().__init__(message)
        self.status_code = status_code
        self.body = body


# ---------------------------------------------------------------------------
# Credentials helper
# ---------------------------------------------------------------------------

def _get_headers() -> dict:
    """Return Composer API auth headers via CredentialManager."""
    import sys, os
    src_dir = os.path.dirname(os.path.abspath(__file__))
    if src_dir not in sys.path:
        sys.path.insert(0, src_dir)
    from credentials import CredentialManager
    mgr = CredentialManager()
    return {**mgr.get_composer_headers(), "Content-Type": "application/json"}


# ---------------------------------------------------------------------------
# Date helpers
# ---------------------------------------------------------------------------

def _get_period_dates(period: str) -> tuple[str, str]:
    """Return (start_date, end_date) strings for a given period label.

    End date is always today (UTC). Start date is calculated by subtracting
    the period's day count from today.

    Args:
        period: One of "6M", "1Y", "2Y", "3Y".

    Returns:
        Tuple of ISO date strings (start_date, end_date).

    Raises:
        BacktestRunnerError: If period is not recognised.
    """
    if period not in _PERIOD_DAYS:
        raise BacktestRunnerError(
            f"Unknown period '{period}'. Valid periods: {sorted(_PERIOD_DAYS.keys())}"
        )
    today = date.today()
    start = today - timedelta(days=_PERIOD_DAYS[period])
    return start.isoformat(), today.isoformat()


# ---------------------------------------------------------------------------
# API field parsing
# ---------------------------------------------------------------------------

def _parse_period_stats(
    raw_stats: dict,
    benchmark_ticker: str,
    period: str,
    start_date: str,
    end_date: str,
) -> dict:
    """Convert raw Composer API stats response to the period stats block schema.

    Field mappings (Section 4.1 — confirmed):
        annualized_rate_of_return → annualized_return (×100)
        cumulative_return         → total_return (×100)
        sharpe_ratio              → sharpe
        max_drawdown              → max_drawdown (×100)
        standard_deviation        → volatility (×100)
        win_rate                  → win_rate (×100)

    Benchmark fields (Section 4.3 — from spec):
        stats.benchmarks.SPY.percent.alpha       → alpha
        stats.benchmarks.SPY.percent.beta        → beta
        stats.benchmarks.SPY.percent.r_square    → r_squared
        stats.benchmarks.SPY.percent.pearson_r   → correlation
        stats.benchmarks.SPY.annualized_rate_of_return → benchmark_annualized_return (×100)

    Args:
        raw_stats:         The data.stats object from the Composer API response.
        benchmark_ticker:  e.g. "SPY".
        period:            Period label e.g. "1Y".
        start_date:        ISO date string.
        end_date:          ISO date string.

    Returns:
        Fully-populated period stats block dict (Section 3 schema).
    """
    def _f(val, scale=1.0):
        """Safely convert a value to float, returning None if missing."""
        if val is None:
            return None
        return float(val) * scale

    # Core metrics
    core = {
        "annualized_return": _f(raw_stats.get("annualized_rate_of_return"), 100.0),
        "total_return":      _f(raw_stats.get("cumulative_return"), 100.0),
        "sharpe":            _f(raw_stats.get("sharpe_ratio")),
        "max_drawdown":      _f(raw_stats.get("max_drawdown"), 100.0),
        "volatility":        _f(raw_stats.get("standard_deviation"), 100.0),
        "win_rate":          _f(raw_stats.get("win_rate"), 100.0),
    }

    # Benchmark metrics
    bench_block = (raw_stats.get("benchmarks") or {}).get(benchmark_ticker, {})
    bench_pct   = bench_block.get("percent", {})

    bench_ann_return = _f(bench_block.get("annualized_rate_of_return"), 100.0)
    strategy_return  = core.get("annualized_return")
    beats_benchmark  = (
        (strategy_return is not None and bench_ann_return is not None
         and strategy_return > bench_ann_return)
        if bench_ann_return is not None else None
    )

    benchmark = {
        "benchmark_ticker":            benchmark_ticker,
        "benchmark_annualized_return": bench_ann_return,
        "benchmark_sharpe":            _f(bench_block.get("sharpe_ratio")),
        "benchmark_max_drawdown":      _f(bench_block.get("max_drawdown"), 100.0),
        "benchmark_volatility":        _f(bench_block.get("standard_deviation"), 100.0),
        "beats_benchmark":             beats_benchmark,
        "alpha":                       _f(bench_pct.get("alpha")),
        "beta":                        _f(bench_pct.get("beta")),
        "r_squared":                   _f(bench_pct.get("r_square")),   # API drops the 'd'
        "correlation":                 _f(bench_pct.get("pearson_r")),
    }

    # Raw API fields preserved at original scale for debugging
    raw_preserved = {
        "annualized_rate_of_return": _f(raw_stats.get("annualized_rate_of_return")),
        "cumulative_return":         _f(raw_stats.get("cumulative_return")),
        "sharpe_ratio":              _f(raw_stats.get("sharpe_ratio")),
        "max_drawdown":              _f(raw_stats.get("max_drawdown")),
        "standard_deviation":        _f(raw_stats.get("standard_deviation")),
        "win_rate":                  _f(raw_stats.get("win_rate")),
        "sortino_ratio":             _f(raw_stats.get("sortino_ratio")),
        "calmar_ratio":              _f(raw_stats.get("calmar_ratio")),
        "annualized_turnover":       _f(raw_stats.get("annualized_turnover")),
        "tail_ratio":                _f(raw_stats.get("tail_ratio")),
        "herfindahl_index":          _f(raw_stats.get("herfindahl_index")),
        "trailing_1m_return":        _f(raw_stats.get("trailing_one_month_return"), 100.0),
        "trailing_3m_return":        _f(raw_stats.get("trailing_three_month_return"), 100.0),
    }

    return {
        "period":            period,
        "start_date":        start_date,
        "end_date":          end_date,
        "core_metrics":      core,
        "benchmark_metrics": benchmark,
        "fitness":           None,         # populated by scorer.py
        "raw_api_fields":    raw_preserved,
    }


# ---------------------------------------------------------------------------
# Parameter injection
# ---------------------------------------------------------------------------

def _inject_parameters(composer_json: dict, params: dict) -> dict:
    """Deep copy composer_json and inject parameter values from params dict.

    params is a flat dict mapping parameter names to new values, e.g.:
        {"svxy_drawdown_threshold": "9", "rsi_window": "14"}

    Injection strategy: walk all nodes and match params against known
    parameter fields (rhs-val, lhs-fn-params.window, select-n, etc.).

    Args:
        composer_json: The composer_json tree (not mutated).
        params:        Flat dict of parameter names → new values.

    Returns:
        Deep copy of composer_json with params injected.
    """
    if not params:
        return copy.deepcopy(composer_json)

    result = copy.deepcopy(composer_json)
    _inject_into_node(result, params)
    return result


def _inject_into_node(node: dict, params: dict) -> None:
    """Recursively inject parameter values into a composer node in-place.

    Key format (aligned with optimizer.py):
        "{lhs-fn}_{lhs-val}_threshold"   e.g. "max-drawdown_SVXY_threshold"
        "{lhs-fn}_{lhs-val}_window"      e.g. "max-drawdown_SVXY_window"
        "filter_{sort-by-fn}_window"     e.g. "filter_cumulative-return_window"
        "filter_{sort-by-fn}_select_n"   e.g. "filter_cumulative-return_select_n"
        "wt-inverse-vol_window_days"
    """
    if not isinstance(node, dict):
        return

    step    = node.get("step", "")
    lhs_fn  = node.get("lhs-fn", "")
    lhs_val = node.get("lhs-val", "")
    fn_params = node.get("lhs-fn-params") or {}

    # Conditional if-child: rhs-val and window
    if lhs_fn and not node.get("is-else-condition?", False):
        rhs_key = f"{lhs_fn}_{lhs_val}_threshold"
        if rhs_key in params and "rhs-val" in node:
            node["rhs-val"] = str(params[rhs_key])

        win_key = f"{lhs_fn}_{lhs_val}_window"
        if win_key in params and "window" in fn_params:
            fn_params["window"] = int(params[win_key])

    # Filter nodes
    if step == "filter":
        sort_fn     = node.get("sort-by-fn", "")
        sort_params = node.get("sort-by-fn-params") or {}
        win_key     = f"filter_{sort_fn}_window"
        sel_key     = f"filter_{sort_fn}_select_n"
        if win_key in params and "window" in sort_params:
            sort_params["window"] = int(params[win_key])
        if sel_key in params:
            node["select-n"] = str(params[sel_key])

    # wt-inverse-vol
    if step == "wt-inverse-vol" and "wt-inverse-vol_window_days" in params:
        node["window-days"] = str(params["wt-inverse-vol_window_days"])

    for child in node.get("children", []):
        _inject_into_node(child, params)


def _make_param_key(lhs_fn: str, lhs_val: str, suffix: str) -> str:
    """Build a parameter key in the new format: {fn}_{val}_{suffix}."""
    return f"{lhs_fn}_{lhs_val}_{suffix}"


# ---------------------------------------------------------------------------
# HTTP request helpers
# ---------------------------------------------------------------------------

def _post(path: str, payload: dict, headers: dict) -> dict:
    """POST to the Composer proxy with retry on 429.

    Args:
        path:    API path (must be in _ALLOWED_PATHS or start with allowed prefix).
        payload: JSON payload dict.
        headers: Auth headers.

    Returns:
        Parsed JSON response dict.

    Raises:
        ComposerAPIError: On 400/422 or persistent 429 after retries.
        BacktestRunnerError: On network errors or disallowed paths.
    """
    # Enforce allowlist (exact match or prefix for symphony sub-paths)
    allowed = any(
        path == p or path.startswith(p + "/")
        for p in _ALLOWED_PATHS
    )
    if not allowed:
        raise BacktestRunnerError(
            f"Path '{path}' is not in the API endpoint allowlist."
        )

    url = COMPOSER_PROXY_BASE + path
    delay = RETRY_BASE_DELAY_S

    for attempt in range(MAX_RETRIES + 1):
        try:
            response = requests.post(url, json=payload, headers=headers, timeout=60)
        except requests.RequestException as exc:
            raise BacktestRunnerError(f"Network error calling {url}: {exc}") from exc

        if response.status_code in (200, 201):
            return response.json()

        if response.status_code in (400, 422):
            raise ComposerAPIError(
                f"Composer API error {response.status_code} for {path}",
                status_code=response.status_code,
                body=response.text,
            )

        if response.status_code in (429, 503):
            if attempt < MAX_RETRIES:
                sleep_s = delay if response.status_code == 429 else 3.0
                time.sleep(sleep_s)
                delay *= 2
                continue
            raise ComposerAPIError(
                f"Composer API {response.status_code} after {MAX_RETRIES} retries",
                status_code=response.status_code,
            )

        # Other errors
        raise ComposerAPIError(
            f"Composer API unexpected status {response.status_code} for {path}",
            status_code=response.status_code,
            body=response.text,
        )

    # Should not reach here
    raise BacktestRunnerError(f"Exhausted retries for {path}")


# ---------------------------------------------------------------------------
# Backtest payload builder
# ---------------------------------------------------------------------------

def _build_symphony_backtest_payload(
    start_date: str,
    end_date: str,
    meta: dict,
) -> dict:
    """Build the backtest payload for the symphony endpoint (Step 3 of copy+PUT+backtest+delete).

    The symphony already has the strategy encoded — only timing/capital params needed.

    Args:
        start_date: ISO date string for backtest start.
        end_date:   ISO date string for backtest end.
        meta:       Full meta.json dict.

    Returns:
        Composer API backtest payload dict.
    """
    config = meta.get("config", {})
    return {
        "capital":           config.get("capital", 10000),
        "apply_reg_fee":     False,
        "apply_taf_fee":     False,
        "slippage_percent":  0.001,
        "broker":            config.get("broker", "ALPACA_WHITE_LABEL"),
        "start_date":        start_date,
        "end_date":          end_date,
        "benchmark_tickers": [config.get("benchmark", "SPY")],
    }


# ---------------------------------------------------------------------------
# Pipeline status helpers
# ---------------------------------------------------------------------------

def _now_iso() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _set_pipeline_status(strategy: dict, status: str) -> None:
    """Update pipeline.current_status and append to status_history."""
    pipeline = strategy.setdefault("pipeline", {})
    pipeline["current_status"] = status
    history  = pipeline.setdefault("status_history", [])
    history.append({"status": status, "timestamp": _now_iso()})


def _mark_disqualified(strategy: dict, reason: str) -> None:
    """Mark strategy as disqualified in summary and pipeline blocks."""
    strategy["summary"]["disqualified"] = True
    strategy["summary"]["status"]       = "DISQUALIFIED"
    pipeline = strategy.setdefault("pipeline", {})
    pipeline["disqualified"]             = True
    pipeline["disqualification_reason"]  = reason
    pipeline["disqualified_at"]          = _now_iso()
    _set_pipeline_status(strategy, "DISQUALIFIED")


def _mark_error(strategy: dict, error_msg: str) -> None:
    """Log a pipeline error without full disqualification."""
    pipeline = strategy.setdefault("pipeline", {})
    error_log = pipeline.setdefault("error_log", [])
    error_log.append({"timestamp": _now_iso(), "error": error_msg})
    _set_pipeline_status(strategy, "ERROR")


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------


# ── Symphony lifecycle helpers ─────────────────────────────────────────────────

_COPY_SOURCE_ID = "qjRIwrAOA1YzFSghM08b"  # Sisyphus — simple, reliable copy source

def _create_temp_symphony(composer_json: dict, name: str, headers: dict) -> str:
    """Create a temporary symphony for backtesting via copy+PUT.

    Copy a simple source symphony to get a valid ID, then PUT our
    strategy definition into it. Returns the symphony ID.

    Args:
        composer_json: Strategy composer_json dict (has step, children, etc.)
        name: Strategy name for the symphony.
        headers: Auth headers from _get_headers().

    Returns:
        Symphony ID string.

    Raises:
        ComposerAPIError: If copy or PUT fails.
    """
    import uuid

    # Step 1: Copy source symphony to get a valid ID
    copy_resp = _post(
        f"/api/v0.1/symphonies/{_COPY_SOURCE_ID}/copy",
        {"name": f"tmp-{name[:40]}"},
        headers,
    )
    sym_id = copy_resp.get("symphony_id")
    if not sym_id:
        raise ComposerAPIError(f"Copy returned no symphony_id: {copy_resp}")

    # Step 2: PUT our strategy into the copied symphony
    # Build node tree with UUIDs on every node
    def add_ids(node):
        import copy as _copy
        n = _copy.deepcopy(node)
        if "id" not in n:
            n["id"] = str(uuid.uuid4())
        n["children"] = [add_ids(c) for c in n.get("children", [])]
        return n

    children = [add_ids(c) for c in composer_json.get("children", [])]

    put_payload = {
        "name":        name[:100],
        "description": "",
        "step":        "root",
        "rebalance":   "daily",
        "asset_class": "EQUITIES",
        "children":    children,
    }

    # PUT uses requests directly (not _post allowlist — PUT is separate)
    import requests as _req
    put_resp = _req.put(
        f"{COMPOSER_PROXY_BASE}/api/v0.1/symphonies/{sym_id}",
        headers={**headers, "Content-Type": "application/json"},
        json=put_payload,
        timeout=30,
    )
    if put_resp.status_code not in (200, 201):
        # Clean up the copy we made
        try:
            _req.delete(f"{COMPOSER_PROXY_BASE}/api/v0.1/symphonies/{sym_id}",
                       headers=headers, timeout=10)
        except Exception:
            pass
        raise ComposerAPIError(
            f"PUT symphony failed {put_resp.status_code}: {put_resp.text[:200]}"
        )

    return sym_id


def _delete_symphony(sym_id: str, headers: dict) -> None:
    """Delete a temporary symphony. Errors are logged but not raised."""
    try:
        import requests as _req
        _req.delete(
            f"{COMPOSER_PROXY_BASE}/api/v0.1/symphonies/{sym_id}",
            headers=headers,
            timeout=10,
        )
    except Exception as e:
        log_event("WARNING", "backtest_runner",
                  f"Failed to delete temp symphony {sym_id}: {e}")

def run_nominal_backtest(
    strategy: dict,
    periods: list[str],
    meta: dict,
) -> dict:
    """Submit strategy to Composer API for each period and populate nominal_result.

    Args:
        strategy: Full strategy dict at PENDING status.
        periods:  List of period labels e.g. ["6M", "1Y", "2Y", "3Y"].
        meta:     Full meta.json dict.

    Returns:
        Updated strategy dict with nominal_result.periods populated.
        Pipeline status set to NOMINAL_COMPLETE on success, DISQUALIFIED on
        400/422, ERROR on other failures.
    """
    result   = copy.deepcopy(strategy)
    composer = result["strategy"]["composer_json"]
    config   = meta.get("config", {})
    benchmark = config.get("benchmark", "SPY")

    try:
        headers = _get_headers()
    except Exception as exc:
        _mark_error(result, f"Credential error: {exc}")
        return result

    period_results: dict = {}
    api_calls = 0
    total_ms  = 0

    strat_name = result.get("identity", {}).get("name") or result.get("summary", {}).get("name", "tmp")

    for period in periods:
        start_date, end_date = _get_period_dates(period)
        payload = _build_symphony_backtest_payload(start_date, end_date, meta)

        t0 = time.monotonic()
        # Create temp symphony via copy+PUT
        sym_id = None
        try:
            sym_id = _create_temp_symphony(composer, strat_name, headers)
        except Exception as e:
            _mark_error(result, f"Failed to create temp symphony: {e}")
            return result

        try:
            raw = _post(f"/api/v0.1/symphonies/{sym_id}/backtest", payload, headers)
            elapsed_ms = int((time.monotonic() - t0) * 1000)
            api_calls += 1
            total_ms  += elapsed_ms

            stats_obj = raw.get("stats", raw)
            if "data" in raw:
                stats_obj = raw["data"].get("stats", raw.get("stats", {}))

            period_results[period] = _parse_period_stats(
                stats_obj, benchmark, period, start_date, end_date
            )

        except ComposerAPIError as exc:
            _delete_symphony(sym_id, headers)
            if exc.status_code in (400, 422):
                _mark_disqualified(result, "INVALID_JSON")
                result.setdefault("pipeline", {}).setdefault("error_log", []).append(
                    {"timestamp": _now_iso(), "error": str(exc), "body": getattr(exc, "body", "")}
                )
                return result
            _mark_error(result, str(exc))
            return result
        finally:
            # Always clean up symphony
            if sym_id:
                _delete_symphony(sym_id, headers)
                sym_id = None

        # Rate limit sleep (configurable — 0 for symphony endpoint by default)
        time.sleep(RATE_LIMIT_SLEEP_S)

    # Populate nominal_result
    result["nominal_result"] = {
        "status":       "COMPLETE",
        "completed_at": _now_iso(),
        "parameters_used": _extract_parameters(composer),
        "periods":      period_results,
        "composite_fitness": None,    # populated by scorer.py
        "api_calls_used": api_calls,
        "api_call_ms":    total_ms,
    }
    result["summary"]["status"] = "NOMINAL_COMPLETE"
    _set_pipeline_status(result, "NOMINAL_COMPLETE")
    return result


def run_validation_backtest(
    strategy: dict,
    optimal_params: dict,
    periods: list[str],
    meta: dict,
) -> dict:
    """Run backtest with optimal parameters injected; populate final_result.

    Args:
        strategy:       Full strategy dict (post-optimizer).
        optimal_params: Flat dict of optimal parameter values.
        periods:        List of period labels.
        meta:           Full meta.json dict.

    Returns:
        Updated strategy dict with final_result.periods populated.
    """
    result   = copy.deepcopy(strategy)
    original = result["strategy"]["composer_json"]
    composer = _inject_parameters(original, optimal_params)
    config   = meta.get("config", {})
    benchmark = config.get("benchmark", "SPY")

    try:
        headers = _get_headers()
    except Exception as exc:
        _mark_error(result, f"Credential error: {exc}")
        return result

    period_results: dict = {}
    api_calls = 0
    total_ms  = 0

    strat_name = result.get("identity", {}).get("name") or result.get("summary", {}).get("name", "tmp")

    for period in periods:
        start_date, end_date = _get_period_dates(period)
        payload = _build_symphony_backtest_payload(start_date, end_date, meta)

        t0 = time.monotonic()
        sym_id = None
        try:
            sym_id = _create_temp_symphony(composer, strat_name, headers)
        except Exception as e:
            _mark_error(result, f"Failed to create temp symphony: {e}")
            return result

        try:
            raw = _post(f"/api/v0.1/symphonies/{sym_id}/backtest", payload, headers)
            elapsed_ms = int((time.monotonic() - t0) * 1000)
            api_calls += 1
            total_ms  += elapsed_ms

            stats_obj = raw.get("stats", raw)
            if "data" in raw:
                stats_obj = raw["data"].get("stats", raw.get("stats", {}))

            period_results[period] = _parse_period_stats(
                stats_obj, benchmark, period, start_date, end_date
            )

        except ComposerAPIError as exc:
            _delete_symphony(sym_id, headers)
            if exc.status_code in (400, 422):
                _mark_disqualified(result, "INVALID_JSON")
                return result
            _mark_error(result, str(exc))
            return result
        finally:
            if sym_id:
                _delete_symphony(sym_id, headers)
                sym_id = None

        time.sleep(RATE_LIMIT_SLEEP_S)

    # Populate final_result
    result["final_result"] = {
        "status":       "COMPLETE",
        "completed_at": _now_iso(),
        "parameters_used": optimal_params,
        "periods":      period_results,
        "composite_fitness": None,
        "api_calls_used": api_calls,
        "api_call_ms":    total_ms,
    }
    result["summary"]["status"] = "VALIDATING"
    _set_pipeline_status(result, "VALIDATING")
    return result


# ---------------------------------------------------------------------------
# Utilities
# ---------------------------------------------------------------------------

def _extract_parameters(composer_json: dict) -> dict:
    """Extract key tunable parameters from a composer_json tree.

    Uses the same key format as optimizer._extract_params_from_tree:
        "{lhs-fn}_{lhs-val}_threshold" / "{lhs-fn}_{lhs-val}_window"
        "filter_{sort-by-fn}_window" / "filter_{sort-by-fn}_select_n"
        "wt-inverse-vol_window_days"
    """
    params: dict = {}

    def visit(node: dict) -> None:
        if not isinstance(node, dict):
            return
        step    = node.get("step", "")
        lhs_fn  = node.get("lhs-fn", "")
        lhs_val = node.get("lhs-val", "")
        fn_p    = node.get("lhs-fn-params") or {}

        if lhs_fn and not node.get("is-else-condition?", False):
            if "rhs-val" in node:
                params[f"{lhs_fn}_{lhs_val}_threshold"] = node["rhs-val"]
            if "window" in fn_p:
                params[f"{lhs_fn}_{lhs_val}_window"] = fn_p["window"]

        if step == "filter":
            sort_fn = node.get("sort-by-fn", "")
            sp      = node.get("sort-by-fn-params") or {}
            if "window" in sp:
                params[f"filter_{sort_fn}_window"] = sp["window"]
            if "select-n" in node:
                params[f"filter_{sort_fn}_select_n"] = node["select-n"]

        if step == "wt-inverse-vol":
            wd = node.get("window-days")
            if wd is not None:
                params["wt-inverse-vol_window_days"] = wd

    from logic_auditor import walk_nodes
    walk_nodes(composer_json, visit)
    return params
