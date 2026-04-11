"""
generate_dsl_fragments.py — Convert patterns.json winning/losing patterns to DSL files.

Creates kb/patterns_dsl/{guards,allocation,selection,anti_patterns}/ with .dsl files.
"""

import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from json_to_dsl_converter import render_node, ticker_to_dsl, FN_JSON_TO_DSL, COMPARATOR_TO_DSL

KB_ROOT = Path.home() / '.openclaw' / 'workspace' / 'learning' / 'kb'
OUT_DIR = KB_ROOT / 'patterns_dsl'

# ── Create directories ─────────────────────────────────────────────────────────
for d in ['guards', 'allocation', 'selection', 'anti_patterns']:
    (OUT_DIR / d).mkdir(parents=True, exist_ok=True)


def slugify(name: str) -> str:
    return re.sub(r'[^a-z0-9]+', '_', name.lower()).strip('_')


def format_list(lst: list) -> str:
    if not lst:
        return 'none'
    return ', '.join(str(x) for x in lst)


def category_to_dir(cat: str) -> str:
    return {'guard': 'guards', 'allocation': 'allocation', 'selection': 'selection'}.get(cat, 'guards')


def normalize_template(node):
    """Recursively normalize template JSON to standard Composer format.
    - Converts 'symbol' → 'ticker' (some patterns use symbol)
    - Ensures children is a list
    """
    if not isinstance(node, dict):
        return node
    node = dict(node)
    # Normalize 'symbol' → 'ticker'
    if 'symbol' in node and 'ticker' not in node:
        node['ticker'] = node.pop('symbol')
    # Recurse children
    if 'children' in node:
        node['children'] = [normalize_template(c) for c in node['children']]
    return node


def manual_dsl_pat018():
    """pat-018 uses a non-standard template format — manually translate."""
    return (
        '(if (< (cumulative-return "EQUITIES::TQQQ//USD" 10) -33)\n'
        '  [(asset "EQUITIES::BIL//USD" "BIL")]\n'
        '  [; PLACEHOLDER: Insert remaining strategy logic here\n'
        '  ])'
    )


def manual_dsl_pat019():
    """pat-019 uses a non-standard template format — manually translate."""
    return (
        '(if (> (rsi "EQUITIES::SVXY//USD" 10) 31)\n'
        '  [(if (> (cumulative-return "EQUITIES::SVXY//USD" 1) -6)\n'
        '    [(asset "EQUITIES::SVXY//USD" "SVXY")]\n'
        '    [(asset "EQUITIES::BIL//USD" "BIL")])]\n'
        '  [(asset "EQUITIES::BIL//USD" "BIL")])'
    )


MANUAL_DSL = {
    'pat-018': manual_dsl_pat018,
    'pat-019': manual_dsl_pat019,
}


def render_template_dsl(pat_id: str, template: dict) -> str:
    """Render a template to DSL, with fallbacks for non-standard formats."""
    # Manual translations for known non-standard templates
    if pat_id in MANUAL_DSL:
        return MANUAL_DSL[pat_id]()

    normalized = normalize_template(template)
    try:
        return render_node(normalized, indent=0)
    except Exception as e:
        # Best-effort: emit what we know
        return (
            f'; NOTE: Auto-conversion failed ({e})\n'
            f'; Raw template step: {template.get("step", "unknown")}\n'
            f'; See patterns.json for full template'
        )


def write_winning_pattern(pat: dict):
    pat_id   = pat['id']
    name     = pat['name']
    cat      = pat['category']
    subdir   = category_to_dir(cat)
    slug     = slugify(name)
    filename = f"{pat_id}_{slug}.dsl"

    conf     = pat['performance']['confidence']
    seen     = pat['times_seen']
    app      = pat['applicability']
    desc     = pat['description']
    usage    = pat['usage_note']
    gen_inst = pat['generator_instruction']
    overrides = pat.get('archetype_overrides', {})
    template = pat['template']

    dsl = render_template_dsl(pat_id, template)

    lines = [
        f'; {name} — {pat_id}',
        f'; confidence: {conf} | seen: {seen}x',
        f'; category: {cat}',
        f'; archetypes: {format_list(app["archetypes"])}',
        f'; regimes effective: {format_list(app["regimes_effective"])}',
        f'; regimes less effective: {format_list(app["regimes_less_effective"])}',
        ';',
        f'; DESCRIPTION: {desc}',
        ';',
        f'; USAGE: {usage}',
        ';',
        f'; GENERATOR INSTRUCTION: {gen_inst}',
        ';',
    ]

    # Variants block — only if aggressive/conservative both present with threshold
    agg  = overrides.get('aggressive', {})
    cons = overrides.get('conservative', {})
    if agg.get('threshold') is not None or cons.get('threshold') is not None:
        lines.append('; VARIANTS:')
        if agg.get('threshold') is not None:
            lines.append(f';   aggressive:   threshold={agg["threshold"]}')
        if cons.get('threshold') is not None:
            lines.append(f';   conservative: threshold={cons["threshold"]}')
        lines.append(';')

    lines.append('; DSL:')
    lines.append(dsl)

    out_path = OUT_DIR / subdir / filename
    out_path.write_text('\n'.join(lines) + '\n')
    return filename


def write_losing_pattern(pat: dict):
    pat_id   = pat['id']
    name     = pat['name']
    slug     = slugify(name)
    filename = f"{pat_id}_{slug}.dsl"

    never    = pat['never_do']
    why      = pat['why_it_fails']
    evidence = pat.get('historical_evidence', [])

    lines = [
        f'; {name} — {pat_id}',
        f'; category: {pat["category"]}',
        ';',
        f'; NEVER DO: {never}',
        ';',
        f'; WHY IT FAILS: {why}',
        ';',
        '; EVIDENCE:',
    ]
    for e in evidence:
        lines.append(f';   - {e}')

    out_path = OUT_DIR / 'anti_patterns' / filename
    out_path.write_text('\n'.join(lines) + '\n')
    return filename


def main():
    patterns = json.loads((KB_ROOT / 'patterns.json').read_text())

    print(f"\nGenerating DSL fragments → {OUT_DIR}")
    print(f"{'─'*60}")

    winning = patterns.get('winning_patterns', [])
    losing  = patterns.get('losing_patterns', [])

    print(f"\nWinning patterns ({len(winning)}):")
    ok = err = 0
    for pat in winning:
        try:
            fname = write_winning_pattern(pat)
            cat   = pat['category']
            subdir = category_to_dir(cat)
            print(f"  ✓  {subdir}/{fname}")
            ok += 1
        except Exception as e:
            print(f"  ✗  {pat['id']} {pat['name']}: {e}")
            err += 1

    print(f"\nLosing patterns ({len(losing)}):")
    for pat in losing:
        try:
            fname = write_losing_pattern(pat)
            print(f"  ✓  anti_patterns/{fname}")
            ok += 1
        except Exception as e:
            print(f"  ✗  {pat['id']} {pat['name']}: {e}")
            err += 1

    print(f"\n{'─'*60}")
    print(f"  {ok} files written, {err} errors")
    print(f"\nDirectory layout:")
    for d in ['guards', 'allocation', 'selection', 'anti_patterns']:
        files = sorted((OUT_DIR / d).glob('*.dsl'))
        print(f"  {d}/  ({len(files)} files)")
        for f in files:
            print(f"    {f.name}")

    return 0 if err == 0 else 1


if __name__ == '__main__':
    sys.exit(main())
