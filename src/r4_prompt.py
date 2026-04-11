"""
r4_prompt.py — R4 Seed Generation configuration for research_phase.py

R4 generates 24 seed strategies (6 per archetype) using the KB
seeded by R3. These seeds are backtested and their results inform
generation 0 — giving the Learner 24 strategies to learn from
before the autonomous loop starts.

R4 does NOT use a new prompt — it reuses generator_agent.py
with an is_seed=True flag and a modified mission brief that
emphasizes exploration over exploitation.

No optimizer is run on seeds — 2-period backtest only (1Y, 2Y).
Seeds are for KB seeding and parent identification, not deployment.

Cost: ~$1.80 (24 Generator calls × ~$0.075 each)
Time: ~10 minutes (24 × 25s generation)
"""

# ── Seed generation configuration ─────────────────────────────────────────────

SEED_CONFIG = {
    "count_per_archetype": 6,
    "total_seeds": 24,
    "periods": ["1Y", "2Y"],          # 2 periods only — no optimizer
    "run_optimizer": False,            # Seeds don't need optimization
    "checkpoint_every": 6,             # Save state every 6 strategies
    "stuck_alert_minutes": 5,          # Telegram alert if no progress
    "progress_alert_pct": [25, 50, 75, 100],
}

# ── Archetype order for seed generation ───────────────────────────────────────

SEED_ARCHETYPE_ORDER = [
    "SHARPE_HUNTER",   # 6 seeds
    "RETURN_CHASER",   # 6 seeds
    "RISK_MINIMIZER",  # 6 seeds
    "CONSISTENCY",     # 6 seeds
]

# ── Seed mission brief overrides ──────────────────────────────────────────────
# These override the standard archetype mission briefs in context_builder.py
# for seed generation only. They emphasize structural DIVERSITY over
# optimization — seeds should explore the strategy space widely.

SEED_MISSION_BRIEF_PREFIX = """\
SEED GENERATION MODE: This is strategy {seed_number} of {total_seeds} \
seed strategies being generated to explore the strategy space before \
the autonomous learning loop begins.

DIVERSITY INSTRUCTION: Do NOT produce a strategy similar to the \
previous seeds. Explore different structural approaches:
  - If previous seeds used 3-layer nesting, try 2-layer or 4-layer
  - If previous seeds used max-drawdown guards, try RSI or \
cumulative-return guards
  - If previous seeds used TQQQ as the core asset, try SOXL or TECL
  - Vary the rebalance frequency (daily vs 5% vs 10%)

The goal is to cover the strategy space broadly, not to find the \
best strategy. Diversity in structure is more valuable than \
optimizing any single approach at this stage.

"""

# ── How R4 uses context_builder.py ────────────────────────────────────────────

def build_seed_prompt(
    archetype: str,
    seed_number: int,
    total_seeds: int,
    generation: int,
    previous_structures: list[str],
) -> str:
    """
    Build the Generator prompt for one seed strategy.

    Prepends the diversity instruction to the standard Generator prompt.
    Injects previous seed structures so Claude knows what to avoid.

    Args:
        archetype: One of the four archetype enum values.
        seed_number: Which seed this is (1-24).
        total_seeds: Total seeds being generated (24).
        generation: Always 0 for seeds.
        previous_structures: tree_to_string() outputs of seeds already
                             generated for this archetype. Claude uses
                             these to produce diverse structures.

    Returns:
        Complete seed Generator prompt string.
    """
    from context_builder import build_generator_prompt

    # Build standard Generator prompt
    base_prompt = build_generator_prompt(archetype, generation, seed_number)

    # Build diversity section
    diversity_prefix = SEED_MISSION_BRIEF_PREFIX.format(
        seed_number=seed_number,
        total_seeds=total_seeds,
    )

    if previous_structures:
        diversity_prefix += (
            f"PREVIOUS SEED STRUCTURES (avoid repeating these):\n"
        )
        for i, struct in enumerate(previous_structures, 1):
            diversity_prefix += f"  Seed {i}: {struct}\n"
        diversity_prefix += "\n"

    return diversity_prefix + base_prompt


# ── Seed strategy metadata ─────────────────────────────────────────────────────

def make_seed_identity(
    archetype: str,
    seed_number: int,
    archetype_seed_number: int,
) -> dict:
    """
    Build the identity block for a seed strategy.
    Seeds use generation=0 and is_seed=True in lineage.

    Args:
        archetype: Archetype enum value.
        seed_number: Global seed number (1-24).
        archetype_seed_number: Seed number within archetype (1-6).

    Returns:
        Partial identity dict to merge into the strategy file.
    """
    return {
        "is_seed": True,
        "seed_source": "R4_research_phase",
        "seed_number": seed_number,
        "archetype_seed_number": archetype_seed_number,
        "generation": 0,
    }
