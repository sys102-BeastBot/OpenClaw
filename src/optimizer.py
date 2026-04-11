"""
optimizer.py — Grid search parameter space for strategies that pass rough cut.

Two-stage: nominal backtest already done — optimizer finds best params using
the Composer symphony endpoint (500 req/s, no sleep needed between calls).

Schema reference: Section 2.6 (optimizer_data block).
"""

from __future__ import annotations

import copy
import itertools
import time
from datetime import datetime, timezone
from typing import Optional

import requests

from monitor_agent import log_event

# ---------------------------------------------------------------------------
# Module-level config (monkeypatchable in tests)
# ---------------------------------------------------------------------------

COMPOSER_PROXY_BASE: str = "http://localhost:8080/composer"
MAX_RETRIES:         int  = 3
RETRY_BASE_DELAY_S:  float = 2.0

# Symphony endpoint — 500 req/s, no sleep needed
SYMPHONY_PATH:  str = "/api/v0.1/symphonies"
BACKTEST_PATH:  str = "/api/v0.1/backtest"

# Delta thresholds
DELTA_LARGE:      float = 15.0
DELTA_MODERATE:   float = 5.0
DELTA_SMALL:      float = 2.0

# Default search ranges per indicator (used when no KB prior available).
# Keys match the fn-suffix portion of the param key (after stripping the asset token).
# New key format: "{lhs-fn}_{lhs-val}_window" / "{lhs-fn}_{lhs-val}_threshold"
_DEFAULT_RANGES: dict[str, list] = {
    "max-drawdown_threshold":            ["5", "8", "10", "12", "15"],
    "max-drawdown_window":               [1, 2, 3, 5],
    "relative-strength-index_threshold": ["70", "75", "79", "82", "85"],
    "relative-strength-index_window":    [5, 10, 14, 20],
    "cumulative-return_window":          [5, 10, 15, 20, 30],
    "filter_select_n":                   ["1", "2", "3"],
    "wt-inverse-vol_window_days":        ["10", "20", "30", "60"],
}

# ---------------------------------------------------------------------------
# Exceptions
# ---------------------------------------------------------------------------

class OptimizerError(Exception):
    """Raised for unrecoverable optimizer errors."""


class ComposerAPIError(Exception):
    """Raised for Composer API errors during optimization."""

    def __init__(self, message: str, status_code: int, body: str = "") -> None:
        super().__init__(message)
        self.status_code = status_code
        self.body = body


# ---------------------------------------------------------------------------
# Credentials helper
# ---------------------------------------------------------------------------

def _get_headers() -> dict:
    import sys, os
    src_dir = os.path.dirname(os.path.abspath(__file__))
    if src_dir not in sys.path:
        sys.path.insert(0, src_dir)
    from credentials import CredentialManager
    mgr = CredentialManager()
    return {**mgr.get_composer_headers(), "Content-Type": "application/json"}


# ---------------------------------------------------------------------------
# Utility
# ---------------------------------------------------------------------------

def _now_iso() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _inject_parameters(composer_json: dict, params: dict) -> dict:
    """Deep copy composer_json and inject flat param dict into the tree.

    Uses the same key format as backtest_runner._inject_parameters:
        {asset}_{fn_name}_{suffix}  e.g. "svxy_max-drawdown_threshold"

    Args:
        composer_json: The composer_json tree (not mutated).
        params:        Flat dict of param_key → value.

    Returns:
        Modified deep copy.
    """
    if not params:
        return copy.deepcopy(composer_json)
    result = copy.deepcopy(composer_json)
    _inject_into_node(result, params)
    return result


def _inject_into_node(node: dict, params: dict) -> None:
    """Recursively inject params into node in-place.

    Key format matches _extract_params_from_tree:
        "{lhs-fn}_{lhs-val}_threshold" / "{lhs-fn}_{lhs-val}_window"
        "filter_{sort-by-fn}_window" / "filter_{sort-by-fn}_select_n"
        "wt-inverse-vol_window_days"
    """
    if not isinstance(node, dict):
        return

    step    = node.get("step", "")
    lhs_fn  = node.get("lhs-fn", "")
    lhs_val = node.get("lhs-val", "")
    fn_params = node.get("lhs-fn-params") or {}

    # Conditional if-child nodes
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

    # wt-inverse-vol nodes
    if step == "wt-inverse-vol" and "wt-inverse-vol_window_days" in params:
        node["window-days"] = str(params["wt-inverse-vol_window_days"])

    for child in node.get("children", []):
        _inject_into_node(child, params)


# ---------------------------------------------------------------------------
# KB prior helpers
# ---------------------------------------------------------------------------

def _extract_params_from_tree(composer_json: dict) -> dict:
    """Walk the full composer_json tree and collect all tunable parameter values.

    Key format (new spec):
        "{lhs-fn}_{lhs-val}_window"    e.g. "max-drawdown_SVXY_window"
        "{lhs-fn}_{lhs-val}_threshold" e.g. "max-drawdown_SVXY_threshold"
        "filter_{sort-by-fn}_select_n" e.g. "filter_cumulative-return_select_n"
        "filter_{sort-by-fn}_window"   e.g. "filter_cumulative-return_window"
        "wt-inverse-vol_window_days"

    Walks the full tree at any depth, including under wt-cash-equal wrappers.
    """
    params: dict = {}

    def visit(node: dict) -> None:
        if not isinstance(node, dict):
            return

        step    = node.get("step", "")
        lhs_fn  = node.get("lhs-fn", "")
        lhs_val = node.get("lhs-val", "")
        fn_p    = node.get("lhs-fn-params") or {}

        # if-child conditional nodes
        if lhs_fn and not node.get("is-else-condition?", False):
            if "rhs-val" in node:
                params[f"{lhs_fn}_{lhs_val}_threshold"] = node["rhs-val"]
            if "window" in fn_p:
                params[f"{lhs_fn}_{lhs_val}_window"] = fn_p["window"]

        # filter nodes
        if step == "filter":
            sort_fn = node.get("sort-by-fn", "")
            sp      = node.get("sort-by-fn-params") or {}
            if "window" in sp:
                params[f"filter_{sort_fn}_window"] = sp["window"]
            if "select-n" in node:
                params[f"filter_{sort_fn}_select_n"] = node["select-n"]

        # wt-inverse-vol nodes
        if step == "wt-inverse-vol":
            wd = node.get("window-days")
            if wd is not None:
                params["wt-inverse-vol_window_days"] = wd

    from logic_auditor import walk_nodes
    walk_nodes(composer_json, visit)
    return params


def _prior_range(param_key: str, current_val, kb_priors: dict) -> tuple[list, str]:
    """Return (search_values, search_basis) for a parameter.

    Args:
        param_key:   e.g. "svxy_max-drawdown_threshold"
        current_val: Current value in the strategy tree.
        kb_priors:   Dict of param_key → {values: list, confidence: float, ...}

    Returns:
        (list_of_values_to_test, search_basis_string)
    """
    prior = kb_priors.get(param_key)

    if prior is None:
        # No prior — look up in _DEFAULT_RANGES.
        # New key format: "{lhs-fn}_{lhs-val}_suffix" → strip the middle lhs-val token
        # to get a fn+suffix key. But some keys (filter_*, wt-inverse-vol_*) are direct.
        # Strategy: try the full key first, then try stripping the second token.
        default = _DEFAULT_RANGES.get(param_key)
        if default is None:
            parts = param_key.split("_")
            # Try removing the asset token (index 1 for 3-part keys like fn_ASSET_suffix)
            if len(parts) >= 3:
                fn_suffix = f"{parts[0]}_{parts[-1]}"   # e.g. "max-drawdown_threshold"
                default   = _DEFAULT_RANGES.get(fn_suffix)
        if default is None:
            default = [current_val]
        return default, "no_prior_full"

    confidence = float(prior.get("confidence", 0.0))
    prior_vals = prior.get("values", [current_val])
    gen_val    = str(current_val)

    if gen_val not in [str(v) for v in prior_vals]:
        # Generator deviated from prior
        narrow = list(prior_vals[:3]) if prior_vals else [current_val]
        return [current_val] + narrow, "generator_deviation_targeted"

    if confidence >= 0.7:
        # High confidence — narrow search around prior
        return list(prior_vals[:3]) if prior_vals else [current_val], "prior_narrow"

    # Lower confidence — full prior range
    return list(prior_vals), "prior_full"


# ---------------------------------------------------------------------------
# build_param_grid
# ---------------------------------------------------------------------------

def build_param_grid(strategy: dict, kb_priors: dict) -> tuple[list[dict], dict[str, str]]:
    """Build the list of parameter combinations to test.

    Args:
        strategy:  Full strategy dict at NOMINAL_COMPLETE status.
        kb_priors: Dict of {param_key: {values, confidence, ...}} from patterns.json.

    Returns:
        Tuple of (combinations, search_basis_map).
        combinations is a list of flat param dicts.
        search_basis_map is {param_key: basis_string}.
    """
    composer_json = strategy["strategy"]["composer_json"]
    current_params = _extract_params_from_tree(composer_json)

    if not current_params:
        return [{}], {}

    search_values: dict[str, list] = {}
    search_basis:  dict[str, str]  = {}

    for key, val in current_params.items():
        values, basis = _prior_range(key, val, kb_priors)
        search_values[key] = values
        search_basis[key]  = basis

    # Build cartesian product
    keys = list(search_values.keys())
    value_lists = [search_values[k] for k in keys]
    combinations = [
        dict(zip(keys, combo))
        for combo in itertools.product(*value_lists)
    ]

    return combinations, search_basis


# ---------------------------------------------------------------------------
# compute_fitness_delta
# ---------------------------------------------------------------------------

def compute_fitness_delta(nominal_composite: float, optimized_composite: float) -> dict:
    """Compute the fitness improvement from optimization.

    Args:
        nominal_composite:   Composite fitness before optimization.
        optimized_composite: Composite fitness after optimization.

    Returns:
        Dict with: nominal_composite, optimized_composite, delta (str), delta_interpretation.
    """
    delta = optimized_composite - nominal_composite

    if abs(delta) >= DELTA_LARGE:
        interpretation = "LARGE"
    elif abs(delta) >= DELTA_MODERATE:
        interpretation = "MODERATE"
    elif abs(delta) >= DELTA_SMALL:
        interpretation = "SMALL"
    else:
        interpretation = "NEGLIGIBLE"

    sign = "+" if delta >= 0 else ""
    return {
        "nominal_composite":   round(nominal_composite, 4),
        "optimized_composite": round(optimized_composite, 4),
        "delta":               f"{sign}{round(delta, 2)}",
        "delta_interpretation": interpretation,
    }


# ---------------------------------------------------------------------------
# HTTP helpers
# ---------------------------------------------------------------------------

def _post(path: str, payload: dict, headers: dict) -> dict:
    """POST to the Composer proxy with retry on 429."""
    url   = COMPOSER_PROXY_BASE + path
    delay = RETRY_BASE_DELAY_S

    for attempt in range(MAX_RETRIES + 1):
        try:
            resp = requests.post(url, json=payload, headers=headers, timeout=60)
        except requests.RequestException as exc:
            raise OptimizerError(f"Network error calling {url}: {exc}") from exc

        if resp.status_code in (200, 201):
            return resp.json()
        if resp.status_code in (400, 422):
            raise ComposerAPIError(
                f"Composer API {resp.status_code}", resp.status_code, resp.text
            )
        if resp.status_code in (429, 503):
            if attempt < MAX_RETRIES:
                sleep_s = delay if resp.status_code == 429 else 3.0
                time.sleep(sleep_s)
                delay *= 2
                continue
            raise ComposerAPIError(f"Rate limit/503 ({resp.status_code})", resp.status_code)
        raise ComposerAPIError(
            f"Unexpected status {resp.status_code}", resp.status_code, resp.text
        )
    raise OptimizerError("Exhausted retries")


def _delete(path: str, headers: dict) -> None:
    """DELETE a symphony from the proxy (cleanup)."""
    url = COMPOSER_PROXY_BASE + path
    try:
        requests.delete(url, headers=headers, timeout=30)
    except requests.RequestException:
        pass  # best-effort cleanup


# ---------------------------------------------------------------------------
# Symphony create / delete for optimizer
# ---------------------------------------------------------------------------

_COPY_SOURCE_ID = "qjRIwrAOA1YzFSghM08b"  # Sisyphus — reliable copy source


def _create_symphony(composer_json: dict, headers: dict) -> str:
    """Create a temporary Composer symphony via copy+PUT flow.

    Step 1: Copy the source symphony to get a valid ID.
    Step 2: PUT our strategy into the copied symphony (with UUID ids on every node).

    Returns:
        Symphony ID string.
    """
    import uuid, requests as _req

    # Step 1: Copy
    copy_resp = _post(
        f"{SYMPHONY_PATH}/{_COPY_SOURCE_ID}/copy",
        {"name": "_opt_tmp"},
        headers,
    )
    sym_id = copy_resp.get("symphony_id")
    if not sym_id:
        raise OptimizerError(f"Copy returned no symphony_id: {copy_resp}")

    # Step 2: PUT strategy
    def add_ids(node: dict) -> dict:
        n = copy.deepcopy(node)
        if "id" not in n:
            n["id"] = str(uuid.uuid4())
        n["children"] = [add_ids(c) for c in n.get("children", [])]
        return n

    children   = [add_ids(c) for c in composer_json.get("children", [])]
    put_payload = {
        "name":        "_opt_tmp",
        "description": "",
        "step":        "root",
        "rebalance":   "daily",
        "asset_class": "EQUITIES",
        "children":    children,
    }

    put_resp = _req.put(
        f"{COMPOSER_PROXY_BASE}{SYMPHONY_PATH}/{sym_id}",
        headers={**headers, "Content-Type": "application/json"},
        json=put_payload,
        timeout=30,
    )
    if put_resp.status_code not in (200, 201):
        _delete(f"{SYMPHONY_PATH}/{sym_id}", headers)
        raise ComposerAPIError(
            f"PUT symphony failed {put_resp.status_code}: {put_resp.text[:200]}",
            put_resp.status_code,
        )
    return sym_id


def _run_symphony_backtest(
    symphony_id: str,
    start_date: str,
    end_date: str,
    meta: dict,
    headers: dict,
) -> dict:
    """Run a backtest for an existing symphony ID."""
    config = meta.get("config", {})
    payload = {
        "capital":           config.get("capital", 10000),
        "apply_reg_fee":     False,
        "apply_taf_fee":     False,
        "slippage_percent":  0.001,
        "broker":            config.get("broker", "ALPACA_WHITE_LABEL"),
        "start_date":        start_date,
        "end_date":          end_date,
        "benchmark_tickers": [config.get("benchmark", "SPY")],
    }
    path = f"{SYMPHONY_PATH}/{symphony_id}/backtest"
    return _post(path, payload, headers)


# ---------------------------------------------------------------------------
# run_optimizer
# ---------------------------------------------------------------------------

def run_optimizer(
    strategy: dict,
    meta: dict,
    kb_priors: Optional[dict] = None,
) -> dict:
    """Find optimal parameters via grid search using Composer symphony endpoint.

    Requires strategy at NOMINAL_COMPLETE status with nominal_result populated.

    Args:
        strategy:  Full strategy dict at NOMINAL_COMPLETE.
        meta:      Full meta.json dict.
        kb_priors: Optional dict of {param_key: prior_info} from patterns.json.
                   Pass empty dict or None to use default ranges.

    Returns:
        Updated strategy dict with optimizer_data block populated.
        Pipeline status set to OPTIMIZING while running, COMPLETE when done.
    """
    result = copy.deepcopy(strategy)
    if kb_priors is None:
        kb_priors = {}

    # Extract nominal composite fitness for delta computation
    nom_res   = result.get("nominal_result") or {}
    nom_comp  = (nom_res.get("composite_fitness") or {}).get("final_composite")

    composer_json   = result["strategy"]["composer_json"]
    current_params  = _extract_params_from_tree(composer_json)

    try:
        headers = _get_headers()
    except Exception as exc:
        _mark_error(result, f"Credential error: {exc}")
        return result

    # Get backtest date range (use 1Y period for optimizer grid)
    from backtest_runner import _get_period_dates
    start_date, end_date = _get_period_dates("1Y")

    # Build parameter grid
    combinations, search_basis = build_param_grid(result, kb_priors)

    # Apply combination cap (read from meta, default 200)
    cap = int(meta.get("config", {}).get("optimizer_combination_cap", 200))
    if len(combinations) > cap:
        import random
        combinations = random.sample(combinations, cap)
        log_event("INFO", "optimizer",
                  f"{result['summary']['strategy_id']}: grid capped at {cap} "
                  f"(sampled from full grid)")

    total_combos = len(combinations)

    _set_optimizer_status(result, "PENDING", started=True)

    best_fitness: Optional[float] = None
    best_params:  dict            = copy.deepcopy(current_params)
    best_stats:   dict            = {}
    api_calls:    int             = 0
    param_scores: dict[str, dict] = {}  # key → {value: fitness_score}
    strategy_id   = result["summary"]["strategy_id"]

    for i, combo in enumerate(combinations):
        injected = _inject_parameters(composer_json, combo)
        sym_id_combo: Optional[str] = None

        # Create symphony via copy+PUT
        try:
            sym_id_combo = _create_symphony(injected, headers)
            api_calls += 1
        except (ComposerAPIError, OptimizerError) as exc:
            _mark_error(result, f"Symphony create error: {exc}")
            return result

        # Run backtest, always clean up symphony afterwards
        try:
            raw = _run_symphony_backtest(sym_id_combo, start_date, end_date, meta, headers)
            api_calls += 1
        except ComposerAPIError as exc:
            if exc.status_code in (400, 422):
                # Skip this combination — continue to next
                continue
            _mark_error(result, str(exc))
            return result
        finally:
            if sym_id_combo:
                _delete(f"{SYMPHONY_PATH}/{sym_id_combo}", headers)

        # Parse fitness
        stats_obj = raw.get("stats", raw)
        if "data" in raw:
            stats_obj = raw["data"].get("stats", raw.get("stats", {}))

        ann_ret   = float(stats_obj.get("annualized_rate_of_return", 0) or 0) * 100
        sharpe    = float(stats_obj.get("sharpe_ratio", 0) or 0)
        max_dd    = float(stats_obj.get("max_drawdown", 0) or 0) * 100

        # Simple composite for ranking within optimizer (uses global weights from meta)
        weights = meta.get("fitness", {}).get("global_weights", {
            "sharpe": 0.35, "return": 0.40, "drawdown": 0.25
        })
        import math
        sharpe_c  = max(0, min(sharpe / 3.0, 1)) * weights.get("sharpe", 0.35) * 100
        return_c  = max(0, min(math.log(max(1e-9, 1 + ann_ret / 100)) / math.log(2.5), 1)) * weights.get("return", 0.40) * 100
        dd_c      = max(dd_c := _dd_penalty(max_dd, weights.get("drawdown", 0.25)), 0)
        composite = sharpe_c + return_c - dd_c

        # Track per-param scores for sensitivity analysis
        for pk, pv in combo.items():
            if pk not in param_scores:
                param_scores[pk] = {}
            pv_str = str(pv)
            if pv_str not in param_scores[pk] or composite > param_scores[pk][pv_str]:
                param_scores[pk][pv_str] = composite

        if best_fitness is None or composite > best_fitness:
            best_fitness = composite
            best_params  = dict(combo)
            best_stats   = stats_obj

        # Progress logging every 25 combos
        if (i + 1) % 25 == 0 or (i + 1) == total_combos:
            best_str = f"{best_fitness:.1f}" if best_fitness is not None else "N/A"
            log_event("INFO", "optimizer",
                      f"{strategy_id}: optimizer {i+1}/{total_combos} combos "
                      f"({(i+1)/total_combos*100:.0f}%) — "
                      f"best so far: {best_str}")

    # Compute parameter diff (what changed from Generator's values)
    param_diff: dict = {}
    for key, opt_val in best_params.items():
        orig_val = current_params.get(key)
        if str(orig_val) != str(opt_val):
            param_diff[key] = {"from": orig_val, "to": opt_val}

    # Parameter sensitivity analysis
    parameter_sensitivity: dict = {}
    for pk, score_map in param_scores.items():
        if not score_map:
            continue
        sorted_vals = sorted(score_map.items(), key=lambda x: x[1], reverse=True)
        parameter_sensitivity[pk] = {
            "winner":     sorted_vals[0][0] if len(sorted_vals) > 0 else None,
            "runner_up":  sorted_vals[1][0] if len(sorted_vals) > 1 else None,
            "sensitivity": "HIGH" if len(sorted_vals) > 1 and
                           abs(sorted_vals[0][1] - sorted_vals[-1][1]) > 5 else "LOW",
        }

    # Fitness delta
    opt_fitness  = best_fitness or (nom_comp or 0.0)
    nom_fitness  = nom_comp or 0.0
    delta_block  = compute_fitness_delta(nom_fitness, opt_fitness)
    delta_str    = delta_block["delta"]

    result["optimizer_data"] = {
        "status":                   "COMPLETE",
        "started_at":               result["optimizer_data"].get("started_at") if result.get("optimizer_data") else _now_iso(),
        "completed_at":             _now_iso(),
        "total_combinations_tested": len(combinations),
        "api_calls_used":           api_calls,
        "search_basis":             search_basis,
        "parameter_sensitivity":    parameter_sensitivity,
        "optimal_parameters":       best_params,
        "parameter_diff":           param_diff,
        "fitness_delta":            delta_block,
    }

    result["summary"]["optimization_delta"] = delta_str
    result["summary"]["passed_rough_cut"]   = True
    _set_pipeline_status(result, "OPTIMIZING")

    return result


# ---------------------------------------------------------------------------
# Pipeline helpers
# ---------------------------------------------------------------------------

def _set_pipeline_status(strategy: dict, status: str) -> None:
    pipeline = strategy.setdefault("pipeline", {})
    pipeline["current_status"] = status
    history = pipeline.setdefault("status_history", [])
    history.append({"status": status, "timestamp": _now_iso()})


def _set_optimizer_status(strategy: dict, status: str, started: bool = False) -> None:
    if strategy.get("optimizer_data") is None:
        strategy["optimizer_data"] = {
            "status": status,
            "started_at": _now_iso() if started else None,
            "completed_at": None,
        }
    else:
        strategy["optimizer_data"]["status"] = status
        if started:
            strategy["optimizer_data"]["started_at"] = _now_iso()


def _mark_error(strategy: dict, error_msg: str) -> None:
    pipeline = strategy.setdefault("pipeline", {})
    pipeline.setdefault("error_log", []).append({"timestamp": _now_iso(), "error": error_msg})
    _set_pipeline_status(strategy, "ERROR")


def _dd_penalty(max_drawdown: float, weight: float) -> float:
    """Tiered drawdown penalty (mirrors scorer.py)."""
    dd = max_drawdown
    if dd <= 5.0:
        return 0.0
    elif dd <= 15.0:
        return (dd - 5.0) / 10.0 * 0.48 * weight * 100.0
    elif dd <= 30.0:
        return (0.48 + (dd - 15.0) / 15.0 * 0.52) * weight * 100.0
    else:
        return weight * 100.0
