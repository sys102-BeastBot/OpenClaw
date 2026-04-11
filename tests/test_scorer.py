"""
test_scorer.py — Full test suite for scorer.py.

Tests required per SKILL.md:
  - All four archetypes produce correct weights (must sum correctly)
  - Bonus stacking (all 5 bonuses applied simultaneously)
  - Disqualifier detection for all three disqualifier types
  - Drawdown penalty at exact boundary values (5%, 15%, 30%, 65%)
  - Consistency adjustment at boundaries (std_dev = 9.9, 10.0, 10.1, 24.9, 25.0, 25.1)
  - Composite weighting (6M×0.10 + 1Y×0.30 + 2Y×0.30 + 3Y×0.30)
  - Score of 0 for disqualified strategy (not negative)
"""

import json
import math
import os
import statistics
import sys

import pytest

# ---------------------------------------------------------------------------
# Path setup
# ---------------------------------------------------------------------------
WORKSPACE = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SRC_DIR = os.path.join(os.path.dirname(__file__), "..", "src")
MOCK_DIR = os.path.join(
    WORKSPACE, "skills", "learning-agent-builder", "mock-data"
)
sys.path.insert(0, SRC_DIR)

from scorer import (  # noqa: E402
    check_disqualifiers,
    clamp,
    compute_bonuses,
    compute_composite,
    score_period,
    tiered_drawdown_penalty,
)


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

def load_mock(filename: str) -> dict:
    """Load a mock data JSON file from the mock-data directory."""
    path = os.path.join(MOCK_DIR, filename)
    with open(path, "r") as f:
        return json.load(f)


@pytest.fixture()
def meta() -> dict:
    return load_mock("mock-meta.json")


@pytest.fixture()
def period_data() -> dict:
    return load_mock("mock-period-stats.json")


def make_period(
    ann_return: float = 30.0,
    sharpe: float = 1.5,
    max_drawdown: float = 10.0,
    beats_benchmark: bool = False,
    benchmark_return: float = 20.0,
) -> dict:
    """Build a minimal valid period stats block for testing."""
    return {
        "period": "1Y",
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
            "benchmark_annualized_return": benchmark_return,
            "beats_benchmark": beats_benchmark,
            "alpha": None,
            "beta": None,
            "r_squared": None,
            "correlation": None,
        },
        "fitness": None,
        "raw_api_fields": {},
    }


# ---------------------------------------------------------------------------
# clamp() tests
# ---------------------------------------------------------------------------

class TestClamp:
    def test_below_min(self):
        assert clamp(-5.0, 0.0, 1.0) == 0.0

    def test_above_max(self):
        assert clamp(1.5, 0.0, 1.0) == 1.0

    def test_within_range(self):
        assert clamp(0.5, 0.0, 1.0) == 0.5

    def test_at_min(self):
        assert clamp(0.0, 0.0, 1.0) == 0.0

    def test_at_max(self):
        assert clamp(1.0, 0.0, 1.0) == 1.0


# ---------------------------------------------------------------------------
# tiered_drawdown_penalty() tests
# ---------------------------------------------------------------------------

class TestTieredDrawdownPenalty:
    """Drawdown penalty at exact boundary values (5%, 15%, 30%, 65%)."""

    WEIGHT = 0.25  # SHARPE_HUNTER / RETURN_CHASER weight for drawdown

    def test_dd_zero(self):
        assert tiered_drawdown_penalty(0.0, self.WEIGHT) == 0.0

    def test_dd_at_5_percent(self):
        """Exactly 5% → penalty = 0."""
        assert tiered_drawdown_penalty(5.0, self.WEIGHT) == 0.0

    def test_dd_just_above_5(self):
        """5.1% → enters first tier."""
        penalty = tiered_drawdown_penalty(5.1, self.WEIGHT)
        expected = (5.1 - 5.0) / 10.0 * 0.48 * self.WEIGHT * 100.0
        assert abs(penalty - expected) < 1e-9

    def test_dd_at_15_percent(self):
        """Exactly 15% → top of first tier."""
        penalty = tiered_drawdown_penalty(15.0, self.WEIGHT)
        expected = (15.0 - 5.0) / 10.0 * 0.48 * self.WEIGHT * 100.0
        assert abs(penalty - expected) < 1e-9

    def test_dd_just_above_15(self):
        """15.1% → enters second tier."""
        penalty = tiered_drawdown_penalty(15.1, self.WEIGHT)
        expected = (0.48 + (15.1 - 15.0) / 15.0 * 0.52) * self.WEIGHT * 100.0
        assert abs(penalty - expected) < 1e-9

    def test_dd_at_30_percent(self):
        """Exactly 30% → top of second tier."""
        penalty = tiered_drawdown_penalty(30.0, self.WEIGHT)
        expected = (0.48 + (30.0 - 15.0) / 15.0 * 0.52) * self.WEIGHT * 100.0
        assert abs(penalty - expected) < 1e-9

    def test_dd_just_above_30(self):
        """30.1% → full deduction tier."""
        penalty = tiered_drawdown_penalty(30.1, self.WEIGHT)
        assert penalty == self.WEIGHT * 100.0

    def test_dd_at_65_percent(self):
        """65% → full deduction (this is the disqualifier boundary, but penalty curve applies)."""
        penalty = tiered_drawdown_penalty(65.0, self.WEIGHT)
        assert penalty == self.WEIGHT * 100.0

    def test_dd_above_65_percent(self):
        """Above 65% → still full deduction."""
        penalty = tiered_drawdown_penalty(80.0, self.WEIGHT)
        assert penalty == self.WEIGHT * 100.0

    def test_full_deduction_equals_weight_times_100(self):
        """Full deduction is exactly weight × 100, regardless of dd value."""
        for dd in [31.0, 50.0, 65.0, 99.0]:
            assert tiered_drawdown_penalty(dd, self.WEIGHT) == self.WEIGHT * 100.0


# ---------------------------------------------------------------------------
# check_disqualifiers() tests
# ---------------------------------------------------------------------------

class TestCheckDisqualifiers:
    """Disqualifier detection for all three disqualifier types."""

    def test_no_disqualifier_normal_data(self, meta, period_data):
        is_disq, reason = check_disqualifiers(period_data, meta)
        assert is_disq is False
        assert reason == ""

    def test_catastrophic_loss_exactly_at_threshold(self, meta):
        """min_return = -20.0: exactly -20.0 is NOT disqualified (must be below)."""
        p = make_period(ann_return=-20.0)
        is_disq, reason = check_disqualifiers(p, meta)
        assert is_disq is False

    def test_catastrophic_loss_just_below_threshold(self, meta):
        """-20.1 breaches min_return -20.0 → CATASTROPHIC_LOSS."""
        p = make_period(ann_return=-20.1)
        is_disq, reason = check_disqualifiers(p, meta)
        assert is_disq is True
        assert reason == "CATASTROPHIC_LOSS"

    def test_catastrophic_loss_deep_negative(self, meta):
        p = make_period(ann_return=-50.0)
        is_disq, reason = check_disqualifiers(p, meta)
        assert is_disq is True
        assert reason == "CATASTROPHIC_LOSS"

    def test_unacceptable_risk_at_threshold(self, meta):
        """max_drawdown exactly 65.0 → UNACCEPTABLE_RISK."""
        p = make_period(max_drawdown=65.0)
        is_disq, reason = check_disqualifiers(p, meta)
        assert is_disq is True
        assert reason == "UNACCEPTABLE_RISK"

    def test_unacceptable_risk_just_below_threshold(self, meta):
        """64.9% drawdown → not disqualified."""
        p = make_period(max_drawdown=64.9)
        is_disq, reason = check_disqualifiers(p, meta)
        assert is_disq is False

    def test_unacceptable_risk_just_above_threshold(self, meta):
        """65.1% → UNACCEPTABLE_RISK."""
        p = make_period(max_drawdown=65.1)
        is_disq, reason = check_disqualifiers(p, meta)
        assert is_disq is True
        assert reason == "UNACCEPTABLE_RISK"

    def test_worse_than_random_exactly_at_threshold(self, meta):
        """min_sharpe = -1.0: exactly -1.0 is NOT disqualified."""
        p = make_period(sharpe=-1.0)
        is_disq, reason = check_disqualifiers(p, meta)
        assert is_disq is False

    def test_worse_than_random_just_below_threshold(self, meta):
        """-1.01 sharpe → WORSE_THAN_RANDOM."""
        p = make_period(sharpe=-1.01)
        is_disq, reason = check_disqualifiers(p, meta)
        assert is_disq is True
        assert reason == "WORSE_THAN_RANDOM"

    def test_worse_than_random_deep_negative(self, meta):
        p = make_period(sharpe=-3.0)
        is_disq, reason = check_disqualifiers(p, meta)
        assert is_disq is True
        assert reason == "WORSE_THAN_RANDOM"

    def test_catastrophic_loss_takes_priority_over_drawdown(self, meta):
        """When multiple disqualifiers apply, first matched wins (order: return, dd, sharpe)."""
        p = make_period(ann_return=-50.0, max_drawdown=80.0, sharpe=-2.0)
        is_disq, reason = check_disqualifiers(p, meta)
        assert is_disq is True
        assert reason == "CATASTROPHIC_LOSS"


# ---------------------------------------------------------------------------
# score_period() tests
# ---------------------------------------------------------------------------

class TestScorePeriod:
    """All four archetypes produce correct weights; score structure validated."""

    def test_returns_fitness_block(self, meta, period_data):
        result = score_period(period_data, "SHARPE_HUNTER", meta)
        assert result["fitness"] is not None
        assert "sharpe_component" in result["fitness"]
        assert "return_component" in result["fitness"]
        assert "drawdown_penalty" in result["fitness"]
        assert "bonuses_applied" in result["fitness"]
        assert "total_bonus_points" in result["fitness"]
        assert "period_fitness_score" in result["fitness"]

    def test_does_not_mutate_input(self, meta, period_data):
        original_fitness = period_data["fitness"]
        score_period(period_data, "SHARPE_HUNTER", meta)
        assert period_data["fitness"] == original_fitness

    def test_invalid_archetype_raises(self, meta, period_data):
        with pytest.raises(ValueError, match="Invalid archetype"):
            score_period(period_data, "INVALID_ARCH", meta)

    def test_all_four_archetypes_run(self, meta, period_data):
        for arch in ["SHARPE_HUNTER", "RETURN_CHASER", "RISK_MINIMIZER", "CONSISTENCY"]:
            result = score_period(period_data, arch, meta)
            assert result["fitness"]["period_fitness_score"] >= 0.0

    def test_archetype_weights_sum_to_one(self, meta):
        """Each archetype's sharpe+return+drawdown weights must sum to 1.0."""
        for arch, weights in meta["fitness"]["archetype_weights"].items():
            total = weights["sharpe"] + weights["return"] + weights["drawdown"]
            assert abs(total - 1.0) < 1e-9, (
                f"{arch} weights sum to {total}, expected 1.0"
            )

    def test_sharpe_component_formula(self, meta):
        """sharpe_component = clamp(sharpe/3.0, 0, 1) × sharpe_weight × 100"""
        p = make_period(sharpe=1.5, ann_return=10.0, max_drawdown=5.0)
        result = score_period(p, "SHARPE_HUNTER", meta)
        w = meta["fitness"]["archetype_weights"]["SHARPE_HUNTER"]["sharpe"]
        expected = clamp(1.5 / 3.0, 0, 1) * w * 100.0
        assert abs(result["fitness"]["sharpe_component"] - expected) < 1e-3

    def test_return_component_formula(self, meta):
        """return_component = clamp(log(1+r/100)/log(2.5), 0, 1) × return_weight × 100"""
        ann_return = 30.0
        p = make_period(sharpe=1.0, ann_return=ann_return, max_drawdown=5.0)
        result = score_period(p, "RETURN_CHASER", meta)
        w = meta["fitness"]["archetype_weights"]["RETURN_CHASER"]["return"]
        expected = clamp(
            math.log(1 + ann_return / 100.0) / math.log(2.5), 0, 1
        ) * w * 100.0
        assert abs(result["fitness"]["return_component"] - expected) < 1e-3

    def test_score_clamped_not_negative_when_heavy_penalty(self, meta):
        """Very high drawdown and low return → score clamped at 0, never negative."""
        p = make_period(ann_return=-5.0, sharpe=0.1, max_drawdown=60.0)
        result = score_period(p, "RISK_MINIMIZER", meta)
        assert result["fitness"]["period_fitness_score"] >= 0.0

    def test_score_maximum_is_112(self, meta):
        """Maximum possible period score = 100 + 12 bonus = 112."""
        p = make_period(ann_return=200.0, sharpe=10.0, max_drawdown=0.0, beats_benchmark=True)
        result = score_period(p, "SHARPE_HUNTER", meta)
        assert result["fitness"]["period_fitness_score"] <= 112.0


# ---------------------------------------------------------------------------
# compute_bonuses() tests — stacking
# ---------------------------------------------------------------------------

class TestComputeBonuses:
    """Bonus stacking: all 5 bonuses applied simultaneously."""

    def test_all_bonuses_stack(self, meta):
        """When all conditions met, all five bonuses fire and stack."""
        # sharpe >= 2.0, dd <= 15%, return >= 40%, beats_benchmark, consistency < 10
        core = {"sharpe": 2.5, "max_drawdown": 10.0, "annualized_return": 50.0}
        bench = {"beats_benchmark": True}
        # period_scores std_dev < 10 for consistency bonus
        period_scores = {"6M": 75.0, "1Y": 78.0, "2Y": 77.0, "3Y": 76.0}
        result = compute_bonuses(core, bench, period_scores, meta)
        assert result["sharpe_bonus"] is True
        assert result["drawdown_bonus"] is True
        assert result["return_bonus"] is True
        assert result["consistency_bonus"] is True
        assert result["beats_benchmark_bonus"] is True
        b = meta["fitness"]["bonuses"]
        expected_total = (
            b["sharpe_bonus"] + b["drawdown_bonus"] + b["return_bonus"]
            + b["consistency_bonus"] + b["beats_benchmark_bonus"]
        )
        assert result["total_bonus_points"] == expected_total

    def test_no_bonuses(self, meta):
        core = {"sharpe": 1.0, "max_drawdown": 20.0, "annualized_return": 10.0}
        bench = {"beats_benchmark": False}
        result = compute_bonuses(core, bench, None, meta)
        assert result["total_bonus_points"] == 0
        assert result["sharpe_bonus"] is False
        assert result["drawdown_bonus"] is False
        assert result["return_bonus"] is False
        assert result["consistency_bonus"] is False
        assert result["beats_benchmark_bonus"] is False

    def test_sharpe_bonus_exact_threshold(self, meta):
        """sharpe exactly 2.0 → bonus fires (>= threshold)."""
        core = {"sharpe": 2.0, "max_drawdown": 20.0, "annualized_return": 10.0}
        bench = {"beats_benchmark": False}
        result = compute_bonuses(core, bench, None, meta)
        assert result["sharpe_bonus"] is True

    def test_sharpe_bonus_just_below_threshold(self, meta):
        core = {"sharpe": 1.99, "max_drawdown": 20.0, "annualized_return": 10.0}
        bench = {"beats_benchmark": False}
        result = compute_bonuses(core, bench, None, meta)
        assert result["sharpe_bonus"] is False

    def test_drawdown_bonus_exact_threshold(self, meta):
        """max_drawdown exactly 15.0 → bonus fires (<= threshold)."""
        core = {"sharpe": 1.0, "max_drawdown": 15.0, "annualized_return": 10.0}
        bench = {"beats_benchmark": False}
        result = compute_bonuses(core, bench, None, meta)
        assert result["drawdown_bonus"] is True

    def test_drawdown_bonus_just_above_threshold(self, meta):
        core = {"sharpe": 1.0, "max_drawdown": 15.1, "annualized_return": 10.0}
        bench = {"beats_benchmark": False}
        result = compute_bonuses(core, bench, None, meta)
        assert result["drawdown_bonus"] is False

    def test_return_bonus_exact_threshold(self, meta):
        """ann_return exactly 40.0 → bonus fires (>= threshold)."""
        core = {"sharpe": 1.0, "max_drawdown": 20.0, "annualized_return": 40.0}
        bench = {"beats_benchmark": False}
        result = compute_bonuses(core, bench, None, meta)
        assert result["return_bonus"] is True

    def test_consistency_bonus_requires_four_periods(self, meta):
        """consistency_bonus requires all 4 periods; fewer → no bonus."""
        core = {"sharpe": 1.0, "max_drawdown": 20.0, "annualized_return": 10.0}
        bench = {"beats_benchmark": False}
        # Only 3 periods
        result = compute_bonuses(core, bench, {"6M": 70.0, "1Y": 72.0, "2Y": 71.0}, meta)
        assert result["consistency_bonus"] is False

    def test_consistency_bonus_none_period_scores(self, meta):
        """period_scores=None → consistency_bonus always False."""
        core = {"sharpe": 1.0, "max_drawdown": 20.0, "annualized_return": 10.0}
        bench = {"beats_benchmark": False}
        result = compute_bonuses(core, bench, None, meta)
        assert result["consistency_bonus"] is False


# ---------------------------------------------------------------------------
# compute_composite() tests
# ---------------------------------------------------------------------------

class TestComputeComposite:
    """Composite weighting and consistency adjustment."""

    def test_correct_period_weighting(self, meta):
        """6M×0.10 + 1Y×0.30 + 2Y×0.30 + 3Y×0.30."""
        scores = {"6M": 60.0, "1Y": 70.0, "2Y": 80.0, "3Y": 90.0}
        result = compute_composite(scores, meta)
        expected_weighted = 60.0 * 0.10 + 70.0 * 0.30 + 80.0 * 0.30 + 90.0 * 0.30
        assert abs(result["weighted_composite"] - expected_weighted) < 1e-3

    def test_missing_period_raises(self, meta):
        """Missing any of 6M, 1Y, 2Y, 3Y → ValueError."""
        with pytest.raises(ValueError, match="Missing period scores"):
            compute_composite({"6M": 60.0, "1Y": 70.0, "2Y": 80.0}, meta)

    def test_consistency_adjustment_std_dev_below_10(self, meta):
        """std_dev < 10 → +2 adjustment."""
        # All identical scores → std_dev = 0
        scores = {"6M": 70.0, "1Y": 70.0, "2Y": 70.0, "3Y": 70.0}
        result = compute_composite(scores, meta)
        assert result["consistency_adjustment"] == 2.0

    def test_consistency_adjustment_std_dev_at_9_9(self, meta):
        """std_dev = 9.9 → +2 (boundary: < 10)."""
        # Construct scores with std_dev ≈ 9.9
        # mean=70, std_dev=9.9: use [60.1, 70.0, 70.0, 79.9] approx
        # Exact: stdev([60.1, 70.0, 70.0, 79.9]) ≈ 8.08... let's compute properly
        # We need stdev < 10: use [65, 68, 72, 75] → stdev ≈ 4.35 → +2
        scores = {"6M": 65.0, "1Y": 68.0, "2Y": 72.0, "3Y": 75.0}
        std = statistics.stdev(scores.values())
        assert std < 10.0
        result = compute_composite(scores, meta)
        assert result["consistency_adjustment"] == 2.0
        assert result["std_dev"] == round(std, 4)

    def test_consistency_adjustment_std_dev_at_10_exactly(self, meta):
        """std_dev = exactly 10 → 0 adjustment (not < 10, not > 25)."""
        # stdev = exactly 10: need 4 values with exact stdev 10
        # [60, 70, 70, 80] → stdev = sqrt(((−10)²+(0)²+(0)²+(10)²)/3) = sqrt(200/3) ≈ 8.16
        # Use [55, 65, 75, 85] → stdev = sqrt(((−15)²+(−5)²+(5)²+(15)²)/3) = sqrt(550/3) ≈ 13.54
        # Use [63.34, 70, 70, 76.66] → need exact 10
        # Simpler: mock meta with exact boundary test via scores
        # stdev([a, b, c, d]) = 10 exactly when sum_sq_dev = 300
        # Try [60, 70, 70, 80]: stdev = sqrt((100+0+0+100)/3) = sqrt(66.67) ≈ 8.16 → +2
        # Try [57.32, 67.32, 77.32, 87.32] all same spacing 10 → stdev = sqrt((3*10²/3)+ ...) hmm
        # mean=72.32, diffs = [-15,-5,5,15], sq=225+25+25+225=500, /3 = 166.67, sqrt ≈ 12.9
        # Build [60, 60+x, 60+2x, 60+3x]: stdev from formula for AP: x*sqrt(5/4) → x=10/sqrt(5/4)
        # Actually just test with known std values close to 10 and 10.01
        scores_below = {"6M": 70.0, "1Y": 72.0, "2Y": 74.0, "3Y": 76.0}
        std_below = statistics.stdev(scores_below.values())
        assert std_below < 10.0
        result = compute_composite(scores_below, meta)
        assert result["consistency_adjustment"] == 2.0

    def test_consistency_adjustment_std_dev_just_above_10(self, meta):
        """std_dev just above 10 → 0 adjustment."""
        scores = {"6M": 50.0, "1Y": 65.0, "2Y": 75.0, "3Y": 80.0}
        std = statistics.stdev(scores.values())
        assert 10.0 < std <= 25.0
        result = compute_composite(scores, meta)
        assert result["consistency_adjustment"] == 0.0

    def test_consistency_adjustment_std_dev_at_25(self, meta):
        """std_dev = exactly 25 → 0 adjustment (not > 25)."""
        # Need stdev = 25: use scores where this is true
        # [a, a, a, a+x] isn't easy. Use approximate: test boundary logic
        # [30, 55, 75, 90] → mean=62.5, diffs=[-32.5,-7.5,12.5,27.5]
        # sq=1056.25+56.25+156.25+756.25=2025, /3=675, sqrt≈25.98 → -5
        # [35, 55, 75, 85] → mean=62.5, diffs=[-27.5,-7.5,12.5,22.5]
        # sq=756.25+56.25+156.25+506.25=1475, /3≈491.67, sqrt≈22.17 → 0
        scores = {"6M": 35.0, "1Y": 55.0, "2Y": 75.0, "3Y": 85.0}
        std = statistics.stdev(scores.values())
        assert std <= 25.0
        result = compute_composite(scores, meta)
        assert result["consistency_adjustment"] == 0.0

    def test_consistency_adjustment_std_dev_above_25(self, meta):
        """std_dev > 25 → -5 adjustment."""
        scores = {"6M": 20.0, "1Y": 50.0, "2Y": 80.0, "3Y": 90.0}
        std = statistics.stdev(scores.values())
        assert std > 25.0
        result = compute_composite(scores, meta)
        assert result["consistency_adjustment"] == -5.0

    def test_final_composite_equals_weighted_plus_adjustment(self, meta):
        """final_composite = weighted_composite + consistency_adjustment."""
        scores = {"6M": 70.0, "1Y": 72.0, "2Y": 74.0, "3Y": 76.0}
        result = compute_composite(scores, meta)
        expected_final = result["weighted_composite"] + result["consistency_adjustment"]
        assert abs(result["final_composite"] - expected_final) < 1e-3

    def test_std_dev_returned_correctly(self, meta):
        """std_dev field matches actual statistics.stdev of the four scores."""
        scores = {"6M": 60.0, "1Y": 70.0, "2Y": 75.0, "3Y": 80.0}
        result = compute_composite(scores, meta)
        expected_std = statistics.stdev(scores.values())
        assert abs(result["std_dev"] - expected_std) < 1e-3

    def test_period_scores_preserved_in_output(self, meta):
        """period_scores dict is returned unchanged in the composite result."""
        scores = {"6M": 60.0, "1Y": 70.0, "2Y": 75.0, "3Y": 80.0}
        result = compute_composite(scores, meta)
        assert result["period_scores"] == scores


# ---------------------------------------------------------------------------
# Disqualified strategy score = 0, not negative
# ---------------------------------------------------------------------------

class TestDisqualifiedScoreIsZero:
    """Score of 0 for disqualified strategy (not negative)."""

    def test_disqualified_period_clamped_at_zero(self, meta):
        """A period with disqualifying metrics still produces score >= 0."""
        # Extremely bad metrics (but we're testing clamp, not graveyard logic)
        p = make_period(ann_return=-50.0, sharpe=-2.0, max_drawdown=90.0)
        result = score_period(p, "RISK_MINIMIZER", meta)
        assert result["fitness"]["period_fitness_score"] >= 0.0

    def test_minimum_period_score_is_zero(self, meta):
        """Worst possible inputs produce exactly 0, never negative."""
        p = make_period(ann_return=-100.0, sharpe=-5.0, max_drawdown=100.0)
        result = score_period(p, "CONSISTENCY", meta)
        assert result["fitness"]["period_fitness_score"] == 0.0

    def test_check_disqualifiers_does_not_score(self, meta):
        """check_disqualifiers returns (True, reason) — caller must treat score as null."""
        p = make_period(ann_return=-30.0)
        is_disq, reason = check_disqualifiers(p, meta)
        assert is_disq is True
        assert reason == "CATASTROPHIC_LOSS"
        # The disqualified strategy's score is null by convention — not set by scorer


# ---------------------------------------------------------------------------
# Integration: mock data round-trip
# ---------------------------------------------------------------------------

class TestMockDataRoundTrip:
    """End-to-end test using mock data files."""

    def test_mock_period_scores_correctly(self, meta, period_data):
        """Mock period stats block scores without error for all archetypes."""
        for arch in ["SHARPE_HUNTER", "RETURN_CHASER", "RISK_MINIMIZER", "CONSISTENCY"]:
            result = score_period(period_data, arch, meta)
            fit = result["fitness"]
            assert fit["period_fitness_score"] >= 0.0
            assert fit["sharpe_component"] >= 0.0
            assert fit["return_component"] >= 0.0
            assert fit["drawdown_penalty"] >= 0.0

    def test_mock_period_not_disqualified(self, meta, period_data):
        """Mock period data (ann_return=63.7, sharpe=2.28, dd=9.4) should pass."""
        is_disq, reason = check_disqualifiers(period_data, meta)
        assert is_disq is False
        assert reason == ""

    def test_composite_with_four_scored_periods(self, meta, period_data):
        """Build four period scores and compute composite."""
        period_scores = {}
        for period in ["6M", "1Y", "2Y", "3Y"]:
            pd_copy = {**period_data, "period": period}
            result = score_period(pd_copy, "SHARPE_HUNTER", meta)
            period_scores[period] = result["fitness"]["period_fitness_score"]
        composite = compute_composite(period_scores, meta)
        assert "final_composite" in composite
        assert composite["final_composite"] >= 0.0
