#!/usr/bin/env python3
"""
Validate that every demos.imageFile in matter_demos.xml has:
  1. A matching .slcw file present in the repository
  2. A board listed in CI json files that corresponds to the solution

Run from the repository root:
    python3 slc/script/validate_demo_images.py
"""

import json
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

_SOLUTION_JSON_MAP = [
    (r"_series_2_internal_freertos$",  ["mg24-internal", "mgm24-internal", "mg26-internal", "mgm26-internal"]),
    (r"_trustzone_series_2_freertos$", ["mg24-trustzone"]),
    (r"_series_2_freertos$",           ["mg24", "mgm24", "mg26"]),
    (r"_series_3_freertos$",           ["sixg301"]),
    (r"wifi_soc_",                     ["siwx"]),
    (r"917_ncp_",                      ["917-ncp"]),
]

_SOLUTION_NAME_PREFIXES = [
    "matter_thread_soc_",
    "matter_wifi_soc_",
    "matter_wifi_917_ncp_",
]

_SOLUTION_NAME_SUFFIXES = [
    "_series_2_internal_freertos",
    "_trustzone_series_2_freertos",
    "_series_2_freertos",
    "_series_3_freertos",
    "_freertos",
]

def _parse_image_uri(uri: str) -> dict | None:
    """
    Parse image file uri from demos xml file
    Returns dict with keys: board, solution_dir, solution_name, output_suffix, artifact_file
    """
    m = re.match(
        r"asset://[^/]+/demos/([^/]+)/([^/]+)/artifact/(.+)$",
        uri,
    )
    if not m:
        return None

    board_raw, solution_dir, artifact_file = m.group(1), m.group(2), m.group(3)
    board = board_raw.split(",")[0].lower()

    sol_match = re.match(r"^(.+?)_solution(?:_(.+))?$", solution_dir)
    if not sol_match:
        return None

    solution_name = sol_match.group(1)
    output_suffix = sol_match.group(2) or ""

    return {
        "board": board,
        "solution_dir": solution_dir,
        "solution_name": solution_name,
        "output_suffix": output_suffix,
        "artifact_file": artifact_file,
        "uri": uri,
    }

def _app_key_from_solution_name(solution_name: str) -> str:
    """Strip protocol prefix and series suffix to get the bare app name"""
    s = solution_name
    for prefix in _SOLUTION_NAME_PREFIXES:
        if s.startswith(prefix):
            s = s[len(prefix):]
            break
    for suffix in _SOLUTION_NAME_SUFFIXES:
        if s.endswith(suffix):
            s = s[: -len(suffix)]
            break
    return s

def _json_keys_for_solution_name(solution_name: str) -> list[str]:
    """Return list of json file identifiers that CI uses for this solution"""
    for pattern, json_keys in _SOLUTION_JSON_MAP:
        if re.search(pattern, solution_name):
            return json_keys
    return []

def _board_covered_in_json(
    json_path: Path, app_key: str, board: str, solution_name: str, output_suffix: str
) -> bool:
    """Return True if the json file has a board entry in full"""
    with open(json_path) as f:
        data = json.load(f)
    apps = data.get("full", {})
    for key in (app_key, "default"):
        for entry in apps.get(key, []):
            args = " ".join(entry.get("arguments", []))
            entry_suffix_match = re.search(r"--output_suffix\s+(\S+)", args)
            entry_suffix = entry_suffix_match.group(1) if entry_suffix_match else ""
            if entry_suffix != output_suffix:
                continue
            entry_boards = {b.split(",")[0].lower() for b in entry.get("boards", [])}
            if any(b == board or b.startswith(board + "_") for b in entry_boards):
                return True
    return False

def _collect_slcw_names(root: Path) -> dict[str, Path]:
    """Return mapping of solution name to path for every slcw in slc/apps/"""
    names: dict[str, Path] = {}
    for p in (root / "slc" / "apps").rglob("*.slcw"):
        names[p.stem] = p
    return names

def _parse_demos_xml(xml_path: Path) -> list[str]:
    root = ET.parse(xml_path).getroot()
    uris: list[str] = []
    for demo in root:
        for prop in demo:
            if (
                prop.tag.split("}")[-1] == "property"
                and prop.attrib.get("key") == "demos.imageFile"
            ):
                uris.append(prop.attrib.get("value", ""))
    return uris

def validate(demos_xml: Path, repo_root: Path) -> int:
    github_dir = repo_root / ".github"
    slcw_names = _collect_slcw_names(repo_root)
    uris = _parse_demos_xml(demos_xml)
    unique_uris = sorted(set(uris))

    failures: list[str] = []
    warnings: list[str] = []
    ok_count = 0

    for uri in unique_uris:
        parsed = _parse_image_uri(uri)
        if parsed is None:
            warnings.append(f"SKIP  could not parse URI: {uri}")
            continue

        solution_name = parsed["solution_name"]
        board = parsed["board"]
        suffix = parsed["output_suffix"]
        app_key = _app_key_from_solution_name(solution_name)

        errs: list[str] = []

        # Artifact filename follows expected convention
        artifact = parsed["artifact_file"]
        expected_artifacts = (f"{solution_name}_full.s37", f"{solution_name}.rps")
        if artifact not in expected_artifacts:
            errs.append(f"unexpected artifact filename '{artifact}' (expected one of: {', '.join(expected_artifacts)})")

        # .slcw file exists
        if solution_name not in slcw_names:
            errs.append(f"no .slcw found for '{solution_name}'")

        # Board and suffix covered in CI json for this solution type
        json_keys = _json_keys_for_solution_name(solution_name)
        if not json_keys:
            errs.append(f"unknown solution type, cannot determine CI json for '{solution_name}'")
        else:
            covered = False
            for jk in json_keys:
                p = github_dir / f"silabs-builds-{jk}.json"
                if p.exists() and _board_covered_in_json(p, app_key, board, solution_name, suffix):
                    covered = True
                    break
            if not covered:
                suffix_label = f" (suffix '{suffix}')" if suffix else ""
                errs.append(f"board '{board}'{suffix_label} not covered in CI json for app '{app_key}' (checked: {', '.join(json_keys)})")

        if errs:
            failures.append(f"FAIL  {board} / {solution_name}{('_' + suffix) if suffix else ''}\n      " + "\n      ".join(errs))
        else:
            ok_count += 1

    for w in warnings:
        print(w)

    if failures:
        print(f"\n{'='*70}")
        print(f"FAILURES ({len(failures)}):")
        print(f"{'='*70}")
        for f in failures:
            print(f)
        print(f"\n{ok_count} passed, {len(failures)} failed, {len(warnings)} skipped")
        return 1

    print(f"OK  {ok_count} unique demo image slots validated ({len(warnings)} skipped)")
    return 0

def main() -> None:
    repo_root = Path(__file__).parents[2]
    rc = validate(repo_root / "matter_demos.xml", repo_root)
    sys.exit(rc)

if __name__ == "__main__":
    main()
