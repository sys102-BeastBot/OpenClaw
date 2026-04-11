"""
Tests for generator_agent.py.
All Claude API calls and file writes are mocked.
Never hits real Anthropic API or writes real files.
"""
import copy
import json
import sys
import pytest
from pathlib import Path
from unittest.mock import patch, MagicMock, call

sys.path.insert(0, str(Path(__file__).parent.parent / 'src'))
import generator_agent as ga

FAKE_KEY = 'sk-ant-test-key-000'

# ── Valid strategy JSON Claude would return ────────────────────────────────────
VALID_STRATEGY_JSON = {
    "name": "Test Vol Guard",
    "rebalance_frequency": "daily",
    "description": {
        "summary": "Crash-protected momentum strategy",
        "logic_explanation": "If SVXY drops more than 10% in 2 days go to BIL else hold TQQQ.",
        "regime_behavior": {
            "crash": "100% BIL",
            "bear": "100% BIL",
            "normal": "100% TQQQ"
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

def make_claude_response(strategy_json: dict, status: int = 200):
    mock = MagicMock()
    mock.status_code = status
    mock.json.return_value = {
        'content': [{'type': 'text', 'text': json.dumps(strategy_json)}],
        'usage': {'input_tokens': 2000, 'output_tokens': 800},
    }
    mock.text = json.dumps(strategy_json)
    return mock


# ── JSON extraction tests ──────────────────────────────────────────────────────

class TestExtractStrategyJson:
    def test_clean_json_parses(self):
        text = json.dumps(VALID_STRATEGY_JSON)
        result = ga._extract_strategy_json(text)
        assert result is not None
        assert 'children' in result

    def test_json_with_preamble(self):
        text = 'Here is the strategy:\n' + json.dumps(VALID_STRATEGY_JSON)
        result = ga._extract_strategy_json(text)
        assert result is not None

    def test_json_with_markdown_fences(self):
        text = '```json\n' + json.dumps(VALID_STRATEGY_JSON) + '\n```'
        result = ga._extract_strategy_json(text)
        assert result is not None

    def test_missing_children_returns_none(self):
        result = ga._extract_strategy_json('{"name": "test"}')
        assert result is None

    def test_empty_string_returns_none(self):
        assert ga._extract_strategy_json('') is None

    def test_none_returns_none(self):
        assert ga._extract_strategy_json(None) is None

    def test_invalid_json_returns_none(self):
        assert ga._extract_strategy_json('{invalid}') is None


# ── Strategy file builder tests ────────────────────────────────────────────────

class TestBuildStrategyFile:
    def test_strategy_id_format(self):
        f = ga._build_strategy_file(VALID_STRATEGY_JSON, 'SHARPE_HUNTER', 3, 2, [])
        assert f['identity']['strategy_id'] == 'gen-003-strat-02'

    def test_status_is_pending(self):
        f = ga._build_strategy_file(VALID_STRATEGY_JSON, 'SHARPE_HUNTER', 1, 1, [])
        assert f['summary']['status'] == 'PENDING'
        assert f['pipeline']['current_status'] == 'PENDING'

    def test_daily_rebalance_format(self):
        f = ga._build_strategy_file(VALID_STRATEGY_JSON, 'SHARPE_HUNTER', 1, 1, [])
        rv = f['identity']['composer_rebalance_value']
        assert rv['rebalance-frequency'] == 'daily'
        assert 'rebalance-threshold' not in rv

    def test_5pct_rebalance_format(self):
        strat = dict(VALID_STRATEGY_JSON, rebalance_frequency='5%')
        f = ga._build_strategy_file(strat, 'SHARPE_HUNTER', 1, 1, [])
        rv = f['identity']['composer_rebalance_value']
        assert rv['rebalance-threshold'] == 0.05
        assert 'rebalance-frequency' not in rv

    def test_10pct_rebalance_format(self):
        strat = dict(VALID_STRATEGY_JSON, rebalance_frequency='10%')
        f = ga._build_strategy_file(strat, 'SHARPE_HUNTER', 1, 1, [])
        rv = f['identity']['composer_rebalance_value']
        assert rv['rebalance-threshold'] == 0.10

    def test_unknown_rebalance_defaults_to_daily(self):
        strat = dict(VALID_STRATEGY_JSON, rebalance_frequency='unknown')
        f = ga._build_strategy_file(strat, 'SHARPE_HUNTER', 1, 1, [])
        assert f['summary']['rebalance_frequency'] == 'daily'

    def test_parent_ids_set(self):
        f = ga._build_strategy_file(
            VALID_STRATEGY_JSON, 'SHARPE_HUNTER', 2, 1,
            ['gen-001-strat-01']
        )
        assert f['lineage']['parent_ids'] == ['gen-001-strat-01']
        assert f['lineage']['generation_type'] == 'MUTATION'

    def test_no_parents_is_novel(self):
        f = ga._build_strategy_file(VALID_STRATEGY_JSON, 'SHARPE_HUNTER', 1, 1, [])
        assert f['lineage']['generation_type'] == 'NOVEL'

    def test_all_result_sections_null(self):
        f = ga._build_strategy_file(VALID_STRATEGY_JSON, 'SHARPE_HUNTER', 1, 1, [])
        assert f['nominal_result'] is None
        assert f['optimizer_data'] is None
        assert f['final_result'] is None

    def test_logic_audit_pending(self):
        f = ga._build_strategy_file(VALID_STRATEGY_JSON, 'SHARPE_HUNTER', 1, 1, [])
        assert f['logic_audit']['status'] == 'PENDING'
        assert f['logic_audit']['quarantined'] is False

    def test_summary_ids_match_identity(self):
        f = ga._build_strategy_file(VALID_STRATEGY_JSON, 'SHARPE_HUNTER', 3, 4, [])
        assert f['summary']['strategy_id'] == f['identity']['strategy_id']
        assert f['summary']['name'] == f['identity']['name']

    def test_archetype_set_correctly(self):
        for arch in ['SHARPE_HUNTER', 'RETURN_CHASER', 'RISK_MINIMIZER', 'CONSISTENCY']:
            f = ga._build_strategy_file(VALID_STRATEGY_JSON, arch, 1, 1, [])
            assert f['summary']['archetype'] == arch
            assert f['identity']['archetype'] == arch


# ── run_generator_agent integration tests ─────────────────────────────────────

class TestRunGeneratorAgent:
    @patch('generator_agent.write_strategy_file')
    @patch('generator_agent.build_generator_prompt')
    @patch('requests.post')
    def test_successful_generation(self, mock_post, mock_prompt, mock_write):
        mock_prompt.return_value = 'mock prompt'
        mock_post.return_value = make_claude_response(VALID_STRATEGY_JSON)
        mock_write.return_value = 'pending/gen-001-strat-01.json'

        result = ga.run_generator_agent(
            'SHARPE_HUNTER', 1, 1, [], FAKE_KEY)

        assert result is not None
        assert result['summary']['status'] == 'PENDING'
        assert result['summary']['disqualified'] is False
        mock_write.assert_called_once()

    @patch('generator_agent.write_strategy_file')
    @patch('generator_agent.build_generator_prompt')
    @patch('requests.post')
    def test_invalid_json_returns_none(self, mock_post, mock_prompt, mock_write):
        mock_prompt.return_value = 'mock prompt'
        bad_resp = MagicMock()
        bad_resp.status_code = 200
        bad_resp.json.return_value = {
            'content': [{'type': 'text', 'text': 'not json at all'}],
            'usage': {'input_tokens': 100, 'output_tokens': 50},
        }
        mock_post.return_value = bad_resp

        result = ga.run_generator_agent(
            'SHARPE_HUNTER', 1, 1, [], FAKE_KEY)

        assert result is None
        mock_write.assert_not_called()

    @patch('generator_agent.write_strategy_file')
    @patch('generator_agent.build_generator_prompt')
    @patch('requests.post')
    def test_api_error_returns_none(self, mock_post, mock_prompt, mock_write):
        mock_prompt.return_value = 'mock prompt'
        mock_post.side_effect = Exception('Connection refused')

        result = ga.run_generator_agent(
            'SHARPE_HUNTER', 1, 1, [], FAKE_KEY)

        assert result is None
        mock_write.assert_not_called()

    @patch('generator_agent.write_strategy_file')
    @patch('generator_agent.build_generator_prompt')
    @patch('requests.post')
    def test_quarantined_strategy_still_written(
            self, mock_post, mock_prompt, mock_write):
        mock_prompt.return_value = 'mock prompt'
        # Strategy with invalid node type — will fail logic audit
        bad_strategy = copy.deepcopy(VALID_STRATEGY_JSON)
        bad_strategy['children'] = [
            {'step': 'invalid-node-type', 'children': []}
        ]
        mock_post.return_value = make_claude_response(bad_strategy)
        mock_write.return_value = 'pending/gen-001-strat-01.json'

        result = ga.run_generator_agent(
            'SHARPE_HUNTER', 1, 1, [], FAKE_KEY)

        # Quarantined but still returned and written
        assert result is not None
        assert result['summary']['disqualified'] is True
        assert result['summary']['status'] == 'DISQUALIFIED'
        assert result['pipeline']['disqualification_reason'] == 'INVALID_JSON'
        mock_write.assert_called_once()

    @patch('generator_agent.write_strategy_file')
    @patch('generator_agent.build_generator_prompt')
    @patch('requests.post')
    def test_http_429_returns_none(self, mock_post, mock_prompt, mock_write):
        mock_prompt.return_value = 'mock prompt'
        err_resp = MagicMock()
        err_resp.status_code = 429
        err_resp.text = 'Rate limit exceeded'
        mock_post.return_value = err_resp

        result = ga.run_generator_agent(
            'SHARPE_HUNTER', 1, 1, [], FAKE_KEY)

        assert result is None

    @patch('generator_agent.write_strategy_file')
    @patch('generator_agent.build_generator_prompt')
    @patch('requests.post')
    def test_invalid_archetype_raises(self, mock_post, mock_prompt, mock_write):
        with pytest.raises(ValueError, match='Invalid archetype'):
            ga.run_generator_agent(
                'INVALID', 1, 1, [], FAKE_KEY)

    @patch('generator_agent.write_strategy_file')
    @patch('generator_agent.build_generator_prompt')
    @patch('requests.post')
    def test_parent_ids_in_lineage(self, mock_post, mock_prompt, mock_write):
        mock_prompt.return_value = 'mock prompt'
        mock_post.return_value = make_claude_response(VALID_STRATEGY_JSON)
        mock_write.return_value = 'pending/gen-002-strat-01.json'

        result = ga.run_generator_agent(
            'SHARPE_HUNTER', 2, 1,
            ['gen-001-strat-01', 'gen-001-strat-03'],
            FAKE_KEY
        )

        assert result['lineage']['parent_ids'] == [
            'gen-001-strat-01', 'gen-001-strat-03'
        ]
        assert result['lineage']['generation_type'] == 'MUTATION'

    @patch('generator_agent.write_strategy_file')
    @patch('generator_agent.build_generator_prompt')
    @patch('requests.post')
    def test_audit_result_written_to_file(
            self, mock_post, mock_prompt, mock_write):
        mock_prompt.return_value = 'mock prompt'
        mock_post.return_value = make_claude_response(VALID_STRATEGY_JSON)
        mock_write.return_value = 'pending/gen-001-strat-01.json'

        result = ga.run_generator_agent(
            'SHARPE_HUNTER', 1, 1, [], FAKE_KEY)

        audit = result['logic_audit']
        assert audit['status'] in ('PASSED', 'FAILED')
        assert isinstance(audit['checks'], dict)
        assert isinstance(audit['failures'], list)

    @patch('generator_agent.write_strategy_file')
    @patch('generator_agent.build_generator_prompt')
    @patch('requests.post')
    def test_never_raises(self, mock_post, mock_prompt, mock_write):
        mock_prompt.side_effect = RuntimeError('Unexpected error')
        try:
            result = ga.run_generator_agent(
                'SHARPE_HUNTER', 1, 1, [], FAKE_KEY)
            assert result is None
        except Exception:
            pytest.fail("run_generator_agent should never raise")


# ── run_generation batch tests ─────────────────────────────────────────────────

class TestRunGeneration:
    @patch('generator_agent.run_generator_agent')
    @patch('generator_agent.read_json')
    def test_generates_correct_slot_count(self, mock_read, mock_run):
        mock_read.return_value = {
            'archetype_allocation': {
                'current': {
                    'SHARPE_HUNTER': 2,
                    'RETURN_CHASER': 2,
                    'RISK_MINIMIZER': 1,
                    'CONSISTENCY': 1,
                }
            }
        }
        mock_run.return_value = {'summary': {'strategy_id': 'test'}}

        results = ga.run_generation(1, FAKE_KEY, mock_read.return_value)
        assert mock_run.call_count == 6
        assert len(results) == 6

    @patch('generator_agent.run_generator_agent')
    @patch('generator_agent.read_json')
    def test_failed_slots_excluded_from_results(self, mock_read, mock_run):
        mock_read.return_value = {
            'archetype_allocation': {
                'current': {
                    'SHARPE_HUNTER': 2,
                    'RETURN_CHASER': 1,
                    'RISK_MINIMIZER': 1,
                    'CONSISTENCY': 1,
                }
            }
        }
        # Second call returns None (failure)
        mock_run.side_effect = [
            {'summary': {'strategy_id': 'gen-001-strat-01'}},
            None,
            {'summary': {'strategy_id': 'gen-001-strat-03'}},
            {'summary': {'strategy_id': 'gen-001-strat-04'}},
            {'summary': {'strategy_id': 'gen-001-strat-05'}},
        ]

        results = ga.run_generation(1, FAKE_KEY, mock_read.return_value)
        assert len(results) == 4   # one slot failed

    @patch('generator_agent.run_generator_agent')
    @patch('generator_agent.read_json')
    def test_sequential_slot_numbers(self, mock_read, mock_run):
        mock_read.return_value = {
            'archetype_allocation': {
                'current': {
                    'SHARPE_HUNTER': 2,
                    'RETURN_CHASER': 1,
                    'RISK_MINIMIZER': 1,
                    'CONSISTENCY': 1,
                }
            }
        }
        mock_run.return_value = {'summary': {'strategy_id': 'test'}}

        ga.run_generation(1, FAKE_KEY, mock_read.return_value)

        slot_numbers = [c.kwargs['slot_number']
                        for c in mock_run.call_args_list]
        assert slot_numbers == [1, 2, 3, 4, 5]
