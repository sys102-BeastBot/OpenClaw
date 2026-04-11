"""
research_phase.py — One-time Research Phase orchestrator.

Runs R1-R5 sequentially to seed the Knowledge Base before
generation 0 of the autonomous learning loop. Each task saves
state so it can be resumed if interrupted.

Usage:
    # Run all tasks:
    python3 src/research_phase.py --tasks R1,R2,R3,R4,R5

    # Run a single task:
    python3 src/research_phase.py --task R1

    # Resume from last checkpoint:
    python3 src/research_phase.py --tasks R2,R3,R4,R5

    # Dry run (no API calls, uses mock data):
    python3 src/research_phase.py --tasks R1,R2,R3 --dry-run

Dependencies:
    R1 → independent
    R2 → independent (reuses R1 backtest data if available)
    R3 → requires R1 and R2 complete
    R4 → requires R3 complete (KB seeded)
    R5 → requires R4 complete (seeds backtested)

Cost estimate: ~$4.65 core + ~$16 prompt engineering sprint = ~$25
"""

import argparse
import json
import os
import re
import sys
import time
import uuid
from datetime import datetime, date, timedelta, timezone
from pathlib import Path
from typing import Optional

# ── Path setup ─────────────────────────────────────────────────────────────────
_LEARNING_ROOT = Path.home() / '.openclaw' / 'workspace' / 'learning'
_SRC_DIR       = _LEARNING_ROOT / 'src'
sys.path.insert(0, str(_SRC_DIR))

from kb_writer       import read_json, write_json_atomic, initialize_kb_structure
from credentials     import CredentialManager
from monitor_agent   import log_event, send_telegram_alert
from lineage_tracker import tree_to_string
from scorer          import score_period, compute_composite, check_disqualifiers
from graveyard       import file_disqualified
from learner_agent   import run_learner_agent
from learner_prep    import build_brief

from r1_prompt import build_r1_prompt, R1_SYSTEM_PROMPT
from r2_prompt import build_r2_prompt, R2_SYSTEM_PROMPT
from r3_prompt import build_r3_prompt, R3_SYSTEM_PROMPT
from r4_prompt import (
    SEED_CONFIG, SEED_ARCHETYPE_ORDER,
    build_seed_prompt, make_seed_identity,
)
from r5_prompt import (
    R5_CONFIG, build_r5_brief_prefix,
    build_r5_active_lessons_note,
)

# ── Paths ──────────────────────────────────────────────────────────────────────
_KB_ROOT        = _LEARNING_ROOT / 'kb'
_META_PATH      = _KB_ROOT / 'meta.json'
_ACTIVE_PATH    = _KB_ROOT / 'lessons' / 'active.json'
_PATTERNS_PATH  = _KB_ROOT / 'patterns.json'
_LINEAGE_PATH   = _KB_ROOT / 'lineage.json'
_RESEARCH_DIR   = _KB_ROOT / 'research'
_STATE_PATH     = _RESEARCH_DIR / 'state.json'
_PROXY_BASE     = 'http://localhost:8080/composer'

# ── Constants ──────────────────────────────────────────────────────────────────
CLAUDE_MODEL       = 'claude-sonnet-4-5'
MAX_TOKENS_R1      = 8000
MAX_TOKENS_R2      = 8000
MAX_TOKENS_R3      = 6000
MAX_TOKENS_R5      = 10000
COMMUNITY_MIN_SHARPE = 1.5
COMMUNITY_MAX_COUNT  = 150
BACKTEST_PERIODS_FULL = ['6M', '1Y', '2Y', '3Y']
BACKTEST_PERIODS_SEED = ['1Y', '2Y']
STUCK_ALERT_SECONDS  = 300   # 5 minutes

# Known symphony IDs
KNOWN_SYMPHONIES = {
    'beta_baller':   'vNP5oYsbpV8tS9USqGEL',
    'extended_oos':  'n9J6L8weCzu2vAUrMWnm',
    'sisyphus':      'qjRIwrAOA1YzFSghM08b',
    's90':           'QgwrvzhG0qZWnd6o88vb',
}

COPY_SOURCE_ID = 'qjRIwrAOA1YzFSghM08b'   # Sisyphus — copy source


# ── State management ───────────────────────────────────────────────────────────

def _load_state() -> dict:
    """Load research phase state. Returns empty dict if not found."""
    _RESEARCH_DIR.mkdir(parents=True, exist_ok=True)
    try:
        return read_json(str(_STATE_PATH))
    except Exception:
        return {}


def _save_state(task: str, output: dict) -> None:
    """Save task output to state file. Idempotent."""
    state = _load_state()
    state[task] = {
        'completed_at': _now_iso(),
        'output':       output,
    }
    write_json_atomic(str(_STATE_PATH), state)
    log_event('INFO', 'research_phase',
              f'{task}: state saved to {_STATE_PATH}')


def _save_checkpoint(task: str, partial: list, count: int) -> None:
    """Save partial progress checkpoint for resumable tasks."""
    state = _load_state()
    state[f'{task}_checkpoint'] = {
        'saved_at':   _now_iso(),
        'count':      count,
        'partial':    partial,
    }
    write_json_atomic(str(_STATE_PATH), state)


def _load_checkpoint(task: str) -> Optional[list]:
    """Load partial checkpoint. Returns None if not found."""
    state = _load_state()
    cp = state.get(f'{task}_checkpoint')
    if cp:
        log_event('INFO', 'research_phase',
                  f'{task}: resuming from checkpoint ({cp["count"]} done)')
        return cp['partial']
    return None


def is_complete(task: str) -> bool:
    """Check if a task has already completed successfully."""
    state = _load_state()
    return task in state and 'output' in state[task]


def get_task_output(task: str) -> Optional[dict]:
    """Get output from a completed task."""
    state = _load_state()
    entry = state.get(task)
    if entry:
        return entry.get('output')
    return None


# ── Utilities ──────────────────────────────────────────────────────────────────

def _now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def _now_label() -> str:
    return datetime.now(timezone.utc).strftime('%H:%M:%SZ')


def _elapsed_str(start: float) -> str:
    s = int(time.time() - start)
    return f"{s//60}m {s%60}s" if s >= 60 else f"{s}s"


def _get_period_dates(period: str) -> tuple[str, str]:
    """Return (start_date, end_date) ISO strings for a period."""
    end   = date.today()
    days  = {'6M': 183, '1Y': 365, '2Y': 730, '3Y': 1095}
    start = end - timedelta(days=days[period])
    return start.isoformat(), end.isoformat()


def _progress_alert(task: str, done: int, total: int) -> None:
    """Send Telegram milestone alert at 25/50/75/100%."""
    pct = int(done / total * 100)
    for milestone in [25, 50, 75, 100]:
        if pct >= milestone and (done - 1) / total * 100 < milestone:
            send_telegram_alert(
                'INFO',
                f"🔬 {task}: {milestone}% complete ({done}/{total})"
            )
            break


# ── Composer API helpers ───────────────────────────────────────────────────────

def _get_headers() -> dict:
    """Get Composer API auth headers."""
    creds = CredentialManager()
    return creds.get_composer_headers()


def _call_claude(
    system: str,
    prompt: str,
    max_tokens: int,
    anthropic_key: str,
    task_label: str,
) -> Optional[str]:
    """Make one Claude API call. Returns response text or None."""
    import requests

    url     = 'https://api.anthropic.com/v1/messages'
    headers = {
        'x-api-key':         anthropic_key,
        'anthropic-version': '2023-06-01',
        'content-type':      'application/json',
    }
    payload = {
        'model':      CLAUDE_MODEL,
        'max_tokens': max_tokens,
        'system':     system,
        'messages':   [{'role': 'user', 'content': prompt}],
    }

    log_event('INFO', 'research_phase',
              f'{task_label}: calling Claude ({max_tokens} max tokens)...')
    t0 = time.time()

    try:
        resp = requests.post(url, headers=headers,
                             json=payload, timeout=180)
        elapsed = time.time() - t0

        if resp.status_code != 200:
            log_event('WARNING', 'research_phase',
                      f'{task_label}: Claude API error {resp.status_code}: '
                      f'{resp.text[:200]}')
            return None

        data  = resp.json()
        usage = data.get('usage', {})
        text  = ''.join(
            b.get('text', '')
            for b in data.get('content', [])
            if b.get('type') == 'text'
        )
        log_event('INFO', 'research_phase',
                  f'{task_label}: Claude response received '
                  f'({elapsed:.1f}s, '
                  f'{usage.get("input_tokens", 0)} in / '
                  f'{usage.get("output_tokens", 0)} out)')
        return text

    except Exception as e:
        log_event('WARNING', 'research_phase',
                  f'{task_label}: Claude API exception: {e}')
        return None


def _parse_claude_json(text: str, task_label: str) -> Optional[dict]:
    """Extract and parse JSON from Claude response."""
    if not text:
        return None
    # Strip markdown fences
    text = re.sub(r'```(?:json)?\s*', '', text).strip()
    # Try direct parse
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        pass
    # Try to find JSON object
    start = text.find('{')
    end   = text.rfind('}')
    if start != -1 and end > start:
        try:
            return json.loads(text[start:end + 1])
        except json.JSONDecodeError:
            pass
    log_event('WARNING', 'research_phase',
              f'{task_label}: could not parse JSON from Claude response')
    return None


def _fetch_symphony_score(sym_id: str, headers: dict) -> Optional[dict]:
    """Fetch symphony score/definition from Composer API."""
    import requests
    try:
        resp = requests.get(
            f'{_PROXY_BASE}/api/v0.1/symphonies/{sym_id}/score',
            headers=headers, timeout=15
        )
        if resp.status_code == 200:
            return resp.json()
        log_event('WARNING', 'research_phase',
                  f'fetch_symphony_score {sym_id}: HTTP {resp.status_code}')
        return None
    except Exception as e:
        log_event('WARNING', 'research_phase',
                  f'fetch_symphony_score {sym_id}: {e}')
        return None


def _backtest_symphony(
    sym_id: str,
    period: str,
    headers: dict,
    meta: dict,
) -> Optional[dict]:
    """Run one backtest period for a symphony by ID."""
    import requests

    start, end = _get_period_dates(period)
    config = meta.get('config', {})
    payload = {
        'capital':           config.get('capital', 10000),
        'apply_reg_fee':     False,
        'apply_taf_fee':     False,
        'slippage_percent':  0.001,
        'broker':            config.get('broker', 'ALPACA_WHITE_LABEL'),
        'start_date':        start,
        'end_date':          end,
        'benchmark_tickers': [config.get('benchmark', 'SPY')],
    }

    try:
        resp = requests.post(
            f'{_PROXY_BASE}/api/v0.1/symphonies/{sym_id}/backtest',
            headers=headers, json=payload, timeout=60
        )
        if resp.status_code == 200:
            return resp.json()
        if resp.status_code == 503:
            time.sleep(3)
            resp = requests.post(
                f'{_PROXY_BASE}/api/v0.1/symphonies/{sym_id}/backtest',
                headers=headers, json=payload, timeout=60
            )
            if resp.status_code == 200:
                return resp.json()
        log_event('WARNING', 'research_phase',
                  f'backtest {sym_id} {period}: HTTP {resp.status_code}')
        return None
    except Exception as e:
        log_event('WARNING', 'research_phase',
                  f'backtest {sym_id} {period}: {e}')
        return None


def _parse_period_stats(raw: dict, period: str) -> dict:
    """Parse Composer API backtest response into period stats block."""
    stats  = raw.get('stats', raw)
    bm_raw = stats.get('benchmarks', {}).get('SPY', {})
    bm_pct = bm_raw.get('percent', {})

    return {
        'period': period,
        'core_metrics': {
            'annualized_return': stats.get('annualized_rate_of_return', 0) * 100,
            'total_return':      stats.get('cumulative_return', 0) * 100,
            'sharpe':            stats.get('sharpe_ratio', 0),
            'max_drawdown':      stats.get('max_drawdown', 0) * 100,
            'volatility':        stats.get('standard_deviation', 0) * 100,
            'win_rate':          stats.get('win_rate', 0) * 100,
            'sortino_ratio':     stats.get('sortino_ratio'),
            'calmar_ratio':      stats.get('calmar_ratio'),
        },
        'benchmark_metrics': {
            'benchmark_ticker':            'SPY',
            'benchmark_annualized_return': bm_raw.get('annualized_rate_of_return', 0) * 100,
            'beats_benchmark':             (
                stats.get('annualized_rate_of_return', 0) >
                bm_raw.get('annualized_rate_of_return', 0)
            ),
            'alpha':       bm_pct.get('alpha'),
            'beta':        bm_pct.get('beta'),
            'r_squared':   bm_pct.get('r_square'),
            'correlation': bm_pct.get('pearson_r'),
        },
        'fitness': None,
        'raw_api_fields': {
            'annualized_rate_of_return': stats.get('annualized_rate_of_return'),
            'cumulative_return':         stats.get('cumulative_return'),
            'sharpe_ratio':              stats.get('sharpe_ratio'),
            'max_drawdown':              stats.get('max_drawdown'),
            'standard_deviation':        stats.get('standard_deviation'),
        },
    }


def _backtest_symphony_all_periods(
    sym_id: str,
    periods: list[str],
    headers: dict,
    meta: dict,
    sym_name: str = '',
) -> dict:
    """Backtest a symphony across multiple periods. Returns {period: stats}."""
    results = {}
    for period in periods:
        raw = _backtest_symphony(sym_id, period, headers, meta)
        if raw:
            results[period] = _parse_period_stats(raw, period)
            core = results[period]['core_metrics']
            log_event('INFO', 'research_phase',
                      f'{sym_name or sym_id} {period}: '
                      f"return={core['annualized_return']:.1f}% "
                      f"sharpe={core['sharpe']:.2f} "
                      f"maxDD={core['max_drawdown']:.1f}%")
        else:
            log_event('WARNING', 'research_phase',
                      f'{sym_name or sym_id} {period}: backtest failed')
        time.sleep(0.5)   # brief pause between periods
    return results


def _create_temp_symphony(
    composer_json: dict,
    name: str,
    headers: dict,
) -> Optional[str]:
    """Create temp symphony via copy+PUT. Returns symphony ID."""
    import requests

    # Step 1: Copy
    copy_resp = requests.post(
        f'{_PROXY_BASE}/api/v0.1/symphonies/{COPY_SOURCE_ID}/copy',
        headers=headers,
        json={'name': f'tmp-{name[:40]}'},
        timeout=15,
    )
    if copy_resp.status_code not in (200, 201):
        log_event('WARNING', 'research_phase',
                  f'create_temp_symphony: copy failed {copy_resp.status_code}')
        return None

    sym_id = copy_resp.json().get('symphony_id')
    if not sym_id:
        return None

    # Step 2: PUT our strategy
    def add_ids(node):
        import copy as _copy
        n = _copy.deepcopy(node)
        if 'id' not in n:
            n['id'] = str(uuid.uuid4())
        n['children'] = [add_ids(c) for c in n.get('children', [])]
        return n

    children = [add_ids(c) for c in composer_json.get('children', [])]
    put_payload = {
        'name':        name[:100],
        'description': '',
        'step':        'root',
        'rebalance':   'daily',
        'asset_class': 'EQUITIES',
        'children':    children,
    }

    put_resp = requests.put(
        f'{_PROXY_BASE}/api/v0.1/symphonies/{sym_id}',
        headers={**headers, 'Content-Type': 'application/json'},
        json=put_payload,
        timeout=30,
    )
    if put_resp.status_code not in (200, 201):
        requests.delete(
            f'{_PROXY_BASE}/api/v0.1/symphonies/{sym_id}',
            headers=headers, timeout=10
        )
        return None

    return sym_id


def _delete_symphony(sym_id: str, headers: dict) -> None:
    """Delete a symphony. Errors are suppressed."""
    import requests
    try:
        requests.delete(
            f'{_PROXY_BASE}/api/v0.1/symphonies/{sym_id}',
            headers=headers, timeout=10
        )
    except Exception:
        pass


def _backtest_strategy_all_periods(
    composer_json: dict,
    name: str,
    periods: list[str],
    headers: dict,
    meta: dict,
) -> dict:
    """Backtest a strategy JSON across periods via temp symphony."""
    sym_id = _create_temp_symphony(composer_json, name, headers)
    if not sym_id:
        log_event('WARNING', 'research_phase',
                  f'backtest_strategy: failed to create temp symphony for {name}')
        return {}

    try:
        return _backtest_symphony_all_periods(
            sym_id, periods, headers, meta, name
        )
    finally:
        _delete_symphony(sym_id, headers)


def _fetch_all_portfolio_symphonies(headers: dict) -> list[dict]:
    """
    Fetch all symphonies from all three accounts via symphony-stats-meta.
    Deduplicates by symphony ID across accounts.
    """
    import requests

    ACCOUNT_UUIDS = [
        '0fe12b8e-12a3-4f09-9ec5-49731bf12093',  # ROTH IRA
        '67345c1c-0a30-4d18-b441-b365264f7cf4',  # Traditional IRA
        '6b7cf335-9963-456c-821f-a02332481f3b',  # Individual
    ]

    seen_ids       = set()
    all_symphonies = []

    for uuid in ACCOUNT_UUIDS:
        try:
            resp = requests.get(
                f'{_PROXY_BASE}/api/v0.1/portfolio/accounts/{uuid}/symphony-stats-meta',
                headers=headers, timeout=15
            )
            if resp.status_code != 200:
                log_event('WARNING', 'research_phase',
                          f'fetch_portfolio {uuid[:8]}: HTTP {resp.status_code}')
                continue
            syms = resp.json().get('symphonies', [])
            for sym in syms:
                sym_id = sym.get('id', '')
                if sym_id and sym_id not in seen_ids:
                    seen_ids.add(sym_id)
                    all_symphonies.append(sym)
        except Exception as e:
            log_event('WARNING', 'research_phase',
                      f'fetch_portfolio {uuid[:8]}: {e}')

    log_event('INFO', 'research_phase',
              f'fetch_portfolio: {len(all_symphonies)} unique symphonies across all accounts')
    return all_symphonies

def _fetch_community_symphonies(
    headers: dict,
    min_sharpe: float = COMMUNITY_MIN_SHARPE,
    max_count: int = COMMUNITY_MAX_COUNT,
) -> list[dict]:
    """
    Fetch top public community symphonies by Sharpe ratio.
    Returns compact summary dicts (no full JSON).
    """
    import requests

    log_event('INFO', 'research_phase',
              f'Fetching community symphonies (Sharpe > {min_sharpe})...')

    try:
        resp = requests.get(
            f'{_PROXY_BASE}/api/v0.1/symphonies?public=true',
            headers=headers, timeout=30
        )
        if resp.status_code != 200:
            log_event('WARNING', 'research_phase',
                      f'fetch_community: HTTP {resp.status_code}')
            return []

        all_syms = resp.json()
        if not isinstance(all_syms, list):
            return []

        log_event('INFO', 'research_phase',
                  f'fetch_community: {len(all_syms)} total public symphonies')

        # Filter and sort by Sharpe
        filtered = []
        for sym in all_syms:
            sharpe = sym.get('sharpe_ratio') or sym.get('sharpe') or 0
            if sharpe >= min_sharpe:
                filtered.append({
                    'id':                 sym.get('id', ''),
                    'name':               sym.get('name', ''),
                    'sharpe':             sharpe,
                    'annualized_return':  sym.get('annualized_rate_of_return', 0) * 100,
                    'max_drawdown':       sym.get('max_drawdown', 0) * 100,
                    'r_squared':          sym.get('r_squared'),
                    'pearson_r':          sym.get('pearson_r'),
                    'tree_structure':     '',
                    'tickers':            [],
                })

        # Sort by Sharpe desc, cap at max_count
        filtered.sort(key=lambda x: x['sharpe'], reverse=True)
        filtered = filtered[:max_count]

        log_event('INFO', 'research_phase',
                  f'fetch_community: {len(filtered)} symphonies pass filter')
        return filtered

    except Exception as e:
        log_event('WARNING', 'research_phase',
                  f'fetch_community: {e}')
        return []


def _enrich_community_symphony(
    sym: dict,
    headers: dict,
) -> dict:
    """Fetch score for a community symphony and add tree_structure + tickers."""
    score_data = _fetch_symphony_score(sym['id'], headers)
    if score_data:
        sym['tree_structure'] = tree_to_string(score_data)
        # Extract unique tickers
        def get_tickers(node):
            tickers = []
            if isinstance(node, dict):
                if node.get('step') == 'asset' and node.get('ticker'):
                    tickers.append(node['ticker'])
                for child in node.get('children', []):
                    tickers.extend(get_tickers(child))
            return tickers
        sym['tickers'] = list(set(get_tickers(score_data)))
    return sym


# ── R1 — Library Mining ────────────────────────────────────────────────────────

def _filter_backtested_for_r1(
    portfolio_symphonies: list[dict],
    min_sharpe_top: float = 1.0,
    max_sharpe_failure: float = -1.0,
) -> list[dict]:
    """
    Filter portfolio symphonies AFTER standardized backtesting.
    Uses 1Y standardized Sharpe — apple-to-apple comparison.
    INCLUDE: Standardized 1Y Sharpe > 1.0  — top performers
    INCLUDE: Standardized 1Y Sharpe < -1.0 — notable failures
    EXCLUDE: Everything in between — mediocre, low signal
    """
    top_performers   = []
    notable_failures = []

    for sym in portfolio_symphonies:
        periods   = sym.get('periods', {})
        sharpe_1y = periods.get('1Y', {}).get('sharpe')

        if sharpe_1y is None:
            log_event('WARNING', 'research_phase',
                      f'filter_backtested: no 1Y data for '
                      f'{sym.get("name", "?")} — skipping')
            continue

        if sharpe_1y > min_sharpe_top:
            top_performers.append(sym)
        elif sharpe_1y < max_sharpe_failure:
            notable_failures.append(sym)
        else:
            log_event('INFO', 'research_phase',
                      f'filter_backtested: skipping mediocre '
                      f'{sym.get("name", "?")[:40]} '
                      f'(1Y sharpe={sharpe_1y:.2f})')

    top_performers.sort(
        key=lambda x: x['periods'].get('1Y', {}).get('sharpe', 0),
        reverse=True
    )
    notable_failures.sort(
        key=lambda x: x['periods'].get('1Y', {}).get('sharpe', 0)
    )

    selected = top_performers + notable_failures
    log_event('INFO', 'research_phase',
              f'filter_backtested: {len(selected)} selected '
              f'({len(top_performers)} top, {len(notable_failures)} failures) '
              f'from {len(portfolio_symphonies)} backtested')
    return selected



def run_r1(meta: dict, anthropic_key: str, dry_run: bool = False) -> dict:
    """
    R1: Library Mining — fetch and analyze portfolio + community symphonies.

    Step 1: Fetch portfolio symphonies (full JSON + 4-period backtest)
    Step 2: Fetch community symphonies (structure summaries, Sharpe > 1.5)
    Step 3: Send to Claude for pattern extraction

    Returns R1 output dict.
    """
    if is_complete('R1'):
        log_event('INFO', 'research_phase', 'R1: already complete — skipping')
        return get_task_output('R1')

    log_event('INFO', 'research_phase', 'R1: starting library mining')
    send_telegram_alert('INFO', '🔬 R1 Library Mining started')
    t0 = time.time()

    headers = _get_headers()

    # ── Step 1: Portfolio symphonies ───────────────────────────────────────────
    log_event('INFO', 'research_phase', 'R1 Step 1: fetching portfolio symphonies')
    portfolio_raw = _fetch_all_portfolio_symphonies(headers)

    if not portfolio_raw and not dry_run:
        # Fall back to known symphony IDs
        log_event('WARNING', 'research_phase',
                  'R1: portfolio fetch failed — using known IDs')
        portfolio_raw = [
            {'id': v, 'name': k}
            for k, v in KNOWN_SYMPHONIES.items()
        ]

    portfolio_symphonies = []
    last_progress = time.time()

    for i, sym in enumerate(portfolio_raw):
        # Stuck detection
        if time.time() - last_progress > STUCK_ALERT_SECONDS:
            send_telegram_alert('WARNING',
                f'⚠️ R1 Step 1: no progress for 5 min '
                f'({i}/{len(portfolio_raw)} portfolios). Still running.')
            last_progress = time.time()

        sym_id   = sym.get('id', '')
        sym_name = sym.get('name', sym_id)

        log_event('INFO', 'research_phase',
                  f'R1 portfolio {i+1}/{len(portfolio_raw)}: {sym_name}')

        # Fetch full definition
        score_data = _fetch_symphony_score(sym_id, headers)
        if not score_data:
            continue

        # Full 4-period backtest
        if dry_run:
            periods_data = {p: _mock_period_stats(p) for p in BACKTEST_PERIODS_FULL}
        else:
            periods_data = _backtest_symphony_all_periods(
                sym_id, BACKTEST_PERIODS_FULL, headers, meta, sym_name
            )

        portfolio_symphonies.append({
            'id':             sym_id,
            'name':           sym_name,
            'tree_structure': tree_to_string(score_data),
            'composer_json':  score_data,
            'periods':        {
                p: {
                    'annualized_return': d['core_metrics']['annualized_return'],
                    'sharpe':            d['core_metrics']['sharpe'],
                    'max_drawdown':      d['core_metrics']['max_drawdown'],
                    'r_squared':         d['benchmark_metrics']['r_squared'],
                    'pearson_r':         d['benchmark_metrics']['correlation'],
                }
                for p, d in periods_data.items()
            },
        })
        last_progress = time.time()
        _progress_alert('R1 portfolio', i + 1, len(portfolio_raw))

    # Filter AFTER backtest — now on apple-to-apple standardized basis
    if not dry_run:
        portfolio_symphonies = _filter_backtested_for_r1(portfolio_symphonies)

    log_event('INFO', 'research_phase',
              f'R1: {len(portfolio_symphonies)} portfolio symphonies '
              f'selected for Claude analysis')

    # ── Step 2: Community symphonies ───────────────────────────────────────────
    log_event('INFO', 'research_phase', 'R1 Step 2: fetching community symphonies')

    if dry_run:
        community_symphonies = _mock_community_symphonies()
    else:
        community_raw = _fetch_community_symphonies(headers)
        community_symphonies = []
        last_progress = time.time()

        for i, sym in enumerate(community_raw):
            if time.time() - last_progress > STUCK_ALERT_SECONDS:
                send_telegram_alert('WARNING',
                    f'⚠️ R1 Step 2: no progress for 5 min '
                    f'({i}/{len(community_raw)} community). Still running.')
                last_progress = time.time()

            enriched = _enrich_community_symphony(sym, headers)
            community_symphonies.append(enriched)
            last_progress = time.time()
            _progress_alert('R1 community', i + 1, len(community_raw))
            time.sleep(0.2)   # rate limit

    log_event('INFO', 'research_phase',
              f'R1: {len(community_symphonies)} community symphonies ready')

    # ── Step 3: Claude extraction ──────────────────────────────────────────────
    log_event('INFO', 'research_phase', 'R1 Step 3: sending to Claude')

    if dry_run:
        r1_output = _mock_r1_output()
    else:
        prompt = build_r1_prompt(portfolio_symphonies, community_symphonies)
        text   = _call_claude(
            R1_SYSTEM_PROMPT, prompt, MAX_TOKENS_R1, anthropic_key, 'R1'
        )
        r1_output = _parse_claude_json(text, 'R1')

        if not r1_output:
            log_event('WARNING', 'research_phase',
                      'R1: Claude parsing failed — saving raw text')
            r1_output = {'_raw': text, '_parse_failed': True}

    # Attach portfolio backtest data for R2 reuse
    r1_output['_portfolio_symphonies'] = portfolio_symphonies

    _save_state('R1', r1_output)
    elapsed = _elapsed_str(t0)
    send_telegram_alert('INFO',
        f'✅ R1 Library Mining complete ({elapsed})\n'
        f'Patterns found: {len(r1_output.get("winning_patterns", []))}\n'
        f'Anti-patterns: {len(r1_output.get("losing_patterns", []))}\n'
        f'Parameter priors: {len(r1_output.get("parameter_priors", []))}'
    )
    log_event('INFO', 'research_phase', f'R1: complete in {elapsed}')
    return r1_output


# ── R2 — Symphony Autopsy ──────────────────────────────────────────────────────

def run_r2(meta: dict, anthropic_key: str, dry_run: bool = False) -> dict:
    """
    R2: Symphony Autopsy — deep analysis of 4 specific symphonies.
    Reuses R1 portfolio backtest data — no new Composer API calls.
    """
    if is_complete('R2'):
        log_event('INFO', 'research_phase', 'R2: already complete — skipping')
        return get_task_output('R2')

    log_event('INFO', 'research_phase', 'R2: starting symphony autopsy')
    send_telegram_alert('INFO', '🔬 R2 Symphony Autopsy started')
    t0 = time.time()

    headers = _get_headers()

    # Load R1 portfolio data if available
    r1_output = get_task_output('R1')
    r1_portfolio = r1_output.get('_portfolio_symphonies', []) if r1_output else []

    # Build lookup by name
    portfolio_lookup = {
        s['name'].lower().replace(' ', ''): s
        for s in r1_portfolio
    }

    def get_or_fetch_symphony(key: str, sym_id: str) -> dict:
        """Get symphony from R1 data or fetch fresh."""
        # Try to find in R1 portfolio data
        for s in r1_portfolio:
            if s['id'] == sym_id:
                return s
        # Fetch fresh
        score_data = _fetch_symphony_score(sym_id, headers)
        if not score_data:
            return {'id': sym_id, 'name': key,
                    'tree_structure': '', 'composer_json': {}, 'periods': {}}

        if dry_run:
            periods_data = {p: _mock_period_data() for p in BACKTEST_PERIODS_FULL}
        else:
            periods_data = _backtest_symphony_all_periods(
                sym_id, BACKTEST_PERIODS_FULL, headers, meta, key
            )

        return {
            'id':             sym_id,
            'name':           score_data.get('name', key),
            'tree_structure': tree_to_string(score_data),
            'composer_json':  score_data,
            'periods': {
                p: {
                    'annualized_return': d['core_metrics']['annualized_return'],
                    'sharpe':            d['core_metrics']['sharpe'],
                    'max_drawdown':      d['core_metrics']['max_drawdown'],
                    'r_squared':         d['benchmark_metrics']['r_squared'],
                    'pearson_r':         d['benchmark_metrics']['correlation'],
                }
                for p, d in periods_data.items()
            },
        }

    log_event('INFO', 'research_phase', 'R2: loading 4 symphonies')
    beta_baller  = get_or_fetch_symphony('beta_baller',  KNOWN_SYMPHONIES['beta_baller'])
    extended_oos = get_or_fetch_symphony('extended_oos', KNOWN_SYMPHONIES['extended_oos'])
    sisyphus     = get_or_fetch_symphony('sisyphus',     KNOWN_SYMPHONIES['sisyphus'])
    s90          = get_or_fetch_symphony('s90',          KNOWN_SYMPHONIES['s90'])

    log_event('INFO', 'research_phase', 'R2: sending to Claude')

    if dry_run:
        r2_output = _mock_r2_output()
    else:
        prompt = build_r2_prompt(beta_baller, extended_oos, sisyphus, s90)
        text   = _call_claude(
            R2_SYSTEM_PROMPT, prompt, MAX_TOKENS_R2, anthropic_key, 'R2'
        )
        r2_output = _parse_claude_json(text, 'R2')

        if not r2_output:
            r2_output = {'_raw': text, '_parse_failed': True}

    _save_state('R2', r2_output)
    elapsed = _elapsed_str(t0)
    params = len(r2_output.get('beta_baller_parameters', []))
    lessons = len(r2_output.get('cross_symphony_lessons', []))
    send_telegram_alert('INFO',
        f'✅ R2 Symphony Autopsy complete ({elapsed})\n'
        f'Beta Baller parameters extracted: {params}\n'
        f'Cross-symphony lessons: {lessons}'
    )
    log_event('INFO', 'research_phase', f'R2: complete in {elapsed}')
    return r2_output


# ── R3 — Knowledge Synthesis ───────────────────────────────────────────────────

def run_r3(meta: dict, anthropic_key: str, dry_run: bool = False) -> dict:
    """
    R3: Knowledge Synthesis — combine R1 and R2 into 20 ranked lessons.
    Requires R1 and R2 complete.
    Writes results directly to active.json and patterns.json.
    """
    if is_complete('R3'):
        log_event('INFO', 'research_phase', 'R3: already complete — skipping')
        return get_task_output('R3')

    # Dependency check
    if not is_complete('R1'):
        raise RuntimeError(
            'R3 requires R1 to be complete first. '
            'Run: python3 src/research_phase.py --task R1'
        )
    if not is_complete('R2'):
        log_event('INFO', 'research_phase',
                  'R3: R2 not complete — running with R1 output only')

    log_event('INFO', 'research_phase', 'R3: starting knowledge synthesis')
    send_telegram_alert('INFO', '🔬 R3 Knowledge Synthesis started')
    t0 = time.time()

    r1_output = get_task_output('R1')
    r2_output = get_task_output('R2')

    # Strip internal fields before sending to Claude
    r1_clean = {k: v for k, v in r1_output.items() if not k.startswith('_')}
    r2_clean = {k: v for k, v in r2_output.items() if not k.startswith('_')}

    if dry_run:
        r3_output = _mock_r3_output()
    else:
        prompt = build_r3_prompt(r1_clean, r2_clean)
        text   = _call_claude(
            R3_SYSTEM_PROMPT, prompt, MAX_TOKENS_R3, anthropic_key, 'R3'
        )
        r3_output = _parse_claude_json(text, 'R3')

        if not r3_output:
            r3_output = {'_raw': text, '_parse_failed': True}

    # Write lessons to active.json
    lessons = r3_output.get('lessons', [])
    if lessons:
        _write_r3_lessons_to_kb(lessons, meta)
        log_event('INFO', 'research_phase',
                  f'R3: {len(lessons)} lessons written to active.json')

    # Write patterns to patterns.json
    winning = r1_output.get('winning_patterns', [])
    losing  = r1_output.get('losing_patterns', [])
    if winning or losing:
        _write_patterns_to_kb(winning, losing)
        log_event('INFO', 'research_phase',
                  f'R3: {len(winning)} winning + {len(losing)} losing '
                  f'patterns written to patterns.json')

    _save_state('R3', r3_output)
    elapsed = _elapsed_str(t0)
    conflicts = r3_output.get('synthesis_summary', {}).get('conflicts_flagged', 0)
    send_telegram_alert('INFO',
        f'✅ R3 Knowledge Synthesis complete ({elapsed})\n'
        f'Lessons written: {len(lessons)}\n'
        f'Conflicts flagged: {conflicts}'
    )
    log_event('INFO', 'research_phase', f'R3: complete in {elapsed}')
    return r3_output


def _write_r3_lessons_to_kb(lessons: list[dict], meta: dict) -> None:
    """Write R3 synthesized lessons to active.json."""
    try:
        active = read_json(str(_ACTIVE_PATH))
    except Exception:
        active = {
            'version':       '1.0',
            'total_lessons': 0,
            'lessons':       [],
            'token_config': {'flexible_pool_tokens': 7300},
        }

    existing_lessons = active.get('lessons', [])
    # Assign IDs continuing from existing
    next_id = len(existing_lessons) + 1

    for lesson in lessons:
        lesson_obj = {
            'id':                f'lesson-{next_id:03d}',
            'category':          lesson.get('category', 'structure'),
            'subcategory':       lesson.get('subcategory', ''),
            'confidence':        lesson.get('confidence', 0.65),
            'decay':             lesson.get('decay', True),
            'archetypes':        lesson.get('archetypes', ['ALL']),
            'lesson':            lesson.get('lesson', ''),
            'parameter_data':    lesson.get('parameter_data'),
            'regime_context':    lesson.get('regime_context'),
            'supporting_evidence': lesson.get('supporting_evidence', []),
            'merge_candidate_ids': [],
            'apply_to_next':     True,
            'times_reinforced':  0,
            'times_contradicted':0,
            'created_at':        _now_iso(),
            'last_seen_generation': 0,
            'source':            lesson.get('source', 'R3'),
            'conflict_flag':     lesson.get('conflict_flag', False),
            'conflict_notes':    lesson.get('conflict_notes'),
        }
        existing_lessons.append(lesson_obj)
        next_id += 1

    active['lessons']       = existing_lessons
    active['total_lessons'] = len(existing_lessons)
    write_json_atomic(str(_ACTIVE_PATH), active)


def _write_patterns_to_kb(
    winning: list[dict],
    losing:  list[dict],
) -> None:
    """Write winning and losing patterns to patterns.json."""
    try:
        patterns = read_json(str(_PATTERNS_PATH))
    except Exception:
        patterns = {
            'version':          '1.0',
            'last_updated':     _now_iso(),
            'winning_patterns': [],
            'losing_patterns':  [],
        }

    patterns['winning_patterns'] = winning
    patterns['losing_patterns']  = losing
    patterns['last_updated']     = _now_iso()
    write_json_atomic(str(_PATTERNS_PATH), patterns)


# ── R4 — Seed Generation ───────────────────────────────────────────────────────

def run_r4(meta: dict, anthropic_key: str, dry_run: bool = False) -> dict:
    """
    R4: Seed Generation — generate 24 diverse seed strategies.
    Uses the KB seeded by R3. No optimizer. 2-period backtest only.
    Includes progress reporting and stuck detection.
    """
    if is_complete('R4'):
        log_event('INFO', 'research_phase', 'R4: already complete — skipping')
        return get_task_output('R4')

    if not is_complete('R3'):
        raise RuntimeError(
            'R4 requires R3 to be complete first. '
            'Run: python3 src/research_phase.py --task R3'
        )

    log_event('INFO', 'research_phase', 'R4: starting seed generation')
    total_seeds = SEED_CONFIG['total_seeds']
    send_telegram_alert('INFO',
        f'🌱 R4 Seed Generation started\n'
        f'{total_seeds} seeds × 2 periods — no optimizer\n'
        f'Estimated time: ~15 minutes'
    )
    t0 = time.time()

    headers     = _get_headers()
    seeds_done  = _load_checkpoint('R4') or []
    start_from  = len(seeds_done)
    last_progress = time.time()

    if start_from > 0:
        log_event('INFO', 'research_phase',
                  f'R4: resuming from seed {start_from + 1}')

    seed_number = start_from + 1
    failed      = 0

    for archetype in SEED_ARCHETYPE_ORDER:
        arch_seeds = [
            s for s in seeds_done
            if s.get('summary', {}).get('archetype') == archetype
        ]
        arch_done = len(arch_seeds)
        arch_total = SEED_CONFIG['count_per_archetype']
        previous_structures = [
            s.get('strategy', {}).get('description', {})
             .get('summary', '')
            for s in arch_seeds
        ]

        for arch_slot in range(arch_done + 1, arch_total + 1):
            if seed_number > total_seeds:
                break

            # Stuck detection
            if time.time() - last_progress > STUCK_ALERT_SECONDS:
                send_telegram_alert('WARNING',
                    f'⚠️ R4: no progress for 5 min '
                    f'(seed {seed_number}/{total_seeds}). Still running.')
                last_progress = time.time()

            log_event('INFO', 'research_phase',
                      f'R4: generating seed {seed_number}/{total_seeds} '
                      f'({archetype} {arch_slot}/{arch_total})')

            if dry_run:
                strategy = _mock_seed_strategy(archetype, seed_number)
            else:
                # Build diversity-aware prompt
                prompt = build_seed_prompt(
                    archetype=archetype,
                    seed_number=seed_number,
                    total_seeds=total_seeds,
                    generation=0,
                    previous_structures=previous_structures,
                )

                # Use generator_agent for the actual generation
                from generator_agent import (
                    _call_claude as _gen_call_claude,
                    _extract_strategy_json,
                    _build_strategy_file,
                )
                from logic_auditor import audit_strategy, ASSET_UNIVERSE

                text, call_meta = _gen_call_claude(
                    prompt=prompt,
                    generation=0,
                    slot_number=seed_number,
                    archetype=archetype,
                    anthropic_key=anthropic_key,
                )

                if not text:
                    log_event('WARNING', 'research_phase',
                              f'R4 seed {seed_number}: Generator API call failed')
                    failed += 1
                    seed_number += 1
                    continue

                strategy_json = _extract_strategy_json(text)
                if not strategy_json:
                    log_event('WARNING', 'research_phase',
                              f'R4 seed {seed_number}: could not extract JSON')
                    failed += 1
                    seed_number += 1
                    continue

                strategy = _build_strategy_file(
                    strategy_json, archetype, 0, seed_number, []
                )

                # Mark as seed
                seed_meta = make_seed_identity(archetype, seed_number, arch_slot)
                strategy['lineage'].update(seed_meta)

                # Logic audit
                audit = audit_strategy(strategy, list(ASSET_UNIVERSE))
                strategy['logic_audit'] = audit.to_dict()

                if audit.quarantined:
                    log_event('WARNING', 'research_phase',
                              f'R4 seed {seed_number}: quarantined '
                              f'({audit.failures})')
                    failed += 1
                    seed_number += 1
                    continue

                # 2-period backtest
                periods_data = _backtest_strategy_all_periods(
                    composer_json=strategy['strategy']['composer_json'],
                    name=strategy['summary']['name'],
                    periods=BACKTEST_PERIODS_SEED,
                    headers=headers,
                    meta=meta,
                )

                if not periods_data:
                    log_event('WARNING', 'research_phase',
                              f'R4 seed {seed_number}: backtest failed')
                    failed += 1
                    seed_number += 1
                    continue

                # Score
                period_scores = {}
                for period, period_data in periods_data.items():
                    is_disq, reason = check_disqualifiers(period_data, meta)
                    if is_disq:
                        break
                    scored = score_period(period_data, archetype, meta)
                    period_scores[period] = scored['fitness']['period_fitness_score']
                    periods_data[period]  = scored

                if len(period_scores) < len(BACKTEST_PERIODS_SEED):
                    strategy['summary']['disqualified'] = True
                    strategy['summary']['status'] = 'DISQUALIFIED'
                else:
                    # Fill missing periods for composite
                    all_scores = {'6M': 50.0, '1Y': 50.0,
                                  '2Y': 50.0, '3Y': 50.0}
                    all_scores.update(period_scores)
                    composite = compute_composite(all_scores, meta)
                    strategy['summary']['final_composite_fitness'] = \
                        composite['final_composite']
                    strategy['summary']['status'] = 'COMPLETE'
                    strategy['nominal_result'] = {
                        'periods':           periods_data,
                        'composite_fitness': composite,
                    }

            previous_structures.append(
                strategy.get('strategy', {})
                        .get('description', {})
                        .get('summary', '')
            )
            seeds_done.append(strategy)
            last_progress = time.time()

            # Checkpoint every N seeds
            if len(seeds_done) % SEED_CONFIG['checkpoint_every'] == 0:
                _save_checkpoint('R4', seeds_done, len(seeds_done))

            _progress_alert('R4', len(seeds_done), total_seeds)
            seed_number += 1

    r4_output = {
        'seeds':          seeds_done,
        'total_generated': len(seeds_done),
        'total_failed':    failed,
        'completed_at':    _now_iso(),
    }

    _save_state('R4', r4_output)
    elapsed = _elapsed_str(t0)
    send_telegram_alert('INFO',
        f'✅ R4 Seed Generation complete ({elapsed})\n'
        f'Seeds generated: {len(seeds_done)}/{total_seeds}\n'
        f'Failed/skipped: {failed}'
    )
    log_event('INFO', 'research_phase', f'R4: complete in {elapsed}')
    return r4_output


# ── R5 — Seed Lesson Extraction ────────────────────────────────────────────────

def run_r5(meta: dict, anthropic_key: str, dry_run: bool = False) -> dict:
    """
    R5: Seed Lesson Extraction — run Learner on all 24 seeds.
    This is the richest Learner call the system will ever make.
    Writes additional lessons to active.json.
    """
    if is_complete('R5'):
        log_event('INFO', 'research_phase', 'R5: already complete — skipping')
        return get_task_output('R5')

    if not is_complete('R4'):
        raise RuntimeError(
            'R5 requires R4 to be complete first. '
            'Run: python3 src/research_phase.py --task R4'
        )

    log_event('INFO', 'research_phase', 'R5: starting seed lesson extraction')
    send_telegram_alert('INFO', '🧠 R5 Seed Lesson Extraction started')
    t0 = time.time()

    r4_output = get_task_output('R4')
    seeds     = r4_output.get('seeds', [])
    r3_output = get_task_output('R3')
    r3_lessons_count = len(r3_output.get('lessons', [])) if r3_output else 0

    log_event('INFO', 'research_phase',
              f'R5: processing {len(seeds)} seeds')

    # Load current active lessons
    try:
        active_lessons = read_json(str(_ACTIVE_PATH))
    except Exception:
        active_lessons = {'lessons': [], 'total_lessons': 0}

    # Build the brief using learner_prep
    brief = build_brief(seeds, active_lessons.get('lessons', []), generation=0)

    # Add R5 context prefix to the brief
    brief['_r5_context'] = build_r5_brief_prefix()
    brief['_r3_lessons_note'] = build_r5_active_lessons_note(r3_lessons_count)

    if dry_run:
        r5_lessons = _mock_r5_output()
    else:
        r5_lessons = run_learner_agent(
            generation=0,
            brief=brief,
            active_lessons=active_lessons,
            anthropic_key=anthropic_key,
        )

    # Write new lessons to active.json
    new_lessons = r5_lessons.get('lessons', [])
    if new_lessons and not r5_lessons.get('_extraction_failed'):
        _write_r3_lessons_to_kb(new_lessons, meta)
        log_event('INFO', 'research_phase',
                  f'R5: {len(new_lessons)} additional lessons written')

    # Write raw lessons file
    raw_path = _KB_ROOT / 'lessons' / 'raw' / 'gen-000-research-lessons.json'
    write_json_atomic(str(raw_path), r5_lessons)

    # Extract seed analysis for lineage
    seed_analysis = r5_lessons.get('seed_analysis', {})
    recommended_parents = seed_analysis.get('recommended_gen0_parents', [])

    if recommended_parents:
        log_event('INFO', 'research_phase',
                  f'R5: {len(recommended_parents)} generation-0 parents identified')
        for parent in recommended_parents:
            log_event('INFO', 'research_phase',
                      f'  Parent: {parent.get("strategy_id")} '
                      f'({parent.get("archetype")}) '
                      f'fitness={parent.get("fitness", 0):.1f}')

    r5_output = {
        'lessons_extracted':    len(new_lessons),
        'extraction_failed':    r5_lessons.get('_extraction_failed', False),
        'recommended_parents':  recommended_parents,
        'seed_analysis':        seed_analysis,
        'compaction_hints':     r5_lessons.get('compaction_hints', {}),
        'completed_at':         _now_iso(),
    }

    _save_state('R5', r5_output)
    elapsed = _elapsed_str(t0)

    # Final KB summary
    try:
        final_active = read_json(str(_ACTIVE_PATH))
        final_count  = final_active.get('total_lessons', 0)
    except Exception:
        final_count = 0

    send_telegram_alert('INFO',
        f'✅ R5 Seed Lesson Extraction complete ({elapsed})\n'
        f'New lessons added: {len(new_lessons)}\n'
        f'Total active lessons: {final_count}\n'
        f'Generation-0 parents identified: {len(recommended_parents)}\n\n'
        f'🎉 Research Phase COMPLETE\n'
        f'KB is ready for generation 0.'
    )
    log_event('INFO', 'research_phase',
              f'R5: complete in {elapsed}. '
              f'KB has {final_count} active lessons. '
              f'Research Phase COMPLETE.')
    return r5_output


# ── Mock data for dry run ──────────────────────────────────────────────────────

def _mock_period_stats(period: str) -> dict:
    """Return mock period stats for dry run."""
    return {
        'annualized_return': 45.2,
        'sharpe':            2.1,
        'max_drawdown':      10.5,
        'r_squared':         0.12,
        'pearson_r':         -0.08,
    }


def _mock_period_data() -> dict:
    """Return mock full period data block for dry run."""
    return {
        'core_metrics': {
            'annualized_return': 45.2,
            'total_return':      45.2,
            'sharpe':            2.1,
            'max_drawdown':      10.5,
            'volatility':        18.0,
            'win_rate':          62.0,
        },
        'benchmark_metrics': {
            'benchmark_ticker':            'SPY',
            'benchmark_annualized_return': 24.0,
            'beats_benchmark':             True,
            'alpha':      0.25,
            'beta':      -0.15,
            'r_squared':  0.12,
            'correlation':-0.08,
        },
        'fitness': None,
        'raw_api_fields': {},
    }


def _mock_community_symphonies() -> list[dict]:
    return [
        {
            'id':                f'mock-community-{i:03d}',
            'name':              f'Mock Community Symphony {i}',
            'sharpe':            1.5 + i * 0.1,
            'annualized_return': 40.0 + i,
            'max_drawdown':      12.0,
            'r_squared':         0.15,
            'pearson_r':         0.05,
            'tree_structure':    'if SVXY crash → BIL else TQQQ',
            'tickers':           ['SVXY', 'BIL', 'TQQQ'],
        }
        for i in range(5)
    ]


def _mock_r1_output() -> dict:
    return {
        'winning_patterns': [
            {
                'id': 'pat-001',
                'name': 'Outer SVXY crash guard',
                'description': 'max-drawdown on SVXY as outermost condition',
                'why_it_works': 'Prevents catastrophic vol spike losses',
                'evidence_symphony_ids': ['mock-001'],
                'performance_correlation': 'Sharpe +0.8 vs no guard',
                'implementation_notes': 'window=2 threshold=10',
                'parameter_ranges': {'window': '2', 'threshold': '8-12'},
                'archetypes': ['ALL'],
                'in_universe': True,
            }
        ],
        'losing_patterns': [
            {
                'id': 'pat-bad-001',
                'name': 'Naked leveraged ETF',
                'never_do': 'Never hold TQQQ without a crash guard',
                'why_it_fails': '2022 drawdown -80%',
                'historical_evidence': ['mock-001: -80% in 2022'],
                'archetypes_most_affected': ['ALL'],
                'in_universe': True,
            }
        ],
        'parameter_priors': [],
        'asset_insights':   [],
        'correlation_analysis': {
            'high_correlation': {'symphony_ids': [], 'structural_features': 'mock'},
            'uncorrelated': {'symphony_ids': [], 'generator_lesson': 'mock'},
            'negative_correlation': {'symphony_ids': [], 'note': 'none found'},
        },
        'synthesis_notes': 'Mock R1 output for dry run.',
    }


def _mock_r2_output() -> dict:
    return {
        'beta_baller_parameters': [
            {
                'function':      'max-drawdown',
                'asset':         'SVXY',
                'window':        2,
                'threshold':     '10',
                'what_it_detects': 'Volatility crash signal',
                'why_this_value':  'Fast detection of SVXY stress',
                'confidence':    0.90,
                'goal_sensitivity': {
                    'maximize_sharpe':   'keep at 10',
                    'maximize_return':   'consider 13',
                    'minimize_drawdown': 'tighten to 8',
                },
            }
        ],
        'structural_comparison':  {'universal_patterns': [], 'beta_baller_differentiators': []},
        'failure_autopsy': {
            'primary_structural_failure': 'No crash guard',
            'crash_guard_analysis': {'has_guard': False},
            'anti_pattern_lessons': [
                {
                    'id': 'ap-r2-001',
                    'never_do': 'Never hold naked leverage',
                    'why_it_fails': 'Amplified losses',
                    'evidence': 'mock',
                }
            ],
        },
        'cross_symphony_lessons': [],
        'synthesis_notes': 'Mock R2 output for dry run.',
    }


def _mock_r3_output() -> dict:
    return {
        'synthesis_summary': {
            'r1_patterns_reviewed': 1,
            'r2_parameters_reviewed': 1,
            'conflicts_found': 0,
            'conflicts_flagged': 0,
        },
        'lessons': [
            {
                'rank': 1,
                'category': 'hard_rule',
                'subcategory': 'crash_guard',
                'confidence': 0.90,
                'decay': False,
                'archetypes': ['ALL'],
                'lesson': 'Mock lesson for dry run.',
                'parameter_data': None,
                'regime_context': None,
                'supporting_evidence': ['mock'],
                'conflict_flag': False,
                'conflict_notes': None,
                'source': 'BOTH',
                'apply_to_active': True,
            }
        ],
        'deferred_lessons': [],
    }


def _mock_seed_strategy(archetype: str, seed_number: int) -> dict:
    """Return a minimal mock seed strategy for dry run."""
    return {
        'summary': {
            'strategy_id':            f'gen-000-strat-{seed_number:02d}',
            'name':                   f'Mock Seed {seed_number} ({archetype})',
            'archetype':              archetype,
            'generation':             0,
            'final_composite_fitness': 60.0 + seed_number,
            'passed_rough_cut':        True,
            'disqualified':            False,
            'status':                  'COMPLETE',
            'rebalance_frequency':     'daily',
            'optimization_delta':      None,
        },
        'strategy': {'description': {'summary': f'Mock seed {seed_number}'}, 'composer_json': {}},
        'lineage':  {'parent_ids': [], 'generation_type': 'NOVEL',
                     'is_seed': True, 'seed_number': seed_number},
        'nominal_result': {
            'composite_fitness': {'final_composite': 60.0 + seed_number},
            'periods': {},
        },
        'optimizer_data':    None,
        'final_result':      None,
        'pipeline':          {'disqualified': False, 'current_status': 'COMPLETE'},
        'logic_audit':       {'status': 'PASSED', 'quarantined': False},
        'learner_metadata':  {'processed': False},
        'identity':          {'strategy_id': f'gen-000-strat-{seed_number:02d}'},
    }


def _mock_r5_output() -> dict:
    return {
        'generation':        0,
        'lessons_extracted': 3,
        '_extraction_failed': False,
        'lessons': [
            {
                'category':           'structure',
                'subcategory':        'seed_insight',
                'confidence':         0.65,
                'decay':              True,
                'archetypes':         ['ALL'],
                'lesson':             'Mock seed lesson for dry run.',
                'parameter_data':     None,
                'regime_context':     None,
                'supporting_evidence': ['gen-000-strat-01'],
                'apply_to_active':    True,
            }
        ],
        'seed_analysis': {
            'recommended_gen0_parents': [],
            'archetype_summary': {},
        },
        'compaction_hints': {},
    }


# ── Task dependency validation ─────────────────────────────────────────────────

TASK_DEPS = {
    'R1': [],
    'R2': [],           # R2 is independent (reuses R1 data if available)
    'R3': ['R1', 'R2'],
    'R4': ['R3'],
    'R5': ['R4'],
}


def validate_task_order(tasks: list[str]) -> None:
    """Validate that all dependencies are met for the requested tasks."""
    for task in tasks:
        for dep in TASK_DEPS.get(task, []):
            if dep not in tasks and not is_complete(dep):
                raise RuntimeError(
                    f'{task} requires {dep} to be complete first.\n'
                    f'Add {dep} to your task list or run it separately.\n'
                    f'Example: python3 src/research_phase.py '
                    f'--tasks {dep},{task}'
                )


# ── CLI entry point ────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description='OpenClaw Research Phase — seed the KB before generation 0',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  Run all tasks:
    python3 src/research_phase.py --tasks R1,R2,R3,R4,R5

  Run a single task:
    python3 src/research_phase.py --task R1

  Resume from R3 (R1 and R2 already complete):
    python3 src/research_phase.py --tasks R3,R4,R5

  Dry run (no API calls):
    python3 src/research_phase.py --tasks R1,R2,R3 --dry-run

  Check status:
    python3 src/research_phase.py --status
        """
    )
    group = parser.add_mutually_exclusive_group()
    group.add_argument('--tasks', type=str,
                       help='Comma-separated tasks to run e.g. R1,R2,R3')
    group.add_argument('--task',  type=str,
                       help='Single task to run e.g. R1')
    group.add_argument('--status', action='store_true',
                       help='Show completion status of all tasks')
    parser.add_argument('--dry-run', action='store_true',
                        help='Skip real API calls — use mock data')
    parser.add_argument('--force', action='store_true',
                        help='Re-run tasks even if already complete')
    args = parser.parse_args()

    # Status check
    if args.status:
        print('\nResearch Phase Status:')
        for task in ['R1', 'R2', 'R3', 'R4', 'R5']:
            state = _load_state()
            if task in state:
                ts = state[task].get('completed_at', '?')[:19]
                print(f'  {task}: ✓ COMPLETE ({ts})')
            else:
                deps = TASK_DEPS.get(task, [])
                deps_ok = all(is_complete(d) for d in deps)
                status = 'READY' if deps_ok else f'WAITING ({", ".join(deps)})'
                print(f'  {task}: ○ {status}')
        return

    # Determine tasks
    if args.task:
        tasks = [args.task.upper()]
    elif args.tasks:
        tasks = [t.strip().upper() for t in args.tasks.split(',')]
    else:
        parser.print_help()
        return

    # Validate tasks
    valid = {'R1', 'R2', 'R3', 'R4', 'R5'}
    for task in tasks:
        if task not in valid:
            print(f'ERROR: Unknown task {task!r}. Valid tasks: R1, R2, R3, R4, R5')
            sys.exit(1)

    # Force re-run: clear completed state for requested tasks
    if args.force:
        state = _load_state()
        for task in tasks:
            state.pop(task, None)
        write_json_atomic(str(_STATE_PATH), state)
        print(f'Cleared state for: {", ".join(tasks)}')

    # Validate dependencies
    try:
        validate_task_order(tasks)
    except RuntimeError as e:
        print(f'ERROR: {e}')
        sys.exit(1)

    # Load KB and credentials
    initialize_kb_structure()
    meta          = read_json(str(_META_PATH))
    creds         = CredentialManager()
    anthropic_key = creds.get_anthropic_key()

    dry_run = args.dry_run
    if dry_run:
        print('DRY RUN MODE — no real API calls')

    # Run tasks
    task_runners = {
        'R1': run_r1,
        'R2': run_r2,
        'R3': run_r3,
        'R4': run_r4,
        'R5': run_r5,
    }

    for task in tasks:
        print(f'\n{"="*60}')
        print(f'Running {task}...')
        print(f'{"="*60}')
        t0 = time.time()
        try:
            output = task_runners[task](meta, anthropic_key, dry_run)
            print(f'{task}: COMPLETE in {_elapsed_str(t0)}')
        except RuntimeError as e:
            print(f'{task}: BLOCKED — {e}')
            sys.exit(1)
        except Exception as e:
            print(f'{task}: FAILED — {e}')
            log_event('WARNING', 'research_phase',
                      f'{task} failed with exception: {e}')
            sys.exit(1)

    print('\nAll tasks complete.')
    print(f'Run: python3 src/research_phase.py --status')


if __name__ == '__main__':
    main()