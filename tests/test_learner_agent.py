"""
Tests for learner_agent.py.
All Claude API calls are mocked — never hits real Anthropic API.
"""
import json
import sys
import pytest
from pathlib import Path
from unittest.mock import patch, MagicMock

sys.path.insert(0, str(Path(__file__).parent.parent / 'src'))
import learner_agent as la

# ── Fixtures ───────────────────────────────────────────────────────────────────

FAKE_KEY = 'sk-ant-test-key-000'

@pytest.fixture
def minimal_brief():
    return {
        'generation': 3,
        'total_strategies': 5,
        'archetype_summary': {
            'SHARPE_HUNTER': {'count': 2, 'avg_fitness': 72.1},
            'RETURN_CHASER':  {'count': 2, 'avg_fitness': 68.4},
            'CONSISTENCY':    {'count': 1, 'avg_fitness': 65.0},
        },
        'ranked_results': [],
        'disqualified': [],
        'parameter_sensitivity': {},
        'generation_stats': {
            'avg_fitness': 69.5,
            'std_dev_fitness': 5.2,
            'best_fitness': 78.4,
            'worst_fitness': 58.1,
        },
    }

@pytest.fixture
def empty_active_lessons():
    return {'lessons': [], 'total_lessons': 0}

@pytest.fixture
def active_with_lessons():
    return {
        'total_lessons': 2,
        'lessons': [
            {
                'id': 'lesson-001',
                'category': 'hard_rule',
                'confidence': 1.0,
                'archetypes': ['ALL'],
                'lesson': 'wt-inverse-vol requires window-days as string.',
            },
            {
                'id': 'lesson-002',
                'category': 'indicator',
                'confidence': 0.75,
                'archetypes': ['ALL'],
                'lesson': 'max-drawdown window=2 is best crash detector.',
            },
        ]
    }

@pytest.fixture
def valid_claude_response():
    return {
        'generation': 3,
        'lessons_extracted': 2,
        'lessons': [
            {
                'category': 'indicator',
                'subcategory': 'drawdown_guard',
                'confidence': 0.80,
                'decay': True,
                'archetypes': ['ALL'],
                'lesson': 'max-drawdown window=2 confirmed optimal in gen-3. '
                          'All 4 strategies using it outperformed window=5 variants.',
                'parameter_data': {
                    'function': 'max-drawdown',
                    'asset': 'SVXY',
                    'optimal_window': 2,
                    'optimal_threshold': '10',
                    'threshold_range': '9-11',
                    'sensitivity': 'HIGH',
                    'archetype_overrides': {},
                },
                'regime_context': None,
                'supporting_evidence': ['gen-003-strat-01', 'gen-003-strat-02'],
                'merge_candidate_ids': ['lesson-002'],
                'apply_to_active': True,
            },
            {
                'category': 'structure',
                'subcategory': 'nesting',
                'confidence': 0.70,
                'decay': True,
                'archetypes': ['SHARPE_HUNTER'],
                'lesson': 'Three-layer nesting outperformed two-layer in '
                          'gen-003-strat-01 vs gen-003-strat-03 (fitness +8.2).',
                'parameter_data': None,
                'regime_context': None,
                'supporting_evidence': ['gen-003-strat-01', 'gen-003-strat-03'],
                'merge_candidate_ids': [],
                'apply_to_active': True,
            },
        ],
        'compaction_hints': {
            'confirmed_lesson_ids': ['lesson-002'],
            'contradicted_lesson_ids': [],
            'merge_suggestions': [],
            'retire_suggestions': [],
        }
    }

def make_mock_response(data: dict, status: int = 200):
    """Build a mock requests.Response for the Claude API."""
    mock_resp = MagicMock()
    mock_resp.status_code = status
    mock_resp.json.return_value = {
        'content': [{'type': 'text', 'text': json.dumps(data)}],
        'usage': {'input_tokens': 1000, 'output_tokens': 500},
    }
    mock_resp.text = json.dumps(data)
    return mock_resp


# ── Prompt building tests ──────────────────────────────────────────────────────

class TestBuildLearnerPrompt:
    def test_generation_number_in_prompt(self, minimal_brief, empty_active_lessons):
        prompt = la.build_learner_prompt(minimal_brief, empty_active_lessons, 3)
        assert 'Generation 3' in prompt or 'generation": 3' in prompt

    def test_next_generation_in_prompt(self, minimal_brief, empty_active_lessons):
        prompt = la.build_learner_prompt(minimal_brief, empty_active_lessons, 3)
        assert '4' in prompt

    def test_xml_sections_present(self, minimal_brief, empty_active_lessons):
        prompt = la.build_learner_prompt(minimal_brief, empty_active_lessons, 3)
        for tag in ['<generation_brief>', '<existing_lessons>',
                    '<extraction_instructions>', '<output_format>']:
            assert tag in prompt

    def test_brief_serialised_in_prompt(self, minimal_brief, empty_active_lessons):
        prompt = la.build_learner_prompt(minimal_brief, empty_active_lessons, 3)
        assert 'total_strategies' in prompt

    def test_existing_lessons_in_prompt(self, minimal_brief, active_with_lessons):
        prompt = la.build_learner_prompt(minimal_brief, active_with_lessons, 3)
        assert 'lesson-001' in prompt
        assert 'lesson-002' in prompt

    def test_empty_lessons_fallback_message(self, minimal_brief, empty_active_lessons):
        prompt = la.build_learner_prompt(minimal_brief, empty_active_lessons, 3)
        assert 'No active lessons yet' in prompt

    def test_quality_rules_present(self, minimal_brief, empty_active_lessons):
        prompt = la.build_learner_prompt(minimal_brief, empty_active_lessons, 3)
        assert 'QUALITY RULES' in prompt

    def test_good_bad_examples_present(self, minimal_brief, empty_active_lessons):
        prompt = la.build_learner_prompt(minimal_brief, empty_active_lessons, 3)
        assert 'GOOD LESSON' in prompt or 'good lesson' in prompt.lower()
        assert 'BAD LESSON' in prompt or 'bad lesson' in prompt.lower()


# ── JSON extraction tests ──────────────────────────────────────────────────────

class TestExtractJson:
    def test_clean_json_parses(self, valid_claude_response):
        text = json.dumps(valid_claude_response)
        result = la._extract_json(text)
        assert result is not None
        assert result['generation'] == 3

    def test_json_with_preamble(self, valid_claude_response):
        text = 'Here is the output:\n' + json.dumps(valid_claude_response)
        result = la._extract_json(text)
        assert result is not None

    def test_json_with_markdown_fences(self, valid_claude_response):
        text = '```json\n' + json.dumps(valid_claude_response) + '\n```'
        result = la._extract_json(text)
        assert result is not None

    def test_empty_string_returns_none(self):
        assert la._extract_json('') is None

    def test_none_returns_none(self):
        assert la._extract_json(None) is None

    def test_invalid_json_returns_none(self):
        assert la._extract_json('{invalid json}') is None

    def test_partial_json_returns_none(self):
        assert la._extract_json('{"lessons": [{"category":') is None


# ── Lesson validation tests ────────────────────────────────────────────────────

class TestValidateLesson:
    def test_valid_lesson_passes(self, valid_claude_response):
        lesson = valid_claude_response['lessons'][0]
        is_valid, errors = la._validate_lesson(lesson, 0)
        assert is_valid
        assert errors == []

    def test_missing_lesson_text_fails(self):
        lesson = {'category': 'indicator', 'confidence': 0.7,
                  'archetypes': ['ALL']}
        is_valid, errors = la._validate_lesson(lesson, 0)
        assert not is_valid
        assert any('lesson' in e for e in errors)

    def test_invalid_category_fails(self):
        lesson = {'category': 'made_up', 'confidence': 0.7,
                  'archetypes': ['ALL'], 'lesson': 'test'}
        is_valid, errors = la._validate_lesson(lesson, 0)
        assert not is_valid
        assert any('category' in e for e in errors)

    def test_confidence_out_of_range_fails(self):
        lesson = {'category': 'indicator', 'confidence': 1.5,
                  'archetypes': ['ALL'], 'lesson': 'test'}
        is_valid, errors = la._validate_lesson(lesson, 0)
        assert not is_valid
        assert any('confidence' in e for e in errors)

    def test_invalid_archetype_fails(self):
        lesson = {'category': 'indicator', 'confidence': 0.7,
                  'archetypes': ['INVALID_ARCH'], 'lesson': 'test'}
        is_valid, errors = la._validate_lesson(lesson, 0)
        assert not is_valid
        assert any('archetype' in e for e in errors)

    def test_all_categories_valid(self):
        for cat in la.VALID_CATEGORIES:
            lesson = {'category': cat, 'confidence': 0.7,
                      'archetypes': ['ALL'], 'lesson': 'test lesson text'}
            is_valid, errors = la._validate_lesson(lesson, 0)
            assert is_valid, f"Category {cat} should be valid, got: {errors}"

    def test_invalid_sensitivity_fails(self):
        lesson = {
            'category': 'indicator', 'confidence': 0.7,
            'archetypes': ['ALL'], 'lesson': 'test',
            'parameter_data': {'sensitivity': 'EXTREME'}
        }
        is_valid, errors = la._validate_lesson(lesson, 0)
        assert not is_valid
        assert any('sensitivity' in e for e in errors)

    def test_valid_sensitivity_values(self):
        for sens in ['HIGH', 'MEDIUM', 'LOW']:
            lesson = {
                'category': 'indicator', 'confidence': 0.7,
                'archetypes': ['ALL'], 'lesson': 'test',
                'parameter_data': {'sensitivity': sens}
            }
            is_valid, _ = la._validate_lesson(lesson, 0)
            assert is_valid, f"Sensitivity {sens} should be valid"


# ── Response validation tests ──────────────────────────────────────────────────

class TestValidateResponse:
    def test_valid_response_passes(self, valid_claude_response):
        is_valid, lessons, errors = la._validate_response(
            valid_claude_response, 3)
        assert len(lessons) == 2

    def test_missing_lessons_array_fails(self):
        is_valid, lessons, errors = la._validate_response({'generation': 3}, 3)
        assert not is_valid
        assert lessons == []

    def test_too_few_lessons_flagged(self):
        data = {
            'generation': 3,
            'lessons': [
                {'category': 'indicator', 'confidence': 0.7,
                 'archetypes': ['ALL'], 'lesson': 'test'}
            ],
            'compaction_hints': {}
        }
        is_valid, lessons, errors = la._validate_response(data, 3)
        assert any('few' in e for e in errors)

    def test_too_many_lessons_truncated(self):
        base_lesson = {
            'category': 'indicator', 'confidence': 0.7,
            'archetypes': ['ALL'], 'lesson': 'test lesson text here'
        }
        data = {
            'generation': 3,
            'lessons': [base_lesson] * 15,
            'compaction_hints': {}
        }
        is_valid, lessons, errors = la._validate_response(data, 3)
        assert len(lessons) <= la.LESSONS_MAX

    def test_generation_mismatch_flagged(self, valid_claude_response):
        valid_claude_response['generation'] = 99
        is_valid, lessons, errors = la._validate_response(
            valid_claude_response, 3)
        assert any('mismatch' in e for e in errors)

    def test_invalid_lessons_excluded(self, valid_claude_response):
        valid_claude_response['lessons'].append(
            {'category': 'bad_category', 'confidence': 0.5,
             'archetypes': ['ALL'], 'lesson': 'test'}
        )
        is_valid, lessons, errors = la._validate_response(
            valid_claude_response, 3)
        assert len(lessons) == 2  # invalid one excluded


# ── Zero lessons fallback tests ────────────────────────────────────────────────

class TestZeroLessonsResult:
    def test_returns_valid_structure(self):
        result = la._zero_lessons_result(3, 'test reason')
        assert result['generation'] == 3
        assert result['lessons_extracted'] == 0
        assert result['lessons'] == []
        assert result['_extraction_failed'] is True
        assert 'test reason' in result['_failure_reason']

    def test_compaction_hints_empty(self):
        result = la._zero_lessons_result(3, 'reason')
        hints = result['compaction_hints']
        assert hints['confirmed_lesson_ids'] == []
        assert hints['contradicted_lesson_ids'] == []
        assert hints['merge_suggestions'] == []


# ── Full run_learner_agent integration tests ───────────────────────────────────

class TestRunLearnerAgent:
    @patch('requests.post')
    def test_successful_extraction(self, mock_post, minimal_brief,
                                    empty_active_lessons, valid_claude_response):
        mock_post.return_value = make_mock_response(valid_claude_response)
        result = la.run_learner_agent(
            3, minimal_brief, empty_active_lessons, FAKE_KEY)
        assert result['lessons_extracted'] == 2
        assert result['_extraction_failed'] is False
        assert len(result['lessons']) == 2

    @patch('requests.post')
    def test_retries_on_invalid_json(self, mock_post, minimal_brief,
                                      empty_active_lessons,
                                      valid_claude_response):
        bad_resp = MagicMock()
        bad_resp.status_code = 200
        bad_resp.json.return_value = {
            'content': [{'type': 'text', 'text': 'not json at all'}],
            'usage': {'input_tokens': 100, 'output_tokens': 50},
        }
        good_resp = make_mock_response(valid_claude_response)
        mock_post.side_effect = [bad_resp, good_resp]

        result = la.run_learner_agent(
            3, minimal_brief, empty_active_lessons, FAKE_KEY)
        assert result['lessons_extracted'] == 2
        assert mock_post.call_count == 2

    @patch('requests.post')
    def test_returns_zero_lessons_after_all_failures(
            self, mock_post, minimal_brief, empty_active_lessons):
        bad_resp = MagicMock()
        bad_resp.status_code = 200
        bad_resp.json.return_value = {
            'content': [{'type': 'text', 'text': 'not json'}],
            'usage': {'input_tokens': 100, 'output_tokens': 50},
        }
        mock_post.return_value = bad_resp

        result = la.run_learner_agent(
            3, minimal_brief, empty_active_lessons, FAKE_KEY)
        assert result['_extraction_failed'] is True
        assert result['lessons_extracted'] == 0
        assert result['lessons'] == []

    @patch('requests.post')
    def test_returns_zero_lessons_on_api_error(
            self, mock_post, minimal_brief, empty_active_lessons):
        mock_post.side_effect = Exception('Connection refused')

        result = la.run_learner_agent(
            3, minimal_brief, empty_active_lessons, FAKE_KEY)
        assert result['_extraction_failed'] is True
        assert result['lessons_extracted'] == 0

    @patch('requests.post')
    def test_never_raises(self, mock_post, minimal_brief, empty_active_lessons):
        mock_post.side_effect = RuntimeError('Unexpected error')
        try:
            result = la.run_learner_agent(
                3, minimal_brief, empty_active_lessons, FAKE_KEY)
            assert result['_extraction_failed'] is True
        except Exception:
            pytest.fail("run_learner_agent should never raise")

    @patch('requests.post')
    def test_compaction_hints_preserved(self, mock_post, minimal_brief,
                                         empty_active_lessons,
                                         valid_claude_response):
        mock_post.return_value = make_mock_response(valid_claude_response)
        result = la.run_learner_agent(
            3, minimal_brief, empty_active_lessons, FAKE_KEY)
        hints = result['compaction_hints']
        assert 'lesson-002' in hints['confirmed_lesson_ids']

    @patch('requests.post')
    def test_token_counts_recorded(self, mock_post, minimal_brief,
                                    empty_active_lessons, valid_claude_response):
        mock_post.return_value = make_mock_response(valid_claude_response)
        result = la.run_learner_agent(
            3, minimal_brief, empty_active_lessons, FAKE_KEY)
        assert result['_input_tokens'] == 1000
        assert result['_output_tokens'] == 500

    @patch('requests.post')
    def test_http_error_returns_zero_lessons(
            self, mock_post, minimal_brief, empty_active_lessons):
        err_resp = MagicMock()
        err_resp.status_code = 429
        err_resp.text = 'Rate limit exceeded'
        mock_post.return_value = err_resp

        result = la.run_learner_agent(
            3, minimal_brief, empty_active_lessons, FAKE_KEY)
        assert result['_extraction_failed'] is True
