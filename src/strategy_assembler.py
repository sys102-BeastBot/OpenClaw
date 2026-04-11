"""
strategy_assembler.py — Assemble valid Composer JSON skeletons from pattern IDs.

The assembler's job is to solve the WIRING problem so the Generator
only needs to solve the INTELLIGENCE problem.

Given a list of pattern IDs (outer → inner) and terminal allocation
tiers, the assembler:
  1. Loads each pattern's template from patterns.json
  2. Wires them into a nested if-child chain (outer wraps inner)
  3. Attaches terminal asset nodes at each confidence tier
  4. Validates the result structurally before returning

The Generator receives this skeleton and fills in:
  - Exact parameter values (within confirmed ranges)
  - Description fields
  - Any optional refinements

This separation guarantees structural validity — no hallucinated
step types, no missing else branches, no invalid field names.

Architecture:
  Layer 0 (outermost): Mandatory crash guards — always fire first
  Layer 1: Primary regime classifier (SPY EMA 210)
  Layer 2: Confidence builders (TQQQ gate, SVXY health)
  Layer 3: Optional refinements (bond stress, vol spike)
  Terminal: Tier-based allocation based on layers confirmed

Tier allocation (default):
  TIER_1 (3+ layers confirmed): 3x leveraged (TQQQ or SOXL)
  TIER_2 (2 layers confirmed):  3x broad (SPXL or UPRO)
  TIER_3 (1 layer confirmed):   1x unlevered (SPY or QQQ)
  TIER_4 (0 layers / crash):    Cash (BIL)
  TIER_5 (vol spike override):  UVXY + VIXM (pat-006 template)

Any/All condition support (confirmed via API testing 2026-04-08):
  binary-compound/any: same indicator across multiple tickers, ANY must pass
  compound/all:        multiple independent conditions, ALL must pass
  compound/any:        multiple independent conditions, ANY must pass
  All three schemas require legacy flat fields (lhs-fn etc.) alongside
  the condition object — the API uses condition when present, falls back
  to flat fields for display/compatibility.

Schema reference: Sections 8 (patterns.json), 12 (Composer JSON rules)
"""

import copy
import json
from pathlib import Path
from typing import Optional

# ── Paths ──────────────────────────────────────────────────────────────────────
_KB_ROOT       = Path.home() / '.openclaw' / 'workspace' / 'learning' / 'kb'
_PATTERNS_PATH = _KB_ROOT / 'patterns.json'

# ── Valid Composer step types (from schema Section 12) ─────────────────────────
_VALID_STEPS = {
    'wt-cash-equal', 'wt-cash-specified', 'wt-inverse-vol',
    'wt-equal', 'if', 'if-child', 'filter', 'asset', 'group',
}

# ── Valid indicator functions (from schema Section 12) ─────────────────────────
_VALID_LHS_FNS = {
    'relative-strength-index',
    'cumulative-return',
    'moving-average-price',
    'max-drawdown',
    'standard-deviation-return',
    'exponential-moving-average-price',
    'moving-average-return',
    'standard-deviation-price',
    'current-price',
}

# ── Valid Any/All condition types (confirmed via API testing) ─────────────────
_VALID_CONDITION_TYPES  = {'binary', 'binary-compound', 'compound'}
_VALID_CONDITION_OPS    = {'any', 'all'}

# ── Asset universe (from schema Section 12.3) ──────────────────────────────────
ASSET_UNIVERSE = {
    'SVIX', 'SVXY',               # volatility short
    'UVXY', 'VIXM',               # volatility long
    'TQQQ', 'TECL', 'SOXL',       # leveraged bull — tech/semi
    'SPXL', 'UPRO',               # leveraged bull — broad
    'SQQQ', 'SOXS', 'SPXS', 'TECS',  # leveraged bear
    'BIL', 'SPY', 'QQQ',          # safe / unlevered
}

# ── Default tier terminal assets ──────────────────────────────────────────────
DEFAULT_TIERS = {
    'tier_1': ['TQQQ'],           # 3+ layers confirmed — most aggressive
    'tier_2': ['SPXL'],           # 2 layers confirmed
    'tier_3': ['SPY'],            # 1 layer confirmed
    'tier_4': ['BIL'],            # 0 layers / crash
    'tier_5': ['UVXY', 'VIXM'],   # vol spike override
}

# ── Pattern role ordering (outer → inner) ─────────────────────────────────────
# Patterns assigned a role get sorted into the correct architectural position.
# Lower number = more outer (higher priority, fires first).
ROLE_ORDER = {
    'crash_guard':       0,   # Layer 0: mandatory overrides
    'regime_router':     1,   # Layer 1: primary bull/bear split
    'momentum_selector': 2,   # Layer 2: confidence building
    'asset_rotator':     3,   # Layer 3: terminal selection
    'weighting':         4,   # Terminal: allocation weighting
}


class AssemblyError(Exception):
    """Raised when the assembler cannot produce a valid skeleton."""
    pass


# ── Pattern loader ─────────────────────────────────────────────────────────────

def load_patterns(patterns_path: Optional[Path] = None) -> dict[str, dict]:
    """Load patterns.json and return a dict keyed by pattern ID.

    Args:
        patterns_path: Override path for testing. Defaults to KB location.

    Returns:
        Dict mapping pattern ID → pattern dict.

    Raises:
        AssemblyError: If patterns file cannot be loaded or is malformed.
    """
    path = patterns_path or _PATTERNS_PATH
    try:
        with open(path) as f:
            data = json.load(f)
    except FileNotFoundError:
        raise AssemblyError(f"patterns.json not found at {path}")
    except json.JSONDecodeError as e:
        raise AssemblyError(f"patterns.json is invalid JSON: {e}")

    result = {}
    for pat in data.get('winning_patterns', []):
        pat_id = pat.get('id')
        if pat_id:
            result[pat_id] = pat
    return result


# ── Node builders ──────────────────────────────────────────────────────────────

def _make_asset_node(ticker: str) -> dict:
    """Build a single asset leaf node.

    Args:
        ticker: Asset ticker symbol.

    Returns:
        Valid Composer asset node.

    Raises:
        AssemblyError: If ticker is not in the asset universe.
    """
    if ticker not in ASSET_UNIVERSE:
        raise AssemblyError(
            f"Ticker '{ticker}' is not in the asset universe. "
            f"Valid tickers: {sorted(ASSET_UNIVERSE)}"
        )
    return {'step': 'asset', 'ticker': ticker, 'children': []}


def _make_equal_weight_node(tickers: list[str]) -> dict:
    """Build a wt-cash-equal node containing asset leaf nodes.

    Args:
        tickers: List of ticker symbols to weight equally.

    Returns:
        Valid Composer wt-cash-equal node.

    Raises:
        AssemblyError: If any ticker is not in the asset universe.
    """
    if not tickers:
        raise AssemblyError("Cannot build equal-weight node with empty ticker list")
    return {
        'step': 'wt-cash-equal',
        'children': [_make_asset_node(t) for t in tickers],
    }


def _make_invvol_node(tickers: list[str], window: str = '10') -> dict:
    """Build a wt-inverse-vol node.

    Args:
        tickers: Tickers to weight by inverse volatility.
        window: Volatility window as STRING (Composer API requires string).

    Returns:
        Valid Composer wt-inverse-vol node.

    Raises:
        AssemblyError: If window is not a string or tickers are invalid.
    """
    if not isinstance(window, str):
        raise AssemblyError(
            f"wt-inverse-vol window-days must be a string, got {type(window).__name__}"
        )
    if not tickers:
        raise AssemblyError("Cannot build invvol node with empty ticker list")
    return {
        'step': 'wt-inverse-vol',
        'window-days': window,
        'children': [_make_asset_node(t) for t in tickers],
    }


def _make_terminal_node(tickers: list[str], weighting: str = 'equal',
                         invvol_window: str = '10') -> dict:
    """Build a terminal allocation node for tickers.

    Args:
        tickers: Asset tickers for this tier.
        weighting: 'equal' for wt-cash-equal, 'invvol' for wt-inverse-vol.
        invvol_window: Window string for invvol (only used if weighting='invvol').

    Returns:
        Valid Composer allocation node or single asset node.
    """
    if len(tickers) == 1:
        return _make_asset_node(tickers[0])
    if weighting == 'invvol':
        return _make_invvol_node(tickers, invvol_window)
    return _make_equal_weight_node(tickers)


# ── Any/All condition builders ───────────────────────────────────────────────

def make_binary_condition(fn: str, ticker: str, window: int,
                           comparator: str, value) -> dict:
    """Build a single binary condition for use inside a compound condition.

    Args:
        fn:         Indicator function name (must be in _VALID_LHS_FNS).
        ticker:     Asset ticker to evaluate.
        window:     Lookback window in days (integer).
        comparator: 'gt', 'lt', 'gte', 'lte', 'eq'.
        value:      Threshold value (numeric).

    Returns:
        Binary condition dict for use in compound conditions array.

    Raises:
        AssemblyError: If fn is invalid.
    """
    if fn not in _VALID_LHS_FNS:
        raise AssemblyError(
            f"Invalid indicator function '{fn}'. "
            f"Valid: {sorted(_VALID_LHS_FNS)}"
        )
    return {
        'condition-type': 'binary',
        'lhs': {'fn': fn, 'params': {'window': window}, 'ticker': ticker},
        'comparator': comparator,
        'rhs': {'constant': value},
    }


def make_compound_condition(operator: str,
                             conditions: list[dict]) -> dict:
    """Build a compound (ALL/ANY) condition with multiple independent conditions.

    Use this when conditions test DIFFERENT indicators or DIFFERENT tickers.
    Example: SVXY RSI < 31 AND SVXY cumret < -6% AND SPY max-DD > 6%

    Args:
        operator:   'all' (every condition must pass) or
                    'any' (at least one condition must pass).
        conditions: List of binary condition dicts from make_binary_condition().

    Returns:
        Compound condition dict to set as the 'condition' field on an if-child.

    Raises:
        AssemblyError: If operator is invalid or conditions list is empty.
    """
    if operator not in _VALID_CONDITION_OPS:
        raise AssemblyError(
            f"Invalid operator '{operator}'. Must be 'all' or 'any'."
        )
    if not conditions:
        raise AssemblyError("compound condition requires at least one condition")
    return {
        'condition-type': 'compound',
        'operator': operator,
        'conditions': conditions,
    }


def make_binary_compound_condition(fn: str, tickers: list[str],
                                    window: int, comparator: str,
                                    value, operator: str = 'any') -> dict:
    """Build a binary-compound condition (same indicator across multiple tickers).

    Use this when applying the SAME indicator to MULTIPLE tickers.
    Example: RSI(10) > 75 for ANY OF [TQQQ, SPY]

    Args:
        fn:         Indicator function (applied to all tickers).
        tickers:    List of tickers to evaluate. Use '%' for wildcard.
        window:     Lookback window in days.
        comparator: 'gt', 'lt', 'gte', 'lte', 'eq'.
        value:      Threshold value (numeric).
        operator:   'any' or 'all'.

    Returns:
        binary-compound condition dict.

    Raises:
        AssemblyError: If fn invalid, tickers empty, or operator invalid.
    """
    if fn not in _VALID_LHS_FNS:
        raise AssemblyError(f"Invalid indicator function '{fn}'.")
    if not tickers:
        raise AssemblyError("binary-compound condition requires at least one ticker")
    if operator not in _VALID_CONDITION_OPS:
        raise AssemblyError(f"Invalid operator '{operator}'.")
    return {
        'condition-type': 'binary-compound',
        'operator': operator,
        'tickers': tickers,
        'lhs': {'fn': fn, 'params': {'window': window}, 'ticker': '%'},
        'comparator': comparator,
        'rhs': {'constant': value},
    }


def attach_condition(if_child: dict, condition: dict) -> dict:
    """Attach a condition object to an if-child node.

    The API requires both the condition object AND the legacy flat fields
    (lhs-fn, lhs-window-days, etc.) to be present simultaneously.
    This function adds the condition object while preserving legacy fields.

    Args:
        if_child:  An if-child node (must already have legacy lhs-fn fields).
        condition: A condition dict from make_compound_condition() or
                   make_binary_compound_condition().

    Returns:
        Copy of if_child with condition field added.

    Raises:
        AssemblyError: If if_child is missing required legacy fields.
    """
    if if_child.get('is-else-condition?'):
        raise AssemblyError("Cannot attach condition to an else if-child")
    if 'lhs-fn' not in if_child:
        raise AssemblyError(
            "if_child must have legacy lhs-fn field before attaching condition. "
            "Set lhs-fn to the first/primary condition's indicator function."
        )
    result = copy.deepcopy(if_child)
    result['condition'] = condition
    return result


# ── Template extraction and cleaning ──────────────────────────────────────────

def _extract_condition_if_child(template: dict) -> Optional[dict]:
    """Extract the condition (non-else) if-child from a pattern template.

    Pattern templates are if nodes with two if-child children.
    This extracts the condition branch (is-else-condition? = false).

    Args:
        template: Pattern template dict (must have step='if').

    Returns:
        The condition if-child dict, or None if not found.
    """
    if template.get('step') != 'if':
        return None
    for child in template.get('children', []):
        if child.get('step') == 'if-child' and not child.get('is-else-condition?', True):
            return child
    return None


def _clean_template_children(if_child: dict) -> dict:
    """Return a copy of an if-child with its children array emptied.

    The assembler fills children with the next layer or terminal node.
    This prevents accidentally inheriting the pattern's own example children.

    Args:
        if_child: The condition if-child from a pattern template.

    Returns:
        Deep copy with children set to [].
    """
    node = copy.deepcopy(if_child)
    node['children'] = []
    return node


# ── Core assembly ──────────────────────────────────────────────────────────────

def assemble_strategy(
    pattern_ids: list[str],
    tiers: Optional[dict[str, list[str]]] = None,
    weighting: str = 'equal',
    invvol_window: str = '10',
    patterns_override: Optional[dict[str, dict]] = None,
) -> dict:
    """Assemble a valid Composer JSON skeleton from pattern IDs.

    Patterns are wired outer → inner. Each pattern's condition becomes
    the true branch; the next pattern occupies the else branch until
    the innermost layer, which routes to tier terminal assets.

    Tier mapping:
      N patterns in chain → N+1 tiers
      0 patterns confirmed (all else) → tier_4 (BIL)
      1 pattern confirmed → tier_3
      2 patterns confirmed → tier_2
      3+ patterns confirmed → tier_1
      Vol spike override (pat-006/pat-009) → tier_5

    Args:
        pattern_ids: List of pattern IDs, ordered outer → inner.
                     Maximum 4 patterns recommended for readability.
                     Crash guards (role=crash_guard) are auto-sorted to front.
        tiers: Override default tier asset allocation.
               Keys: tier_1..tier_5. Values: list of tickers.
        weighting: 'equal' (wt-cash-equal) or 'invvol' (wt-inverse-vol).
        invvol_window: Window string for invvol weighting.
        patterns_override: Inject patterns dict directly (for testing).

    Returns:
        dict with keys:
          skeleton:     The assembled Composer JSON (wt-cash-equal root)
          layers:       List of pattern IDs in order used
          tier_map:     What each tier routes to
          description:  Human-readable summary of the skeleton
          warnings:     List of non-fatal issues found during assembly

    Raises:
        AssemblyError: If any pattern ID is unknown, template is invalid,
                       or assembly produces structurally invalid JSON.
    """
    if not pattern_ids:
        raise AssemblyError("pattern_ids must not be empty")
    if len(pattern_ids) > 6:
        raise AssemblyError(
            f"Too many patterns ({len(pattern_ids)}). Max 6 recommended "
            f"to avoid excessive nesting depth."
        )

    # Load patterns
    patterns = patterns_override if patterns_override is not None else load_patterns()

    # Resolve and validate pattern IDs
    resolved = []
    for pid in pattern_ids:
        if pid not in patterns:
            raise AssemblyError(
                f"Pattern '{pid}' not found in patterns.json. "
                f"Available: {sorted(patterns.keys())}"
            )
        resolved.append(patterns[pid])

    # Auto-sort: crash guards outermost, then by role order
    def _sort_key(pat: dict) -> int:
        role = pat.get('applicability', {}).get('archetypes', [])
        # Use category field for ordering
        cat = pat.get('category', 'selection')
        # Infer role from pattern name/description for ordering
        name_lower = pat['name'].lower()
        if 'crash' in name_lower or 'guard' in name_lower or 'circuit' in name_lower:
            return 0
        if 'trend' in name_lower or 'ema' in name_lower or 'regime' in name_lower:
            return 1
        if 'gate' in name_lower or 'momentum' in name_lower or 'entry' in name_lower:
            return 2
        return 3

    resolved_sorted = sorted(resolved, key=_sort_key)
    ordered_ids = [p['id'] for p in resolved_sorted]

    # Resolve tier assets
    effective_tiers = {**DEFAULT_TIERS, **(tiers or {})}

    # Validate all tier tickers
    for tier_name, ticker_list in effective_tiers.items():
        for ticker in ticker_list:
            if ticker not in ASSET_UNIVERSE:
                raise AssemblyError(
                    f"Tier '{tier_name}' contains invalid ticker '{ticker}'. "
                    f"Valid tickers: {sorted(ASSET_UNIVERSE)}"
                )

    warnings = []
    n = len(resolved_sorted)

    # Map layer count → tier
    # 0 layers confirmed → tier_4, 1 → tier_3, 2 → tier_2, 3+ → tier_1
    tier_for_depth = {
        0: 'tier_4',   # innermost else (no layers confirmed)
        1: 'tier_3',   # 1 layer confirmed
        2: 'tier_2',   # 2 layers confirmed
    }
    # 3+ layers confirmed → tier_1
    for d in range(3, n + 1):
        tier_for_depth[d] = 'tier_1'

    # Build the nested structure from inside out
    # Start with the innermost tier nodes
    def _tier_node(tier_name: str) -> dict:
        tickers = effective_tiers[tier_name]
        return _make_terminal_node(tickers, weighting, invvol_window)

    # Build from innermost to outermost
    # At each layer, the true branch routes deeper (higher confidence)
    # The else branch routes to the appropriate tier
    current_inner = None  # will be built layer by layer

    for depth in range(n, 0, -1):
        pat = resolved_sorted[depth - 1]
        template = pat.get('template', {})

        # Extract the condition if-child from this pattern's template
        condition_if_child = _extract_condition_if_child(template)
        if condition_if_child is None:
            warnings.append(
                f"Pattern {pat['id']} template has no extractable condition "
                f"if-child. Using a passthrough node."
            )
            # Build a passthrough — just route to next tier directly
            if current_inner is None:
                current_inner = _tier_node(tier_for_depth.get(depth, 'tier_1'))
            continue

        # Build the true branch (condition confirmed → go deeper or to tier_1)
        if current_inner is None:
            # Innermost layer: true branch → tier_1
            true_branch_content = _tier_node('tier_1')
        else:
            true_branch_content = current_inner

        # The condition if-child with true branch filled
        true_if_child = _clean_template_children(condition_if_child)
        true_if_child['children'] = [true_branch_content]

        # The else branch → tier for this depth
        else_tier = tier_for_depth.get(depth - 1, 'tier_4')
        else_if_child = {
            'step': 'if-child',
            'is-else-condition?': True,
            'children': [_tier_node(else_tier)],
        }

        # Assemble this layer's if node
        current_inner = {
            'step': 'if',
            'children': [true_if_child, else_if_child],
        }

    if current_inner is None:
        raise AssemblyError("Assembly produced no output — all patterns were skipped")

    # Wrap in wt-cash-equal root (standard Composer top-level container)
    skeleton = {
        'step': 'wt-cash-equal',
        'children': [current_inner],
    }

    # Build tier map for description
    tier_map = {}
    for depth in range(n + 1):
        tier_name = tier_for_depth.get(depth, 'tier_1')
        layers_confirmed = depth
        tier_map[f'{layers_confirmed}_layers'] = {
            'tier':    tier_name,
            'tickers': effective_tiers[tier_name],
        }

    # Build description
    layer_descriptions = []
    for i, pat in enumerate(resolved_sorted):
        layer_descriptions.append(f"Layer {i+1}: {pat['name']} (conf={pat['performance']['confidence']})")

    description = (
        f"Regime confidence model with {n} signal layers.\n"
        + '\n'.join(layer_descriptions)
        + f"\nTerminal tiers: "
        + ' | '.join(
            f"{v['layers_confirmed']} layers→{effective_tiers[v['tier']]} "
            for k, v in tier_map.items()
            for v in [{'layers_confirmed': int(k.split('_')[0]),
                       'tier': tier_for_depth.get(int(k.split('_')[0]), 'tier_1')}]
        )
    )

    # Final structural validation
    validation_issues = validate_skeleton(skeleton)
    if validation_issues:
        raise AssemblyError(
            f"Assembly produced structurally invalid JSON:\n"
            + '\n'.join(f"  - {i}" for i in validation_issues)
        )

    return {
        'skeleton':    skeleton,
        'layers':      ordered_ids,
        'tier_map':    tier_map,
        'description': description,
        'warnings':    warnings,
    }


# ── Structural validator ───────────────────────────────────────────────────────

def _validate_condition_object(cond: dict, path: str) -> list[str]:
    """Validate a condition object (Any/All format).

    Handles all three schemas:
      binary-compound: {condition-type, operator, tickers, lhs, comparator, rhs}
      compound:        {condition-type, operator, conditions:[binary,...]}
      binary:          {condition-type, lhs, comparator, rhs}

    Args:
        cond: The condition dict to validate.
        path: Parent path for error messages.

    Returns:
        List of issue strings. Empty = valid.
    """
    issues = []
    cpath  = f"{path}/condition"
    ctype  = cond.get('condition-type')

    if ctype not in _VALID_CONDITION_TYPES:
        issues.append(
            f"{cpath}: invalid condition-type '{ctype}'. "
            f"Valid: {sorted(_VALID_CONDITION_TYPES)}"
        )
        return issues

    if ctype == 'binary-compound':
        op      = cond.get('operator')
        tickers = cond.get('tickers', [])
        lhs     = cond.get('lhs', {})
        rhs     = cond.get('rhs', {})
        if op not in _VALID_CONDITION_OPS:
            issues.append(f"{cpath}: invalid operator '{op}'")
        if not tickers:
            issues.append(f"{cpath}: binary-compound missing tickers list")
        fn = lhs.get('fn')
        if not fn:
            issues.append(f"{cpath}/lhs: missing fn")
        elif fn not in _VALID_LHS_FNS:
            issues.append(f"{cpath}/lhs: invalid fn '{fn}'")
        if lhs.get('ticker') != '%' and lhs.get('ticker') not in (tickers + ['%']):
            issues.append(
                f"{cpath}/lhs: ticker should be '%' for binary-compound "
                f"(wildcard applies to tickers[])"
            )
        if 'constant' not in rhs and 'ticker' not in rhs:
            issues.append(f"{cpath}/rhs: missing 'constant' or 'ticker' key")

    elif ctype == 'compound':
        op         = cond.get('operator')
        conditions = cond.get('conditions', [])
        if op not in _VALID_CONDITION_OPS:
            issues.append(f"{cpath}: invalid operator '{op}'")
        if not conditions:
            issues.append(f"{cpath}: compound missing conditions list")
        for i, sub in enumerate(conditions):
            sub_issues = _validate_condition_object(sub, f"{cpath}/conditions[{i}]")
            issues.extend(sub_issues)

    elif ctype == 'binary':
        lhs = cond.get('lhs', {})
        rhs = cond.get('rhs', {})
        fn  = lhs.get('fn')
        if not fn:
            issues.append(f"{cpath}/lhs: missing fn")
        elif fn not in _VALID_LHS_FNS:
            issues.append(f"{cpath}/lhs: invalid fn '{fn}'")
        if not lhs.get('ticker'):
            issues.append(f"{cpath}/lhs: missing ticker")
        if 'constant' not in rhs and 'ticker' not in rhs:
            issues.append(f"{cpath}/rhs: missing 'constant' or 'ticker' key")

    return issues


def validate_skeleton(node: dict, path: str = 'root') -> list[str]:
    """Recursively validate a Composer JSON node for API compatibility.

    Checks:
      - step is a valid Composer step type
      - if nodes have exactly 2 if-child children (one true, one else)
      - if-child nodes have is-else-condition? field
      - asset nodes have ticker in ASSET_UNIVERSE and empty children
      - wt-inverse-vol nodes have window-days as a string
      - lhs-fn is a valid indicator function
      - rhs-fixed-value? is present when rhs-val is a fixed string
      - No 'comment' or other invalid step types

    Args:
        node: Composer JSON node dict to validate.
        path: Current path string for error messages.

    Returns:
        List of issue strings. Empty list means valid.
    """
    issues = []

    step = node.get('step', 'MISSING')
    if step not in _VALID_STEPS:
        issues.append(f"{path}: invalid step '{step}'")
        return issues  # Cannot validate further without valid step

    children = node.get('children', [])

    # Validate 'if' nodes
    if step == 'if':
        if len(children) != 2:
            issues.append(
                f"{path}: if node must have exactly 2 children, "
                f"got {len(children)}"
            )
        else:
            has_condition = any(
                c.get('step') == 'if-child' and not c.get('is-else-condition?', True)
                for c in children
            )
            has_else = any(
                c.get('step') == 'if-child' and c.get('is-else-condition?', False)
                for c in children
            )
            if not has_condition:
                issues.append(f"{path}: if node missing condition if-child")
            if not has_else:
                issues.append(f"{path}: if node missing else if-child")

    # Validate 'if-child' nodes
    elif step == 'if-child':
        if 'is-else-condition?' not in node:
            issues.append(f"{path}: if-child missing is-else-condition? field")
        is_else = node.get('is-else-condition?', False)
        if not is_else:
            # Condition branch: validate condition object OR legacy flat fields
            condition_obj = node.get('condition')
            lhs_fn        = node.get('lhs-fn')

            if condition_obj:
                # Validate the condition object structure
                issues.extend(_validate_condition_object(condition_obj, path))
                # Legacy lhs-fn still required alongside condition object
                if not lhs_fn:
                    issues.append(
                        f"{path}: condition if-child has condition object but "
                        f"missing legacy lhs-fn field (required by API)"
                    )
            else:
                # Legacy-only path: lhs-fn required
                if not lhs_fn:
                    issues.append(f"{path}: condition if-child missing lhs-fn")
                elif lhs_fn not in _VALID_LHS_FNS:
                    issues.append(f"{path}: invalid lhs-fn '{lhs_fn}'")

            # Check lhs-fn-params has window-days not window (when present)
            params = node.get('lhs-fn-params', {})
            if 'window' in params and 'window-days' not in params:
                issues.append(
                    f"{path}: lhs-fn-params has 'window' key — "
                    f"must be 'window-days'"
                )
            # rhs-fixed-value? required for fixed comparisons (legacy path)
            if node.get('rhs-val') and not condition_obj and 'rhs-fixed-value?' not in node:
                issues.append(
                    f"{path}: if-child with rhs-val missing rhs-fixed-value?"
                )

    # Validate 'asset' nodes
    elif step == 'asset':
        ticker = node.get('ticker')
        if not ticker:
            issues.append(f"{path}: asset node missing ticker")
        elif ticker not in ASSET_UNIVERSE:
            issues.append(f"{path}: ticker '{ticker}' not in asset universe")
        if children:
            issues.append(f"{path}: asset node must have empty children array")

    # Validate 'wt-inverse-vol' nodes
    elif step == 'wt-inverse-vol':
        wd = node.get('window-days')
        if wd is None:
            issues.append(f"{path}: wt-inverse-vol missing window-days")
        elif not isinstance(wd, str):
            issues.append(
                f"{path}: wt-inverse-vol window-days must be a string, "
                f"got {type(wd).__name__}"
            )

    # Recurse into children
    for i, child in enumerate(children):
        child_path = f"{path}/children[{i}]"
        issues.extend(validate_skeleton(child, child_path))

    return issues


# ── Seed plan builder ──────────────────────────────────────────────────────────

def build_r4_seed_plan(patterns_override: Optional[dict[str, dict]] = None) -> list[dict]:
    """Build the 20 R4 seed strategy specifications.

    Produces a diverse set of regime confidence model variants
    covering the archetype space. Each seed specifies:
      - pattern_ids: layers to combine (outer → inner)
      - tiers: terminal asset allocation per tier
      - archetype: which archetype this seed targets
      - description: what regime detection approach this covers

    The assembler turns each spec into a validated skeleton.
    The Generator fills in exact parameter values.

    Returns:
        List of 20 seed spec dicts with keys:
          seed_number, archetype, pattern_ids, tiers,
          weighting, invvol_window, description
    """
    seeds = [
        # ── SHARPE_HUNTER × 5 ─────────────────────────────────────────────────
        {
            'seed_number': 1,
            'archetype': 'SHARPE_HUNTER',
            'pattern_ids': ['pat-004', 'pat-001', 'pat-005'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['TQQQ'], 'tier_2': ['SPXL'],
                      'tier_3': ['SPY']},
            'weighting': 'equal',
            'invvol_window': '10',
            'description': 'Classic 3-layer: EMA210 trend + TQQQ momentum + BIL/IEF rate stress',
        },
        {
            'seed_number': 2,
            'archetype': 'SHARPE_HUNTER',
            'pattern_ids': ['pat-003', 'pat-004', 'pat-001'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['SOXL'], 'tier_2': ['TQQQ'],
                      'tier_3': ['QQQ']},
            'weighting': 'invvol',
            'invvol_window': '10',
            'description': 'Crash guard outer + trend + momentum, invvol weighting, SOXL as top tier',
        },
        {
            'seed_number': 3,
            'archetype': 'SHARPE_HUNTER',
            'pattern_ids': ['pat-004', 'pat-012', 'pat-001'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['TQQQ'], 'tier_2': ['SPXL'],
                      'tier_3': ['SPY']},
            'weighting': 'equal',
            'invvol_window': '10',
            'description': 'EMA210 + SVXY triple compound crash guard + TQQQ gate',
        },
        {
            'seed_number': 4,
            'archetype': 'SHARPE_HUNTER',
            'pattern_ids': ['pat-004', 'pat-001', 'pat-009'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['TQQQ'], 'tier_2': ['QQQ'],
                      'tier_3': ['SPY'], 'tier_5': ['UVXY', 'VIXM']},
            'weighting': 'equal',
            'invvol_window': '10',
            'description': 'EMA210 + TQQQ gate + UVXY spike detector, vol override tier',
        },
        {
            'seed_number': 5,
            'archetype': 'SHARPE_HUNTER',
            'pattern_ids': ['pat-016', 'pat-001', 'pat-019'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['TQQQ'], 'tier_2': ['SPXL'],
                      'tier_3': ['SPY']},
            'weighting': 'equal',
            'invvol_window': '10',
            'description': 'Dual timeframe SPY MA3+EMA210 + TQQQ gate + SVXY health check',
        },

        # ── RISK_MINIMIZER × 5 ────────────────────────────────────────────────
        {
            'seed_number': 6,
            'archetype': 'RISK_MINIMIZER',
            'pattern_ids': ['pat-012', 'pat-007', 'pat-004'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['SPXL'], 'tier_2': ['SPY'],
                      'tier_3': ['QQQ'], 'tier_4': ['BIL']},
            'weighting': 'equal',
            'invvol_window': '10',
            'description': 'SVXY triple guard + SPY max-DD floor + EMA210, conservative tiers',
        },
        {
            'seed_number': 7,
            'archetype': 'RISK_MINIMIZER',
            'pattern_ids': ['pat-003', 'pat-018', 'pat-004'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['UPRO'], 'tier_2': ['SPY'],
                      'tier_3': ['QQQ']},
            'weighting': 'equal',
            'invvol_window': '10',
            'description': 'SVXY crash guard + TQQQ -33% circuit breaker + EMA210 trend',
        },
        {
            'seed_number': 8,
            'archetype': 'RISK_MINIMIZER',
            'pattern_ids': ['pat-012', 'pat-009', 'pat-001'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['TQQQ'], 'tier_2': ['SPY'],
                      'tier_3': ['BIL'], 'tier_5': ['UVXY', 'VIXM']},
            'weighting': 'equal',
            'invvol_window': '10',
            'description': 'SVXY compound guard + UVXY spike detector + TQQQ gate',
        },
        {
            'seed_number': 9,
            'archetype': 'RISK_MINIMIZER',
            'pattern_ids': ['pat-007', 'pat-004', 'pat-017'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['SPXL'], 'tier_2': ['QQQ'],
                      'tier_3': ['SPY']},
            'weighting': 'equal',
            'invvol_window': '10',
            'description': 'Max-DD floor + EMA210 + BND RSI(45) sustained bond stress',
        },
        {
            'seed_number': 10,
            'archetype': 'RISK_MINIMIZER',
            'pattern_ids': ['pat-003', 'pat-004', 'pat-010'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['UPRO'], 'tier_2': ['SPY'],
                      'tier_3': ['BIL']},
            'weighting': 'equal',
            'invvol_window': '10',
            'description': 'SVXY guard + EMA210 + SPY RSI overbought exit',
        },

        # ── CONSISTENCY × 5 ───────────────────────────────────────────────────
        {
            'seed_number': 11,
            'archetype': 'CONSISTENCY',
            'pattern_ids': ['pat-004', 'pat-005', 'pat-001'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['TQQQ'], 'tier_2': ['SPY'],
                      'tier_3': ['QQQ']},
            'weighting': 'equal',
            'invvol_window': '10',
            'description': 'EMA210 + BIL/IEF rate stress (leading signal) + TQQQ gate',
        },
        {
            'seed_number': 12,
            'archetype': 'CONSISTENCY',
            'pattern_ids': ['pat-004', 'pat-001', 'pat-013'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['TQQQ'], 'tier_2': ['SPXL'],
                      'tier_3': ['SPY'], 'tier_5': ['UVXY', 'VIXM']},
            'weighting': 'equal',
            'invvol_window': '10',
            'description': 'EMA210 + TQQQ gate + UVXY MA vs VIXM vol trend signal',
        },
        {
            'seed_number': 13,
            'archetype': 'CONSISTENCY',
            'pattern_ids': ['pat-012', 'pat-004', 'pat-005'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['SPXL'], 'tier_2': ['SPY'],
                      'tier_3': ['QQQ']},
            'weighting': 'equal',
            'invvol_window': '10',
            'description': 'SVXY compound guard + EMA210 + BIL/IEF bond stress',
        },
        {
            'seed_number': 14,
            'archetype': 'CONSISTENCY',
            'pattern_ids': ['pat-003', 'pat-016', 'pat-001'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['TQQQ'], 'tier_2': ['SPXL'],
                      'tier_3': ['SPY']},
            'weighting': 'equal',
            'invvol_window': '10',
            'description': 'SVXY guard + SPY dual timeframe (MA3+EMA210) + TQQQ gate',
        },
        {
            'seed_number': 15,
            'archetype': 'CONSISTENCY',
            'pattern_ids': ['pat-007', 'pat-004', 'pat-019'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['TQQQ'], 'tier_2': ['SPY'],
                      'tier_3': ['QQQ']},
            'weighting': 'equal',
            'invvol_window': '10',
            'description': 'Max-DD floor + EMA210 + SVXY RSI health confirmation',
        },

        # ── RETURN_CHASER × 5 ─────────────────────────────────────────────────
        {
            'seed_number': 16,
            'archetype': 'RETURN_CHASER',
            'pattern_ids': ['pat-004', 'pat-001'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['TQQQ'], 'tier_2': ['SOXL'],
                      'tier_3': ['SPY']},
            'weighting': 'invvol',
            'invvol_window': '10',
            'description': 'Minimal 2-layer: EMA210 + TQQQ gate, invvol between TQQQ/SOXL',
        },
        {
            'seed_number': 17,
            'archetype': 'RETURN_CHASER',
            'pattern_ids': ['pat-004', 'pat-001', 'pat-019'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['TQQQ'], 'tier_2': ['TECL'],
                      'tier_3': ['SPXL']},
            'weighting': 'invvol',
            'invvol_window': '10',
            'description': 'EMA210 + TQQQ gate + SVXY health, aggressive tech tiers',
        },
        {
            'seed_number': 18,
            'archetype': 'RETURN_CHASER',
            'pattern_ids': ['pat-003', 'pat-001', 'pat-004'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['SOXL'], 'tier_2': ['TQQQ'],
                      'tier_3': ['SPXL']},
            'weighting': 'invvol',
            'invvol_window': '10',
            'description': 'SVXY crash guard + TQQQ momentum first + EMA210 confirmation',
        },
        {
            'seed_number': 19,
            'archetype': 'RETURN_CHASER',
            'pattern_ids': ['pat-004', 'pat-001', 'pat-015'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['TQQQ'], 'tier_2': ['TECL'],
                      'tier_3': ['SPY'], 'tier_5': ['UVXY', 'VIXM']},
            'weighting': 'equal',
            'invvol_window': '10',
            'description': 'EMA210 + TQQQ gate + UVXY RSI 84 exhaustion exit',
        },
        {
            'seed_number': 20,
            'archetype': 'RETURN_CHASER',
            'pattern_ids': ['pat-012', 'pat-001', 'pat-004'],
            'tiers': {**DEFAULT_TIERS, 'tier_1': ['TQQQ'], 'tier_2': ['SOXL'],
                      'tier_3': ['SPXL']},
            'weighting': 'invvol',
            'invvol_window': '10',
            'description': 'SVXY compound triple guard + TQQQ momentum + EMA210 macro filter',
        },
    ]

    return seeds


def assemble_all_seeds(
    patterns_override: Optional[dict[str, dict]] = None,
) -> list[dict]:
    """Assemble all 20 R4 seed skeletons.

    Runs build_r4_seed_plan() then assemble_strategy() on each spec.
    Returns results with assembled skeletons. Failed assemblies are
    included with error field set rather than raising.

    Args:
        patterns_override: Inject patterns dict directly (for testing).

    Returns:
        List of result dicts, one per seed:
          seed_number, archetype, description, status ('ok'|'error'),
          result (assemble_strategy output or None), error (str or None)
    """
    plan = build_r4_seed_plan()
    results = []

    for spec in plan:
        try:
            result = assemble_strategy(
                pattern_ids=spec['pattern_ids'],
                tiers=spec.get('tiers'),
                weighting=spec.get('weighting', 'equal'),
                invvol_window=spec.get('invvol_window', '10'),
                patterns_override=patterns_override,
            )
            results.append({
                'seed_number': spec['seed_number'],
                'archetype':   spec['archetype'],
                'description': spec['description'],
                'pattern_ids': spec['pattern_ids'],
                'status':      'ok',
                'result':      result,
                'error':       None,
            })
        except AssemblyError as e:
            results.append({
                'seed_number': spec['seed_number'],
                'archetype':   spec['archetype'],
                'description': spec['description'],
                'pattern_ids': spec['pattern_ids'],
                'status':      'error',
                'result':      None,
                'error':       str(e),
            })

    return results
