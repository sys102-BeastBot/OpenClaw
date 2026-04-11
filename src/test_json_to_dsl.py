"""
test_json_to_dsl.py — Unit tests for json_to_dsl_converter.py

Tests every node type and every condition schema with real JSON samples.
Run: python3 test_json_to_dsl.py

Tests are structured as:
  - Unit tests (individual node → DSL snippet)
  - Integration tests (full symphony JSON → DSL string)
  - Compound condition tests (all three Sisyphus schemas)
  - Edge case tests (empty children, unknown nodes, rhs-fn dynamic)
"""

import sys
import json
import textwrap
from json_to_dsl_converter import (
    json_to_dsl,
    render_node,
    render_condition,
    extract_condition_from_if_child,
    ticker_to_dsl,
)

# ── Test harness ───────────────────────────────────────────────────────────────

PASS = 0
FAIL = 0

def check(label: str, got: str, expected: str):
    global PASS, FAIL
    got_s = got.strip()
    exp_s = expected.strip()
    if got_s == exp_s:
        print(f"  ✓  {label}")
        PASS += 1
    else:
        print(f"  ✗  {label}")
        print(f"     expected: {exp_s!r}")
        print(f"     got:      {got_s!r}")
        FAIL += 1

def check_contains(label: str, got: str, fragment: str):
    global PASS, FAIL
    if fragment in got:
        print(f"  ✓  {label}")
        PASS += 1
    else:
        print(f"  ✗  {label}")
        print(f"     expected fragment: {fragment!r}")
        print(f"     in output:         {got!r}")
        FAIL += 1

def section(title: str):
    print(f"\n{'─'*60}")
    print(f"  {title}")
    print(f"{'─'*60}")


# ── Section 1: Ticker normalisation ───────────────────────────────────────────

section("1. Ticker normalisation")

check("bare ticker",
      ticker_to_dsl("TQQQ"),
      '"EQUITIES::TQQQ//USD"')

check("already qualified ticker passes through",
      ticker_to_dsl("EQUITIES::SPY//USD"),
      '"EQUITIES::SPY//USD"')


# ── Section 2: Asset node ──────────────────────────────────────────────────────

section("2. Asset node")

check("simple asset",
      render_node({"step": "asset", "ticker": "BIL", "children": []}, indent=0),
      '(asset "EQUITIES::BIL//USD" "BIL")')

check("asset with weight (wt-cash-specified child) — weight stripped from node",
      render_node({
          "step": "asset", "ticker": "TQQQ",
          "weight": {"num": 60, "den": 100}, "children": []
      }, indent=0),
      '(asset "EQUITIES::TQQQ//USD" "TQQQ")')


# ── Section 3: Weight nodes ────────────────────────────────────────────────────

section("3. Weight nodes")

wt_equal_node = {
    "step": "wt-cash-equal",
    "children": [
        {"step": "asset", "ticker": "SPY", "children": []},
        {"step": "asset", "ticker": "BIL", "children": []},
    ]
}
dsl = render_node(wt_equal_node, indent=0)
check_contains("wt-cash-equal opens with (weight-equal", dsl, "(weight-equal")
check_contains("wt-cash-equal contains SPY", dsl, '"EQUITIES::SPY//USD"')
check_contains("wt-cash-equal contains BIL", dsl, '"EQUITIES::BIL//USD"')

check("wt-equal alias maps to weight-equal",
      render_node({"step": "wt-equal",
                   "children": [{"step": "asset", "ticker": "QQQ", "children": []}]
                  }, indent=0).split("\n")[0],
      "(weight-equal [")

wt_inv_vol_node = {
    "step": "wt-inverse-vol",
    "window-days": "15",
    "children": [
        {"step": "asset", "ticker": "UPRO", "children": []},
        {"step": "asset", "ticker": "SVIX", "children": []},
    ]
}
dsl = render_node(wt_inv_vol_node, indent=0)
check_contains("wt-inverse-vol has window", dsl, "(weight-inverse-vol 15")

wt_spec_node = {
    "step": "wt-cash-specified",
    "children": [
        {"step": "asset", "ticker": "TQQQ",
         "weight": {"num": 70, "den": 100}, "children": []},
        {"step": "asset", "ticker": "BIL",
         "weight": {"num": 30, "den": 100}, "children": []},
    ]
}
dsl = render_node(wt_spec_node, indent=0)
check_contains("wt-cash-specified opening", dsl, "(weight-specified {")

# Positional form: non-asset children (filter + asset) — confirmed from Beta Baller
wt_spec_mixed = {
    "step": "wt-cash-specified",
    "children": [
        {"step": "filter",
         "sort-by-fn": "cumulative-return", "sort-by-fn-params": {"window": 5},
         "select-fn": "top", "select-n": "1",
         "weight": {"num": 50, "den": 100},
         "children": [{"step": "asset", "ticker": "TQQQ", "children": []}]},
        {"step": "filter",
         "sort-by-fn": "cumulative-return", "sort-by-fn-params": {"window": 5},
         "select-fn": "top", "select-n": "1",
         "weight": {"num": 0, "den": 100},
         "children": [{"step": "asset", "ticker": "SOXL", "children": []}]},
        {"step": "asset", "ticker": "UUP",
         "weight": {"num": 50, "den": 100}, "children": []},
    ]
}
dsl_mixed = render_node(wt_spec_mixed, indent=0)
check_contains("mixed wt-cash-specified uses positional list", dsl_mixed, "(weight-specified [50 0 50]")
check_contains("mixed wt-cash-specified has filter child", dsl_mixed, "(filter")
check_contains("wt-cash-specified 70% weight in dict", dsl, '"TQQQ" 70')
check_contains("wt-cash-specified 30% weight in dict", dsl, '"BIL" 30')


# ── Section 4: Filter node ─────────────────────────────────────────────────────

section("4. Filter node")

filter_node = {
    "step": "filter",
    "sort-by-fn": "cumulative-return",
    "sort-by-fn-params": {"window": 20},
    "select-fn": "top",
    "select-n": "1",
    "children": [
        {"step": "asset", "ticker": "TQQQ", "children": []},
        {"step": "asset", "ticker": "SOXL", "children": []},
        {"step": "asset", "ticker": "UPRO", "children": []},
    ]
}
dsl = render_node(filter_node, indent=0)
check_contains("filter cumulative-return 20", dsl, "(filter (cumulative-return 20)")
check_contains("filter select-top 1", dsl, "(select-top 1)")
check_contains("filter contains TQQQ", dsl, '"EQUITIES::TQQQ//USD"')

filter_bottom_node = {
    "step": "filter",
    "sort-by-fn": "standard-deviation-return",
    "sort-by-fn-params": {"window": 15},
    "select-fn": "bottom",
    "select-n": "2",
    "children": [
        {"step": "asset", "ticker": "SPY", "children": []},
        {"step": "asset", "ticker": "QQQ", "children": []},
    ]
}
dsl = render_node(filter_bottom_node, indent=0)
check_contains("filter std-dev bottom", dsl, "(filter (standard-deviation-return 15)")
check_contains("filter select-bottom 2", dsl, "(select-bottom 2)")


# ── Section 5: Simple if condition ────────────────────────────────────────────

section("5. Simple if / if-child (flat layout)")

simple_if = {
    "step": "if",
    "children": [
        {
            "step": "if-child",
            "is-else-condition?": False,
            "lhs-fn": "relative-strength-index",
            "lhs-fn-params": {"window": 10},
            "lhs-val": "QQQ",
            "comparator": "gt",
            "rhs-val": "79",
            "rhs-fixed-value?": True,
            "children": [{"step": "asset", "ticker": "VIXM", "children": []}]
        },
        {
            "step": "if-child",
            "is-else-condition?": True,
            "children": [{"step": "asset", "ticker": "UPRO", "children": []}]
        }
    ]
}
dsl = render_node(simple_if, indent=0)
check_contains("simple if opens with (if", dsl, "(if ")
check_contains("simple if has RSI condition",
               dsl, '(> (rsi "EQUITIES::QQQ//USD" 10) 79)')
check_contains("simple if has VIXM in true branch", dsl, '"EQUITIES::VIXM//USD"')
check_contains("simple if has UPRO in else branch", dsl, '"EQUITIES::UPRO//USD"')

# Max-drawdown condition
maxdd_if = {
    "step": "if",
    "children": [
        {
            "step": "if-child",
            "is-else-condition?": False,
            "lhs-fn": "max-drawdown",
            "lhs-fn-params": {"window": 2},
            "lhs-val": "SVXY",
            "comparator": "gt",
            "rhs-val": "10",
            "rhs-fixed-value?": True,
            "children": [{"step": "asset", "ticker": "BIL", "children": []}]
        },
        {
            "step": "if-child",
            "is-else-condition?": True,
            "children": [{"step": "asset", "ticker": "SVXY", "children": []}]
        }
    ]
}
dsl = render_node(maxdd_if, indent=0)
check_contains("max-drawdown condition",
               dsl, '(> (max-drawdown "EQUITIES::SVXY//USD" 2) 10)')


# ── Section 6: Dynamic (rhs-fn) comparison ────────────────────────────────────

section("6. Dynamic rhs-fn comparison (Sisyphus regime filter)")

# NEW format: lhs-fn-params / rhs-fn-params as objects
regime_if = {
    "step": "if",
    "children": [
        {
            "step": "if-child",
            "is-else-condition?": False,
            "lhs-fn": "current-price",
            "lhs-fn-params": {"window": 2},
            "lhs-val": "SPY",
            "comparator": "gt",
            "rhs-fn": "moving-average-price",
            "rhs-fn-params": {"window": 200},
            "rhs-val": "SPY",      # ticker for rhs when rhs-fixed-value?=false
            "rhs-fixed-value?": False,
            "children": [{"step": "asset", "ticker": "TQQQ", "children": []}]
        },
        {
            "step": "if-child",
            "is-else-condition?": True,
            "children": [{"step": "asset", "ticker": "BIL", "children": []}]
        }
    ]
}
dsl = render_node(regime_if, indent=0)
check_contains("dynamic comparison: current-price",
               dsl, '(current-price "EQUITIES::SPY//USD" 2)')
check_contains("dynamic comparison: moving-average-price",
               dsl, '(moving-average-price "EQUITIES::SPY//USD" 200)')
check_contains("dynamic comparison uses > operator",
               dsl, '(> (current-price')

# OLD format (lhs-window-days / rhs-window-days as flat strings) — confirmed from Sisyphus
old_format_if_child = {
    "step": "if-child",
    "is-else-condition?": False,
    "lhs-fn": "current-price",
    "lhs-window-days": "2",        # old format — flat string
    "lhs-val": "SPY",
    "comparator": "gt",
    "rhs-fn": "moving-average-price",
    "rhs-window-days": "200",      # old format — flat string
    "rhs-val": "SPY",
    "rhs-fixed-value?": False,
    "children": [{"step": "asset", "ticker": "TQQQ", "children": []}]
}
from json_to_dsl_converter import extract_condition_from_if_child
dsl_cond = extract_condition_from_if_child(old_format_if_child)
check_contains("old format lhs-window-days=2 preserved",
               dsl_cond, '(current-price "EQUITIES::SPY//USD" 2)')
check_contains("old format rhs-window-days=200 preserved",
               dsl_cond, '(moving-average-price "EQUITIES::SPY//USD" 200)')

# OLD format: moving-average-return vs moving-average-return (TLT vs UDN, window=20)
old_format_mar = {
    "step": "if-child",
    "is-else-condition?": False,
    "lhs-fn": "moving-average-return",
    "lhs-window-days": "20",
    "lhs-val": "TLT",
    "comparator": "gt",
    "rhs-fn": "moving-average-return",
    "rhs-window-days": "20",
    "rhs-val": "UDN",
    "rhs-fixed-value?": False,
    "children": [{"step": "asset", "ticker": "TLT", "children": []}]
}
dsl_cond = extract_condition_from_if_child(old_format_mar)
check_contains("old format moving-average-return TLT w=20",
               dsl_cond, '(moving-average-return "EQUITIES::TLT//USD" 20)')
check_contains("old format moving-average-return UDN w=20",
               dsl_cond, '(moving-average-return "EQUITIES::UDN//USD" 20)')

# NEW format: rhs-fn-params as object with different lhs/rhs windows (IEF w=10 vs PSQ w=20)
new_format_diff_windows = {
    "step": "if-child",
    "is-else-condition?": False,
    "lhs-fn": "relative-strength-index",
    "lhs-fn-params": {"window": 10},
    "lhs-val": "IEF",
    "comparator": "gt",
    "rhs-fn": "relative-strength-index",
    "rhs-fn-params": {"window": 20},
    "rhs-val": "PSQ",
    "rhs-fixed-value?": False,
    "children": [{"step": "asset", "ticker": "IEF", "children": []}]
}
dsl_cond = extract_condition_from_if_child(new_format_diff_windows)
check_contains("new format lhs rsi IEF w=10",
               dsl_cond, '(rsi "EQUITIES::IEF//USD" 10)')
check_contains("new format rhs rsi PSQ w=20",
               dsl_cond, '(rsi "EQUITIES::PSQ//USD" 20)')

# CRITICAL: rhs-fn present but rhs-fixed-value? ABSENT (confirmed from Beta Baller)
# Some nodes omit rhs-fixed-value? entirely when rhs-fn is set.
# Must treat as dynamic, not fixed-value.
missing_rhs_fixed = {
    "step": "if-child",
    "is-else-condition?": False,
    "lhs-fn": "relative-strength-index",
    "lhs-fn-params": {"window": 4},
    "lhs-val": "BIL",
    "comparator": "lt",
    "rhs-fn": "relative-strength-index",
    "rhs-fn-params": {"window": 9},
    "rhs-val": "IEF",
    # rhs-fixed-value? intentionally ABSENT
    "children": [{"step": "asset", "ticker": "BIL", "children": []}]
}
dsl_cond = extract_condition_from_if_child(missing_rhs_fixed)
check_contains("missing rhs-fixed-value? with rhs-fn: lhs is indicator",
               dsl_cond, '(rsi "EQUITIES::BIL//USD" 4)')
check_contains("missing rhs-fixed-value? with rhs-fn: rhs is indicator not bare ticker",
               dsl_cond, '(rsi "EQUITIES::IEF//USD" 9)')
check("missing rhs-fixed-value? with rhs-fn: full condition correct",
      dsl_cond,
      '(< (rsi "EQUITIES::BIL//USD" 4) (rsi "EQUITIES::IEF//USD" 9))')

# CRITICAL: rhs-fixed-value?=True takes precedence over rhs-fn when both present
# Confirmed from Sisyphus: some nodes have rhs-fn as metadata but rhs-fixed-value?=True
# The rhs-val is the constant, not a ticker. Must NOT emit an indicator call for rhs.
contradictory_node = {
    "step": "if-child",
    "is-else-condition?": False,
    "lhs-fn": "relative-strength-index",
    "lhs-window-days": "21",
    "lhs-val": "SPY",
    "comparator": "gt",
    "rhs-fn": "moving-average-return",   # present but should be IGNORED
    "rhs-window-days": "1",              # present but should be IGNORED
    "rhs-val": "30",                     # this is a constant, not a ticker
    "rhs-fixed-value?": True,            # True takes absolute precedence
    "children": [{"step": "asset", "ticker": "TQQQ", "children": []}]
}
dsl_cond = extract_condition_from_if_child(contradictory_node)
check("contradictory node: rhs-fixed-value?=True wins over rhs-fn",
      dsl_cond,
      '(> (rsi "EQUITIES::SPY//USD" 21) 30)')
check("contradictory node: no indicator call on rhs",
      str("moving-average-return" not in dsl_cond), "True")


# ── Section 7: Compound conditions (Sisyphus schemas) ─────────────────────────

section("7. Compound conditions — all three Sisyphus schemas")

# Schema 2: compound/all (AND) — UVXY RSI band
compound_all = {
    "condition-type": "compound",
    "operator": "all",
    "conditions": [
        {
            "condition-type": "binary",
            "lhs": {"fn": "relative-strength-index", "params": {"window": 10}, "ticker": "UVXY"},
            "comparator": "gt",
            "rhs": {"constant": 74}
        },
        {
            "condition-type": "binary",
            "lhs": {"fn": "relative-strength-index", "params": {"window": 10}, "ticker": "UVXY"},
            "comparator": "lt",
            "rhs": {"constant": 84}
        }
    ]
}
dsl = render_condition(compound_all)
check_contains("compound/all opens with (and", dsl, "(and ")
check_contains("compound/all first condition > 74",
               dsl, '(> (rsi "EQUITIES::UVXY//USD" 10) 74)')
check_contains("compound/all second condition < 84",
               dsl, '(< (rsi "EQUITIES::UVXY//USD" 10) 84)')

# Schema 3: compound/any (OR) — multi-ticker RSI
compound_any = {
    "condition-type": "compound",
    "operator": "any",
    "conditions": [
        {
            "condition-type": "binary",
            "lhs": {"fn": "relative-strength-index", "params": {"window": 10}, "ticker": "TQQQ"},
            "comparator": "gt",
            "rhs": {"constant": 81}
        },
        {
            "condition-type": "binary",
            "lhs": {"fn": "relative-strength-index", "params": {"window": 10}, "ticker": "SPY"},
            "comparator": "gt",
            "rhs": {"constant": 80}
        }
    ]
}
dsl = render_condition(compound_any)
check_contains("compound/any opens with (or", dsl, "(or ")
check_contains("compound/any TQQQ condition",
               dsl, '(> (rsi "EQUITIES::TQQQ//USD" 10) 81)')
check_contains("compound/any SPY condition",
               dsl, '(> (rsi "EQUITIES::SPY//USD" 10) 80)')

# Schema 1: binary-compound (same test, multiple tickers) — expanded to OR
binary_compound = {
    "condition-type": "binary-compound",
    "operator": "any",
    "tickers": ["QQQ", "SPY"],
    "lhs": {"fn": "relative-strength-index", "params": {"window": 10}, "ticker": "%"},
    "comparator": "gt",
    "rhs": {"constant": 79}
}
dsl = render_condition(binary_compound)
check_contains("binary-compound expands to (or", dsl, "(or ")
check_contains("binary-compound QQQ arm",
               dsl, '(> (rsi "EQUITIES::QQQ//USD" 10) 79)')
check_contains("binary-compound SPY arm",
               dsl, '(> (rsi "EQUITIES::SPY//USD" 10) 79)')

# Compound condition attached to if-child via "condition" key
if_with_compound_condition = {
    "step": "if",
    "children": [
        {
            "step": "if-child",
            "is-else-condition?": False,
            # Legacy flat fields (primary condition mirror — for API compat)
            "lhs-fn": "relative-strength-index",
            "lhs-fn-params": {"window": 10},
            "lhs-val": "UVXY",
            "comparator": "gt",
            "rhs-val": "74",
            "rhs-fixed-value?": True,
            # Full condition object is authoritative
            "condition": {
                "condition-type": "compound",
                "operator": "all",
                "conditions": [
                    {
                        "condition-type": "binary",
                        "lhs": {"fn": "relative-strength-index",
                                "params": {"window": 10}, "ticker": "UVXY"},
                        "comparator": "gt",
                        "rhs": {"constant": 74}
                    },
                    {
                        "condition-type": "binary",
                        "lhs": {"fn": "relative-strength-index",
                                "params": {"window": 10}, "ticker": "UVXY"},
                        "comparator": "lt",
                        "rhs": {"constant": 84}
                    }
                ]
            },
            "children": [{"step": "asset", "ticker": "UVXY", "children": []}]
        },
        {
            "step": "if-child",
            "is-else-condition?": True,
            "children": [{"step": "asset", "ticker": "VIXM", "children": []}]
        }
    ]
}
dsl = render_node(if_with_compound_condition, indent=0)
check_contains("if with compound condition uses (and", dsl, "(and ")
check_contains("condition object takes precedence over flat fields",
               dsl, "(< (rsi")  # if flat fields won, only > 74 would appear; < 84 proves condition obj used
check_contains("true branch UVXY", dsl, '"EQUITIES::UVXY//USD"')
check_contains("else branch VIXM", dsl, '"EQUITIES::VIXM//USD"')


# ── Section 8: Group node ──────────────────────────────────────────────────────

section("8. Group node")

group_node = {
    "step": "group",
    "name": "Bull Rotators",
    "children": [
        {"step": "asset", "ticker": "TQQQ", "children": []},
        {"step": "asset", "ticker": "SOXL", "children": []},
    ]
}
dsl = render_node(group_node, indent=0)
check_contains("group has name", dsl, '(group "Bull Rotators"')
check_contains("group has TQQQ child", dsl, '"EQUITIES::TQQQ//USD"')

# Embedded double quotes in group name (confirmed from Beta Baller)
quoted_group = {
    "step": "group",
    "name": '"V3.0.4.2a" [HTX anti-twitch]| Beta Baller',
    "children": [{"step": "asset", "ticker": "SPY", "children": []}]
}
dsl = render_node(quoted_group, indent=0)
check_contains("embedded quotes escaped in group name", dsl, r'\"V3.0.4.2a\"')


# ── Section 9: Full symphony integration ──────────────────────────────────────

section("9. Full symphony integration (SVXY Guard + RSI + Filter)")

full_symphony = {
    "name": "SVXY Guard RSI Rotation Example",
    "rebalance_frequency": "daily",
    "children": [{
        "step": "if",
        "children": [
            {
                "step": "if-child",
                "is-else-condition?": False,
                "lhs-fn": "max-drawdown",
                "lhs-fn-params": {"window": 2},
                "lhs-val": "SVXY",
                "comparator": "gt",
                "rhs-val": "10",
                "rhs-fixed-value?": True,
                "children": [{"step": "asset", "ticker": "BIL", "children": []}]
            },
            {
                "step": "if-child",
                "is-else-condition?": True,
                "children": [{
                    "step": "if",
                    "children": [
                        {
                            "step": "if-child",
                            "is-else-condition?": False,
                            "lhs-fn": "relative-strength-index",
                            "lhs-fn-params": {"window": 10},
                            "lhs-val": "QQQ",
                            "comparator": "gt",
                            "rhs-val": "79",
                            "rhs-fixed-value?": True,
                            "children": [{"step": "asset", "ticker": "VIXM",
                                          "children": []}]
                        },
                        {
                            "step": "if-child",
                            "is-else-condition?": True,
                            "children": [{
                                "step": "filter",
                                "sort-by-fn": "cumulative-return",
                                "sort-by-fn-params": {"window": 20},
                                "select-fn": "top",
                                "select-n": "1",
                                "children": [
                                    {"step": "asset", "ticker": "TQQQ", "children": []},
                                    {"step": "asset", "ticker": "SOXL", "children": []},
                                    {"step": "asset", "ticker": "UPRO", "children": []},
                                ]
                            }]
                        }
                    ]
                }]
            }
        ]
    }]
}
dsl = json_to_dsl(full_symphony)
check_contains("full symphony: defsymphony header",
               dsl, 'defsymphony "SVXY Guard RSI Rotation Example"')
check_contains("full symphony: rebalance-frequency daily",
               dsl, ':rebalance-frequency :daily')
check_contains("full symphony: outer SVXY crash guard",
               dsl, '(> (max-drawdown "EQUITIES::SVXY//USD" 2) 10)')
check_contains("full symphony: BIL in crash branch",
               dsl, '"EQUITIES::BIL//USD"')
check_contains("full symphony: QQQ RSI guard",
               dsl, '(> (rsi "EQUITIES::QQQ//USD" 10) 79)')
check_contains("full symphony: VIXM in bear branch",
               dsl, '"EQUITIES::VIXM//USD"')
check_contains("full symphony: filter node",
               dsl, '(filter (cumulative-return 20)')
check_contains("full symphony: select-top 1",
               dsl, '(select-top 1)')
check_contains("full symphony: TQQQ in filter",
               dsl, '"EQUITIES::TQQQ//USD"')

# Byte size comparison
original_bytes = len(json.dumps(full_symphony))
dsl_bytes       = len(dsl)
compression     = (1 - dsl_bytes / original_bytes) * 100
print(f"\n  Compression check:")
print(f"    Original JSON: {original_bytes} bytes")
print(f"    DSL output:    {dsl_bytes} bytes")
print(f"    Reduction:     {compression:.0f}%")


# ── Section 10: Edge cases ─────────────────────────────────────────────────────

from json_to_dsl_converter import clean_compiled, merge_from_original

section("10. clean_compiled — strip children:[] from asset nodes")

# Asset nodes: children:[] must be removed (Composer rejects explicit empty children)
dirty = {
    "step": "wt-cash-equal",
    "children": [
        {"step": "asset", "ticker": "TQQQ", "children": []},
        {"step": "asset", "ticker": "BIL",  "children": []},
        {"step": "if", "children": [
            {"step": "if-child", "is-else-condition?": False,
             "lhs-fn": "relative-strength-index",
             "lhs-window-days": "10",
             "lhs-fn-params": {"window": 10},   # should be stripped
             "rhs-fn-params": {"window": 20},   # should be stripped
             "children": [
                 {"step": "asset", "ticker": "SVXY", "children": []}
             ]},
            {"step": "if-child", "is-else-condition?": True,
             "children": [{"step": "asset", "ticker": "BIL", "children": []}]}
        ]}
    ]
}
cleaned = clean_compiled(dirty)

# Asset nodes should have no children key
tqqq = cleaned["children"][0]
check("asset node: children key removed", str("children" not in tqqq), "True")
check("asset node: ticker preserved",     tqqq.get("ticker"), "TQQQ")
check("asset node: no collapsed? field",  str("collapsed?" not in tqqq), "True")

# if-child: lhs-fn-params and rhs-fn-params stripped
ifchild = cleaned["children"][2]["children"][0]
check("if-child: lhs-fn-params present (Composer needs both formats)",
      str("lhs-fn-params" in ifchild), "True")
check("if-child: lhs-window-days preserved",
      ifchild.get("lhs-window-days"), "10")

# Non-asset nodes keep their children
check("weight-equal: children preserved", str(len(cleaned.get("children", [])) > 0), "True")

# Nested asset nodes also cleaned
nested_asset = cleaned["children"][2]["children"][0]["children"][0]
check("nested asset: children key removed", str("children" not in nested_asset), "True")

# Original not mutated
check("original not mutated", str("children" in dirty["children"][0]), "True")

section("11. merge_from_original — copy weight/window-days/collapsed? from original")

orig_tree = {
    "step": "wt-cash-specified",
    "children": [
        {"step": "filter", "sort-by-fn": "cumulative-return",
         "weight": {"num": 60, "den": 100}, "collapsed?": True,
         "children": [{"step": "asset", "ticker": "TQQQ"}]},
        {"step": "if", "weight": {"num": 40, "den": 100}, "collapsed?": False,
         "children": [
             {"step": "if-child", "is-else-condition?": False,
              "children": [{"step": "asset", "ticker": "BIL"}]},
             {"step": "if-child", "is-else-condition?": True,
              "children": [{"step": "asset", "ticker": "SPY"}]},
         ]},
    ]
}
comp_tree = {
    "step": "wt-cash-specified",
    "children": [
        {"step": "filter", "sort-by-fn": "cumulative-return",
         "children": [{"step": "asset", "ticker": "TQQQ", "children": []}]},
        {"step": "if",
         "children": [
             {"step": "if-child", "is-else-condition?": False,
              "children": [{"step": "asset", "ticker": "BIL", "children": []}]},
             {"step": "if-child", "is-else-condition?": True,
              "children": [{"step": "asset", "ticker": "SPY", "children": []}]},
         ]},
    ]
}

merged = merge_from_original(comp_tree, orig_tree)
filter_node = merged["children"][0]
if_node     = merged["children"][1]

check("merge: weight copied to filter node",
      str(filter_node.get("weight")), str({"num": 60, "den": 100}))
check("merge: collapsed? copied to filter node",
      str(filter_node.get("collapsed?")), "True")
check("merge: weight copied to if node",
      str(if_node.get("weight")), str({"num": 40, "den": 100}))
check("merge: collapsed? copied to if node",
      str(if_node.get("collapsed?")), "False")
check("merge: step preserved on filter",
      filter_node.get("step"), "filter")
check("merge: original not mutated",
      str("weight" not in comp_tree["children"][0]), "True")

section("12. Edge cases")
# API root format (step: "root")
api_root = {
    "step": "root",
    "name": "API Format Strategy",
    "rebalance": "weekly",
    "children": [{"step": "asset", "ticker": "SPY", "children": []}]
}
dsl = json_to_dsl(api_root)
check_contains("API root format: name extracted", dsl, '"API Format Strategy"')
check_contains("API root format: rebalance keyword", dsl, ':weekly')

# Deeply nested compound (3-level)
triple_compound = {
    "condition-type": "compound",
    "operator": "all",
    "conditions": [
        {
            "condition-type": "binary",
            "lhs": {"fn": "relative-strength-index", "params": {"window": 10}, "ticker": "UVXY"},
            "comparator": "gt",
            "rhs": {"constant": 65}
        },
        {
            "condition-type": "compound",
            "operator": "any",
            "conditions": [
                {
                    "condition-type": "binary",
                    "lhs": {"fn": "cumulative-return", "params": {"window": 5}, "ticker": "SPY"},
                    "comparator": "lt",
                    "rhs": {"constant": -3}
                },
                {
                    "condition-type": "binary",
                    "lhs": {"fn": "cumulative-return", "params": {"window": 5}, "ticker": "QQQ"},
                    "comparator": "lt",
                    "rhs": {"constant": -4}
                }
            ]
        }
    ]
}
dsl = render_condition(triple_compound)
check_contains("nested compound: outer (and", dsl, "(and ")
check_contains("nested compound: inner (or", dsl, "(or ")
check_contains("nested compound: UVXY rsi", dsl, '(> (rsi "EQUITIES::UVXY//USD" 10) 65)')
check_contains("nested compound: SPY cumret < -3",
               dsl, '(< (cumulative-return "EQUITIES::SPY//USD" 5) -3)')

# binary-compound with single ticker (no OR wrapper needed)
single_ticker_bc = {
    "condition-type": "binary-compound",
    "operator": "any",
    "tickers": ["QQQ"],
    "lhs": {"fn": "relative-strength-index", "params": {"window": 10}, "ticker": "%"},
    "comparator": "gt",
    "rhs": {"constant": 79}
}
dsl = render_condition(single_ticker_bc)
check("single-ticker binary-compound: no OR wrapper",
      dsl,
      '(> (rsi "EQUITIES::QQQ//USD" 10) 79)')


# ── Summary ────────────────────────────────────────────────────────────────────

print(f"\n{'='*60}")
print(f"  RESULTS: {PASS} passed, {FAIL} failed")
print(f"{'='*60}")

if FAIL > 0:
    sys.exit(1)
