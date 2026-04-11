"""
r5_prompt.py — R5 Seed Lesson Extraction prompt for research_phase.py

R5 runs the Learner Agent once on all 24 seed strategy results.
This is the richest Learner call the system will ever make —
24 strategies across all 4 archetypes, covering diverse structures.

R5 does NOT use a new prompt — it reuses learner_agent.py with
a modified system message that acknowledges the seed context.

The R5 Learner call produces 8-12 additional lessons added to
active.json on top of the 20 from R3. Final KB state before
generation 0: ~28-32 active lessons.

Cost: ~$0.15 (one Learner call)
Time: ~30 seconds
Requires: R4 complete (all 24 seeds backtested and scored)
"""


# ── R5 Learner brief modifier ──────────────────────────────────────────────────

R5_LEARNER_CONTEXT_PREFIX = """\
SEED ANALYSIS MODE: You are analyzing the results of 24 seed \
strategies generated to explore the strategy space before the \
autonomous learning loop begins. These are NOT production strategies \
— they are deliberately diverse exploratory probes.

KEY DIFFERENCES FROM NORMAL GENERATION ANALYSIS:
  1. Seeds were designed for DIVERSITY not optimization — expect
     wide variance in performance. High variance is expected.
  2. No optimizer was run — parameters are Generator choices only.
     Parameter lessons here are about what the Generator chose,
     not optimizer-confirmed values.
  3. Seeds cover all 4 archetypes across 24 strategies — more
     structural diversity than any normal generation will provide.
  4. R3 already established 20 lessons from community analysis.
     Do NOT duplicate those lessons. Build on them, refine them,
     or contradict them with evidence.

WHAT TO LOOK FOR IN SEEDS:
  - Which archetypes produced consistently better structures?
  - Did the Generator follow the R3 lessons or deviate?
    (deviations that performed well are especially interesting)
  - What structural patterns appear in the top 6 seeds regardless
    of archetype? These are universally strong.
  - What structural decisions consistently produced poor results
    across all archetypes? These are new anti-patterns.
  - Did any seed produce an unexpectedly good result? Examine
    why — this often reveals a non-obvious structural insight.

CONFIDENCE CALIBRATION FOR SEED LESSONS:
  Since seeds are not optimized, use lower confidence:
    0.55 — single seed observation
    0.65 — pattern in 3+ seeds
    0.70 — pattern in 6+ seeds
    0.75 — pattern confirmed across multiple archetypes

"""

# ── R5 configuration ───────────────────────────────────────────────────────────

R5_CONFIG = {
    "max_lessons": 12,          # Cap for R5 lessons (added on top of R3's 20)
    "min_lessons": 5,           # Minimum acceptable from R5
    "max_tokens": 10000,        # Same as standard Learner
    "focus_areas": [
        "structural_patterns",   # What structures work across archetypes
        "archetype_insights",    # What each archetype needs specifically
        "generator_behavior",    # Did Generator follow KB lessons?
        "parameter_baselines",   # Starting parameter ranges before optimization
    ],
}


def build_r5_brief_prefix() -> str:
    """
    Return the prefix to prepend to the standard learner brief.
    This is injected into the generation_brief section of the
    standard Learner prompt in learner_agent.py.

    Returns:
        Prefix string to prepend to the learner brief JSON.
    """
    return R5_LEARNER_CONTEXT_PREFIX


def build_r5_active_lessons_note(r3_lesson_count: int) -> str:
    """
    Build a note to add to the existing_lessons section
    reminding the Learner that R3 lessons already exist.

    Args:
        r3_lesson_count: Number of lessons added by R3 (should be 20).

    Returns:
        Note string to prepend to existing_lessons section.
    """
    return (
        f"NOTE: The {r3_lesson_count} lessons above were extracted by R3 "
        f"Knowledge Synthesis from community pattern mining and symphony "
        f"autopsy. Do NOT duplicate them. Your task is to ADD new lessons "
        f"that R3 could not produce — lessons that require seeing actual "
        f"backtested strategy results, not just structural analysis.\n\n"
    )


# ── R5 output schema additions ─────────────────────────────────────────────────
# R5 adds two extra fields to the standard Learner output

R5_EXTRA_OUTPUT_SCHEMA = """
  "seed_analysis": {{
    "best_seed_id": "strategy ID of best performing seed",
    "best_seed_fitness": float,
    "best_seed_archetype": "archetype",
    "worst_seed_id": "strategy ID of worst performing seed",
    "recommended_gen0_parents": [
      {{
        "strategy_id": "seed ID",
        "archetype": "archetype",
        "fitness": float,
        "why_recommended": "specific structural reason"
      }}
    ],
    "archetype_summary": {{
      "SHARPE_HUNTER": {{
        "avg_fitness": float,
        "best_fitness": float,
        "structural_insight": "what worked for this archetype"
      }},
      "RETURN_CHASER": {{
        "avg_fitness": float,
        "best_fitness": float,
        "structural_insight": "what worked for this archetype"
      }},
      "RISK_MINIMIZER": {{
        "avg_fitness": float,
        "best_fitness": float,
        "structural_insight": "what worked for this archetype"
      }},
      "CONSISTENCY": {{
        "avg_fitness": float,
        "best_fitness": float,
        "structural_insight": "what worked for this archetype"
      }}
    }},
    "generator_adherence": {{
      "followed_r3_lessons": int,
      "deviated_from_r3": int,
      "beneficial_deviations": ["description of deviations that helped"],
      "harmful_deviations": ["description of deviations that hurt"]
    }}
  }}
"""
