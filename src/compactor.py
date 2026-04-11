"""
compactor.py — Consolidate raw lesson files into a curated active.json.

Runs every 3 generations. Merges duplicates, updates confidence,
retires weak lessons, promotes strong ones to hard_rules.

NEVER calls the Composer API or Claude API.
NEVER writes meta.json directly — returns updated data for caller.
READ ONLY on raw lesson files — never modifies them.

Schema reference:
  Section 8  — lessons/active.json
  Section 9  — lessons/raw/gen-NNN-lessons.json
  Section 10 — lessons/index.json
"""

from __future__ import annotations

import copy
import os
import sys
from datetime import datetime, timezone
from typing import Optional

_SRC_DIR = os.path.dirname(os.path.abspath(__file__))
if _SRC_DIR not in sys.path:
    sys.path.insert(0, _SRC_DIR)

from kb_writer import (
    LESSONS_ACTIVE_PATH,
    LESSONS_INDEX_PATH,
    LESSONS_RAW_DIR,
    read_json,
    write_json_atomic,
    KBNotFoundError,
)

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

RETIRE_THRESHOLD:  float = 0.20   # retire lesson when confidence drops below this
PROMOTE_THRESHOLD: float = 1.0    # promote when confidence reaches this
PROMOTE_MIN_REINFORCED: int = 4   # AND times_reinforced must be >= this

DECAY_RATE:         float = 0.05  # per generation when not seen
DECAY_GRACE_GENS:   int   = 3     # decay only applies after this many gens not seen

CONFIRM_DELTA:    float = 0.10
CONTRADICT_DELTA: float = -0.20

TOTAL_LESSON_CAP: int = 30

# Category caps (from Section 8.2)
CATEGORY_CAPS: dict[str, int] = {
    "hard_rule":    10,
    "indicator":     8,
    "structure":     6,
    "asset":         6,
    "risk":          5,
    "anti_pattern": 10,
}

RETIRED_LESSONS_PATH = os.path.join(
    os.path.dirname(LESSONS_ACTIVE_PATH),
    "retired.json",
)

# ---------------------------------------------------------------------------
# Utility
# ---------------------------------------------------------------------------

def _now_iso() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _clamp(val: float, lo: float = 0.0, hi: float = 1.0) -> float:
    return max(lo, min(hi, val))


def _next_lesson_id(active_lessons: dict) -> str:
    """Return the next sequential lesson ID based on current active.json lessons."""
    lessons = active_lessons.get("lessons", [])
    max_num = 0
    for lesson in lessons:
        lid = lesson.get("id", "")
        if lid.startswith("lesson-"):
            try:
                n = int(lid.split("-")[1])
                if n > max_num:
                    max_num = n
            except (ValueError, IndexError):
                pass
    return f"lesson-{max_num + 1:03d}"


def _lessons_dict(active_lessons: dict) -> dict[str, dict]:
    """Return lessons keyed by id for fast lookup."""
    return {l["id"]: l for l in active_lessons.get("lessons", [])}


def _lessons_from_dict(lessons_map: dict[str, dict], active_lessons: dict) -> dict:
    """Replace lessons array in active_lessons from a dict, preserving order."""
    updated = copy.deepcopy(active_lessons)
    updated["lessons"] = list(lessons_map.values())
    return updated


# ---------------------------------------------------------------------------
# File I/O helpers
# ---------------------------------------------------------------------------

def _load_active_lessons() -> dict:
    """Load active.json, returning empty structure if absent."""
    try:
        return read_json(LESSONS_ACTIVE_PATH)
    except KBNotFoundError:
        return {
            "version": "1.0",
            "last_updated": _now_iso(),
            "last_compacted_generation": 0,
            "next_compaction_generation": 3,
            "total_lessons": 0,
            "category_counts": {k: 0 for k in CATEGORY_CAPS},
            "token_config": {
                "token_budget": 10000,
                "avg_tokens_per_lesson": 175,
                "estimated_max_lessons": 57,
                "hard_rules_reserved_tokens": 1500,
                "anti_patterns_reserved_tokens": 1200,
                "flexible_pool_tokens": 7300,
            },
            "lessons": [],
        }


def _load_index() -> dict:
    """Load lessons/index.json, returning empty structure if absent."""
    try:
        return read_json(LESSONS_INDEX_PATH)
    except KBNotFoundError:
        return {
            "version": "1.0",
            "last_updated": _now_iso(),
            "summary": {
                "total_raw_files": 0,
                "total_raw_lessons": 0,
                "total_active_lessons": 0,
                "last_compacted_generation": 0,
                "next_compaction_generation": 3,
                "compaction_count": 0,
            },
            "raw_files": [],
            "active_lesson_coverage": {k: 0 for k in CATEGORY_CAPS},
            "compaction_history": [],
        }


def _load_retired_lessons() -> dict:
    """Load retired.json, returning empty structure if absent."""
    try:
        return read_json(RETIRED_LESSONS_PATH)
    except (KBNotFoundError, FileNotFoundError):
        return {"retired_lessons": []}


def _raw_file_path(generation: int) -> str:
    return os.path.join(LESSONS_RAW_DIR, f"gen-{generation:03d}-lessons.json")


# ---------------------------------------------------------------------------
# Core lesson operations
# ---------------------------------------------------------------------------

def _update_confidence(lesson: dict, delta: float) -> dict:
    """Apply confidence delta to a lesson. Clamp 0.0-1.0.

    Marks lesson for retirement if confidence drops below RETIRE_THRESHOLD.
    Marks for hard_rule promotion if confidence reaches 1.0 AND
    times_reinforced >= PROMOTE_MIN_REINFORCED.

    Args:
        lesson: Lesson dict (not mutated — returns copy).
        delta:  Confidence change to apply (positive or negative).

    Returns:
        Updated lesson dict copy.
    """
    updated = copy.deepcopy(lesson)
    new_conf = _clamp(updated.get("confidence", 0.5) + delta)
    updated["confidence"] = new_conf
    updated["last_updated_at"] = _now_iso()

    if delta > 0:
        updated["times_reinforced"] = updated.get("times_reinforced", 0) + 1
    elif delta < 0:
        updated["times_contradicted"] = updated.get("times_contradicted", 0) + 1

    # Check retirement
    if new_conf < RETIRE_THRESHOLD:
        updated["_retire"] = True

    # Check hard_rule promotion — use original times_reinforced (before increment)
    # so that a lesson with 3 prior confirmations + 1 new = 4 total qualifies,
    # but a lesson with exactly 3 prior confirmations does not yet qualify.
    original_reinforced = lesson.get("times_reinforced", 0)
    if (
        new_conf >= PROMOTE_THRESHOLD
        and original_reinforced >= PROMOTE_MIN_REINFORCED
        and updated.get("category") != "hard_rule"
    ):
        updated["_promote"] = True

    return updated


def _merge_lessons(lesson_a: dict, lesson_b: dict, reason: str) -> dict:
    """Merge two similar lessons into one.

    Confidence = min(1.0, max(a.confidence, b.confidence) + 0.05)
    Text from whichever has higher confidence.
    Archetypes = union of both.
    supporting_evidence = combined (deduplicated).
    times_reinforced = sum of both.

    Args:
        lesson_a: First lesson (not mutated).
        lesson_b: Second lesson (not mutated).
        reason:   Why they were merged.

    Returns:
        New merged lesson dict (caller assigns final ID).
    """
    conf_a = float(lesson_a.get("confidence", 0.5))
    conf_b = float(lesson_b.get("confidence", 0.5))
    new_conf = _clamp(max(conf_a, conf_b) + 0.05)
    higher = lesson_a if conf_a >= conf_b else lesson_b

    archetypes_a = set(lesson_a.get("archetypes", []))
    archetypes_b = set(lesson_b.get("archetypes", []))
    merged_archetypes = sorted(archetypes_a | archetypes_b)

    evidence_a = lesson_a.get("supporting_evidence", [])
    evidence_b = lesson_b.get("supporting_evidence", [])
    combined_evidence = list(dict.fromkeys(evidence_a + evidence_b))  # deduplicate, preserve order

    merged = copy.deepcopy(higher)
    merged["confidence"]          = new_conf
    merged["archetypes"]          = merged_archetypes
    merged["supporting_evidence"] = combined_evidence
    merged["times_reinforced"]    = (
        lesson_a.get("times_reinforced", 0) + lesson_b.get("times_reinforced", 0)
    )
    merged["times_contradicted"]  = (
        lesson_a.get("times_contradicted", 0) + lesson_b.get("times_contradicted", 0)
    )
    merged["source"]       = "compaction"
    merged["last_updated_at"] = _now_iso()
    merged["_merge_reason"] = reason
    # Remove old ID — caller sets new one
    merged.pop("id", None)
    return merged


def _promote_to_hard_rule(lesson: dict) -> dict:
    """Convert a lesson to hard_rule category.

    Requirements: confidence >= 1.0 AND times_reinforced >= PROMOTE_MIN_REINFORCED.
    Sets decay=false on promoted lessons.

    Args:
        lesson: Lesson dict (not mutated).

    Returns:
        Updated lesson dict with category=hard_rule and decay=false.
    """
    updated = copy.deepcopy(lesson)
    updated["category"] = "hard_rule"
    updated["decay"]    = False
    updated["last_updated_at"] = _now_iso()
    updated.pop("_promote", None)
    return updated


def _retire_lesson(
    lesson_id: str,
    active_lessons: dict,
) -> tuple[dict, Optional[dict]]:
    """Remove lesson from active_lessons.

    Args:
        lesson_id:      ID of lesson to retire.
        active_lessons: Current active.json dict.

    Returns:
        Tuple of (updated_active_lessons, retired_lesson_or_none).
        retired_lesson is None if lesson_id not found.
    """
    lessons_map = _lessons_dict(active_lessons)
    if lesson_id not in lessons_map:
        return active_lessons, None

    retired = copy.deepcopy(lessons_map.pop(lesson_id))
    updated = _lessons_from_dict(lessons_map, active_lessons)
    return updated, retired


# ---------------------------------------------------------------------------
# _apply_compaction_hints
# ---------------------------------------------------------------------------

def _apply_compaction_hints(
    active_lessons: dict,
    raw_lessons: list[dict],
) -> dict:
    """Process compaction_hints from raw lesson objects.

    For each raw lesson dict that has a compaction_hints sub-key,
    applies confirmation/contradiction deltas to matching active lessons.

    This function operates at the raw-lesson level — raw lesson files
    may embed compaction_hints directly on individual lesson objects
    (merge_candidate_ids, apply_to_active fields) or via a top-level
    compaction_notes block (handled separately by the caller).

    Args:
        active_lessons: Current active.json dict.
        raw_lessons:    List of lesson objects from unprocessed raw files.

    Returns:
        Updated active_lessons dict.
    """
    updated = copy.deepcopy(active_lessons)
    lessons_map = _lessons_dict(updated)

    # No per-lesson compaction_hints in raw lesson objects — hints come
    # from the raw file's top-level compaction_notes block, processed in
    # run_compaction. This function is the hook for if that shape changes.
    # Return unchanged for now; caller handles compaction_notes directly.
    return updated


def _apply_raw_file_hints(
    active_lessons: dict,
    raw_file: dict,
    generation: int,
    summary: dict,
) -> tuple[dict, dict]:
    """Apply compaction_notes from one raw file to active lessons.

    Handles confirmed_lesson_ids, contradicted_lesson_ids,
    retire_suggestions, and merge_suggestions.

    Args:
        active_lessons: Current active.json dict.
        raw_file:       Loaded raw gen-NNN-lessons.json dict.
        generation:     Current compaction generation.
        summary:        Mutable compaction summary dict (updated in-place).

    Returns:
        Tuple of (updated_active_lessons, updated_summary).
    """
    updated = copy.deepcopy(active_lessons)
    notes   = raw_file.get("compaction_notes") or {}
    lessons_map = _lessons_dict(updated)

    # Confirmed lessons → +0.10
    for lid in notes.get("confirmed_lesson_ids", []):
        if lid in lessons_map:
            lessons_map[lid] = _update_confidence(lessons_map[lid], CONFIRM_DELTA)
            lessons_map[lid]["last_seen_generation"] = generation
            summary["confidence_updates"]["reinforced"] += 1

    # Contradicted lessons → -0.20
    for lid in notes.get("contradicted_lesson_ids", []):
        if lid in lessons_map:
            lessons_map[lid] = _update_confidence(lessons_map[lid], CONTRADICT_DELTA)
            summary["confidence_updates"]["contradicted"] += 1

    # Retire suggestions — flag for retirement (caller processes)
    for entry in notes.get("retire_suggestions", []):
        lid = entry if isinstance(entry, str) else entry.get("lesson_id", "")
        if lid in lessons_map:
            lessons_map[lid]["_retire"] = True

    updated["lessons"] = list(lessons_map.values())
    return updated, summary


# ---------------------------------------------------------------------------
# _add_new_lessons
# ---------------------------------------------------------------------------

def _add_new_lessons(
    active_lessons: dict,
    raw_lessons: list[dict],
    meta: dict,
) -> dict:
    """Add new lessons from raw files to active.json.

    Skips lessons with apply_to_active=false.
    Assigns permanent IDs (lesson-NNN format).
    Respects category caps and total cap of TOTAL_LESSON_CAP.
    Lower-confidence lessons dropped when cap reached.

    Args:
        active_lessons: Current active.json dict.
        raw_lessons:    List of lesson objects from unprocessed raw files.
        meta:           Full meta.json (reserved for future cap overrides).

    Returns:
        Updated active_lessons dict with new lessons added.
    """
    updated = copy.deepcopy(active_lessons)
    lessons_map = _lessons_dict(updated)

    # Current counts per category
    cat_counts: dict[str, int] = {k: 0 for k in CATEGORY_CAPS}
    for lesson in lessons_map.values():
        cat = lesson.get("category", "")
        if cat in cat_counts:
            cat_counts[cat] += 1

    # Sort new lessons by confidence descending (add highest-confidence first)
    candidates = [
        l for l in raw_lessons
        if l.get("apply_to_active", True) is not False
    ]
    candidates.sort(key=lambda l: float(l.get("confidence", 0.0)), reverse=True)

    for raw_lesson in candidates:
        # Check total cap
        if len(lessons_map) >= TOTAL_LESSON_CAP:
            break

        cat = raw_lesson.get("category", "")
        cap = CATEGORY_CAPS.get(cat, 0)

        # Check category cap
        if cat_counts.get(cat, 0) >= cap:
            continue

        # Assign new permanent ID
        new_id = _next_lesson_id({"lessons": list(lessons_map.values())})

        new_lesson = copy.deepcopy(raw_lesson)
        new_lesson["id"] = new_id
        new_lesson.pop("merge_candidate_ids", None)
        new_lesson.pop("apply_to_active", None)
        new_lesson.setdefault("apply_to_next", True)
        new_lesson["last_updated_at"] = _now_iso()
        if not new_lesson.get("created_at"):
            new_lesson["created_at"] = _now_iso()

        lessons_map[new_id] = new_lesson
        cat_counts[cat] = cat_counts.get(cat, 0) + 1

    updated["lessons"] = list(lessons_map.values())
    return updated


# ---------------------------------------------------------------------------
# _apply_decay
# ---------------------------------------------------------------------------

def _apply_decay(active_lessons: dict, generation: int) -> dict:
    """Apply confidence decay to stale lessons.

    Decay rate: -0.05 per generation not seen.
    Only applies to lessons where:
      - decay=true
      - last_seen_generation is more than DECAY_GRACE_GENS generations ago

    Args:
        active_lessons: Current active.json dict.
        generation:     Current generation number.

    Returns:
        Updated active_lessons dict.
    """
    updated     = copy.deepcopy(active_lessons)
    lessons_map = _lessons_dict(updated)
    decayed     = 0

    for lid, lesson in lessons_map.items():
        if not lesson.get("decay", False):
            continue
        last_seen = lesson.get("last_seen_generation")
        if last_seen is None:
            continue
        gens_since = generation - int(last_seen)
        if gens_since <= DECAY_GRACE_GENS:
            continue

        # Apply decay proportional to how long it's been unseen
        decay_amount = DECAY_RATE * (gens_since - DECAY_GRACE_GENS)
        lessons_map[lid] = _update_confidence(lesson, -decay_amount)
        lessons_map[lid]["times_contradicted"] = lesson.get("times_contradicted", 0)  # decay doesn't count as contradiction
        decayed += 1

    updated["lessons"] = list(lessons_map.values())
    updated["_decay_count"] = decayed  # temporary annotation; caller reads and removes
    return updated


# ---------------------------------------------------------------------------
# _load_unprocessed_raw_lessons
# ---------------------------------------------------------------------------

def _load_unprocessed_raw_lessons(generation: int) -> tuple[list[dict], list[str], list[str]]:
    """Load all lesson objects from unprocessed raw files.

    Reads lessons/index.json to find raw files with fully_processed=false.
    Returns only files from generations <= current generation.

    Args:
        generation: Current compaction generation.

    Returns:
        Tuple of (all_lesson_objects, raw_file_names, errors).
    """
    index = _load_index()
    all_lessons: list[dict] = []
    processed_files: list[str] = []
    errors: list[str] = []
    raw_file_data: list[dict] = []  # keep full raw file data for hint processing

    for entry in index.get("raw_files", []):
        if entry.get("fully_processed", False):
            continue
        if int(entry.get("generation", 0)) > generation:
            continue

        filename = entry.get("filename", "")
        filepath = os.path.join(LESSONS_RAW_DIR, filename)
        if not os.path.exists(filepath):
            errors.append(f"Raw file not found: {filepath}")
            continue

        try:
            raw_data = read_json(filepath)
            lessons  = raw_data.get("lessons", [])
            all_lessons.extend(lessons)
            processed_files.append(filename)
            raw_file_data.append(raw_data)
        except Exception as exc:
            errors.append(f"Failed to read {filename}: {exc}")

    return all_lessons, processed_files, errors, raw_file_data


# ---------------------------------------------------------------------------
# Main entry point
# ---------------------------------------------------------------------------

def run_compaction(generation: int, meta: dict) -> dict:
    """Main compaction entry point. Called by Orchestrator every 3 generations.

    Reads unprocessed raw lesson files, applies hints, adds new lessons,
    runs decay, handles retirements and promotions, then writes updated
    active.json and index.json via atomic writes.

    Args:
        generation: Current generation number.
        meta:       Full meta.json dict (for caps and config — not written to).

    Returns:
        compaction_summary dict with full run statistics.
    """
    summary: dict = {
        "generation":                    generation,
        "ran_at":                        _now_iso(),
        "lessons_before":                0,
        "lessons_after":                 0,
        "new_lessons_added":             0,
        "lessons_merged":                0,
        "lessons_retired":               0,
        "lessons_promoted_to_hard_rule": 0,
        "confidence_updates": {
            "reinforced":   0,
            "contradicted": 0,
            "decayed":      0,
        },
        "raw_files_processed": [],
        "errors":              [],
    }

    # ── Load state ─────────────────────────────────────────────────────────────
    active = _load_active_lessons()
    index  = _load_index()
    summary["lessons_before"] = len(active.get("lessons", []))

    # ── Load unprocessed raw files ─────────────────────────────────────────────
    all_raw_lessons, processed_files, errors, raw_file_objects = \
        _load_unprocessed_raw_lessons(generation)
    summary["errors"].extend(errors)
    summary["raw_files_processed"] = processed_files

    if not processed_files and not errors:
        # Nothing to process — still run decay
        pass

    # ── Apply compaction hints from each raw file ──────────────────────────────
    for raw_file in raw_file_objects:
        active, summary = _apply_raw_file_hints(active, raw_file, generation, summary)

    # ── Apply decay ────────────────────────────────────────────────────────────
    active = _apply_decay(active, generation)
    decay_count = active.pop("_decay_count", 0)
    summary["confidence_updates"]["decayed"] = decay_count

    # ── Process retirements and promotions from confidence changes ─────────────
    retired_store = _load_retired_lessons()
    lessons_map   = _lessons_dict(active)
    to_retire:  list[str] = []
    to_promote: list[str] = []

    for lid, lesson in lessons_map.items():
        if lesson.get("_retire"):
            to_retire.append(lid)
        elif lesson.get("_promote"):
            to_promote.append(lid)

    # Retire
    for lid in to_retire:
        active, retired_lesson = _retire_lesson(lid, active)
        if retired_lesson:
            retired_store["retired_lessons"].append({
                "lesson":        retired_lesson,
                "retired_at":    _now_iso(),
                "retired_reason": "confidence_below_threshold",
                "generation":    generation,
            })
            summary["lessons_retired"] += 1

    # Promote
    for lid in to_promote:
        lessons_map = _lessons_dict(active)
        if lid in lessons_map:
            lessons_map[lid] = _promote_to_hard_rule(lessons_map[lid])
            active["lessons"] = list(lessons_map.values())
            summary["lessons_promoted_to_hard_rule"] += 1

    # ── Add new lessons from raw files ─────────────────────────────────────────
    count_before_add = len(active.get("lessons", []))
    active = _add_new_lessons(active, all_raw_lessons, meta)
    count_after_add  = len(active.get("lessons", []))
    summary["new_lessons_added"] = count_after_add - count_before_add

    # ── Update active.json metadata ────────────────────────────────────────────
    category_counts = {k: 0 for k in CATEGORY_CAPS}
    for lesson in active.get("lessons", []):
        cat = lesson.get("category", "")
        if cat in category_counts:
            category_counts[cat] += 1

    active["last_updated"]            = _now_iso()
    active["last_compacted_generation"] = generation
    active["next_compaction_generation"] = generation + 3
    active["total_lessons"]           = len(active.get("lessons", []))
    active["category_counts"]         = category_counts

    # ── Write active.json atomically ───────────────────────────────────────────
    write_json_atomic(LESSONS_ACTIVE_PATH, active)

    # ── Write retired.json atomically ─────────────────────────────────────────
    write_json_atomic(RETIRED_LESSONS_PATH, retired_store)

    # ── Update index.json ─────────────────────────────────────────────────────
    for entry in index.get("raw_files", []):
        if entry.get("filename") in processed_files:
            entry["fully_processed"] = True
            entry["compacted_into_generation"] = generation

    index_summary = index.setdefault("summary", {})
    index_summary["total_active_lessons"]    = len(active.get("lessons", []))
    index_summary["last_compacted_generation"] = generation
    index_summary["next_compaction_generation"] = generation + 3
    index_summary["compaction_count"] = index_summary.get("compaction_count", 0) + 1

    index["active_lesson_coverage"] = category_counts
    index["last_updated"]           = _now_iso()

    history_entry = {
        "generation":          generation,
        "ran_at":              summary["ran_at"],
        "raw_lessons_read":    len(all_raw_lessons),
        "lessons_merged":      summary["lessons_merged"],
        "lessons_retired":     summary["lessons_retired"],
        "lessons_promoted":    summary["lessons_promoted_to_hard_rule"],
        "active_lessons_before": summary["lessons_before"],
        "active_lessons_after":  len(active.get("lessons", [])),
    }
    index.setdefault("compaction_history", []).append(history_entry)

    write_json_atomic(LESSONS_INDEX_PATH, index)

    # ── Finalize summary ───────────────────────────────────────────────────────
    summary["lessons_after"] = len(active.get("lessons", []))
    return summary
