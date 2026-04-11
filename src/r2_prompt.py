"""
r2_prompt.py — R2 Symphony Autopsy prompt for research_phase.py

Deep structural analysis of 4 specific symphonies:
  - Beta Baller (Sharpe 4.06) — parameter extraction
  - Extended OOS (Sharpe 2.13) — structural comparison
  - Sisyphus (Sharpe 1.92) — structural comparison
  - 01 s90 50/40 maxDD (Sharpe -4.51) — failure autopsy

R2 reuses backtest data from R1 Step 1 — no new Composer API calls.
One Claude API call. Cost: ~$0.75.
"""

from datetime import date, timedelta


# ── Period date ranges (reused from r1_prompt.py) ─────────────────────────────

def get_period_label(period: str) -> str:
    """Return human-readable date range for a backtest period."""
    end = date.today()
    days = {'6M': 183, '1Y': 365, '2Y': 730, '3Y': 1095}
    start = end - timedelta(days=days[period])
    return f"{start.strftime('%b %Y')} → {end.strftime('%b %Y')}"


# ── Symphony block formatter ───────────────────────────────────────────────────

def format_autopsy_symphony(sym: dict, label: str) -> str:
    """
    Format one symphony for the R2 autopsy block.
    All 4 symphonies get full JSON + complete performance data.

    Args:
        sym: dict with keys:
            name, id, tree_structure, composer_json,
            periods: {period: {annualized_return, sharpe,
                               max_drawdown, r_squared, pearson_r}}
        label: Human label e.g. "CROWN JEWEL" or "FAILURE SUBJECT"
    """
    import json

    lines = [
        f"{'='*60}",
        f"SYMPHONY: {sym['name']}",
        f"ID: {sym['id']}",
        f"LABEL: {label}",
        f"{'='*60}",
        f"",
        f"STRUCTURE:",
        sym['tree_structure'],
        f"",
        f"FULL JSON:",
        json.dumps(sym['composer_json'], indent=2),
        f"",
        f"PERFORMANCE:",
    ]

    for period in ['6M', '1Y', '2Y', '3Y']:
        p = sym['periods'].get(period)
        if not p:
            lines.append(f"  {period:3s}  ({get_period_label(period)}): no data")
            continue
        r2      = f"r²={p['r_squared']:.3f}" if p.get('r_squared') is not None else "r²=n/a"
        pearson = f"pearson_r={p['pearson_r']:.3f}" if p.get('pearson_r') is not None else "pearson_r=n/a"
        lines.append(
            f"  {period:3s}  ({get_period_label(period)}): "
            f"return={p['annualized_return']:+.1f}%  "
            f"sharpe={p['sharpe']:.2f}  "
            f"maxDD={p['max_drawdown']:.1f}%  "
            f"{r2}  {pearson}"
        )

    lines.append("")
    return "\n".join(lines)


# ── Prompt assembly ────────────────────────────────────────────────────────────

R2_SYSTEM_PROMPT = """\
You are a quantitative analyst performing forensic analysis of \
Composer.trade trading symphonies. You will analyze four specific \
symphonies in detail — three strong performers and one catastrophic \
failure.

Your analysis has two purposes:
1. Extract precise parameter priors from the best performer (Beta Baller)
   that will guide future strategy generation.
2. Perform a failure autopsy on the worst performer (01 s90) to extract
   anti-pattern lessons that prevent future catastrophic losses.

For parameter extraction: be precise about exact values from the JSON.
The generator needs confirmed numbers, not ranges or estimates.

For the failure autopsy: be ruthless and specific. A -86.8% return
has specific structural causes. Find them in the JSON.\
"""


def build_r2_prompt(
    beta_baller: dict,
    extended_oos: dict,
    sisyphus: dict,
    s90: dict,
) -> str:
    """
    Assemble the complete R2 Symphony Autopsy prompt.

    Args:
        beta_baller:  Beta Baller symphony dict (full JSON + performance)
        extended_oos: Extended OOS symphony dict
        sisyphus:     Sisyphus symphony dict
        s90:          01 s90 50/40 maxDD symphony dict (failure subject)

    Returns:
        Complete prompt string ready for Claude API.
    """
    beta_block     = format_autopsy_symphony(beta_baller, "CROWN JEWEL — highest priority analysis")
    extended_block = format_autopsy_symphony(extended_oos, "STRONG PERFORMER")
    sisyphus_block = format_autopsy_symphony(sisyphus, "STRONG PERFORMER")
    s90_block      = format_autopsy_symphony(s90, "FAILURE SUBJECT — autopsy priority")

    return R2_PROMPT_TEMPLATE.format(
        period_6m=get_period_label('6M'),
        period_1y=get_period_label('1Y'),
        period_2y=get_period_label('2Y'),
        period_3y=get_period_label('3Y'),
        beta_block=beta_block,
        extended_block=extended_block,
        sisyphus_block=sisyphus_block,
        s90_block=s90_block,
    )


# ── R2 Prompt Template ─────────────────────────────────────────────────────────

R2_PROMPT_TEMPLATE = """\
Perform a deep structural analysis of these four Composer.trade \
trading symphonies. Three are strong performers. One is a \
catastrophic failure that lost -86.8% in the same period the \
others gained 45-108%.

The strategy generator that will use your findings is constrained \
to this asset universe:
  Volatility short: SVIX, SVXY
  Volatility long:  UVXY, VIXM
  Leveraged bull:   TQQQ, TECL, SOXL, SPXL, UPRO
  Leveraged bear:   SQQQ, SOXS, SPXS, TECS
  Safe/hedge:       BIL, SPY, QQQ

Performance periods:
  6M: {period_6m}  |  1Y: {period_1y}
  2Y: {period_2y}  |  3Y: {period_3y}

═══════════════════════════════════════════════════════════════════
SYMPHONY 1 — BETA BALLER
═══════════════════════════════════════════════════════════════════

{beta_block}

═══════════════════════════════════════════════════════════════════
SYMPHONY 2 — EXTENDED OOS OUTLIERS
═══════════════════════════════════════════════════════════════════

{extended_block}

═══════════════════════════════════════════════════════════════════
SYMPHONY 3 — SISYPHUS
═══════════════════════════════════════════════════════════════════

{sisyphus_block}

═══════════════════════════════════════════════════════════════════
SYMPHONY 4 — 01 s90 50/40 maxDD  (FAILURE SUBJECT)
═══════════════════════════════════════════════════════════════════

{s90_block}

═══════════════════════════════════════════════════════════════════
YOUR TASKS
═══════════════════════════════════════════════════════════════════

TASK 1 — BETA BALLER PARAMETER EXTRACTION (highest priority)
Beta Baller has Sharpe 4.06 and 108% annualized return — the best
performing strategy in the portfolio. Extract EVERY parameter with
surgical precision directly from the JSON.

For each indicator condition found in the JSON:
  - Exact lhs-fn value (e.g. "max-drawdown")
  - Exact asset (lhs-val)
  - Exact window (from lhs-fn-params)
  - Exact threshold (rhs-val as string)
  - What market condition is this detecting?
  - Why does this specific value work?
    Reference the performance data — what would break if you
    changed window=2 to window=5? What does the 3Y Sharpe tell
    you about the robustness of these values?
  - How should this value change for different goals?
    (maximize Sharpe vs maximize return vs minimize drawdown)

Do not skip any condition. Extract all of them.
These become confidence=0.90 priors — the highest confidence
values in the entire knowledge base.

TASK 2 — STRUCTURAL COMPARISON (three top performers)
Compare Beta Baller, Extended OOS, and Sisyphus structurally.

2a. Universal patterns — what do all three share?
    For each shared pattern:
    - Exact structural feature (specific nodes/functions)
    - Why all three use it (what does it protect against?)
    - Performance evidence (what happens in periods where it matters)

2b. Beta Baller differentiators — what does it have that the others lack?
    This is likely what drives its superior Sharpe 4.06 vs 2.13/1.92.
    For each differentiator:
    - Exact structural feature
    - How it improves risk-adjusted returns specifically
    - Why the others don't have it (design choice or oversight?)

2c. Regime behavior — how does each handle:
    - Volatility spike: SVXY drops sharply (e.g. Feb 2018 style)
    - Sustained bear: SPY down 20%+ over months (e.g. 2022)
    - Normal bull: steady uptrend with occasional pullbacks

2d. Consistency analysis:
    Compare period-by-period performance (6M/1Y/2Y/3Y).
    Which strategy has the smallest variance across periods?
    A strategy with consistent 70/68/72/69 fitness beats one
    with 90/45/88/30 — identify which comes closest to consistency.

TASK 3 — 01 s90 FAILURE AUTOPSY (critical)
01 s90 50/40 maxDD returned -86.8% with Sharpe -4.51.
This is catastrophic. Work through the JSON methodically.

3a. Primary structural failure:
    What is the single most important structural decision that
    caused this outcome? Be specific — reference exact nodes.

3b. Crash guard analysis:
    Does the strategy have any crash protection?
    If yes: why did it fail to protect? What market condition
            overwhelmed it?
    If no:  what was the consequence of holding naked leverage
            through a drawdown? Calculate the approximate loss
            from the performance data.

3c. Asset concentration analysis:
    What assets does this strategy hold?
    What is the correlation profile of those assets?
    Did the combination amplify losses instead of diversifying?

3d. Triggering event hypothesis:
    Based on the 6M/1Y/2Y/3Y performance data, when did the
    catastrophic loss likely occur?
    What market event in that timeframe most plausibly caused it?

3e. Minimum fix:
    What is the SMALLEST structural change that would have
    prevented catastrophic loss? One specific addition or
    modification — not a redesign.

3f. Three NEVER DO anti-pattern lessons:
    Each must be a single specific instruction grounded in
    what you observe in this symphony's JSON.
    Not generic advice — reference specific structural elements.

TASK 4 — IMPROVEMENT ROADMAP
For each of the three top performers, identify:
  - Single highest-impact structural improvement
  - The specific risk that the current design leaves unaddressed
  - The one parameter you would test first in optimization
    (name it and give a suggested test range)

TASK 5 — CROSS-SYMPHONY SYNTHESIS
Synthesize findings across all four symphonies:

5a. What is the structural difference between a Sharpe 4.0
    strategy and a Sharpe 2.0 strategy? Be precise.

5b. What is the minimum viable crash protection structure?
    Describe it in terms of specific Composer nodes and functions.

5c. What rebalance frequency appears optimal and why?
    Reference specific performance evidence.

5d. What is the single most important lesson a strategy
    generator should learn from these four symphonies?

═══════════════════════════════════════════════════════════════════
OUTPUT FORMAT
═══════════════════════════════════════════════════════════════════
Single JSON object. No preamble. No explanation.
No markdown fences. Start with {{ and end with }}.

{{
  "beta_baller_parameters": [
    {{
      "function": "exact lhs-fn name from JSON",
      "asset": "exact lhs-val from JSON",
      "window": integer or null,
      "threshold": "exact rhs-val string from JSON or null",
      "what_it_detects": "plain English — what market condition",
      "why_this_value": "reasoning grounded in performance data",
      "confidence": 0.90,
      "goal_sensitivity": {{
        "maximize_sharpe":  "keep | adjust to X because Y",
        "maximize_return":  "keep | adjust to X because Y",
        "minimize_drawdown": "keep | tighten to X because Y"
      }}
    }}
  ],
  "structural_comparison": {{
    "universal_patterns": [
      {{
        "pattern": "exact structural description",
        "present_in": ["beta_baller", "extended_oos", "sisyphus"],
        "why_universal": "what it protects against with evidence",
        "performance_evidence": "specific numbers"
      }}
    ],
    "beta_baller_differentiators": [
      {{
        "feature": "exact structural feature",
        "impact_on_sharpe": "how it improves risk-adjusted returns",
        "evidence": "specific performance comparison",
        "why_others_lack_it": "design choice or oversight"
      }}
    ],
    "regime_behavior": {{
      "volatility_spike": {{
        "beta_baller":  "what the JSON does structurally",
        "extended_oos": "what the JSON does structurally",
        "sisyphus":     "what the JSON does structurally"
      }},
      "sustained_bear": {{
        "beta_baller":  "what the JSON does structurally",
        "extended_oos": "what the JSON does structurally",
        "sisyphus":     "what the JSON does structurally"
      }},
      "normal_bull": {{
        "beta_baller":  "what the JSON does structurally",
        "extended_oos": "what the JSON does structurally",
        "sisyphus":     "what the JSON does structurally"
      }}
    }},
    "most_consistent": {{
      "symphony": "name",
      "period_scores": {{"6M": x, "1Y": x, "2Y": x, "3Y": x}},
      "std_dev": float,
      "evidence": "why this is the most consistent"
    }}
  }},
  "failure_autopsy": {{
    "primary_structural_failure": "specific JSON element and why it caused loss",
    "crash_guard_analysis": {{
      "has_guard": true or false,
      "guard_description": "what it is or null",
      "why_it_failed": "specific reason or null",
      "consequence_of_no_guard": "calculated loss estimate or null"
    }},
    "asset_concentration": {{
      "assets_held": ["ticker1", "ticker2"],
      "correlation_profile": "how they interact",
      "amplification_effect": "did they amplify or diversify the loss"
    }},
    "triggering_event": {{
      "likely_period": "6M|1Y|2Y|3Y",
      "hypothesis": "what market event caused this",
      "evidence_from_performance": "specific numbers supporting hypothesis"
    }},
    "minimum_fix": "single specific structural change in plain English",
    "anti_pattern_lessons": [
      {{
        "id": "ap-r2-001",
        "never_do": "single specific NEVER DO instruction",
        "why_it_fails": "exact failure mode",
        "evidence": "specific reference to 01 s90 JSON or performance"
      }},
      {{
        "id": "ap-r2-002",
        "never_do": "single specific NEVER DO instruction",
        "why_it_fails": "failure mode",
        "evidence": "evidence"
      }},
      {{
        "id": "ap-r2-003",
        "never_do": "single specific NEVER DO instruction",
        "why_it_fails": "failure mode",
        "evidence": "evidence"
      }}
    ]
  }},
  "improvement_roadmap": {{
    "beta_baller": {{
      "highest_impact_change": "specific structural suggestion",
      "unaddressed_risk": "what risk the current design misses",
      "first_parameter_to_test": "exact parameter name and range e.g. window 2-6"
    }},
    "extended_oos": {{
      "highest_impact_change": "suggestion",
      "unaddressed_risk": "risk",
      "first_parameter_to_test": "parameter and range"
    }},
    "sisyphus": {{
      "highest_impact_change": "suggestion",
      "unaddressed_risk": "risk",
      "first_parameter_to_test": "parameter and range"
    }}
  }},
  "cross_symphony_lessons": [
    {{
      "lesson": "specific actionable lesson — 2-4 sentences grounded in data",
      "category": "indicator|structure|asset|risk|anti_pattern",
      "confidence": 0.0-1.0,
      "archetypes": ["ALL"] or ["SHARPE_HUNTER", "RETURN_CHASER", ...],
      "supporting_evidence": ["symphony_name: specific metric or observation"]
    }}
  ],
  "synthesis_notes": "2-3 sentences on the single most important finding. What is the one structural lesson every generated strategy must apply based on this analysis?"
}}

CRITICAL OUTPUT RULES:
  - beta_baller_parameters must include EVERY indicator/condition
    in the JSON — extract all of them, do not skip any
  - Never invent parameter values — use only exact values from JSON
  - anti_pattern_lessons must reference specific JSON elements
    or performance numbers from 01 s90 — not generic trading advice
  - Confidence assignments:
      0.90 — Beta Baller parameters (best performer, confirmed)
      0.85 — patterns in all 3 top performers
      0.75 — patterns in 2 of 3 top performers
      0.65 — single symphony observation
  - goal_sensitivity must be actionable — say exactly what to
    change and why, or say "keep at this value because X"
"""
