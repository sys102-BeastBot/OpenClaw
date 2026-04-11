"""
r3_prompt.py — R3 Knowledge Synthesis prompt for research_phase.py

Synthesizes R1 (community patterns) and R2 (symphony autopsy) into
a unified set of 20 ranked lessons ready for active.json.

Handles conflicts between R1 and R2 findings:
  - R2 wins on parameter values (confirmed in best performer)
  - R1 wins on structural patterns (confirmed across 150+ symphonies)
  - Conflicts are flagged explicitly for human review

One Claude API call. Cost: ~$0.45.
Requires: R1 and R2 both complete.
"""


# ── Prompt assembly ────────────────────────────────────────────────────────────

R3_SYSTEM_PROMPT = """\
You are a knowledge engineer synthesizing findings from two separate
analyses into a unified, ranked knowledge base for an autonomous
strategy generation system.

Your job is not to add new analysis — it is to reconcile, rank, and
distill the existing findings into exactly 20 high-quality lessons.

Prioritization rules:
  1. R2 (symphony autopsy) wins on parameter values — confirmed in
     the best performing strategy (Sharpe 4.06).
  2. R1 (community patterns) wins on structural patterns — confirmed
     across 150+ symphonies provides stronger structural evidence.
  3. Where findings conflict, flag the conflict explicitly and take
     the more conservative (safer) interpretation.
  4. Do not invent new findings — only synthesize what is in the input.\
"""


def build_r3_prompt(r1_output: dict, r2_output: dict) -> str:
    """
    Assemble the complete R3 Knowledge Synthesis prompt.

    Args:
        r1_output: Full parsed JSON output from R1 Library Mining.
        r2_output: Full parsed JSON output from R2 Symphony Autopsy.

    Returns:
        Complete prompt string ready for Claude API.
    """
    import json

    r1_str = json.dumps(r1_output, indent=2)
    r2_str = json.dumps(r2_output, indent=2)

    return R3_PROMPT_TEMPLATE.format(
        r1_output=r1_str,
        r2_output=r2_str,
    )


# ── R3 Prompt Template ─────────────────────────────────────────────────────────

R3_PROMPT_TEMPLATE = """\
I have completed two analyses of Composer.trade trading symphonies.
Synthesize them into exactly 20 lessons for a strategy knowledge base.

═══════════════════════════════════════════════════════════════════
R1 OUTPUT — Community Pattern Mining (150+ symphonies)
═══════════════════════════════════════════════════════════════════

{r1_output}

═══════════════════════════════════════════════════════════════════
R2 OUTPUT — Symphony Autopsy (4 specific symphonies)
═══════════════════════════════════════════════════════════════════

{r2_output}

═══════════════════════════════════════════════════════════════════
SYNTHESIS RULES
═══════════════════════════════════════════════════════════════════

RULE 1 — R2 WINS ON PARAMETERS
When R1 and R2 suggest different parameter values for the same
indicator, use R2's values. Beta Baller's Sharpe 4.06 provides
stronger confirmation than community averages.
Example: if R1 says max-drawdown threshold=8-12 and R2 says
threshold=10 (exact from Beta Baller), use threshold=10 with
range=8-12 and note R2 confirmation.

RULE 2 — R1 WINS ON STRUCTURE
When R1 community patterns confirm a structural pattern across
many symphonies, that evidence is stronger than R2's 3-symphony
observation for structural lessons.
Example: if R1 shows 3-layer nesting in 40+ symphonies, that
structural lesson is stronger than R2's 3-symphony comparison.

RULE 3 — FLAG CONFLICTS
When R1 and R2 directly contradict each other, include the
lesson but set conflict_flag=true and describe both findings.
Do not resolve the conflict yourself — flag it for human review.

RULE 4 — CONFIDENCE ASSIGNMENT
  0.90 — R2 confirmed in Beta Baller (Sharpe 4.06)
  0.85 — Both R1 and R2 agree (highest synthesis confidence)
  0.80 — R1 confirmed in 5+ community symphonies
  0.75 — R1 confirmed in 2-4 symphonies OR R2 confirmed in 2 symphonies
  0.65 — Single symphony observation (either source)
  0.50 — Plausible but limited evidence

RULE 5 — LESSON QUALITY BAR
Every lesson must:
  - Be actionable (tells the generator what to do or not do)
  - Reference specific evidence (symphony IDs or performance numbers)
  - Be 2-4 sentences maximum
  - Not duplicate another lesson in the 20

RULE 6 — CATEGORY DISTRIBUTION
Aim for this distribution across the 20 lessons:
  indicator:    5-6 lessons (parameter priors with values)
  structure:    4-5 lessons (node patterns, nesting, guards)
  anti_pattern: 4-5 lessons (never do instructions)
  asset:        2-3 lessons (combination insights)
  risk:         2-3 lessons (regime and drawdown management)
  hard_rule:    1-2 lessons (absolute rules, highest confidence)

═══════════════════════════════════════════════════════════════════
YOUR TASK
═══════════════════════════════════════════════════════════════════

Produce exactly 20 lessons. Rank them by importance — lesson 1
is the single most important thing the generator must know.

For each lesson, apply the synthesis rules above. Merge similar
findings from R1 and R2 into one stronger lesson rather than
producing two weaker ones.

The 20 lessons become the starting knowledge base that guides
every strategy the generator produces. Make them count.

═══════════════════════════════════════════════════════════════════
OUTPUT FORMAT
═══════════════════════════════════════════════════════════════════
Single JSON object. No preamble. No explanation.
No markdown fences. Start with {{ and end with }}.

{{
  "synthesis_summary": {{
    "r1_patterns_reviewed": int,
    "r2_parameters_reviewed": int,
    "conflicts_found": int,
    "conflicts_resolved": int,
    "conflicts_flagged": int,
    "synthesis_notes": "2-3 sentences on the most important finding"
  }},
  "lessons": [
    {{
      "rank": 1,
      "category": "hard_rule|indicator|structure|asset|risk|anti_pattern",
      "subcategory": "free text e.g. crash_guard",
      "confidence": 0.0-1.0,
      "decay": true or false,
      "archetypes": ["ALL"] or ["SHARPE_HUNTER", "RETURN_CHASER", ...],
      "lesson": "2-4 sentence lesson. Specific and actionable.",
      "parameter_data": null or {{
        "function": "exact lhs-fn name",
        "asset": "ticker or null",
        "optimal_window": integer or null,
        "window_range": "e.g. 2-5 or null",
        "optimal_threshold": "string value or null",
        "threshold_range": "e.g. 8-12 or null",
        "sensitivity": "HIGH|MEDIUM|LOW or null",
        "archetype_overrides": {{}}
      }},
      "regime_context": null or {{
        "regime": "BULL_CALM|BULL_VOLATILE|BEAR_MODERATE|BEAR_CRISIS|TRANSITION",
        "regime_note": "why this lesson is regime-specific"
      }},
      "supporting_evidence": ["source: specific data point"],
      "conflict_flag": false,
      "conflict_notes": null,
      "source": "R1|R2|BOTH",
      "apply_to_active": true
    }}
  ],
  "deferred_lessons": [
    {{
      "reason": "why this was not included in top 20",
      "lesson_summary": "brief description",
      "source": "R1|R2",
      "revisit_at_generation": 10
    }}
  ]
}}

CRITICAL OUTPUT RULES:
  - Exactly 20 lessons in the lessons array — not 19, not 21
  - Lessons ranked 1-20 by importance (1 = most important)
  - Every lesson must have supporting_evidence with actual sources
  - conflict_flag: true when R1 and R2 disagree on this topic
  - decay: false for hard_rules and anti_patterns (they don't expire)
  - decay: true for indicator and structure lessons (priors can improve)
  - apply_to_active: true for all 20 (they are being added to active.json)
  - deferred_lessons: any good findings that didn't make the top 20
    Include these so they can be added in later compaction cycles
  - parameter_data: required for all indicator category lessons
    null is not acceptable for indicator lessons
"""
