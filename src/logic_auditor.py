"""
logic_auditor.py — Deterministic hallucination and structure checker.

Runs after every Generator call before any API submission.
Pure Python — no Claude, no API calls, no file I/O.

Schema reference: Section 2.8 (logic_audit block), Section 2.3 (composer_json).
"""

from __future__ import annotations

import copy
from dataclasses import dataclass, field
from datetime import datetime, timezone
from typing import Callable, Optional

# ---------------------------------------------------------------------------
# Valid node types
# ---------------------------------------------------------------------------

VALID_STEPS: frozenset[str] = frozenset({
    "wt-cash-equal",
    "wt-cash-specified",
    "wt-inverse-vol",
    "wt-equal",
    "if",
    "if-child",
    "filter",
    "asset",
    "group",
})

# Leveraged ETFs — must not appear in defensive crash branch
LEVERAGED_TICKERS: frozenset[str] = frozenset({
    "TQQQ", "TECL", "SOXL", "SPXL", "UPRO",
})

# Full asset universe
ASSET_UNIVERSE: frozenset[str] = frozenset({
    "SVIX", "SVXY", "UVXY", "VIXM",
    "TQQQ", "TECL", "SOXL", "SPXL", "UPRO",
    "BIL", "SPY", "QQQ",
})

# Keywords that trigger crash_guard_present consistency check
CRASH_GUARD_KEYWORDS: frozenset[str] = frozenset({
    "crash", "guard", "protect",
})

WEIGHTS_EPSILON: float = 0.01

# ---------------------------------------------------------------------------
# Exceptions
# ---------------------------------------------------------------------------

class LogicAuditorError(Exception):
    """Raised when the auditor cannot run due to malformed strategy structure."""


# ---------------------------------------------------------------------------
# AuditResult dataclass
# ---------------------------------------------------------------------------

@dataclass
class AuditResult:
    """Result of a full logic audit run.

    Attributes:
        passed:       True when quarantined is False (i.e. no check failures).
        failures:     List of check names that failed.
        warnings:     Non-blocking issues. Never cause quarantine.
        checks:       Dict mapping check name → True | False | None.
                      None means the check was skipped.
        quarantined:  True if any check returned False.
    """
    passed: bool
    failures: list[str]
    warnings: list[str]
    checks: dict[str, Optional[bool]]
    quarantined: bool

    def to_dict(self) -> dict:
        """Return the logic_audit block shape for insertion into a results file."""
        return {
            "status": "QUARANTINED" if self.quarantined else "PASSED",
            "completed_at": _now_iso(),
            "checks": dict(self.checks),
            "failures": list(self.failures),
            "warnings": list(self.warnings),
            "quarantined": self.quarantined,
        }


# ---------------------------------------------------------------------------
# Shared utility: walk_nodes
# ---------------------------------------------------------------------------

def walk_nodes(node: dict, visitor: Callable[[dict], None]) -> None:
    """Depth-first walk of a composer_json tree.

    Calls visitor(node) for every node including the root.

    Args:
        node:    A composer_json node dict.
        visitor: Callable that receives each node dict.
    """
    if not isinstance(node, dict):
        return
    visitor(node)
    for child in node.get("children", []):
        walk_nodes(child, visitor)


# ---------------------------------------------------------------------------
# Main entry point
# ---------------------------------------------------------------------------

def audit_strategy(strategy: dict, asset_universe: Optional[list[str]] = None) -> AuditResult:
    """Run all logic audit checks on a strategy.

    Args:
        strategy:       Full strategy dict at PENDING status.
        asset_universe: Optional override for valid tickers. Defaults to
                        the module-level ASSET_UNIVERSE constant.

    Returns:
        AuditResult with all checks populated.

    Raises:
        LogicAuditorError: If strategy is missing the top-level strategy block.
    """
    universe = frozenset(asset_universe) if asset_universe is not None else ASSET_UNIVERSE

    try:
        strategy_block = strategy["strategy"]
    except (KeyError, TypeError) as exc:
        raise LogicAuditorError(
            f"strategy dict must contain a 'strategy' block: {exc}"
        ) from exc

    composer_json: Optional[dict] = strategy_block.get("composer_json")
    description:   Optional[dict] = strategy_block.get("description")

    failures: list[str]  = []
    warnings: list[str]  = []
    checks: dict[str, Optional[bool]] = {k: None for k in _ALL_CHECK_NAMES}

    # -----------------------------------------------------------------------
    # Empty / missing composer_json: fail all structural checks immediately
    # -----------------------------------------------------------------------
    if not composer_json:
        for name in _STRUCTURAL_CHECK_NAMES:
            checks[name] = False
            failures.append(name)
        # Add a clear message in warnings for debugging
        warnings.append("empty_json: composer_json is empty or missing")
        # Consistency checks skipped (None already set)
        return _make_result(checks, failures, warnings)

    # -----------------------------------------------------------------------
    # Structural checks
    # -----------------------------------------------------------------------
    checks["valid_node_types_only"], vn_w = _check_valid_node_types(composer_json)
    checks["if_structure_valid"],    is_w = _check_if_structure_valid(composer_json)
    checks["has_else_condition"],    ec_w = _check_has_else_condition(composer_json)
    checks["window_days_string_format"], wd_w = _check_window_days_string_format(composer_json)
    checks["weights_sum_to_100"],    ws_w = _check_weights_sum_to_100(composer_json)
    checks["all_assets_in_universe"], au_w = _check_assets_in_universe(composer_json, universe)
    checks["asset_nodes_have_children"], ac_w = _check_asset_nodes_have_children(composer_json)
    checks["rhs_fixed_value_present"], rf_w = _check_rhs_fixed_value_present(composer_json)

    for w in [vn_w, is_w, ec_w, wd_w, ws_w, au_w, ac_w, rf_w]:
        warnings.extend(w)

    # -----------------------------------------------------------------------
    # Consistency checks (description vs JSON)
    # -----------------------------------------------------------------------
    if description is None:
        # Skip all consistency checks — leave as None
        pass
    else:
        checks["crash_guard_present"], cg_w = _check_crash_guard_present(
            composer_json, description
        )
        checks["bil_in_defensive_branch"], bd_w = _check_bil_in_defensive_branch(
            composer_json, description
        )
        checks["no_leverage_in_defense"], ld_w = _check_no_leverage_in_defense(
            composer_json
        )
        for w in [cg_w, bd_w, ld_w]:
            warnings.extend(w)

    # Collect failures (False checks only; None = skipped, not a failure)
    for name, result in checks.items():
        if result is False:
            failures.append(name)

    return _make_result(checks, failures, warnings)


# ---------------------------------------------------------------------------
# Check names
# ---------------------------------------------------------------------------

_STRUCTURAL_CHECK_NAMES: tuple[str, ...] = (
    "valid_node_types_only",
    "if_structure_valid",
    "has_else_condition",
    "window_days_string_format",
    "weights_sum_to_100",
    "all_assets_in_universe",
    "asset_nodes_have_children",
    "rhs_fixed_value_present",
)

_CONSISTENCY_CHECK_NAMES: tuple[str, ...] = (
    "crash_guard_present",
    "bil_in_defensive_branch",
    "no_leverage_in_defense",
)

_ALL_CHECK_NAMES: tuple[str, ...] = _STRUCTURAL_CHECK_NAMES + _CONSISTENCY_CHECK_NAMES


# ---------------------------------------------------------------------------
# Structural checks
# ---------------------------------------------------------------------------

def _check_valid_node_types(
    composer_json: dict,
) -> tuple[bool, list[str]]:
    """All step values must be in VALID_STEPS."""
    invalid: list[str] = []

    def visit(node: dict) -> None:
        step = node.get("step")
        if step not in VALID_STEPS:
            invalid.append(str(step))

    walk_nodes(composer_json, visit)
    if invalid:
        return False, [f"Invalid node types: {invalid}"]
    return True, []


def _check_if_structure_valid(composer_json: dict) -> tuple[bool, list[str]]:
    """Every if node must have exactly one non-else if-child and exactly one else if-child.

    filter children are not subject to this check.
    """
    problems: list[str] = []

    def visit(node: dict) -> None:
        if node.get("step") == "if":
            children  = node.get("children", [])
            if_children = [c for c in children if c.get("step") == "if-child"]
            non_else  = [c for c in if_children if not c.get("is-else-condition?", False)]
            else_kids = [c for c in if_children if c.get("is-else-condition?", False)]
            if len(non_else) < 1:
                problems.append("if node has no non-else condition branch")
            if len(else_kids) != 1:
                problems.append(
                    f"if node must have exactly 1 else-condition, found {len(else_kids)}"
                )

    walk_nodes(composer_json, visit)
    if problems:
        return False, problems
    return True, []


def _check_has_else_condition(composer_json: dict) -> tuple[bool, list[str]]:
    """Every if node must have at least one if-child with is-else-condition? = true."""
    missing: list[str] = []

    def visit(node: dict) -> None:
        if node.get("step") == "if":
            children = node.get("children", [])
            has_else = any(
                c.get("is-else-condition?", False)
                for c in children
                if c.get("step") == "if-child"
            )
            if not has_else:
                missing.append("if node missing else condition")

    walk_nodes(composer_json, visit)
    if missing:
        return False, missing
    return True, []


def _check_window_days_string_format(composer_json: dict) -> tuple[bool, list[str]]:
    """wt-inverse-vol nodes must have window-days as a STRING. Fail if missing or not string."""
    problems: list[str] = []

    def visit(node: dict) -> None:
        if node.get("step") == "wt-inverse-vol":
            wd = node.get("window-days")
            if wd is None:
                problems.append("wt-inverse-vol missing window-days field")
            elif not isinstance(wd, str):
                problems.append(
                    f"wt-inverse-vol window-days must be string, got {type(wd).__name__}"
                )

    walk_nodes(composer_json, visit)
    if problems:
        return False, problems
    return True, []


def _check_weights_sum_to_100(composer_json: dict) -> tuple[bool, list[str]]:
    """wt-cash-specified children weights (num/den ratios) must sum to 1.0 ± epsilon."""
    problems: list[str] = []

    def visit(node: dict) -> None:
        if node.get("step") == "wt-cash-specified":
            children = node.get("children", [])
            total = sum(
                float(c.get("num", 0)) / float(c.get("den", 1))
                if c.get("den") else float(c.get("weight", 0))
                for c in children
            )
            if abs(total - 1.0) > WEIGHTS_EPSILON:
                problems.append(
                    f"wt-cash-specified weights sum to {total:.4f}, expected 1.0 ±{WEIGHTS_EPSILON}"
                )

    walk_nodes(composer_json, visit)
    if problems:
        return False, problems
    return True, []


def _check_assets_in_universe(
    composer_json: dict,
    universe: frozenset[str],
) -> tuple[bool, list[str]]:
    """Every ticker in asset nodes must be in the configured asset universe."""
    invalid: list[str] = []

    def visit(node: dict) -> None:
        if node.get("step") == "asset":
            ticker = node.get("ticker")
            if ticker not in universe:
                invalid.append(str(ticker) if ticker is not None else "<missing>")

    walk_nodes(composer_json, visit)
    if invalid:
        return False, [f"Tickers not in universe: {invalid}"]
    return True, []


def _check_asset_nodes_have_children(composer_json: dict) -> tuple[bool, list[str]]:
    """Every asset node must have children field = []. Warn if non-empty."""
    problems: list[str] = []
    warns:    list[str] = []

    def visit(node: dict) -> None:
        if node.get("step") == "asset":
            children = node.get("children")
            if children is None:
                problems.append(
                    f"asset node '{node.get('ticker', '?')}' missing children field"
                )
            elif len(children) > 0:
                warns.append(
                    f"asset node '{node.get('ticker', '?')}' has non-empty children (unexpected)"
                )

    walk_nodes(composer_json, visit)
    if problems:
        return False, warns + [f"asset nodes missing children: {problems}"]
    return True, warns


def _check_rhs_fixed_value_present(composer_json: dict) -> tuple[bool, list[str]]:
    """Every conditional if-child with a FIXED rhs-val must have rhs-fixed-value? = true.

    Dynamic asset comparisons (rhs-val = a ticker, e.g. "SPY", "IEF") are
    exempt — rhs-fixed-value? is correctly absent/False for those.
    """
    _SIGNAL_TICKERS = frozenset({
        "SPY", "QQQ", "TQQQ", "SVXY", "UVXY", "VIXM", "SVIX",
        "IEF", "BIL", "TLT", "BND", "SH", "PSQ", "SQQQ", "DBC",
        "VIXY", "UVIX", "EEM", "IEI", "IGIB", "CORP", "STIP",
        "SOXL", "TECL", "SPXL", "UPRO", "VIXM",
    })

    def _is_dynamic(rhs_val: str) -> bool:
        if not isinstance(rhs_val, str):
            return False
        return (rhs_val.upper() in _SIGNAL_TICKERS
                or (rhs_val.isalpha() and rhs_val.isupper() and 2 <= len(rhs_val) <= 5))

    problems: list[str] = []

    def visit(node: dict) -> None:
        if (
            node.get("step") == "if-child"
            and not node.get("is-else-condition?", False)
            and "rhs-val" in node
        ):
            rhs_val = node.get("rhs-val")
            if _is_dynamic(rhs_val):
                return  # dynamic comparison — rhs-fixed-value? legitimately absent
            rfv = node.get("rhs-fixed-value?")
            if rfv is not True:
                problems.append(
                    f"if-child with rhs-val='{rhs_val}' "
                    f"missing or false rhs-fixed-value?"
                )

    walk_nodes(composer_json, visit)
    if problems:
        return False, problems
    return True, []


# ---------------------------------------------------------------------------
# Consistency checks
# ---------------------------------------------------------------------------

def _check_crash_guard_present(
    composer_json: dict,
    description: dict,
) -> tuple[Optional[bool], list[str]]:
    """If description mentions crash/guard/protect, JSON must contain a max-drawdown if-child.

    Returns None (skip) if description does not mention crash/guard.
    """
    desc_text = _description_text(description).lower()
    mentions_guard = any(kw in desc_text for kw in CRASH_GUARD_KEYWORDS)

    if not mentions_guard:
        return None, []  # skip

    has_drawdown_guard = _has_max_drawdown_condition(composer_json)
    if not has_drawdown_guard:
        return False, [
            "Description mentions crash/guard but no max-drawdown if-condition found"
        ]
    return True, []


def _check_bil_in_defensive_branch(
    composer_json: dict,
    description: dict,
) -> tuple[Optional[bool], list[str]]:
    """If description.regime_behavior.crash mentions BIL, it must be in a non-else if-child.

    Returns None (skip) if crash regime description doesn't mention BIL.
    """
    regime    = description.get("regime_behavior", {}) or {}
    crash_desc = str(regime.get("crash", "")).lower()

    if "bil" not in crash_desc:
        return None, []  # skip

    # BIL must be in a non-else (defensive) branch
    bil_in_defensive = _bil_in_non_else_branch(composer_json)
    if not bil_in_defensive:
        return False, [
            "BIL described as crash defense but not found in a non-else defensive branch"
        ]
    return True, []


def _check_no_leverage_in_defense(
    composer_json: dict,
) -> tuple[Optional[bool], list[str]]:
    """The defensive branch of any max-drawdown guard must not contain leveraged tickers.

    Returns None (skip) if no max-drawdown guard exists.
    """
    if not _has_max_drawdown_condition(composer_json):
        return None, []  # skip — no guard to check

    leveraged_found = _leveraged_in_defensive_branch(composer_json)
    if leveraged_found:
        return False, [f"Leveraged ETFs in crash defensive branch: {leveraged_found}"]
    return True, []


# ---------------------------------------------------------------------------
# Tree traversal helpers
# ---------------------------------------------------------------------------

def _has_max_drawdown_condition(node: dict) -> bool:
    """Return True if any crash guard is present in the strategy.

    Recognises all confirmed crash guard forms:
    1. max-drawdown on any asset (original)
    2. SVXY/UVXY RSI or cumret with lt comparator
    3. compound/all condition object with 2+ conditions (Any/All format)
    4. binary-compound with crash-direction comparator
    5. Any if-child routing to BIL with a protective signal
    """
    _CRASH_ASSETS = frozenset({"SVXY", "SVIX", "UVXY", "SPY", "QQQ", "TQQQ"})
    _CRASH_FNS    = frozenset({"max-drawdown", "relative-strength-index",
                                "cumulative-return", "standard-deviation-return"})

    found = [False]

    def visit(n: dict) -> None:
        if n.get("step") != "if-child" or n.get("is-else-condition?", False):
            return

        # Form 1: max-drawdown crash guard
        # Must be short window (≤5d) OR crash-prone asset OR high threshold (>15%)
        if n.get("lhs-fn") == "max-drawdown":
            window    = n.get("lhs-fn-params", {}).get("window", 999)
            asset     = n.get("lhs-val", "")
            threshold = float(n.get("rhs-val", "0") or "0")
            crash_assets = {"SVXY", "SVIX", "UVXY", "TQQQ", "SOXL", "TECL"}
            if window <= 5 or asset in crash_assets or threshold > 15:
                found[0] = True
                return

        # Form 2: SVXY/UVXY RSI or cumret with lt comparator
        lhs_fn  = n.get("lhs-fn", "")
        lhs_val = n.get("lhs-val", "")
        if lhs_fn in _CRASH_FNS and lhs_val in _CRASH_ASSETS:
            if n.get("comparator") in ("lt", "lte"):
                found[0] = True
                return

        # Form 3: compound/all with 2+ conditions
        cond = n.get("condition", {})
        if (isinstance(cond, dict)
                and cond.get("condition-type") == "compound"
                and cond.get("operator") == "all"
                and len(cond.get("conditions", [])) >= 2):
            found[0] = True
            return

        # Form 4: binary-compound with crash-direction comparator
        if (isinstance(cond, dict)
                and cond.get("condition-type") == "binary-compound"
                and cond.get("comparator") in ("lt", "lte")):
            found[0] = True
            return

        # Form 5: routes to BIL with protective signal
        tickers: list[str] = []
        walk_nodes(n, lambda gc: (
            tickers.append(gc["ticker"])
            if gc.get("step") == "asset" and gc.get("ticker") else None
        ))
        if "BIL" in tickers and lhs_fn in _CRASH_FNS:
            found[0] = True

    walk_nodes(node, visit)
    return found[0]


def _bil_in_non_else_branch(node: dict) -> bool:
    """Return True if BIL appears in any non-else if-child branch anywhere in the tree."""
    if node.get("step") == "if":
        for child in node.get("children", []):
            if (
                child.get("step") == "if-child"
                and not child.get("is-else-condition?", False)
            ):
                tickers: list[str] = []
                walk_nodes(child, lambda n: (
                    tickers.append(n["ticker"])
                    if n.get("step") == "asset" and n.get("ticker") else None
                ))
                if "BIL" in tickers:
                    return True
            # Recurse into any nested if nodes within this child
            for grandchild in child.get("children", []):
                if _bil_in_non_else_branch(grandchild):
                    return True
    else:
        for child in node.get("children", []):
            if _bil_in_non_else_branch(child):
                return True
    return False


def _leveraged_in_defensive_branch(node: dict) -> list[str]:
    """Return leveraged tickers found in the immediate true branch of a real crash guard.

    Only flags IMMEDIATE children of the crash guard true branch — not deeply
    nested bull allocation branches below the crash guard.
    Uses same tightened crash guard definition as _has_max_drawdown_condition.
    """
    # For max-drawdown: crash-prone assets that can blow up
    _CRASH_ASSETS_DRAWDOWN = frozenset({"SVXY", "SVIX", "UVXY", "TQQQ", "SOXL", "TECL"})
    # For RSI/cumret lt: only volatility-inverse instruments whose drop = market stress
    _CRASH_ASSETS_SIGNAL   = frozenset({"SVXY", "SVIX", "UVXY"})
    found: list[str] = []

    def check_if_node(n: dict) -> None:
        if n.get("step") != "if":
            return
        for child in n.get("children", []):
            if (child.get("step") != "if-child"
                    or child.get("is-else-condition?", False)):
                continue
            lhs_fn  = child.get("lhs-fn", "")
            lhs_val = child.get("lhs-val", "")
            window  = child.get("lhs-fn-params", {}).get("window", 999)
            try:
                threshold = float(child.get("rhs-val", "0") or "0")
            except (ValueError, TypeError):
                threshold = 0.0

            is_crash_guard = False
            if lhs_fn == "max-drawdown":
                is_crash_guard = (window <= 5
                                  or lhs_val in _CRASH_ASSETS_DRAWDOWN
                                  or threshold > 15)
            elif lhs_fn in {"relative-strength-index", "cumulative-return",
                            "standard-deviation-return"}:
                if lhs_val in _CRASH_ASSETS_SIGNAL and child.get("comparator") in ("lt", "lte"):
                    is_crash_guard = True
            cond = child.get("condition", {})
            if (isinstance(cond, dict)
                    and cond.get("condition-type") == "compound"
                    and cond.get("operator") == "all"
                    and len(cond.get("conditions", [])) >= 2):
                is_crash_guard = True

            if not is_crash_guard:
                continue

            # Only check IMMEDIATE asset children of the true branch
            for grandchild in child.get("children", []):
                if (grandchild.get("step") == "asset"
                        and grandchild.get("ticker") in LEVERAGED_TICKERS):
                    found.append(grandchild["ticker"])

    walk_nodes(node, check_if_node)
    return found


def _description_text(description: dict) -> str:
    """Concatenate relevant text fields from the description block."""
    parts = []
    for key in ("summary", "logic_explanation", "archetype_rationale"):
        val = description.get(key, "")
        if val:
            parts.append(str(val))
    regime = description.get("regime_behavior", {})
    if isinstance(regime, dict):
        parts.extend(str(v) for v in regime.values())
    return " ".join(parts)


# ---------------------------------------------------------------------------
# Private helpers
# ---------------------------------------------------------------------------

def _make_result(
    checks: dict[str, Optional[bool]],
    failures: list[str],
    warnings: list[str],
) -> AuditResult:
    quarantined = len(failures) > 0
    return AuditResult(
        passed=not quarantined,
        failures=failures,
        warnings=warnings,
        checks=checks,
        quarantined=quarantined,
    )


def _now_iso() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
