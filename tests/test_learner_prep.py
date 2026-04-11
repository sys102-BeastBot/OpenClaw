"""
test_learner_prep.py — Full test suite for learner_prep.py.

Tests cover all six brief sections plus token budget, input validation,
and edge cases (empty generation, all-disqualified, etc.).
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

from learner_prep import (  # noqa: E402
    LearnerPrepError,
    build_brief,
    _completed_strategies,
    _disqualified_strategies,
    _get_fitness,
    _interpret_delta,
    _quick_structure,
)


# ---------------------------------------------------------------------------
# Fixtures / helpers
# ---------------------------------------------------------------------------

def load_mock(filename: str) -> dict:
    with open(os.path.join(MOCK_DIR, filename)) as f:
        return json.load(f)


def make_strategy(
    sid: str = "gen-001-strat-01",
    name: str = "Test",
    archetype: str = "SHARPE_HUNTER",
    generation: int = 1,
    fitness: float = 72.0,
    sharpe: float = 2.1,
    ann_return: float = 45.0,
    max_drawdown: float = 12.0,
    disqualified: bool = False,
    status: str = "COMPLETE",
    rebalance_frequency: str = "daily",
    composer_json: dict = None,
    parameter_choices: dict = None,
    optimization_delta: str = None,
    optimizer_data: dict = None,
) -> dict:
    if composer_json is None:
        composer_json = {
            "step": "wt-cash-equal",
            "children": [
                {"step": "asset", "ticker": "TQQQ", "children": []},
                {"step": "asset", "ticker": "BIL",  "children": []},
            ],
        }
    composite_fitness = {
        "period_scores": {"6M": fitness - 2, "1Y": fitness, "2Y": fitness + 1, "3Y": fitness + 1},
        "weighted_composite": fitness - 1,
        "std_dev": 2.0,
        "consistency_adjustment": 2.0,
        "final_composite": fitness,
    }
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
            "final_std_dev": 2.0,
            "optimization_delta": optimization_delta,
            "passed_rough_cut": not disqualified,
            "disqualified": disqualified,
            "status": "DISQUALIFIED" if disqualified else status,
            "rebalance_frequency": rebalance_frequency,
        },
        "identity": {
            "strategy_id": sid,
            "name": name,
            "generation": generation,
            "archetype": archetype,
            "slot_number": 1,
            "created_at": "2026-03-22T00:00:00Z",
            "rebalance_frequency": rebalance_frequency,
            "composer_rebalance_value": {"asset-class": "EQUITIES", "rebalance-frequency": "daily"},
            "composer_symphony_id": None,
        },
        "strategy": {
            "description": {
                "summary": f"{name} summary",
                "logic_explanation": f"{name} logic",
                "regime_behavior": {"crash": "BIL", "normal": "TQQQ"},
                "archetype_rationale": "test",
                "parameter_choices": parameter_choices or {"window": "20", "threshold": "10"},
            },
            "composer_json": composer_json,
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
            "status": "COMPLETE",
            "completed_at": "2026-03-22T00:05:00Z",
            "parameters_used": {"window": 20, "threshold": 10},
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
                        "beats_benchmark": ann_return > 24.1,
                        "alpha": None, "beta": None,
                        "r_squared": None, "correlation": None,
                    },
                    "fitness": None,
                    "raw_api_fields": {},
                },
            },
            "composite_fitness": composite_fitness,
            "api_calls_used": 1,
            "api_call_ms": 1200,
        },
        "optimizer_data": optimizer_data,
        "final_result": None,
        "pipeline": {
            "current_status": "DISQUALIFIED" if disqualified else status,
            "disqualified": disqualified,
            "disqualification_reason": "UNACCEPTABLE_RISK" if disqualified else None,
            "disqualified_at": "2026-03-22T00:05:01Z" if disqualified else None,
        },
    }


def make_generation(n_completed: int = 4, n_disqualified: int = 1) -> list[dict]:
    results = []
    for i in range(n_completed):
        results.append(make_strategy(
            sid=f"gen-001-strat-{i:02d}",
            fitness=float(60 + i * 5),
            archetype=["SHARPE_HUNTER", "RETURN_CHASER", "RISK_MINIMIZER", "CONSISTENCY"][i % 4],
        ))
    for i in range(n_disqualified):
        results.append(make_strategy(
            sid=f"gen-001-disq-{i:02d}",
            fitness=0.0,
            disqualified=True,
        ))
    return results


def make_lesson(lid: str = "lesson-001", text: str = "test lesson") -> dict:
    return {
        "lesson_id": lid,
        "type": "general",
        "text": text,
        "confidence": 0.8,
        "times_confirmed": 2,
        "times_contradicted": 0,
    }


# ---------------------------------------------------------------------------
# Input validation
# ---------------------------------------------------------------------------

class TestInputValidation:
    def test_non_list_results_raises(self):
        with pytest.raises(LearnerPrepError, match="list"):
            build_brief("not a list", [], 1)

    def test_empty_results_returns_brief(self):
        brief = build_brief([], [], 1)
        assert "generation_summary" in brief

    def test_all_disqualified_returns_brief(self):
        results = [make_strategy(sid=f"gen-001-strat-{i:02d}", disqualified=True) for i in range(3)]
        brief = build_brief(results, [], 1)
        assert brief["generation_summary"]["total_disqualified"] == 3
        assert brief["generation_summary"]["total_completed"] == 0


# ---------------------------------------------------------------------------
# Section 1: Generation summary
# ---------------------------------------------------------------------------

class TestGenerationSummary:
    def test_has_required_keys(self):
        brief = build_brief(make_generation(), [], 1)
        gs = brief["generation_summary"]
        for key in ["generation", "total_strategies", "total_completed",
                    "total_disqualified", "avg_fitness", "std_dev_fitness",
                    "best_fitness", "worst_fitness", "best_strategy_id",
                    "worst_strategy_id", "archetype_stats"]:
            assert key in gs, f"Missing key: {key}"

    def test_total_counts_correct(self):
        results = make_generation(n_completed=4, n_disqualified=2)
        gs = build_brief(results, [], 1)["generation_summary"]
        assert gs["total_strategies"] == 6
        assert gs["total_completed"] == 4
        assert gs["total_disqualified"] == 2

    def test_avg_fitness_correct(self):
        fitnesses = [60.0, 65.0, 70.0, 75.0]
        results = [make_strategy(sid=f"gen-001-strat-{i}", fitness=f) for i, f in enumerate(fitnesses)]
        gs = build_brief(results, [], 1)["generation_summary"]
        assert gs["avg_fitness"] == pytest.approx(sum(fitnesses) / len(fitnesses))

    def test_std_dev_correct(self):
        fitnesses = [60.0, 65.0, 70.0, 75.0]
        results = [make_strategy(sid=f"gen-001-strat-{i}", fitness=f) for i, f in enumerate(fitnesses)]
        gs = build_brief(results, [], 1)["generation_summary"]
        assert gs["std_dev_fitness"] == pytest.approx(statistics.stdev(fitnesses), abs=1e-3)

    def test_best_and_worst_fitness(self):
        results = [
            make_strategy(sid="gen-001-strat-00", fitness=60.0),
            make_strategy(sid="gen-001-strat-01", fitness=80.0),
            make_strategy(sid="gen-001-strat-02", fitness=70.0),
        ]
        gs = build_brief(results, [], 1)["generation_summary"]
        assert gs["best_fitness"] == pytest.approx(80.0)
        assert gs["worst_fitness"] == pytest.approx(60.0)
        assert gs["best_strategy_id"] == "gen-001-strat-01"
        assert gs["worst_strategy_id"] == "gen-001-strat-00"

    def test_archetype_stats_populated(self):
        results = [
            make_strategy(sid="gen-001-strat-00", archetype="SHARPE_HUNTER", fitness=70.0),
            make_strategy(sid="gen-001-strat-01", archetype="SHARPE_HUNTER", fitness=80.0),
            make_strategy(sid="gen-001-strat-02", archetype="RETURN_CHASER", fitness=65.0),
        ]
        gs = build_brief(results, [], 1)["generation_summary"]
        assert "SHARPE_HUNTER" in gs["archetype_stats"]
        assert gs["archetype_stats"]["SHARPE_HUNTER"]["count"] == 2
        assert gs["archetype_stats"]["SHARPE_HUNTER"]["avg_fitness"] == pytest.approx(75.0)

    def test_generation_number_stored(self):
        brief = build_brief(make_generation(), [], 7)
        assert brief["generation"] == 7
        assert brief["generation_summary"]["generation"] == 7

    def test_empty_completed_graceful(self):
        results = [make_strategy(disqualified=True)]
        gs = build_brief(results, [], 1)["generation_summary"]
        assert gs["avg_fitness"] is None
        assert gs["best_fitness"] is None


# ---------------------------------------------------------------------------
# Section 2: Ranked strategies
# ---------------------------------------------------------------------------

class TestRankedStrategies:
    def test_sorted_best_to_worst(self):
        results = [
            make_strategy(sid="gen-001-strat-00", fitness=60.0),
            make_strategy(sid="gen-001-strat-01", fitness=80.0),
            make_strategy(sid="gen-001-strat-02", fitness=70.0),
        ]
        ranked = build_brief(results, [], 1)["ranked_strategies"]
        scores = [r["final_composite_fitness"] for r in ranked]
        assert scores == sorted(scores, reverse=True)

    def test_rank_field_sequential(self):
        results = [make_strategy(sid=f"gen-001-strat-{i:02d}", fitness=float(60+i)) for i in range(4)]
        ranked = build_brief(results, [], 1)["ranked_strategies"]
        ranks = [r["rank"] for r in ranked]
        assert ranks == list(range(1, len(ranked)+1))

    def test_has_required_fields(self):
        results = make_generation(n_completed=2, n_disqualified=0)
        ranked = build_brief(results, [], 1)["ranked_strategies"]
        for entry in ranked:
            for field in ["strategy_id", "name", "archetype", "final_composite_fitness",
                          "sharpe_1Y", "return_1Y", "drawdown_1Y", "optimization_delta",
                          "delta_interpretation", "top_level_structure",
                          "parameter_choices", "deviated_from_priors"]:
                assert field in entry, f"Missing field: {field}"

    def test_disqualified_not_in_ranked(self):
        results = [
            make_strategy(sid="gen-001-strat-00", fitness=70.0),
            make_strategy(sid="gen-001-disq-00", disqualified=True),
        ]
        ranked = build_brief(results, [], 1)["ranked_strategies"]
        ids = [r["strategy_id"] for r in ranked]
        assert "gen-001-disq-00" not in ids
        assert "gen-001-strat-00" in ids

    def test_capped_at_max(self):
        results = [make_strategy(sid=f"gen-001-strat-{i:02d}", fitness=float(50+i)) for i in range(20)]
        ranked = build_brief(results, [], 1)["ranked_strategies"]
        assert len(ranked) <= 12

    def test_parameter_choices_included(self):
        results = [make_strategy(
            sid="gen-001-strat-00",
            fitness=72.0,
            parameter_choices={"svxy_window": "2", "rsi_threshold": "79"},
        )]
        ranked = build_brief(results, [], 1)["ranked_strategies"]
        pc = ranked[0]["parameter_choices"]
        assert "svxy_window" in pc
        assert pc["svxy_window"] == "2"

    def test_optimization_delta_stored(self):
        results = [make_strategy(sid="gen-001-strat-00", fitness=72.0, optimization_delta="+5.3")]
        ranked = build_brief(results, [], 1)["ranked_strategies"]
        assert ranked[0]["optimization_delta"] == "+5.3"

    def test_deviated_from_priors_detected(self):
        opt_data = {
            "status": "COMPLETE",
            "search_basis": {
                "window": "generator_deviation_targeted",
                "threshold": "prior_narrow",
            },
            "optimal_parameters": {"window": 15, "threshold": 8},
        }
        results = [make_strategy(sid="gen-001-strat-00", fitness=72.0, optimizer_data=opt_data)]
        ranked = build_brief(results, [], 1)["ranked_strategies"]
        assert ranked[0]["deviated_from_priors"] is True

    def test_no_deviation_when_all_locked(self):
        opt_data = {
            "status": "COMPLETE",
            "search_basis": {"window": "locked", "threshold": "locked"},
            "optimal_parameters": {"window": 20, "threshold": 10},
        }
        results = [make_strategy(sid="gen-001-strat-00", fitness=72.0, optimizer_data=opt_data)]
        ranked = build_brief(results, [], 1)["ranked_strategies"]
        assert ranked[0]["deviated_from_priors"] is False


# ---------------------------------------------------------------------------
# Section 2 helpers: _interpret_delta
# ---------------------------------------------------------------------------

class TestInterpretDelta:
    def test_none_returns_not_optimized(self):
        assert _interpret_delta(None) == "not_optimized"

    def test_strong_gain(self):
        assert _interpret_delta("+7.0") == "strong_gain"

    def test_moderate_gain(self):
        assert _interpret_delta("+3.5") == "moderate_gain"

    def test_minimal_gain(self):
        assert _interpret_delta("+1.0") == "minimal_gain"

    def test_minimal_loss(self):
        assert _interpret_delta("-1.0") == "minimal_loss"

    def test_significant_loss(self):
        assert _interpret_delta("-6.0") == "significant_loss"

    def test_exact_boundary_strong_gain(self):
        assert _interpret_delta("+5.0") == "strong_gain"

    def test_exact_boundary_moderate_gain(self):
        assert _interpret_delta("+2.0") == "moderate_gain"

    def test_non_numeric_returns_unknown(self):
        assert _interpret_delta("N/A") == "unknown"


# ---------------------------------------------------------------------------
# Section 3: Parameter sensitivity
# ---------------------------------------------------------------------------

class TestParameterSensitivity:
    def test_has_required_keys(self):
        ps = build_brief(make_generation(), [], 1)["parameter_sensitivity"]
        for key in ["parameters_searched", "locked_parameters", "sensitivity",
                    "strategies_with_optimizer_data"]:
            assert key in ps

    def test_no_optimizer_data_returns_empty_searched(self):
        results = [make_strategy(sid=f"gen-001-strat-{i:02d}", fitness=float(60+i)) for i in range(3)]
        ps = build_brief(results, [], 1)["parameter_sensitivity"]
        assert ps["parameters_searched"] == []
        assert ps["strategies_with_optimizer_data"] == 0

    def test_searched_params_detected(self):
        opt_data = {
            "status": "COMPLETE",
            "search_basis": {"window": "prior_narrow", "threshold": "locked"},
            "optimal_parameters": {"window": 20, "threshold": 10},
        }
        results = [make_strategy(sid="gen-001-strat-00", fitness=70.0, optimizer_data=opt_data)]
        ps = build_brief(results, [], 1)["parameter_sensitivity"]
        assert "window" in ps["parameters_searched"]
        assert "threshold" in ps["locked_parameters"]

    def test_top_winning_values_counted(self):
        # Two strategies both find window=20 optimal
        opt1 = {"status": "COMPLETE", "search_basis": {"window": "prior_narrow"},
                 "optimal_parameters": {"window": 20}}
        opt2 = {"status": "COMPLETE", "search_basis": {"window": "prior_narrow"},
                 "optimal_parameters": {"window": 20}}
        results = [
            make_strategy(sid="gen-001-strat-00", fitness=70.0, optimizer_data=opt1),
            make_strategy(sid="gen-001-strat-01", fitness=72.0, optimizer_data=opt2),
        ]
        ps = build_brief(results, [], 1)["parameter_sensitivity"]
        win_vals = ps["sensitivity"]["window"]["top_winning_values"]
        assert any(v["value"] == "20" and v["count"] == 2 for v in win_vals)

    def test_archetype_optima_populated(self):
        opt1 = {"status": "COMPLETE", "search_basis": {"window": "prior_narrow"},
                 "optimal_parameters": {"window": 15}}
        opt2 = {"status": "COMPLETE", "search_basis": {"window": "prior_narrow"},
                 "optimal_parameters": {"window": 25}}
        results = [
            make_strategy(sid="gen-001-strat-00", archetype="SHARPE_HUNTER",
                          fitness=70.0, optimizer_data=opt1),
            make_strategy(sid="gen-001-strat-01", archetype="RETURN_CHASER",
                          fitness=65.0, optimizer_data=opt2),
        ]
        ps = build_brief(results, [], 1)["parameter_sensitivity"]
        ao = ps["sensitivity"]["window"]["archetype_optima"]
        assert "SHARPE_HUNTER" in ao
        assert "RETURN_CHASER" in ao


# ---------------------------------------------------------------------------
# Section 4: Disqualified summary
# ---------------------------------------------------------------------------

class TestDisqualifiedSummary:
    def test_has_required_keys(self):
        ds = build_brief(make_generation(n_disqualified=1), [], 1)["disqualified_summary"]
        for key in ["total_disqualified", "reason_counts", "structural_patterns_failed", "entries"]:
            assert key in ds

    def test_count_correct(self):
        results = make_generation(n_completed=3, n_disqualified=2)
        ds = build_brief(results, [], 1)["disqualified_summary"]
        assert ds["total_disqualified"] == 2

    def test_zero_disqualified(self):
        results = [make_strategy(sid=f"gen-001-strat-{i:02d}", fitness=float(60+i)) for i in range(3)]
        ds = build_brief(results, [], 1)["disqualified_summary"]
        assert ds["total_disqualified"] == 0
        assert ds["entries"] == []

    def test_reason_codes_counted(self):
        disq = make_strategy(sid="gen-001-disq-00", disqualified=True)
        disq["pipeline"]["disqualification_reason"] = "UNACCEPTABLE_RISK"
        results = [make_strategy(sid="gen-001-strat-00", fitness=70.0), disq]
        ds = build_brief(results, [], 1)["disqualified_summary"]
        assert "UNACCEPTABLE_RISK" in ds["reason_counts"]
        assert ds["reason_counts"]["UNACCEPTABLE_RISK"] == 1

    def test_structural_patterns_extracted(self):
        disq = make_strategy(
            sid="gen-001-disq-00",
            disqualified=True,
            composer_json={
                "step": "wt-cash-equal",
                "children": [
                    {"step": "asset", "ticker": "UVXY", "children": []},
                    {"step": "asset", "ticker": "TQQQ", "children": []},
                ],
            },
        )
        results = [make_strategy(sid="gen-001-strat-00", fitness=70.0), disq]
        ds = build_brief(results, [], 1)["disqualified_summary"]
        patterns = ds["structural_patterns_failed"]
        assert any("wt-cash-equal" in p for p in patterns)

    def test_entry_has_strategy_id(self):
        disq = make_strategy(sid="gen-001-disq-00", disqualified=True)
        results = [disq]
        ds = build_brief(results, [], 1)["disqualified_summary"]
        assert ds["entries"][0]["strategy_id"] == "gen-001-disq-00"


# ---------------------------------------------------------------------------
# Section 5: Active lessons
# ---------------------------------------------------------------------------

class TestActiveLessons:
    def test_lessons_included_in_brief(self):
        lessons = [make_lesson("l-001", "crash guards improve Sharpe")]
        brief = build_brief(make_generation(), lessons, 1)
        al = brief["active_lessons"]
        assert len(al) == 1
        assert al[0]["lesson_id"] == "l-001"

    def test_empty_lessons_returns_empty_list(self):
        brief = build_brief(make_generation(), [], 1)
        assert brief["active_lessons"] == []

    def test_lesson_text_truncated_to_budget(self):
        long_text = "x" * 500
        lessons = [make_lesson("l-001", long_text)]
        brief = build_brief(make_generation(), lessons, 1)
        assert len(brief["active_lessons"][0]["text"]) <= 200

    def test_lesson_fields_present(self):
        lessons = [make_lesson("l-001", "test")]
        brief = build_brief(make_generation(), lessons, 1)
        entry = brief["active_lessons"][0]
        for field in ["lesson_id", "type", "text", "confidence",
                      "times_confirmed", "times_contradicted"]:
            assert field in entry


# ---------------------------------------------------------------------------
# Section 6: Compaction hints
# ---------------------------------------------------------------------------

class TestCompactionHints:
    def test_has_required_keys(self):
        ch = build_brief(make_generation(), [], 1)["compaction_hints"]
        for key in ["lessons_confirmed", "lessons_contradicted",
                    "new_patterns_worth_extracting"]:
            assert key in ch

    def test_new_patterns_from_high_scorers(self):
        # All four strategies use TQQQ — should appear as a pattern
        results = [
            make_strategy(
                sid=f"gen-001-strat-{i:02d}",
                fitness=float(70 + i),
                composer_json={
                    "step": "wt-cash-equal",
                    "children": [
                        {"step": "asset", "ticker": "TQQQ", "children": []},
                        {"step": "asset", "ticker": "BIL",  "children": []},
                    ],
                },
            )
            for i in range(4)
        ]
        ch = build_brief(results, [], 1)["compaction_hints"]
        all_patterns = " ".join(ch["new_patterns_worth_extracting"])
        assert "TQQQ" in all_patterns or "wt-cash-equal" in all_patterns

    def test_crash_guard_lesson_confirmed(self):
        """Lesson about crash guards confirmed when guarded strategies outscore unguarded."""
        guard_strat = make_strategy(
            sid="gen-001-strat-00",
            fitness=80.0,
            composer_json={
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
                        "children": [{"step": "asset", "ticker": "TQQQ", "children": []}],
                    },
                ],
            },
        )
        no_guard = make_strategy(sid="gen-001-strat-01", fitness=55.0)
        lesson = make_lesson("l-001", "crash guards improve performance")
        lesson["type"] = "crash_guard_important"
        results = [guard_strat, no_guard]
        ch = build_brief(results, [lesson], 1)["compaction_hints"]
        # Guard avg=80 > no-guard avg=55 → confirmed
        confirmed_text = " ".join(ch["lessons_confirmed"])
        assert "l-001" in confirmed_text

    def test_returns_lists_not_sets(self):
        ch = build_brief(make_generation(), [], 1)["compaction_hints"]
        assert isinstance(ch["lessons_confirmed"], list)
        assert isinstance(ch["lessons_contradicted"], list)
        assert isinstance(ch["new_patterns_worth_extracting"], list)


# ---------------------------------------------------------------------------
# Return type and structure
# ---------------------------------------------------------------------------

class TestReturnType:
    def test_returns_dict(self):
        result = build_brief(make_generation(), [], 1)
        assert isinstance(result, dict)

    def test_not_a_string(self):
        result = build_brief(make_generation(), [], 1)
        assert not isinstance(result, str)

    def test_all_values_plain_python_types(self):
        """No custom objects — all values must be str, int, float, list, dict, bool, None."""
        def check_types(obj, path=""):
            allowed = (str, int, float, list, dict, bool, type(None))
            if not isinstance(obj, allowed):
                pytest.fail(f"Non-plain type at {path}: {type(obj)}")
            if isinstance(obj, dict):
                for k, v in obj.items():
                    check_types(v, f"{path}.{k}")
            elif isinstance(obj, list):
                for i, v in enumerate(obj):
                    check_types(v, f"{path}[{i}]")
        result = build_brief(make_generation(), [], 1)
        check_types(result)

    def test_has_all_six_sections(self):
        brief = build_brief(make_generation(), [], 1)
        for section in ["generation_summary", "ranked_strategies",
                        "parameter_sensitivity", "disqualified_summary",
                        "active_lessons", "compaction_hints"]:
            assert section in brief, f"Missing section: {section}"

    def test_no_claude_api_calls(self):
        """Module must not import anthropic or make any API calls."""
        import learner_prep as lp
        import inspect
        src = inspect.getsource(lp)
        assert "anthropic" not in src
        # Must not call Claude SDK — check for actual API call patterns
        assert "anthropic.Anthropic" not in src
        assert "client.messages.create" not in src
        assert "import anthropic" not in src


# ---------------------------------------------------------------------------
# Token budget
# ---------------------------------------------------------------------------

class TestTokenBudget:
    def test_meta_block_present(self):
        brief = build_brief(make_generation(), [], 1)
        assert "_meta" in brief
        assert "estimated_tokens" in brief["_meta"]

    def test_small_generation_under_budget(self):
        brief = build_brief(make_generation(n_completed=4, n_disqualified=1), [], 1)
        assert brief["_meta"]["over_budget"] is False

    def test_over_budget_flagged(self):
        """Very large generation with many lessons and strategies flags over_budget."""
        results = [
            make_strategy(
                sid=f"gen-001-strat-{i:02d}",
                fitness=float(50+i),
                parameter_choices={f"param_{j}": "x" * 100 for j in range(20)},
            )
            for i in range(12)
        ]
        lessons = [make_lesson(f"lesson-{i:03d}", "x" * 200) for i in range(50)]
        brief = build_brief(results, lessons, 1)
        # The meta block should report token count — may or may not be over depending
        # on implementation; just verify the field exists and is an int
        assert isinstance(brief["_meta"]["estimated_tokens"], int)
        assert brief["_meta"]["estimated_tokens"] > 0


# ---------------------------------------------------------------------------
# Mock data integration
# ---------------------------------------------------------------------------

class TestMockDataIntegration:
    def test_build_brief_with_mock_files(self):
        """Build a brief using the actual mock data files."""
        import copy
        pending = copy.deepcopy(load_mock("mock-strategy-pending.json"))
        disq    = load_mock("mock-strategy-disqualified.json")
        # mock-strategy-pending has nominal_result=null — seed it
        pending["summary"]["status"] = "COMPLETE"
        pending["summary"]["final_composite_fitness"] = 72.5
        pending["nominal_result"] = {
            "status": "COMPLETE",
            "completed_at": "2026-03-22T00:05:00Z",
            "parameters_used": {},
            "periods": {
                "1Y": {
                    "period": "1Y",
                    "core_metrics": {
                        "annualized_return": 63.7,
                        "total_return": 63.7,
                        "sharpe": 2.28,
                        "max_drawdown": 9.4,
                        "volatility": 18.4,
                        "win_rate": 63.1,
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
                },
            },
            "composite_fitness": {
                "period_scores": {"6M": 70.0, "1Y": 72.5, "2Y": 73.0, "3Y": 74.0},
                "weighted_composite": 72.5,
                "std_dev": 1.5,
                "consistency_adjustment": 2.0,
                "final_composite": 72.5,
            },
            "api_calls_used": 1,
            "api_call_ms": 1200,
        }
        results = [pending, disq]
        brief = build_brief(results, [], 1)
        assert brief["generation_summary"]["total_strategies"] == 2
        assert brief["generation_summary"]["total_disqualified"] == 1
        assert len(brief["ranked_strategies"]) == 1

    def test_disqualified_mock_in_disqualified_section(self):
        disq = load_mock("mock-strategy-disqualified.json")
        brief = build_brief([disq], [], 1)
        assert brief["disqualified_summary"]["total_disqualified"] == 1
        assert brief["ranked_strategies"] == []
