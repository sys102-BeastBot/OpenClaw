"""
test_monitor_agent.py — Full test suite for monitor_agent.py (Phase 1).

Tests required per SKILL.md:
  - Cost calculation: (input × 3.0 + output × 15.0) / 1_000_000
  - Daily spend resets at midnight
  - Monthly spend resets on first of month
  - WARNING alert fires when daily_cost > daily_alert_threshold
  - CRITICAL + emergency_stop fires when daily_cost > daily_hard_limit
  - Log entries include correct timestamp, level, component, message
  - Scrubbing applied before any log write (no credentials in logs)
"""

import json
import os
import re
import sys
import pytest
from datetime import datetime, timezone
from unittest import mock

# ---------------------------------------------------------------------------
# Path setup
# ---------------------------------------------------------------------------
SRC_DIR = os.path.join(os.path.dirname(__file__), "..", "src")
sys.path.insert(0, SRC_DIR)

import monitor_agent  # noqa: E402
from monitor_agent import (  # noqa: E402
    MonitorError,
    _compute_cost,
    _default_cost_tracker,
    _format_log_line,
    _load_cost_tracker,
    _save_cost_tracker,
    check_spend_limits,
    get_daily_spend,
    get_monthly_spend,
    log_api_call,
    log_event,
    send_telegram_alert,
)


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

@pytest.fixture(autouse=True)
def isolated_monitor(tmp_path, monkeypatch):
    """Redirect all monitor_agent path constants to tmp_path."""
    monitor_dir = str(tmp_path / "monitor")
    monkeypatch.setattr(monitor_agent, "MONITOR_DIR", monitor_dir)
    monkeypatch.setattr(monitor_agent, "COST_TRACKER_PATH", str(tmp_path / "monitor" / "cost-tracker.json"))
    monkeypatch.setattr(monitor_agent, "EVENTS_LOG_PATH",   str(tmp_path / "monitor" / "events.log"))
    monkeypatch.setattr(monitor_agent, "API_LOG_PATH",      str(tmp_path / "monitor" / "api-calls.log"))
    monkeypatch.setattr(monitor_agent, "CLAUDE_LOG_PATH",   str(tmp_path / "monitor" / "claude-io.log"))
    monkeypatch.setattr(monitor_agent, "SECURITY_LOG_PATH", str(tmp_path / "monitor" / "security.log"))
    os.makedirs(monitor_dir, exist_ok=True)


@pytest.fixture()
def fresh_tracker():
    """Write and return a default cost tracker."""
    tracker = _default_cost_tracker()
    _save_cost_tracker(tracker)
    return tracker


def read_log(path: str) -> list[str]:
    """Read log file lines (strips trailing whitespace)."""
    if not os.path.exists(path):
        return []
    with open(path) as f:
        return [line.rstrip() for line in f.readlines()]


def read_tracker() -> dict:
    return json.loads(open(monitor_agent.COST_TRACKER_PATH).read())


# ---------------------------------------------------------------------------
# _compute_cost() tests
# ---------------------------------------------------------------------------

class TestComputeCost:
    """Cost calculation: (input × 3.0 + output × 15.0) / 1_000_000"""

    DEFAULT_PRICING = {
        "input_cost_per_1M_tokens": 3.00,
        "output_cost_per_1M_tokens": 15.00,
    }

    def test_zero_tokens(self):
        assert _compute_cost(0, 0, self.DEFAULT_PRICING) == 0.0

    def test_input_only(self):
        # 1_000_000 input tokens × $3.00 / 1M = $3.00
        assert _compute_cost(1_000_000, 0, self.DEFAULT_PRICING) == pytest.approx(3.00)

    def test_output_only(self):
        # 1_000_000 output × $15.00 / 1M = $15.00
        assert _compute_cost(0, 1_000_000, self.DEFAULT_PRICING) == pytest.approx(15.00)

    def test_mixed_tokens(self):
        # 500 input × 3 + 100 output × 15 = 1500 + 1500 = 3000 / 1M = 0.003
        result = _compute_cost(500, 100, self.DEFAULT_PRICING)
        assert result == pytest.approx(0.003)

    def test_formula_exact(self):
        inp, out = 12345, 6789
        expected = (inp * 3.00 + out * 15.00) / 1_000_000
        assert _compute_cost(inp, out, self.DEFAULT_PRICING) == pytest.approx(expected)

    def test_custom_pricing(self):
        pricing = {"input_cost_per_1M_tokens": 1.00, "output_cost_per_1M_tokens": 5.00}
        result = _compute_cost(1_000_000, 1_000_000, pricing)
        assert result == pytest.approx(6.00)

    def test_small_call_cost(self):
        """Typical small call: 1000 input + 500 output."""
        result = _compute_cost(1000, 500, self.DEFAULT_PRICING)
        expected = (1000 * 3.00 + 500 * 15.00) / 1_000_000
        assert result == pytest.approx(expected)


# ---------------------------------------------------------------------------
# log_event() tests
# ---------------------------------------------------------------------------

class TestLogEvent:
    """Log entries include correct timestamp, level, component, message."""

    def test_writes_to_events_log(self, fresh_tracker):
        log_event("INFO", "scorer", "test message")
        lines = read_log(monitor_agent.EVENTS_LOG_PATH)
        assert len(lines) >= 1

    def test_log_line_format(self, fresh_tracker):
        """Format: YYYY-MM-DDTHH:MM:SSZ [LEVEL] [component] message"""
        log_event("INFO", "scorer", "hello world")
        lines = read_log(monitor_agent.EVENTS_LOG_PATH)
        last = lines[-1]
        # Timestamp pattern
        assert re.match(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z", last)
        assert "[INFO]" in last
        assert "[scorer]" in last
        assert "hello world" in last

    def test_all_levels_accepted(self, fresh_tracker):
        for level in ["INFO", "WARNING", "CRITICAL", "EMERGENCY"]:
            log_event(level, "test", f"msg at {level}")
        lines = read_log(monitor_agent.EVENTS_LOG_PATH)
        assert len(lines) == 4

    def test_invalid_level_raises(self):
        with pytest.raises(ValueError, match="Invalid log level"):
            log_event("DEBUG", "test", "msg")

    def test_data_dict_appended_as_json(self, fresh_tracker):
        log_event("INFO", "test", "with data", data={"key": "val"})
        lines = read_log(monitor_agent.EVENTS_LOG_PATH)
        last = lines[-1]
        assert '"key"' in last
        assert '"val"' in last

    def test_creates_log_file_and_directory(self, tmp_path):
        """Log file and directory are created if absent."""
        assert not os.path.exists(monitor_agent.EVENTS_LOG_PATH)
        log_event("INFO", "test", "creating")
        assert os.path.exists(monitor_agent.EVENTS_LOG_PATH)

    def test_multiple_entries_appended(self, fresh_tracker):
        log_event("INFO", "a", "first")
        log_event("WARNING", "b", "second")
        lines = read_log(monitor_agent.EVENTS_LOG_PATH)
        assert any("first" in l for l in lines)
        assert any("second" in l for l in lines)


# ---------------------------------------------------------------------------
# _format_log_line() tests
# ---------------------------------------------------------------------------

class TestFormatLogLine:
    def test_contains_all_parts(self):
        line = _format_log_line("WARNING", "monitor", "test msg")
        assert "[WARNING]" in line
        assert "[monitor]" in line
        assert "test msg" in line

    def test_timestamp_is_iso8601(self):
        line = _format_log_line("INFO", "x", "y")
        parts = line.split(" ")
        ts = parts[0]
        assert re.match(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z", ts)


# ---------------------------------------------------------------------------
# Daily spend reset tests
# ---------------------------------------------------------------------------

class TestDailySpendReset:
    """Daily spend resets at midnight (UTC)."""

    def test_daily_spend_returns_current_value(self, fresh_tracker):
        tracker = read_tracker()
        tracker["current_period"]["daily_cost_usd"] = 5.50
        _save_cost_tracker(tracker)
        assert get_daily_spend() == pytest.approx(5.50)

    def test_daily_spend_resets_when_date_differs(self, fresh_tracker):
        """If the stored date is yesterday, daily_cost_usd resets to 0."""
        tracker = read_tracker()
        tracker["current_period"]["date"] = "2000-01-01"  # old date
        tracker["current_period"]["daily_cost_usd"] = 9.99
        _save_cost_tracker(tracker)
        # Reload triggers reset because date differs from today
        result = get_daily_spend()
        assert result == pytest.approx(0.0)

    def test_daily_reset_preserves_monthly_spend(self, fresh_tracker):
        """Daily reset must not zero out the monthly total."""
        tracker = read_tracker()
        tracker["current_period"]["date"] = "2000-01-01"
        tracker["current_period"]["daily_cost_usd"] = 5.00
        tracker["current_period"]["monthly_cost_usd"] = 12.00
        _save_cost_tracker(tracker)
        get_daily_spend()  # triggers reset
        updated = read_tracker()
        assert updated["current_period"]["monthly_cost_usd"] == pytest.approx(12.00)

    def test_no_reset_when_date_matches_today(self, fresh_tracker):
        tracker = read_tracker()
        # date is already today (set by _default_cost_tracker)
        tracker["current_period"]["daily_cost_usd"] = 7.77
        _save_cost_tracker(tracker)
        assert get_daily_spend() == pytest.approx(7.77)


# ---------------------------------------------------------------------------
# Monthly spend reset tests
# ---------------------------------------------------------------------------

class TestMonthlySpendReset:
    """Monthly spend resets on first of month (UTC)."""

    def test_monthly_spend_returns_current_value(self, fresh_tracker):
        tracker = read_tracker()
        tracker["current_period"]["monthly_cost_usd"] = 8.00
        _save_cost_tracker(tracker)
        assert get_monthly_spend() == pytest.approx(8.00)

    def test_monthly_spend_resets_when_month_differs(self, fresh_tracker):
        tracker = read_tracker()
        tracker["current_period"]["month"] = "2000-01"
        tracker["current_period"]["monthly_cost_usd"] = 18.00
        _save_cost_tracker(tracker)
        result = get_monthly_spend()
        assert result == pytest.approx(0.0)

    def test_monthly_reset_preserves_daily_spend_for_current_day(self, fresh_tracker):
        """Monthly reset must not affect today's daily_cost_usd if date is current."""
        tracker = read_tracker()
        tracker["current_period"]["month"] = "2000-01"
        tracker["current_period"]["monthly_cost_usd"] = 18.00
        tracker["current_period"]["daily_cost_usd"] = 3.00
        _save_cost_tracker(tracker)
        get_monthly_spend()
        updated = read_tracker()
        assert updated["current_period"]["daily_cost_usd"] == pytest.approx(3.00)


# ---------------------------------------------------------------------------
# check_spend_limits() tests
# ---------------------------------------------------------------------------

class TestCheckSpendLimits:
    """WARNING fires on alert threshold; CRITICAL + emergency stop on hard limit."""

    def test_within_limits_returns_true(self, fresh_tracker):
        ok, msg = check_spend_limits()
        assert ok is True
        assert msg == "OK"

    def test_warning_alert_when_daily_exceeds_alert_threshold(self, fresh_tracker):
        """WARNING fires when daily_cost > daily_alert_threshold ($10.00)."""
        tracker = read_tracker()
        tracker["current_period"]["daily_cost_usd"] = 10.01
        _save_cost_tracker(tracker)
        with mock.patch.object(monitor_agent, "send_telegram_alert") as mock_alert:
            ok, _ = check_spend_limits()
        assert ok is True  # warning doesn't halt
        mock_alert.assert_called()
        call_args = mock_alert.call_args_list[0][0]
        assert call_args[0] == "WARNING"

    def test_warning_not_fired_at_exact_threshold(self, fresh_tracker):
        """Exactly at threshold — no alert (must be strictly greater than)."""
        tracker = read_tracker()
        tracker["current_period"]["daily_cost_usd"] = 10.00
        _save_cost_tracker(tracker)
        with mock.patch.object(monitor_agent, "send_telegram_alert") as mock_alert:
            ok, _ = check_spend_limits()
        assert ok is True
        mock_alert.assert_not_called()

    def test_critical_and_emergency_stop_when_daily_exceeds_hard_limit(self, fresh_tracker):
        """CRITICAL + emergency_stop fires when daily_cost > daily_hard_limit ($15.00)."""
        tracker = read_tracker()
        tracker["current_period"]["daily_cost_usd"] = 15.01
        _save_cost_tracker(tracker)
        with mock.patch.object(monitor_agent, "send_telegram_alert") as mock_alert:
            ok, msg = check_spend_limits()
        assert ok is False
        assert "hard limit" in msg.lower() or "suspended" in msg.lower()
        mock_alert.assert_called()
        call_args = mock_alert.call_args_list[0][0]
        assert call_args[0] == "CRITICAL"
        # Emergency stop flag set in tracker
        updated = read_tracker()
        assert updated.get("emergency_stopped") is True

    def test_monthly_warning_fires_when_monthly_exceeds_alert(self, fresh_tracker):
        tracker = read_tracker()
        tracker["current_period"]["monthly_cost_usd"] = 15.01
        _save_cost_tracker(tracker)
        with mock.patch.object(monitor_agent, "send_telegram_alert") as mock_alert:
            ok, _ = check_spend_limits()
        assert ok is True
        alerts = [c[0][0] for c in mock_alert.call_args_list]
        assert "WARNING" in alerts

    def test_monthly_critical_fires_when_monthly_exceeds_hard_limit(self, fresh_tracker):
        tracker = read_tracker()
        tracker["current_period"]["monthly_cost_usd"] = 20.01
        _save_cost_tracker(tracker)
        with mock.patch.object(monitor_agent, "send_telegram_alert") as mock_alert:
            ok, msg = check_spend_limits()
        assert ok is False
        call_args = mock_alert.call_args_list[0][0]
        assert call_args[0] == "CRITICAL"

    def test_warning_logged_to_events_log(self, fresh_tracker):
        tracker = read_tracker()
        tracker["current_period"]["daily_cost_usd"] = 12.00
        _save_cost_tracker(tracker)
        with mock.patch.object(monitor_agent, "send_telegram_alert"):
            check_spend_limits()
        lines = read_log(monitor_agent.EVENTS_LOG_PATH)
        assert any("WARNING" in l for l in lines)

    def test_critical_logged_to_events_log(self, fresh_tracker):
        tracker = read_tracker()
        tracker["current_period"]["daily_cost_usd"] = 16.00
        _save_cost_tracker(tracker)
        with mock.patch.object(monitor_agent, "send_telegram_alert"):
            check_spend_limits()
        lines = read_log(monitor_agent.EVENTS_LOG_PATH)
        assert any("CRITICAL" in l for l in lines)


# ---------------------------------------------------------------------------
# log_api_call() tests
# ---------------------------------------------------------------------------

class TestLogApiCall:
    def test_writes_to_api_log(self, fresh_tracker):
        log_api_call("GENERATOR", "gen-001-strat-01", 1, 1000, 500, 1200, True)
        lines = read_log(monitor_agent.API_LOG_PATH)
        assert len(lines) >= 1

    def test_updates_daily_cost(self, fresh_tracker):
        log_api_call("GENERATOR", None, 1, 1_000_000, 0, 100, True)
        # 1M input × $3.00 / 1M = $3.00
        assert get_daily_spend() == pytest.approx(3.00)

    def test_updates_monthly_cost(self, fresh_tracker):
        log_api_call("GENERATOR", None, 1, 0, 1_000_000, 100, True)
        assert get_monthly_spend() == pytest.approx(15.00)

    def test_multiple_calls_accumulate_cost(self, fresh_tracker):
        log_api_call("GENERATOR", None, 1, 1_000_000, 0, 100, True)
        log_api_call("GENERATOR", None, 1, 1_000_000, 0, 100, True)
        assert get_daily_spend() == pytest.approx(6.00)

    def test_error_call_logged_with_warning(self, fresh_tracker):
        log_api_call("GENERATOR", None, 1, 100, 50, 500, False, error="bad request")
        lines = read_log(monitor_agent.API_LOG_PATH)
        assert any("WARNING" in l or "ERROR" in l for l in lines)

    def test_slow_call_triggers_warning_log(self, fresh_tracker):
        """Calls > 30000ms must log a WARNING."""
        log_api_call("GENERATOR", None, 1, 100, 50, 30001, True)
        lines = read_log(monitor_agent.EVENTS_LOG_PATH)
        assert any("WARNING" in l and "Slow" in l for l in lines)

    def test_normal_call_no_slow_warning(self, fresh_tracker):
        log_api_call("GENERATOR", None, 1, 100, 50, 1000, True)
        lines = read_log(monitor_agent.EVENTS_LOG_PATH)
        # Should have no slow warning (may have spend alerts from check_spend_limits)
        slow_lines = [l for l in lines if "Slow" in l]
        assert slow_lines == []

    def test_call_log_entry_has_correct_fields(self, fresh_tracker):
        log_api_call("LEARNER", "gen-001-strat-02", 1, 500, 200, 800, True)
        tracker = read_tracker()
        entry = tracker["call_log"][-1]
        assert entry["call_type"] == "LEARNER"
        assert entry["strategy_id"] == "gen-001-strat-02"
        assert entry["generation"] == 1
        assert entry["input_tokens"] == 500
        assert entry["output_tokens"] == 200
        assert entry["duration_ms"] == 800
        assert entry["success"] is True

    def test_call_ids_sequential(self, fresh_tracker):
        log_api_call("GENERATOR", None, 1, 100, 50, 100, True)
        log_api_call("GENERATOR", None, 1, 100, 50, 100, True)
        tracker = read_tracker()
        ids = [e["id"] for e in tracker["call_log"]]
        assert ids[0] == "call-001"
        assert ids[1] == "call-002"

    def test_lifetime_totals_updated(self, fresh_tracker):
        log_api_call("GENERATOR", None, 1, 300, 100, 100, True)
        tracker = read_tracker()
        lt = tracker["lifetime"]
        assert lt["total_calls"] == 1
        assert lt["total_input_tokens"] == 300
        assert lt["total_output_tokens"] == 100
        assert lt["first_call_at"] is not None

    def test_call_log_capped_at_500(self, fresh_tracker):
        """Call log should not grow beyond 500 entries."""
        for i in range(505):
            log_api_call("GENERATOR", None, 1, 10, 5, 100, True)
        tracker = read_tracker()
        assert len(tracker["call_log"]) == 500


# ---------------------------------------------------------------------------
# Scrubbing tests
# ---------------------------------------------------------------------------

class TestScrubbing:
    """Scrubbing applied before any log write — no credentials in logs."""

    def test_scrub_applied_to_error_field(self, fresh_tracker):
        """Error messages in API call log entries must be scrubbed."""
        # We mock _scrub to verify it's called on the error string
        with mock.patch.object(monitor_agent, "_scrub", wraps=monitor_agent._scrub) as mock_scrub:
            log_api_call("GENERATOR", None, 1, 100, 50, 100, False, error="some error")
        # _scrub should have been called (at least on the error)
        assert mock_scrub.called

    def test_scrub_applied_to_log_lines(self, fresh_tracker):
        """_scrub is called before writing log lines."""
        with mock.patch.object(monitor_agent, "_scrub", wraps=monitor_agent._scrub) as mock_scrub:
            log_event("INFO", "test", "a log line")
        assert mock_scrub.called


# ---------------------------------------------------------------------------
# send_telegram_alert() tests
# ---------------------------------------------------------------------------

class TestSendTelegramAlert:
    def test_logs_alert_to_events_log(self, fresh_tracker):
        send_telegram_alert("WARNING", "test alert")
        lines = read_log(monitor_agent.EVENTS_LOG_PATH)
        assert any("TELEGRAM ALERT" in l for l in lines)

    def test_includes_level_in_log(self, fresh_tracker):
        send_telegram_alert("CRITICAL", "critical alert")
        lines = read_log(monitor_agent.EVENTS_LOG_PATH)
        assert any("CRITICAL" in l for l in lines)

    def test_includes_details_when_provided(self, fresh_tracker):
        send_telegram_alert("WARNING", "main msg", details="extra info")
        lines = read_log(monitor_agent.EVENTS_LOG_PATH)
        assert any("extra info" in l for l in lines)
