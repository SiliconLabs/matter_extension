#!/usr/bin/env python3
"""
get_zap_version.py

Description:
    This script determines the required ZAP version for Simplicity Studio Matter SDK workflows.
    It reads the ZAP version from a release variable or from the Matter SDK's zap.json file.
    The script is intended for use in CI/CD pipelines or locally to fetch the correct ZAP version
    for downloading or validation.

Usage:
    python3 get_zap_version.py                # Prints a human-readable message with the minimum required ZAP version
    python3 get_zap_version.py --docker       # Prints only the version string (for automation in Docker or CI)
    python3 get_zap_version.py --verbose      # Enables debug/info logging output

Arguments:
    --docker    Print only the version string (no extra text), suitable for scripting/automation.
    --verbose   Enable debug/info logging output.
"""

import os
import json
import argparse
import logging
from pathlib import Path

# This string should remain empty on the main branch. Update it only when a release branch is created. 
# Coordinate with the studio team to determine the appropriate ZAP version for the release.
# Version string example :  "v2024.08.14-nightly"
SIMPLICITY_STUDIO_ZAP_VERSION = ""

def get_zap_version():
    if SIMPLICITY_STUDIO_ZAP_VERSION:
        logging.info(f"Using SIMPLICITY_STUDIO_ZAP_VERSION: {SIMPLICITY_STUDIO_ZAP_VERSION}")
        return SIMPLICITY_STUDIO_ZAP_VERSION    
    # Check if the environment variable SILABS_MATTER_ROOT is set
    if "SILABS_MATTER_ROOT" not in os.environ:
        logging.info("SILABS_MATTER_ROOT not set, using default path for Matter root")
        silabs_chip_root = Path(__file__).resolve().parents[2]
    else:
        silabs_chip_root = Path(os.environ["SILABS_MATTER_ROOT"])
        logging.info(f"Using SILABS_MATTER_ROOT: {silabs_chip_root}")

    zap_version_path = silabs_chip_root / "third_party" / "matter_sdk" / "scripts" / "setup" / "zap.version"
    with open(zap_version_path, 'r') as f:
        zap_version = f.read().strip()
    return zap_version

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Get ZAP version")
    parser.add_argument('--docker', action='store_true', help='Print only the version string (for automation)')
    parser.add_argument('--verbose', action='store_true', help='Enable debug/info logging output')
    args = parser.parse_args()

    if args.verbose:
        logging.basicConfig(level=logging.INFO, format='[%(levelname)s] %(message)s')
    else:
        logging.basicConfig(level=logging.WARNING)

    zap_version = get_zap_version()
    if args.docker:
        print(zap_version)
    else:
        print("The minimum zap required is", zap_version)