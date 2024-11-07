"""
This script is used to determine the latest ZAP version from a JSON configuration file from matter_sdk.

Usage:
    Run the script directly to print the minimum zap level required:
    $ python get_zap_version.py

"""
import os
import json
from pathlib import Path

# This string should remain empty on the main branch. Update it only when a release branch is created. 
# Coordinate with the studio team to determine the appropriate ZAP version for the release.
# Version string example :  "v2024.08.14-nightly"
SIMPLICITY_STUDIO_ZAP_VERSION = "v2024.10.24"

def get_zap_version():
    if SIMPLICITY_STUDIO_ZAP_VERSION:
        return SIMPLICITY_STUDIO_ZAP_VERSION    
    # Check if the environment variable SILABS_MATTER_ROOT is set
    if "SILABS_MATTER_ROOT" not in os.environ:
        # If not set, use the default path for Matter root
        print("Using default path for Matter root")
        silabs_chip_root = Path(__file__).resolve().parents[2]
    else:
        # If set, use the path from the environment variable
        print("Using ENV path for Matter root")
        silabs_chip_root = os.environ["SILABS_MATTER_ROOT"]

    zap_version = ""
    # Construct the path to the zap.json file
    zap_path = os.path.join(silabs_chip_root, "third_party", "matter_sdk", "scripts", "setup", "zap.json")
    # Load the JSON data from the zap.json file
    zap_json = json.load(open(zap_path))
    # Iterate through the packages in the JSON data
    for package in zap_json.get("packages", []):
        # Iterate through the tags in each package
        for tag in package.get("tags", []):
            # Check if the tag starts with "version:2@"
            if tag.startswith("version:2@"):
                # Remove the prefix "version:2@" from the tag to get the version
                zap_version = tag.removeprefix("version:2@")
                # Find the last occurrence of "." in the version string
                suffix_index = zap_version.rfind(".")
                if suffix_index != -1:
                    # Remove the suffix after the last "."
                    zap_version = zap_version[:suffix_index]
                # Return the zap version
                return zap_version

if __name__ == "__main__":
    # Print the minimum zap required
    print("The minimum zap required is", get_latest_zap())