#!/usr/bin/env python3
"""Scan recursively for .slcc component files missing metadata.sbom section (license required).

Only .slcc files that reference source code (.c, .cpp, .h) anywhere in their text are required to have metadata.sbom.license.
References are detected by a simple substring search using a regex for paths ending in those extensions. If none of these extensions appear, the component is skipped.

Quick start:
  ./scripts/find_missing_sbom.py slc/component

Usage:
  python find_missing_sbom.py <root_dir> [--verbose]

Arguments:
  <root_dir>   Directory to start recursive search.

Options:
  --verbose    Show per-file scan logs and problem details immediately.

Exit codes:
  0 success (no required components missing sbom/license)
  1 missing sbom/license detected
  2 invalid arguments

Detection rules:
  A file is considered to REQUIRE sbom if it contains a reference to at least one C/C++ source/header file extension (.c, .cpp, .h). Required means metadata.sbom must exist as a mapping and include 'license'. Parse errors count as missing if the file requires sbom. Files without source references are ignored.
"""
from __future__ import annotations
import sys
import argparse
import logging
import re
from pathlib import Path
from typing import List

try:
    import yaml  # type: ignore
except ImportError:  # fallback minimal parser
    yaml = None

SOURCE_EXT_PATTERN = re.compile(r"\b[\w/-]+\.(c|cpp|h)\b")

def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Find .slcc files missing metadata.sbom.license (only for components referencing source code)")
    p.add_argument("root", help="Root directory to scan")
    p.add_argument("--verbose", action="store_true", help="Show per-file scan logs")
    return p.parse_args()

def setup_logging(verbose: bool) -> None:
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(level=level, format="[%(levelname)s] %(message)s")
    if not verbose:
        logging.getLogger("yaml").setLevel(logging.WARNING)

logger = logging.getLogger(__name__)

def iter_slcc_files(root: Path) -> List[Path]:
    return list(root.rglob("*.slcc"))

def slcc_requires_sbom(text: str) -> bool:
    return bool(SOURCE_EXT_PATTERN.search(text))

def has_sbom_with_license(text: str) -> tuple[bool, str | None]:
    """Return (has_sbom_with_license, error) given raw file text."""
    data = None
    if yaml is not None:
        try:
            data = yaml.safe_load(text)
        except Exception as e:
            return False, f"YAML parse error: {e}"
    else:
        lines = [l.strip() for l in text.splitlines()]
        meta_idx = next((i for i,l in enumerate(lines) if l.startswith("metadata:")), -1)
        if meta_idx == -1:
            return False, None
        sbom_idx = next((i for i,l in enumerate(lines[meta_idx+1:meta_idx+50]) if l.startswith("sbom:")), -1)
        if sbom_idx == -1:
            return False, None
        license_present = any("license:" in l for l in lines[meta_idx+1:meta_idx+100])
        return (license_present, None if license_present else "sbom present but license missing")
    if not isinstance(data, dict):
        return False, "Top-level YAML is not a mapping"
    meta = data.get("metadata")
    if not isinstance(meta, dict):
        return False, None
    sbom = meta.get("sbom")
    if not isinstance(sbom, dict):
        return False, None
    if "license" not in sbom:
        return False, "license missing in sbom"
    return True, None


def main() -> int:
    ns = parse_args()
    setup_logging(ns.verbose)
    root = Path(ns.root).resolve()
    if not root.exists():
        logger.error(f"Root path '{root}' does not exist")
        return 2

    files = iter_slcc_files(root)
    missing: list[str] = []
    problems: list[str] = []
    skipped: list[str] = []

    for f in files:
        try:
            text = f.read_text(encoding="utf-8", errors="replace")
        except Exception as e:
            problems.append(f"{f}: File read error: {e}")
            logger.debug(f"Problem: {f}: File read error: {e}") if ns.verbose else None
            continue
        requires = slcc_requires_sbom(text)
        if not requires:
            skipped.append(str(f))
            logger.debug(f"SKIP(no source): {f}") if ns.verbose else None
            continue
        present, err = has_sbom_with_license(text)
        if present:
            logger.debug(f"OK: {f}") if ns.verbose else None
        else:
            logger.debug(f"MISSING: {f}") if ns.verbose else None
            missing.append(str(f))
        if err:
            problems.append(f"{f}: {err}")
            logger.debug(f"Problem: {f}: {err}") if ns.verbose else None

    if ns.verbose:
        logger.info(f"Scanned files total={len(files)}, required={len(files)-len(skipped)}, skipped(no source)={len(skipped)}")
        if problems:
            logger.info("Problems encountered (treated as missing):")
            for p in problems:
                logger.info(p)

    logger.info(f"Components missing metadata.sbom.license (required components count={len(files)-len(skipped)}, missing={len(missing)}):")
    for m in missing:
        logger.info(m)
    if not ns.verbose and problems:
        logger.info(f"(Encountered {len(problems)} problems while parsing; run with --verbose for details)")

    # Exit code decision
    return 1 if missing else 0

if __name__ == "__main__":
    raise SystemExit(main())
