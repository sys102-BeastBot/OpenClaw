"""
monitor_agent.py — Governance watchdog (Phase 1 skeleton).

Phase 1 covers: structured event logging, API call logging, cost tracking,
and spend-limit alerting. Security checks are added in later phases.

All log writes are scrubbed for credential values before writing.
No other module writes to monitor/ files directly.

Schema reference: Section 11 (cost-tracker.json).

Log files (all in MONITOR_DIR):
    events.log    — general event log
    api-calls.log — every Composer/Claude API call
    claude-io.log — all Claude prompt inputs and outputs
    security.log  — credential checks, blocked calls (Phase 2+)

Log line format:
    2026-03-21T10:00:00Z [INFO] [component] message
"""

import json
import os
import tempfile
from datetime import date, datetime, timezone
from typing import Optional

# ---------------------------------------------------------------------------
# Directory / file paths (module-level so tests can monkeypatch)
# ---------------------------------------------------------------------------

MONITOR_DIR: str = os.path.expanduser("~/.openclaw/workspace/learning/monitor")

COST_TRACKER_PATH: str = os.path.join(MONITOR_DIR, "cost-tracker.json")
EVENTS_LOG_PATH: str   = os.path.join(MONITOR_DIR, "events.log")
API_LOG_PATH: str      = os.path.join(MONITOR_DIR, "api-calls.log")
CLAUDE_LOG_PATH: str   = os.path.join(MONITOR_DIR, "claude-io.log")
SECURITY_LOG_PATH: str = os.path.join(MONITOR_DIR, "security.log")

# ---------------------------------------------------------------------------
# Valid log levels
# ---------------------------------------------------------------------------

LOG_LEVELS = {"INFO", "WARNING", "CRITICAL", "EMERGENCY"}

# ---------------------------------------------------------------------------
# Exceptions
# ---------------------------------------------------------------------------

class MonitorError(Exception):
    """Raised when monitor_agent encounters an unrecoverable error."""


# ---------------------------------------------------------------------------
# Credential scrubbing (best-effort — never crash the monitor)
# ---------------------------------------------------------------------------

def _scrub(text: str) -> str:
    """Scrub credential values from text before any log write.

    Attempts to use CredentialManager if available. If credentials are not
    loaded (e.g. file missing in test environments), returns text unchanged —
    the monitor must not crash because of a missing credentials file.

    Args:
        text: Any string to scrub.

    Returns:
        Text with all known credential values replaced by [REDACTED].
    """
    try:
        import sys
        src_dir = os.path.dirname(os.path.abspath(__file__))
        if src_dir not in sys.path:
            sys.path.insert(0, src_dir)
        from credentials import CredentialManager
        mgr = CredentialManager()
        return mgr.redact_for_logging(text)
    except Exception:
        return text


# ---------------------------------------------------------------------------
# Atomic write helper (local — avoids importing kb_writer to keep loose coupling)
# ---------------------------------------------------------------------------

def _write_atomic(path: str, data: dict) -> None:
    """Write JSON to path atomically. Raises MonitorError on failure."""
    dir_path = os.path.dirname(path) or "."
    tmp_path: Optional[str] = None
    try:
        os.makedirs(dir_path, exist_ok=True)
        with tempfile.NamedTemporaryFile(
            mode="w", dir=dir_path, suffix=".tmp",
            delete=False, encoding="utf-8"
        ) as f:
            tmp_path = f.name
            json.dump(data, f, indent=2)
        os.replace(tmp_path, path)
    except Exception as exc:
        if tmp_path is not None:
            try:
                os.unlink(tmp_path)
            except OSError:
                pass
        raise MonitorError(f"Atomic write failed for '{path}': {exc}") from exc


def _read_json(path: str) -> dict:
    """Read JSON from path. Returns empty dict if file doesn't exist."""
    if not os.path.exists(path):
        return {}
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


# ---------------------------------------------------------------------------
# Log appender
# ---------------------------------------------------------------------------

def _append_log(log_path: str, line: str) -> None:
    """Append a single scrubbed line to a log file.

    Creates the file (and parent directory) if it doesn't exist.

    Args:
        log_path: Absolute path to the log file.
        line: Log line to append (newline appended automatically).
    """
    scrubbed = _scrub(line)
    os.makedirs(os.path.dirname(log_path), exist_ok=True)
    with open(log_path, "a", encoding="utf-8") as f:
        f.write(scrubbed + "\n")


def _format_log_line(level: str, component: str, message: str) -> str:
    """Format a log line per the schema standard.

    Format: 2026-03-21T10:00:00Z [LEVEL] [component] message

    Args:
        level: Log level string (INFO/WARNING/CRITICAL/EMERGENCY).
        component: Component name (e.g. "scorer", "monitor").
        message: Human-readable message.

    Returns:
        Formatted log line string (without trailing newline).
    """
    ts = _now_iso()
    return f"{ts} [{level}] [{component}] {message}"


# ---------------------------------------------------------------------------
# Cost tracker I/O
# ---------------------------------------------------------------------------

def _now_iso() -> str:
    """Return current UTC time as ISO 8601 string (seconds precision)."""
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _today_str() -> str:
    """Return today's date as YYYY-MM-DD (UTC)."""
    return datetime.now(timezone.utc).strftime("%Y-%m-%d")


def _month_str() -> str:
    """Return current month as YYYY-MM (UTC)."""
    return datetime.now(timezone.utc).strftime("%Y-%m")


def _default_cost_tracker() -> dict:
    """Return a fresh cost-tracker.json structure with defaults."""
    return {
        "limits": {
            "daily_alert_threshold": 10.00,
            "daily_hard_limit": 15.00,
            "monthly_alert_threshold": 15.00,
            "monthly_hard_limit": 20.00,
            "research_phase_budget": 50.00,
            "research_phase_spent": 0.0,
            "research_phase_active": True,
        },
        "current_period": {
            "date": _today_str(),
            "month": _month_str(),
            "daily_cost_usd": 0.0,
            "monthly_cost_usd": 0.0,
        },
        "pricing": {
            "model": "claude-sonnet-4-6",
            "input_cost_per_1M_tokens": 3.00,
            "output_cost_per_1M_tokens": 15.00,
        },
        "call_log": [],
        "generation_costs": {},
        "lifetime": {
            "total_calls": 0,
            "total_input_tokens": 0,
            "total_output_tokens": 0,
            "total_cost_usd": 0.0,
            "first_call_at": None,
            "last_call_at": None,
        },
    }


def _load_cost_tracker() -> dict:
    """Load cost tracker from disk, applying date-based resets if needed.

    If the file doesn't exist, returns a fresh default.
    If the stored date differs from today, resets daily_cost_usd.
    If the stored month differs from current month, resets monthly_cost_usd.

    Returns:
        Cost tracker dict with current-period values up to date.
    """
    raw = _read_json(COST_TRACKER_PATH)
    if not raw:
        return _default_cost_tracker()

    tracker = raw
    cp = tracker.get("current_period", {})

    today = _today_str()
    this_month = _month_str()

    modified = False

    # Daily reset
    if cp.get("date") != today:
        cp["date"] = today
        cp["daily_cost_usd"] = 0.0
        modified = True

    # Monthly reset
    if cp.get("month") != this_month:
        cp["month"] = this_month
        cp["monthly_cost_usd"] = 0.0
        modified = True

    tracker["current_period"] = cp

    if modified:
        _write_atomic(COST_TRACKER_PATH, tracker)

    return tracker


def _save_cost_tracker(tracker: dict) -> None:
    """Atomically save the cost tracker to disk."""
    _write_atomic(COST_TRACKER_PATH, tracker)


# ---------------------------------------------------------------------------
# Cost calculation
# ---------------------------------------------------------------------------

def _compute_cost(input_tokens: int, output_tokens: int, pricing: dict) -> float:
    """Compute API call cost in USD.

    Formula: (input × input_rate + output × output_rate) / 1_000_000

    Args:
        input_tokens: Number of input tokens consumed.
        output_tokens: Number of output tokens generated.
        pricing: Pricing block from cost-tracker.json.

    Returns:
        Cost in USD as a float.
    """
    input_rate: float  = pricing.get("input_cost_per_1M_tokens", 3.00)
    output_rate: float = pricing.get("output_cost_per_1M_tokens", 15.00)
    return (input_tokens * input_rate + output_tokens * output_rate) / 1_000_000


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def log_event(
    level: str,
    component: str,
    message: str,
    data: Optional[dict] = None,
) -> None:
    """Log a significant event to events.log.

    Args:
        level: One of INFO | WARNING | CRITICAL | EMERGENCY.
        component: Name of the calling component (e.g. "scorer").
        message: Human-readable event description.
        data: Optional dict of structured data (appended as JSON suffix).

    Raises:
        ValueError: If level is not a valid log level.
    """
    if level not in LOG_LEVELS:
        raise ValueError(
            f"Invalid log level '{level}'. Must be one of: {sorted(LOG_LEVELS)}"
        )
    line = _format_log_line(level, component, message)
    if data:
        line += " | " + json.dumps(data)
    _append_log(EVENTS_LOG_PATH, line)


def log_api_call(
    call_type: str,
    strategy_id: Optional[str],
    generation: int,
    input_tokens: int,
    output_tokens: int,
    duration_ms: int,
    success: bool,
    error: Optional[str] = None,
) -> None:
    """Log a Composer or Claude API call and update cost tracking.

    Appends an entry to api-calls.log and updates cost-tracker.json.

    Args:
        call_type: One of GENERATOR | LEARNER | COMPACTOR | RESEARCH_R1..R5 | VERIFICATION.
        strategy_id: Strategy ID for GENERATOR calls; None for others.
        generation: Generation number (0 for research phase).
        input_tokens: Input tokens consumed.
        output_tokens: Output tokens generated.
        duration_ms: Wall clock time in milliseconds.
        success: False if API returned an error.
        error: Error message if success=False, else None.
    """
    tracker = _load_cost_tracker()
    pricing = tracker.get("pricing", {
        "input_cost_per_1M_tokens": 3.00,
        "output_cost_per_1M_tokens": 15.00,
    })

    cost = _compute_cost(input_tokens, output_tokens, pricing)
    now = _now_iso()

    # Build call log entry
    lifetime = tracker.get("lifetime", {})
    call_number = (lifetime.get("total_calls") or 0) + 1
    entry = {
        "id": f"call-{call_number:03d}",
        "timestamp": now,
        "call_type": call_type,
        "strategy_id": strategy_id,
        "generation": generation,
        "input_tokens": input_tokens,
        "output_tokens": output_tokens,
        "cost_usd": round(cost, 8),
        "duration_ms": duration_ms,
        "success": success,
        "error": _scrub(error) if error else None,
    }

    # Update call log (keep last 500)
    call_log = tracker.get("call_log", [])
    call_log.append(entry)
    if len(call_log) > 500:
        call_log = call_log[-500:]
    tracker["call_log"] = call_log

    # Update current period costs
    cp = tracker["current_period"]
    cp["daily_cost_usd"] = round(cp.get("daily_cost_usd", 0.0) + cost, 8)
    cp["monthly_cost_usd"] = round(cp.get("monthly_cost_usd", 0.0) + cost, 8)

    # Update lifetime stats
    tracker["lifetime"] = {
        "total_calls": call_number,
        "total_input_tokens": lifetime.get("total_input_tokens", 0) + input_tokens,
        "total_output_tokens": lifetime.get("total_output_tokens", 0) + output_tokens,
        "total_cost_usd": round(lifetime.get("total_cost_usd", 0.0) + cost, 8),
        "first_call_at": lifetime.get("first_call_at") or now,
        "last_call_at": now,
    }

    # Update generation costs
    gen_key = f"gen-{generation:03d}"
    gen_costs = tracker.get("generation_costs", {})
    gc = gen_costs.get(gen_key, {"total_cost_usd": 0.0, "call_count": 0})
    gc["total_cost_usd"] = round(gc["total_cost_usd"] + cost, 8)
    gc["call_count"] = gc["call_count"] + 1
    gen_costs[gen_key] = gc
    tracker["generation_costs"] = gen_costs

    _save_cost_tracker(tracker)

    # Write to api-calls.log
    status_str = "OK" if success else f"ERROR: {error or 'unknown'}"
    log_line = _format_log_line(
        "INFO" if success else "WARNING",
        "monitor",
        f"API call {entry['id']} type={call_type} gen={generation} "
        f"in={input_tokens} out={output_tokens} cost=${cost:.6f} "
        f"dur={duration_ms}ms status={status_str}",
    )
    _append_log(API_LOG_PATH, log_line)

    # Flag slow calls
    if duration_ms > 30000:
        log_event(
            "WARNING", "monitor",
            f"Slow API call {entry['id']} took {duration_ms}ms (threshold 30000ms)",
        )

    # Check spend after every call
    check_spend_limits()


def check_spend_limits() -> tuple[bool, str]:
    """Check current spend against configured limits and fire alerts if needed.

    Fires a WARNING Telegram alert when daily/monthly alert threshold is exceeded.
    Fires a CRITICAL alert and triggers emergency stop when hard limit is hit.

    Returns:
        Tuple of (within_limits: bool, message: str).
        within_limits is False when any hard limit is exceeded.
    """
    tracker = _load_cost_tracker()
    limits = tracker.get("limits", {})
    cp = tracker.get("current_period", {})

    daily_cost: float    = cp.get("daily_cost_usd", 0.0)
    monthly_cost: float  = cp.get("monthly_cost_usd", 0.0)

    daily_alert: float   = limits.get("daily_alert_threshold", 10.00)
    daily_hard: float    = limits.get("daily_hard_limit", 15.00)
    monthly_alert: float = limits.get("monthly_alert_threshold", 15.00)
    monthly_hard: float  = limits.get("monthly_hard_limit", 20.00)

    # Hard limits (checked first — more severe)
    if daily_cost > daily_hard:
        msg = (
            f"Daily spend ${daily_cost:.2f} exceeded hard limit ${daily_hard:.2f}. "
            "All Claude calls suspended."
        )
        log_event("CRITICAL", "monitor", msg)
        send_telegram_alert("CRITICAL", msg)
        _trigger_emergency_stop(tracker, msg)
        return False, msg

    if monthly_cost > monthly_hard:
        msg = (
            f"Monthly spend ${monthly_cost:.2f} exceeded hard limit ${monthly_hard:.2f}. "
            "Emergency stop triggered."
        )
        log_event("CRITICAL", "monitor", msg)
        send_telegram_alert("CRITICAL", msg)
        _trigger_emergency_stop(tracker, msg)
        return False, msg

    # Alert thresholds (warning only — system continues)
    if daily_cost > daily_alert:
        msg = f"Daily spend ${daily_cost:.2f} exceeded alert threshold ${daily_alert:.2f}"
        log_event("WARNING", "monitor", msg)
        send_telegram_alert("WARNING", msg)

    if monthly_cost > monthly_alert:
        msg = f"Monthly spend ${monthly_cost:.2f} exceeded alert threshold ${monthly_alert:.2f}"
        log_event("WARNING", "monitor", msg)
        send_telegram_alert("WARNING", msg)

    return True, "OK"


def get_daily_spend() -> float:
    """Return total API spend for today (UTC) in USD.

    Applies date-based reset logic before returning.

    Returns:
        Current day's total spend in USD.
    """
    tracker = _load_cost_tracker()
    return tracker.get("current_period", {}).get("daily_cost_usd", 0.0)


def get_monthly_spend() -> float:
    """Return total API spend for the current month (UTC) in USD.

    Applies month-based reset logic before returning.

    Returns:
        Current month's total spend in USD.
    """
    tracker = _load_cost_tracker()
    return tracker.get("current_period", {}).get("monthly_cost_usd", 0.0)


def send_telegram_alert(
    level: str,
    message: str,
    details: Optional[str] = None,
) -> None:
    """Send a Telegram alert for spend or anomaly events.

    Phase 1: Logs the alert to events.log. Full Telegram webhook
    integration is wired in a later phase.

    Args:
        level: Alert severity — WARNING | CRITICAL | EMERGENCY.
        message: Primary alert message.
        details: Optional extra context string.
    """
    alert_text = f"TELEGRAM ALERT [{level}]: {message}"
    if details:
        alert_text += f" | {details}"
    _append_log(EVENTS_LOG_PATH, _format_log_line(level, "telegram-alert", alert_text))


# ---------------------------------------------------------------------------
# Emergency stop
# ---------------------------------------------------------------------------

def _trigger_emergency_stop(tracker: dict, reason: str) -> None:
    """Mark the cost tracker as halted and log an emergency event.

    Phase 1: Sets a halted flag in the cost tracker. Full meta.json
    halting via kb_writer is added in a later phase.

    Args:
        tracker: The currently-loaded cost tracker dict (mutated in place).
        reason: Plain text reason for the stop.
    """
    tracker["emergency_stopped"] = True
    tracker["emergency_stop_reason"] = reason
    tracker["emergency_stop_at"] = _now_iso()
    _save_cost_tracker(tracker)
    log_event(
        "EMERGENCY", "monitor",
        f"Emergency stop triggered: {reason}",
    )
