#!/usr/bin/env python3
"""
Remove obsolete cluster components from slc/component/matter-clusters/.
Compares committed vs current cluster-to-component-dependencies.json
to detect removed clusters and deletes their corresponding .slcc files.
Invoked by gen_cluster_components.py
"""

import json
import os
import pathlib
import subprocess

root = str(pathlib.Path(os.path.realpath(__file__)).parent.parent.parent)
os.chdir(root)

DEPS_FILE = "src/app/zap-templates/cluster-to-component-dependencies.json"
COMPONENT_DIR = pathlib.Path("slc/component/matter-clusters")

def _git_show(path):
    """Return committed content of a file"""
    try:
        result = subprocess.run(
            ["git", "show", f"HEAD:{path}"],
            capture_output=True, text=True, check=True,
        )
        return result.stdout
    except subprocess.CalledProcessError:
        return None

def _names_from_deps(text):
    """Extract component names from deps JSON text."""
    names = set()
    if not text:
        return names
    try:
        data = json.loads(text)
    except (json.JSONDecodeError, ValueError):
        return names
    prefix = "%extension-matter%matter_"
    for entry in data:
        for value in entry.get("value", []):
            if isinstance(value, str) and value.startswith(prefix):
                names.add(value[len(prefix):])
    return names

def remove_obsolete_cluster_components():
    if not COMPONENT_DIR.exists():
        print("Component dir not found:", COMPONENT_DIR)
        return 0

    old_names = _names_from_deps(_git_show(DEPS_FILE))

    try:
        new_text = pathlib.Path(DEPS_FILE).read_text(encoding="utf-8")
    except OSError:
        print("Error: could not read", DEPS_FILE)
        return 1
    new_names = _names_from_deps(new_text)

    if not new_names and old_names:
        print("Error: failed to parse", DEPS_FILE)
        return 1

    removed_clusters = old_names - new_names

    if not removed_clusters:
        return 0

    deleted = []
    for name in sorted(removed_clusters):
        path = COMPONENT_DIR / f"matter_{name}.slcc"
        if path.exists():
            path.unlink()
            deleted.append(path.name)

    if deleted:
        print("Removed obsolete cluster components:", ", ".join(deleted))
    return 0

def main():
    return remove_obsolete_cluster_components()

if __name__ == "__main__":
    raise SystemExit(main())
