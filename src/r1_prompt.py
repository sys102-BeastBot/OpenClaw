"""
r1_prompt.py — R1 Library Mining prompt template for research_phase.py

This module contains the assembled R1 prompt and the data assembly
functions that build the portfolio and community symphony blocks.

The R1 prompt is the most important in the Research Phase.
It seeds patterns.json and initial active.json lessons.
"""

from datetime import date, timedelta
from typing import Optional

# ── Period date ranges ─────────────────────────────────────────────────────────

def get_period_label(period: str) -> str:
    """Return human-readable date range for a backtest period."""
    end = date.today()
    days = {'6M': 183, '1Y': 365, '2Y': 730, '3Y': 1095}
    start = end - timedelta(days=days[period])
    return f"{start.strftime('%b %Y')} → {end.strftime('%b %Y')}"


# ── Symphony block formatters ──────────────────────────────────────────────────

def format_portfolio_symphony(sym: dict) -> str:
    """
    Format one portfolio symphony for the SECTION A block.
    Receives full JSON + 4-period backtest results.

    Args:
        sym: dict with keys:
            name, id, tree_structure, composer_json,
            periods: {period: {return, sharpe, max_drawdown,
                               r_squared, pearson_r}}
    """
    import json

    lines = [
        f"SYMPHONY: {sym['name']}",
        f"ID: {sym['id']}",
        f"STRUCTURE: {sym['tree_structure']}",
        f"JSON:",
        json.dumps(sym['composer_json'], indent=2),
        "",
        "PERFORMANCE:",
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

    lines.append("---")
    return "\n".join(lines)


def format_community_symphony(sym: dict) -> str:
    """
    Format one community symphony for the SECTION B block.
    Compact summary — structure and performance only.

    Args:
        sym: dict with keys:
            name, id, sharpe, annualized_return, max_drawdown,
            r_squared, pearson_r, tree_structure, tickers
    """
    r2      = f"r²={sym['r_squared']:.3f}" if sym.get('r_squared') is not None else "r²=n/a"
    pearson = f"pearson_r={sym['pearson_r']:.3f}" if sym.get('pearson_r') is not None else "pearson_r=n/a"
    tickers = ', '.join(sorted(set(sym.get('tickers', []))))

    return (
        f"{sym['name']} ({sym['id']}): "
        f"sharpe={sym['sharpe']:.2f}  "
        f"return={sym['annualized_return']:+.1f}%  "
        f"maxDD={sym['max_drawdown']:.1f}%  "
        f"{r2}  {pearson}\n"
        f"Structure: {sym['tree_structure']}\n"
        f"Assets: {tickers}\n"
        f"---"
    )


# ── Prompt assembly ────────────────────────────────────────────────────────────

R1_SYSTEM_PROMPT = """\
You are a quantitative analyst specializing in systematic trading \
strategies built on Composer.trade. You have deep knowledge of the \
Composer symphony JSON format, leveraged ETF behavior, volatility \
trading mechanics, and portfolio construction.

You will analyze real trading symphonies and extract actionable \
structural patterns for a strategy knowledge base. Quality and \
specificity beat quantity — one precise lesson with supporting \
evidence beats five vague observations. Every claim must be \
grounded in specific data from the symphonies provided.\
"""


def build_r1_prompt(
    portfolio_symphonies: list[dict],
    community_symphonies: list[dict],
) -> str:
    """
    Assemble the complete R1 Library Mining prompt.

    Args:
        portfolio_symphonies: List of formatted portfolio symphony dicts.
                              Each has full JSON + 4-period performance.
        community_symphonies: List of formatted community symphony dicts.
                              Structure summaries + performance only.

    Returns:
        Complete prompt string ready for Claude API.
    """
    portfolio_block = "\n\n".join(
        format_portfolio_symphony(s) for s in portfolio_symphonies
    )

    community_block = "\n\n".join(
        format_community_symphony(s) for s in community_symphonies
    )

    n_community = len(community_symphonies)
    n_portfolio = len(portfolio_symphonies)

    from r1_prompt import get_period_label as _gpl
    return R1_PROMPT_TEMPLATE.format(
        n_portfolio=n_portfolio,
        n_community=n_community,
        portfolio_block=portfolio_block,
        community_block=community_block,
        period_6m=_gpl('6M'),
        period_1y=_gpl('1Y'),
        period_2y=_gpl('2Y'),
        period_3y=_gpl('3Y'),
    )


# ── R1 Prompt Template ─────────────────────────────────────────────────────────

R1_PROMPT_TEMPLATE = """\
I am building an autonomous strategy generation system for \
Composer.trade. I need you to extract structural patterns from \
two sets of trading symphonies to seed the system's knowledge base.

The system generates strategies using this constrained asset universe:

  Volatility short: SVIX, SVXY
  Volatility long:  UVXY, VIXM
  Leveraged bull:   TQQQ, TECL, SOXL, SPXL, UPRO
  Leveraged bear:   SQQQ, SOXS, SPXS, TECS
  Safe/hedge:       BIL, SPY, QQQ

CRITICAL RISK FACTS — these must inform your analysis:
  SVXY:  Dropped 93% intraday Feb 5 2018 (Volmageddon). Never \
hold without an outer max-drawdown crash guard.
  UVXY:  Loses 75-90% annually from VIX futures roll decay in \
low-vol regimes. Only useful during volatility spikes.
  TQQQ:  2022 drawdown -80%. 3x leverage amplifies crashes \
non-linearly. Guard conditions are mandatory.
  SOXL:  2022 drawdown -90%. Most volatile 3x ETF in the universe.
  SQQQ/SPXS/SOXS/TECS: Severe negative carry in bull markets. \
Use only when a bearish signal is confirmed.
  TMF:   Fell simultaneously with equities in 2022. Historical \
equity hedge behavior is unreliable post-2022.

KNOWN HIGH-CORRELATION PAIRS (combining these adds no diversification):
  UPRO + SPXL:  r=0.98 — near identical S&P 500 products
  TQQQ + TECL:  r=0.94 — near identical tech products
  TQQQ + SOXL:  r=0.92 — both 3x tech-adjacent

When you find patterns using tickers outside the generator universe, \
flag them clearly as OUT-OF-UNIVERSE and note whether an in-universe \
ticker could serve the same role.

Performance periods use these exact date ranges:
  6M:  {period_6m}
  1Y:  {period_1y}
  2Y:  {period_2y}
  3Y:  {period_3y}

═══════════════════════════════════════════════════════════════════════
SECTION A — MY PORTFOLIO SYMPHONIES ({n_portfolio} symphonies)
Highest confidence signal — hand-curated from the community.
Treat patterns here as stronger evidence than Section B.
═══════════════════════════════════════════════════════════════════════

{portfolio_block}

═══════════════════════════════════════════════════════════════════════
SECTION B — COMMUNITY SYMPHONIES ({n_community} symphonies)
Top public symphonies by Sharpe ratio. Structure summaries only.
Use to confirm or challenge patterns found in Section A.
═══════════════════════════════════════════════════════════════════════

{community_block}

═══════════════════════════════════════════════════════════════════════
YOUR TASKS
═══════════════════════════════════════════════════════════════════════

TASK 1 — WINNING STRUCTURAL PATTERNS (8-12 patterns)
Structural decisions that appear consistently in symphonies with \
Sharpe > 2.0. For each pattern:
  - Exact structural decision (node types, functions, nesting depth)
  - Which symphonies exhibit it (IDs from both sections)
  - Performance correlation with specific numbers
  - Recommended parameter ranges with confidence
  - Whether it applies to all strategies or specific goals
  - Whether it requires in-universe tickers or flags out-of-universe

TASK 2 — LOSING STRUCTURAL PATTERNS (5-8 anti-patterns)
Structural mistakes from poor performers or known failure modes. \
For each:
  - Exact structural mistake
  - Failure mode it causes (drawdown spike, decay, whipsaw, etc.)
  - Supporting symphony evidence (IDs and specific metrics)
  - Write as a specific NEVER DO instruction
  - Whether this is in-universe or out-of-universe

TASK 3 — PARAMETER PRIORS
From Section A symphonies, extract confirmed parameter values for \
each indicator function observed. For each indicator:
  - Exact lhs-fn value (e.g. "max-drawdown", "relative-strength-index")
  - Asset it is applied to
  - Optimal window and threshold values actually observed
  - Sensitivity: does a small change cause large performance swing?
  - Whether different strategic goals benefit from different values
  - Confidence level based on how many symphonies confirm it

TASK 4 — ASSET COMBINATION INSIGHTS
  - Which asset combinations appear in top performers and why
  - Which combinations should be avoided (high correlation, \
decay interaction, regime conflict)
  - For out-of-universe assets that appear in top performers: \
what is the closest in-universe substitute?

TASK 5 — SPY CORRELATION CLASSIFICATION
Using the r² and pearson_r values from backtest data, classify \
each symphony into one of three buckets:

  HIGH CORRELATION (r² > 0.85):
    Essentially tracks SPY with leverage.
    Crashes with the market — limited diversification value.
    What structural features drive this tight SPY tracking?

  UNCORRELATED (-0.15 < pearson_r < 0.15):
    Independent return stream. Highest portfolio construction value.
    THIS IS THE MOST VALUABLE FINDING.
    What EXACTLY creates SPY independence? Be specific about nodes, \
indicators, and assets. This becomes a direct generator instruction.

  NEGATIVE CORRELATION (pearson_r < -0.85):
    Inverse SPY relationship. Extremely rare and valuable as hedge.
    Describe precisely if any found.

═══════════════════════════════════════════════════════════════════════
OUTPUT FORMAT
═══════════════════════════════════════════════════════════════════════
Output a single JSON object. No preamble. No explanation.
No markdown fences. Start with {{ and end with }}.

{{
  "winning_patterns": [
    {{
      "id": "pat-001",
      "name": "short descriptive name",
      "description": "what the structural decision is",
      "why_it_works": "data-grounded hypothesis with numbers",
      "evidence_symphony_ids": ["id1", "id2"],
      "performance_correlation": "specific metric improvement with values",
      "implementation_notes": "how to implement in Composer JSON",
      "parameter_ranges": {{"param_name": "value or range"}},
      "archetypes": ["ALL"] or ["SHARPE_HUNTER", "RETURN_CHASER", ...],
      "in_universe": true or false,
      "out_of_universe_note": null or "in-universe substitute: TICKER"
    }}
  ],
  "losing_patterns": [
    {{
      "id": "pat-bad-001",
      "name": "short name",
      "never_do": "specific NEVER DO instruction — one sentence",
      "why_it_fails": "failure mode with specific evidence",
      "historical_evidence": ["id1: metric=value because reason"],
      "archetypes_most_affected": ["ALL"] or specific,
      "in_universe": true or false
    }}
  ],
  "parameter_priors": [
    {{
      "function": "exact lhs-fn name",
      "asset": "ticker",
      "optimal_window": integer or null,
      "window_range": "e.g. 2-5 or null",
      "optimal_threshold": "string value or null",
      "threshold_range": "e.g. 8-12 or null",
      "sensitivity": "HIGH|MEDIUM|LOW",
      "goal_overrides": {{
        "high_return": {{"optimal_threshold": "13", "range": "12-15"}},
        "low_drawdown": {{"optimal_threshold": "7", "range": "5-9"}}
      }},
      "confidence": 0.0-1.0,
      "supporting_symphony_ids": ["id1", "id2"],
      "in_universe": true or false
    }}
  ],
  "asset_insights": [
    {{
      "combination": ["TICKER1", "TICKER2"],
      "verdict": "AVOID|USE|CONDITIONAL",
      "reason": "specific reason with performance evidence",
      "alternative": "what to do instead or null",
      "in_universe": true or false
    }}
  ],
  "correlation_analysis": {{
    "high_correlation": {{
      "symphony_ids": [],
      "structural_features": "what structural decisions drive SPY tracking",
      "r_squared_range": "e.g. 0.87-0.94",
      "generator_implication": "what to avoid when building uncorrelated strategies"
    }},
    "uncorrelated": {{
      "symphony_ids": [],
      "structural_features": "SPECIFIC structural decisions that create independence",
      "pearson_r_range": "e.g. -0.12 to 0.08",
      "generator_lesson": "exact actionable instruction: what structural pattern produces SPY independence"
    }},
    "negative_correlation": {{
      "symphony_ids": [],
      "structural_features": null or "describe precisely",
      "pearson_r_range": null or "range",
      "note": "none found" or "describe what was found"
    }}
  }},
  "synthesis_notes": "2-3 sentences on the single most important finding. What should the strategy generator prioritize above all else based on this analysis?"
}}

CRITICAL OUTPUT RULES:
  - Every claim must reference specific symphony IDs from the data above
  - Never invent performance numbers — only use values from the data
  - Parameter values must come from observed symphonies not general knowledge
  - confidence values: 0.50 single symphony, 0.70 two symphonies, \
0.85 three or more, 1.0 overwhelming consistent evidence
  - If a pattern only appears in out-of-universe symphonies, still \
report it but set in_universe: false and suggest the substitute
\
"""
