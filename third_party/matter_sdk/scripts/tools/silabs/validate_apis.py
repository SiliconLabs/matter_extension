#!/usr/bin/env python3
# Copyright (c) 2026 Project CHIP Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""@brief Validate Silabs APIs against a committed manifest.

Parses public APIs from AppTaskImpl.h (and ClosureManagerImpl.h
for closure app) and compares API names and signatures to .github/silabs-apis.yaml.
Fails when headers and manifest drift (missing, extra, or changed APIs).

Use --bootstrap once to regenerate the manifest from current headers.
"""

from __future__ import annotations

import argparse
import glob
import os
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional, Tuple

import yaml

DEFAULT_MANIFEST = ".github/silabs-apis.yaml"
MANIFEST_HEADER_COMMENT = (
    "# CI validation baseline for Silabs APIs.\n"
    "# When adding/changing an API, update this file and the Confluence page.\n"
    "# https://confluence.silabs.com/spaces/MATTER/pages/873669145/CRTP+Override+APIs+by+App\n"
)


@dataclass(frozen=True)
class ApiEntry:
    name: str
    signature: str
    ifdef: Optional[str] = None


@dataclass(frozen=True)
class ClassConfig:
    header: str
    apis: Tuple[ApiEntry, ...]


@dataclass(frozen=True)
class AppConfig:
    classes: Dict[str, ClassConfig]


@dataclass(frozen=True)
class ParsedApi:
    name: str
    signature: str
    ifdef: Optional[str] = None


def strip_comments(text: str) -> str:
    result: List[str] = []
    i = 0
    while i < len(text):
        if text[i: i + 2] == "//":
            while i < len(text) and text[i] != "\n":
                i += 1
        elif text[i: i + 2] == "/*":
            end = text.find("*/", i + 2)
            if end < 0:
                break
            i = end + 2
        else:
            result.append(text[i])
            i += 1
    return "".join(result)


def collapse_whitespace(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip()


def normalize_signature(signature: str) -> str:
    signature = collapse_whitespace(signature)
    signature = re.sub(r"\)\s*override\b", ") override", signature)
    signature = re.sub(r"\boverride\s*const\b", "override const", signature)
    signature = re.sub(r"\s*\*\s*", " *", signature)
    signature = re.sub(r"\s*&\s*", " &", signature)
    signature = re.sub(r">\s*([A-Za-z_])", r"> \1", signature)
    signature = re.sub(r",\s*([A-Za-z_])", r", \1", signature)
    signature = re.sub(r"\s*<\s*", "<", signature)
    signature = re.sub(r"\s*>\s*", ">", signature)
    signature = re.sub(r"\s*,\s*", ", ", signature)
    signature = re.sub(r"\s*\(\s*", "(", signature)
    signature = re.sub(r"\s*\)\s*", ")", signature)
    return signature


def remove_brace_bodies(text: str) -> str:
    result: List[str] = []
    i = 0
    while i < len(text):
        if text[i] == "{":
            depth = 1
            i += 1
            while i < len(text) and depth > 0:
                if text[i] == "{":
                    depth += 1
                elif text[i] == "}":
                    depth -= 1
                i += 1
            result.append(";")
        else:
            result.append(text[i])
            i += 1
    return "".join(result)


def extract_access_section(text: str, access: str) -> str:
    pattern = re.compile(rf"\b{access}\s*:")
    match = pattern.search(text)
    if not match:
        return ""
    start = match.end()
    next_access = re.search(r"\b(public|private|protected)\s*:", text[start:])
    if next_access:
        return text[start: start + next_access.start()]
    return text[start:]


def ifdef_macro_from_directive(directive: str) -> Optional[str]:
    directive = collapse_whitespace(directive)
    defined_match = re.search(r"defined\s*\(\s*([A-Za-z_][A-Za-z0-9_]*)\s*\)", directive)
    if defined_match:
        return defined_match.group(1)
    simple_match = re.match(r"([A-Za-z_][A-Za-z0-9_]*)", directive)
    if simple_match:
        return simple_match.group(1)
    return None


def split_preprocessor_sections(text: str) -> List[Tuple[Optional[str], str]]:
    sections: List[Tuple[Optional[str], str]] = []
    ifdef_stack: List[Optional[str]] = [None]
    current: List[str] = []
    lines = text.splitlines(keepends=True)
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        if stripped.startswith("#ifdef "):
            if current:
                sections.append((ifdef_stack[-1], "".join(current)))
                current = []
            directive = stripped[7:].strip()
            ifdef_stack.append(ifdef_macro_from_directive(directive))
        elif stripped.startswith("#ifndef "):
            if current:
                sections.append((ifdef_stack[-1], "".join(current)))
                current = []
            directive = stripped[8:].strip()
            ifdef_stack.append(ifdef_macro_from_directive(directive))
        elif stripped.startswith("#if"):
            if current:
                sections.append((ifdef_stack[-1], "".join(current)))
                current = []
            directive = stripped[3:].strip()
            ifdef_stack.append(ifdef_macro_from_directive(directive))
        elif stripped.startswith("#endif"):
            if current:
                sections.append((ifdef_stack[-1], "".join(current)))
                current = []
            if len(ifdef_stack) > 1:
                ifdef_stack.pop()
        else:
            current.append(line)
        i += 1
    if current:
        sections.append((ifdef_stack[-1], "".join(current)))
    return sections


def find_matching_paren(text: str, open_index: int) -> int:
    depth = 0
    for i in range(open_index, len(text)):
        if text[i] == "(":
            depth += 1
        elif text[i] == ")":
            depth -= 1
            if depth == 0:
                return i
    return -1


def parse_method_declaration(decl: str) -> Optional[ParsedApi]:
    decl = collapse_whitespace(decl.strip().rstrip(";"))
    if not decl or decl.startswith("#"):
        return None

    is_static = False
    if decl.startswith("static "):
        is_static = True
        decl = decl[len("static "):]

    paren_index = decl.find("(")
    if paren_index < 0:
        return None
    close_index = find_matching_paren(decl, paren_index)
    if close_index < 0:
        return None

    before_paren = decl[:paren_index].strip()
    name_match = re.search(r"([A-Za-z_][A-Za-z0-9_]*)\s*$", before_paren)
    if not name_match:
        return None
    name = name_match.group(1)
    return_type = before_paren[: name_match.start()].strip()
    params = decl[paren_index: close_index + 1]
    trailing = decl[close_index + 1:].strip()
    trailing = re.sub(r"\boverride\b", "override", trailing)
    trailing = re.sub(r"\bconst\b", "const", trailing)
    trailing = collapse_whitespace(trailing)

    signature_parts = []
    if is_static:
        signature_parts.append("static")
    signature_parts.append(f"{return_type} {name}{params}")
    if trailing:
        signature_parts.append(trailing)
    signature = normalize_signature(" ".join(signature_parts))
    return ParsedApi(name=name, signature=signature)


def extract_methods_from_section(section_text: str, active_ifdef: Optional[str]) -> List[ParsedApi]:
    cleaned = strip_comments(section_text)
    without_bodies = remove_brace_bodies(cleaned)
    declarations = [part.strip() for part in without_bodies.split(";") if part.strip()]
    methods: List[ParsedApi] = []
    for decl in declarations:
        parsed = parse_method_declaration(decl)
        if parsed is None:
            continue
        methods.append(ParsedApi(name=parsed.name, signature=parsed.signature, ifdef=active_ifdef))
    return methods


def parse_impl_header(path: Path) -> List[ParsedApi]:
    text = path.read_text(encoding="utf-8")
    public_section = extract_access_section(text, "public")
    if not public_section:
        return []

    public_section_no_comments = strip_comments(public_section)
    methods: List[ParsedApi] = []
    for ifdef, block in split_preprocessor_sections(public_section_no_comments):
        methods.extend(extract_methods_from_section(block, ifdef))
    return methods


def app_name_from_header(header_path: str) -> str:
    parts = Path(header_path).parts
    examples_index = parts.index("examples")
    return parts[examples_index + 1]


def discover_impl_headers(repo_root: Path) -> Dict[str, Dict[str, str]]:
    apps: Dict[str, Dict[str, str]] = {}
    pattern = str(repo_root / "examples" / "*" / "silabs" / "include" / "AppTaskImpl.h")
    for header in sorted(glob.glob(pattern)):
        rel_header = os.path.relpath(header, repo_root)
        app = app_name_from_header(rel_header)
        apps.setdefault(app, {})["AppTask"] = rel_header

    closure_manager = repo_root / "examples" / "closure-app" / "silabs" / "include" / "ClosureManagerImpl.h"
    if closure_manager.is_file():
        rel_header = os.path.relpath(closure_manager, repo_root)
        apps.setdefault("closure-app", {})["ClosureManager"] = rel_header
    return apps


def load_manifest(path: Path) -> Dict[str, AppConfig]:
    with path.open(encoding="utf-8") as handle:
        data = yaml.safe_load(handle) or {}

    apps: Dict[str, AppConfig] = {}
    for app_name, app_data in (data.get("apps") or {}).items():
        classes: Dict[str, ClassConfig] = {}
        for class_name, class_data in (app_data.get("classes") or {}).items():
            apis = tuple(
                ApiEntry(
                    name=api["name"],
                    signature=api["signature"],
                    ifdef=api.get("ifdef"),
                )
                for api in class_data.get("apis", [])
            )
            classes[class_name] = ClassConfig(header=class_data["header"], apis=apis)
        apps[app_name] = AppConfig(classes=classes)
    return apps


def manifest_to_dict(apps: Dict[str, AppConfig]) -> dict:
    manifest_apps = {}
    for app_name in sorted(apps):
        classes = {}
        for class_name in sorted(apps[app_name].classes):
            class_config = apps[app_name].classes[class_name]
            apis = []
            for api in class_config.apis:
                entry = {"name": api.name, "signature": api.signature}
                if api.ifdef:
                    entry["ifdef"] = api.ifdef
                apis.append(entry)
            classes[class_name] = {"header": class_config.header, "apis": apis}
        manifest_apps[app_name] = {"classes": classes}
    return {"apps": manifest_apps}


def write_manifest(path: Path, apps: Dict[str, AppConfig]) -> None:
    content = MANIFEST_HEADER_COMMENT + yaml.safe_dump(
        manifest_to_dict(apps),
        sort_keys=False,
        default_flow_style=False,
        width=120,
    )
    path.write_text(content, encoding="utf-8")


def bootstrap_manifest(repo_root: Path, manifest_path: Path) -> Dict[str, AppConfig]:
    discovered = discover_impl_headers(repo_root)
    apps: Dict[str, AppConfig] = {}
    for app_name in sorted(discovered):
        classes: Dict[str, ClassConfig] = {}
        for class_name in sorted(discovered[app_name]):
            header = discovered[app_name][class_name]
            header_path = repo_root / header
            parsed = parse_impl_header(header_path)
            apis = tuple(
                ApiEntry(name=api.name, signature=api.signature, ifdef=api.ifdef)
                for api in parsed
            )
            classes[class_name] = ClassConfig(header=header, apis=apis)
        apps[app_name] = AppConfig(classes=classes)
    write_manifest(manifest_path, apps)
    return apps


def compare_apis(
    header_path: str,
    expected: Tuple[ApiEntry, ...],
    actual: List[ParsedApi],
) -> List[str]:
    errors: List[str] = []
    actual_by_name = {api.name: api for api in actual}
    expected_names = {api.name for api in expected}

    for api in expected:
        if api.name not in actual_by_name:
            errors.append(f"{header_path}: missing API '{api.name}' from header")
            continue
        actual_api = actual_by_name[api.name]
        if normalize_signature(api.signature) != normalize_signature(actual_api.signature):
            errors.append(
                f"{header_path}: signature mismatch for '{api.name}':\n"
                f"  manifest: {api.signature}\n"
                f"  header:   {actual_api.signature}"
            )
        if api.ifdef and actual_api.ifdef and api.ifdef != actual_api.ifdef:
            errors.append(
                f"{header_path}: ifdef mismatch for '{api.name}': "
                f"manifest={api.ifdef}, header={actual_api.ifdef}"
            )

    for api in actual:
        if api.name not in expected_names:
            errors.append(
                f"{header_path}: unexpected API '{api.name}' not listed in manifest "
                f"(signature: {api.signature})"
            )
    return errors


def validate_manifest(repo_root: Path, manifest_path: Path) -> List[str]:
    errors: List[str] = []
    if not manifest_path.is_file():
        return [f"Manifest not found: {manifest_path}"]

    manifest = load_manifest(manifest_path)
    discovered = discover_impl_headers(repo_root)

    for app_name in sorted(discovered):
        if app_name not in manifest:
            errors.append(f"App '{app_name}' has AppTaskImpl.h but is missing from manifest")
            continue
        for class_name, header in sorted(discovered[app_name].items()):
            if class_name not in manifest[app_name].classes:
                errors.append(f"App '{app_name}' class '{class_name}' missing from manifest")
                continue
            class_config = manifest[app_name].classes[class_name]
            if class_config.header != header:
                errors.append(
                    f"App '{app_name}' class '{class_name}': manifest header "
                    f"'{class_config.header}' != discovered '{header}'"
                )
            header_path = repo_root / header
            if not header_path.is_file():
                errors.append(f"Header not found: {header}")
                continue
            actual = parse_impl_header(header_path)
            errors.extend(compare_apis(header, class_config.apis, actual))

    for app_name in sorted(manifest):
        if app_name not in discovered:
            errors.append(f"Manifest app '{app_name}' has no discovered AppTaskImpl.h")

    return errors


def parse_args(argv: Optional[List[str]] = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--bootstrap",
        action="store_true",
        help="Generate manifest from current headers (initial setup only)",
    )
    return parser.parse_args(argv)


def main(argv: Optional[List[str]] = None) -> int:
    args = parse_args(argv)
    repo_root = Path(__file__).resolve().parents[3]
    manifest = (repo_root / DEFAULT_MANIFEST).resolve()

    if args.bootstrap:
        bootstrap_manifest(repo_root, manifest)
        print(f"Wrote manifest to {manifest}")
        return 0

    errors = validate_manifest(repo_root, manifest)
    if errors:
        print("API validation failed:", file=sys.stderr)
        for error in errors:
            print(f"  - {error}", file=sys.stderr)
        return 1

    print("API validation passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
