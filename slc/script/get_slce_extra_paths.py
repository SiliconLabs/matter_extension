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
    @retval 10 No extension paths returned by git ls-files.
    @retval 11 'extra_files:' key not found in matter.slce.extra.

@note If no --roots are supplied a built‑in list of default SDK template directories is used.
@note The marker text is currently hard-coded as "# matter_sdk paths"; adjust if the file format evolves.
@note The file third_party/matter_sdk/src/app/common/templates/config-data.yaml is always added (if it exists) in addition to discovered paths.
"""
import argparse
import os
import subprocess
import sys
import yaml
from pathlib import Path
from typing import Iterable, List, Optional, Set

def _is_excluded_path(path: str) -> bool:
    """Return True for paths that should not appear in the extension package."""
    parts = path.split("/")
    # Exclude hidden directories
    if any(part.startswith(".") for part in parts[:-1]):
        return True
    # Exclude git meta files
    basename = parts[-1]
    if basename in (".gitignore", ".gitmodules"):
        return True
    # Exclude __pycache__ and bytecode
    if "__pycache__" in parts or basename.endswith(".pyc"):
        return True
    return False

def _git_tracked_extension_paths() -> List[str]:
    """Return sorted list of git tracked files, excluding submodule entries."""
    submodules = set()
    stage = subprocess.run(
        ["git", "ls-files", "--stage"],
        capture_output=True, text=True, check=True,
    )
    for line in stage.stdout.splitlines():
        if line.startswith("160000"):
            submodules.add(line.split("\t", 1)[1])

    result = subprocess.run(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard"],
        capture_output=True, text=True, check=True,
    )
    return sorted(
        p for p in result.stdout.splitlines()
        if p not in submodules and not _is_excluded_path(p) and os.path.exists(p)
    )

COMPONENT_ROOT = Path("slc/component")

def _discover_component_ids(component_root: Path, repo_root: Path) -> Set[str]:
    """Find all .slcc under component_root and collect their YAML id: values."""
    base = repo_root / component_root
    ids: Set[str] = set()
    if not base.exists() or not base.is_dir():
        return ids
    for slcc in base.rglob("*.slcc"):
        try:
            data = yaml.safe_load(slcc.read_text(encoding="utf-8"))
            if isinstance(data, dict) and data.get("id"):
                ids.add(str(data["id"]).strip())
        except (yaml.YAMLError, OSError):
            continue
    return ids

def _add_path_refs(refs: Set[str], item: dict) -> None:
    """Add path and any file_list paths from a single component list item."""
    if not isinstance(item, dict) or not item.get("path"):
        return
    base = str(item["path"]).strip().replace("\\", "/")
    if not base or base.startswith("#"):
        return
    refs.add(base)
    for fl in item.get("file_list") or []:
        if isinstance(fl, dict) and fl.get("path"):
            sub = str(fl["path"]).strip().replace("\\", "/")
            if sub:
                refs.add(base.rstrip("/") + "/" + sub.lstrip("/"))
        elif isinstance(fl, str):
            refs.add(base.rstrip("/") + "/" + fl.strip().lstrip("/"))

def _referenced_paths_from_slcc(component_root: Path, repo_root: Path) -> Set[str]:
    """Collect paths referenced in components under component_root."""
    refs: Set[str] = set()
    base = repo_root / component_root
    if not base.exists() or not base.is_dir():
        return refs
    for slcc in base.rglob("*.slcc"):
        try:
            data = yaml.safe_load(slcc.read_text(encoding="utf-8"))
        except (yaml.YAMLError, OSError):
            continue
        if not isinstance(data, dict):
            continue
        for value in data.values():
            if not isinstance(value, list):
                continue
            for item in value:
                _add_path_refs(refs, item)
    return refs

def _update_components_block(text: List[str], component_ids: Set[str]) -> List[str]:
    """Replace the components: list in text with sorted component_ids."""
    try:
        comp_idx = next(i for i, line in enumerate(text) if line.strip() == "components:")
    except StopIteration:
        return text
    end = comp_idx + 1
    while end < len(text):
        line = text[end]
        stripped = line.strip()
        if stripped.startswith("- "):
            end += 1
            continue
        if stripped and not stripped.startswith("#") and ":" in stripped.split()[0]:
            break
        end += 1
    new_lines = [f"  - {cid}" for cid in sorted(component_ids)]
    return text[: comp_idx + 1] + new_lines + text[end:]

def _update_extension_paths(text: List[str], sdk_marker: str, referenced: Set[str]) -> List[str]:
    """
    Set extra_files to all extension files minus paths referenced by components.
    """
    all_paths = set(_git_tracked_extension_paths())
    if not all_paths:
        print("Error: git ls-files returned no extension paths", file=sys.stderr)
        raise SystemExit(10)
    try:
        extra_idx = next(i for i, line in enumerate(text) if line.strip() == "extra_files:")
    except StopIteration:
        print("Error: 'extra_files:' not found", file=sys.stderr)
        raise SystemExit(11)
    try:
        sdk_idx = next(i for i, line in enumerate(text) if line.strip() == sdk_marker)
    except StopIteration:
        print(f"Error: '{sdk_marker}' not found", file=sys.stderr)
        raise SystemExit(6)

    expanded_refs = set()
    for ref in referenced:
        if ref in all_paths:
            expanded_refs.add(ref)
        else:
            ref_prefix = ref.rstrip("/") + "/"
            for path in all_paths:
                if path.startswith(ref_prefix):
                    expanded_refs.add(path)
    extra_files_set = all_paths - expanded_refs
    all_paths_sorted = sorted(extra_files_set)
    new_ext_lines = [f"  - {p}" for p in all_paths_sorted]
    updated = text[: extra_idx + 1] + new_ext_lines + text[sdk_idx:]
    print(f"Updated {len(new_ext_lines)} extra_files (all extension files minus component-referenced)")
    return updated

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
        repo_root = Path.cwd().resolve()

        # Sync components block
        component_ids = _discover_component_ids(COMPONENT_ROOT, repo_root)
        if component_ids:
            text = _update_components_block(text, component_ids)
            print(f"Updated components block with {len(component_ids)} component ids")
        referenced = _referenced_paths_from_slcc(COMPONENT_ROOT, repo_root)

        # extra_files = all extension files minus referenced
        text = _update_extension_paths(text, marker, referenced)

        # Update sdk paths
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
        print(f"Inserted {len(paths)} SDK paths under marker in {target_file}")
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
