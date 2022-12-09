#!/usr/bin/env python3

# This script updates Matter extension version in our various files.
# Example usage:
# ./slc/script/update_version.py 1.2.3

import os
import sys
import pathlib
import re

# replace regular expression in given filename with replacement text
def replace_text(filename, regex_to_search, replacement_text):
    with open(filename, "r") as rfile:
        replaced = re.subn(regex_to_search, replacement_text, rfile.read())
        replaced_text = replaced[0]
        replaced_count = replaced[1]
        if (replaced_count == 0):
            print("Warning: Following regex format not found in "+filename+". Review manually to ensure format has not changed.")
            print(regex_to_search)
    with open(filename, 'w') as wfile:
        wfile.write(replaced_text)

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Error: Incorrect usage. Example: ./slc/script/update_version.py 1.2.3")
        sys.exit()

    NEW_VERSION = sys.argv[1]
    VERSION_REGEX_FORMAT="(\d+)\.(\d+)\.(\d+)"
    ROOT = pathlib.Path(sys.argv[0]).parent.parent.parent.absolute()

    # Update .slcp files in slc/ directory
    #
    # REGEX FORMAT:
    # sdk_extension:
    #   - id: matter
    #     version: "0.0.3"
    slcp_files = [os.path.abspath(f) for f in pathlib.Path(ROOT).glob("slc/**/*.slcp")]
    for file in slcp_files:
        replace_text(file,"sdk_extension:\n *- id: matter\n *version: \""+VERSION_REGEX_FORMAT+"\"", "sdk_extension:\n  - id: matter\n    version: \""+NEW_VERSION+"\"")

    # Update matter.slce
    #
    # REGEX FORMAT:
    # matterExtensionVersion: '0.0.3'
    replace_text(str(ROOT)+"/matter.slce","id: matter\nversion: "+VERSION_REGEX_FORMAT,"id: matter\nversion: "+NEW_VERSION)

    # Update matter.slsdk
    #
    # REGEX FORMAT:
    # version=0.0.4
    replace_text(str(ROOT)+"/matter.slsdk","version="+VERSION_REGEX_FORMAT,"version="+NEW_VERSION)

    # Update pipeline_metadata.yml
    #
    # REGEX FORMAT:
    # matterExtensionVersion: '0.0.3'
    replace_text(str(ROOT)+"/pipeline_metadata.yml","matterExtensionVersion: '"+VERSION_REGEX_FORMAT+"'","matterExtensionVersion: '"+NEW_VERSION+"'")
