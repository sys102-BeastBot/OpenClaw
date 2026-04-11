"""
convert_portfolio.py — Batch convert portfolio symphonies from JSON to DSL.

Fetches 8 symphonies from Composer API, converts to DSL, compiles back,
saves .dsl and _compiled.json files to kb/portfolio_dsl/.
"""

import json
import sys
import re
import requests
import importlib.util
import os
from pathlib import Path

# ── Paths ──────────────────────────────────────────────────────────────────────
WORKSPACE = Path(__file__).parent.parent
CREDS_PATH = Path.home() / ".openclaw" / "composer-credentials.json"
OUT_DIR = WORKSPACE / "kb" / "portfolio_dsl"
SRC_DIR = WORKSPACE / "src"

# ── Load modules ───────────────────────────────────────────────────────────────
def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod

converter = load_module("json_to_dsl_converter", SRC_DIR / "json_to_dsl_converter.py")
compiler  = load_module("dsl_compiler",          SRC_DIR / "dsl_compiler.py")

json_to_dsl       = converter.json_to_dsl
clean_compiled    = converter.clean_compiled
merge_from_original = converter.merge_from_original
compile_dsl       = compiler.compile_dsl

# ── Credentials ────────────────────────────────────────────────────────────────
with open(CREDS_PATH) as f:
    creds = json.load(f)

API_BASE = "http://localhost:8080/composer/api/v0.1"
AUTH = (creds["composer_api_key_id"], creds["composer_api_secret"])

# ── Symphonies ─────────────────────────────────────────────────────────────────
SYMPHONIES = [
    ("0JAbjs58FYRqXhRky7fY", "Benchmark_TQQQ"),
    ("im5F6HTk3OFj7cmewwCC", "Bitcoin Strategy by Derecknielsen"),
    ("F5raZUZDJvTXjebUJL5F", "Extended OOS Outliers (FNGG)"),
    ("QgwrvzhG0qZWnd6o88vb", "01 s90 50/40 maxDD"),
    ("ab8vNQbry0qMdvT3YMLG", "NOVA Best Leverage Mashup v1"),
    ("bUwysuNlSGuyS7XzNdqG", "Custom Foreign RINF mod"),
    ("q8cfmpmiJFnS0byO3myO", "Beta Baller TESTPORT"),
    ("1y5tnTt3FSTKo8FRnFal", "Combined Wild West and RSI Frankenfest"),
]

def slugify(name: str) -> str:
    """Convert symphony name to safe filename slug."""
    s = name.lower()
    s = re.sub(r"[^a-z0-9]+", "_", s)
    s = s.strip("_")
    return s

def fetch_score(symphony_id: str) -> dict:
    url = f"{API_BASE}/symphonies/{symphony_id}/score"
    resp = requests.get(url, auth=AUTH, timeout=30)
    resp.raise_for_status()
    return resp.json()

def process_symphony(symphony_id: str, label: str) -> dict:
    """Full pipeline for one symphony. Returns result dict."""
    slug = slugify(label)
    dsl_path      = OUT_DIR / f"{slug}.dsl"
    compiled_path = OUT_DIR / f"{slug}_compiled.json"

    print(f"\n{'─'*60}")
    print(f"  {label}")
    print(f"  ID: {symphony_id}  →  slug: {slug}")

    # 1. Fetch
    try:
        original_json = fetch_score(symphony_id)
        print(f"  Fetched: {len(json.dumps(original_json)):,} bytes")
    except Exception as e:
        print(f"  FETCH ERROR: {e}")
        return {"id": symphony_id, "label": label, "slug": slug,
                "status": "FETCH_ERROR", "error": str(e)}

    # 2. Convert JSON → DSL
    try:
        dsl_str = json_to_dsl(original_json)
        print(f"  DSL: {len(dsl_str):,} bytes, {len(dsl_str.splitlines())} lines")
    except Exception as e:
        print(f"  CONVERT ERROR: {e}")
        return {"id": symphony_id, "label": label, "slug": slug,
                "status": "CONVERT_ERROR", "error": str(e)}

    # 3. Compile DSL → JSON
    try:
        compiled = compile_dsl(dsl_str)
    except Exception as e:
        print(f"  COMPILE ERROR: {e}")
        # Still save the DSL even if compile fails
        dsl_path.write_text(dsl_str + "\n")
        print(f"  Saved DSL (compile failed): {dsl_path}")
        return {"id": symphony_id, "label": label, "slug": slug,
                "status": "COMPILE_ERROR", "error": str(e), "dsl_saved": True}

    # 4. Clean + merge
    try:
        cleaned = clean_compiled(compiled)
        merged  = merge_from_original(cleaned, original_json)
        print(f"  Compiled+merged: {len(json.dumps(merged)):,} bytes")
    except Exception as e:
        print(f"  CLEAN/MERGE ERROR: {e}")
        merged = compiled

    # 5. Save DSL
    dsl_path.write_text(dsl_str + "\n")
    print(f"  Saved: {dsl_path.name}")

    # 6. Save compiled JSON
    compiled_path.write_text(json.dumps(merged, indent=2) + "\n")
    print(f"  Saved: {compiled_path.name}")

    # 7. Quick structural check
    orig_bytes     = len(json.dumps(original_json))
    compiled_bytes = len(json.dumps(merged))
    compression    = 100 * (1 - len(dsl_str) / orig_bytes)
    print(f"  Compression: {compression:.0f}%  (JSON: {orig_bytes:,} → DSL: {len(dsl_str):,} → compiled: {compiled_bytes:,})")

    return {
        "id":            symphony_id,
        "label":         label,
        "slug":          slug,
        "status":        "OK",
        "orig_bytes":    orig_bytes,
        "dsl_bytes":     len(dsl_str),
        "dsl_lines":     len(dsl_str.splitlines()),
        "compiled_bytes": compiled_bytes,
        "compression_pct": round(compression, 1),
        "dsl_path":      str(dsl_path),
        "compiled_path": str(compiled_path),
    }


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    results = []

    print(f"\n{'='*60}")
    print(f"  Portfolio DSL Conversion — {len(SYMPHONIES)} symphonies")
    print(f"  Output: {OUT_DIR}")
    print(f"{'='*60}")

    for sym_id, label in SYMPHONIES:
        result = process_symphony(sym_id, label)
        results.append(result)

    # ── Report ─────────────────────────────────────────────────────────────────
    print(f"\n{'='*60}")
    print("  CONVERSION REPORT")
    print(f"{'='*60}\n")

    ok     = [r for r in results if r["status"] == "OK"]
    failed = [r for r in results if r["status"] != "OK"]

    report_lines = [
        "Portfolio DSL Conversion Report",
        f"Date: 2026-04-10",
        f"Symphonies: {len(results)} total, {len(ok)} OK, {len(failed)} failed",
        "",
        "── Results ──────────────────────────────────────────────────",
        "",
    ]

    for r in results:
        if r["status"] == "OK":
            report_lines.append(
                f"[OK]  {r['label']}"
            )
            report_lines.append(
                f"      ID: {r['id']}"
            )
            report_lines.append(
                f"      Slug: {r['slug']}"
            )
            report_lines.append(
                f"      DSL: {r['dsl_lines']} lines, {r['dsl_bytes']:,} bytes "
                f"({r['compression_pct']:.0f}% compression)"
            )
            report_lines.append(
                f"      Files: {r['slug']}.dsl  |  {r['slug']}_compiled.json"
            )
        else:
            report_lines.append(
                f"[{r['status']}]  {r['label']}"
            )
            report_lines.append(
                f"      ID: {r['id']}"
            )
            report_lines.append(
                f"      Error: {r.get('error', 'unknown')}"
            )
        report_lines.append("")

    report_lines += [
        "── Round-trip backtest ───────────────────────────────────────",
        "",
        "NOTE: Backtest round-trip (Step 3) deferred — manual Composer UI",
        "import required. User will handle imports and log Sharpe/MaxDD results.",
        "",
        "To complete round-trip validation:",
        "  1. Import each *_compiled.json into Composer UI",
        "  2. Save to get new symphony ID",
        "  3. Backtest original ID (2022-01-01 to 2022-12-31)",
        "  4. Backtest new ID same period",
        "  5. Compare Sharpe / MaxDD",
        "",
        "── Summary ───────────────────────────────────────────────────",
        "",
    ]

    if ok:
        total_orig     = sum(r["orig_bytes"]     for r in ok)
        total_dsl      = sum(r["dsl_bytes"]      for r in ok)
        total_compiled = sum(r["compiled_bytes"]  for r in ok)
        avg_compression = 100 * (1 - total_dsl / total_orig)
        report_lines.append(
            f"Total original JSON:  {total_orig:,} bytes"
        )
        report_lines.append(
            f"Total DSL:            {total_dsl:,} bytes  ({avg_compression:.0f}% avg compression)"
        )
        report_lines.append(
            f"Total compiled JSON:  {total_compiled:,} bytes"
        )

    report_text = "\n".join(report_lines) + "\n"
    report_path = OUT_DIR / "conversion_report.txt"
    report_path.write_text(report_text)

    print(report_text)
    print(f"Report saved to: {report_path}")

    # Print console summary
    print(f"\n{'─'*60}")
    for r in results:
        status_sym = "✓" if r["status"] == "OK" else "✗"
        print(f"  {status_sym}  {r['label']}")
        if r["status"] != "OK":
            print(f"     → {r['status']}: {r.get('error','')}")

    print(f"\n  {len(ok)}/{len(results)} succeeded")

    return 0 if not failed else 1


if __name__ == "__main__":
    sys.exit(main())
