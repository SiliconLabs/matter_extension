#!/usr/bin/env python3

"""
@file generate_pkg_slt.py
@brief Generate pkg.slt files adjacent to SLC projects (.slcp / .slcw) with
       pinned dependency versions (Matter + platform-specific extras).

OVERVIEW
    Walk a base directory (recursively) and, for every directory containing at
    least one .slcp or .slcw file, (re)write a pkg.slt file. Existing files are
    overwritten for consistency (idempotent output).

MATTER VERSION RESOLUTION (priority)
    1. Explicit --matter-version CLI argument.
    2. Version field from the matter.slce file in the extension root (auto-appended with "-0.dev").

DEPENDENCY VERSIONS SOURCE
    Non-Matter dependency versions are loaded from 'dependency_versions.yaml' which
    supports both grouped format (common/thread/wifi) and legacy flat format.
    Groups allow fine-grained control over which dependencies are included for each platform.

PLATFORM HEURISTICS (when --common is NOT used)
    - Path components NOT containing 'wifi' => Thread group dependencies appended.
    - Path components containing 'wifi'     => Wi-Fi group dependencies appended.
    - Common group dependencies are included for all platforms.
    - Matter dependency is always included first.

--common MODE
    Every discovered project receives uniform content consisting of just the
    Matter dependency plus any dependencies in the 'common' group.

SAMPLE APP PACKAGE
    By default (--update-sample-app-pkg True), also generates 'packages/matter_app/pkg.slt' 
    in the packages/matter_app directory, pointing at 'matter_app' rather than 'matter'.
    Disable with --update-sample-app-pkg False.

VERSION-ONLY MODE
    Use --version-only to resolve and print just the Matter version without 
    generating any pkg.slt files. Useful for scripting and Makefiles.

EXCLUDES
    Directories can be skipped using --exclude/-e. Each value is a substring
    match applied to full directory paths. Multiple excludes can be provided by
    repeating -e or supplying comma-separated values. If no excludes are
    provided, 'third_party' is excluded by default.

SAFETY / IDEMPOTENCE
    Output is deterministic given the same inputs (YAML, flags, version). Files
    are always overwritten, eliminating drift.

USAGE EXAMPLES
    python3 slc/script/generate_pkg_slt.py -d slc                      # heuristic mode
    python3 slc/script/generate_pkg_slt.py -d slc --common             # uniform content
    python3 slc/script/generate_pkg_slt.py -d slc --matter-version 2.7.0-beta.1
    python3 slc/script/generate_pkg_slt.py -d slc -e build,temp,legacy # exclude multiple
    python3 slc/script/generate_pkg_slt.py --verbose
    python3 slc/script/generate_pkg_slt.py --version-only              # just print version
    python3 slc/script/generate_pkg_slt.py --update-sample-app-pkg False

ARGUMENT SUMMARY
    --directory, -d               Base directory to search (default: cwd)
    --verbose, -v                 Enable verbose logging
    --common                      Ignore platform heuristics; emit Matter + common deps only
    --matter-version              Override Matter version (else read from matter.slce)
    --version-only                Only resolve and print Matter version, then exit
    --exclude, -e                 Directory exclude pattern (repeatable/comma-separated)
    --update-sample-app-pkg, -s   Generate packages/matter_app/pkg.slt (default: True)

EXIT CODES
    0 on success; 1 if the Matter version cannot be resolved.
"""

import os
import sys
import argparse
import logging
from typing import Dict, Optional, Any
import yaml

# Module-level logger (configured once in main)
logger = logging.getLogger(__name__)


def _load_grouped_versions(filename: str = "dependency_versions.yaml") -> Dict[str, Dict[str, str]]:
    """Load grouped dependency versions (common/thread/wifi) from YAML.

    Accepts either new grouped format or legacy flat mapping. Returns a dict:
        { "common": {...}, "thread": {...}, "wifi": {...} }
    Fallback provides minimal defaults if the file is missing or malformed.
    """
    script_dir = os.path.dirname(os.path.abspath(__file__))
    candidates = [
        os.path.join(script_dir, filename),
        os.path.join(script_dir, "..", "..", filename),
        os.path.join(os.getcwd(), filename),
    ]
    raw: Dict[str, Any] = {}
    for path in candidates:
        if os.path.exists(path):
            try:
                with open(path, "r", encoding="utf-8") as f:
                    data = yaml.safe_load(f) or {}
                if isinstance(data, dict):
                    raw = data
                    logger.debug("Loaded dependency versions from %s", path)
                    break
            except Exception as e:
                logger.error("Failed parsing dependency versions file %s: %s", path, e)
                break
    grouped: Dict[str, Dict[str, str]]
    if raw and any(k in raw for k in ("thread", "wifi", "common")):
        grouped = {
            "common": raw.get("common", {}) or {},
            "thread": raw.get("thread", {}) or {},
            "wifi": raw.get("wifi", {}) or {},
        }
    elif raw:  # legacy flat mapping; no explicit groups provided
        # Instead of maintaining hardcoded dependency name lists, just put all
        # flat keys into both 'thread' and 'wifi' groups so additions require
        # no script changes. Keep 'common' empty (or could optionally lift
        # universally shared entries there later).
        flat_items = {k: v for k, v in raw.items() if k not in ("common", "thread", "wifi")}
        grouped = {
            "common": {},
            "thread": dict(flat_items),
            "wifi": dict(flat_items),
        }
    else:
        logger.warning("dependency_versions.yaml not found; using embedded fallback versions")
        grouped = {
            "common": {"bluetooth_le_host": "0.0.6"},
            "thread": {"openthread": "0.1.5", "rail_module": "0.0.5"},
            "wifi": {"platform_nwp_siwx91x": "0.0.3", "bluetooth_le_siwx91x": "0.0.3", "lwip": "0.0.5"},
        }
    return grouped


DEP_GROUPS = _load_grouped_versions()


def build_content_strings(matter_version: str):
    """Return header plus platform-specific dependency blocks using grouped versions.

    The returned tuple is (common_header, thread_block, wifi_block, all_header).
    For now 'common_header' and 'all_header' are identical (Matter only) to preserve
    previous behavior when --common is supplied.
    """
    header = f"""# Version defaults to "0" if not defined
version = "0"
 
 
[dependency]
# Get a specific version of the package
matter = {{ version = "{matter_version}", installer ="conan", prerelease=true }}
"""

    def merged_lines(group_name: str) -> str:
        # Merge common first, then group-specific (group overrides duplicates)
        common = DEP_GROUPS.get("common", {})
        specific = DEP_GROUPS.get(group_name, {})
        merged: Dict[str, str] = dict(common)
        # Maintain insertion order: add keys from specific (overwriting any duplicates)
        for k, v in specific.items():
            merged[k] = v
        # Simple emission: rely on merged dict insertion order (Python 3.7+ preserves it)
        #  - common entries first
        #  - followed by group-specific additions / overrides
        lines = []
        for name, ver in merged.items():
            if name == "matter":
                continue
            lines.append(f"{name} = {{ version = \"{ver}\", installer =\"conan\", prerelease=true }}\n")
        return "".join(lines)

    thread_block = merged_lines("thread")
    wifi_block = merged_lines("wifi")
    logger.debug("Resolved dependency groups: %s", DEP_GROUPS)
    logger.debug("Thread block emitted:\n%s", thread_block)
    logger.debug("WiFi block emitted:\n%s", wifi_block)
    return header, thread_block, wifi_block, header


def resolve_matter_version(cli_version: Optional[str]) -> str:
    """Determine the Matter package version to embed.

    Priority:
      1. --matter-version CLI argument if provided
      2. Version field from matter.slce file in the extension root
    Exits with error if neither source provides a version.
    """
    if cli_version:
        logger.debug("Matter version provided via CLI: %s", cli_version)
        return cli_version

    script_dir = os.path.dirname(os.path.abspath(__file__))
    logger.debug("Script directory: %s", script_dir)
    
    # Try matter.slce file
    slce_file = os.path.join(script_dir, "..", "..", "matter.slce")
    try:
        with open(slce_file, "r", encoding="utf-8") as sf:
            slce_data = yaml.safe_load(sf)
            if slce_data and "version" in slce_data:
                version = str(slce_data["version"]).strip()
                if version:
                    version = version+"-0.dev"
                    logger.debug("Matter version read from matter.slce: %s", version)
                    return version
                else:
                    logger.warning("Version field in %s is empty", slce_file)
    except FileNotFoundError:
        logger.debug("matter.slce file %s not found", slce_file)
    except Exception as e:
        logger.warning("Failed to parse matter.slce file %s: %s", slce_file, e)

    logger.error("Unable to determine Matter package version: provide --matter-version or ensure matter.slce has a valid version field.")
    sys.exit(1)

def generate_pkg_slt(verbose, pkg_slt_path, stack, matter_version, exclude_patterns):
    logger.info(f"Generating {pkg_slt_path} for Matter version: {matter_version}")
    pkg_slt_content = f"""# Version defaults to "0" if not defined
version = "0"
 
 
[dependency]
# Get a specific version of the package
{stack} = {{ version = "{matter_version}", installer ="conan", prerelease=true }}
"""
    with open(pkg_slt_path, "w", encoding="utf-8") as pkg_slt_file:
        pkg_slt_file.write(pkg_slt_content)
    logger.debug(f"Generated {pkg_slt_path}")

def generate_pkg_slt_files(base_directory, verbose, common, matter_version, exclude_patterns):
    logger.info(f"Using Matter package version: {matter_version}")

    pkg_slt_content_common, pkg_slt_content_thread, pkg_slt_content_wifi, pkg_slt_content_all = build_content_strings(matter_version)

    for root, dirs, files in os.walk(base_directory):
        # Skip whole subtree if root matches an exclude pattern
        if any(patt and patt in root for patt in exclude_patterns):
            logger.debug(f"Skipping excluded directory tree: {root}")
            continue
        # Prune traversal: remove excluded dirs from in-place list
        if exclude_patterns:
            pruned = []
            for d in dirs:
                full = os.path.join(root, d)
                if any(patt and patt in full for patt in exclude_patterns):
                    logger.debug(f"Pruning excluded subdirectory: {full}")
                else:
                    pruned.append(d)
            dirs[:] = pruned
        # Require presence of at least one .slcp/.slcw
        if not any(file.endswith((".slcp", ".slcw")) for file in files):
            continue

        if common:
            pkg_slt_content = pkg_slt_content_all
        else:
            path_components = os.path.normpath(root).split(os.path.sep)
            if "wifi" not in path_components:
                pkg_slt_content = pkg_slt_content_common + pkg_slt_content_thread
                # logger.debug("efr app contents = %s", pkg_slt_content_thread)
            else:
                pkg_slt_content = pkg_slt_content_common + pkg_slt_content_wifi
                # logger.debug("wifi app contents = %s", pkg_slt_content_wifi)

        pkg_slt_path = os.path.join(root, "pkg.slt")
        try:
            with open(pkg_slt_path, "w", encoding="utf-8") as pkg_slt_file:
                pkg_slt_file.write(pkg_slt_content)
            logger.debug(f"Generated pkg.slt in: {pkg_slt_path}")
        except Exception as e:
            logger.error(f"Failed to generate pkg.slt in {pkg_slt_path}: {e}")


def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Generate pkg.slt files in directories containing .slcp files.")
    parser.add_argument("--directory", "-d", default=os.getcwd(),
                        help="Base directory to search for .slcp files. Defaults to current working directory.")
    parser.add_argument("--verbose", "-v", action="store_true", help="Enable verbose logging.")
    parser.add_argument("--common", action="store_true",
                        help="Generate pkg.slt using only the universal pkg_slt_content_all for every project.")
    parser.add_argument("--matter-version", help="Explicit Matter package version to embed; overrides matter.slce file.")
    parser.add_argument("--version-only", action="store_true", help="Only resolve and print the Matter version, then exit.")
    parser.add_argument("--exclude", "-e", action="append", default=[],
                        help="Directory exclude pattern (substring match). Can be repeated or provide comma-separated values.")
    parser.add_argument("--update-sample-app-pkg", "-s", type=lambda x: x.lower() in ('true', '1', 'yes', 'on'), 
                        default=True, metavar="BOOL",
                        help="Update packages/matter_app/pkg.slt (default: True). Use 'False', 'True', '0', '1', 'yes', 'no', 'on', 'off'.")
    parser.add_argument("--update-stack-pkg", "-k", type=lambda x: x.lower() in ('true', '1', 'yes', 'on'), 
                        default=True, metavar="BOOL",
                        help="Update packages/matter/pkg.slt (default: True). Use 'False', 'True', '0', '1', 'yes', 'no', 'on', 'off'.")
    args = parser.parse_args()

    # Configure logging once here so all helper functions share configuration
    log_level = logging.DEBUG if args.verbose else logging.INFO
    logging.basicConfig(level=log_level, format="%(message)s")
    logger.debug("Logging initialized (level=%s)", logging.getLevelName(log_level))
    matter_version = resolve_matter_version(args.matter_version)
    
    # If only version resolution is requested, print and exit
    if args.version_only:
        print(matter_version)
        sys.exit(0)  # Explicit success exit code
    
    # Flatten comma-separated patterns
    exclude_patterns = []
    for entry in args.exclude:
        if entry:
            exclude_patterns.extend([p.strip() for p in entry.split(',') if p.strip()])
    if not exclude_patterns:
        exclude_patterns = ["third_party"]
        logger.info("No --exclude provided; defaulting to exclude: %s", exclude_patterns)
    if exclude_patterns and args.verbose:
        logger.debug(f"Exclude patterns: {exclude_patterns}")
    generate_pkg_slt_files(args.directory, args.verbose, args.common, matter_version, exclude_patterns)
    if args.update_sample_app_pkg:
        generate_pkg_slt(args.verbose, 'packages/matter_app/pkg.slt', 'matter_app', matter_version, exclude_patterns)
    if args.update_stack_pkg:
        generate_pkg_slt(args.verbose, 'packages/matter/pkg.slt', 'matter', matter_version, exclude_patterns)

if __name__ == "__main__":
    main()