"""
context_builder.py — Assemble the Generator prompt for Claude.

Reads from the Knowledge Base and produces a fully-assembled prompt
string ready to send to the Claude API. Claude never reads raw KB files
directly — this module pre-digests everything into a clean, token-efficient
prompt.

Seven sections assembled:
  1. Mission brief      — archetype tone, targets, regime guidance
  2. Hard rules         — valid nodes, functions, JSON structure rules
  3. Parameter priors   — KB-derived known-good values per indicator
  4. Lessons            — active.json filtered by archetype + regime
  5. Anti-patterns      — losing patterns + anti_pattern lessons
  6. Parent strategies  — top performers to build from
  7. Output format      — exact schema + complete valid example

Schema reference: Section 8 (lessons/active.json), Section 7 (lineage.json)
"""

import copy
import json
import math
import os
import re
from pathlib import Path
from typing import Optional

from kb_writer import read_json
from lineage_tracker import get_parents_for_archetype, tree_to_string

# ── Paths ──────────────────────────────────────────────────────────────────────
_KB_ROOT    = Path.home() / '.openclaw' / 'workspace' / 'learning' / 'kb'
_META_PATH  = _KB_ROOT / 'meta.json'
_ACTIVE_PATH= _KB_ROOT / 'lessons' / 'active.json'
_PATTERNS_PATH = _KB_ROOT / 'patterns.json'

# ── Constants ──────────────────────────────────────────────────────────────────
VALID_ARCHETYPES = {
    'SHARPE_HUNTER', 'RETURN_CHASER', 'RISK_MINIMIZER', 'CONSISTENCY'
}

# ── Regime guidance one-liners ─────────────────────────────────────────────────
REGIME_GUIDANCE = {
    'BULL_CALM':     'leverage and momentum strategies perform well — '
                     'favour leveraged ETF selection',
    'BULL_VOLATILE': 'rally continues but fear is elevated — '
                     'use overbought guards, reduce leverage aggressiveness',
    'BULL_STRESSED': 'prices rising but volatility spiking — '
                     'selective leverage only with tight crash guards',
    'BEAR_MODERATE': 'sustained downtrend — minimise leverage exposure, '
                     'favour BIL and VIXM rotation',
    'BEAR_CRISIS':   'crash conditions — capital preservation only, '
                     'BIL/VIXM priority, short-vol products are dangerous',
    'TRANSITION':    'regime unclear — include defensive fallback in '
                     'every branch, do not assume direction',
    'UNKNOWN':       'no regime data available — include SVXY crash guard '
                     'as outermost layer regardless of archetype',
}

# ── Archetype mission briefs ───────────────────────────────────────────────────
MISSION_BRIEFS = {
    'SHARPE_HUNTER': (
        "You are designing a Composer trading symphony for the SHARPE_HUNTER "
        "archetype. Your singular goal is risk-adjusted excellence. A strategy "
        "with Sharpe 2.5 and 30% return beats one with Sharpe 1.5 and 80% "
        "return — every time. Drawdown control is what separates elite from "
        "average. The market will test your strategy in bad regimes — design "
        "for survival first, performance second.\n\n"
        "Current market regime: {regime} — {regime_guidance}\n"
        "Generation: {generation} | Best SHARPE_HUNTER fitness: {best_fitness}\n"
        "Targets: Sharpe ≥ 2.5 | Ann. Return ≥ 30% | Max Drawdown ≤ 20%"
    ),
    'RETURN_CHASER': (
        "You are designing a Composer trading symphony for the RETURN_CHASER "
        "archetype. Maximise absolute returns. Sharpe matters but return is "
        "king — a 15% drawdown is acceptable when it comes with 80% annualised "
        "return. Find the highest-conviction momentum signal in the leveraged "
        "ETF universe and ride it with appropriate aggression. You are not "
        "here to preserve capital — you are here to grow it fast.\n\n"
        "Current market regime: {regime} — {regime_guidance}\n"
        "Generation: {generation} | Best RETURN_CHASER fitness: {best_fitness}\n"
        "Targets: Ann. Return ≥ 80% | Sharpe ≥ 1.5 | Max Drawdown ≤ 25%"
    ),
    'RISK_MINIMIZER': (
        "You are designing a Composer trading symphony for the RISK_MINIMIZER "
        "archetype. Capital preservation is the primary objective — always. "
        "A flat year beats a down year. Max drawdown under 10% is non-negotiable. "
        "Return matters but never at the cost of catastrophic loss. Design "
        "defensively: multiple guard layers, early exit triggers, and safe "
        "haven assets that activate before damage accumulates. The best trade "
        "is sometimes no trade.\n\n"
        "Current market regime: {regime} — {regime_guidance}\n"
        "Generation: {generation} | Best RISK_MINIMIZER fitness: {best_fitness}\n"
        "Targets: Max Drawdown ≤ 10% | Sharpe ≥ 1.8 | Ann. Return ≥ 25%"
    ),
    'CONSISTENCY': (
        "You are designing a Composer trading symphony for the CONSISTENCY "
        "archetype. Eliminate variance across all market regimes. A strategy "
        "scoring 70/68/72/69 across 6M/1Y/2Y/3Y periods beats one scoring "
        "90/45/88/30 — the floor matters more than the ceiling. Build for "
        "all regimes, not one. Your enemy is not low returns — it is "
        "unpredictability. A strategy that works in 2024 but fails in 2022 "
        "is worthless. Prove it works everywhere.\n\n"
        "Current market regime: {regime} — {regime_guidance}\n"
        "Generation: {generation} | Best CONSISTENCY fitness: {best_fitness}\n"
        "Targets: Period σ < 10 | Max Drawdown ≤ 12% | Ann. Return ≥ 30%"
    ),
}

# ── Hard rules (static — never changes) ───────────────────────────────────────
HARD_RULES = """<hard_rules>
RULE 1 — VALID BLOCK FUNCTIONS ONLY
DSL block functions must be exactly one of:
  (weight-equal [...])
  (weight-specified {"TICKER" pct ...} [...])
  (weight-inverse-vol <window> [...])
  (filter (<fn> <window>) (select-top <n>) [...])
  (if <condition> [<true>] [<else>])
  (asset "EQUITIES::<TICKER>//USD" "<TICKER>")
  (group "Name" [...])
Never invent new block functions. Any other value causes a 400 error.

RULE 2 — VALID INDICATOR FUNCTIONS ONLY
Indicator functions in conditions and filters must be exactly one of:
  rsi                               (relative-strength-index, RSI momentum)
  cumulative-return                 (total return over N days)
  moving-average-price              (simple moving average of price)
  max-drawdown                      (max drawdown over N days)
  standard-deviation-return         (return volatility over N days)
  exponential-moving-average-price  (EMA of price)
  moving-average-return             (moving average of returns)
  standard-deviation-price          (price volatility over N days)
  current-price                     (current price, use window=2)
Never use: risk-adjusted-momentum, momentum-persistence,
exponential-moving-average (without -price suffix), or any invented function.
422 error every time.

RULE 3 — weight-inverse-vol WINDOW IS AN INTEGER
  CORRECT:   (weight-inverse-vol 10 [...])
  INCORRECT: (weight-inverse-vol "10" [...])

RULE 4 — if STRUCTURE REQUIRES BOTH BRANCHES
Every (if ...) must have exactly two [...] blocks — true branch AND else branch.
  CORRECT:   (if <condition> [<true-content>] [<else-content>])
  INCORRECT: (if <condition> [<true-content>])   ← missing else branch — 400 error

RULE 5 — ASSET FORMAT: QUALIFIED STRINGS ONLY
  CORRECT:   (asset "EQUITIES::TQQQ//USD" "TQQQ")
  INCORRECT: (asset "TQQQ" "TQQQ")   ← missing EQUITIES:: and //USD suffix

RULE 6 — FIXED vs DYNAMIC COMPARISONS
  Fixed (compare against constant):
    (> (rsi "EQUITIES::TQQQ//USD" 10) 5.5)

  Dynamic (compare two indicators — rhs is an indicator call):
    (> (rsi "EQUITIES::BIL//USD" 10) (rsi "EQUITIES::IEF//USD" 10))
    (> (current-price "EQUITIES::SPY//USD" 2) (moving-average-price "EQUITIES::SPY//USD" 200))

RULE 7 — ASSET UNIVERSE — ONLY THESE TICKERS PERMITTED
  Volatility:  SVIX, SVXY, UVXY, VIXM
  Leveraged:   TQQQ, TECL, SOXL, SPXL, UPRO
  Safe/hedge:  BIL, SPY, QQQ
  No other tickers. Any other ticker causes an error.

RULE 8 — COMPLETE YOUR DSL — NEVER TRUNCATE
  Always close all parentheses and brackets.
  Never stop mid-expression. A truncated DSL cannot be compiled.
  Set your output budget to at least 3000 tokens.

RULE 9 — COMPOUND CONDITIONS: (and ...) / (or ...)
Use (and ...) or (or ...) to express compound logic instead of deep nesting.

  AND — all must be true (crash guard with 3 simultaneous signals):
    (and (< (rsi "EQUITIES::SVXY//USD" 10) 31)
         (< (cumulative-return "EQUITIES::SVXY//USD" 1) -6)
         (> (max-drawdown "EQUITIES::SPY//USD" 20) 6))

  OR — any one is sufficient:
    (or (> (rsi "EQUITIES::TQQQ//USD" 10) 75)
        (> (rsi "EQUITIES::SPY//USD" 10) 75))

  Nested in an if:
    (if (and (< (rsi "EQUITIES::SVXY//USD" 10) 31)
             (< (cumulative-return "EQUITIES::SVXY//USD" 1) -6))
      [(asset "EQUITIES::BIL//USD" "BIL")]
      [<else-branch>])

  WHEN TO USE:
    - (and ...) when 2-3 signals must ALL confirm before leveraged entry
    - (or ...)  for exit signals where ANY trigger is sufficient
    - Nesting (if ...) when conditions have different else-branch routing

RULE 10 — OUTPUT FORMAT
  Always output DSL, never JSON.
  The DSL will be compiled to JSON automatically by the pipeline.
  Start your response with: defsymphony

RULE 11 — VOLATILITY PROFIT LAYER IS MANDATORY FOR SHARPE_HUNTER
  Strategies that only protect capital in bear markets (routing to BIL)
  will score near zero in 2022. Top strategies PROFIT from bear markets
  by holding UVXY when volatility is elevated.

  The canonical structure is:
  crash_guard → else →
    UVXY RSI(21) > 65? → UVXY (vol profit)
    else →
      SPY > EMA(210)? → bull allocation
      else → BIL

  NEVER generate a strategy where all non-crash paths lead to either
  leveraged bulls OR BIL. There must be a UVXY profit path.
  Volatility assets: UVXY, UVIX, VIXM

DSL GRAMMAR QUICK REFERENCE:
  defsymphony "Name" {:rebalance-frequency :daily}
    (weight-equal [...])
    (weight-inverse-vol <window> [...])
    (weight-specified {"TICKER" pct ...} [...])
    (filter (<fn> <window>) (select-top <n>) [...])
    (if <condition> [<true>] [<else>])
    (asset "EQUITIES::<TICKER>//USD" "<TICKER>")
    (group "Name" [...])
    (and <cond1> <cond2> ...)
    (or <cond1> <cond2> ...)
    (> (rsi "EQUITIES::SPY//USD" 10) 50)
    (> (current-price "EQUITIES::SPY//USD" 2) (moving-average-price "EQUITIES::SPY//USD" 200))
</hard_rules>"""

# ── Complete valid example strategy ───────────────────────────────────────────
EXAMPLE_STRATEGY = """defsymphony "SVXY Guard RSI Rotation Example" {:rebalance-frequency :daily}
  (weight-equal [
    (if (> (max-drawdown "EQUITIES::SVXY//USD" 2) 10)
      [(asset "EQUITIES::BIL//USD" "BIL")]
      [(if (> (rsi "EQUITIES::QQQ//USD" 10) 79)
        [(asset "EQUITIES::VIXM//USD" "VIXM")]
        [(filter (cumulative-return 20) (select-top 1) [
          (asset "EQUITIES::TQQQ//USD" "TQQQ")
          (asset "EQUITIES::SOXL//USD" "SOXL")
          (asset "EQUITIES::UPRO//USD" "UPRO")
        ])])])])
"""

# ── Output format template ─────────────────────────────────────────────────────
OUTPUT_FORMAT_TEMPLATE = """<output_format>
Output exactly one DSL string. No preamble. No explanation.
No markdown code fences. Start your response with defsymphony.

Required DSL structure:
  defsymphony "descriptive strategy name" {{:rebalance-frequency :daily}}
    (<root-block> ...)

Root block must be one of:
  (weight-equal [...])
  (weight-specified {{...}} [...])
  (weight-inverse-vol <window> [...])
  (if <condition> [<true>] [<else>])
  (filter (<fn> <window>) (select-top/bottom <n>) [...])

Archetype goal for this strategy: {archetype}

CRITICAL REMINDERS:
- Every (if ...) needs exactly two [...] blocks — true branch AND else branch
- Asset format: (asset "EQUITIES::TQQQ//USD" "TQQQ")
- Only permitted tickers: SVIX, SVXY, UVXY, VIXM, TQQQ, TECL, SOXL, SPXL, UPRO, BIL, SPY, QQQ
- Compound conditions: (and ...) or (or ...) instead of multiple flat conditions
- Dynamic comparison: (> (rsi "EQUITIES::BIL//USD" 10) (rsi "EQUITIES::IEF//USD" 10))
- Complete all parentheses and brackets — never truncate
- The DSL will be compiled to JSON automatically — do NOT output JSON

EXAMPLE OF VALID COMPLETE DSL OUTPUT:
{example}
</output_format>"""

# ── Token estimation ───────────────────────────────────────────────────────────
def _estimate_tokens(text: str) -> int:
    """Rough token estimate: ~4 characters per token."""
    return max(1, len(text) // 4)


# ── Section builders ───────────────────────────────────────────────────────────

def build_mission_brief(archetype: str, generation: int, meta: dict) -> str:
    """Build the mission brief for the given archetype.

    Args:
        archetype: One of the four archetype enum values.
        generation: Current generation number.
        meta: Full meta.json contents.

    Returns:
        Formatted mission brief string.
    """
    if archetype not in VALID_ARCHETYPES:
        raise ValueError(f"Invalid archetype: {archetype!r}")

    regime = meta['kb_health'].get('current_market_regime', 'UNKNOWN')
    regime_guidance = REGIME_GUIDANCE.get(regime, REGIME_GUIDANCE['UNKNOWN'])

    best_per = meta.get('best_per_archetype', {})
    best_record = best_per.get(archetype)
    best_fitness = (
        f"{best_record['fitness_score']:.1f}"
        if best_record else 'none yet'
    )

    template = MISSION_BRIEFS[archetype]
    return template.format(
        regime=regime,
        regime_guidance=regime_guidance,
        generation=generation,
        best_fitness=best_fitness,
    )


def build_parameter_priors(archetype: str, active_lessons: dict) -> str:
    """Build the parameter priors section from active.json indicator lessons.

    Filters indicator lessons applicable to this archetype, then formats
    them as a structured priors block. Applies archetype_overrides where
    present.

    Args:
        archetype: Archetype enum value.
        active_lessons: Full active.json contents.

    Returns:
        Formatted <parameter_priors> XML section string.
    """
    lessons = active_lessons.get('lessons', [])
    indicator_lessons = [
        l for l in lessons
        if l.get('category') == 'indicator'
        and l.get('apply_to_next', True)
        and (archetype in l.get('archetypes', []) or 'ALL' in l.get('archetypes', []))
    ]

    if not indicator_lessons:
        return (
            "<parameter_priors>\n"
            "No parameter priors available yet. Use the values in the example "
            "strategy as a starting point.\n"
            "</parameter_priors>"
        )

    lines = [
        "<parameter_priors>",
        "Use these known-good parameter values as your starting point.",
        "You may deviate if you have a specific structural reason — "
        "document your reasoning in parameter_choices.",
        "The optimizer will search nearby values regardless.",
        "",
    ]

    for lesson in sorted(indicator_lessons,
                          key=lambda l: l.get('confidence', 0), reverse=True):
        pd = lesson.get('parameter_data')
        if not pd:
            continue

        fn      = pd.get('function', '')
        asset   = pd.get('asset', '')
        conf    = lesson.get('confidence', 0)
        window  = pd.get('optimal_window')
        thresh  = pd.get('optimal_threshold')
        t_range = pd.get('threshold_range')
        sens    = pd.get('sensitivity', '')

        # Apply archetype override if present
        overrides = pd.get('archetype_overrides', {})
        arch_override = overrides.get(archetype, {})
        if arch_override.get('optimal_threshold'):
            thresh  = arch_override['optimal_threshold']
            t_range = arch_override.get('threshold_range', t_range)

        header = f"{fn}"
        if asset:
            header += f" on {asset}"
        header += f":  (confidence: {conf:.2f})"

        lines.append(header)
        if window is not None:
            lines.append(f"  window: {window}")
        if thresh is not None:
            range_str = f"  (optimal range {t_range})" if t_range else ""
            lines.append(f"  threshold: \"{thresh}\"{range_str}")
        if sens:
            lines.append(f"  sensitivity: {sens}")
        if arch_override:
            lines.append(f"  [{archetype} override applied]")
        lines.append("")

    lines.append("</parameter_priors>")
    return "\n".join(lines)


def build_lessons_section(archetype: str, regime: str,
                           active_lessons: dict,
                           token_budget: int) -> str:
    """Build the lessons section from active.json.

    Assembly priority (within token_budget):
      1. hard_rule lessons (always — non-negotiable)
      2. anti_pattern lessons (always — non-negotiable)
      3. indicator/risk/structure lessons matching archetype, conf >= 0.7
      4. indicator/structure lessons for ALL, conf >= 0.6
      5. asset lessons matching archetype, conf >= 0.6
      6. asset lessons for ALL, conf >= 0.5
      7. Lower-confidence lessons if tokens remain

    Regime-matching lessons float to top of each tier.

    Args:
        archetype: Archetype enum value.
        regime: Current market regime string.
        active_lessons: Full active.json contents.
        token_budget: Max tokens for this section.

    Returns:
        Formatted <lessons> XML section string.
    """
    lessons = active_lessons.get('lessons', [])
    applicable = [
        l for l in lessons
        if l.get('apply_to_next', True)
        and (archetype in l.get('archetypes', [])
             or 'ALL' in l.get('archetypes', []))
    ]

    def regime_boost(lesson: dict) -> int:
        rc = lesson.get('regime_context') or {}
        return 1 if rc.get('regime') == regime else 0

    # Sort tiers
    hard_rules    = [l for l in applicable if l['category'] == 'hard_rule']
    anti_patterns = [l for l in applicable if l['category'] == 'anti_pattern']
    flexible      = [l for l in applicable
                     if l['category'] not in ('hard_rule', 'anti_pattern')]

    # Priority tiers for flexible pool
    tiers = [
        [l for l in flexible
         if l['category'] in ('indicator', 'risk', 'structure')
         and l.get('confidence', 0) >= 0.7],
        [l for l in flexible
         if l['category'] in ('indicator', 'structure')
         and l.get('confidence', 0) >= 0.6],
        [l for l in flexible
         if l['category'] == 'asset'
         and l.get('confidence', 0) >= 0.6],
        [l for l in flexible
         if l['category'] == 'asset'
         and l.get('confidence', 0) >= 0.5],
        [l for l in flexible
         if l.get('confidence', 0) < 0.6],
    ]

    # Sort each tier by confidence desc, regime match first
    def sort_key(l):
        return (regime_boost(l), l.get('confidence', 0))

    selected = []
    seen_ids = set()
    tokens_used = 0

    # Always include hard_rules and anti_patterns first
    for lesson in sorted(hard_rules + anti_patterns, key=sort_key, reverse=True):
        if lesson['id'] not in seen_ids:
            selected.append(lesson)
            seen_ids.add(lesson['id'])
            tokens_used += _estimate_tokens(lesson.get('lesson', ''))

    # Fill flexible pool within budget
    for tier in tiers:
        for lesson in sorted(tier, key=sort_key, reverse=True):
            if lesson['id'] in seen_ids:
                continue
            cost = _estimate_tokens(lesson.get('lesson', ''))
            if tokens_used + cost > token_budget:
                break
            selected.append(lesson)
            seen_ids.add(lesson['id'])
            tokens_used += cost

    if not selected:
        return (
            "<lessons>\n"
            "No lessons available yet. This is an early generation — "
            "explore freely while following the hard rules.\n"
            "</lessons>"
        )

    lines = [
        "<lessons>",
        f"These lessons were extracted from {active_lessons.get('total_lessons', 0)} "
        f"generations of backtesting. Apply them when designing your strategy.",
        "",
    ]

    for lesson in selected:
        cat   = lesson.get('category', '').upper()
        conf  = lesson.get('confidence', 0)
        archs = ', '.join(lesson.get('archetypes', ['ALL']))
        rc    = lesson.get('regime_context') or {}
        regime_tag = f" | REGIME: {rc['regime']}" if rc.get('regime') else ''
        lines.append(
            f"[{cat} | CONFIDENCE: {conf:.2f} | {archs}{regime_tag}]"
        )
        lines.append(lesson.get('lesson', ''))
        lines.append("")

    lines.append(f"(Token budget used: ~{tokens_used} of {token_budget})")
    lines.append("</lessons>")
    return "\n".join(lines)


def build_anti_patterns(active_lessons: dict, patterns: dict) -> str:
    """Build the anti-patterns section.

    Includes:
    - All losing patterns from patterns.json
    - All anti_pattern category lessons from active.json

    Anti-patterns are always injected in full — no token budget truncation.

    Args:
        active_lessons: Full active.json contents.
        patterns: Full patterns.json contents.

    Returns:
        Formatted <anti_patterns> XML section string.
    """
    lines = [
        "<anti_patterns>",
        "NEVER do any of the following. These patterns consistently fail.",
        "",
    ]

    # Losing patterns from patterns.json
    for pat in patterns.get('losing_patterns', []):
        lines.append(f"NEVER: {pat.get('never_do', '')}")
        lines.append(f"REASON: {pat.get('why_it_fails', '')}")
        evidence = pat.get('historical_evidence', [])
        if evidence:
            for e in evidence[:2]:   # cap at 2 evidence items per pattern
                lines.append(f"  Evidence: {e}")
        lines.append("")

    # Anti-pattern lessons from active.json
    anti_lessons = [
        l for l in active_lessons.get('lessons', [])
        if l.get('category') == 'anti_pattern'
        and l.get('apply_to_next', True)
    ]
    for lesson in sorted(anti_lessons,
                          key=lambda l: l.get('confidence', 0), reverse=True):
        lines.append(f"ANTI-PATTERN [{lesson.get('confidence', 0):.2f} confidence]:")
        lines.append(lesson.get('lesson', ''))
        lines.append("")

    lines.append("</anti_patterns>")
    return "\n".join(lines)


def build_dsl_fragments(archetype: str, max_fragments: int = 8) -> str:
    """Load DSL fragments from kb/patterns_dsl/ relevant to this archetype.

    Reads all .dsl files from guards/, allocation/, selection/ subdirectories.
    Filters by archetype match in the file's comment header.
    Sorts by confidence (parsed from header), returns top max_fragments.

    Args:
        archetype: Archetype enum value.
        max_fragments: Maximum number of fragments to include.

    Returns:
        Formatted <dsl_fragments> XML section string.
    """
    kb_dsl = _KB_ROOT / 'patterns_dsl'
    if not kb_dsl.exists():
        return (
            "<dsl_fragments>\n"
            "No DSL fragment library available yet.\n"
            "</dsl_fragments>"
        )

    fragments = []
    for subdir in ('guards', 'allocation', 'selection'):
        subdir_path = kb_dsl / subdir
        if not subdir_path.exists():
            continue
        for dsl_file in sorted(subdir_path.glob('*.dsl')):
            content = dsl_file.read_text()

            # Parse name from first line: "; Name — id"
            first_line = content.split('\n')[0]
            name = first_line.lstrip('; ').split(' — ')[0].strip()

            # Parse archetypes from comment header
            arch_m = re.search(r'; archetypes: (.+)', content)
            archetypes_str = arch_m.group(1).strip() if arch_m else ''
            arch_list = [a.strip() for a in archetypes_str.split(',')]

            # Parse confidence
            conf_m = re.search(r'; confidence: ([\d.]+)', content)
            confidence = float(conf_m.group(1)) if conf_m else 0.0

            # Filter: include if archetype matches or ALL applies
            if archetype in arch_list or 'ALL' in arch_list:
                fragments.append({
                    'name':       name,
                    'content':    content,
                    'confidence': confidence,
                    'subdir':     subdir,
                })

    if not fragments:
        return (
            "<dsl_fragments>\n"
            f"No DSL fragments available for archetype {archetype}.\n"
            "</dsl_fragments>"
        )

    # Sort by confidence desc, cap at max_fragments
    fragments.sort(key=lambda x: x['confidence'], reverse=True)
    fragments = fragments[:max_fragments]

    lines = [
        "<dsl_fragments>",
        f"These are proven DSL building blocks extracted from {len(fragments)} real symphonies.",
        "Use them as structural components in your strategy.",
        "",
    ]

    for frag in fragments:
        conf = frag['confidence']
        lines.append(f"FRAGMENT: {frag['name']} (confidence: {conf})")
        lines.append(frag['content'])
        lines.append("")

    lines.append("</dsl_fragments>")
    return "\n".join(lines)


def build_parents_section(parents: list[dict], generation: int) -> str:
    """Format the parent strategies section.

    Includes full composer_json for all parents (not truncated).
    Generation 0 parents are annotated as existing symphonies.

    Args:
        parents: List of parent strategy dicts from get_parents_for_prompt().
        generation: Current generation number.

    Returns:
        Formatted <parent_strategies> XML section string.
    """
    if not parents:
        return (
            "<parent_strategies>\n"
            "No parent strategies available yet. "
            "This is the first generation — design freely.\n"
            "</parent_strategies>"
        )

    is_gen0 = generation == 0
    lines = ["<parent_strategies>"]

    if is_gen0:
        lines.append(
            "These are your existing live symphonies — use them as structural "
            "reference and inspiration. They have not been scored by this system. "
            "Build something better, not a copy."
        )
    else:
        lines.append(
            "These are the top-performing strategies for this archetype. "
            "Use them as inspiration. Mutate, combine, or improve on them. "
            "Do not copy them exactly — build something better."
        )
    lines.append("")

    for i, parent in enumerate(parents, 1):
        name    = parent.get('name', f'Parent {i}')
        fitness = parent.get('fitness')
        sharpe  = parent.get('sharpe_1Y')
        ret     = parent.get('return_1Y')
        dd      = parent.get('drawdown_1Y')
        struct  = parent.get('top_level_structure', '')
        is_existing = parent.get('is_existing_symphony', False)

        if is_existing:
            lines.append(f"PARENT {i} — {name} (existing live symphony)")
        elif fitness is not None:
            perf_parts = []
            if fitness is not None:
                perf_parts.append(f"fitness: {fitness:.1f}")
            if sharpe is not None:
                perf_parts.append(f"Sharpe: {sharpe:.2f}")
            if ret is not None:
                perf_parts.append(f"Return: {ret:.1f}%")
            if dd is not None:
                perf_parts.append(f"MaxDD: {dd:.1f}%")
            lines.append(f"PARENT {i} — {name} ({', '.join(perf_parts)})")
        else:
            lines.append(f"PARENT {i} — {name}")

        if struct:
            lines.append(f"Structure: {struct}")

        # Full DSL (preferred) or composer JSON
        dsl = parent.get('dsl', '')
        composer_json = parent.get('composer_json', {})
        if dsl:
            lines.append(
                "FULL DSL — study the architecture, crash guards, vol profit "
                "paths, and bull allocation. Build something inspired by this "
                "structure with your own parameter variations. Do NOT copy exactly."
            )
            lines.append(dsl)
        elif composer_json:
            lines.append("JSON:")
            lines.append(json.dumps(composer_json, indent=2))

        lines.append("")

    lines.append("</parent_strategies>")
    return "\n".join(lines)


def get_parents_for_prompt(archetype: str, generation: int,
                            meta: dict) -> list[dict]:
    """Get parent strategies for the Generator prompt.

    Generation 0: fetch existing symphonies from Composer API score endpoint.
    Generation 1+: read from lineage.json elite_registry via lineage_tracker.

    Args:
        archetype: Archetype enum value.
        generation: Current generation number.
        meta: Full meta.json contents.

    Returns:
        List of up to 3 parent strategy dicts.
    """
    if generation == 0:
        return _fetch_gen0_parents(archetype, meta)

    parents = get_parents_for_archetype(archetype, limit=3)

    if not parents:
        # Archetype has no history — use cross-archetype global top performers
        from lineage_tracker import _load_lineage
        lineage = _load_lineage()
        global_top = lineage.get('elite_registry', {}).get(
            'all_time_top_10', []
        )[:3]
        for p in global_top:
            p['_cross_archetype_note'] = (
                f"Cross-archetype parent (from {p.get('archetype', 'unknown')})"
            )
        return global_top

    return parents


def _fetch_gen0_parents(archetype: str, meta: dict) -> list[dict]:
    """Fetch existing symphonies from Composer API for generation 0.

    Uses the /api/v0.1/symphonies/{id}/score endpoint to get the full
    symphony definition JSON. Returns the 3 most relevant symphonies
    for the given archetype.

    Args:
        archetype: Archetype enum value.
        meta: Full meta.json contents (for broker/capital config).

    Returns:
        List of parent dicts with composer_json populated.
    """
    import requests
    from credentials import CredentialManager

    # Existing symphony IDs
    SYMPHONIES = {
        'beta_baller':  {
            'id':   'vNP5oYsbpV8tS9USqGEL',
            'name': 'Beta Baller with Rotators Final',
            'sharpe': 4.06, 'return': 108.0, 'drawdown': 5.3,
        },
        'extended_oos': {
            'id':   'n9J6L8weCzu2vAUrMWnm',
            'name': 'Extended OOS Outliers',
            'sharpe': 2.13, 'return': 60.5, 'drawdown': 9.2,
        },
        'sisyphus':     {
            'id':   'qjRIwrAOA1YzFSghM08b',
            'name': 'Sisyphus V0.0',
            'sharpe': 1.92, 'return': 45.8, 'drawdown': 10.3,
        },
    }

    # Priority order per archetype
    PRIORITY = {
        'SHARPE_HUNTER':  ['beta_baller', 'extended_oos', 'sisyphus'],
        'RETURN_CHASER':  ['beta_baller', 'extended_oos', 'sisyphus'],
        'RISK_MINIMIZER': ['extended_oos', 'sisyphus', 'beta_baller'],
        'CONSISTENCY':    ['sisyphus', 'extended_oos', 'beta_baller'],
    }

    creds   = CredentialManager()
    headers = creds.get_composer_headers()
    base    = 'http://localhost:8080/composer'
    parents = []

    for key in PRIORITY.get(archetype, list(SYMPHONIES.keys())):
        sym = SYMPHONIES[key]
        try:
            url  = f"{base}/api/v0.1/symphonies/{sym['id']}/score"
            resp = requests.get(url, headers=headers, timeout=15)
            resp.raise_for_status()
            data = resp.json()

            definition = data.get('definition') or data.get('score') or {}

            parent_dict = {
                'strategy_id':          f"existing-{key}",
                'name':                 sym['name'],
                'fitness':              None,
                'sharpe_1Y':            sym['sharpe'],
                'return_1Y':            sym['return'],
                'drawdown_1Y':          sym['drawdown'],
                'is_existing_symphony': True,
                'composer_json':        definition,
                'top_level_structure':  tree_to_string(definition),
            }
            if key == 'sisyphus':
                dsl_path = Path.home() / '.openclaw/workspace/learning/kb/pilot/sisyphus.dsl'
                if dsl_path.exists():
                    parent_dict['dsl'] = dsl_path.read_text()
                    parent_dict['composer_json'] = {}
            parents.append(parent_dict)
        except Exception as e:
            # Don't crash if one symphony fails to fetch — continue with others
            parent_dict = {
                'strategy_id':          f"existing-{key}",
                'name':                 sym['name'],
                'fitness':              None,
                'is_existing_symphony': True,
                'composer_json':        {},
                'top_level_structure':  f"(fetch failed: {e})",
                '_fetch_error':         str(e),
            }
            if key == 'sisyphus':
                dsl_path = Path.home() / '.openclaw/workspace/learning/kb/pilot/sisyphus.dsl'
                if dsl_path.exists():
                    parent_dict['dsl'] = dsl_path.read_text()
            parents.append(parent_dict)

    return parents


# ── Main assembly function ─────────────────────────────────────────────────────

def build_generator_prompt(archetype: str, generation: int,
                            slot_number: int) -> str:
    """Assemble the complete Generator prompt for Claude.

    Reads all KB files, assembles all 7 sections, and returns the
    complete prompt string ready to send to the Anthropic API.

    Args:
        archetype: One of the four archetype enum values.
        generation: Current generation number (0-indexed).
        slot_number: Which slot within the generation (1-indexed).

    Returns:
        Complete prompt string.

    Raises:
        ValueError: If archetype is invalid.
        FileNotFoundError: If KB files are not initialised.
    """
    if archetype not in VALID_ARCHETYPES:
        raise ValueError(
            f"Invalid archetype: {archetype!r}. "
            f"Must be one of: {sorted(VALID_ARCHETYPES)}"
        )

    # Load KB files
    meta           = read_json(str(_META_PATH))
    active_lessons = read_json(str(_ACTIVE_PATH))
    patterns       = read_json(str(_PATTERNS_PATH))

    # Fetch parents
    parents = get_parents_for_prompt(archetype, generation, meta)

    # Token config
    token_config   = active_lessons.get('token_config', {})
    flexible_budget = token_config.get('flexible_pool_tokens', 7300)

    # Build each section
    regime = meta['kb_health'].get('current_market_regime', 'UNKNOWN')

    mission      = build_mission_brief(archetype, generation, meta)
    priors       = build_parameter_priors(archetype, active_lessons)
    lessons      = build_lessons_section(
                       archetype, regime, active_lessons, flexible_budget)
    anti_pats    = build_anti_patterns(active_lessons, patterns)
    dsl_fragments = build_dsl_fragments(archetype)
    parents_sect = build_parents_section(parents, generation)
    output_fmt   = OUTPUT_FORMAT_TEMPLATE.format(
                       archetype=archetype,
                       example=EXAMPLE_STRATEGY)

    # Assemble final prompt
    sections = [
        mission,
        "",
        HARD_RULES,
        "",
        priors,
        "",
        lessons,
        "",
        anti_pats,
        "",
        dsl_fragments,
        "",
        parents_sect,
        "",
        output_fmt,
    ]

    prompt = "\n".join(sections)

    # Log token estimate
    estimated_tokens = _estimate_tokens(prompt)
    from monitor_agent import log_event
    log_event(
        'INFO', 'context_builder',
        f"Generator prompt assembled for {archetype} gen-{generation} "
        f"slot-{slot_number}: ~{estimated_tokens} tokens estimated"
    )

    return prompt


# ── Convenience: build all prompts for a generation ───────────────────────────

def build_generation_prompts(generation: int,
                              meta: dict) -> list[dict]:
    """Build all Generator prompts for an entire generation.

    Reads the archetype allocation from meta.json and returns one
    prompt per strategy slot.

    Args:
        generation: Current generation number.
        meta: Full meta.json contents.

    Returns:
        List of dicts with keys: archetype, slot_number, prompt.
    """
    allocation = meta['archetype_allocation']['current']
    prompts = []
    slot = 1

    for archetype, count in allocation.items():
        for _ in range(count):
            prompt = build_generator_prompt(archetype, generation, slot)
            prompts.append({
                'archetype':   archetype,
                'slot_number': slot,
                'prompt':      prompt,
            })
            slot += 1

    return prompts
