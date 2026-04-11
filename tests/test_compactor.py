"""
test_compactor.py — Full test suite for compactor.py.

Covers all required SKILL.md tests plus edge cases.
Uses tmp_path for all file I/O — never touches real KB.
"""

import copy
import json
import os
import sys
import pytest

# ---------------------------------------------------------------------------
# Path setup
# ---------------------------------------------------------------------------
WORKSPACE = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SRC_DIR   = os.path.join(os.path.dirname(__file__), "..", "src")
MOCK_DIR  = os.path.join(WORKSPACE, "skills", "learning-agent-builder", "mock-data")
sys.path.insert(0, SRC_DIR)

import kb_writer
import compactor as cp_mod
from compactor import (  # noqa: E402
    CATEGORY_CAPS,
    CONFIRM_DELTA,
    CONTRADICT_DELTA,
    RETIRE_THRESHOLD,
    PROMOTE_THRESHOLD,
    PROMOTE_MIN_REINFORCED,
    TOTAL_LESSON_CAP,
    _add_new_lessons,
    _apply_decay,
    _merge_lessons,
    _promote_to_hard_rule,
    _retire_lesson,
    _update_confidence,
    run_compaction,
)


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

@pytest.fixture(autouse=True)
def isolated_kb(tmp_path, monkeypatch):
    """Redirect all KB paths to tmp_path."""
    kb_root      = str(tmp_path / "kb")
    lessons_dir  = str(tmp_path / "kb" / "lessons")
    raw_dir      = str(tmp_path / "kb" / "lessons" / "raw")
    os.makedirs(raw_dir, exist_ok=True)

    active_path  = str(tmp_path / "kb" / "lessons" / "active.json")
    index_path   = str(tmp_path / "kb" / "lessons" / "index.json")
    retired_path = str(tmp_path / "kb" / "lessons" / "retired.json")

    monkeypatch.setattr(kb_writer, "KB_ROOT",            kb_root)
    monkeypatch.setattr(kb_writer, "LESSONS_ACTIVE_PATH", active_path)
    monkeypatch.setattr(kb_writer, "LESSONS_INDEX_PATH",  index_path)
    monkeypatch.setattr(kb_writer, "LESSONS_RAW_DIR",     raw_dir)
    monkeypatch.setattr(kb_writer, "META_PATH",     str(tmp_path / "kb" / "meta.json"))
    monkeypatch.setattr(kb_writer, "PENDING_DIR",   str(tmp_path / "pending"))
    monkeypatch.setattr(kb_writer, "RESULTS_DIR",   str(tmp_path / "results"))
    monkeypatch.setattr(kb_writer, "HISTORY_DIR",   str(tmp_path / "history"))
    monkeypatch.setattr(cp_mod, "LESSONS_ACTIVE_PATH", active_path)
    monkeypatch.setattr(cp_mod, "LESSONS_INDEX_PATH",  index_path)
    monkeypatch.setattr(cp_mod, "LESSONS_RAW_DIR",     raw_dir)
    monkeypatch.setattr(cp_mod, "RETIRED_LESSONS_PATH", retired_path)

    return tmp_path


def load_mock(filename: str) -> dict:
    with open(os.path.join(MOCK_DIR, filename)) as f:
        return json.load(f)


def make_lesson(
    lid: str = "lesson-001",
    category: str = "indicator",
    confidence: float = 0.6,
    times_reinforced: int = 1,
    times_contradicted: int = 0,
    decay: bool = True,
    last_seen_generation: int = 3,
    first_seen_generation: int = 1,
    archetypes: list = None,
    apply_to_next: bool = True,
    apply_to_active: bool = True,
) -> dict:
    return {
        "id": lid,
        "category": category,
        "subcategory": "test",
        "confidence": confidence,
        "decay": decay,
        "times_reinforced": times_reinforced,
        "times_contradicted": times_contradicted,
        "first_seen_generation": first_seen_generation,
        "last_seen_generation": last_seen_generation,
        "created_at": "2026-03-22T00:00:00Z",
        "last_updated_at": "2026-03-22T00:00:00Z",
        "source": "generation",
        "lesson": f"Test lesson {lid}",
        "archetypes": archetypes or ["ALL"],
        "supporting_evidence": [f"Evidence for {lid}"],
        "apply_to_next": apply_to_next,
        "apply_to_active": apply_to_active,
        "parameter_data": None,
        "regime_context": None,
        "merge_candidate_ids": [],
    }


def make_active(lessons: list = None) -> dict:
    lessons = lessons or []
    cat_counts = {k: 0 for k in CATEGORY_CAPS}
    for l in lessons:
        cat = l.get("category", "")
        if cat in cat_counts:
            cat_counts[cat] += 1
    return {
        "version": "1.0",
        "last_updated": "2026-03-22T00:00:00Z",
        "last_compacted_generation": 0,
        "next_compaction_generation": 3,
        "total_lessons": len(lessons),
        "category_counts": cat_counts,
        "token_config": {
            "token_budget": 10000,
            "avg_tokens_per_lesson": 175,
            "estimated_max_lessons": 57,
            "hard_rules_reserved_tokens": 1500,
            "anti_patterns_reserved_tokens": 1200,
            "flexible_pool_tokens": 7300,
        },
        "lessons": lessons,
    }


def make_index(raw_files: list = None) -> dict:
    return {
        "version": "1.0",
        "last_updated": "2026-03-22T00:00:00Z",
        "summary": {
            "total_raw_files": len(raw_files or []),
            "total_raw_lessons": 0,
            "total_active_lessons": 0,
            "last_compacted_generation": 0,
            "next_compaction_generation": 3,
            "compaction_count": 0,
        },
        "raw_files": raw_files or [],
        "active_lesson_coverage": {k: 0 for k in CATEGORY_CAPS},
        "compaction_history": [],
    }


def make_raw_file(generation: int, lessons: list, confirmed_ids: list = None,
                   contradicted_ids: list = None, retire_suggestions: list = None) -> dict:
    return {
        "generation": generation,
        "created_at": "2026-03-22T00:00:00Z",
        "strategies_analyzed": 2,
        "strategy_ids_analyzed": ["gen-001-strat-01"],
        "claude_model": "claude-sonnet-4-5",
        "prompt_tokens": 1000,
        "completion_tokens": 500,
        "lessons_extracted": len(lessons),
        "lessons": lessons,
        "compaction_notes": {
            "confirmed_lesson_ids": confirmed_ids or [],
            "contradicted_lesson_ids": contradicted_ids or [],
            "merge_suggestions": [],
            "retire_suggestions": retire_suggestions or [],
            "promote_suggestions": [],
        },
    }


def write_active(active: dict, monkeypatch_ref=None):
    kb_writer.write_json_atomic(cp_mod.LESSONS_ACTIVE_PATH, active)


def write_index(index: dict):
    kb_writer.write_json_atomic(cp_mod.LESSONS_INDEX_PATH, index)


def write_raw_file(generation: int, raw_data: dict):
    path = os.path.join(cp_mod.LESSONS_RAW_DIR, f"gen-{generation:03d}-lessons.json")
    kb_writer.write_json_atomic(path, raw_data)


def read_active() -> dict:
    return kb_writer.read_json(cp_mod.LESSONS_ACTIVE_PATH)


def read_index() -> dict:
    return kb_writer.read_json(cp_mod.LESSONS_INDEX_PATH)


def make_meta() -> dict:
    return load_mock("mock-meta.json")


# ---------------------------------------------------------------------------
# _update_confidence() tests
# ---------------------------------------------------------------------------

class TestUpdateConfidence:
    """Confidence update +0.10 on confirmation, -0.20 on contradiction, clamped 0.0-1.0."""

    def test_confirmation_adds_010(self):
        lesson = make_lesson(confidence=0.6)
        updated = _update_confidence(lesson, CONFIRM_DELTA)
        assert updated["confidence"] == pytest.approx(0.7)

    def test_contradiction_subtracts_020(self):
        lesson = make_lesson(confidence=0.6)
        updated = _update_confidence(lesson, CONTRADICT_DELTA)
        assert updated["confidence"] == pytest.approx(0.4)

    def test_clamped_at_1_0(self):
        lesson = make_lesson(confidence=0.95)
        updated = _update_confidence(lesson, CONFIRM_DELTA)
        assert updated["confidence"] == pytest.approx(1.0)

    def test_clamped_at_0_0(self):
        lesson = make_lesson(confidence=0.1)
        updated = _update_confidence(lesson, CONTRADICT_DELTA)
        assert updated["confidence"] == pytest.approx(0.0)

    def test_does_not_mutate_original(self):
        lesson = make_lesson(confidence=0.6)
        _update_confidence(lesson, CONFIRM_DELTA)
        assert lesson["confidence"] == 0.6

    def test_increments_times_reinforced_on_positive_delta(self):
        lesson = make_lesson(confidence=0.6, times_reinforced=2)
        updated = _update_confidence(lesson, CONFIRM_DELTA)
        assert updated["times_reinforced"] == 3

    def test_increments_times_contradicted_on_negative_delta(self):
        lesson = make_lesson(confidence=0.6, times_contradicted=1)
        updated = _update_confidence(lesson, CONTRADICT_DELTA)
        assert updated["times_contradicted"] == 2

    def test_retire_flag_set_below_threshold(self):
        lesson = make_lesson(confidence=0.25)
        updated = _update_confidence(lesson, CONTRADICT_DELTA)
        assert updated["confidence"] < RETIRE_THRESHOLD
        assert updated.get("_retire") is True

    def test_no_retire_flag_above_threshold(self):
        lesson = make_lesson(confidence=0.6)
        updated = _update_confidence(lesson, CONTRADICT_DELTA)
        assert not updated.get("_retire", False)

    def test_promote_flag_set_when_max_confidence_and_reinforced(self):
        """Promoted when confidence=1.0 AND times_reinforced >= 4."""
        lesson = make_lesson(confidence=0.95, times_reinforced=4, category="indicator")
        updated = _update_confidence(lesson, CONFIRM_DELTA)
        assert updated["confidence"] == pytest.approx(1.0)
        assert updated.get("_promote") is True

    def test_not_promoted_if_reinforced_below_4(self):
        """NOT promoted if reinforced < 4 even at confidence 1.0."""
        lesson = make_lesson(confidence=0.95, times_reinforced=3, category="indicator")
        updated = _update_confidence(lesson, CONFIRM_DELTA)
        assert updated["confidence"] == pytest.approx(1.0)
        assert not updated.get("_promote", False)

    def test_not_promoted_if_already_hard_rule(self):
        lesson = make_lesson(confidence=0.95, times_reinforced=4, category="hard_rule")
        updated = _update_confidence(lesson, CONFIRM_DELTA)
        assert not updated.get("_promote", False)


# ---------------------------------------------------------------------------
# _merge_lessons() tests
# ---------------------------------------------------------------------------

class TestMergeLessons:
    """Merge produces correct confidence; combines supporting_evidence (deduplicated)."""

    def test_confidence_is_max_plus_005(self):
        a = make_lesson("lesson-001", confidence=0.7)
        b = make_lesson("lesson-002", confidence=0.6)
        merged = _merge_lessons(a, b, "similar content")
        assert merged["confidence"] == pytest.approx(0.75)

    def test_confidence_clamped_at_1_0(self):
        a = make_lesson("lesson-001", confidence=0.98)
        b = make_lesson("lesson-002", confidence=0.97)
        merged = _merge_lessons(a, b, "both high")
        assert merged["confidence"] == pytest.approx(1.0)

    def test_higher_confidence_lesson_text_kept(self):
        a = make_lesson("lesson-001", confidence=0.8)
        a["lesson"] = "High confidence text"
        b = make_lesson("lesson-002", confidence=0.5)
        b["lesson"] = "Low confidence text"
        merged = _merge_lessons(a, b, "test")
        assert merged["lesson"] == "High confidence text"

    def test_archetypes_union(self):
        a = make_lesson("lesson-001", archetypes=["SHARPE_HUNTER"])
        b = make_lesson("lesson-002", archetypes=["RETURN_CHASER"])
        merged = _merge_lessons(a, b, "test")
        assert "SHARPE_HUNTER" in merged["archetypes"]
        assert "RETURN_CHASER" in merged["archetypes"]

    def test_supporting_evidence_deduplicated(self):
        a = make_lesson("lesson-001")
        a["supporting_evidence"] = ["evidence A", "shared evidence"]
        b = make_lesson("lesson-002")
        b["supporting_evidence"] = ["shared evidence", "evidence B"]
        merged = _merge_lessons(a, b, "test")
        ev = merged["supporting_evidence"]
        assert "shared evidence" in ev
        assert ev.count("shared evidence") == 1  # deduplicated
        assert "evidence A" in ev
        assert "evidence B" in ev

    def test_times_reinforced_is_sum(self):
        a = make_lesson("lesson-001", times_reinforced=3)
        b = make_lesson("lesson-002", times_reinforced=2)
        merged = _merge_lessons(a, b, "test")
        assert merged["times_reinforced"] == 5

    def test_no_id_in_merged(self):
        """Merged lesson has no id — caller assigns new one."""
        a = make_lesson("lesson-001")
        b = make_lesson("lesson-002")
        merged = _merge_lessons(a, b, "test")
        assert "id" not in merged

    def test_does_not_mutate_inputs(self):
        a = make_lesson("lesson-001", confidence=0.7)
        b = make_lesson("lesson-002", confidence=0.6)
        orig_conf_a = a["confidence"]
        _merge_lessons(a, b, "test")
        assert a["confidence"] == orig_conf_a


# ---------------------------------------------------------------------------
# _promote_to_hard_rule() tests
# ---------------------------------------------------------------------------

class TestPromoteToHardRule:
    def test_sets_category_to_hard_rule(self):
        lesson = make_lesson(category="indicator")
        promoted = _promote_to_hard_rule(lesson)
        assert promoted["category"] == "hard_rule"

    def test_sets_decay_false(self):
        lesson = make_lesson(decay=True)
        promoted = _promote_to_hard_rule(lesson)
        assert promoted["decay"] is False

    def test_clears_promote_flag(self):
        lesson = make_lesson()
        lesson["_promote"] = True
        promoted = _promote_to_hard_rule(lesson)
        assert "_promote" not in promoted

    def test_does_not_mutate_original(self):
        lesson = make_lesson(category="indicator")
        _promote_to_hard_rule(lesson)
        assert lesson["category"] == "indicator"


# ---------------------------------------------------------------------------
# _retire_lesson() tests
# ---------------------------------------------------------------------------

class TestRetireLesson:
    def test_removes_lesson_from_active(self):
        active = make_active([make_lesson("lesson-001"), make_lesson("lesson-002")])
        updated, _ = _retire_lesson("lesson-001", active)
        ids = [l["id"] for l in updated["lessons"]]
        assert "lesson-001" not in ids
        assert "lesson-002" in ids

    def test_returns_retired_lesson(self):
        active = make_active([make_lesson("lesson-001")])
        _, retired = _retire_lesson("lesson-001", active)
        assert retired is not None
        assert retired["id"] == "lesson-001"

    def test_missing_id_returns_none(self):
        active = make_active([make_lesson("lesson-001")])
        updated, retired = _retire_lesson("lesson-999", active)
        assert retired is None
        assert len(updated["lessons"]) == 1  # unchanged

    def test_does_not_mutate_original(self):
        lessons = [make_lesson("lesson-001"), make_lesson("lesson-002")]
        active = make_active(lessons)
        _retire_lesson("lesson-001", active)
        assert len(active["lessons"]) == 2  # original untouched


# ---------------------------------------------------------------------------
# _add_new_lessons() tests
# ---------------------------------------------------------------------------

class TestAddNewLessons:
    """New lessons added respects category caps and total cap of 30."""

    def test_adds_basic_lesson(self):
        active = make_active([])
        new_lesson = make_lesson("tmp-001", category="indicator", confidence=0.6)
        new_lesson.pop("id")
        updated = _add_new_lessons(active, [new_lesson], make_meta())
        assert len(updated["lessons"]) == 1
        assert updated["lessons"][0]["id"] == "lesson-001"

    def test_assigns_sequential_ids(self):
        active = make_active([make_lesson("lesson-003")])
        raw = [make_lesson("tmp", category="indicator") for _ in range(3)]
        for l in raw:
            l.pop("id", None)
        updated = _add_new_lessons(active, raw, make_meta())
        ids = [l["id"] for l in updated["lessons"]]
        assert "lesson-004" in ids
        assert "lesson-005" in ids
        assert "lesson-006" in ids

    def test_skips_apply_to_active_false(self):
        active = make_active([])
        skip_lesson = make_lesson("tmp-001", category="indicator", apply_to_active=False)
        updated = _add_new_lessons(active, [skip_lesson], make_meta())
        assert len(updated["lessons"]) == 0

    def test_respects_category_cap(self):
        """Category cap enforced: indicator cap = 8."""
        existing = [make_lesson(f"lesson-{i:03d}", category="indicator") for i in range(1, 9)]
        active = make_active(existing)
        overflow = [make_lesson("tmp", category="indicator") for _ in range(3)]
        for l in overflow:
            l.pop("id", None)
        updated = _add_new_lessons(active, overflow, make_meta())
        indicator_count = sum(1 for l in updated["lessons"] if l["category"] == "indicator")
        assert indicator_count == CATEGORY_CAPS["indicator"]  # still 8, no overflow

    def test_respects_total_cap_of_30(self):
        """Total cap of 30 lessons enforced."""
        existing = []
        for cat, cap in CATEGORY_CAPS.items():
            for i in range(cap):
                existing.append(make_lesson(f"lesson-{cat}-{i:02d}", category=cat))
        # Trim to exactly 30 if we built more
        existing = existing[:30]
        active = make_active(existing)

        overflow = [make_lesson("tmp", category="indicator") for _ in range(5)]
        for l in overflow:
            l.pop("id", None)
        updated = _add_new_lessons(active, overflow, make_meta())
        assert len(updated["lessons"]) <= TOTAL_LESSON_CAP

    def test_higher_confidence_lessons_prioritized(self):
        """When cap would be exceeded, higher-confidence lessons are kept."""
        active = make_active([])
        # 9 indicator lessons (cap=8), varying confidence
        raw = []
        for i in range(9):
            l = make_lesson(f"tmp-{i}", category="indicator", confidence=float(i+1)/10)
            l.pop("id", None)
            raw.append(l)

        updated = _add_new_lessons(active, raw, make_meta())
        indicator = [l for l in updated["lessons"] if l["category"] == "indicator"]
        assert len(indicator) == CATEGORY_CAPS["indicator"]
        # All kept lessons should have higher confidence than any dropped one
        kept_confs = [l["confidence"] for l in indicator]
        assert min(kept_confs) > 0.1  # The lowest-confidence (0.1) was dropped


# ---------------------------------------------------------------------------
# _apply_decay() tests
# ---------------------------------------------------------------------------

class TestApplyDecay:
    """Decay applies only to decay=true lessons; skips lessons seen within 3 gens."""

    def test_no_decay_within_grace_period(self):
        """Lesson seen 3 gens ago → no decay."""
        lesson = make_lesson(confidence=0.7, decay=True, last_seen_generation=7)
        active = make_active([lesson])
        updated = _apply_decay(active, generation=10)
        kept = {l["id"]: l for l in updated["lessons"]}
        assert kept["lesson-001"]["confidence"] == pytest.approx(0.7)

    def test_decay_applied_beyond_grace_period(self):
        """Lesson last seen 5 gens ago → decay applied."""
        lesson = make_lesson(confidence=0.7, decay=True, last_seen_generation=5)
        active = make_active([lesson])
        updated = _apply_decay(active, generation=10)  # 5 gens since seen, 2 beyond grace
        kept = {l["id"]: l for l in updated["lessons"]}
        assert kept["lesson-001"]["confidence"] < 0.7

    def test_no_decay_for_decay_false(self):
        """Lessons with decay=False are never decayed."""
        lesson = make_lesson(confidence=0.7, decay=False, last_seen_generation=1)
        active = make_active([lesson])
        updated = _apply_decay(active, generation=20)
        kept = {l["id"]: l for l in updated["lessons"]}
        assert kept["lesson-001"]["confidence"] == pytest.approx(0.7)

    def test_decay_count_returned(self):
        """_decay_count annotation tells caller how many were decayed."""
        l1 = make_lesson("lesson-001", confidence=0.7, decay=True, last_seen_generation=1)
        l2 = make_lesson("lesson-002", confidence=0.7, decay=False, last_seen_generation=1)
        active = make_active([l1, l2])
        updated = _apply_decay(active, generation=20)
        assert updated.get("_decay_count") == 1  # only l1 was decayed

    def test_no_decay_when_last_seen_is_none(self):
        """last_seen_generation=None → skip decay."""
        lesson = make_lesson(confidence=0.7, decay=True)
        lesson["last_seen_generation"] = None
        active = make_active([lesson])
        updated = _apply_decay(active, generation=20)
        kept = {l["id"]: l for l in updated["lessons"]}
        assert kept["lesson-001"]["confidence"] == pytest.approx(0.7)


# ---------------------------------------------------------------------------
# run_compaction() integration tests
# ---------------------------------------------------------------------------

class TestRunCompaction:
    """Integration tests for run_compaction()."""

    def _setup_basic_run(self, generation: int = 3):
        """Write minimal active.json, index.json, and one raw file."""
        active = make_active([make_lesson("lesson-001", confidence=0.6)])
        write_active(active)

        raw_lesson = make_lesson("tmp-001", category="indicator", confidence=0.7)
        raw_lesson.pop("id", None)
        raw_lesson["apply_to_active"] = True
        raw_file = make_raw_file(generation, [raw_lesson])
        write_raw_file(generation, raw_file)

        index = make_index([{
            "filename": f"gen-{generation:03d}-lessons.json",
            "generation": generation,
            "lessons_count": 1,
            "created_at": "2026-03-22T00:00:00Z",
            "fully_processed": False,
            "compacted_into_generation": None,
        }])
        write_index(index)

    def test_returns_compaction_summary(self):
        self._setup_basic_run(3)
        summary = run_compaction(3, make_meta())
        assert isinstance(summary, dict)
        for key in ["generation", "ran_at", "lessons_before", "lessons_after",
                    "new_lessons_added", "lessons_merged", "lessons_retired",
                    "lessons_promoted_to_hard_rule", "confidence_updates",
                    "raw_files_processed", "errors"]:
            assert key in summary, f"Missing key: {key}"

    def test_compaction_summary_correct_counts(self):
        self._setup_basic_run(3)
        summary = run_compaction(3, make_meta())
        assert summary["lessons_before"] == 1
        assert summary["lessons_after"] == 2
        assert summary["new_lessons_added"] == 1
        assert summary["errors"] == []

    def test_fully_processed_flag_set_in_index(self):
        """fully_processed flag set to true in index.json after run."""
        self._setup_basic_run(3)
        run_compaction(3, make_meta())
        idx = read_index()
        for entry in idx["raw_files"]:
            if entry["generation"] == 3:
                assert entry["fully_processed"] is True
                assert entry["compacted_into_generation"] == 3

    def test_active_json_written(self):
        self._setup_basic_run(3)
        run_compaction(3, make_meta())
        active = read_active()
        assert active["total_lessons"] == 2
        assert active["last_compacted_generation"] == 3
        assert active["next_compaction_generation"] == 6

    def test_confidence_reinforced_on_confirmation(self):
        """Confidence update +0.10 on confirmation."""
        active = make_active([make_lesson("lesson-001", confidence=0.6)])
        write_active(active)

        raw_file = make_raw_file(3, [], confirmed_ids=["lesson-001"])
        write_raw_file(3, raw_file)
        index = make_index([{
            "filename": "gen-003-lessons.json", "generation": 3,
            "lessons_count": 0, "created_at": "2026-03-22T00:00:00Z",
            "fully_processed": False, "compacted_into_generation": None,
        }])
        write_index(index)

        run_compaction(3, make_meta())
        result = read_active()
        lesson = next(l for l in result["lessons"] if l["id"] == "lesson-001")
        assert lesson["confidence"] == pytest.approx(0.7)

    def test_confidence_reduced_on_contradiction(self):
        """Confidence update -0.20 on contradiction."""
        active = make_active([make_lesson("lesson-001", confidence=0.6)])
        write_active(active)

        raw_file = make_raw_file(3, [], contradicted_ids=["lesson-001"])
        write_raw_file(3, raw_file)
        index = make_index([{
            "filename": "gen-003-lessons.json", "generation": 3,
            "lessons_count": 0, "created_at": "2026-03-22T00:00:00Z",
            "fully_processed": False, "compacted_into_generation": None,
        }])
        write_index(index)

        run_compaction(3, make_meta())
        result = read_active()
        lesson = next(l for l in result["lessons"] if l["id"] == "lesson-001")
        assert lesson["confidence"] == pytest.approx(0.4)

    def test_lesson_retired_when_confidence_drops_below_threshold(self):
        """Lesson retired when confidence drops below 0.20."""
        active = make_active([make_lesson("lesson-001", confidence=0.25)])
        write_active(active)

        raw_file = make_raw_file(3, [], contradicted_ids=["lesson-001"])
        write_raw_file(3, raw_file)
        index = make_index([{
            "filename": "gen-003-lessons.json", "generation": 3,
            "lessons_count": 0, "created_at": "2026-03-22T00:00:00Z",
            "fully_processed": False, "compacted_into_generation": None,
        }])
        write_index(index)

        summary = run_compaction(3, make_meta())
        assert summary["lessons_retired"] == 1
        result = read_active()
        ids = [l["id"] for l in result["lessons"]]
        assert "lesson-001" not in ids

    def test_lesson_promoted_when_criteria_met(self):
        """Lesson promoted to hard_rule when confidence=1.0 AND reinforced>=4."""
        l = make_lesson("lesson-001", category="indicator",
                        confidence=0.95, times_reinforced=4)
        active = make_active([l])
        write_active(active)

        raw_file = make_raw_file(3, [], confirmed_ids=["lesson-001"])
        write_raw_file(3, raw_file)
        index = make_index([{
            "filename": "gen-003-lessons.json", "generation": 3,
            "lessons_count": 0, "created_at": "2026-03-22T00:00:00Z",
            "fully_processed": False, "compacted_into_generation": None,
        }])
        write_index(index)

        summary = run_compaction(3, make_meta())
        assert summary["lessons_promoted_to_hard_rule"] == 1
        result = read_active()
        lesson = next(l for l in result["lessons"] if l["id"] == "lesson-001")
        assert lesson["category"] == "hard_rule"
        assert lesson["decay"] is False

    def test_lesson_not_promoted_if_reinforced_below_4(self):
        """NOT promoted if reinforced < 4 even at confidence 1.0."""
        l = make_lesson("lesson-001", category="indicator",
                        confidence=0.95, times_reinforced=2)
        active = make_active([l])
        write_active(active)

        raw_file = make_raw_file(3, [], confirmed_ids=["lesson-001"])
        write_raw_file(3, raw_file)
        index = make_index([{
            "filename": "gen-003-lessons.json", "generation": 3,
            "lessons_count": 0, "created_at": "2026-03-22T00:00:00Z",
            "fully_processed": False, "compacted_into_generation": None,
        }])
        write_index(index)

        summary = run_compaction(3, make_meta())
        assert summary["lessons_promoted_to_hard_rule"] == 0
        result = read_active()
        lesson = next(l for l in result["lessons"] if l["id"] == "lesson-001")
        assert lesson["category"] == "indicator"  # not promoted

    def test_apply_to_active_false_skipped(self):
        """apply_to_active=false lessons are skipped."""
        active = make_active([])
        write_active(active)

        skip_lesson = make_lesson("tmp", category="indicator")
        skip_lesson.pop("id", None)
        skip_lesson["apply_to_active"] = False
        raw_file = make_raw_file(3, [skip_lesson])
        write_raw_file(3, raw_file)
        index = make_index([{
            "filename": "gen-003-lessons.json", "generation": 3,
            "lessons_count": 1, "created_at": "2026-03-22T00:00:00Z",
            "fully_processed": False, "compacted_into_generation": None,
        }])
        write_index(index)

        summary = run_compaction(3, make_meta())
        assert summary["new_lessons_added"] == 0

    def test_raw_files_not_modified(self):
        """Raw files must never be modified — read-only."""
        self._setup_basic_run(3)
        raw_path = os.path.join(cp_mod.LESSONS_RAW_DIR, "gen-003-lessons.json")
        stat_before = os.stat(raw_path)
        run_compaction(3, make_meta())
        stat_after = os.stat(raw_path)
        # File should not have been written to (mtime unchanged)
        assert stat_before.st_mtime == stat_after.st_mtime

    def test_no_temp_files_after_run(self):
        """All writes use atomic pattern — no .tmp files left."""
        self._setup_basic_run(3)
        run_compaction(3, make_meta())
        kb_dir = os.path.dirname(cp_mod.LESSONS_ACTIVE_PATH)
        for root, dirs, files in os.walk(kb_dir):
            tmp_files = [f for f in files if f.endswith(".tmp")]
            assert tmp_files == [], f"Orphaned .tmp files in {root}: {tmp_files}"

    def test_empty_active_no_error(self):
        """Runs without error when active.json has no lessons."""
        write_active(make_active([]))
        write_index(make_index([]))
        summary = run_compaction(3, make_meta())
        assert summary["errors"] == []
        assert summary["lessons_before"] == 0

    def test_missing_active_json_creates_it(self):
        """run_compaction creates active.json if it doesn't exist."""
        write_index(make_index([]))
        # Don't write active.json
        summary = run_compaction(3, make_meta())
        assert os.path.exists(cp_mod.LESSONS_ACTIVE_PATH)

    def test_skip_already_processed_files(self):
        """Files with fully_processed=True are not re-processed."""
        active = make_active([make_lesson("lesson-001")])
        write_active(active)

        raw_lesson = make_lesson("tmp", category="indicator")
        raw_lesson.pop("id", None)
        raw_file = make_raw_file(3, [raw_lesson])
        write_raw_file(3, raw_file)
        index = make_index([{
            "filename": "gen-003-lessons.json", "generation": 3,
            "lessons_count": 1, "created_at": "2026-03-22T00:00:00Z",
            "fully_processed": True,  # already processed
            "compacted_into_generation": 3,
        }])
        write_index(index)

        summary = run_compaction(6, make_meta())
        assert summary["new_lessons_added"] == 0
        assert summary["raw_files_processed"] == []

    def test_nonexistent_lesson_id_in_hints_skipped_silently(self):
        """If a lesson ID in compaction_hints doesn't exist → skip silently."""
        active = make_active([make_lesson("lesson-001", confidence=0.6)])
        write_active(active)

        raw_file = make_raw_file(3, [], confirmed_ids=["lesson-999"])  # doesn't exist
        write_raw_file(3, raw_file)
        index = make_index([{
            "filename": "gen-003-lessons.json", "generation": 3,
            "lessons_count": 0, "created_at": "2026-03-22T00:00:00Z",
            "fully_processed": False, "compacted_into_generation": None,
        }])
        write_index(index)

        # Should not raise
        summary = run_compaction(3, make_meta())
        assert summary["errors"] == []
        result = read_active()
        lesson = next(l for l in result["lessons"] if l["id"] == "lesson-001")
        assert lesson["confidence"] == pytest.approx(0.6)  # unchanged

    def test_compaction_history_appended_to_index(self):
        self._setup_basic_run(3)
        run_compaction(3, make_meta())
        idx = read_index()
        assert len(idx["compaction_history"]) == 1
        hist = idx["compaction_history"][0]
        assert hist["generation"] == 3
        assert "ran_at" in hist
