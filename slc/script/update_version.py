#!/usr/bin/env python3

# This script updates Matter extension version in our various files.
# Example usage:
# ./slc/script/update_version.py 2.2.0-1.2 4.4.0 4.0.0 readme=True/False
# param 1: New version for sdk_extension
# param 2: New version for simplicity_sdk
# param 3: New version for wiseconnect (Wi-Fi SDK)
# param 4: Choose to update/not update the readme files with "param 1"

import os
import sys
import pathlib
import re

# replace regular expression in given filename with replacement text
def replace_text(filename, regex_to_search, replacement_text, warning_if_unchanged=True):
    with open(filename, "r") as rfile:
        replaced = re.subn(regex_to_search, replacement_text, rfile.read())
        replaced_text = replaced[0]
        replaced_count = replaced[1]
        if (replaced_count == 0 and warning_if_unchanged):
            print("Warning: Following regex format not found in "+filename+". Review manually to ensure format has not changed.")
            print(regex_to_search)
    with open(filename, 'w') as wfile:
        wfile.write(replaced_text)

if __name__ == '__main__':
    if len(sys.argv) != 5:
        print("Error: Incorrect usage. Example: ./slc/script/update_version.py 2.2.0-1.2 4.4.0 4.0.0 readme=True/False")
        sys.exit()

    EXTENSION_NEW_VERSION = sys.argv[1]
    SISDK_NEW_VERSION = sys.argv[2]
    WISECONNECT_NEW_VERSION = sys.argv[3]
    README = sys.argv[4]
    VERSION_REGEX_FORMAT=r"(\d+)\.(\d+)\.(\d+)"
    AUX_REGEX_FORMAT = r"(\d+)\.(\d+)(\.(\d+))?"
    FULL_VERSION = False
    UPDATE_README=False

    # Validate extension version: X.Y.Z or X.Y.Z-A.B(.C)
    extension_regex = r"^\d+\.\d+\.\d+(-\d+\.\d+(\.\d+)?)?$"
    if not re.match(extension_regex, EXTENSION_NEW_VERSION):
        print("Error: Incorrect usage for extension version. Need X.Y.Z or X.Y.Z-A.B(.C) format")
        sys.exit()

    # Check if there an Auxillary version number is supplied 
    if len(re.split('-',EXTENSION_NEW_VERSION)) == 2:
        if (re.compile(AUX_REGEX_FORMAT)).match((re.split('-',EXTENSION_NEW_VERSION))[1]):
            AUX_VERSION = (re.split('-',EXTENSION_NEW_VERSION))[1]
            FULL_VERSION_REGEX = r"(\d+)\.(\d+)\.(\d+)-(\d+)\.(\d+)(\.(\d+))?"
            FULL_VERSION = True
            EXTENSION_NEW_VERSION=(re.split('-',EXTENSION_NEW_VERSION))[0]
        else:
            print("Error: Incorrect usage for extension version. Auxiliary part must be A.B(.C)")
            sys.exit()

    ROOT = pathlib.Path(sys.argv[0]).parent.parent.parent.absolute()

    #Check if SISDK_NEW_VERSION version is in (\d+)\.(\d+)\.(\d+) format
    if len(SISDK_NEW_VERSION.split("."))!=3 or not re.match(r"^\d+\.\d+\.\d+$", SISDK_NEW_VERSION):
        print("Error: Incorrect usage for SISDK version. Need X.Y.Z format")

    #Check if WISECONNECT_NEW_VERSION is in X.Y.Z format
    if len(WISECONNECT_NEW_VERSION.split(".")) != 3 or not re.match(r"^\d+\.\d+\.\d+$", WISECONNECT_NEW_VERSION):
        print("Error: Incorrect usage for wiseconnect version. Need X.Y.Z format")
        sys.exit()

    #Check if  updated to README.md files is required.
    readme_args = README.split("=")
    if(len(readme_args)!=2 or readme_args[0]!="readme" or readme_args[1].upper() not in ["TRUE", "FALSE"]):
        print("Error: Incorrect usage for readme. Example: ./slc/script/update_version.py 2.2.0-1.2 4.4.0 4.0.0 readme=True/False")
        sys.exit()
    else:
        UPDATE_README=True if readme_args[1].upper()=="TRUE" else False

    print("Updating the sdk_extension version to "+EXTENSION_NEW_VERSION)
    print("Updating the simplicity_sdk version to "+SISDK_NEW_VERSION)
    print("Updating the wiseconnect version to "+WISECONNECT_NEW_VERSION)
    readme_str= "Updating" if UPDATE_README else "Not Updating"
    print(readme_str+" the README.md files")

    # Update .slcp files in slc/ directory
    #
    # REGEX FORMAT:
    # sdk_extension:
    #   - id: matter
    #     version: "0.0.3"
    slcp_files = [os.path.abspath(f) for f in pathlib.Path(ROOT).glob("slc/**/*.slcp")]
    for file in slcp_files:
        replace_text(file,"sdk_extension:\n *- id: matter\n *version: \""+VERSION_REGEX_FORMAT+"\"", "sdk_extension:\n  - id: matter\n    version: \""+EXTENSION_NEW_VERSION+"\"")
        replace_text(file,"- id: wiseconnect3_sdk\n *version: \""+VERSION_REGEX_FORMAT+"\"", "- id: wiseconnect3_sdk\n    version: \""+WISECONNECT_NEW_VERSION+"\"", warning_if_unchanged=False)

    # Update matter.slce
    #
    # REGEX FORMAT:
    # id: matter
    # version: 2.0.0
    replace_text(str(ROOT)+"/matter.slce","id: matter\nversion: "+VERSION_REGEX_FORMAT,"id: matter\nversion: "+EXTENSION_NEW_VERSION)
    replace_text(str(ROOT)+"/matter.slce","version: "+VERSION_REGEX_FORMAT+"","version: "+EXTENSION_NEW_VERSION)

    #Update the simplicity_sdk in matte.slce
    # REGEX FORMAT:
    # sdk:
    #   id: simplicity_sdk
    #   version: 4.3.0
    replace_text(str(ROOT)+"/matter.slce","  *id: simplicity_sdk\n  *version: "+VERSION_REGEX_FORMAT,"  id: simplicity_sdk\n  version: "+SISDK_NEW_VERSION)

    # Update matter.slsdk
    #
    # REGEX FORMAT:
    # version=0.0.4
    # prop.subLabel=Silicon Labs Matter\\ 1.0.4-1.0
    if FULL_VERSION:
        replace_text(str(ROOT)+"/matter.slsdk",FULL_VERSION_REGEX,EXTENSION_NEW_VERSION+"-"+AUX_VERSION)
    replace_text(str(ROOT)+"/matter.slsdk","version="+VERSION_REGEX_FORMAT,"version="+EXTENSION_NEW_VERSION)

    # Update .md files in slc/ directory and root README.md
    #
    # REGEX FORMAT:
    # https://docs.silabs.com/matter/1.0.4
    # https://github.com/SiliconLabsSoftware/matter_sdk/blob/v2.8.1/...
    # https://github.com/SiliconLabs/wiseconnect/blob/v4.0.1-content-for-docs/...
    if(UPDATE_README):
        readme_files = [os.path.abspath(f) for f in pathlib.Path(ROOT).glob("slc/**/*.md")]
        readme_files.append(os.path.join(str(ROOT), "README.md"))
        for file in readme_files:

            replace_text(file,"https://docs.silabs.com/matter/"+VERSION_REGEX_FORMAT,"https://docs.silabs.com/matter/"+EXTENSION_NEW_VERSION)
            replace_text(file,"matter_sdk/blob/v"+VERSION_REGEX_FORMAT,"matter_sdk/blob/v"+EXTENSION_NEW_VERSION, warning_if_unchanged=False)
            replace_text(file,"wiseconnect/blob/v"+VERSION_REGEX_FORMAT+"-content-for-docs","wiseconnect/blob/v"+WISECONNECT_NEW_VERSION+"-content-for-docs", warning_if_unchanged=False)
            if FULL_VERSION:
                replace_text(file,"https://www.silabs.com/documents/public/software/SilabsMatterPi_"+FULL_VERSION_REGEX+"-extension.zip", "https://www.silabs.com/documents/public/software/SilabsMatterPi_"+EXTENSION_NEW_VERSION+"-"+AUX_VERSION+"-extension.zip", False)

    # Update matter_docs.xml
    #
    # REGEX FORMAT:
    # https://github.com/SiliconLabs/matter_extension/releases/tag/v1.0.4
    # Silicon Labs Matter v1.0.4-1.0
    if FULL_VERSION:
        replace_text(str(ROOT)+"/matter_docs.xml","https://github.com/SiliconLabs/matter_extension/releases/tag/v"+VERSION_REGEX_FORMAT+"","https://github.com/SiliconLabs/matter_extension/releases/tag/v"+EXTENSION_NEW_VERSION)
        replace_text(str(ROOT)+"/matter_docs.xml","Silicon Labs Matter v"+FULL_VERSION_REGEX+"","Silicon Labs Matter v"+EXTENSION_NEW_VERSION+"-"+AUX_VERSION+"")

    # Update matter_demos.xml
    #
    # REGEX FORMAT:
    # asset://extension.matter_1.0.4/demos/...
    replace_text(str(ROOT)+"/matter_demos.xml","asset://extension\\.matter_"+VERSION_REGEX_FORMAT+"/","asset://extension.matter_"+EXTENSION_NEW_VERSION+"/")
