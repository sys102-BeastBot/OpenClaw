"""
Tests for context_builder.py.
All tests use mock data — no real KB files, no API calls.
"""
import json
import sys
import pytest
from pathlib import Path
from unittest.mock import patch, MagicMock

sys.path.insert(0, str(Path(__file__).parent.parent / 'src'))
import context_builder

# ── Fixtures ───────────────────────────────────────────────────────────────────

@pytest.fixture
def mock_meta():
    return {
        'kb_health': {'current_market_regime': 'BULL_CALM'},
        'best_per_archetype': {
            'SHARPE_HUNTER':  {'fitness_score': 78.4},
            'RETURN_CHASER':  None,
            'RISK_MINIMIZER': None,
            'CONSISTENCY':    None,
        },
        'archetype_allocation': {
            'current': {
                'SHARPE_HUNTER': 2, 'RETURN_CHASER': 2,
                'RISK_MINIMIZER': 1, 'CONSISTENCY': 1,
            }
        },
        'lessons': {'token_config': {'flexible_pool_tokens': 7300}},
    }

@pytest.fixture
def mock_active_empty():
    return {
        'lessons': [],
        'total_lessons': 0,
        'token_config': {'flexible_pool_tokens': 7300}
    }

@pytest.fixture
def mock_active_with_lessons():
    return {
        'total_lessons': 3,
        'token_config': {'flexible_pool_tokens': 7300},
        'lessons': [
            {
                'id': 'lesson-001',
                'category': 'hard_rule',
                'confidence': 1.0,
                'archetypes': ['ALL'],
                'apply_to_next': True,
                'lesson': 'wt-inverse-vol always requires window-days as a string.',
                'regime_context': None,
                'parameter_data': None,
            },
            {
                'id': 'lesson-002',
                'category': 'indicator',
                'confidence': 0.85,
                'archetypes': ['ALL'],
                'apply_to_next': True,
                'lesson': 'max-drawdown on SVXY with window=2 is the best crash detector.',
                'regime_context': {'regime': 'BULL_CALM', 'regime_note': None},
                'parameter_data': {
                    'function': 'max-drawdown',
                    'asset': 'SVXY',
                    'optimal_window': 2,
                    'optimal_threshold': '10',
                    'threshold_range': '9-11',
                    'sensitivity': 'HIGH',
                    'archetype_overrides': {
                        'RETURN_CHASER': {'optimal_threshold': '13'},
                    },
                    'last_optimizer_confirmed_generation': None,
                },
            },
            {
                'id': 'lesson-003',
                'category': 'anti_pattern',
                'confidence': 0.95,
                'archetypes': ['ALL'],
                'apply_to_next': True,
                'lesson': 'Never equal-weight TQQQ and SOXL.',
                'regime_context': None,
                'parameter_data': None,
            },
        ]
    }

@pytest.fixture
def mock_patterns():
    return {
        'winning_patterns': [],
        'losing_patterns': [
            {
                'id': 'pat-bad-001',
                'name': 'Naked Leverage Hold',
                'never_do': 'Never allocate to a leveraged ETF without a guard.',
                'why_it_fails': '3x leverage amplifies crashes non-linearly.',
                'historical_evidence': ['2022: TQQQ -80%'],
            }
        ]
    }


# ── Mission brief tests ────────────────────────────────────────────────────────

class TestBuildMissionBrief:
    def test_all_archetypes_render(self, mock_meta):
        for arch in context_builder.VALID_ARCHETYPES:
            brief = context_builder.build_mission_brief(arch, 1, mock_meta)
            assert len(brief) > 100
            assert arch in brief or arch.replace('_', ' ').title() in brief

    def test_invalid_archetype_raises(self, mock_meta):
        with pytest.raises(ValueError, match='Invalid archetype'):
            context_builder.build_mission_brief('INVALID', 1, mock_meta)

    def test_regime_included_in_brief(self, mock_meta):
        brief = context_builder.build_mission_brief('SHARPE_HUNTER', 1, mock_meta)
        assert 'BULL_CALM' in brief

    def test_best_fitness_shown_when_available(self, mock_meta):
        brief = context_builder.build_mission_brief('SHARPE_HUNTER', 1, mock_meta)
        assert '78.4' in brief

    def test_none_fitness_shows_fallback(self, mock_meta):
        brief = context_builder.build_mission_brief('RETURN_CHASER', 1, mock_meta)
        assert 'none yet' in brief

    def test_unknown_regime_uses_fallback(self, mock_meta):
        mock_meta['kb_health']['current_market_regime'] = 'UNKNOWN'
        brief = context_builder.build_mission_brief('SHARPE_HUNTER', 1, mock_meta)
        assert 'UNKNOWN' in brief

    def test_generation_number_in_brief(self, mock_meta):
        brief = context_builder.build_mission_brief('SHARPE_HUNTER', 5, mock_meta)
        assert '5' in brief

    def test_sharpe_hunter_emphasises_sharpe(self, mock_meta):
        brief = context_builder.build_mission_brief('SHARPE_HUNTER', 1, mock_meta)
        assert 'Sharpe' in brief or 'sharpe' in brief.lower()

    def test_return_chaser_emphasises_return(self, mock_meta):
        brief = context_builder.build_mission_brief('RETURN_CHASER', 1, mock_meta)
        assert 'return' in brief.lower()

    def test_risk_minimizer_emphasises_drawdown(self, mock_meta):
        brief = context_builder.build_mission_brief('RISK_MINIMIZER', 1, mock_meta)
        assert 'drawdown' in brief.lower() or 'preservation' in brief.lower()

    def test_consistency_emphasises_variance(self, mock_meta):
        brief = context_builder.build_mission_brief('CONSISTENCY', 1, mock_meta)
        assert 'variance' in brief.lower() or 'consistent' in brief.lower()


# ── Hard rules tests ───────────────────────────────────────────────────────────

class TestHardRules:
    def test_all_eight_rules_present(self):
        for i in range(1, 9):
            assert f'RULE {i}' in context_builder.HARD_RULES

    def test_valid_node_types_listed(self):
        for node in ['wt-cash-equal', 'wt-inverse-vol', 'if', 'if-child',
                     'filter', 'asset', 'group']:
            assert node in context_builder.HARD_RULES

    def test_invalid_functions_named(self):
        for fn in ['risk-adjusted-momentum', 'momentum-persistence',
                   'wt-cash-dynamic', 'exponential-moving-average']:
            assert fn in context_builder.HARD_RULES

    def test_window_days_string_requirement(self):
        assert 'window-days' in context_builder.HARD_RULES
        assert '"10"' in context_builder.HARD_RULES

    def test_rhs_fixed_value_rule(self):
        assert 'rhs-fixed-value?' in context_builder.HARD_RULES

    def test_asset_universe_complete(self):
        for ticker in ['SVIX', 'SVXY', 'TQQQ', 'BIL', 'SPY', 'QQQ', 'UPRO']:
            assert ticker in context_builder.HARD_RULES

    def test_truncation_warning_present(self):
        assert 'truncate' in context_builder.HARD_RULES.lower()

    def test_wrapped_in_xml_tags(self):
        assert context_builder.HARD_RULES.strip().startswith('<hard_rules>')
        assert context_builder.HARD_RULES.strip().endswith('</hard_rules>')


# ── Parameter priors tests ─────────────────────────────────────────────────────

class TestBuildParameterPriors:
    def test_empty_lessons_returns_fallback(self, mock_active_empty):
        result = context_builder.build_parameter_priors(
            'SHARPE_HUNTER', mock_active_empty)
        assert 'No parameter priors' in result

    def test_indicator_lesson_rendered(self, mock_active_with_lessons):
        result = context_builder.build_parameter_priors(
            'SHARPE_HUNTER', mock_active_with_lessons)
        assert 'max-drawdown' in result
        assert 'SVXY' in result
        assert '0.85' in result

    def test_archetype_override_applied(self, mock_active_with_lessons):
        result = context_builder.build_parameter_priors(
            'RETURN_CHASER', mock_active_with_lessons)
        assert '13' in result
        assert 'override' in result.lower()

    def test_non_indicator_lessons_excluded(self, mock_active_with_lessons):
        result = context_builder.build_parameter_priors(
            'SHARPE_HUNTER', mock_active_with_lessons)
        # anti_pattern lesson should not appear in priors
        assert 'Never equal-weight' not in result

    def test_wrapped_in_xml_tags(self, mock_active_with_lessons):
        result = context_builder.build_parameter_priors(
            'SHARPE_HUNTER', mock_active_with_lessons)
        assert '<parameter_priors>' in result
        assert '</parameter_priors>' in result

    def test_apply_to_next_false_excluded(self, mock_active_with_lessons):
        mock_active_with_lessons['lessons'][1]['apply_to_next'] = False
        result = context_builder.build_parameter_priors(
            'SHARPE_HUNTER', mock_active_with_lessons)
        assert 'max-drawdown' not in result


# ── Lessons section tests ──────────────────────────────────────────────────────

class TestBuildLessonsSection:
    def test_empty_lessons_returns_fallback(self, mock_active_empty):
        result = context_builder.build_lessons_section(
            'SHARPE_HUNTER', 'BULL_CALM', mock_active_empty, 7300)
        assert 'No lessons available' in result

    def test_hard_rule_always_included(self, mock_active_with_lessons):
        result = context_builder.build_lessons_section(
            'SHARPE_HUNTER', 'BULL_CALM', mock_active_with_lessons, 7300)
        assert 'wt-inverse-vol' in result

    def test_wrapped_in_xml_tags(self, mock_active_with_lessons):
        result = context_builder.build_lessons_section(
            'SHARPE_HUNTER', 'BULL_CALM', mock_active_with_lessons, 7300)
        assert '<lessons>' in result
        assert '</lessons>' in result

    def test_confidence_shown(self, mock_active_with_lessons):
        result = context_builder.build_lessons_section(
            'SHARPE_HUNTER', 'BULL_CALM', mock_active_with_lessons, 7300)
        assert 'CONFIDENCE' in result

    def test_token_budget_reported(self, mock_active_with_lessons):
        result = context_builder.build_lessons_section(
            'SHARPE_HUNTER', 'BULL_CALM', mock_active_with_lessons, 7300)
        assert 'Token budget' in result

    def test_apply_to_next_false_excluded(self, mock_active_with_lessons):
        mock_active_with_lessons['lessons'][0]['apply_to_next'] = False
        result = context_builder.build_lessons_section(
            'SHARPE_HUNTER', 'BULL_CALM', mock_active_with_lessons, 7300)
        assert 'wt-inverse-vol always requires' not in result


# ── Anti-patterns tests ────────────────────────────────────────────────────────

class TestBuildAntiPatterns:
    def test_losing_pattern_included(self, mock_active_empty, mock_patterns):
        result = context_builder.build_anti_patterns(
            mock_active_empty, mock_patterns)
        assert 'Never allocate to a leveraged ETF' in result
        assert '3x leverage' in result

    def test_anti_pattern_lesson_included(self,
                                           mock_active_with_lessons,
                                           mock_patterns):
        result = context_builder.build_anti_patterns(
            mock_active_with_lessons, mock_patterns)
        assert 'Never equal-weight TQQQ' in result

    def test_wrapped_in_xml_tags(self, mock_active_empty, mock_patterns):
        result = context_builder.build_anti_patterns(
            mock_active_empty, mock_patterns)
        assert '<anti_patterns>' in result
        assert '</anti_patterns>' in result

    def test_historical_evidence_included(self, mock_active_empty, mock_patterns):
        result = context_builder.build_anti_patterns(
            mock_active_empty, mock_patterns)
        assert '2022' in result


# ── Parents section tests ──────────────────────────────────────────────────────

class TestBuildParentsSection:
    def test_empty_parents_returns_fallback(self):
        result = context_builder.build_parents_section([], 1)
        assert 'No parent strategies' in result

    def test_parent_name_included(self):
        parents = [{
            'name': 'Vol Guard v1',
            'fitness': 78.4,
            'sharpe_1Y': 2.1,
            'return_1Y': 55.0,
            'drawdown_1Y': 10.2,
            'top_level_structure': 'if SVXY crash → BIL else TQQQ',
            'composer_json': {'step': 'asset', 'ticker': 'BIL', 'children': []},
            'is_existing_symphony': False,
        }]
        result = context_builder.build_parents_section(parents, 1)
        assert 'Vol Guard v1' in result
        assert '78.4' in result

    def test_full_json_included(self):
        parents = [{
            'name': 'Test Parent',
            'fitness': 70.0,
            'top_level_structure': 'asset BIL',
            'composer_json': {'step': 'asset', 'ticker': 'BIL', 'children': []},
            'is_existing_symphony': False,
        }]
        result = context_builder.build_parents_section(parents, 1)
        assert '"step": "asset"' in result
        assert '"ticker": "BIL"' in result

    def test_gen0_existing_symphony_label(self):
        parents = [{
            'name': 'Beta Baller',
            'is_existing_symphony': True,
            'composer_json': {},
            'top_level_structure': 'filter top-1',
        }]
        result = context_builder.build_parents_section(parents, 0)
        assert 'existing live symphony' in result

    def test_wrapped_in_xml_tags(self):
        result = context_builder.build_parents_section([], 1)
        assert '<parent_strategies>' in result
        assert '</parent_strategies>' in result


# ── Example strategy tests ─────────────────────────────────────────────────────

class TestExampleStrategy:
    def test_valid_json(self):
        parsed = json.loads(context_builder.EXAMPLE_STRATEGY)
        assert isinstance(parsed, dict)

    def test_has_required_fields(self):
        parsed = json.loads(context_builder.EXAMPLE_STRATEGY)
        assert 'name' in parsed
        assert 'rebalance_frequency' in parsed
        assert 'description' in parsed
        assert 'children' in parsed

    def test_description_has_all_fields(self):
        parsed = json.loads(context_builder.EXAMPLE_STRATEGY)
        desc = parsed['description']
        assert 'summary' in desc
        assert 'logic_explanation' in desc
        assert 'regime_behavior' in desc
        assert 'archetype_rationale' in desc
        assert 'parameter_choices' in desc

    def test_regime_behavior_has_all_keys(self):
        parsed = json.loads(context_builder.EXAMPLE_STRATEGY)
        rb = parsed['description']['regime_behavior']
        assert 'crash' in rb
        assert 'bear' in rb
        assert 'normal' in rb

    def test_no_invalid_node_types(self):
        valid_steps = {
            'wt-cash-equal', 'wt-cash-specified', 'wt-inverse-vol',
            'wt-equal', 'if', 'if-child', 'filter', 'asset', 'group'
        }
        def check_nodes(node):
            if isinstance(node, dict):
                if 'step' in node:
                    assert node['step'] in valid_steps, \
                        f"Invalid step: {node['step']}"
                for child in node.get('children', []):
                    check_nodes(child)
        parsed = json.loads(context_builder.EXAMPLE_STRATEGY)
        for child in parsed.get('children', []):
            check_nodes(child)

    def test_all_tickers_in_universe(self):
        universe = {'SVIX','SVXY','UVXY','VIXM','TQQQ','TECL',
                    'SOXL','SPXL','UPRO','BIL','SPY','QQQ'}
        def find_tickers(node):
            tickers = []
            if isinstance(node, dict):
                if 'ticker' in node:
                    tickers.append(node['ticker'])
                for child in node.get('children', []):
                    tickers.extend(find_tickers(child))
            return tickers
        parsed = json.loads(context_builder.EXAMPLE_STRATEGY)
        for child in parsed.get('children', []):
            for ticker in find_tickers(child):
                assert ticker in universe, f"Ticker {ticker} not in universe"

    def test_every_if_has_else(self):
        def check_if_nodes(node):
            if isinstance(node, dict):
                if node.get('step') == 'if':
                    children = node.get('children', [])
                    else_count = sum(
                        1 for c in children
                        if c.get('is-else-condition?') is True
                    )
                    assert else_count == 1, \
                        f"if node missing else: {node}"
                for child in node.get('children', []):
                    check_if_nodes(child)
        parsed = json.loads(context_builder.EXAMPLE_STRATEGY)
        for child in parsed.get('children', []):
            check_if_nodes(child)

    def test_rhs_fixed_value_on_conditions(self):
        def check_conditions(node):
            if isinstance(node, dict):
                if node.get('step') == 'if-child' and \
                   not node.get('is-else-condition?', False):
                    if 'rhs-val' in node:
                        assert node.get('rhs-fixed-value?') is True, \
                            f"Missing rhs-fixed-value? on: {node}"
                for child in node.get('children', []):
                    check_conditions(child)
        parsed = json.loads(context_builder.EXAMPLE_STRATEGY)
        for child in parsed.get('children', []):
            check_conditions(child)

    def test_asset_nodes_have_empty_children(self):
        def check_assets(node):
            if isinstance(node, dict):
                if node.get('step') == 'asset':
                    assert node.get('children') == [], \
                        f"Asset node missing empty children: {node}"
                for child in node.get('children', []):
                    check_assets(child)
        parsed = json.loads(context_builder.EXAMPLE_STRATEGY)
        for child in parsed.get('children', []):
            check_assets(child)


# ── Token estimator tests ──────────────────────────────────────────────────────

class TestTokenEstimator:
    def test_returns_positive_int(self):
        assert context_builder._estimate_tokens("hello world") > 0

    def test_longer_text_more_tokens(self):
        short = context_builder._estimate_tokens("hi")
        long  = context_builder._estimate_tokens("hello world this is a much longer text")
        assert long > short

    def test_empty_string_returns_one(self):
        assert context_builder._estimate_tokens("") == 1
