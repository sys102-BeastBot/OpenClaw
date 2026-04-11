"""
generator_agent.py — Generate a single Composer strategy via Claude.

Makes one Claude API call per strategy slot. Assembles the prompt via
context_builder.py, calls Claude Sonnet, extracts and validates the
strategy JSON, runs the logic auditor, and writes the result to pending/.

One call per strategy — independent, retryable, clean logs per slot.

Error handling:
  - Invalid JSON from Claude → quarantine, write to pending/ with
    QUARANTINED status, continue to next slot
  - Logic audit failure → quarantine, write to pending/ with
    QUARANTINED status, continue to next slot
  - API error → log, return None for this slot

Never retries on bad JSON — the optimizer cannot fix a structurally
invalid strategy. Better to discard and move to the next slot.

Schema reference: Section 2 (results file), Section 12 (Composer JSON rules)
"""

import copy
import json
import re
import time
import uuid
from datetime import datetime, timezone
from pathlib import Path
from typing import Optional

from context_builder import build_generator_prompt, VALID_ARCHETYPES
from logic_auditor import audit_strategy, ASSET_UNIVERSE
from kb_writer import write_strategy_file, read_json
from monitor_agent import log_event, log_api_call

# ── Paths ──────────────────────────────────────────────────────────────────────
_KB_ROOT  = Path.home() / '.openclaw' / 'workspace' / 'learning' / 'kb'
_META_PATH = _KB_ROOT / 'meta.json'

# ── Constants ──────────────────────────────────────────────────────────────────
CLAUDE_MODEL = 'claude-sonnet-4-5'
MAX_TOKENS   = 8000      # generous budget — never truncate strategy JSON
TEMPERATURE  = 1.0       # default — creative but controlled


# ── Claude API call ────────────────────────────────────────────────────────────

def _call_claude(prompt: str,
                 generation: int,
                 slot_number: int,
                 archetype: str,
                 anthropic_key: str) -> tuple[Optional[str], dict]:
    """Make one Claude API call for strategy generation.

    Args:
        prompt: Complete assembled Generator prompt.
        generation: Generation number (for logging).
        slot_number: Slot within generation (for logging).
        archetype: Archetype being generated (for logging).
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
        'model':       CLAUDE_MODEL,
        'max_tokens':  MAX_TOKENS,
        'temperature': TEMPERATURE,
        'messages':    [{'role': 'user', 'content': prompt}],
    }

    strategy_id = f"gen-{generation:03d}-strat-{slot_number:02d}"
    start_ms    = int(time.time() * 1000)
    meta        = {
        'call_type':     'GENERATOR',
        'strategy_id':   strategy_id,
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

        data  = resp.json()
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


# ── DSL extraction and compilation ────────────────────────────────────────────

def _extract_strategy_dsl(text: str) -> Optional[str]:
    """Extract DSL string from Claude response.
    Claude should output starting with 'defsymphony'.
    Strip any markdown fences if present.
    Returns the DSL string or None if not found.
    """
    # Strip markdown fences
    text = re.sub(r'```(?:clojure|dsl|lisp)?\s*', '', text).strip()
    text = re.sub(r'```\s*$', '', text).strip()

    # Find defsymphony
    idx = text.find('defsymphony')
    if idx == -1:
        return None
    return text[idx:].strip()


def _compile_dsl_to_json(dsl_str: str) -> Optional[dict]:
    """Compile DSL string to Composer JSON.
    Returns compiled dict or None if compilation fails.
    """
    try:
        from dsl_compiler import compile_dsl
        return compile_dsl(dsl_str)
    except Exception as e:
        return None


# ── Strategy file builder ──────────────────────────────────────────────────────

def _now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def _build_strategy_file(strategy_json: dict,
                          archetype: str,
                          generation: int,
                          slot_number: int,
                          parent_ids: list[str]) -> dict:
    """Build the full results file dict for a generated strategy.

    Populates identity, strategy, lineage, and pipeline sections.
    All other sections (nominal_result, optimizer_data, etc.) start null.

    Args:
        strategy_json: Parsed strategy dict from Claude (has name, description,
                       rebalance_frequency, children).
        archetype: Archetype enum value.
        generation: Generation number.
        slot_number: Slot within generation.
        parent_ids: List of parent strategy IDs from lineage.

    Returns:
        Complete results file dict at PENDING status.
    """
    strategy_id = f"gen-{generation:03d}-strat-{slot_number:02d}"
    name        = strategy_json.get('name', f'Strategy {strategy_id}')
    rebalance   = strategy_json.get('rebalance_frequency',
                  strategy_json.get('rebalance', 'daily'))
    _desc       = strategy_json.get('description', {})
    description = _desc if isinstance(_desc, dict) else {}
    children    = strategy_json.get('children', [])
    now         = _now_iso()

    # Determine composer rebalance value format
    if rebalance == 'daily':
        composer_rebalance = {
            'asset-class':        'EQUITIES',
            'rebalance-frequency': 'daily',
        }
    elif rebalance == '5%':
        composer_rebalance = {
            'asset-class':        'EQUITIES',
            'rebalance-threshold': 0.05,
        }
    elif rebalance == '10%':
        composer_rebalance = {
            'asset-class':        'EQUITIES',
            'rebalance-threshold': 0.10,
        }
    else:
        # Default to daily for unknown values
        composer_rebalance = {
            'asset-class':        'EQUITIES',
            'rebalance-frequency': 'daily',
        }
        rebalance = 'daily'

    return {
        'summary': {
            'strategy_id':            strategy_id,
            'name':                   name,
            'archetype':              archetype,
            'generation':             generation,
            'final_composite_fitness': None,
            'final_sharpe_1Y':         None,
            'final_return_1Y':         None,
            'final_max_drawdown_1Y':   None,
            'final_std_dev':           None,
            'optimization_delta':      None,
            'passed_rough_cut':        None,
            'disqualified':            False,
            'status':                  'PENDING',
            'rebalance_frequency':     rebalance,
        },
        'identity': {
            'strategy_id':          strategy_id,
            'name':                 name,
            'generation':           generation,
            'archetype':            archetype,
            'slot_number':          slot_number,
            'created_at':           now,
            'rebalance_frequency':  rebalance,
            'composer_rebalance_value': composer_rebalance,
            'composer_symphony_id': None,
        },
        'strategy': {
            'description': description,
            'composer_json': {
                'step':               'wt-cash-equal',   # will be replaced by children
                'rebalanceFrequency': composer_rebalance,
                'children':           children,
            }
        },
        'lineage': {
            'parent_ids':          parent_ids,
            'parent_patterns':     [],
            'generation_type':     'NOVEL' if not parent_ids else 'MUTATION',
            'mutation_description': None,
            'is_seed':             False,
            'seed_source':         None,
        },
        'nominal_result':   None,
        'optimizer_data':   None,
        'final_result':     None,
        'logic_audit': {
            'status':       'PENDING',
            'completed_at': None,
            'checks': {
                'crash_guard_present':     None,
                'bil_in_defensive_branch': None,
                'weights_sum_to_100':      None,
                'no_leverage_in_defense':  None,
                'if_structure_valid':      None,
                'all_assets_in_universe':  None,
                'valid_node_types_only':   None,
                'window_days_string_format': None,
                'has_else_condition':      None,
            },
            'failures':    [],
            'warnings':    [],
            'quarantined': False,
        },
        'pipeline': {
            'current_status': 'PENDING',
            'status_history': [
                {'status': 'PENDING', 'timestamp': now}
            ],
            'error_log':              [],
            'retry_count':            0,
            'disqualified':           False,
            'disqualification_reason': None,
            'disqualified_at':        None,
            'archived':               False,
            'archived_at':            None,
            'archive_path':           None,
        },
        'learner_metadata': {
            'processed':              False,
            'processed_at':           None,
            'lessons_extracted':      0,
            'lesson_ids':             [],
            'patterns_contributed':   [],
            'contributed_to_graveyard': False,
            'graveyard_entry_id':     None,
            'contributed_to_lineage': True,
            'notes':                  None,
        },
    }


# ── Main entry point ───────────────────────────────────────────────────────────

def run_generator_agent(archetype: str,
                         generation: int,
                         slot_number: int,
                         parent_ids: list[str],
                         anthropic_key: str,
                         asset_universe: Optional[list] = None) -> Optional[dict]:
    """Run the Generator Agent for one strategy slot.

    Assembles the prompt, calls Claude, validates the output,
    runs the logic auditor, and writes to pending/.

    Args:
        archetype: One of the four archetype enum values.
        generation: Current generation number.
        slot_number: Which slot within the generation (1-indexed).
        parent_ids: List of parent strategy IDs for lineage tracking.
        anthropic_key: Anthropic API key.
        asset_universe: Optional asset universe override. Defaults to
                        logic_auditor.ASSET_UNIVERSE if not provided.

    Returns:
        The strategy dict written to pending/, or None if generation failed.
        A quarantined strategy IS returned (caller decides what to do with it).
    """
    if archetype not in VALID_ARCHETYPES:
        raise ValueError(f"Invalid archetype: {archetype!r}")

    strategy_id = f"gen-{generation:03d}-strat-{slot_number:02d}"
    universe    = frozenset(asset_universe) if asset_universe else ASSET_UNIVERSE

    log_event(
        'INFO', 'generator_agent',
        f"{strategy_id}: starting generation for {archetype}"
    )

    # ── Step 1: Build prompt ───────────────────────────────────────────────────
    try:
        prompt = build_generator_prompt(archetype, generation, slot_number)
    except Exception as e:
        log_event(
            'WARNING', 'generator_agent',
            f"{strategy_id}: prompt build failed — {e}"
        )
        return None

    # ── Step 2: Call Claude ────────────────────────────────────────────────────
    text, call_meta = _call_claude(
        prompt, generation, slot_number, archetype, anthropic_key
    )

    if text is None:
        log_event(
            'WARNING', 'generator_agent',
            f"{strategy_id}: API call failed — {call_meta.get('error')}"
        )
        return None

    # ── Step 3: Extract DSL and compile to JSON ────────────────────────────────
    dsl_str = _extract_strategy_dsl(text)
    if dsl_str is None:
        log_event('ERROR', 'generator',
                  f"{strategy_id}: could not extract DSL from response (no 'defsymphony' found)")
        strategy_file = _build_strategy_file({}, archetype, generation,
                                              slot_number, parent_ids)
        strategy_file['pipeline']['status'] = 'QUARANTINED'
        strategy_file['pipeline']['disqualification_reason'] = 'NO_DSL_OUTPUT'
        strategy_file['raw_claude_output'] = text
        write_strategy_file(strategy_file, stage='pending')
        return strategy_file

    strategy_json = _compile_dsl_to_json(dsl_str)
    if strategy_json is None:
        log_event('ERROR', 'generator',
                  f"{strategy_id}: DSL compilation failed")
        strategy_file = _build_strategy_file({}, archetype, generation,
                                              slot_number, parent_ids)
        strategy_file['pipeline']['status'] = 'QUARANTINED'
        strategy_file['pipeline']['disqualification_reason'] = 'DSL_COMPILE_FAILED'
        strategy_file['raw_claude_output'] = text
        strategy_file['raw_dsl'] = dsl_str
        write_strategy_file(strategy_file, stage='pending')
        return strategy_file

    # ── Step 4: Build strategy file ────────────────────────────────────────────
    strategy_file = _build_strategy_file(
        strategy_json, archetype, generation, slot_number, parent_ids
    )

    # Store raw DSL for KB reference
    if dsl_str:
        strategy_file['raw_dsl'] = dsl_str

    # ── Step 5: Run logic auditor ──────────────────────────────────────────────
    audit_result = audit_strategy(strategy_file, list(universe))
    audit_dict   = audit_result.to_dict()

    strategy_file['logic_audit'] = audit_dict

    if audit_result.quarantined:
        # Quarantine — mark but still write to pending/ so Learner can
        # extract anti-pattern lessons from the failure
        strategy_file['summary']['status']           = 'DISQUALIFIED'
        strategy_file['summary']['disqualified']     = True
        strategy_file['pipeline']['current_status']  = 'DISQUALIFIED'
        strategy_file['pipeline']['disqualified']    = True
        strategy_file['pipeline']['disqualification_reason'] = 'AUDIT_FAILURE: ' + ', '.join(audit_result.failures)
        strategy_file['pipeline']['disqualified_at'] = _now_iso()
        strategy_file['pipeline']['status_history'].append({
            'status':    'DISQUALIFIED',
            'timestamp': _now_iso(),
        })

        log_event(
            'WARNING', 'generator_agent',
            f"{strategy_id}: quarantined — audit failures: "
            f"{audit_result.failures}"
        )
    else:
        log_event(
            'INFO', 'generator_agent',
            f"{strategy_id}: audit passed"
            + (f" ({len(audit_result.warnings)} warnings)"
               if audit_result.warnings else "")
        )

    # ── Step 6: Write to pending/ ──────────────────────────────────────────────
    try:
        write_strategy_file(strategy_file, stage='pending')
        log_event(
            'INFO', 'generator_agent',
            f"{strategy_id}: written to pending/"
        )
    except Exception as e:
        log_event(
            'WARNING', 'generator_agent',
            f"{strategy_id}: failed to write to pending/ — {e}"
        )
        return None

    return strategy_file


# ── Batch generation for a full generation ────────────────────────────────────

def run_generation(generation: int,
                    anthropic_key: str,
                    meta: Optional[dict] = None) -> list[dict]:
    """Generate all strategy slots for one complete generation.

    Reads archetype allocation from meta.json, generates each slot
    sequentially, returns list of written strategy files.

    Args:
        generation: Current generation number.
        anthropic_key: Anthropic API key.
        meta: Optional meta.json contents. Loaded from disk if not provided.

    Returns:
        List of strategy dicts written to pending/.
        Failed slots are excluded (None returns from run_generator_agent).
    """
    if meta is None:
        meta = read_json(str(_META_PATH))

    allocation = meta['archetype_allocation']['current']
    results    = []
    slot       = 1

    for archetype, count in allocation.items():
        for _ in range(count):
            log_event(
                'INFO', 'generator_agent',
                f"gen-{generation:03d}: generating slot {slot} "
                f"({archetype})"
            )

            strategy = run_generator_agent(
                archetype=archetype,
                generation=generation,
                slot_number=slot,
                parent_ids=[],        # lineage_tracker fills this separately
                anthropic_key=anthropic_key,
            )

            if strategy is not None:
                results.append(strategy)
            else:
                log_event(
                    'WARNING', 'generator_agent',
                    f"gen-{generation:03d}: slot {slot} ({archetype}) "
                    f"failed — skipping"
                )

            slot += 1

    log_event(
        'INFO', 'generator_agent',
        f"gen-{generation:03d}: generation complete — "
        f"{len(results)} of {slot - 1} slots succeeded"
    )

    return results
