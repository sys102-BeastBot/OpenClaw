"""
dsl_compiler.py — Composer DSL to JSON compiler.

Converts Composer's functional DSL (from the "Def" tab) to valid Composer JSON
that can be imported via the UI or used with the backtest API.

DSL Grammar:
  defsymphony "Name" {:rebalance-frequency :daily}
    <block>

  <block> ::=
    (weight-equal [<block>...])
    (weight-specified {<ticker> <pct>} [<block>...])
    (weight-inverse-vol <window> [<block>...])
    (filter (<indicator> <window>) (select-top <n>) [<asset>...])
    (if <condition> [<block>...] [<block>...])
    (asset "EQUITIES::<TICKER>//USD" "<Name>")
    (group "Name" [<block>...])

  <condition> ::=
    (> <lhs> <rhs>)
    (< <lhs> <rhs>)
    (>= <lhs> <rhs>)
    (<= <lhs> <rhs>)
    (or <condition>...)
    (and <condition>...)

  <lhs/rhs> ::=
    (<indicator> "<asset>" <window>)
    <number>

  <indicator> ::=
    rsi | cumulative-return | moving-average-price | max-drawdown
    exponential-moving-average-price | moving-average-return
    standard-deviation-return | standard-deviation-price | current-price
"""

import re
import uuid
import json
from typing import Any

# ── Indicator function name mapping (DSL → JSON lhs-fn) ──────────────────────
INDICATOR_MAP = {
    'rsi':                            'relative-strength-index',
    'relative-strength-index':        'relative-strength-index',
    'cumulative-return':              'cumulative-return',
    'moving-average-price':           'moving-average-price',
    'max-drawdown':                   'max-drawdown',
    'exponential-moving-average-price': 'exponential-moving-average-price',
    'ema':                            'exponential-moving-average-price',
    'moving-average-return':          'moving-average-return',
    'standard-deviation-return':      'standard-deviation-return',
    'standard-deviation-price':       'standard-deviation-price',
    'current-price':                  'current-price',
}

COMPARATOR_MAP = {
    '>':  'gt',
    '<':  'lt',
    '>=': 'gte',
    '<=': 'lte',
    '=':  'eq',
}


class DSLError(Exception):
    pass


def fresh_id() -> str:
    return str(uuid.uuid4())


def extract_ticker(asset_str: str) -> str:
    """Extract ticker from 'EQUITIES::TQQQ//USD' or plain 'TQQQ'."""
    m = re.search(r'::([A-Z0-9]+)//', asset_str)
    if m:
        return m.group(1)
    return asset_str.strip('"').strip()


# ── Tokenizer ────────────────────────────────────────────────────────────────

def tokenize(text: str) -> list[str]:
    """Convert DSL text to a list of tokens."""
    # Normalize whitespace, handle strings, parens, brackets
    tokens = []
    i = 0
    while i < len(text):
        c = text[i]
        if c in ' \t\n\r':
            i += 1
        elif c in '()[]{}':
            tokens.append(c)
            i += 1
        elif c == '"':
            # String literal
            j = i + 1
            while j < len(text) and text[j] != '"':
                if text[j] == '\\':
                    j += 1
                j += 1
            tokens.append(text[i:j+1])
            i = j + 1
        elif c == ';':
            # Comment — skip to end of line
            while i < len(text) and text[i] != '\n':
                i += 1
        elif c == ':':
            # Keyword like :daily
            j = i + 1
            while j < len(text) and text[j] not in ' \t\n\r()[]{}':
                j += 1
            tokens.append(text[i:j])
            i = j
        else:
            # Symbol or number
            j = i
            while j < len(text) and text[j] not in ' \t\n\r()[]{},"':
                j += 1
            tokens.append(text[i:j])
            i = j
    return [t for t in tokens if t]


# ── Parser ───────────────────────────────────────────────────────────────────

class Parser:
    def __init__(self, tokens: list[str]):
        self.tokens = tokens
        self.pos    = 0

    def peek(self) -> str | None:
        return self.tokens[self.pos] if self.pos < len(self.tokens) else None

    def consume(self, expected: str | None = None) -> str:
        tok = self.peek()
        if tok is None:
            raise DSLError(f"Unexpected end of input, expected {expected!r}")
        if expected and tok != expected:
            raise DSLError(f"Expected {expected!r}, got {tok!r} at position {self.pos}")
        self.pos += 1
        return tok

    def parse_string(self) -> str:
        tok = self.consume()
        if tok.startswith('"') and tok.endswith('"'):
            return tok[1:-1]
        return tok

    def parse_number(self, tok: str) -> float | int:
        try:
            v = float(tok)
            return int(v) if v == int(v) else v
        except ValueError:
            raise DSLError(f"Expected number, got {tok!r}")

    def parse_map(self) -> dict:
        """Parse {:key :value ...}"""
        self.consume('{')
        result = {}
        while self.peek() != '}':
            key = self.consume()   # :rebalance-frequency
            val = self.consume()   # :daily
            result[key.lstrip(':')] = val.lstrip(':')
        self.consume('}')
        return result

    def parse_list(self) -> list:
        """Parse [<item>...] — items are blocks."""
        self.consume('[')
        items = []
        while self.peek() != ']':
            items.append(self.parse_block())
        self.consume(']')
        return items

    def parse_block(self) -> dict:
        """Parse any block expression."""
        tok = self.peek()

        if tok == '(':
            self.consume('(')
            fn = self.consume()
            result = self.dispatch_block(fn)
            self.consume(')')
            return result

        elif tok and tok.startswith('"'):
            # bare asset string — shouldn't normally appear here
            raise DSLError(f"Unexpected string token {tok!r} as block")

        else:
            raise DSLError(f"Expected block, got {tok!r} at pos {self.pos}")

    def dispatch_block(self, fn: str) -> dict:
        if fn == 'weight-equal':
            children = self.parse_list()
            return {'id': fresh_id(), 'step': 'wt-cash-equal', 'children': children}

        elif fn == 'weight-specified':
            # (weight-specified {"TQQQ" 60 "BIL" 40} [...])
            weights = self.parse_weight_map()
            children = self.parse_list()
            # Apply weights to children
            if isinstance(weights, list):
                # Positional form: align weights by index
                for i, child in enumerate(children):
                    if i < len(weights):
                        w = weights[i]
                        child['weight'] = {'num': str(int(w)) if w == int(w) else str(w), 'den': 100}
            else:
                # Dict form: match by ticker
                for child in children:
                    ticker = child.get('ticker', '')
                    if ticker in weights:
                        child['weight'] = {'num': str(weights[ticker]), 'den': 100}
            return {'id': fresh_id(), 'step': 'wt-cash-specified', 'children': children}

        elif fn == 'weight-inverse-vol':
            window = self.parse_number(self.consume())
            children = self.parse_list()
            return {'id': fresh_id(), 'step': 'wt-inverse-vol',
                    'window-days': str(int(window)), 'children': children}

        elif fn == 'filter':
            # (filter (rsi 10) (select-top 1) [...])
            sort_fn, sort_window = self.parse_indicator_call()
            select_fn, select_n  = self.parse_select_call()
            children = self.parse_list()
            return {
                'id':                fresh_id(),
                'step':              'filter',
                'sort-by-fn':        sort_fn,
                'sort-by-fn-params': {'window': sort_window},  # int, matches Sisyphus
                'select-fn':         select_fn,
                'select-n':          str(select_n),
                'select?':           True,
                'sort-by?':          True,
                'children':          children,
            }

        elif fn == 'if':
            condition = self.parse_condition()
            true_list  = self.parse_list()
            false_list = self.parse_list()

            # Flatten single-child lists
            true_content  = true_list[0]  if len(true_list)  == 1 else {'id': fresh_id(), 'step': 'wt-cash-equal', 'children': true_list}
            false_content = false_list[0] if len(false_list) == 1 else {'id': fresh_id(), 'step': 'wt-cash-equal', 'children': false_list}

            # Build legacy flat fields from condition
            legacy = condition_to_legacy(condition)

            true_if_child = {
                'id':                fresh_id(),
                'step':              'if-child',
                'is-else-condition?': False,
                **legacy,
                'children':          [true_content],
            }
            if condition.get('_compound'):
                true_if_child['condition'] = condition['_compound']

            false_if_child = {
                'id':                fresh_id(),
                'step':              'if-child',
                'is-else-condition?': True,
                'children':          [false_content],
            }
            return {
                'id':       fresh_id(),
                'step':     'if',
                'children': [true_if_child, false_if_child],
            }

        elif fn == 'asset':
            asset_str = self.parse_string()
            ticker = extract_ticker(asset_str)
            # Optional name string
            if self.peek() and self.peek().startswith('"'):
                self.parse_string()  # consume name (not needed in JSON)
            return {'id': fresh_id(), 'step': 'asset', 'ticker': ticker, 'children': []}

        elif fn == 'group':
            name = self.parse_string()
            children = self.parse_list()
            return {'id': fresh_id(), 'step': 'group', 'name': name, 'children': children}

        else:
            raise DSLError(f"Unknown block function: {fn!r}")

    def parse_weight_map(self):
        """Parse either {"TQQQ" 60 "BIL" 40} (dict) or [50 0 50] (positional list)."""
        if self.peek() == '[':
            # Positional list form: [50 0 50] — weights aligned by index to children
            self.consume('[')
            weights = []
            while self.peek() != ']':
                weights.append(self.parse_number(self.consume()))
            self.consume(']')
            return weights  # returns list
        else:
            # Dict form: {"TQQQ" 60 "BIL" 40}
            self.consume('{')
            weights = {}
            while self.peek() != '}':
                ticker = extract_ticker(self.parse_string())
                val    = self.parse_number(self.consume())
                weights[ticker] = val
            self.consume('}')
            return weights  # returns dict

    def parse_indicator_call(self) -> tuple[str, int]:
        """Parse (rsi 10) or (cumulative-return 20)"""
        self.consume('(')
        fn     = self.consume()
        window = self.parse_number(self.consume())
        self.consume(')')
        return INDICATOR_MAP.get(fn, fn), int(window)

    def parse_select_call(self) -> tuple[str, int]:
        """Parse (select-top 1) or (select-bottom 1)"""
        self.consume('(')
        fn = self.consume()   # select-top / select-bottom
        n  = self.parse_number(self.consume())
        self.consume(')')
        direction = 'top' if 'top' in fn else 'bottom'
        return direction, int(n)

    def parse_condition(self) -> dict:
        """Parse a condition expression."""
        self.consume('(')
        op = self.consume()

        if op in ('or', 'and'):
            sub_conds = []
            while self.peek() != ')':
                sub_conds.append(self.parse_condition())
            self.consume(')')
            operator = 'any' if op == 'or' else 'all'
            # Build compound condition object
            # Build conditions list — include both binary and compound sub-conditions
            conditions = []
            for c in sub_conds:
                if '_compound' in c:
                    # Prefer _compound over _binary — compound has full condition set
                    # (a sub-cond can have both when it's a nested or/and)
                    inner = c['_compound']
                    if inner.get('operator') == operator:
                        # Flatten same-operator compound into parent
                        conditions.extend(inner.get('conditions', []))
                    else:
                        conditions.append(inner)
                elif '_binary' in c:
                    conditions.append(c['_binary'])
            compound = {
                'condition-type': 'compound',
                'operator':       operator,
                'conditions':     conditions,
            }
            # Return with legacy from first sub-condition
            legacy = sub_conds[0] if sub_conds else {}
            return {**legacy, '_compound': compound}

        elif op in ('>', '<', '>=', '<=', '='):
            lhs = self.parse_value()
            rhs = self.parse_value()
            self.consume(')')
            comparator = COMPARATOR_MAP[op]

            # Build binary condition
            binary = build_binary_condition(lhs, comparator, rhs)
            legacy = build_legacy_fields(lhs, comparator, rhs)
            return {**legacy, '_binary': binary}

        else:
            raise DSLError(f"Unknown condition operator: {op!r}")

    def parse_value(self) -> dict:
        """Parse a value — either an indicator call or a number."""
        tok = self.peek()
        if tok == '(':
            self.consume('(')
            fn = self.consume()
            if fn in INDICATOR_MAP:
                # (rsi "SVXY" 10) or (rsi "EQUITIES::SVXY//USD" 10)
                asset_str = self.parse_string()
                ticker    = extract_ticker(asset_str)
                window    = self.parse_number(self.consume())
                self.consume(')')
                return {'type': 'indicator', 'fn': INDICATOR_MAP[fn],
                        'ticker': ticker, 'window': int(window)}
            else:
                raise DSLError(f"Unknown indicator: {fn!r}")
        else:
            # Number or ticker for dynamic comparison
            val = self.consume()
            try:
                return {'type': 'constant', 'value': float(val)}
            except ValueError:
                return {'type': 'ticker', 'ticker': extract_ticker(val)}


# ── Condition helpers ─────────────────────────────────────────────────────────

def build_binary_condition(lhs: dict, comparator: str, rhs: dict) -> dict:
    """Build a binary condition object for compound conditions."""
    lhs_node = {}
    if lhs['type'] == 'indicator':
        lhs_node = {'fn': lhs['fn'], 'params': {'window': lhs['window']},
                    'ticker': lhs['ticker']}
    rhs_node = {}
    if rhs['type'] == 'constant':
        rhs_node = {'constant': rhs['value']}
    elif rhs['type'] == 'indicator':
        rhs_node = {'fn': rhs['fn'], 'params': {'window': rhs['window']},
                    'ticker': rhs['ticker']}
    return {'condition-type': 'binary', 'lhs': lhs_node,
            'comparator': comparator, 'rhs': rhs_node}


def build_legacy_fields(lhs: dict, comparator: str, rhs: dict) -> dict:
    """Build legacy flat if-child fields for API compatibility."""
    fields = {}
    if lhs['type'] == 'indicator':
        fields['lhs-fn']          = lhs['fn']
        fields['lhs-window-days'] = str(lhs['window'])
        fields['lhs-val']         = lhs['ticker']
        fields['lhs-fn-params']   = {'window': lhs['window']}  # int, not string

    fields['comparator'] = comparator

    if rhs['type'] == 'constant':
        v = rhs['value']
        fields['rhs-val']          = str(int(v) if v == int(v) else v)
        fields['rhs-fixed-value?'] = True
    elif rhs['type'] == 'indicator':
        fields['rhs-fn']          = rhs['fn']
        fields['rhs-window-days'] = str(rhs['window'])
        fields['rhs-val']         = rhs['ticker']
        fields['rhs-fixed-value?'] = False
    elif rhs['type'] == 'ticker':
        fields['rhs-val']          = rhs['ticker']
        fields['rhs-fixed-value?'] = False

    return fields


def condition_to_legacy(cond: dict) -> dict:
    """Extract legacy fields from a parsed condition for the if-child node."""
    # Remove internal keys
    return {k: v for k, v in cond.items()
            if not k.startswith('_')}


# ── Top-level compiler ────────────────────────────────────────────────────────

def compile_dsl(dsl_text: str, name_override: str = None) -> dict:
    """Compile a DSL string to Composer JSON.

    Args:
        dsl_text:      The DSL string from Composer's Def tab.
        name_override: Override the symphony name.

    Returns:
        Valid Composer JSON dict ready for import or backtesting.

    Raises:
        DSLError: If the DSL is malformed.
    """
    tokens = tokenize(dsl_text)
    p      = Parser(tokens)

    # Parse: defsymphony "Name" {:rebalance-frequency :daily}
    p.consume('defsymphony')
    name     = p.parse_string()
    opts     = p.parse_map()
    rebalance = opts.get('rebalance-frequency', 'daily')

    # Parse the root block
    root_block = p.parse_block()

    return {
        'id':          fresh_id(),
        'step':        'root',
        'name':        name_override or name,
        'description': '',
        'rebalance':   rebalance,
        'children':    [root_block],
    }


# ── Tests ─────────────────────────────────────────────────────────────────────

def run_tests():
    import sys
    passed = failed = 0

    def chk(name, cond, detail=''):
        nonlocal passed, failed
        if cond:
            print(f"  ✓ {name}")
            passed += 1
        else:
            print(f"  ✗ {name}" + (f": {detail}" if detail else ''))
            failed += 1

    print("\n=== DSL Compiler Tests ===\n")

    # Test 1: Simple BIL-only strategy
    dsl1 = '''defsymphony "BIL Only" {:rebalance-frequency :daily}
  (weight-equal
    [(asset "EQUITIES::BIL//USD" "T-Bill ETF")])'''
    r1 = compile_dsl(dsl1)
    chk("root step=root",       r1['step'] == 'root')
    chk("root name",            r1['name'] == 'BIL Only')
    chk("root rebalance",       r1['rebalance'] == 'daily')
    chk("wt-cash-equal",        r1['children'][0]['step'] == 'wt-cash-equal')
    chk("BIL asset",            r1['children'][0]['children'][0]['ticker'] == 'BIL')
    chk("asset children=[]",    r1['children'][0]['children'][0]['children'] == [])

    # Test 2: Simple if/else
    dsl2 = '''defsymphony "RSI Test" {:rebalance-frequency :daily}
  (weight-equal
    [(if (< (rsi "EQUITIES::SVXY//USD" 10) 31)
       [(asset "EQUITIES::BIL//USD" "BIL")]
       [(asset "EQUITIES::TQQQ//USD" "TQQQ")])])'''
    r2 = compile_dsl(dsl2)
    if_node = r2['children'][0]['children'][0]
    chk("if step",              if_node['step'] == 'if')
    chk("if has 2 children",    len(if_node['children']) == 2)
    true_branch = if_node['children'][0]
    chk("true branch",          not true_branch.get('is-else-condition?'))
    chk("lhs-fn=rsi",           true_branch.get('lhs-fn') == 'relative-strength-index')
    chk("lhs-val=SVXY",         true_branch.get('lhs-val') == 'SVXY')
    chk("comparator=lt",        true_branch.get('comparator') == 'lt')
    chk("rhs-val=31",           true_branch.get('rhs-val') == '31')
    chk("rhs-fixed-value?",     true_branch.get('rhs-fixed-value?') == True)
    false_branch = if_node['children'][1]
    chk("else branch",          false_branch.get('is-else-condition?'))
    chk("else has TQQQ",        false_branch['children'][0]['ticker'] == 'TQQQ')

    # Test 3: OR compound condition
    dsl3 = '''defsymphony "Compound OR" {:rebalance-frequency :daily}
  (weight-equal
    [(if (or (< (rsi "EQUITIES::SVXY//USD" 10) 31)
             (< (cumulative-return "EQUITIES::SVXY//USD" 1) -8))
       [(asset "EQUITIES::BIL//USD" "BIL")]
       [(asset "EQUITIES::TQQQ//USD" "TQQQ")])])'''
    r3 = compile_dsl(dsl3)
    true_b3 = r3['children'][0]['children'][0]['children'][0]
    chk("compound condition present",   'condition' in true_b3)
    chk("compound operator=any",        true_b3.get('condition',{}).get('operator') == 'any')
    chk("compound has 2 conditions",    len(true_b3.get('condition',{}).get('conditions',[])) == 2)
    chk("legacy lhs-fn present",        'lhs-fn' in true_b3)

    # Test 4: wt-inverse-vol
    dsl4 = '''defsymphony "InvVol" {:rebalance-frequency :daily}
  (weight-equal
    [(if (> (rsi "EQUITIES::TQQQ//USD" 10) 50)
       [(weight-inverse-vol 10
          [(asset "EQUITIES::SOXL//USD" "SOXL")
           (asset "EQUITIES::TECL//USD" "TECL")])]
       [(asset "EQUITIES::BIL//USD" "BIL")])])'''
    r4 = compile_dsl(dsl4)
    true_b4 = r4['children'][0]['children'][0]['children'][0]
    invvol  = true_b4['children'][0]
    chk("wt-inverse-vol step",      invvol['step'] == 'wt-inverse-vol')
    chk("window-days as string",    invvol.get('window-days') == '10')
    chk("invvol has 2 children",    len(invvol['children']) == 2)

    # Test 5: filter block
    dsl5 = '''defsymphony "Filter" {:rebalance-frequency :daily}
  (weight-equal
    [(filter (rsi 10) (select-top 1)
       [(asset "EQUITIES::TQQQ//USD" "TQQQ")
        (asset "EQUITIES::SOXL//USD" "SOXL")
        (asset "EQUITIES::TECL//USD" "TECL")])])'''
    r5 = compile_dsl(dsl5)
    filt = r5['children'][0]['children'][0]
    chk("filter step",              filt['step'] == 'filter')
    chk("filter sort-by-fn=rsi",    filt.get('sort-by-fn') == 'relative-strength-index')
    chk("filter select-fn=top",     filt.get('select-fn') == 'top')
    chk("filter select-n=1",        filt.get('select-n') == '1')
    chk("filter has 3 children",    len(filt['children']) == 3)

    # Test 6: the full strategy from Composer AI
    dsl6 = '''defsymphony "Leveraged ETF Momentum Strategy" {:rebalance-frequency :daily}
  (weight-equal
    [(if
       (or (< (rsi "EQUITIES::SVXY//USD" 10) 31)
           (< (cumulative-return "EQUITIES::SVXY//USD" 1) -8))
       [(asset "EQUITIES::BIL//USD" "SPDR Bloomberg 1-3 Month T-Bill ETF")]
       [(if
          (> (exponential-moving-average-price "EQUITIES::SPY//USD" 210) (moving-average-price "EQUITIES::SPY//USD" 200))
          [(filter
             (rsi 10)
             (select-top 1)
             [(asset "EQUITIES::TQQQ//USD" "ProShares UltraPro QQQ")
              (asset "EQUITIES::SOXL//USD" "Direxion Daily Semiconductor Bull 3X Shares")
              (asset "EQUITIES::TECL//USD" "Direxion Daily Technology Bull 3X Shares")])]
          [(if
             (> (rsi "EQUITIES::BIL//USD" 10) (rsi "EQUITIES::IEF//USD" 10))
             [(asset "EQUITIES::BIL//USD" "SPDR Bloomberg 1-3 Month T-Bill ETF")]
             [(asset "EQUITIES::QQQ//USD" "Invesco QQQ Trust")])])])])'''
    r6 = compile_dsl(dsl6)
    chk("full strategy compiles",   r6['step'] == 'root')
    # Check depth: root → wt-equal → if → if-child → if → if-child → if → ...
    outer_if = r6['children'][0]['children'][0]
    chk("outer if step",            outer_if['step'] == 'if')
    outer_true = outer_if['children'][0]
    chk("outer crash guard compound", 'condition' in outer_true)
    chk("crash guard operator=any",  outer_true['condition']['operator'] == 'any')
    inner_if = outer_if['children'][1]['children'][0]  # else → inner if
    chk("inner if exists",           inner_if['step'] == 'if')
    ema_branch = inner_if['children'][0]
    chk("EMA branch lhs-fn",         'exponential-moving-average-price' in ema_branch.get('lhs-fn',''))
    filter_node = ema_branch['children'][0]
    chk("filter in EMA true branch", filter_node['step'] == 'filter')
    chk("filter has 3 assets",       len(filter_node['children']) == 3)
    bond_if = inner_if['children'][1]['children'][0]
    chk("bond stress if exists",     bond_if['step'] == 'if')
    bond_true = bond_if['children'][0]
    chk("bond rhs-fn=rsi",           bond_true.get('rhs-fn') == 'relative-strength-index')

    # Validate all nodes have IDs
    def check_ids(node, path='root'):
        issues = []
        if 'id' not in node:
            issues.append(f"missing id at {path}")
        for i, c in enumerate(node.get('children', [])):
            issues.extend(check_ids(c, f"{path}[{i}]"))
        return issues
    id_issues = check_ids(r6)
    chk("all nodes have IDs",       len(id_issues) == 0, str(id_issues[:3]))

    print(f"\n{'='*50}")
    print(f"Results: {passed} passed, {failed} failed")
    if failed == 0:
        print("ALL TESTS PASSED ✓")
        # Print the compiled JSON for visual inspection
        print("\n=== Full strategy JSON (Test 6) ===")
        print(json.dumps(r6, indent=2))
    return failed == 0


if __name__ == '__main__':
    run_tests()