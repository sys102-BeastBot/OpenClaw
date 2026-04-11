"""
learner_agent.py — Extract lessons from backtest results via Claude.

Makes one Claude API call per generation. Receives a pre-digested brief
from learner_prep.py, assembles the Learner prompt, calls Claude Sonnet,
parses and validates the JSON response, and returns structured lesson data
ready for kb_writer.py to store.

Error recovery:
  Attempt 1: Normal Learner call
  Attempt 2: Retry with stricter prompt if parse fails
  Fallback:  Return zero lessons — clean known state, no corruption

Never writes to KB directly — returns data for caller to store.

Schema reference: Section 9 (lessons/raw/gen-NNN-lessons.json)
"""

import json
import time
import re
from typing import Optional
from pathlib import Path

from monitor_agent import log_event, log_api_call

# ── Constants ──────────────────────────────────────────────────────────────────

VALID_CATEGORIES = {
    'hard_rule', 'indicator', 'structure',
    'asset', 'risk', 'anti_pattern'
}

VALID_ARCHETYPES = {
    'SHARPE_HUNTER', 'RETURN_CHASER',
    'RISK_MINIMIZER', 'CONSISTENCY', 'ALL'
}

VALID_SENSITIVITY = {'HIGH', 'MEDIUM', 'LOW'}

CLAUDE_MODEL    = 'claude-sonnet-4-5'
MAX_TOKENS      = 10000
MAX_RETRIES     = 1          # one retry then fail clean
LESSONS_MIN     = 5
LESSONS_MAX     = 12

# ── Learner prompt template ────────────────────────────────────────────────────

_LEARNER_PROMPT = """\
You are the learning engine for an autonomous trading strategy evolution \
system. Your job is to extract high-quality lessons from this generation's \
backtest results that will improve the next generation's strategy designs.

Generation {generation} ran {total_strategies} strategies across \
{archetypes_run} archetypes. Your lessons will be injected into the \
Generator prompt for generation {next_generation}. Write lessons that \
are specific, actionable, and grounded in the data — not general \
trading wisdom.

<generation_brief>
{generation_brief}
</generation_brief>

<existing_lessons>
These are the current active lessons in the KB. Reference them when \
writing new lessons — update confidence reasoning, note contradictions, \
avoid duplicates.

{existing_lessons}
</existing_lessons>

<extraction_instructions>
Extract lessons in this priority order:

PRIORITY 1 — Parameter lessons (most valuable)
For every parameter the optimizer searched:
  - Did the Generator prior hold up or get corrected?
  - What was the winning value and its sensitivity?
  - Did different archetypes show different optimal values?
  - Was there a cliff — fitness dropping sharply above/below optimal?
Write one lesson per parameter with sufficient evidence.
Only write parameter lessons where the optimizer ran (score >= 40).

PRIORITY 2 — Structural lessons
Compare winners vs losers structurally:
  - What node types appeared in top performers but not losers?
  - Did three-layer structures outperform two-layer?
  - Did any archetype show a distinctive structural pattern?
  - Did rebalance frequency correlate with performance?
Write structural lessons only when the pattern appears in \
2+ strategies — single-strategy observations are noise.

PRIORITY 3 — Anti-pattern lessons
For disqualified strategies and poor performers:
  - What structural decision caused failure?
  - Is this a new failure mode or confirmation of an existing graveyard entry?
  - Write as a specific NEVER DO instruction.

PRIORITY 4 — Compaction hints
Review existing lessons against this generation's results:
  - List lesson IDs that were confirmed this generation
  - List lesson IDs that were contradicted
  - List pairs of lessons that say the same thing

QUALITY RULES:
  - Write {lessons_min}-{lessons_max} lessons per generation. More is not better.
  - Each lesson must reference specific strategy IDs or data points.
  - Never invent performance claims — only reference data in the brief.
  - Lessons must be 2-4 sentences. Specific beats general.
  - Confidence: 0.50 first observation. +0.10 per confirming strategy.
  - Set apply_to_active: true only when confidence >= 0.65.

WHAT NOT TO WRITE:
  - General trading wisdom not grounded in this generation's data
  - Lessons that duplicate existing active lessons
  - Lessons with no supporting_evidence from actual strategy IDs
  - Performance claims you cannot verify from the brief
</extraction_instructions>

<output_format>
Output a single JSON object. No preamble. No explanation.
No markdown fences. Start with {{ and end with }}.

{{
  "generation": {generation},
  "lessons_extracted": count,
  "lessons": [
    {{
      "category": "hard_rule|indicator|structure|asset|risk|anti_pattern",
      "subcategory": "free text e.g. drawdown_guard",
      "confidence": 0.0-1.0,
      "decay": true|false,
      "archetypes": ["ALL"] or ["SHARPE_HUNTER", "RETURN_CHASER", ...],
      "lesson": "2-4 sentence lesson. Specific and actionable.",
      "parameter_data": null or {{
        "function": "exact lhs-fn name",
        "asset": "ticker or null",
        "optimal_window": integer or null,
        "optimal_threshold": "string or null",
        "threshold_range": "e.g. 9-11 or null",
        "sensitivity": "HIGH|MEDIUM|LOW or null",
        "archetype_overrides": {{}}
      }},
      "regime_context": null or {{
        "regime": "regime enum or null",
        "regime_note": "string"
      }},
      "supporting_evidence": ["gen-003-strat-01", "data point"],
      "merge_candidate_ids": [],
      "apply_to_active": true|false
    }}
  ],
  "compaction_hints": {{
    "confirmed_lesson_ids": [],
    "contradicted_lesson_ids": [],
    "merge_suggestions": [
      {{
        "lesson_a": "lesson-id",
        "lesson_b": "lesson-id",
        "reason": "both describe RSI threshold on QQQ"
      }}
    ],
    "retire_suggestions": []
  }}
}}

EXAMPLE OF A GOOD LESSON:
{{
  "category": "indicator",
  "subcategory": "drawdown_guard",
  "confidence": 0.80,
  "decay": true,
  "archetypes": ["ALL"],
  "lesson": "max-drawdown on SVXY with window=2 outperformed window=5 \
in all 4 tested strategies this generation. Optimizer confirmed \
threshold=10 as optimal for SHARPE_HUNTER (fitness +5.2 vs nominal). \
RETURN_CHASER benefited from threshold=13 — lower sensitivity to \
short-term dips allowed longer momentum rides.",
  "parameter_data": {{
    "function": "max-drawdown",
    "asset": "SVXY",
    "optimal_window": 2,
    "optimal_threshold": "10",
    "threshold_range": "9-11",
    "sensitivity": "HIGH",
    "archetype_overrides": {{
      "RETURN_CHASER": {{
        "optimal_threshold": "13",
        "threshold_range": "12-14"
      }}
    }}
  }},
  "supporting_evidence": [
    "gen-003-strat-01", "gen-003-strat-02", "gen-003-strat-04"
  ],
  "merge_candidate_ids": ["lesson-002"],
  "apply_to_active": true
}}

EXAMPLE OF A BAD LESSON — never write this:
{{
  "category": "structure",
  "lesson": "Momentum strategies tend to work well in bull markets.",
  "confidence": 0.7
}}
This is generic trading wisdom with no connection to this \
generation's data.

CRITICAL OUTPUT RULES:
  - lessons array must be valid JSON — no trailing commas
  - confidence must be a float between 0.0 and 1.0
  - category must be exactly one of the six valid values
  - archetypes must be an array — use ["ALL"] for universal lessons
  - supporting_evidence must reference actual strategy IDs from brief
  - Never fabricate strategy IDs or performance numbers
  - apply_to_active: true when confidence >= 0.65, false otherwise
</output_format>
"""

_RETRY_PROMPT = """\
Your previous response was not valid JSON. Output only the JSON object \
— nothing else. No explanation, no preamble, no markdown fences.
Start your response with {{ and end with }}.

{original_prompt}
"""


# ── Prompt assembly ────────────────────────────────────────────────────────────

def _format_existing_lessons(active_lessons: dict) -> str:
    """Format active lessons for injection into the prompt.

    Produces a compact, readable representation of each active lesson.
    Strips fields the Learner doesn't need (timestamps, source, etc.)
    to keep token count low.

    Args:
        active_lessons: Full active.json contents.

    Returns:
        Formatted string of lessons.
    """
    lessons = active_lessons.get('lessons', [])
    if not lessons:
        return "No active lessons yet — this is an early generation."

    lines = []
    for lesson in lessons:
        lid   = lesson.get('id', 'unknown')
        cat   = lesson.get('category', '').upper()
        conf  = lesson.get('confidence', 0)
        archs = ', '.join(lesson.get('archetypes', ['ALL']))
        text  = lesson.get('lesson', '')
        lines.append(f"[{lid} | {cat} | conf:{conf:.2f} | {archs}]")
        lines.append(text)
        lines.append("")

    return "\n".join(lines)


def build_learner_prompt(brief: dict,
                          active_lessons: dict,
                          generation: int) -> str:
    """Assemble the complete Learner prompt.

    Args:
        brief: Pre-digested generation brief from learner_prep.py.
        active_lessons: Full active.json contents.
        generation: Current generation number.

    Returns:
        Complete prompt string ready for Claude API.
    """
    archetypes_run = len(brief.get('archetype_summary', {}))
    existing       = _format_existing_lessons(active_lessons)

    return _LEARNER_PROMPT.format(
        generation=generation,
        next_generation=generation + 1,
        total_strategies=brief.get('total_strategies', 0),
        archetypes_run=archetypes_run,
        generation_brief=json.dumps(brief, indent=2),
        existing_lessons=existing,
        lessons_min=LESSONS_MIN,
        lessons_max=LESSONS_MAX,
    )


# ── Claude API call ────────────────────────────────────────────────────────────

def _call_claude(prompt: str,
                 generation: int,
                 attempt: int,
                 anthropic_key: str) -> tuple[Optional[str], dict]:
    """Make one Claude API call for lesson extraction.

    Args:
        prompt: Complete prompt string.
        generation: Generation number (for logging).
        attempt: Attempt number 1 or 2 (for logging).
        anthropic_key: Anthropic API key.

    Returns:
        Tuple of (response_text or None, call_metadata dict).
    """
    import requests

    url     = 'https://api.anthropic.com/v1/messages'
    headers = {
        'x-api-key':         anthropic_key,
        'anthropic-version': '2023-06-01',
        'content-type':      'application/json',
    }
    payload = {
        'model':      CLAUDE_MODEL,
        'max_tokens': MAX_TOKENS,
        'messages':   [{'role': 'user', 'content': prompt}],
    }

    start_ms = int(time.time() * 1000)
    meta     = {
        'call_type':     'LEARNER',
        'strategy_id':   None,
        'generation':    generation,
        'input_tokens':  0,
        'output_tokens': 0,
        'duration_ms':   0,
        'success':       False,
        'error':         None,
    }

    try:
        resp = requests.post(url, headers=headers,
                              json=payload, timeout=120)
        meta['duration_ms'] = int(time.time() * 1000) - start_ms

        if resp.status_code != 200:
            meta['error'] = f"HTTP {resp.status_code}: {resp.text[:200]}"
            log_api_call(**meta)
            return None, meta

        data = resp.json()
        usage = data.get('usage', {})
        meta['input_tokens']  = usage.get('input_tokens', 0)
        meta['output_tokens'] = usage.get('output_tokens', 0)
        meta['success']       = True

        text = ''.join(
            block.get('text', '')
            for block in data.get('content', [])
            if block.get('type') == 'text'
        )
        log_api_call(**meta)
        return text, meta

    except Exception as e:
        meta['duration_ms'] = int(time.time() * 1000) - start_ms
        meta['error']       = str(e)
        log_api_call(**meta)
        return None, meta


# ── Response parsing and validation ───────────────────────────────────────────

def _extract_json(text: str) -> Optional[dict]:
    """Extract and parse JSON from Claude response text.

    Handles cases where Claude wraps the JSON in markdown fences
    or adds preamble text despite being instructed not to.

    Args:
        text: Raw Claude response text.

    Returns:
        Parsed dict or None if extraction fails.
    """
    if not text:
        return None

    # Strip markdown fences if present
    text = re.sub(r'```(?:json)?\s*', '', text).strip()

    # Try direct parse first
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        pass

    # Try to find JSON object in the text
    start = text.find('{')
    end   = text.rfind('}')
    if start != -1 and end != -1 and end > start:
        try:
            return json.loads(text[start:end + 1])
        except json.JSONDecodeError:
            pass

    return None


def _validate_lesson(lesson: dict, idx: int) -> tuple[bool, list[str]]:
    """Validate a single lesson object against the schema.

    Args:
        lesson: Lesson dict from Claude response.
        idx: Index in the lessons array (for error messages).

    Returns:
        Tuple of (is_valid: bool, errors: list[str]).
    """
    errors = []

    # Required fields
    if 'lesson' not in lesson or not lesson['lesson']:
        errors.append(f"lesson[{idx}]: missing or empty 'lesson' text")

    # Category validation
    cat = lesson.get('category', '')
    if cat not in VALID_CATEGORIES:
        errors.append(
            f"lesson[{idx}]: invalid category '{cat}'. "
            f"Must be one of: {sorted(VALID_CATEGORIES)}"
        )

    # Confidence validation
    conf = lesson.get('confidence')
    if conf is None:
        errors.append(f"lesson[{idx}]: missing confidence")
    elif not isinstance(conf, (int, float)) or not (0.0 <= conf <= 1.0):
        errors.append(
            f"lesson[{idx}]: confidence must be float 0.0-1.0, got {conf!r}"
        )

    # Archetypes validation
    archs = lesson.get('archetypes', [])
    if not isinstance(archs, list) or not archs:
        errors.append(f"lesson[{idx}]: archetypes must be a non-empty list")
    else:
        for arch in archs:
            if arch not in VALID_ARCHETYPES:
                errors.append(
                    f"lesson[{idx}]: invalid archetype '{arch}'"
                )

    # supporting_evidence must be a list
    evidence = lesson.get('supporting_evidence', [])
    if not isinstance(evidence, list):
        errors.append(
            f"lesson[{idx}]: supporting_evidence must be a list"
        )

    # parameter_data validation (if present)
    pd = lesson.get('parameter_data')
    if pd is not None:
        if not isinstance(pd, dict):
            errors.append(f"lesson[{idx}]: parameter_data must be dict or null")
        else:
            sens = pd.get('sensitivity')
            if sens is not None and sens not in VALID_SENSITIVITY:
                errors.append(
                    f"lesson[{idx}]: parameter_data.sensitivity must be "
                    f"HIGH|MEDIUM|LOW or null, got {sens!r}"
                )

    return len(errors) == 0, errors


def _validate_response(data: dict,
                        generation: int) -> tuple[bool, list[dict], list[str]]:
    """Validate the full Claude response structure.

    Args:
        data: Parsed JSON dict from Claude.
        generation: Expected generation number.

    Returns:
        Tuple of (is_valid, valid_lessons, all_errors).
    """
    all_errors  = []
    valid_lessons = []

    # Top-level structure
    if not isinstance(data, dict):
        return False, [], ['Response is not a JSON object']

    if 'lessons' not in data:
        return False, [], ['Response missing lessons array']

    lessons = data['lessons']
    if not isinstance(lessons, list):
        return False, [], ['lessons must be an array']

    # Generation check
    resp_gen = data.get('generation')
    if resp_gen is not None and resp_gen != generation:
        all_errors.append(
            f"generation mismatch: expected {generation}, got {resp_gen}"
        )

    # Lesson count check
    count = len(lessons)
    if count < LESSONS_MIN:
        all_errors.append(
            f"too few lessons: {count} (minimum {LESSONS_MIN})"
        )
    if count > LESSONS_MAX:
        all_errors.append(
            f"too many lessons: {count} (maximum {LESSONS_MAX}) — "
            f"truncating to {LESSONS_MAX}"
        )
        lessons = lessons[:LESSONS_MAX]

    # Validate each lesson
    for i, lesson in enumerate(lessons):
        is_valid, errors = _validate_lesson(lesson, i)
        if is_valid:
            valid_lessons.append(lesson)
        else:
            all_errors.extend(errors)
            log_event(
                'WARNING', 'learner_agent',
                f"gen-{generation} lesson[{i}] failed validation: "
                f"{'; '.join(errors)}"
            )

    # compaction_hints (optional but validated if present)
    hints = data.get('compaction_hints', {})
    if hints and not isinstance(hints, dict):
        all_errors.append('compaction_hints must be a dict if present')

    return len(all_errors) == 0, valid_lessons, all_errors


# ── Zero-lessons fallback ──────────────────────────────────────────────────────

def _zero_lessons_result(generation: int, reason: str) -> dict:
    """Return a valid empty result when lesson extraction fails.

    Args:
        generation: Generation number.
        reason: Why extraction failed (for logging).

    Returns:
        Valid raw lessons dict with zero lessons.
    """
    log_event(
        'WARNING', 'learner_agent',
        f"gen-{generation}: returning zero lessons. Reason: {reason}"
    )
    return {
        'generation':         generation,
        'lessons_extracted':  0,
        'lessons':            [],
        'compaction_hints': {
            'confirmed_lesson_ids':    [],
            'contradicted_lesson_ids': [],
            'merge_suggestions':       [],
            'retire_suggestions':      [],
        },
        '_extraction_failed': True,
        '_failure_reason':    reason,
    }


# ── Main entry point ───────────────────────────────────────────────────────────

def run_learner_agent(generation: int,
                       brief: dict,
                       active_lessons: dict,
                       anthropic_key: str) -> dict:
    """Run the Learner Agent for one generation.

    Assembles the prompt, calls Claude, parses and validates the response.
    On failure retries once with a stricter prompt, then returns zero lessons.

    Args:
        generation: Current generation number.
        brief: Pre-digested generation brief from learner_prep.build_learner_brief().
        active_lessons: Full active.json contents (for context and contradiction detection).
        anthropic_key: Anthropic API key string.

    Returns:
        Dict matching lessons/raw/gen-NNN-lessons.json schema.
        On failure returns zero-lesson result — never raises.
    """
    log_event(
        'INFO', 'learner_agent',
        f"gen-{generation}: starting lesson extraction, "
        f"{brief.get('total_strategies', 0)} strategies in brief"
    )

    # Build initial prompt
    prompt = build_learner_prompt(brief, active_lessons, generation)

    for attempt in range(1, MAX_RETRIES + 2):   # attempts 1 and 2

        if attempt == 2:
            # Retry with stricter prompt
            log_event(
                'INFO', 'learner_agent',
                f"gen-{generation}: retrying with stricter prompt (attempt 2)"
            )
            prompt = _RETRY_PROMPT.format(original_prompt=prompt)

        text, call_meta = _call_claude(
            prompt, generation, attempt, anthropic_key
        )

        if text is None:
            log_event(
                'WARNING', 'learner_agent',
                f"gen-{generation} attempt {attempt}: API call failed — "
                f"{call_meta.get('error', 'unknown error')}"
            )
            continue

        # Parse JSON
        data = _extract_json(text)
        if data is None:
            log_event(
                'WARNING', 'learner_agent',
                f"gen-{generation} attempt {attempt}: "
                f"could not extract JSON from response"
            )
            continue

        # Validate
        is_valid, valid_lessons, errors = _validate_response(data, generation)

        if errors:
            log_event(
                'WARNING', 'learner_agent',
                f"gen-{generation} attempt {attempt}: "
                f"validation issues: {'; '.join(errors)}"
            )

        if valid_lessons:
            # Success — build final result
            hints = data.get('compaction_hints', {})
            result = {
                'generation':         generation,
                'lessons_extracted':  len(valid_lessons),
                'lessons':            valid_lessons,
                'compaction_hints': {
                    'confirmed_lesson_ids':
                        hints.get('confirmed_lesson_ids', []),
                    'contradicted_lesson_ids':
                        hints.get('contradicted_lesson_ids', []),
                    'merge_suggestions':
                        hints.get('merge_suggestions', []),
                    'retire_suggestions':
                        hints.get('retire_suggestions', []),
                },
                '_extraction_failed': False,
                '_failure_reason':    None,
                '_attempts':          attempt,
                '_input_tokens':      call_meta.get('input_tokens', 0),
                '_output_tokens':     call_meta.get('output_tokens', 0),
            }

            log_event(
                'INFO', 'learner_agent',
                f"gen-{generation}: extracted {len(valid_lessons)} lessons "
                f"on attempt {attempt}"
            )
            return result

    # All attempts exhausted — fail clean
    return _zero_lessons_result(
        generation,
        f"failed after {MAX_RETRIES + 1} attempts"
    )
