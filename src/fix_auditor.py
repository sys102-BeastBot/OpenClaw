import os

src_path = '/home/sys102/.openclaw/workspace/learning/src/logic_auditor.py'
with open(src_path) as f:
    src = f.read()

# ── Fix 1: _check_rhs_fixed_value_present ─────────────────────────────────────
OLD1 = 'def _check_rhs_fixed_value_present(composer_json: dict) -> tuple[bool, list[str]]:\n    """Every conditional if-child (non-else) with rhs-val must have rhs-fixed-value? = true."""\n    problems: list[str] = []\n\n    def visit(node: dict) -> None:\n        if (\n            node.get("step") == "if-child"\n            and not node.get("is-else-condition?", False)\n            and "rhs-val" in node\n        ):\n            rfv = node.get("rhs-fixed-value?")\n            if rfv is not True:\n                problems.append(\n                    f"if-child with rhs-val=\'{node.get(\'rhs-val\')}\' "\n                    f"missing or false rhs-fixed-value?"\n                )\n\n    walk_nodes(composer_json, visit)\n    if problems:\n        return False, problems\n    return True, []\n\n\n# ---------------------------------------------------------------------------\n# Consistency checks\n# ---------------------------------------------------------------------------\n'

NEW1 = 'def _check_rhs_fixed_value_present(composer_json: dict) -> tuple[bool, list[str]]:\n    """Every conditional if-child with a FIXED rhs-val must have rhs-fixed-value? = true.\n\n    Dynamic asset comparisons (rhs-val = a ticker, e.g. "SPY", "IEF") are\n    exempt — rhs-fixed-value? is correctly absent/False for those.\n    """\n    _SIGNAL_TICKERS = frozenset({\n        "SPY", "QQQ", "TQQQ", "SVXY", "UVXY", "VIXM", "SVIX",\n        "IEF", "BIL", "TLT", "BND", "SH", "PSQ", "SQQQ", "DBC",\n        "VIXY", "UVIX", "EEM", "IEI", "IGIB", "CORP", "STIP",\n        "SOXL", "TECL", "SPXL", "UPRO", "VIXM",\n    })\n\n    def _is_dynamic(rhs_val: str) -> bool:\n        if not isinstance(rhs_val, str):\n            return False\n        return (rhs_val.upper() in _SIGNAL_TICKERS\n                or (rhs_val.isalpha() and rhs_val.isupper() and 2 <= len(rhs_val) <= 5))\n\n    problems: list[str] = []\n\n    def visit(node: dict) -> None:\n        if (\n            node.get("step") == "if-child"\n            and not node.get("is-else-condition?", False)\n            and "rhs-val" in node\n        ):\n            rhs_val = node.get("rhs-val")\n            if _is_dynamic(rhs_val):\n                return  # dynamic comparison — rhs-fixed-value? legitimately absent\n            rfv = node.get("rhs-fixed-value?")\n            if rfv is not True:\n                problems.append(\n                    f"if-child with rhs-val=\'{rhs_val}\' "\n                    f"missing or false rhs-fixed-value?"\n                )\n\n    walk_nodes(composer_json, visit)\n    if problems:\n        return False, problems\n    return True, []\n\n\n# ---------------------------------------------------------------------------\n# Consistency checks\n# ---------------------------------------------------------------------------\n'

assert OLD1 in src, f"Fix 1 anchor not found — len={len(OLD1)}"
src = src.replace(OLD1, NEW1, 1)
print("Fix 1 applied: _check_rhs_fixed_value_present")

# ── Fix 2: _has_max_drawdown_condition ────────────────────────────────────────
OLD2 = 'def _has_max_drawdown_condition(node: dict) -> bool:\n    """Return True if any if-child uses lhs-fn=max-drawdown."""\n    found = [False]\n\n    def visit(n: dict) -> None:\n        if n.get("step") == "if-child" and n.get("lhs-fn") == "max-drawdown":\n            found[0] = True\n\n    walk_nodes(node, visit)\n    return found[0]\n\n'

NEW2 = 'def _has_max_drawdown_condition(node: dict) -> bool:\n    """Return True if any crash guard is present in the strategy.\n\n    Recognises all confirmed crash guard forms:\n    1. max-drawdown on any asset (original)\n    2. SVXY/UVXY RSI or cumret with lt comparator\n    3. compound/all condition object with 2+ conditions (Any/All format)\n    4. binary-compound with crash-direction comparator\n    5. Any if-child routing to BIL with a protective signal\n    """\n    _CRASH_ASSETS = frozenset({"SVXY", "SVIX", "UVXY", "SPY", "QQQ", "TQQQ"})\n    _CRASH_FNS    = frozenset({"max-drawdown", "relative-strength-index",\n                                "cumulative-return", "standard-deviation-return"})\n\n    found = [False]\n\n    def visit(n: dict) -> None:\n        if n.get("step") != "if-child" or n.get("is-else-condition?", False):\n            return\n\n        # Form 1: legacy max-drawdown\n        if n.get("lhs-fn") == "max-drawdown":\n            found[0] = True\n            return\n\n        # Form 2: SVXY/UVXY RSI or cumret with lt comparator\n        lhs_fn  = n.get("lhs-fn", "")\n        lhs_val = n.get("lhs-val", "")\n        if lhs_fn in _CRASH_FNS and lhs_val in _CRASH_ASSETS:\n            if n.get("comparator") in ("lt", "lte"):\n                found[0] = True\n                return\n\n        # Form 3: compound/all with 2+ conditions\n        cond = n.get("condition", {})\n        if (isinstance(cond, dict)\n                and cond.get("condition-type") == "compound"\n                and cond.get("operator") == "all"\n                and len(cond.get("conditions", [])) >= 2):\n            found[0] = True\n            return\n\n        # Form 4: binary-compound with crash-direction comparator\n        if (isinstance(cond, dict)\n                and cond.get("condition-type") == "binary-compound"\n                and cond.get("comparator") in ("lt", "lte")):\n            found[0] = True\n            return\n\n        # Form 5: routes to BIL with protective signal\n        tickers: list[str] = []\n        walk_nodes(n, lambda gc: (\n            tickers.append(gc["ticker"])\n            if gc.get("step") == "asset" and gc.get("ticker") else None\n        ))\n        if "BIL" in tickers and lhs_fn in _CRASH_FNS:\n            found[0] = True\n\n    walk_nodes(node, visit)\n    return found[0]\n\n'

assert OLD2 in src, f"Fix 2 anchor not found — len={len(OLD2)}"
src = src.replace(OLD2, NEW2, 1)
print("Fix 2 applied: _has_max_drawdown_condition")

# Validate syntax
import ast
ast.parse(src)
print("Syntax: OK")

# Write atomically
tmp = src_path + '.tmp'
with open(tmp, 'w') as f:
    f.write(src)
os.replace(tmp, src_path)
print(f"Written to {src_path} ({src.count(chr(10))+1} lines)")

# Quick verify
checks = [
    ("_is_dynamic present",        "_is_dynamic" in src),
    ("compound/all form present",  "condition-type.*compound" in src or "Form 3" in src),
    ("SVXY crash form present",    "Form 2" in src),
    ("BIL route form present",     "Form 5" in src),
]
for label, ok in checks:
    print(f"  {'✓' if ok else '✗'} {label}")
