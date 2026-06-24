#!/usr/bin/env python3
"""
Validate project files under slc/apps against sisdk standardization spec:
https://confluence.silabs.com/spaces/SDX/pages/115268192/SDK+Requirements+for+Presentation+in+Simplicity+Studio

Usage:
  python3 slc/script/validate_app_standardization.py
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Callable, Dict, List, Mapping, Optional, Sequence, Tuple

try:
    import yaml
except ImportError as exc:
    print("PyYAML is required, run: pip install pyyaml", file=sys.stderr)
    raise SystemExit(2) from exc

REPO_ROOT = Path(__file__).resolve().parent.parent.parent
DEFAULT_APPS_DIR = REPO_ROOT / "slc" / "apps"


def _path_for_report(path: Path) -> str:
    """Prefer repo-relative paths in messages, avoid ValueError if outside REPO_ROOT"""
    try:
        return path.relative_to(REPO_ROOT).as_posix()
    except ValueError:
        return path.as_posix()

ALLOWED_TYPES: frozenset[str] = frozenset({"SoC Project", "RCP Project", "NCP Project", "Host"})
ALLOWED_DIFFICULTY: frozenset[str] = frozenset({"Beginner", "Advanced"})

_ROLE_TOKEN = re.compile(r"(?<=_)(soc|ncp|rcp|host)(?=_)")

_NCP_README_HINT = re.compile(
    r"(ncp|network\s+co-?processor|co-?processor|"
    r"host\s+(mcu|processor|application|app)|"
    r"companion\s+(project|application|app)|"
    r"siwx917|917\s+ncp|efr32.*917)",
    re.IGNORECASE | re.DOTALL,
)

_APP_NAME_RE = re.compile(r"^[a-z][a-z0-9_]*$")

_DESCRIPTION_ALLOWED_PREFIXES: Tuple[str, ...] = (
    "Demonstrates a sample implementation of ",
    "Demonstrates a POC of ",
)
@dataclass(frozen=True)
class _LabelClaimRequiresProjectName:
    """If label matches label_pattern, project_name must satisfy name_ok"""

    label_pattern: re.Pattern[str]
    name_ok: Callable[[str, Sequence[str]], bool]
    error: str

_LABEL_CLAIM_REQUIRES_PROJECT_NAME: Tuple[_LabelClaimRequiresProjectName, ...] = (
    _LabelClaimRequiresProjectName(
        re.compile(r"\bTrustZone\b", re.IGNORECASE),
        lambda _n, segs: "trustzone" in segs,
        "label taxonomy: label claims TrustZone but 'trustzone' not in project_name",
    ),
    _LabelClaimRequiresProjectName(
        re.compile(r"\bZigbee\b", re.IGNORECASE),
        lambda _n, segs: "zigbee" in segs,
        "label taxonomy: label claims Zigbee but 'zigbee' not in project_name",
    ),
    _LabelClaimRequiresProjectName(
        re.compile(r"\bDual Stack\b", re.IGNORECASE),
        lambda n, _segs: "dual_stack" in n,
        "label taxonomy: label claims Dual Stack but 'dual_stack' not in project_name",
    ),
)
@dataclass
class FileReport:
    path: Path
    issues: List[str] = field(default_factory=list)

    def add(self, message: str) -> None:
        self.issues.append(message)

def _load_yaml(path: Path) -> Tuple[Optional[Any], Optional[str]]:
    try:
        text = path.read_text(encoding="utf-8")
    except OSError as exc:
        return None, f"cannot read file: {exc}"
    try:
        return yaml.safe_load(text), None
    except yaml.YAMLError as exc:
        return None, f"YAML parse error: {exc}"

def _filter_map(data: Mapping[str, Any]) -> Dict[str, List[str]]:
    out: Dict[str, List[str]] = {}
    raw = data.get("filter")
    if not isinstance(raw, list):
        return out
    for entry in raw:
        if not isinstance(entry, dict):
            continue
        name = entry.get("name")
        val = entry.get("value")
        if not isinstance(name, str):
            continue
        if isinstance(val, list) and all(isinstance(x, str) for x in val):
            out[name] = list(val)
        elif isinstance(val, str):
            out[name] = [val]
    return out

def _readme_paths(data: Mapping[str, Any], base_dir: Path) -> List[Path]:
    readme = data.get("readme")
    if not isinstance(readme, list):
        return []
    paths: List[Path] = []
    for item in readme:
        if not isinstance(item, dict):
            continue
        p = item.get("path")
        if isinstance(p, str) and p.lower().endswith(".md"):
            paths.append((base_dir / p).resolve())
    return paths

_SLCP_PROJECT_NAMES_EXEMPT_README: frozenset[str] = frozenset(
    {
        "matter_thread_soc_code_size_sensor_freertos",
    }
)

def _slcp_exempt_readme(project_name: str) -> bool:
    return project_name in _SLCP_PROJECT_NAMES_EXEMPT_README

def _is_bootloaderish(rel_posix: str, project_name: str) -> bool:
    if "/bootloaders/" in rel_posix.replace("\\", "/"):
        return True
    return project_name.startswith("matter_bootloader_")

def _readme_steps_demo_subsections_required(rel_posix: str, project_name: str) -> bool:
    """Whether readme must include Steps for Execution, Configuration under Steps to Run Demo"""
    rp = rel_posix.replace("\\", "/")
    if _is_bootloaderish(rel_posix, project_name):
        return False
    if "/openthread_border_router_doc/" in rp:
        return False
    return True

def _app_name_taxonomy_ok(app_name: str, rel_posix: str) -> bool:
    """True if app name matches sisdk requirements"""
    if _is_bootloaderish(rel_posix, app_name):
        return bool(re.match(r"^matter_bootloader_[a-z0-9_]+$", app_name))
    if not _APP_NAME_RE.match(app_name):
        return False
    if _ROLE_TOKEN.search(app_name) is None:
        return False
    return True

def _label_taxonomy_error(app_name: str, label: str, rel_posix: str) -> Optional[str]:
    """Align label with app name taxonomy"""
    if not isinstance(app_name, str) or not app_name.strip():
        return None
    name_l = app_name.strip().lower()
    if not name_l.startswith("matter_"):
        return None

    lb = label.strip()
    if not lb:
        return None

    rp = rel_posix.replace("\\", "/")

    if not lb.startswith("Matter"):
        return "label taxonomy: label must start with 'Matter'"

    if name_l.startswith("matter_bootloader_") or "/bootloaders/" in rp:
        if "Bootloader" not in lb:
            return "label taxonomy: Matter bootloader labels must contain 'Bootloader'"
        return None

    if "openthread_border_router" in name_l:
        if not re.search(r"\bHost\b", lb):
            return "label taxonomy: OpenThread border router template label must include Host role"
        if "OpenThread" not in lb or "Border" not in lb:
            return (
                "label taxonomy: OpenThread border router label should reference "
                "OpenThread and Border Router"
            )
        return None

    if name_l.startswith("matter_thread_"):
        if "Matter Thread" not in lb:
            return (
                "label taxonomy: Matter over Thread projects must include "
                "'Matter Thread' (match app name / file stem)"
            )
    elif name_l.startswith("matter_wifi_"):
        if "Matter WiFi" not in lb:
            return (
                "label taxonomy: Matter over Wi-Fi projects must include "
                "'Matter WiFi' (match app name / file stem)"
            )

    name_segments = name_l.split("_")
    role_set = frozenset({"soc", "ncp", "rcp", "host"})
    role_display = {"soc": "SoC", "ncp": "NCP", "rcp": "RCP", "host": "Host"}
    role_idx = next((i for i, t in enumerate(name_segments) if t in role_set), None)
    if role_idx is not None:
        disp = role_display[name_segments[role_idx]]
        if disp not in lb:
            return (
                f"label taxonomy: label must include role segment {disp!r} "
                "from app name (SoC / NCP / RCP / Host)"
            )

    if any(
        i + 1 < len(name_segments)
        and name_segments[i] == "917"
        and name_segments[i + 1] == "ncp"
        for i in range(len(name_segments))
    ):
        if "917" not in lb or "NCP" not in lb:
            return (
                "label taxonomy: SiWx917 NCP projects must include both '917' and 'NCP' in the label"
            )

    if name_segments and name_segments[-1] == "freertos":
        if "FreeRTOS" not in lb:
            return "label taxonomy: app names ending with '_freertos' must include 'FreeRTOS' in the label"
        tail = lb[lb.rfind("FreeRTOS") + len("FreeRTOS") :].strip()
        if tail:
            return (
                "label taxonomy: 'FreeRTOS' must end the label, put qualifiers before it"
            )

    for rule in _LABEL_CLAIM_REQUIRES_PROJECT_NAME:
        if rule.label_pattern.search(lb) and not rule.name_ok(name_l, name_segments):
            return rule.error

    filler = frozenset(
        {
            "matter",
            "thread",
            "wifi",
            "soc",
            "ncp",
            "rcp",
            "host",
            "freertos",
            "app",
            "internal",
            "external",
            "series",
            "ns",
            "s",
            "doc",
            "917",
        }
    )

    if role_idx is None:
        return None

    end = len(name_segments)
    while end > role_idx + 1 and name_segments[end - 1] == "freertos":
        end -= 1
    for segment in name_segments[role_idx + 1 : end]:
        if segment in filler:
            continue
        if segment.isdigit():
            continue
        if len(segment) < 2:
            continue
        pat = re.compile(rf"\b{re.escape(segment)}\b", re.IGNORECASE)
        if not pat.search(lb):
            return (
                f"label taxonomy: label should reflect app name segment {segment!r} "
                "(technology - role - example - OS)"
            )
    return None

def _readme_intro_under_h1_gaps(text: str, max_chars: int = 200) -> List[str]:
    gaps: List[str] = []
    lines = text.replace("\r\n", "\n").split("\n")
    i = 0
    while i < len(lines) and not lines[i].strip():
        i += 1
    if i >= len(lines):
        gaps.append("empty or whitespace only")
        return gaps
    first = lines[i].strip()
    m = re.match(r"^(#+)\s*(.*)$", first)
    if not m or len(m.group(1)) != 1 or not m.group(2).strip():
        gaps.append(
            "first non-empty line must be a single top-level (#) title with text",
        )
        return gaps

    i += 1
    body_lines: List[str] = []
    while i < len(lines):
        stripped = lines[i].strip()
        if stripped.startswith("##"):
            break
        body_lines.append(lines[i].rstrip())
        i += 1

    intro = "\n".join(body_lines).strip()
    if not intro:
        gaps.append(
            "missing brief high-level description under the top-level (#) title "
            "(before the first ## section)",
        )
    elif len(intro) > max_chars:
        gaps.append(
            f"description under title is {len(intro)} characters; maximum is {max_chars}",
        )
    return gaps

def _readme_section_gaps(
    text: str,
    *,
    require_steps_demo_subsections: bool = True,
) -> List[str]:
    """Return gaps vs recommended readme outline"""
    low = text.lower()
    gaps: List[str] = []

    def has_any(*phrases: str) -> bool:
        return any(p in low for p in phrases)

    gaps.extend(_readme_intro_under_h1_gaps(text))
    if "table of contents" not in low:
        gaps.append('missing "Table of Contents" heading')
    if not (has_any("purpose/scope", "purposescope") or ("purpose" in low and "scope" in low)):
        gaps.append('missing "Purpose/Scope" heading')
    if not (has_any("prerequisites", "setup requirements")):
        gaps.append('missing "Prerequisites/Setup Requirements" heading')
    if not has_any("steps to run", "steps to run demo"):
        gaps.append('missing "Steps to Run Demo" heading')
    if "troubleshooting" not in low:
        gaps.append('missing "Troubleshooting" heading')
    if not has_any("resources", "## resources"):
        gaps.append('missing "Resources" heading')
    if not has_any("report bugs", "get support"):
        gaps.append('missing "Report Bugs & Get Support" heading')
    if require_steps_demo_subsections and has_any("steps to run", "steps to run demo"):
        if not has_any("steps for execution", "steps for execution."):
            gaps.append('under "Steps to Run Demo": missing "Steps for Execution" subsection')
        if not has_any("configuration and setup", "configuration & setup"):
            gaps.append('under "Steps to Run Demo": missing "Configuration and Setup" subsection')
    return gaps

def _check_nonempty_string(
    rep: FileReport,
    data: Mapping[str, Any],
    field: str,
    *,
    empty_msg: str,
    max_len: Optional[int] = None,
) -> Optional[str]:
    """If field is a non-empty string and within max_len, return it, else rep.add and return None"""
    val = data.get(field)
    if not isinstance(val, str) or not val.strip():
        rep.add(empty_msg)
        return None
    if max_len is not None and len(val) > max_len:
        rep.add(f"'{field}' length {len(val)} exceeds {max_len} characters")
        return None
    return val

def _load_yaml_mapping_report(path: Path) -> Tuple[Optional[Dict[str, Any]], FileReport]:
    """Load YAML; return (dict, report). On failure report has issues and data is None"""
    rep = FileReport(path=path)
    raw, err = _load_yaml(path)
    if err:
        rep.add(err)
        return None, rep
    if not isinstance(raw, dict):
        rep.add("top-level YAML must be a mapping")
        return None, rep
    return raw, rep

def _validate_identity_name_field(
    rep: FileReport,
    value: Any,
    stem: str,
    field: str,
    rel_posix: str,
    *,
    missing_msg: str,
) -> str:
    """Validate project_name / workspace_name vs stem and taxonomy, return value or ''"""
    if not isinstance(value, str) or not value:
        rep.add(missing_msg)
        return ""
    if value != stem:
        rep.add(f"'{field}' ({value!r}) must match file stem ({stem!r})")
    if len(value) > 72:
        rep.add(f"'{field}' length {len(value)} exceeds 72 characters")
    if not _APP_NAME_RE.match(value):
        rep.add(
            f"'{field}' must be snake_case: start with a-z, then lowercase letters, digits, underscores only",
        )
    if not _app_name_taxonomy_ok(value, rel_posix):
        rep.add(
            f"'{field}' must follow app name taxonomy ",
        )
    return value

def _validate_common_studio_fields(
    rep: FileReport,
    data: Mapping[str, Any],
    rel_posix: str,
    app_name_for_taxonomy: str,
    *,
    label_empty_msg: str,
) -> None:
    label = _check_nonempty_string(
        rep, data, "label", empty_msg=label_empty_msg, max_len=72
    )
    if label is not None:
        tax = _label_taxonomy_error(app_name_for_taxonomy, label, rel_posix)
        if tax:
            rep.add(tax)
    _check_nonempty_string(rep, data, "quality", empty_msg="missing or empty 'quality'")

    desc = _check_nonempty_string(
        rep, data, "description", empty_msg="missing or empty 'description'", max_len=200
    )
    if desc is not None:
        rp = rel_posix.replace("\\", "/")
        skip_desc_shape = _is_bootloaderish(rel_posix, app_name_for_taxonomy) or (
            "/openthread_border_router_doc/" in rp
        )
        if not skip_desc_shape and not any(
            desc.startswith(p) for p in _DESCRIPTION_ALLOWED_PREFIXES
        ):
            rep.add(
                "description must start with \"Demonstrates a sample implementation of ...\" (production quality apps) "
                'or "Demonstrates a POC of ..." (non-production quality apps)'
            )

def validate_slcp(path: Path, rel_posix: str) -> FileReport:
    data, rep = _load_yaml_mapping_report(path)
    if data is None:
        return rep

    stem = path.stem
    project_name = _validate_identity_name_field(
        rep,
        data.get("project_name"),
        stem,
        "project_name",
        rel_posix,
        missing_msg="missing or invalid 'project_name' (non-empty string required)",
    )
    _validate_common_studio_fields(
        rep,
        data,
        rel_posix,
        str(project_name or ""),
        label_empty_msg="missing or empty 'label' (Studio display name)",
    )

    fm = _filter_map(data)
    if not _is_bootloaderish(rel_posix, str(project_name or "")):
        type_vals = fm.get("Type")
        if not type_vals:
            rep.add("missing filter 'Type' (SoC, RCP, NCP, or Host)")
        else:
            bad = [x for x in type_vals if x not in ALLOWED_TYPES]
            if bad:
                rep.add(f"filter 'Type' has invalid value(s): {bad!r}")
        diff_vals = fm.get("Difficulty")
        if not diff_vals:
            rep.add("missing filter 'Difficulty' (Beginner or Advanced)")
        else:
            bad_d = [x for x in diff_vals if x not in ALLOWED_DIFFICULTY]
            if bad_d:
                rep.add(f"filter 'Difficulty' has invalid value(s): {bad_d!r}")

    md_readmes = _readme_paths(data, path.parent)
    pn = str(project_name or "")
    if not md_readmes:
        if not _slcp_exempt_readme(pn):
            rep.add("missing 'readme' entry pointing to a .md file")
    else:
        primary = md_readmes[0]
        if not primary.is_file():
            rep.add(f"readme markdown not found: {_path_for_report(primary)}")
        else:
            try:
                body = primary.read_text(encoding="utf-8")
            except OSError as exc:
                rep.add(f"cannot read readme: {exc}")
            else:
                req_steps = _readme_steps_demo_subsections_required(rel_posix, pn)
                for gap in _readme_section_gaps(
                    body,
                    require_steps_demo_subsections=req_steps,
                ):
                    rep.add(f"readme structure: {gap}")
                type_vals = fm.get("Type") or []
                if "NCP" in type_vals and not _NCP_README_HINT.search(body):
                    rep.add(
                        "Type is NCP but readme does not clearly reference host/NCP/co-processor "
                        "or companion documentation paths (Studio spec)",
                    )

    return rep

def validate_slcw(path: Path, rel_posix: str) -> FileReport:
    data, rep = _load_yaml_mapping_report(path)
    if data is None:
        return rep

    stem = path.stem
    ws = _validate_identity_name_field(
        rep,
        data.get("workspace_name"),
        stem,
        "workspace_name",
        rel_posix,
        missing_msg="missing or invalid 'workspace_name'",
    )
    _validate_common_studio_fields(
        rep,
        data,
        rel_posix,
        str(ws or ""),
        label_empty_msg="missing or empty 'label'",
    )

    projects = data.get("project")
    if not isinstance(projects, list) or not projects:
        rep.add("missing or empty 'project' list")
    else:
        for i, proj in enumerate(projects):
            if not isinstance(proj, dict):
                rep.add(f"project[{i}] must be a mapping")
                continue
            rel = proj.get("path")
            if not isinstance(rel, str):
                rep.add(f"project[{i}].path must be a string")
                continue
            target = (path.parent / rel).resolve()
            if not target.is_file():
                rep.add(f"project[{i}] path does not resolve to a file: {rel}")

    return rep

def discover_files(apps_dir: Path) -> Tuple[List[Path], List[Path]]:
    slcps = sorted(apps_dir.rglob("*.slcp"))
    slcws = sorted(apps_dir.rglob("*.slcw"))
    return slcps, slcws

def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--apps-dir",
        type=Path,
        default=DEFAULT_APPS_DIR,
        help=f"Root directory to scan (default: {DEFAULT_APPS_DIR})",
    )
    args = parser.parse_args(list(argv) if argv is not None else None)

    apps_dir = args.apps_dir.resolve()
    if not apps_dir.is_dir():
        print(f"apps directory not found: {apps_dir}", file=sys.stderr)
        return 2

    slcps, slcws = discover_files(apps_dir)
    reports: List[FileReport] = []

    for p in slcps:
        rel = _path_for_report(p)
        reports.append(validate_slcp(p, rel))
    for p in slcws:
        rel = _path_for_report(p)
        reports.append(validate_slcw(p, rel))

    issue_count = sum(len(r.issues) for r in reports)
    files_with_issues = sum(1 for r in reports if r.issues)

    if issue_count == 0:
        print(
            f"OK: validated {len(reports)} project files under {_path_for_report(apps_dir)}",
        )
        return 0

    for r in reports:
        if not r.issues:
            continue
        rel = _path_for_report(r.path)
        for msg in r.issues:
            print(f"{rel}: {msg}", file=sys.stderr)
    print(
        f"\nFailed: {issue_count} issue(s) in {files_with_issues} file(s) "
        f"({len(reports)} scanned)",
        file=sys.stderr,
    )
    return 1

if __name__ == "__main__":
    raise SystemExit(main())
