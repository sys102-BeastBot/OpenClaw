"""
credentials.py — Single access point for all credentials.

No other module reads credentials files directly. All credential access
goes through CredentialManager. Raw credential values never appear in
logs, exceptions, or return values (except the two deliberate accessors).

Credential file location: ~/.openclaw/composer-credentials.json

Expected credential file shape:
    {
        "composer_api_key_id": "...",
        "composer_api_secret": "...",
        "anthropic_api_key": "sk-ant-..."
    }

Schema reference: Section 11 (monitor — credential handling notes).
"""

import json
import os
import re
from typing import Optional


# ---------------------------------------------------------------------------
# Exceptions
# ---------------------------------------------------------------------------

class CredentialError(Exception):
    """Raised when credentials cannot be loaded or are invalid.

    CRITICAL: Never include raw credential values in exception messages.
    """


# ---------------------------------------------------------------------------
# CredentialManager — singleton
# ---------------------------------------------------------------------------

class CredentialManager:
    """Singleton credential manager. Loads credentials once at init.

    Only one instance is ever created. Subsequent instantiations return
    the same object. Credentials are loaded once at construction time and
    never re-read unless reload() is called explicitly.

    Usage:
        mgr = CredentialManager()
        headers = mgr.get_composer_headers()
        key = mgr.get_anthropic_key()
        safe_log = mgr.redact_for_logging(some_text)
    """

    _instance: Optional["CredentialManager"] = None
    _credentials_path: str = os.path.expanduser(
        "~/.openclaw/composer-credentials.json"
    )

    def __new__(cls) -> "CredentialManager":
        """Enforce singleton — return existing instance if already created."""
        if cls._instance is None:
            instance = super().__new__(cls)
            instance._loaded = False
            instance._creds: dict = {}
            cls._instance = instance
        return cls._instance

    def __init__(self) -> None:
        """Load credentials on first construction only."""
        if not self._loaded:
            self._load()

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def get_composer_headers(self) -> dict:
        """Return HTTP headers required for Composer API calls.

        Returns:
            Dict with keys 'x-api-key-id' and 'authorization'.

        Raises:
            CredentialError: If required Composer credentials are missing.
        """
        key_id = self._get_required("composer_api_key_id")
        secret = self._get_required("composer_api_secret")
        return {
            "x-api-key-id": key_id,
            "authorization": f"Bearer {secret}",
        }

    def get_anthropic_key(self) -> str:
        """Return the Anthropic API key string.

        Returns:
            The raw Anthropic API key.

        Raises:
            CredentialError: If the Anthropic API key is missing.
        """
        return self._get_required("anthropic_api_key")

    def redact_for_logging(self, text: str) -> str:
        """Replace all credential values in text with [REDACTED].

        Scans for every known credential value and replaces ALL occurrences.
        Safe to call on any string before writing to any log.

        Args:
            text: Any string that may contain credential values.

        Returns:
            The string with all credential values replaced by [REDACTED].
        """
        result = text
        for value in self._get_sensitive_values():
            if value and len(value) >= 4:
                result = result.replace(value, "[REDACTED]")
        return result

    def get_sensitive_patterns(self) -> list[str]:
        """Return list of all current credential values for external redaction.

        Returns:
            List of raw credential value strings. Caller is responsible for
            not logging this list.
        """
        return self._get_sensitive_values()

    def reload(self) -> None:
        """Explicitly reload credentials from disk.

        Call this only if the credentials file has been updated at runtime.
        Resets the loaded state and re-reads from disk.

        Raises:
            CredentialError: If credentials cannot be loaded after reload.
        """
        self._loaded = False
        self._creds = {}
        self._load()

    # ------------------------------------------------------------------
    # Private helpers
    # ------------------------------------------------------------------

    def _load(self) -> None:
        """Load credentials from the credentials file.

        Raises:
            CredentialError: If the file is missing, unreadable, or invalid JSON.
                             Never includes credential values in the message.
        """
        path = self._credentials_path
        if not os.path.exists(path):
            raise CredentialError(
                f"Credentials file not found: '{path}'. "
                "Create it with composer_api_key_id, composer_api_secret, "
                "and anthropic_api_key fields."
            )
        try:
            with open(path, "r", encoding="utf-8") as f:
                data = json.load(f)
        except json.JSONDecodeError as exc:
            raise CredentialError(
                f"Credentials file at '{path}' contains invalid JSON "
                f"(line {exc.lineno}, col {exc.colno})."
            ) from exc
        except OSError as exc:
            raise CredentialError(
                f"Cannot read credentials file at '{path}': {exc.strerror}."
            ) from exc

        if not isinstance(data, dict):
            raise CredentialError(
                f"Credentials file at '{path}' must be a JSON object, "
                f"got {type(data).__name__}."
            )

        self._creds = data
        self._loaded = True

    def _get_required(self, key: str) -> str:
        """Return a required credential value.

        Args:
            key: Credential key name.

        Returns:
            The credential value string.

        Raises:
            CredentialError: If the key is absent or empty. Message never
                             includes the actual value.
        """
        value = self._creds.get(key)
        if not value:
            raise CredentialError(
                f"Required credential '{key}' is missing or empty in "
                f"'{self._credentials_path}'."
            )
        if not isinstance(value, str):
            raise CredentialError(
                f"Credential '{key}' must be a string, "
                f"got {type(value).__name__}."
            )
        return value

    def _get_sensitive_values(self) -> list[str]:
        """Return all credential values as a flat list for redaction scanning."""
        return [str(v) for v in self._creds.values() if v]

    @classmethod
    def _reset_singleton(cls) -> None:
        """Reset the singleton instance. FOR TESTING ONLY.

        Allows tests to create fresh instances with different credential files.
        Never call this in production code.
        """
        cls._instance = None
