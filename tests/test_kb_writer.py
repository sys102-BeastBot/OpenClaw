"""
test_kb_writer.py — Full test suite for kb_writer.py.

Tests required per SKILL.md:
  - Atomic write leaves no temp files on success
  - Atomic write leaves no partial files on simulated crash
  - update_meta merges correctly without overwriting unrelated fields
  - move_to_results fails cleanly if file not in pending/
  - initialize_kb_structure creates all required directories and files
  - All initialized files are valid JSON matching schema shapes
"""

import json
import os
import sys
import tempfile
import unittest.mock as mock

import pytest

# ---------------------------------------------------------------------------
# Path setup
# ---------------------------------------------------------------------------
WORKSPACE = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SRC_DIR = os.path.join(os.path.dirname(__file__), "..", "src")
MOCK_DIR = os.path.join(
    WORKSPACE, "skills", "learning-agent-builder", "mock-data"
)
sys.path.insert(0, SRC_DIR)

import kb_writer  # noqa: E402
from kb_writer import (  # noqa: E402
    KBNotFoundError,
    KBReadError,
    KBWriteError,
    archive_to_history,
    initialize_kb_structure,
    move_to_results,
    read_json,
    update_kb_health,
    update_meta,
    write_json_atomic,
    write_strategy_file,
)


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

@pytest.fixture()
def tmp_kb(tmp_path, monkeypatch):
    """Redirect all kb_writer path constants to a temp directory."""
    kb_root = tmp_path / "kb"
    pending = tmp_path / "pending"
    results = tmp_path / "results"
    history = tmp_path / "history"

    monkeypatch.setattr(kb_writer, "KB_ROOT", str(kb_root))
    monkeypatch.setattr(kb_writer, "PENDING_DIR", str(pending))
    monkeypatch.setattr(kb_writer, "RESULTS_DIR", str(results))
    monkeypatch.setattr(kb_writer, "HISTORY_DIR", str(history))
    monkeypatch.setattr(kb_writer, "META_PATH", str(kb_root / "meta.json"))
    monkeypatch.setattr(kb_writer, "PATTERNS_PATH", str(kb_root / "patterns.json"))
    monkeypatch.setattr(kb_writer, "GRAVEYARD_PATH", str(kb_root / "graveyard.json"))
    monkeypatch.setattr(kb_writer, "LINEAGE_PATH", str(kb_root / "lineage.json"))
    monkeypatch.setattr(
        kb_writer, "LESSONS_ACTIVE_PATH",
        str(kb_root / "lessons" / "active.json")
    )
    monkeypatch.setattr(
        kb_writer, "LESSONS_INDEX_PATH",
        str(kb_root / "lessons" / "index.json")
    )
    monkeypatch.setattr(
        kb_writer, "LESSONS_RAW_DIR",
        str(kb_root / "lessons" / "raw")
    )
    return tmp_path


def load_mock(filename: str) -> dict:
    """Load a mock data JSON file."""
    path = os.path.join(MOCK_DIR, filename)
    with open(path, "r") as f:
        return json.load(f)


@pytest.fixture()
def mock_strategy() -> dict:
    return load_mock("mock-strategy-pending.json")


@pytest.fixture()
def mock_meta() -> dict:
    return load_mock("mock-meta.json")


# ---------------------------------------------------------------------------
# write_json_atomic() tests
# ---------------------------------------------------------------------------

class TestWriteJsonAtomic:
    """Atomic write leaves no temp files on success; no partial files on crash."""

    def test_writes_valid_json(self, tmp_path):
        path = str(tmp_path / "test.json")
        data = {"key": "value", "num": 42}
        write_json_atomic(path, data)
        with open(path) as f:
            result = json.load(f)
        assert result == data

    def test_no_temp_files_after_success(self, tmp_path):
        path = str(tmp_path / "test.json")
        write_json_atomic(path, {"a": 1})
        tmp_files = [f for f in os.listdir(tmp_path) if f.endswith(".tmp")]
        assert tmp_files == [], f"Orphaned temp files found: {tmp_files}"

    def test_creates_parent_directories(self, tmp_path):
        path = str(tmp_path / "deep" / "nested" / "dir" / "file.json")
        write_json_atomic(path, {"x": 1})
        assert os.path.exists(path)

    def test_overwrites_existing_file(self, tmp_path):
        path = str(tmp_path / "test.json")
        write_json_atomic(path, {"v": 1})
        write_json_atomic(path, {"v": 2})
        with open(path) as f:
            result = json.load(f)
        assert result == {"v": 2}

    def test_no_partial_file_on_simulated_crash(self, tmp_path):
        """Simulate a crash during json.dump — target file must not be corrupted."""
        path = str(tmp_path / "target.json")
        original_data = {"original": True}
        write_json_atomic(path, original_data)

        # Simulate crash: patch json.dump to raise mid-write
        with mock.patch("json.dump", side_effect=RuntimeError("simulated crash")):
            with pytest.raises((RuntimeError, KBWriteError)):
                write_json_atomic(path, {"corrupted": True})

        # Original file must be intact
        assert os.path.exists(path)
        with open(path) as f:
            result = json.load(f)
        assert result == original_data

    def test_no_temp_files_after_crash(self, tmp_path):
        """After a crash during write, no .tmp files should remain."""
        path = str(tmp_path / "test.json")
        with mock.patch("json.dump", side_effect=RuntimeError("crash")):
            with pytest.raises((RuntimeError, KBWriteError)):
                write_json_atomic(path, {"x": 1})
        tmp_files = [f for f in os.listdir(tmp_path) if f.endswith(".tmp")]
        assert tmp_files == [], f"Orphaned temp files after crash: {tmp_files}"

    def test_output_is_pretty_printed(self, tmp_path):
        """Output should be indented JSON (indent=2)."""
        path = str(tmp_path / "test.json")
        write_json_atomic(path, {"a": 1})
        content = open(path).read()
        assert "\n" in content  # indented output has newlines


# ---------------------------------------------------------------------------
# read_json() tests
# ---------------------------------------------------------------------------

class TestReadJson:
    def test_reads_valid_file(self, tmp_path):
        path = str(tmp_path / "data.json")
        write_json_atomic(path, {"hello": "world"})
        result = read_json(path)
        assert result == {"hello": "world"}

    def test_raises_not_found_for_missing_file(self, tmp_path):
        path = str(tmp_path / "nonexistent.json")
        with pytest.raises(KBNotFoundError, match="not found"):
            read_json(path)

    def test_raises_read_error_for_invalid_json(self, tmp_path):
        path = str(tmp_path / "bad.json")
        with open(path, "w") as f:
            f.write("{not valid json")
        with pytest.raises(KBReadError, match="Invalid JSON"):
            read_json(path)


# ---------------------------------------------------------------------------
# update_meta() tests
# ---------------------------------------------------------------------------

class TestUpdateMeta:
    """update_meta merges correctly without overwriting unrelated fields."""

    def test_merges_top_level_key(self, tmp_kb, mock_meta):
        write_json_atomic(kb_writer.META_PATH, mock_meta)
        update_meta({"generations": {**mock_meta["generations"], "current": 5}})
        result = read_json(kb_writer.META_PATH)
        assert result["generations"]["current"] == 5

    def test_does_not_overwrite_unrelated_fields(self, tmp_kb, mock_meta):
        write_json_atomic(kb_writer.META_PATH, mock_meta)
        original_config = mock_meta["config"].copy()
        update_meta({"generations": {**mock_meta["generations"], "current": 99}})
        result = read_json(kb_writer.META_PATH)
        assert result["config"] == original_config

    def test_updates_last_updated_at(self, tmp_kb, mock_meta):
        original_ts = "2000-01-01T00:00:00Z"
        mock_meta["system"]["last_updated_at"] = original_ts
        write_json_atomic(kb_writer.META_PATH, mock_meta)
        update_meta({"generations": mock_meta["generations"]})
        result = read_json(kb_writer.META_PATH)
        assert result["system"]["last_updated_at"] != original_ts

    def test_raises_if_meta_missing(self, tmp_kb):
        with pytest.raises(KBNotFoundError):
            update_meta({"generations": {}})

    def test_multiple_updates_accumulate(self, tmp_kb, mock_meta):
        write_json_atomic(kb_writer.META_PATH, mock_meta)
        update_meta({"generations": {**mock_meta["generations"], "current": 2}})
        update_meta({"generations": {**mock_meta["generations"], "current": 3}})
        result = read_json(kb_writer.META_PATH)
        assert result["generations"]["current"] == 3


# ---------------------------------------------------------------------------
# write_strategy_file() tests
# ---------------------------------------------------------------------------

class TestWriteStrategyFile:
    def test_writes_to_pending(self, tmp_kb, mock_strategy):
        path = write_strategy_file(mock_strategy, "pending")
        assert os.path.exists(path)
        result = read_json(path)
        assert result["summary"]["strategy_id"] == mock_strategy["summary"]["strategy_id"]

    def test_writes_to_results(self, tmp_kb, mock_strategy):
        path = write_strategy_file(mock_strategy, "results")
        assert kb_writer.RESULTS_DIR in path
        assert os.path.exists(path)

    def test_pending_path_is_in_pending_dir(self, tmp_kb, mock_strategy):
        path = write_strategy_file(mock_strategy, "pending")
        assert kb_writer.PENDING_DIR in path

    def test_invalid_stage_raises(self, tmp_kb, mock_strategy):
        with pytest.raises(ValueError, match="Invalid stage"):
            write_strategy_file(mock_strategy, "invalid_stage")

    def test_missing_strategy_id_raises(self, tmp_kb):
        bad = {"summary": {}}
        with pytest.raises(ValueError):
            write_strategy_file(bad, "pending")

    def test_returns_correct_path(self, tmp_kb, mock_strategy):
        sid = mock_strategy["summary"]["strategy_id"]
        path = write_strategy_file(mock_strategy, "pending")
        assert path.endswith(f"{sid}.json")


# ---------------------------------------------------------------------------
# move_to_results() tests
# ---------------------------------------------------------------------------

class TestMoveToResults:
    def test_moves_file_from_pending_to_results(self, tmp_kb, mock_strategy):
        write_strategy_file(mock_strategy, "pending")
        sid = mock_strategy["summary"]["strategy_id"]
        dst = move_to_results(sid)
        assert os.path.exists(dst)
        assert kb_writer.RESULTS_DIR in dst

    def test_removes_file_from_pending(self, tmp_kb, mock_strategy):
        write_strategy_file(mock_strategy, "pending")
        sid = mock_strategy["summary"]["strategy_id"]
        move_to_results(sid)
        src = os.path.join(kb_writer.PENDING_DIR, f"{sid}.json")
        assert not os.path.exists(src)

    def test_fails_cleanly_if_not_in_pending(self, tmp_kb):
        """move_to_results raises KBNotFoundError if file not in pending/."""
        with pytest.raises(KBNotFoundError, match="not found in pending"):
            move_to_results("gen-001-strat-99")

    def test_destination_content_matches_source(self, tmp_kb, mock_strategy):
        write_strategy_file(mock_strategy, "pending")
        sid = mock_strategy["summary"]["strategy_id"]
        dst = move_to_results(sid)
        result = read_json(dst)
        assert result["summary"]["strategy_id"] == sid


# ---------------------------------------------------------------------------
# archive_to_history() tests
# ---------------------------------------------------------------------------

class TestArchiveToHistory:
    def test_archives_from_results_to_history(self, tmp_kb, mock_strategy):
        write_strategy_file(mock_strategy, "results")
        sid = mock_strategy["summary"]["strategy_id"]
        dst = archive_to_history(sid, generation=1)
        assert os.path.exists(dst)
        assert "gen-001" in dst

    def test_removes_from_results(self, tmp_kb, mock_strategy):
        write_strategy_file(mock_strategy, "results")
        sid = mock_strategy["summary"]["strategy_id"]
        archive_to_history(sid, generation=1)
        src = os.path.join(kb_writer.RESULTS_DIR, f"{sid}.json")
        assert not os.path.exists(src)

    def test_fails_if_not_in_results(self, tmp_kb):
        with pytest.raises(KBNotFoundError, match="not found in results"):
            archive_to_history("gen-001-strat-99", generation=1)

    def test_generation_directory_zero_padded(self, tmp_kb, mock_strategy):
        write_strategy_file(mock_strategy, "results")
        sid = mock_strategy["summary"]["strategy_id"]
        dst = archive_to_history(sid, generation=5)
        assert "gen-005" in dst

    def test_history_content_preserved(self, tmp_kb, mock_strategy):
        write_strategy_file(mock_strategy, "results")
        sid = mock_strategy["summary"]["strategy_id"]
        dst = archive_to_history(sid, generation=2)
        result = read_json(dst)
        assert result["summary"]["strategy_id"] == sid


# ---------------------------------------------------------------------------
# initialize_kb_structure() tests
# ---------------------------------------------------------------------------

class TestInitializeKbStructure:
    """Creates all required directories and files; all are valid JSON."""

    EXPECTED_DIRS = [
        "kb",
        "kb/lessons",
        "kb/lessons/raw",
        "pending",
        "results",
        "history",
        "monitor",
    ]

    EXPECTED_FILES = [
        "kb/meta.json",
        "kb/patterns.json",
        "kb/graveyard.json",
        "kb/lineage.json",
        "kb/lessons/active.json",
        "kb/lessons/index.json",
    ]

    def test_creates_all_directories(self, tmp_kb):
        initialize_kb_structure()
        for d in self.EXPECTED_DIRS:
            full_path = str(tmp_kb / d)
            assert os.path.isdir(full_path), f"Missing directory: {d}"

    def test_creates_all_files(self, tmp_kb):
        initialize_kb_structure()
        for f in self.EXPECTED_FILES:
            full_path = str(tmp_kb / f)
            assert os.path.isfile(full_path), f"Missing file: {f}"

    def test_all_files_are_valid_json(self, tmp_kb):
        initialize_kb_structure()
        for f in self.EXPECTED_FILES:
            full_path = str(tmp_kb / f)
            try:
                with open(full_path) as fh:
                    data = json.load(fh)
                assert isinstance(data, dict), f"{f} is not a JSON object"
            except json.JSONDecodeError as exc:
                pytest.fail(f"{f} is invalid JSON: {exc}")

    def test_meta_json_has_required_top_level_keys(self, tmp_kb):
        initialize_kb_structure()
        meta = read_json(kb_writer.META_PATH)
        for key in ["system", "generations", "config", "fitness", "kb_health"]:
            assert key in meta, f"meta.json missing key: {key}"

    def test_meta_system_mode_is_research(self, tmp_kb):
        initialize_kb_structure()
        meta = read_json(kb_writer.META_PATH)
        assert meta["system"]["system_mode"] == "RESEARCH"

    def test_meta_execution_not_permitted(self, tmp_kb):
        initialize_kb_structure()
        meta = read_json(kb_writer.META_PATH)
        assert meta["system"]["execution_permitted"] is False
        assert meta["system"]["deploy_permitted"] is False

    def test_patterns_has_winning_losing_arrays(self, tmp_kb):
        initialize_kb_structure()
        patterns = read_json(kb_writer.PATTERNS_PATH)
        assert "winning" in patterns and isinstance(patterns["winning"], list)
        assert "losing" in patterns and isinstance(patterns["losing"], list)

    def test_graveyard_has_entries_array(self, tmp_kb):
        initialize_kb_structure()
        graveyard = read_json(kb_writer.GRAVEYARD_PATH)
        assert "entries" in graveyard
        assert isinstance(graveyard["entries"], list)

    def test_lineage_has_strategies_and_elite_registry(self, tmp_kb):
        initialize_kb_structure()
        lineage = read_json(kb_writer.LINEAGE_PATH)
        assert "strategies" in lineage
        assert "elite_registry" in lineage
        assert "global_top_10" in lineage["elite_registry"]

    def test_lessons_active_has_lessons_array(self, tmp_kb):
        initialize_kb_structure()
        active = read_json(kb_writer.LESSONS_ACTIVE_PATH)
        assert "lessons" in active
        assert isinstance(active["lessons"], list)

    def test_lessons_index_has_raw_files_array(self, tmp_kb):
        initialize_kb_structure()
        index = read_json(kb_writer.LESSONS_INDEX_PATH)
        assert "raw_files" in index
        assert isinstance(index["raw_files"], list)

    def test_idempotent_does_not_overwrite_existing_files(self, tmp_kb):
        """Calling initialize twice must not clobber existing data."""
        initialize_kb_structure()
        # Manually modify meta.json
        meta = read_json(kb_writer.META_PATH)
        meta["generations"]["current"] = 42
        write_json_atomic(kb_writer.META_PATH, meta)
        # Re-initialize
        initialize_kb_structure()
        meta_after = read_json(kb_writer.META_PATH)
        assert meta_after["generations"]["current"] == 42

    def test_no_temp_files_left_after_init(self, tmp_kb):
        initialize_kb_structure()
        for root, dirs, files in os.walk(str(tmp_kb)):
            tmp_files = [f for f in files if f.endswith(".tmp")]
            assert tmp_files == [], f"Orphaned .tmp files in {root}: {tmp_files}"


# ---------------------------------------------------------------------------
# update_kb_health() tests
# ---------------------------------------------------------------------------

class TestUpdateKbHealth:
    def test_updates_kb_health_block(self, tmp_kb, mock_meta):
        write_json_atomic(kb_writer.META_PATH, mock_meta)
        updated_meta = dict(mock_meta)
        updated_meta["kb_health"] = {
            **mock_meta["kb_health"],
            "graveyard_count": 7,
        }
        update_kb_health(updated_meta)
        result = read_json(kb_writer.META_PATH)
        assert result["kb_health"]["graveyard_count"] == 7

    def test_does_not_overwrite_other_blocks(self, tmp_kb, mock_meta):
        write_json_atomic(kb_writer.META_PATH, mock_meta)
        updated_meta = dict(mock_meta)
        updated_meta["kb_health"] = {**mock_meta["kb_health"], "graveyard_count": 3}
        original_config = mock_meta["config"].copy()
        update_kb_health(updated_meta)
        result = read_json(kb_writer.META_PATH)
        assert result["config"] == original_config

    def test_updates_last_updated_at(self, tmp_kb, mock_meta):
        mock_meta["system"]["last_updated_at"] = "2000-01-01T00:00:00Z"
        write_json_atomic(kb_writer.META_PATH, mock_meta)
        update_kb_health(mock_meta)
        result = read_json(kb_writer.META_PATH)
        assert result["system"]["last_updated_at"] != "2000-01-01T00:00:00Z"
