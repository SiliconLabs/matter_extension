#!/usr/bin/env python3
"""
Run all component update scripts required after a matter_sdk submodule update.
"""

import os
import pathlib
import subprocess
import sys

root = pathlib.Path(__file__).resolve().parent.parent.parent
script_dir = root / "slc" / "script"
os.chdir(root)

SCRIPTS = [
    "gen_cluster_components.py",
    "gen_static_zap_includes.py",
    "get_slce_extra_paths.py",
]


def main():
    for name in SCRIPTS:
        path = script_dir / name
        if not path.exists():
            print(f"Error: script not found: {path}", file=sys.stderr)
            return 1
        rc = subprocess.run([sys.executable, str(path)], cwd=root)
        if rc.returncode != 0:
            print(f"Error: {name} exited with {rc.returncode}", file=sys.stderr)
            return rc.returncode
    return 0


if __name__ == "__main__":
    raise SystemExit(main())