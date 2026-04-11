"""
test_logic_auditor.py — Full test suite for logic_auditor.py.

Uses mock-strategy-pending.json as the base valid strategy.
Covers all required tests from the SKILL.md spec plus edge cases.
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

from logic_auditor import (  # noqa: E402
    AuditResult,
    LogicAuditorError,
    LEVERAGED_TICKERS,
    VALID_STEPS,
    audit_strategy,
    walk_nodes,
)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def load_mock(filename: str) -> dict:
    with open(os.path.join(MOCK_DIR, filename)) as f:
        return json.load(f)


@pytest.fixture()
def valid_strategy() -> dict:
    return copy.deepcopy(load_mock("mock-strategy-pending.json"))


@pytest.fixture()
def asset_universe() -> list[str]:
    return load_mock("mock-meta.json")["config"]["asset_universe"]


def set_composer(strategy: dict, cj: dict) -> dict:
    s = copy.deepcopy(strategy)
    s["strategy"]["composer_json"] = cj
    return s


def clear_description(strategy: dict) -> dict:
    s = copy.deepcopy(strategy)
    s["strategy"]["description"] = None
    return s


# Minimal valid 3-layer composer_json matching mock-strategy-pending.json structure
VALID_3LAYER = {
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
            "children": [
                {
                    "step": "if",
                    "children": [
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
                            "children": [
                                {
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
                            ],
                        },
                    ],
                }
            ],
        },
    ],
}


# ---------------------------------------------------------------------------
# walk_nodes utility
# ---------------------------------------------------------------------------

class TestWalkNodes:
    def test_visits_all_nodes(self):
        tree = {
            "step": "if",
            "children": [
                {"step": "if-child", "children": [
                    {"step": "asset", "ticker": "BIL", "children": []}
                ]},
                {"step": "if-child", "children": []},
            ]
        }
        visited = []
        walk_nodes(tree, lambda n: visited.append(n["step"]))
        assert "if" in visited
        assert visited.count("if-child") == 2
        assert "asset" in visited

    def test_visits_root(self):
        node = {"step": "asset", "ticker": "BIL", "children": []}
        visited = []
        walk_nodes(node, lambda n: visited.append(n))
        assert node in visited

    def test_handles_empty_children(self):
        node = {"step": "asset", "ticker": "BIL", "children": []}
        visited = []
        walk_nodes(node, lambda n: visited.append(n))
        assert len(visited) == 1

    def test_non_dict_node_is_noop(self):
        walk_nodes("not a dict", lambda n: None)  # must not raise

    def test_depth_first_order(self):
        tree = {
            "step": "A",
            "children": [
                {"step": "B", "children": [
                    {"step": "D", "children": []}
                ]},
                {"step": "C", "children": []}
            ]
        }
        order = []
        walk_nodes(tree, lambda n: order.append(n["step"]))
        assert order == ["A", "B", "D", "C"]


# ---------------------------------------------------------------------------
# AuditResult and to_dict()
# ---------------------------------------------------------------------------

class TestAuditResultToDict:
    """to_dict() returns correct logic_audit block shape."""

    def test_to_dict_keys(self, valid_strategy, asset_universe):
        result = audit_strategy(valid_strategy, asset_universe)
        d = result.to_dict()
        for key in ["status", "completed_at", "checks", "failures", "warnings", "quarantined"]:
            assert key in d

    def test_to_dict_passed_status(self, valid_strategy, asset_universe):
        result = audit_strategy(valid_strategy, asset_universe)
        assert result.to_dict()["status"] == "PASSED"

    def test_to_dict_quarantined_status(self, valid_strategy, asset_universe):
        bad = set_composer(valid_strategy, {
            "step": "wt-cash-equal",
            "children": [{"step": "asset", "ticker": "AAPL", "children": []}]
        })
        result = audit_strategy(bad, asset_universe)
        assert result.to_dict()["status"] == "QUARANTINED"
        assert result.to_dict()["quarantined"] is True

    def test_to_dict_checks_is_dict(self, valid_strategy, asset_universe):
        result = audit_strategy(valid_strategy, asset_universe)
        assert isinstance(result.to_dict()["checks"], dict)

    def test_to_dict_failures_is_list(self, valid_strategy, asset_universe):
        result = audit_strategy(valid_strategy, asset_universe)
        assert isinstance(result.to_dict()["failures"], list)

    def test_to_dict_completed_at_not_none(self, valid_strategy, asset_universe):
        result = audit_strategy(valid_strategy, asset_universe)
        assert result.to_dict()["completed_at"] is not None


# ---------------------------------------------------------------------------
# Valid 3-layer strategy passes all checks
# ---------------------------------------------------------------------------

class TestValidStrategyPasses:
    """Valid 3-layer strategy passes all checks."""

    def test_passed_is_true(self, valid_strategy, asset_universe):
        result = audit_strategy(valid_strategy, asset_universe)
        assert result.passed is True

    def test_not_quarantined(self, valid_strategy, asset_universe):
        result = audit_strategy(valid_strategy, asset_universe)
        assert result.quarantined is False

    def test_no_failures(self, valid_strategy, asset_universe):
        result = audit_strategy(valid_strategy, asset_universe)
        assert result.failures == []

    def test_all_structural_checks_true(self, valid_strategy, asset_universe):
        result = audit_strategy(valid_strategy, asset_universe)
        from logic_auditor import _STRUCTURAL_CHECK_NAMES
        for name in _STRUCTURAL_CHECK_NAMES:
            assert result.checks[name] is True, f"Structural check '{name}' should be True"

    def test_returns_audit_result_instance(self, valid_strategy, asset_universe):
        result = audit_strategy(valid_strategy, asset_universe)
        assert isinstance(result, AuditResult)


# ---------------------------------------------------------------------------
# valid_node_types_only
# ---------------------------------------------------------------------------

class TestValidNodeTypes:
    """Invalid step type fails valid_node_types_only."""

    def test_invalid_step_fails(self, valid_strategy, asset_universe):
        bad = set_composer(valid_strategy, {"step": "wt-mystery-unknown", "children": []})
        result = audit_strategy(bad, asset_universe)
        assert result.checks["valid_node_types_only"] is False
        assert "valid_node_types_only" in result.failures

    def test_all_valid_steps_pass(self, asset_universe):
        """Each step in VALID_STEPS must be accepted."""
        # wt-inverse-vol needs window-days so test it separately
        steps_without_wt_inv = VALID_STEPS - {"wt-inverse-vol"}
        for step in steps_without_wt_inv:
            node = {"step": step, "children": []}
            strat = {"strategy": {"composer_json": node, "description": None}}
            result = audit_strategy(strat, asset_universe)
            assert result.checks["valid_node_types_only"] is True, \
                f"Step '{step}' should be valid"

    def test_invalid_step_nested_deep(self, valid_strategy, asset_universe):
        bad = copy.deepcopy(valid_strategy)
        bad["strategy"]["composer_json"]["children"][1]["children"] = [
            {"step": "NOT_VALID", "children": []}
        ]
        result = audit_strategy(bad, asset_universe)
        assert result.checks["valid_node_types_only"] is False


# ---------------------------------------------------------------------------
# if_structure_valid and has_else_condition
# ---------------------------------------------------------------------------

class TestIfStructure:
    """Missing else if-child fails if_structure_valid AND has_else_condition."""

    def test_missing_else_fails_both(self, valid_strategy, asset_universe):
        bad = set_composer(valid_strategy, {
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
                }
                # No else branch
            ]
        })
        result = audit_strategy(bad, asset_universe)
        assert result.checks["if_structure_valid"] is False
        assert result.checks["has_else_condition"] is False
        assert "if_structure_valid" in result.failures
        assert "has_else_condition" in result.failures

    def test_no_non_else_fails_if_structure(self, valid_strategy, asset_universe):
        bad = set_composer(valid_strategy, {
            "step": "if",
            "children": [
                {
                    "step": "if-child",
                    "is-else-condition?": True,
                    "children": [{"step": "asset", "ticker": "BIL", "children": []}],
                }
            ]
        })
        result = audit_strategy(bad, asset_universe)
        assert result.checks["if_structure_valid"] is False

    def test_multiple_else_fails(self, valid_strategy, asset_universe):
        bad = set_composer(valid_strategy, {
            "step": "if",
            "children": [
                {
                    "step": "if-child",
                    "lhs-fn": "max-drawdown",
                    "lhs-fn-params": {},
                    "lhs-val": "SVXY",
                    "comparator": "gt",
                    "rhs-val": "10",
                    "rhs-fixed-value?": True,
                    "is-else-condition?": False,
                    "children": [{"step": "asset", "ticker": "BIL", "children": []}],
                },
                {"step": "if-child", "is-else-condition?": True,
                 "children": [{"step": "asset", "ticker": "TQQQ", "children": []}]},
                {"step": "if-child", "is-else-condition?": True,
                 "children": [{"step": "asset", "ticker": "SPY",  "children": []}]},
            ]
        })
        result = audit_strategy(bad, asset_universe)
        assert result.checks["if_structure_valid"] is False


# ---------------------------------------------------------------------------
# window_days_string_format
# ---------------------------------------------------------------------------

class TestWindowDaysStringFormat:
    """wt-inverse-vol with int window-days fails; missing window-days fails."""

    def test_int_window_days_fails(self, valid_strategy, asset_universe):
        bad = set_composer(valid_strategy, {
            "step": "wt-inverse-vol",
            "window-days": 20,   # int — wrong
            "children": [{"step": "asset", "ticker": "TQQQ", "children": []}],
        })
        result = audit_strategy(bad, asset_universe)
        assert result.checks["window_days_string_format"] is False
        assert "window_days_string_format" in result.failures

    def test_missing_window_days_fails(self, valid_strategy, asset_universe):
        """wt-inverse-vol missing window-days field → fail."""
        bad = set_composer(valid_strategy, {
            "step": "wt-inverse-vol",
            # window-days absent
            "children": [{"step": "asset", "ticker": "TQQQ", "children": []}],
        })
        result = audit_strategy(bad, asset_universe)
        assert result.checks["window_days_string_format"] is False

    def test_string_window_days_passes(self, valid_strategy, asset_universe):
        good = set_composer(valid_strategy, {
            "step": "wt-inverse-vol",
            "window-days": "20",   # string — correct
            "children": [{"step": "asset", "ticker": "TQQQ", "children": []}],
        })
        result = audit_strategy(good, asset_universe)
        assert result.checks["window_days_string_format"] is True

    def test_no_wt_inverse_vol_passes_trivially(self, valid_strategy, asset_universe):
        result = audit_strategy(valid_strategy, asset_universe)
        assert result.checks["window_days_string_format"] is True


# ---------------------------------------------------------------------------
# all_assets_in_universe
# ---------------------------------------------------------------------------

class TestAllAssetsInUniverse:
    """Ticker not in universe fails."""

    def test_unknown_ticker_fails(self, valid_strategy, asset_universe):
        bad = set_composer(valid_strategy, {
            "step": "wt-cash-equal",
            "children": [{"step": "asset", "ticker": "AAPL", "children": []}],
        })
        result = audit_strategy(bad, asset_universe)
        assert result.checks["all_assets_in_universe"] is False
        assert "all_assets_in_universe" in result.failures

    def test_all_universe_tickers_valid(self, valid_strategy, asset_universe):
        for ticker in asset_universe:
            strat = set_composer(valid_strategy, {
                "step": "wt-cash-equal",
                "children": [{"step": "asset", "ticker": ticker, "children": []}],
            })
            result = audit_strategy(strat, asset_universe)
            assert result.checks["all_assets_in_universe"] is True, \
                f"Ticker '{ticker}' should be accepted"


# ---------------------------------------------------------------------------
# weights_sum_to_100 (num/den ratio — must sum to 1.0)
# ---------------------------------------------------------------------------

class TestWeightsSumTo100:
    """weights summing to 0.99 passes (within epsilon); 0.90 fails."""

    def test_exactly_1_passes(self, valid_strategy, asset_universe):
        strat = set_composer(valid_strategy, {
            "step": "wt-cash-specified",
            "children": [
                {"step": "asset", "ticker": "TQQQ", "num": 3, "den": 5, "children": []},
                {"step": "asset", "ticker": "BIL",  "num": 2, "den": 5, "children": []},
            ],
        })
        result = audit_strategy(strat, asset_universe)
        assert result.checks["weights_sum_to_100"] is True

    def test_0_99_passes_within_epsilon(self, valid_strategy, asset_universe):
        """0.995 is within epsilon 0.01 of 1.0 → passes."""
        # Use num/den: 199/200 = 0.995, diff from 1.0 = 0.005 < epsilon 0.01
        strat = set_composer(valid_strategy, {
            "step": "wt-cash-specified",
            "children": [
                {"step": "asset", "ticker": "TQQQ", "num": 199, "den": 200, "children": []},
                # total = 0.995 — clearly within epsilon 0.01
            ],
        })
        result = audit_strategy(strat, asset_universe)
        assert result.checks["weights_sum_to_100"] is True

    def test_0_90_fails(self, valid_strategy, asset_universe):
        """0.90 is outside epsilon → fails."""
        strat = set_composer(valid_strategy, {
            "step": "wt-cash-specified",
            "children": [
                {"step": "asset", "ticker": "TQQQ", "weight": 0.60, "children": []},
                {"step": "asset", "ticker": "BIL",  "weight": 0.30, "children": []},
                # total = 0.90 — fails
            ],
        })
        result = audit_strategy(strat, asset_universe)
        assert result.checks["weights_sum_to_100"] is False
        assert "weights_sum_to_100" in result.failures

    def test_no_wt_cash_specified_passes_trivially(self, valid_strategy, asset_universe):
        result = audit_strategy(valid_strategy, asset_universe)
        assert result.checks["weights_sum_to_100"] is True


# ---------------------------------------------------------------------------
# no_leverage_in_defense
# ---------------------------------------------------------------------------

class TestNoLeverageInDefense:
    """Leveraged ETF in crash defensive branch fails."""

    def test_leveraged_in_crash_branch_fails(self, valid_strategy, asset_universe):
        bad = set_composer(valid_strategy, {
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
                    "children": [
                        {"step": "asset", "ticker": "TQQQ", "children": []}  # leveraged in defense
                    ],
                },
                {
                    "step": "if-child",
                    "is-else-condition?": True,
                    "children": [{"step": "asset", "ticker": "BIL", "children": []}],
                },
            ],
        })
        result = audit_strategy(bad, asset_universe)
        assert result.checks["no_leverage_in_defense"] is False
        assert "no_leverage_in_defense" in result.failures

    def test_all_leveraged_tickers_caught(self, valid_strategy, asset_universe):
        for ticker in LEVERAGED_TICKERS:
            bad = set_composer(valid_strategy, {
                "step": "if",
                "children": [
                    {
                        "step": "if-child",
                        "lhs-fn": "max-drawdown",
                        "lhs-fn-params": {},
                        "lhs-val": "SVXY",
                        "comparator": "gt",
                        "rhs-val": "10",
                        "rhs-fixed-value?": True,
                        "is-else-condition?": False,
                        "children": [{"step": "asset", "ticker": ticker, "children": []}],
                    },
                    {
                        "step": "if-child",
                        "is-else-condition?": True,
                        "children": [{"step": "asset", "ticker": "BIL", "children": []}],
                    },
                ],
            })
            result = audit_strategy(bad, asset_universe)
            assert result.checks["no_leverage_in_defense"] is False, \
                f"Leveraged ticker '{ticker}' in defense should fail"

    def test_skipped_when_no_drawdown_guard(self, valid_strategy, asset_universe):
        """No max-drawdown guard → no_leverage_in_defense skipped (None)."""
        strat = set_composer(valid_strategy, {
            "step": "wt-cash-equal",
            "children": [
                {"step": "asset", "ticker": "TQQQ", "children": []},
                {"step": "asset", "ticker": "BIL",  "children": []},
            ],
        })
        # Strip description so crash_guard check doesn't fire
        strat["strategy"]["description"] = None
        result = audit_strategy(strat, asset_universe)
        assert result.checks["no_leverage_in_defense"] is None

    def test_leveraged_in_else_branch_passes(self, valid_strategy, asset_universe):
        """Leveraged in else (normal) branch is fine."""
        result = audit_strategy(valid_strategy, asset_universe)
        assert result.checks["no_leverage_in_defense"] is True


# ---------------------------------------------------------------------------
# bil_in_defensive_branch
# ---------------------------------------------------------------------------

class TestBilInDefensiveBranch:
    """BIL described as crash defense but not in defensive branch fails."""

    def test_passes_when_bil_in_defensive_branch(self, valid_strategy, asset_universe):
        result = audit_strategy(valid_strategy, asset_universe)
        assert result.checks["bil_in_defensive_branch"] is True

    def test_fails_when_bil_in_else_only(self, valid_strategy, asset_universe):
        bad = set_composer(valid_strategy, {
            "step": "if",
            "children": [
                {
                    "step": "if-child",
                    "lhs-fn": "max-drawdown",
                    "lhs-fn-params": {},
                    "lhs-val": "SVXY",
                    "comparator": "gt",
                    "rhs-val": "10",
                    "rhs-fixed-value?": True,
                    "is-else-condition?": False,
                    "children": [{"step": "asset", "ticker": "TQQQ", "children": []}],
                },
                {
                    "step": "if-child",
                    "is-else-condition?": True,
                    "children": [{"step": "asset", "ticker": "BIL", "children": []}],
                },
            ],
        })
        result = audit_strategy(bad, asset_universe)
        assert result.checks["bil_in_defensive_branch"] is False
        assert "bil_in_defensive_branch" in result.failures

    def test_skipped_when_crash_desc_no_bil(self, valid_strategy, asset_universe):
        """If crash regime description doesn't mention BIL → skipped (None)."""
        strat = copy.deepcopy(valid_strategy)
        strat["strategy"]["description"]["regime_behavior"] = {"crash": "holds cash"}
        result = audit_strategy(strat, asset_universe)
        assert result.checks["bil_in_defensive_branch"] is None


# ---------------------------------------------------------------------------
# Empty JSON fails all structural checks
# ---------------------------------------------------------------------------

class TestEmptyComposerJson:
    """Empty JSON fails all structural checks."""

    def test_empty_dict_fails_all_structural(self, asset_universe):
        strat = {"strategy": {"composer_json": {}, "description": None}}
        result = audit_strategy(strat, asset_universe)
        from logic_auditor import _STRUCTURAL_CHECK_NAMES
        for name in _STRUCTURAL_CHECK_NAMES:
            assert result.checks[name] is False, \
                f"Structural check '{name}' should be False for empty JSON"
        assert result.quarantined is True

    def test_none_composer_json_fails_structural(self, asset_universe):
        strat = {"strategy": {"composer_json": None, "description": None}}
        result = audit_strategy(strat, asset_universe)
        assert result.quarantined is True

    def test_missing_strategy_block_raises(self, asset_universe):
        with pytest.raises(LogicAuditorError):
            audit_strategy({}, asset_universe)

    def test_consistency_checks_skipped_for_empty_json(self, asset_universe):
        strat = {"strategy": {"composer_json": {}, "description": None}}
        result = audit_strategy(strat, asset_universe)
        from logic_auditor import _CONSISTENCY_CHECK_NAMES
        for name in _CONSISTENCY_CHECK_NAMES:
            assert result.checks[name] is None, \
                f"Consistency check '{name}' should be None (skipped) for empty JSON"

    def test_empty_json_warning_message(self, asset_universe):
        strat = {"strategy": {"composer_json": {}, "description": None}}
        result = audit_strategy(strat, asset_universe)
        assert any("empty_json" in w for w in result.warnings)


# ---------------------------------------------------------------------------
# Missing description skips consistency checks
# ---------------------------------------------------------------------------

class TestMissingDescription:
    """Missing description: skip consistency checks (record None)."""

    def test_none_description_skips_consistency(self, valid_strategy, asset_universe):
        strat = clear_description(valid_strategy)
        result = audit_strategy(strat, asset_universe)
        from logic_auditor import _CONSISTENCY_CHECK_NAMES
        for name in _CONSISTENCY_CHECK_NAMES:
            assert result.checks[name] is None, \
                f"Consistency check '{name}' should be None when description missing"

    def test_none_description_structural_checks_still_run(self, valid_strategy, asset_universe):
        strat = clear_description(valid_strategy)
        result = audit_strategy(strat, asset_universe)
        from logic_auditor import _STRUCTURAL_CHECK_NAMES
        for name in _STRUCTURAL_CHECK_NAMES:
            assert result.checks[name] is not None, \
                f"Structural check '{name}' should still run without description"

    def test_skipped_checks_do_not_cause_quarantine(self, valid_strategy, asset_universe):
        strat = clear_description(valid_strategy)
        result = audit_strategy(strat, asset_universe)
        assert result.passed is True
        assert result.quarantined is False


# ---------------------------------------------------------------------------
# Warnings do not cause quarantine
# ---------------------------------------------------------------------------

class TestWarningsDoNotQuarantine:
    """Warnings never cause quarantine."""

    def test_non_empty_asset_children_warns_not_fails(self, valid_strategy, asset_universe):
        """Asset node with non-empty children → warning only, not failure."""
        # Use a neutral description so no consistency checks fire
        strat = copy.deepcopy(valid_strategy)
        strat["strategy"]["description"] = None   # skip consistency checks
        strat = set_composer(strat, {
            "step": "wt-cash-equal",
            "children": [
                {
                    "step": "asset",
                    "ticker": "TQQQ",
                    "children": [{"step": "asset", "ticker": "BIL", "children": []}],
                },
            ],
        })
        result = audit_strategy(strat, asset_universe)
        # asset_nodes_have_children check passes (children present, just non-empty → warn)
        assert result.checks["asset_nodes_have_children"] is True
        assert any("non-empty children" in w for w in result.warnings)
        assert result.quarantined is False

    def test_quarantine_false_with_only_warnings(self, valid_strategy, asset_universe):
        strat = copy.deepcopy(valid_strategy)
        strat["strategy"]["description"] = None
        strat = set_composer(strat, {
            "step": "wt-cash-equal",
            "children": [
                {
                    "step": "asset", "ticker": "TQQQ",
                    "children": [{"step": "asset", "ticker": "BIL", "children": []}],
                },
            ],
        })
        result = audit_strategy(strat, asset_universe)
        assert result.quarantined is False
        assert result.passed is True


# ---------------------------------------------------------------------------
# Multi-failure quarantine
# ---------------------------------------------------------------------------

class TestMultipleFailures:
    def test_multiple_failures_all_listed(self, valid_strategy, asset_universe):
        bad = set_composer(valid_strategy, {
            "step": "wt-cash-specified",
            "children": [
                {"step": "asset", "ticker": "AAPL", "weight": 0.60, "children": []},
                {"step": "asset", "ticker": "GOOG", "weight": 0.20, "children": []},
                # total 0.80 — fails weights; AAPL, GOOG not in universe
            ],
        })
        result = audit_strategy(bad, asset_universe)
        assert "all_assets_in_universe" in result.failures
        assert "weights_sum_to_100" in result.failures
        assert result.quarantined is True

    def test_all_check_names_present_in_checks_dict(self, valid_strategy, asset_universe):
        result = audit_strategy(valid_strategy, asset_universe)
        from logic_auditor import _ALL_CHECK_NAMES
        for name in _ALL_CHECK_NAMES:
            assert name in result.checks, f"Missing check: {name}"


# ---------------------------------------------------------------------------
# rhs_fixed_value_present
# ---------------------------------------------------------------------------

class TestRhsFixedValuePresent:
    def test_passes_when_rhs_fixed_value_true(self, valid_strategy, asset_universe):
        result = audit_strategy(valid_strategy, asset_universe)
        assert result.checks["rhs_fixed_value_present"] is True

    def test_fails_when_rhs_fixed_value_false(self, valid_strategy, asset_universe):
        bad = copy.deepcopy(valid_strategy)
        bad["strategy"]["composer_json"]["children"][0]["rhs-fixed-value?"] = False
        result = audit_strategy(bad, asset_universe)
        assert result.checks["rhs_fixed_value_present"] is False
        assert "rhs_fixed_value_present" in result.failures

    def test_fails_when_rhs_fixed_value_missing(self, valid_strategy, asset_universe):
        bad = copy.deepcopy(valid_strategy)
        del bad["strategy"]["composer_json"]["children"][0]["rhs-fixed-value?"]
        result = audit_strategy(bad, asset_universe)
        assert result.checks["rhs_fixed_value_present"] is False

    def test_else_branch_without_rhs_val_passes(self, valid_strategy, asset_universe):
        """Else if-child has no rhs-val so rhs_fixed_value check doesn't apply."""
        result = audit_strategy(valid_strategy, asset_universe)
        assert result.checks["rhs_fixed_value_present"] is True
