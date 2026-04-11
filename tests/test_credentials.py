"""
test_credentials.py — Full test suite for credentials.py.

Tests required per SKILL.md:
  - redact_for_logging() removes all credential values from a string
  - Headers dict contains correct keys (x-api-key-id, authorization)
  - Singleton pattern enforced — two instantiations return same object
  - Missing credentials file raises CredentialError with clear message
  - No credential values appear in any exception messages
"""

import json
import os
import sys
import pytest

# ---------------------------------------------------------------------------
# Path setup
# ---------------------------------------------------------------------------
SRC_DIR = os.path.join(os.path.dirname(__file__), "..", "src")
sys.path.insert(0, SRC_DIR)

import credentials as creds_module  # noqa: E402
from credentials import CredentialError, CredentialManager  # noqa: E402


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

VALID_CREDS = {
    "composer_api_key_id": "test-key-id-abc123",
    "composer_api_secret": "test-secret-xyz789",
    "anthropic_api_key": "sk-ant-test-anthropic-key-987",
}


@pytest.fixture(autouse=True)
def reset_singleton():
    """Reset singleton before and after every test for isolation."""
    CredentialManager._reset_singleton()
    yield
    CredentialManager._reset_singleton()


@pytest.fixture()
def creds_file(tmp_path):
    """Write a valid credentials file and patch the module path."""
    path = tmp_path / "composer-credentials.json"
    path.write_text(json.dumps(VALID_CREDS), encoding="utf-8")
    return str(path)


@pytest.fixture()
def patched_mgr(creds_file, monkeypatch):
    """Return a CredentialManager pointed at the temp credentials file."""
    monkeypatch.setattr(CredentialManager, "_credentials_path", creds_file)
    return CredentialManager()


# ---------------------------------------------------------------------------
# Singleton tests
# ---------------------------------------------------------------------------

class TestSingleton:
    """Singleton pattern enforced — two instantiations return same object."""

    def test_two_instantiations_same_object(self, creds_file, monkeypatch):
        monkeypatch.setattr(CredentialManager, "_credentials_path", creds_file)
        a = CredentialManager()
        b = CredentialManager()
        assert a is b

    def test_three_instantiations_same_object(self, creds_file, monkeypatch):
        monkeypatch.setattr(CredentialManager, "_credentials_path", creds_file)
        a = CredentialManager()
        b = CredentialManager()
        c = CredentialManager()
        assert a is b is c

    def test_reset_allows_fresh_instance(self, creds_file, monkeypatch):
        monkeypatch.setattr(CredentialManager, "_credentials_path", creds_file)
        a = CredentialManager()
        CredentialManager._reset_singleton()
        monkeypatch.setattr(CredentialManager, "_credentials_path", creds_file)
        b = CredentialManager()
        # Different objects after reset (though equal in state)
        assert a is not b

    def test_singleton_id_stable_across_calls(self, patched_mgr):
        mgr2 = CredentialManager()
        assert id(patched_mgr) == id(mgr2)


# ---------------------------------------------------------------------------
# Missing / invalid credentials file tests
# ---------------------------------------------------------------------------

class TestMissingCredentialsFile:
    """Missing credentials file raises CredentialError with clear message."""

    def test_missing_file_raises_credential_error(self, tmp_path, monkeypatch):
        missing = str(tmp_path / "nonexistent.json")
        monkeypatch.setattr(CredentialManager, "_credentials_path", missing)
        with pytest.raises(CredentialError, match="not found"):
            CredentialManager()

    def test_error_message_includes_path(self, tmp_path, monkeypatch):
        missing = str(tmp_path / "nonexistent.json")
        monkeypatch.setattr(CredentialManager, "_credentials_path", missing)
        with pytest.raises(CredentialError) as exc_info:
            CredentialManager()
        assert str(missing) in str(exc_info.value)

    def test_invalid_json_raises_credential_error(self, tmp_path, monkeypatch):
        path = tmp_path / "bad.json"
        path.write_text("{not valid json", encoding="utf-8")
        monkeypatch.setattr(CredentialManager, "_credentials_path", str(path))
        with pytest.raises(CredentialError, match="invalid JSON"):
            CredentialManager()

    def test_non_object_json_raises_credential_error(self, tmp_path, monkeypatch):
        path = tmp_path / "list.json"
        path.write_text(json.dumps(["a", "b"]), encoding="utf-8")
        monkeypatch.setattr(CredentialManager, "_credentials_path", str(path))
        with pytest.raises(CredentialError):
            CredentialManager()

    def test_missing_composer_key_id_raises(self, tmp_path, monkeypatch):
        creds = {k: v for k, v in VALID_CREDS.items() if k != "composer_api_key_id"}
        path = tmp_path / "creds.json"
        path.write_text(json.dumps(creds), encoding="utf-8")
        monkeypatch.setattr(CredentialManager, "_credentials_path", str(path))
        mgr = CredentialManager()
        with pytest.raises(CredentialError, match="composer_api_key_id"):
            mgr.get_composer_headers()

    def test_missing_anthropic_key_raises(self, tmp_path, monkeypatch):
        creds = {k: v for k, v in VALID_CREDS.items() if k != "anthropic_api_key"}
        path = tmp_path / "creds.json"
        path.write_text(json.dumps(creds), encoding="utf-8")
        monkeypatch.setattr(CredentialManager, "_credentials_path", str(path))
        mgr = CredentialManager()
        with pytest.raises(CredentialError, match="anthropic_api_key"):
            mgr.get_anthropic_key()


# ---------------------------------------------------------------------------
# No credential values in exception messages
# ---------------------------------------------------------------------------

class TestNoCredentialsInExceptions:
    """No credential values appear in any exception messages."""

    def test_missing_key_error_has_no_credential_value(self, tmp_path, monkeypatch):
        """Exception message for missing key must not contain other cred values."""
        partial = {"composer_api_key_id": "test-key-id-abc123"}
        path = tmp_path / "partial.json"
        path.write_text(json.dumps(partial), encoding="utf-8")
        monkeypatch.setattr(CredentialManager, "_credentials_path", str(path))
        mgr = CredentialManager()
        with pytest.raises(CredentialError) as exc_info:
            mgr.get_anthropic_key()
        msg = str(exc_info.value)
        # The actual value of composer_api_key_id must not appear in the error
        assert "test-key-id-abc123" not in msg

    def test_missing_file_error_has_no_fake_credentials(self, tmp_path, monkeypatch):
        missing = str(tmp_path / "no-file.json")
        monkeypatch.setattr(CredentialManager, "_credentials_path", missing)
        with pytest.raises(CredentialError) as exc_info:
            CredentialManager()
        msg = str(exc_info.value)
        # Path is fine to include; credentials are not
        for v in VALID_CREDS.values():
            assert v not in msg

    def test_invalid_json_error_has_no_credential_content(self, tmp_path, monkeypatch):
        """Malformed file error must not echo file content back."""
        secret_looking_content = '{"key": "sk-ant-super-secret-do-not-leak"'
        path = tmp_path / "bad.json"
        path.write_text(secret_looking_content, encoding="utf-8")
        monkeypatch.setattr(CredentialManager, "_credentials_path", str(path))
        with pytest.raises(CredentialError) as exc_info:
            CredentialManager()
        msg = str(exc_info.value)
        assert "sk-ant-super-secret-do-not-leak" not in msg


# ---------------------------------------------------------------------------
# get_composer_headers() tests
# ---------------------------------------------------------------------------

class TestGetComposerHeaders:
    """Headers dict contains correct keys (x-api-key-id, authorization)."""

    def test_returns_dict(self, patched_mgr):
        headers = patched_mgr.get_composer_headers()
        assert isinstance(headers, dict)

    def test_contains_x_api_key_id(self, patched_mgr):
        headers = patched_mgr.get_composer_headers()
        assert "x-api-key-id" in headers

    def test_contains_authorization(self, patched_mgr):
        headers = patched_mgr.get_composer_headers()
        assert "authorization" in headers

    def test_x_api_key_id_value(self, patched_mgr):
        headers = patched_mgr.get_composer_headers()
        assert headers["x-api-key-id"] == VALID_CREDS["composer_api_key_id"]

    def test_authorization_is_bearer(self, patched_mgr):
        headers = patched_mgr.get_composer_headers()
        assert headers["authorization"].startswith("Bearer ")

    def test_authorization_contains_secret(self, patched_mgr):
        headers = patched_mgr.get_composer_headers()
        assert VALID_CREDS["composer_api_secret"] in headers["authorization"]

    def test_exactly_two_keys(self, patched_mgr):
        headers = patched_mgr.get_composer_headers()
        assert len(headers) == 2


# ---------------------------------------------------------------------------
# get_anthropic_key() tests
# ---------------------------------------------------------------------------

class TestGetAnthropicKey:
    def test_returns_string(self, patched_mgr):
        key = patched_mgr.get_anthropic_key()
        assert isinstance(key, str)

    def test_returns_correct_value(self, patched_mgr):
        key = patched_mgr.get_anthropic_key()
        assert key == VALID_CREDS["anthropic_api_key"]

    def test_not_empty(self, patched_mgr):
        key = patched_mgr.get_anthropic_key()
        assert len(key) > 0


# ---------------------------------------------------------------------------
# redact_for_logging() tests
# ---------------------------------------------------------------------------

class TestRedactForLogging:
    """redact_for_logging() removes all credential values from a string."""

    def test_redacts_key_id(self, patched_mgr):
        text = f"Calling API with key {VALID_CREDS['composer_api_key_id']} now"
        result = patched_mgr.redact_for_logging(text)
        assert VALID_CREDS["composer_api_key_id"] not in result
        assert "[REDACTED]" in result

    def test_redacts_secret(self, patched_mgr):
        text = f"Secret is {VALID_CREDS['composer_api_secret']}"
        result = patched_mgr.redact_for_logging(text)
        assert VALID_CREDS["composer_api_secret"] not in result

    def test_redacts_anthropic_key(self, patched_mgr):
        text = f"anthropic_api_key={VALID_CREDS['anthropic_api_key']}"
        result = patched_mgr.redact_for_logging(text)
        assert VALID_CREDS["anthropic_api_key"] not in result

    def test_redacts_all_credentials_simultaneously(self, patched_mgr):
        """All 5 bonuses applied simultaneously — here: all 3 creds in one string."""
        text = (
            f"key_id={VALID_CREDS['composer_api_key_id']} "
            f"secret={VALID_CREDS['composer_api_secret']} "
            f"anthropic={VALID_CREDS['anthropic_api_key']}"
        )
        result = patched_mgr.redact_for_logging(text)
        for v in VALID_CREDS.values():
            assert v not in result, f"Credential value still present: {v[:8]}..."

    def test_redacts_all_occurrences_not_just_first(self, patched_mgr):
        """Must replace ALL occurrences, not just the first."""
        val = VALID_CREDS["composer_api_key_id"]
        text = f"{val} and again {val} and one more {val}"
        result = patched_mgr.redact_for_logging(text)
        assert val not in result
        assert result.count("[REDACTED]") == 3

    def test_non_credential_text_preserved(self, patched_mgr):
        text = "This is normal log output with no secrets"
        result = patched_mgr.redact_for_logging(text)
        assert result == text

    def test_empty_string_returns_empty(self, patched_mgr):
        assert patched_mgr.redact_for_logging("") == ""

    def test_redaction_marker_is_redacted(self, patched_mgr):
        """Replacement marker should be [REDACTED], not blank or asterisks."""
        text = f"key={VALID_CREDS['composer_api_key_id']}"
        result = patched_mgr.redact_for_logging(text)
        assert "[REDACTED]" in result

    def test_partial_credential_not_redacted(self, patched_mgr):
        """Partial match of a credential value (too short) should not be redacted."""
        # Values < 4 chars are skipped. All our test creds are long.
        # Test that a prefix that's also in normal text doesn't cause issues.
        text = "test is a normal word"
        result = patched_mgr.redact_for_logging(text)
        # "test" appears in "test-key-id-abc123" but should only be redacted
        # if the full value is present — substring matching is fine here since
        # we replace exact value strings
        assert result == text


# ---------------------------------------------------------------------------
# get_sensitive_patterns() tests
# ---------------------------------------------------------------------------

class TestGetSensitivePatterns:
    def test_returns_list(self, patched_mgr):
        patterns = patched_mgr.get_sensitive_patterns()
        assert isinstance(patterns, list)

    def test_contains_all_credential_values(self, patched_mgr):
        patterns = patched_mgr.get_sensitive_patterns()
        for v in VALID_CREDS.values():
            assert v in patterns

    def test_length_matches_credential_count(self, patched_mgr):
        patterns = patched_mgr.get_sensitive_patterns()
        assert len(patterns) == len(VALID_CREDS)


# ---------------------------------------------------------------------------
# reload() tests
# ---------------------------------------------------------------------------

class TestReload:
    def test_reload_picks_up_new_values(self, tmp_path, monkeypatch):
        path = tmp_path / "creds.json"
        path.write_text(json.dumps(VALID_CREDS), encoding="utf-8")
        monkeypatch.setattr(CredentialManager, "_credentials_path", str(path))
        mgr = CredentialManager()
        assert mgr.get_anthropic_key() == VALID_CREDS["anthropic_api_key"]

        # Update the file
        updated = {**VALID_CREDS, "anthropic_api_key": "sk-ant-new-key-after-reload"}
        path.write_text(json.dumps(updated), encoding="utf-8")
        mgr.reload()
        assert mgr.get_anthropic_key() == "sk-ant-new-key-after-reload"

    def test_reload_raises_if_file_gone(self, tmp_path, monkeypatch):
        path = tmp_path / "creds.json"
        path.write_text(json.dumps(VALID_CREDS), encoding="utf-8")
        monkeypatch.setattr(CredentialManager, "_credentials_path", str(path))
        mgr = CredentialManager()
        path.unlink()  # delete the file
        with pytest.raises(CredentialError, match="not found"):
            mgr.reload()

    def test_reload_singleton_still_same_object(self, creds_file, monkeypatch):
        monkeypatch.setattr(CredentialManager, "_credentials_path", creds_file)
        mgr = CredentialManager()
        mgr.reload()
        mgr2 = CredentialManager()
        assert mgr is mgr2
