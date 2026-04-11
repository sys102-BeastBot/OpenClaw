"""
patch_logic_auditor.py — Two targeted fixes for logic_auditor.py.

Fix 1: _check_rhs_fixed_value_present
  Dynamic rhs-val comparisons (rhs-val = ticker, rhs-fixed-value? = false)
  are valid — stop flagging them as errors.

Fix 2: _has_max_drawdown_condition
  Broaden crash guard detection to recognise SVXY RSI/cumret signals
  and Any/All compound condition blocks, not just max-drawdown.

Run from TheBeast:
  python3 src/patch_logic_auditor.py
"""
import os, ast
from pathlib import Path

SRC = Path(__file__).parent / 'logic_auditor.py'
if not SRC.exists():
    # Try absolute path fallback
    SRC = Path.home() / '.openclaw/workspace/learning/src/logic_auditor.py'

print(f"Patching: {SRC}")
src = SRC.read_text()
original_len = len(src)

# ── Fix 1: _check_rhs_fixed_value_present ─────────────────────────────────────
OLD1 = '''def _check_rhs_fixed_value_present(composer_json: dict) -> tuple[bool, list[str]]:
    """Every conditional if-child (non-else) with rhs-val must have rhs-fixed-value? = true."""
    problems: list[str] = []
    def visit(node: dict) -> None:
        if (
            node.get("step") == "if-child"
            and not node.get("is-else-condition?", False)
            and "rhs-val" in node
        ):
            rfv = node.get("rhs-fixed-value?")
            if rfv is not True:
                problems.append(
                    f"if-child with rhs-val=\'{node.get('rhs-val')}\' "
                    f"missing or false rhs-fixed-value?"
                )
    walk_nodes(composer_json, visit)
    if problems:
        return False, problems
    return True, []'''

NEW1 = '''def _check_rhs_fixed_value_present(composer_json: dict) -> tuple[bool, list[str]]:
    """Fixed-threshold if-child nodes must have rhs-fixed-value? = true.

    Dynamic comparisons (rhs-val = asset ticker, rhs-fixed-value? = false)
    are valid — skip them. Only numeric thresholds require rhs-fixed-value? = true.
    """
    # Tickers valid as dynamic rhs-val (cross-asset comparisons)
    _DYNAMIC_TICKERS = {
        "SPY","QQQ","BIL","IEF","TLT","BND","SH","PSQ","TQQQ","SVXY",
        "UVXY","VIXM","VIXY","SVIX","UDN","UUP","DBC","EEM","PST",
        "STIP","IWM","IEI","IGIB","CORP","SQQQ","TMF","TMV","XLP",
    }
    problems: list[str] = []

    def visit(node: dict) -> None:
        if (
            node.get("step") == "if-child"
            and not node.get("is-else-condition?", False)
            and "rhs-val" in node
        ):
            rhs_val = node.get("rhs-val")
            rfv     = node.get("rhs-fixed-value?")
            # Explicitly marked dynamic — OK
            if rfv is False:
                return
            # Dynamic ticker comparison — OK
            if isinstance(rhs_val, str) and rhs_val.upper() in _DYNAMIC_TICKERS:
                return
            # Fixed threshold — must have rhs-fixed-value? = true
            if rfv is not True:
                problems.append(
                    f"if-child with rhs-val=\'{rhs_val}\' "
                    f"missing rhs-fixed-value?:true (required for fixed thresholds)"
                )

    walk_nodes(composer_json, visit)
    if problems:
        return False, problems
    return True, []'''

if OLD1 not in src:
    print("ERROR: Fix 1 anchor not found")
    exit(1)
src = src.replace(OLD1, NEW1, 1)
print("  Fix 1 applied: _check_rhs_fixed_value_present")

# ── Fix 2: _has_max_drawdown_condition ────────────────────────────────────────
OLD2 = '''def _has_max_drawdown_condition(node: dict) -> bool:
    """Return True if any if-child uses lhs-fn=max-drawdown."""
    found = [False]
    def visit(n: dict) -> None:
        if n.get("step") == "if-child" and n.get("lhs-fn") == "max-drawdown":
            found[0] = True
    walk_nodes(node, visit)
    return found[0]'''

NEW2 = '''def _has_max_drawdown_condition(node: dict) -> bool:
    """Return True if the strategy contains any recognisable crash guard.

    Recognises all confirmed crash guard patterns from the research corpus:
      1. max-drawdown on any asset (original)
      2. SVXY RSI < threshold or cumulative-return < threshold (pat-003/012)
      3. compound/all condition block — any compound condition qualifies
         (Any/All crash guards use compound/all format per RULE 9)
    """
    found = [False]

    def visit(n: dict) -> None:
        if n.get("step") != "if-child":
            return
        lhs_fn  = n.get("lhs-fn", "")
        lhs_val = n.get("lhs-val", "")
        comp    = n.get("comparator", "")

        # Original: max-drawdown on any asset
        if lhs_fn == "max-drawdown":
            found[0] = True
            return

        # SVXY RSI or cumret crash signal (pat-003, pat-012, pat-019)
        if lhs_val == "SVXY" and lhs_fn in (
            "relative-strength-index", "cumulative-return"
        ) and comp in ("lt", "lte"):
            found[0] = True
            return

        # TQQQ extreme crash circuit breaker (pat-018)
        if lhs_val == "TQQQ" and lhs_fn == "cumulative-return" and comp in ("lt", "lte"):
            found[0] = True
            return

        # Any/All compound condition block — compound/all is used for crash guards
        cond = n.get("condition", {})
        if isinstance(cond, dict) and cond.get("condition-type") in (
            "compound", "binary-compound"
        ):
            found[0] = True
            return

    walk_nodes(node, visit)
    return found[0]'''

if OLD2 not in src:
    print("ERROR: Fix 2 anchor not found")
    exit(1)
src = src.replace(OLD2, NEW2, 1)
print("  Fix 2 applied: _has_max_drawdown_condition")

# ── Write atomically ──────────────────────────────────────────────────────────
tmp = str(SRC) + '.tmp'
with open(tmp, 'w') as f:
    f.write(src)
os.replace(tmp, SRC)

ast.parse(src)
print(f"\nSyntax: OK ({len(src):,} chars, was {original_len:,})")

# Spot-checks
assert "_DYNAMIC_TICKERS" in src
assert "SVXY" in src and "relative-strength-index" in src
assert "compound" in src
print("Spot-checks: OK")
print("\n✓ logic_auditor.py patched — ready to restart R4")
