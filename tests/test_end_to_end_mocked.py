"""
test_end_to_end_mocked.py — Full pipeline integration test (mocked).

Verifies that all components wire together correctly:
  Generator → Backtest → Optimizer → Learner → KB updated

No real API calls. All HTTP mocked. Runs in CI.
"""
import copy
import json
import sys
import pytest
from pathlib import Path
from unittest.mock import patch, MagicMock, call

sys.path.insert(0, str(Path(__file__).parent.parent / 'src'))

import generator_agent as ga
import backtest_runner as br
import scorer as sc
import kb_writer as kw
import graveyard as gv
import lineage_tracker as lt
import learner_prep as lp
import learner_agent as la

FAKE_KEY   = 'sk-ant-test-key-000'
GENERATION = 1
ARCHETYPE  = 'SHARPE_HUNTER'

# ── Mock data ──────────────────────────────────────────────────────────────────

VALID_STRATEGY_JSON = {
    "name": "E2E Test Vol Guard",
    "rebalance_frequency": "daily",
    "description": {
        "summary": "Crash-protected momentum strategy",
        "logic_explanation": (
            "If SVXY drops more than 10% in 2 days go to BIL "
            "else hold TQQQ."
        ),
        "regime_behavior": {
            "crash": "100% BIL",
            "bear":  "100% BIL",
            "normal":"100% TQQQ"
        },
        "archetype_rationale": "Guard prevents drawdown.",
        "parameter_choices": {"svxy_threshold": "10 — KB prior"}
    },
    "children": [
        {
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
                        {"step": "asset", "ticker": "BIL", "children": []}
                    ]
                },
                {
                    "step": "if-child",
                    "is-else-condition?": True,
                    "children": [
                        {"step": "asset", "ticker": "TQQQ", "children": []}
                    ]
                }
            ]
        }
    ]
}

MOCK_PERIOD_STATS = {
    "annualized_rate_of_return": 0.621,
    "cumulative_return":          0.621,
    "sharpe_ratio":               2.14,
    "max_drawdown":               0.094,
    "standard_deviation":         0.182,
    "win_rate":                   0.624,
    "sortino_ratio":              2.98,
    "calmar_ratio":               6.61,
    "annualized_turnover":        86.4,
    "tail_ratio":                 0.91,
    "herfindahl_index":           1.0,
    "trailing_one_month_return":  0.042,
    "trailing_three_month_return":0.118,
    "benchmarks": {
        "SPY": {
            "annualized_rate_of_return": 0.241,
            "sharpe_ratio":              1.12,
            "max_drawdown":              0.137,
            "standard_deviation":        0.189,
            "percent": {
                "alpha":     0.38,
                "beta":     -0.21,
                "r_square":  0.04,
                "pearson_r":-0.19,
            }
        }
    }
}

MOCK_BACKTEST_RESPONSE = {
    "stats":       MOCK_PERIOD_STATS,
    "dvm_capital": {"test-id": {"20500": 12500.0}},
    "trades":      [],
}

MOCK_META = {
    "system": {
        "system_mode": "EVALUATE",
        "execution_permitted": False,
        "deploy_permitted": False,
        "halted": False,
    },
    "generations": {"current": 1, "total_completed": 0},
    "best_ever": None,
    "best_per_archetype": {
        "SHARPE_HUNTER": None, "RETURN_CHASER": None,
        "RISK_MINIMIZER": None, "CONSISTENCY": None,
    },
    "config": {
        "strategies_per_generation": 2,
        "backtest_periods": ["1Y", "2Y"],
        "optimizer_rough_cut_threshold": 40,
        "default_rebalance_frequency": "daily",
        "asset_universe": [
            "SVIX","SVXY","UVXY","VIXM",
            "TQQQ","TECL","SOXL","SPXL","UPRO",
            "BIL","SPY","QQQ"
        ],
        "broker": "ALPACA_WHITE_LABEL",
        "benchmark": "SPY",
        "capital": 10000,
    },
    "fitness": {
        "global_weights": {"sharpe": 0.35, "return": 0.40, "drawdown": 0.25},
        "archetype_weights": {
            "SHARPE_HUNTER":  {"sharpe": 0.45, "return": 0.30, "drawdown": 0.25},
            "RETURN_CHASER":  {"sharpe": 0.30, "return": 0.45, "drawdown": 0.25},
            "RISK_MINIMIZER": {"sharpe": 0.25, "return": 0.30, "drawdown": 0.45},
            "CONSISTENCY":    {"sharpe": 0.25, "return": 0.25, "drawdown": 0.50},
        },
        "period_weights": {"6M":0.10,"1Y":0.30,"2Y":0.30,"3Y":0.30},
        "bonuses": {
            "sharpe_min_threshold": 2.0, "sharpe_bonus": 3,
            "drawdown_threshold": 15.0,  "drawdown_bonus": 3,
            "return_threshold": 40.0,    "return_bonus": 3,
            "consistency_std_dev_threshold": 10.0, "consistency_bonus": 2,
            "beats_benchmark_bonus": 1,
        },
        "disqualifiers": {
            "min_return": -20.0, "max_drawdown": 65.0, "min_sharpe": -1.0
        },
        "graveyard_thresholds": {
            "poor_performer_absolute": 20,
            "poor_performer_std_dev_multiplier": 1.5,
            "poor_performer_logic": "BOTH",
        },
    },
    "archetype_allocation": {
        "window_size": 5, "weighting": "recency",
        "minimum_per_archetype": 1,
        "current": {
            "SHARPE_HUNTER": 1, "RETURN_CHASER": 1,
            "RISK_MINIMIZER": 0, "CONSISTENCY": 0,
        },
        "last_rebalanced_generation": 0,
        "performance_history": {
            "SHARPE_HUNTER": [], "RETURN_CHASER": [],
            "RISK_MINIMIZER": [], "CONSISTENCY": [],
        },
        "window_size_schedule": {"20":5,"50":10,"100":15,"200":20},
    },
    "kb_health": {
        "current_market_regime": "BULL_CALM",
        "last_compacted_generation": 0,
        "next_compaction_due_generation": 3,
        "active_lesson_count": 0,
        "total_raw_lessons": 0,
        "graveyard_count": 0,
        "pattern_count": {"winning": 0, "losing": 0},
        "last_quarterly_refresh": None,
        "next_quarterly_refresh": "2026-06-01T00:00:00Z",
        "regime_history": [],
    },
}

MOCK_ACTIVE_LESSONS = {"lessons": [], "total_lessons": 0,
                        "token_config": {"flexible_pool_tokens": 7300}}
MOCK_PATTERNS       = {"winning_patterns": [], "losing_patterns": []}

MOCK_LESSONS_RESPONSE = {
    "generation": 1,
    "lessons_extracted": 2,
    "lessons": [
        {
            "category": "indicator",
            "subcategory": "drawdown_guard",
            "confidence": 0.75,
            "decay": True,
            "archetypes": ["ALL"],
            "lesson": "max-drawdown window=2 confirmed effective in gen-1.",
            "parameter_data": {
                "function": "max-drawdown",
                "asset": "SVXY",
                "optimal_window": 2,
                "optimal_threshold": "10",
                "threshold_range": "9-11",
                "sensitivity": "HIGH",
                "archetype_overrides": {},
            },
            "regime_context": None,
            "supporting_evidence": ["gen-001-strat-01"],
            "merge_candidate_ids": [],
            "apply_to_active": True,
        },
        {
            "category": "structure",
            "subcategory": "guard_layer",
            "confidence": 0.65,
            "decay": True,
            "archetypes": ["SHARPE_HUNTER"],
            "lesson": "Single crash guard outperformed no-guard in gen-1.",
            "parameter_data": None,
            "regime_context": None,
            "supporting_evidence": ["gen-001-strat-01"],
            "merge_candidate_ids": [],
            "apply_to_active": True,
        },
    ],
    "compaction_hints": {
        "confirmed_lesson_ids":    [],
        "contradicted_lesson_ids": [],
        "merge_suggestions":       [],
        "retire_suggestions":      [],
    },
}

def make_http_mock(data: dict, status: int = 200):
    m = MagicMock()
    m.status_code = status
    m.json.return_value = data
    m.text = json.dumps(data)
    return m


# ── Stage 1: Generator ─────────────────────────────────────────────────────────

class TestStage1Generator:
    """Generator produces valid strategy and writes to pending/."""

    @patch('generator_agent.write_strategy_file')
    @patch('generator_agent.build_generator_prompt')
    @patch('requests.post')
    def test_generator_produces_pending_strategy(
            self, mock_post, mock_prompt, mock_write):
        mock_prompt.return_value = 'mock prompt'
        mock_post.return_value = make_http_mock({
            'content': [{'type': 'text',
                          'text': json.dumps(VALID_STRATEGY_JSON)}],
            'usage': {'input_tokens': 2000, 'output_tokens': 800},
        })
        mock_write.return_value = 'pending/gen-001-strat-01.json'

        result = ga.run_generator_agent(
            ARCHETYPE, GENERATION, 1, [], FAKE_KEY)

        assert result is not None
        assert result['summary']['status'] == 'PENDING'
        assert result['summary']['archetype'] == ARCHETYPE
        assert result['logic_audit']['quarantined'] is False
        mock_write.assert_called_once()

    @patch('generator_agent.write_strategy_file')
    @patch('generator_agent.build_generator_prompt')
    @patch('requests.post')
    def test_strategy_id_format_correct(
            self, mock_post, mock_prompt, mock_write):
        mock_prompt.return_value = 'mock prompt'
        mock_post.return_value = make_http_mock({
            'content': [{'type': 'text',
                          'text': json.dumps(VALID_STRATEGY_JSON)}],
            'usage': {'input_tokens': 2000, 'output_tokens': 800},
        })
        mock_write.return_value = 'pending/gen-001-strat-02.json'

        result = ga.run_generator_agent(
            ARCHETYPE, GENERATION, 2, [], FAKE_KEY)

        assert result['identity']['strategy_id'] == 'gen-001-strat-02'


# ── Stage 2: Backtest (nominal) ────────────────────────────────────────────────

class TestStage2NominalBacktest:
    """Backtester submits strategy and populates nominal_result."""

    @patch('backtest_runner._delete_symphony')
    @patch('backtest_runner._create_temp_symphony')
    @patch('backtest_runner._get_headers')
    @patch('backtest_runner._post')
    def test_nominal_backtest_populates_periods(self, mock_post, mock_headers,
                                                mock_create, mock_delete):
        mock_headers.return_value = {'x-api-key-id': 'test', 'authorization': 'Bearer test'}
        mock_create.return_value  = 'sym-mock'
        mock_delete.return_value  = None
        mock_post.return_value    = MOCK_BACKTEST_RESPONSE

        # Build a strategy file at PENDING status
        strat = ga._build_strategy_file(
            VALID_STRATEGY_JSON, ARCHETYPE, GENERATION, 1, []
        )

        result = br.run_nominal_backtest(strat, ['1Y', '2Y'], MOCK_META)

        assert result['nominal_result'] is not None
        assert '1Y' in result['nominal_result']['periods']
        assert '2Y' in result['nominal_result']['periods']
        assert result['pipeline']['current_status'] == 'NOMINAL_COMPLETE'

    @patch('backtest_runner._delete_symphony')
    @patch('backtest_runner._create_temp_symphony')
    @patch('backtest_runner._get_headers')
    @patch('backtest_runner._post')
    def test_nominal_backtest_core_metrics_correct(self, mock_post, mock_headers,
                                                   mock_create, mock_delete):
        mock_headers.return_value = {'x-api-key-id': 'test', 'authorization': 'Bearer test'}
        mock_create.return_value  = 'sym-mock'
        mock_delete.return_value  = None
        mock_post.return_value    = MOCK_BACKTEST_RESPONSE
        strat = ga._build_strategy_file(
            VALID_STRATEGY_JSON, ARCHETYPE, GENERATION, 1, []
        )

        result = br.run_nominal_backtest(strat, ['1Y'], MOCK_META)
        period = result['nominal_result']['periods']['1Y']
        core   = period['core_metrics']

        assert abs(core['annualized_return'] - 62.1) < 1.0
        assert abs(core['sharpe'] - 2.14) < 0.01
        assert abs(core['max_drawdown'] - 9.4) < 1.0


# ── Stage 3: Scoring ───────────────────────────────────────────────────────────

class TestStage3Scoring:
    """Scorer computes fitness from nominal backtest results."""

    def test_period_scoring_produces_fitness(self):
        period_data = {
            'core_metrics': {
                'annualized_return': 62.1,
                'total_return':      62.1,
                'sharpe':            2.14,
                'max_drawdown':      9.4,
                'volatility':        18.2,
                'win_rate':          62.4,
            },
            'benchmark_metrics': {
                'benchmark_ticker':            'SPY',
                'benchmark_annualized_return': 24.1,
                'beats_benchmark':             True,
                'alpha': 0.38, 'beta': -0.21,
                'r_squared': 0.04, 'correlation': -0.19,
            },
            'fitness': None,
            'raw_api_fields': {},
        }

        result = sc.score_period(period_data, ARCHETYPE, MOCK_META)

        assert result['fitness'] is not None
        assert result['fitness']['period_fitness_score'] > 0
        assert result['fitness']['period_fitness_score'] <= 112

    def test_above_targets_earns_bonuses(self):
        period_data = {
            'core_metrics': {
                'annualized_return': 62.1,
                'total_return':      62.1,
                'sharpe':            2.14,
                'max_drawdown':      9.4,
                'volatility':        18.2,
                'win_rate':          62.4,
            },
            'benchmark_metrics': {
                'benchmark_ticker':            'SPY',
                'benchmark_annualized_return': 24.1,
                'beats_benchmark':             True,
                'alpha': None, 'beta': None,
                'r_squared': None, 'correlation': None,
            },
            'fitness': None,
            'raw_api_fields': {},
        }

        result = sc.score_period(period_data, ARCHETYPE, MOCK_META)
        bonuses = result['fitness']['bonuses_applied']

        assert bonuses['sharpe_bonus'] is True
        assert bonuses['drawdown_bonus'] is True
        assert bonuses['return_bonus'] is True

    def test_composite_uses_period_weights(self):
        period_scores = {'6M': 70.0, '1Y': 80.0, '2Y': 75.0, '3Y': 78.0}
        composite = sc.compute_composite(period_scores, MOCK_META)

        expected = (70.0*0.10 + 80.0*0.30 + 75.0*0.30 + 78.0*0.30)
        assert abs(composite['weighted_composite'] - expected) < 0.01


# ── Stage 4: Learner prep ──────────────────────────────────────────────────────

class TestStage4LearnerPrep:
    """learner_prep summarises results into a clean brief."""

    def test_brief_contains_generation_summary(self):
        # Build a scored result
        period_data = {
            'core_metrics': {
                'annualized_return': 62.1, 'total_return': 62.1,
                'sharpe': 2.14, 'max_drawdown': 9.4,
                'volatility': 18.2, 'win_rate': 62.4,
            },
            'benchmark_metrics': {
                'benchmark_ticker': 'SPY',
                'benchmark_annualized_return': 24.1,
                'beats_benchmark': True,
                'alpha': None, 'beta': None,
                'r_squared': None, 'correlation': None,
            },
            'fitness': None, 'raw_api_fields': {},
        }
        scored = sc.score_period(period_data, ARCHETYPE, MOCK_META)
        composite = sc.compute_composite(
            {'6M': 72.0, '1Y': scored['fitness']['period_fitness_score'],
             '2Y': 70.0, '3Y': 71.0},
            MOCK_META
        )

        mock_result = {
            'summary': {
                'strategy_id':            'gen-001-strat-01',
                'name':                   'Test Strategy',
                'archetype':              ARCHETYPE,
                'generation':             GENERATION,
                'final_composite_fitness': composite['final_composite'],
                'final_sharpe_1Y':         2.14,
                'final_return_1Y':         62.1,
                'final_max_drawdown_1Y':   9.4,
                'final_std_dev':           composite['std_dev'],
                'optimization_delta':      '+3.2',
                'passed_rough_cut':        True,
                'disqualified':            False,
                'status':                  'COMPLETE',
                'rebalance_frequency':     'daily',
            },
            'strategy': {
                'description': VALID_STRATEGY_JSON['description'],
                'composer_json': VALID_STRATEGY_JSON,
            },
            'optimizer_data': {
                'parameter_sensitivity': {},
                'optimal_parameters': {},
                'parameter_diff': {},
                'fitness_delta': {
                    'delta': '+3.2',
                    'delta_interpretation': 'SMALL',
                },
            },
            'pipeline': {'disqualified': False, 'current_status': 'COMPLETE'},
        }

        brief = lp.build_brief([mock_result], [], GENERATION)

        assert brief['generation'] == GENERATION
        assert brief['generation_summary']['total_strategies'] == 1
        assert 'ranked_strategies' in brief
        assert len(brief['ranked_strategies']) == 1


# ── Stage 5: Learner Agent ─────────────────────────────────────────────────────

class TestStage5LearnerAgent:
    """Learner Agent extracts lessons from brief."""

    @patch('requests.post')
    def test_learner_extracts_lessons(self, mock_post):
        mock_post.return_value = make_http_mock({
            'content': [{'type': 'text',
                          'text': json.dumps(MOCK_LESSONS_RESPONSE)}],
            'usage': {'input_tokens': 3000, 'output_tokens': 1200},
        })

        brief = {
            'generation': GENERATION,
            'total_strategies': 1,
            'archetype_summary': {ARCHETYPE: {'count': 1, 'avg_fitness': 78.4}},
            'ranked_results': [],
            'disqualified': [],
            'parameter_sensitivity': {},
            'generation_stats': {
                'avg_fitness': 78.4, 'std_dev_fitness': 0.0,
                'best_fitness': 78.4, 'worst_fitness': 78.4,
            },
        }

        result = la.run_learner_agent(
            GENERATION, brief, MOCK_ACTIVE_LESSONS, FAKE_KEY)

        assert result['lessons_extracted'] == 2
        assert result['_extraction_failed'] is False
        assert len(result['lessons']) == 2

    @patch('requests.post')
    def test_lessons_have_correct_structure(self, mock_post):
        mock_post.return_value = make_http_mock({
            'content': [{'type': 'text',
                          'text': json.dumps(MOCK_LESSONS_RESPONSE)}],
            'usage': {'input_tokens': 3000, 'output_tokens': 1200},
        })

        brief = {
            'generation': GENERATION,
            'total_strategies': 1,
            'archetype_summary': {},
            'ranked_results': [],
            'disqualified': [],
            'parameter_sensitivity': {},
            'generation_stats': {
                'avg_fitness': 78.4, 'std_dev_fitness': 0.0,
                'best_fitness': 78.4, 'worst_fitness': 78.4,
            },
        }

        result = la.run_learner_agent(
            GENERATION, brief, MOCK_ACTIVE_LESSONS, FAKE_KEY)

        for lesson in result['lessons']:
            assert 'category' in lesson
            assert 'confidence' in lesson
            assert 'lesson' in lesson
            assert 'archetypes' in lesson


# ── Full pipeline wiring test ──────────────────────────────────────────────────

class TestFullPipelineWiring:
    """Verify all components connect without errors."""

    @patch('backtest_runner._delete_symphony')
    @patch('backtest_runner._create_temp_symphony')
    @patch('backtest_runner._get_headers')
    @patch('requests.post')
    @patch('backtest_runner._post')
    @patch('generator_agent.write_strategy_file')
    @patch('generator_agent.build_generator_prompt')
    def test_generator_to_backtest_to_scorer(
            self, mock_prompt, mock_write,
            mock_bt_post, mock_claude_post, mock_headers,
            mock_create, mock_delete):
        mock_headers.return_value = {'x-api-key-id': 'test', 'authorization': 'Bearer test'}
        mock_create.return_value  = 'sym-mock'
        mock_delete.return_value  = None
        # Generator
        mock_prompt.return_value = 'mock prompt'
        mock_claude_post.return_value = make_http_mock({
            'content': [{'type': 'text',
                          'text': json.dumps(VALID_STRATEGY_JSON)}],
            'usage': {'input_tokens': 2000, 'output_tokens': 800},
        })
        mock_write.return_value = 'pending/gen-001-strat-01.json'
        mock_bt_post.return_value = MOCK_BACKTEST_RESPONSE

        # Stage 1: Generate
        strategy = ga.run_generator_agent(
            ARCHETYPE, GENERATION, 1, [], FAKE_KEY)
        assert strategy is not None
        assert strategy['summary']['status'] == 'PENDING'

        # Stage 2: Backtest
        strategy = br.run_nominal_backtest(strategy, ['1Y'], MOCK_META)
        assert strategy['nominal_result'] is not None
        assert strategy['pipeline']['current_status'] == 'NOMINAL_COMPLETE'

        # Stage 3: Score
        period = strategy['nominal_result']['periods']['1Y']
        scored_period = sc.score_period(period, ARCHETYPE, MOCK_META)
        assert scored_period['fitness']['period_fitness_score'] > 0

        # Stage 4: Composite
        composite = sc.compute_composite(
            {'6M': 70.0, '1Y': scored_period['fitness']['period_fitness_score'],
             '2Y': 68.0, '3Y': 71.0},
            MOCK_META
        )
        assert composite['final_composite'] > 0

        # Passes rough cut
        assert composite['final_composite'] > \
               MOCK_META['config']['optimizer_rough_cut_threshold']

    @patch('requests.post')
    def test_learner_prep_to_learner_agent(self, mock_post):
        mock_post.return_value = make_http_mock({
            'content': [{'type': 'text',
                          'text': json.dumps(MOCK_LESSONS_RESPONSE)}],
            'usage': {'input_tokens': 3000, 'output_tokens': 1200},
        })

        mock_result = {
            'summary': {
                'strategy_id':            'gen-001-strat-01',
                'name':                   'Test',
                'archetype':              ARCHETYPE,
                'generation':             GENERATION,
                'final_composite_fitness': 78.4,
                'final_sharpe_1Y':         2.14,
                'final_return_1Y':         62.1,
                'final_max_drawdown_1Y':   9.4,
                'final_std_dev':           2.1,
                'optimization_delta':      '+3.2',
                'passed_rough_cut':        True,
                'disqualified':            False,
                'status':                  'COMPLETE',
                'rebalance_frequency':     'daily',
            },
            'strategy': {
                'description': VALID_STRATEGY_JSON['description'],
                'composer_json': VALID_STRATEGY_JSON,
            },
            'optimizer_data': {
                'parameter_sensitivity': {},
                'optimal_parameters': {},
                'parameter_diff': {},
                'fitness_delta': {
                    'delta': '+3.2',
                    'delta_interpretation': 'SMALL',
                },
            },
            'pipeline': {'disqualified': False, 'current_status': 'COMPLETE'},
        }

        # learner_prep → brief
        brief = lp.build_brief([mock_result], [], GENERATION)
        assert brief['generation_summary']['total_strategies'] == 1

        # brief → learner_agent → lessons
        lessons = la.run_learner_agent(
            GENERATION, brief, MOCK_ACTIVE_LESSONS, FAKE_KEY)
        assert lessons['lessons_extracted'] == 2
        assert lessons['_extraction_failed'] is False
