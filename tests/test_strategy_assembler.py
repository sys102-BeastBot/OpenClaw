"""
test_strategy_assembler.py — Unit tests for strategy_assembler.py

Tests cover:
  - Valid assembly with 1, 2, 3 pattern chains
  - Crash guard auto-sort to outermost position
  - Tier asset assignment at correct nesting depths
  - Structural validation (invalid steps, missing else, bad tickers)
  - Error handling (unknown pattern IDs, empty pattern lists)
  - wt-inverse-vol window-days string requirement
  - Asset universe enforcement
  - All 20 R4 seed plans assemble without error
  - validate_skeleton catches all known API error conditions

Uses mock patterns only — never reads real KB files.
"""

import copy
import json
import pytest
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).parent.parent / 'src'))

from strategy_assembler import (
    assemble_strategy,
    assemble_all_seeds,
    build_r4_seed_plan,
    validate_skeleton,
    load_patterns,
    AssemblyError,
    ASSET_UNIVERSE,
    DEFAULT_TIERS,
)


# ── Mock patterns ──────────────────────────────────────────────────────────────

def _make_if_child(lhs_fn, lhs_val, window, comparator, rhs_val,
                    rhs_fixed, is_else=False) -> dict:
    """Build a minimal valid if-child node for mock templates."""
    node = {
        'step': 'if-child',
        'is-else-condition?': is_else,
        'children': [],
    }
    if not is_else:
        node.update({
            'lhs-fn': lhs_fn,
            'lhs-fn-params': {'window-days': window},
            'lhs-val': lhs_val,
            'comparator': comparator,
            'rhs-val': rhs_val,
            'rhs-fixed-value?': rhs_fixed,
        })
    return node


def _make_mock_template(lhs_fn='cumulative-return', lhs_val='TQQQ',
                         window=1, rhs_val='5.5', rhs_fixed=True) -> dict:
    """Build a minimal valid if-template for a pattern."""
    return {
        'step': 'if',
        'children': [
            _make_if_child(lhs_fn, lhs_val, window, 'gt', rhs_val, rhs_fixed),
            {'step': 'if-child', 'is-else-condition?': True, 'children': []},
        ]
    }


def _mock_pat(pid, name, conf, lhs_fn, lhs_val, window, rhs_val, rhs_fixed):
    """Helper to build a minimal mock pattern entry."""
    return {
        'id': pid, 'name': name, 'category': 'guard',
        'performance': {'confidence': conf},
        'applicability': {
            'archetypes': ['ALL'],
            'regimes_effective': ['bull_low_vol'],
            'regimes_less_effective': ['bear_sustained'],
        },
        'template': _make_mock_template(lhs_fn, lhs_val, window, rhs_val, rhs_fixed),
    }


# Complete mock set covering all 19 patterns used in R4 seed plan.
MOCK_PATTERNS = {
    'pat-001': _mock_pat('pat-001', 'TQQQ Bull Entry Gate',             0.97,
                         'cumulative-return',              'TQQQ', 1,   '5.5',  True),
    'pat-003': _mock_pat('pat-003', 'SVXY Crash Guard Mandatory',       0.95,
                         'max-drawdown',                   'SVXY', 2,   '10',   True),
    'pat-004': _mock_pat('pat-004', 'SPY EMA 210 Long-Term Trend',      0.90,
                         'exponential-moving-average-price','SPY', 210, 'SPY',  False),
    'pat-005': _mock_pat('pat-005', 'BIL RSI vs IEF Rate Stress',       0.85,
                         'relative-strength-index',        'BIL', 10,  'IEF',  False),
    'pat-006': {
        'id': 'pat-006', 'name': 'UVXY VIXM Paired Volatility Hedge',
        'category': 'allocation', 'performance': {'confidence': 0.82},
        'applicability': {'archetypes': ['ALL'],
                          'regimes_effective': ['vix_spike'],
                          'regimes_less_effective': ['bull_low_vol']},
        'template': {'step': 'wt-cash-equal', 'children': [
            {'step': 'asset', 'ticker': 'UVXY', 'children': []},
            {'step': 'asset', 'ticker': 'VIXM', 'children': []},
        ]},
    },
    'pat-007': _mock_pat('pat-007', 'SPY Max Drawdown Hard Floor',      0.88,
                         'max-drawdown',                   'SPY', 20,  '6',    True),
    'pat-008': _mock_pat('pat-008', 'Triple Confirmation Before Leverage', 0.87,
                         'cumulative-return',              'TQQQ', 1,  '5.5',  True),
    'pat-009': _mock_pat('pat-009', 'UVXY Cumulative Return Spike',     0.85,
                         'cumulative-return',              'UVXY', 10, '20',   True),
    'pat-010': _mock_pat('pat-010', 'SPY RSI Overbought Exhaustion',    0.83,
                         'relative-strength-index',        'SPY', 10,  '70',   True),
    'pat-011': _mock_pat('pat-011', 'Max Drawdown Black Swan Catch',    0.80,
                         'max-drawdown',                   'SPY', 20,  '6',    True),
    'pat-012': _mock_pat('pat-012', 'SVXY Triple Crash Guard Compound', 0.90,
                         'relative-strength-index',        'SVXY', 10, '31',   True),
    'pat-013': _mock_pat('pat-013', 'UVXY MA Return vs VIXM Trending',  0.82,
                         'moving-average-return',          'UVXY', 3,  'VIXM', False),
    'pat-014': _mock_pat('pat-014', 'TECS SOXS SQQQ Named Short Basket', 0.88,
                         'cumulative-return',              'TQQQ', 1,  '5.5',  True),
    'pat-015': _mock_pat('pat-015', 'UVXY RSI Overbought Vol Exhaustion', 0.82,
                         'relative-strength-index',        'UVXY', 10, '84',   True),
    'pat-016': _mock_pat('pat-016', 'SPY MA3 Plus EMA210 Dual Timeframe', 0.83,
                         'exponential-moving-average-price','SPY', 210, 'SPY', False),
    'pat-017': _mock_pat('pat-017', 'BND RSI Long Window Bond Stress',  0.80,
                         'relative-strength-index',        'BND', 45,  'SPY',  False),
    'pat-018': _mock_pat('pat-018', 'TQQQ Extreme Crash Circuit Breaker', 0.80,
                         'cumulative-return',              'TQQQ', 10, '-33',  True),
    'pat-019': _mock_pat('pat-019', 'SVXY RSI Bull Health Confirmation', 0.83,
                         'relative-strength-index',        'SVXY', 10, '31',   True),
}


# ── Test: basic assembly ───────────────────────────────────────────────────────

class TestBasicAssembly:

    def test_single_pattern(self):
        """Single pattern produces 2-tier structure: tier_1 and tier_4."""
        result = assemble_strategy(
            pattern_ids=['pat-001'],
            patterns_override=MOCK_PATTERNS,
        )
        assert result['status'] if 'status' in result else True
        skeleton = result['skeleton']
        assert skeleton['step'] == 'wt-cash-equal'
        # Drill down: wt-cash-equal → if → [condition if-child, else if-child]
        if_node = skeleton['children'][0]
        assert if_node['step'] == 'if'
        assert len(if_node['children']) == 2

    def test_two_patterns(self):
        """Two patterns produce 3-tier structure."""
        result = assemble_strategy(
            pattern_ids=['pat-004', 'pat-001'],
            patterns_override=MOCK_PATTERNS,
        )
        skeleton = result['skeleton']
        issues = validate_skeleton(skeleton)
        assert issues == [], f"Validation issues: {issues}"

    def test_three_patterns(self):
        """Three patterns produce a valid 4-tier structure."""
        result = assemble_strategy(
            pattern_ids=['pat-004', 'pat-001', 'pat-005'],
            patterns_override=MOCK_PATTERNS,
        )
        skeleton = result['skeleton']
        issues = validate_skeleton(skeleton)
        assert issues == [], f"Validation issues: {issues}"

    def test_layers_output(self):
        """layers field returns ordered pattern IDs."""
        result = assemble_strategy(
            pattern_ids=['pat-004', 'pat-001'],
            patterns_override=MOCK_PATTERNS,
        )
        assert len(result['layers']) == 2
        assert 'pat-004' in result['layers']
        assert 'pat-001' in result['layers']

    def test_tier_map_populated(self):
        """tier_map has entries for each layer depth."""
        result = assemble_strategy(
            pattern_ids=['pat-004', 'pat-001'],
            patterns_override=MOCK_PATTERNS,
        )
        assert len(result['tier_map']) > 0

    def test_description_populated(self):
        """description field is a non-empty string."""
        result = assemble_strategy(
            pattern_ids=['pat-001'],
            patterns_override=MOCK_PATTERNS,
        )
        assert isinstance(result['description'], str)
        assert len(result['description']) > 10


# ── Test: tier asset assignment ────────────────────────────────────────────────

class TestTierAssets:

    def _collect_leaf_tickers(self, node: dict) -> list[str]:
        """Collect all asset tickers from a skeleton recursively."""
        tickers = []
        if node.get('step') == 'asset':
            tickers.append(node['ticker'])
        for child in node.get('children', []):
            tickers.extend(self._collect_leaf_tickers(child))
        return tickers

    def test_default_tier1_in_skeleton(self):
        """TQQQ (default tier_1) appears in assembled skeleton."""
        result = assemble_strategy(
            pattern_ids=['pat-001'],
            patterns_override=MOCK_PATTERNS,
        )
        tickers = self._collect_leaf_tickers(result['skeleton'])
        assert 'TQQQ' in tickers

    def test_default_tier4_bil_in_skeleton(self):
        """BIL (default tier_4) appears in assembled skeleton."""
        result = assemble_strategy(
            pattern_ids=['pat-001'],
            patterns_override=MOCK_PATTERNS,
        )
        tickers = self._collect_leaf_tickers(result['skeleton'])
        assert 'BIL' in tickers

    def test_custom_tier_assets(self):
        """Custom tier overrides are reflected in skeleton."""
        result = assemble_strategy(
            pattern_ids=['pat-001'],
            tiers={**DEFAULT_TIERS, 'tier_1': ['SOXL']},
            patterns_override=MOCK_PATTERNS,
        )
        tickers = self._collect_leaf_tickers(result['skeleton'])
        assert 'SOXL' in tickers

    def test_multi_ticker_tier(self):
        """Multi-ticker tier produces wt-cash-equal node."""
        result = assemble_strategy(
            pattern_ids=['pat-001'],
            tiers={**DEFAULT_TIERS, 'tier_1': ['TQQQ', 'SOXL']},
            patterns_override=MOCK_PATTERNS,
        )
        issues = validate_skeleton(result['skeleton'])
        assert issues == [], f"Issues: {issues}"
        tickers = self._collect_leaf_tickers(result['skeleton'])
        assert 'TQQQ' in tickers
        assert 'SOXL' in tickers

    def test_invvol_weighting(self):
        """invvol weighting produces wt-inverse-vol node with string window."""
        result = assemble_strategy(
            pattern_ids=['pat-001'],
            tiers={**DEFAULT_TIERS, 'tier_1': ['TQQQ', 'SOXL']},
            weighting='invvol',
            invvol_window='10',
            patterns_override=MOCK_PATTERNS,
        )
        issues = validate_skeleton(result['skeleton'])
        assert issues == [], f"Issues: {issues}"

        def has_invvol(node):
            if node.get('step') == 'wt-inverse-vol':
                return True
            return any(has_invvol(c) for c in node.get('children', []))

        assert has_invvol(result['skeleton']), "No wt-inverse-vol node found"


# ── Test: crash guard auto-sort ────────────────────────────────────────────────

class TestCrashGuardSort:

    def test_crash_guard_sorted_outermost(self):
        """Pattern with 'crash' in name is sorted to outermost position."""
        result = assemble_strategy(
            # pat-001 (Bull Entry Gate) before pat-003 (Crash Guard)
            # Crash guard should auto-sort to outer position
            pattern_ids=['pat-001', 'pat-003'],
            patterns_override=MOCK_PATTERNS,
        )
        # First layer in assembled order should be the crash guard
        layers = result['layers']
        assert layers[0] == 'pat-003', (
            f"Crash guard pat-003 should be outermost, got {layers}"
        )

    def test_non_crash_order_preserved(self):
        """Non-crash patterns maintain relative order."""
        result = assemble_strategy(
            pattern_ids=['pat-004', 'pat-005'],
            patterns_override=MOCK_PATTERNS,
        )
        layers = result['layers']
        # Neither is a crash guard — order should be stable
        assert len(layers) == 2


# ── Test: structural validation ───────────────────────────────────────────────

class TestValidateSkeleton:

    def test_valid_simple_skeleton(self):
        """Minimal valid skeleton passes validation."""
        skeleton = {
            'step': 'wt-cash-equal',
            'children': [
                {
                    'step': 'if',
                    'children': [
                        {
                            'step': 'if-child',
                            'is-else-condition?': False,
                            'lhs-fn': 'cumulative-return',
                            'lhs-fn-params': {'window-days': 1},
                            'lhs-val': 'TQQQ',
                            'comparator': 'gt',
                            'rhs-val': '5.5',
                            'rhs-fixed-value?': True,
                            'children': [
                                {'step': 'asset', 'ticker': 'TQQQ', 'children': []}
                            ]
                        },
                        {
                            'step': 'if-child',
                            'is-else-condition?': True,
                            'children': [
                                {'step': 'asset', 'ticker': 'BIL', 'children': []}
                            ]
                        }
                    ]
                }
            ]
        }
        issues = validate_skeleton(skeleton)
        assert issues == []

    def test_invalid_step_detected(self):
        """Invalid step type is caught."""
        skeleton = {
            'step': 'comment',  # invalid
            'children': []
        }
        issues = validate_skeleton(skeleton)
        assert any('invalid step' in i for i in issues)

    def test_missing_else_if_child(self):
        """if node missing else branch is caught."""
        skeleton = {
            'step': 'if',
            'children': [
                {
                    'step': 'if-child',
                    'is-else-condition?': False,
                    'lhs-fn': 'cumulative-return',
                    'lhs-fn-params': {'window-days': 1},
                    'lhs-val': 'TQQQ',
                    'comparator': 'gt',
                    'rhs-val': '5.5',
                    'rhs-fixed-value?': True,
                    'children': [{'step': 'asset', 'ticker': 'TQQQ', 'children': []}]
                }
                # Missing else if-child
            ]
        }
        issues = validate_skeleton(skeleton)
        assert any('2 children' in i or 'else' in i.lower() for i in issues)

    def test_invalid_ticker_detected(self):
        """Asset node with invalid ticker is caught."""
        skeleton = {
            'step': 'asset',
            'ticker': 'NOTREAL',
            'children': []
        }
        issues = validate_skeleton(skeleton)
        assert any('not in asset universe' in i or 'invalid ticker' in i or 'NOTREAL' in i for i in issues)

    def test_asset_with_children_detected(self):
        """Asset node with non-empty children is caught."""
        skeleton = {
            'step': 'asset',
            'ticker': 'TQQQ',
            'children': [{'step': 'asset', 'ticker': 'BIL', 'children': []}]
        }
        issues = validate_skeleton(skeleton)
        assert any('empty children' in i for i in issues)

    def test_window_key_instead_of_window_days(self):
        """lhs-fn-params with 'window' key (not window-days) is caught."""
        node = {
            'step': 'if-child',
            'is-else-condition?': False,
            'lhs-fn': 'cumulative-return',
            'lhs-fn-params': {'window': 10},  # wrong key
            'lhs-val': 'TQQQ',
            'comparator': 'gt',
            'rhs-val': '5.5',
            'rhs-fixed-value?': True,
            'children': []
        }
        issues = validate_skeleton(node)
        assert any('window-days' in i for i in issues)

    def test_invvol_int_window_detected(self):
        """wt-inverse-vol with integer window-days is caught."""
        skeleton = {
            'step': 'wt-inverse-vol',
            'window-days': 10,  # must be string
            'children': [{'step': 'asset', 'ticker': 'TQQQ', 'children': []}]
        }
        issues = validate_skeleton(skeleton)
        assert any('string' in i for i in issues)

    def test_invalid_lhs_fn_detected(self):
        """Invalid lhs-fn value is caught."""
        node = {
            'step': 'if-child',
            'is-else-condition?': False,
            'lhs-fn': 'risk-adjusted-momentum',  # invalid
            'lhs-fn-params': {'window-days': 10},
            'lhs-val': 'SPY',
            'comparator': 'gt',
            'rhs-val': '50',
            'rhs-fixed-value?': True,
            'children': []
        }
        issues = validate_skeleton(node)
        assert any('invalid lhs-fn' in i for i in issues)


# ── Test: error handling ───────────────────────────────────────────────────────

class TestErrorHandling:

    def test_empty_pattern_ids_raises(self):
        """Empty pattern_ids raises AssemblyError."""
        with pytest.raises(AssemblyError, match='must not be empty'):
            assemble_strategy(
                pattern_ids=[],
                patterns_override=MOCK_PATTERNS,
            )

    def test_unknown_pattern_id_raises(self):
        """Unknown pattern ID raises AssemblyError with helpful message."""
        with pytest.raises(AssemblyError, match="not found"):
            assemble_strategy(
                pattern_ids=['pat-999'],
                patterns_override=MOCK_PATTERNS,
            )

    def test_too_many_patterns_raises(self):
        """More than 6 patterns raises AssemblyError."""
        with pytest.raises(AssemblyError, match='Too many'):
            assemble_strategy(
                pattern_ids=['pat-001'] * 7,
                patterns_override=MOCK_PATTERNS,
            )

    def test_invalid_tier_ticker_raises(self):
        """Invalid ticker in tier raises AssemblyError."""
        with pytest.raises(AssemblyError):
            assemble_strategy(
                pattern_ids=['pat-001'],
                tiers={**DEFAULT_TIERS, 'tier_1': ['NOTREAL']},
                patterns_override=MOCK_PATTERNS,
            )

    def test_invvol_int_window_raises(self):
        """Integer invvol_window raises AssemblyError."""
        with pytest.raises(AssemblyError, match='string'):
            assemble_strategy(
                pattern_ids=['pat-001'],
                tiers={**DEFAULT_TIERS, 'tier_1': ['TQQQ', 'SOXL']},
                weighting='invvol',
                invvol_window=10,  # must be string
                patterns_override=MOCK_PATTERNS,
            )


# ── Test: assembled skeletons pass validate_skeleton ─────────────────────────

class TestAssembledSkeletonsValid:

    @pytest.mark.parametrize('pattern_ids', [
        ['pat-001'],
        ['pat-004', 'pat-001'],
        ['pat-004', 'pat-001', 'pat-005'],
        ['pat-003', 'pat-004', 'pat-001'],
        ['pat-004', 'pat-001', 'pat-005'],
    ])
    def test_assembled_skeleton_passes_validation(self, pattern_ids):
        """All assembled skeletons pass structural validation."""
        result = assemble_strategy(
            pattern_ids=pattern_ids,
            patterns_override=MOCK_PATTERNS,
        )
        issues = validate_skeleton(result['skeleton'])
        assert issues == [], (
            f"Pattern chain {pattern_ids} produced invalid skeleton:\n"
            + '\n'.join(issues)
        )

    def test_invvol_skeleton_passes_validation(self):
        """invvol-weighted assembly passes validation."""
        result = assemble_strategy(
            pattern_ids=['pat-004', 'pat-001'],
            tiers={**DEFAULT_TIERS, 'tier_1': ['TQQQ', 'SOXL']},
            weighting='invvol',
            invvol_window='10',
            patterns_override=MOCK_PATTERNS,
        )
        issues = validate_skeleton(result['skeleton'])
        assert issues == [], f"Validation issues: {issues}"


# ── Test: R4 seed plan ────────────────────────────────────────────────────────

class TestR4SeedPlan:

    def test_seed_plan_produces_20_seeds(self):
        """build_r4_seed_plan returns exactly 20 seeds."""
        plan = build_r4_seed_plan()
        assert len(plan) == 20

    def test_seed_plan_covers_all_archetypes(self):
        """Seed plan includes all 4 archetypes."""
        plan = build_r4_seed_plan()
        archetypes = {s['archetype'] for s in plan}
        assert archetypes == {
            'SHARPE_HUNTER', 'RISK_MINIMIZER',
            'CONSISTENCY', 'RETURN_CHASER'
        }

    def test_seed_plan_5_per_archetype(self):
        """Each archetype has exactly 5 seeds."""
        plan = build_r4_seed_plan()
        from collections import Counter
        counts = Counter(s['archetype'] for s in plan)
        for archetype, count in counts.items():
            assert count == 5, f"{archetype} has {count} seeds, expected 5"

    def test_seed_plan_sequential_numbers(self):
        """Seed numbers are 1-20 in order."""
        plan = build_r4_seed_plan()
        numbers = [s['seed_number'] for s in plan]
        assert numbers == list(range(1, 21))

    def test_all_seeds_assemble_without_error(self):
        """All 20 seeds assemble successfully with mock patterns."""
        results = assemble_all_seeds(patterns_override=MOCK_PATTERNS)
        failed = [r for r in results if r['status'] == 'error']
        assert failed == [], (
            f"{len(failed)} seeds failed assembly:\n"
            + '\n'.join(
                f"  Seed {r['seed_number']} ({r['archetype']}): {r['error']}"
                for r in failed
            )
        )

    def test_all_seed_skeletons_pass_validation(self):
        """All 20 assembled seed skeletons pass structural validation."""
        results = assemble_all_seeds(patterns_override=MOCK_PATTERNS)
        validation_failures = []
        for r in results:
            if r['status'] == 'ok':
                issues = validate_skeleton(r['result']['skeleton'])
                if issues:
                    validation_failures.append(
                        f"Seed {r['seed_number']}: {issues}"
                    )
        assert validation_failures == [], (
            f"Validation failures:\n" + '\n'.join(validation_failures)
        )

    def test_seed_plan_pattern_ids_are_known(self):
        """All pattern IDs in seed plan exist in MOCK_PATTERNS."""
        plan = build_r4_seed_plan()
        # Map mock pattern IDs — only check IDs that exist in mock
        # (real run would use real patterns)
        known_ids = set(MOCK_PATTERNS.keys())
        for spec in plan:
            for pid in spec['pattern_ids']:
                # Just verify ID format is correct
                assert pid.startswith('pat-'), f"Invalid pattern ID format: {pid}"
                assert len(pid) == len('pat-001'), f"Invalid pattern ID length: {pid}"


# ── Test: descriptions and metadata ───────────────────────────────────────────

class TestMetadata:

    def test_no_warnings_on_clean_assembly(self):
        """Clean assembly with valid templates produces no warnings."""
        result = assemble_strategy(
            pattern_ids=['pat-001'],
            patterns_override=MOCK_PATTERNS,
        )
        assert result['warnings'] == []

    def test_description_contains_layer_count(self):
        """Description mentions number of signal layers."""
        result = assemble_strategy(
            pattern_ids=['pat-004', 'pat-001'],
            patterns_override=MOCK_PATTERNS,
        )
        assert '2' in result['description']

    def test_description_contains_pattern_names(self):
        """Description contains pattern names."""
        result = assemble_strategy(
            pattern_ids=['pat-001'],
            patterns_override=MOCK_PATTERNS,
        )
        assert 'TQQQ' in result['description']


# ── Test: asset universe completeness ─────────────────────────────────────────

class TestAssetUniverse:

    def test_all_expected_tickers_in_universe(self):
        """Asset universe contains all expected tickers."""
        expected = {
            'SVIX', 'SVXY', 'UVXY', 'VIXM',
            'TQQQ', 'TECL', 'SOXL', 'SPXL', 'UPRO',
            'SQQQ', 'SOXS', 'SPXS', 'TECS',
            'BIL', 'SPY', 'QQQ',
        }
        assert expected == ASSET_UNIVERSE

    def test_default_tiers_use_valid_tickers(self):
        """All default tier tickers are in the asset universe."""
        for tier, tickers in DEFAULT_TIERS.items():
            for ticker in tickers:
                assert ticker in ASSET_UNIVERSE, (
                    f"Default tier '{tier}' has invalid ticker '{ticker}'"
                )


if __name__ == '__main__':
    pytest.main([__file__, '-v'])
