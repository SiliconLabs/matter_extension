#!/usr/bin/env python3
"""
@file get_slce_extra_paths.py
@brief Recursively collect file and/or directory paths from one or more root folders and optionally insert them into a section of a matter.slce.extra file.

This utility walks the provided root directories, gathers matching paths (files by default, optionally directories), applies optional glob filtering,
normalises them (absolute or relative to the current working directory or their originating root), de-duplicates while preserving order, and then
either writes the resulting list to an output file or replaces the managed block that follows the marker line:

        # matter_sdk paths

inside a target matter.slce.extra file. When updating that file it can emit either YAML list entries (recommended) so they extend an existing list
context (e.g. `extra_files:`) or commented lines for legacy use. The previous generated block between the marker and the next top‑level key is
fully replaced on each run to ensure idempotency.

Typical use (YAML list insertion under default marker):
        python3 get_slce_extra_paths.py --roots third_party/matter_sdk/src/app/zap-templates/ \
                third_party/matter_sdk/src/app/zap-templates/zcl/ \
                --include-dirs --insertion-style yaml-list

Write raw list to a text file (LF endings) relative to CWD:
        python3 get_slce_extra_paths.py --roots src/ include/ --output paths.txt

Key behaviours:
    * Multiple roots accepted; paths aggregated & de-duplicated preserving first-seen order.
    * Relative base selectable: current working directory (default) or each root (first matching root wins) with fallback to CWD.
    * Optional glob `--pattern` applied individually to each candidate path.
    * Safe replacement of previously generated block (no incremental appends leading to duplication).
    * Hidden entries (names starting with '.') are ignored (both files and directories).

Exit codes (@retval):
    @retval 0 Success.
    @retval 1 A provided root path does not exist or is not a directory.
    @retval 2 Unhandled exception during traversal of a root.
    @retval 3 Failure writing plain output file.
    @retval 4 Target matter.slce.extra file not found.
    @retval 5 Failure reading matter.slce.extra.
    @retval 6 Marker line not found in matter.slce.extra.
    @retval 7 Failure writing updated matter.slce.extra.
    @retval 8 Missing --output when not using --slce-extra.
    @retval 9 Required always-include file missing.

@note If no --roots are supplied a built‑in list of default SDK template directories is used.
@note The marker text is currently hard-coded as "# matter_sdk paths"; adjust if the file format evolves.
@note The file third_party/matter_sdk/src/app/common/templates/config-data.yaml is always added (if it exists) in addition to discovered paths.
"""
import argparse
import os
import sys
from pathlib import Path
from typing import Iterable, List, Optional

def collect_paths(root: Path, include_dirs: bool, absolute: bool, pattern: Optional[str]) -> List[Path]:
    results: List[Path] = []
    root = root.resolve()
    for dirpath, dirnames, filenames in os.walk(root, followlinks=False):
        current_dir = Path(dirpath)
        # Prune hidden directories in-place to prevent descending into them
        dirnames[:] = [d for d in dirnames if not d.startswith('.')]

        if include_dirs:
            if not current_dir.name.startswith('.'):
                if pattern is None or current_dir.match(pattern):
                    results.append(current_dir)
        for name in filenames:
            # Skip hidden files
            if name.startswith('.'):
                continue
            p = current_dir / name
            if pattern is None or p.match(pattern):
                results.append(p)
    # Sort deterministically
    results.sort()
    # Absolute output requested
    if absolute:
        return results
    # Relative output is handled by caller (to allow different bases)
    return results

def main(argv: Iterable[str]) -> int:
    parser = argparse.ArgumentParser(
        description="Recursively list paths under a folder and write them to a file."
    )
    parser.add_argument("--roots", nargs="+", help="One or more root folders to walk")
    parser.add_argument("--output", nargs="?", help="File to write the list into (ignored if --slce-extra is used)")
    parser.add_argument("--absolute", action="store_true", help="Write absolute paths instead of relative")
    parser.add_argument(
        "--relative-base",
        choices=["cwd", "root"],
        default="cwd",
        help="When not using --absolute, choose base for relative paths: 'cwd' (current working directory) or 'root' (the provided root folder). Default: cwd",
    )
    parser.add_argument("--include-dirs", action="store_true", help="Include directory entries (default: only files)")
    parser.add_argument("--pattern", help="Optional glob pattern filter (applied to each path)")
    parser.add_argument("--newline", choices=["lf", "crlf"], default="lf", help="Line ending style (only for file output)")
    parser.add_argument(
        "--slce-extra",
        metavar="FILE",
        default="packages/matter/matter.slce.extra",
        help="Path to matter.slce.extra; if provided, insert collected paths as commented lines under the marker '# matter_sdk paths' instead of writing a separate output file",
    )
    parser.add_argument(
        "--comment-prefix",
        default="# ",
        help="Prefix to place before each inserted path line when updating matter.slce.extra (default: '# '). Ignored without --slce-extra.",
    )
    parser.add_argument(
        "--insertion-style",
        choices=["yaml-list", "comment"],
        default="yaml-list",
        help="How to add paths under the marker when using --slce-extra: 'yaml-list' creates '  - <path>' entries so they extend the preceding list (recommended); 'comment' creates commented lines using --comment-prefix (legacy). Default: yaml-list",
    )
    args = parser.parse_args(list(argv))

    # Collect from multiple roots
    if not args.roots:
        roots_paths = ["third_party/matter_sdk/src/app/"]
    else:
        roots_paths = args.roots

    roots: List[Path] = []
    aggregated: List[Path] = []
    for root_str in roots_paths:
        r = Path(root_str)
        if not r.exists():
            print(f"Error: root folder does not exist: {r}", file=sys.stderr)
            return 1
        if not r.is_dir():
            print(f"Error: root is not a directory: {r}", file=sys.stderr)
            return 1
        roots.append(r.resolve())
        try:
            collected = collect_paths(
                root=r,
                include_dirs=args.include_dirs,
                absolute=args.absolute,
                pattern=args.pattern,
            )
        except Exception as e:
            print(f"Error while collecting paths under {r}: {e}", file=sys.stderr)
            return 2
        aggregated.extend(collected)

    # Always-include specific paths (must exist)
    always_include = [Path("third_party/matter_sdk/src/app/common/templates/config-data.yaml")]
    for extra in always_include:
        if not (extra.exists() and extra.is_file()):
            print(f"Error: required file not found: {extra}", file=sys.stderr)
            return 9
        resolved = extra.resolve()
        if resolved not in aggregated:
            aggregated.append(resolved)

    # De-duplicate while preserving order
    seen = set()
    paths: List[Path] = []
    for p in aggregated:
        if p not in seen:
            seen.add(p)
            paths.append(p)

    # Representative root for single-root behaviors
    primary_root = roots[0]

    line_ending = "\r\n" if args.newline == "crlf" else "\n"

    # Adjust relative paths according to selected base unless absolute was requested
    if not args.absolute:
        adjusted: List[Path] = []
        if args.relative_base == "root":
            # For multiple roots attempt each root for relativity
            for p in paths:
                done = False
                for r in roots:
                    try:
                        adjusted.append(p.relative_to(r))
                        done = True
                        break
                    except ValueError:
                        continue
                if not done:
                    # Fallback to cwd
                    try:
                        adjusted.append(p.relative_to(Path.cwd()))
                    except ValueError:
                        adjusted.append(p)
        else:  # cwd base
            cwd_base = Path.cwd().resolve()
            for p in paths:
                try:
                    adjusted.append(p.relative_to(cwd_base))
                except ValueError:
                    adjusted.append(p)
        paths = adjusted
    if args.slce_extra:
        target_file = Path(args.slce_extra)
        if not target_file.exists():
            print(f"Error: --slce-extra file not found: {target_file}", file=sys.stderr)
            return 4
        try:
            text = target_file.read_text(encoding="utf-8").splitlines()
        except Exception as e:
            print(f"Error reading {target_file}: {e}", file=sys.stderr)
            return 5

        marker = "# matter_sdk paths"
        try:
            idx = next(i for i, line in enumerate(text) if line.strip() == marker)
        except StopIteration:
            print(f"Error: marker '{marker}' not found in {target_file}", file=sys.stderr)
            return 6

        # Find where to stop (next line that looks like a top-level key 'word:'), skipping any existing generated lines
        def is_top_level_key(l: str) -> bool:
            ls = l.lstrip()
            if ls.startswith('#') or not ls:
                return False
            return ls.split()[0].endswith(":") and not ls.startswith('-')

        end = idx + 1
        while end < len(text) and not is_top_level_key(text[end]):
            end += 1

        if args.insertion_style == "yaml-list":
            # Assume marker follows immediately after an existing YAML list key (e.g., extra_files:)
            # We add list items with two-space indent matching existing pattern '  - provision/...'
            new_lines = [f"  - {p}" for p in paths]
        else:
            new_lines = [f"{args.comment_prefix}{p}".rstrip() for p in paths]

        # Replace existing block
        updated = text[: idx + 1] + new_lines + text[end:]
        try:
            target_file.write_text("\n".join(updated) + "\n", encoding="utf-8")
        except Exception as e:
            print(f"Error writing {target_file}: {e}", file=sys.stderr)
            return 7
        print(f"Inserted {len(paths)} paths under marker in {target_file}")
    else:
        if not args.output:
            print("Error: output file required when --slce-extra is not used", file=sys.stderr)
            return 8
        out_path = Path(args.output)
        try:
            out_path.parent.mkdir(parents=True, exist_ok=True)
            with out_path.open("w", encoding="utf-8", newline="") as f:
                for p in paths:
                    f.write(str(p) + line_ending)
        except Exception as e:
            print(f"Error writing output file: {e}", file=sys.stderr)
            return 3
        print(f"Wrote {len(paths)} paths to {out_path}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))