#!/usr/bin/env python3

# This script updates Matter extension version in our various files.
# Example usage:
# ./slc/script/update_version.py 2.2.0-1.2 4.4.0 readme=True/False
# param 1: New version for sdk_extension
# param 2: New version for simplicity_sdk
# param 3: Choose to update/not update the readme files with "param 1"

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
    if len(sys.argv) != 4:
        print("Error: Incorrect usage. Example: ./slc/script/update_version.py 2.2.0-1.2 4.4.0 readme=True/False")
        sys.exit()

    EXTENSION_NEW_VERSION = sys.argv[1]
    GDSK_NEW_VERSION = sys.argv[2]
    README = sys.argv[3]
    VERSION_REGEX_FORMAT="(\d+)\.(\d+)\.(\d+)"
    AUX_REGEX_FORMAT = "(\d+)\.(\d+)(\.(\d+))?"
    FULL_VERSION = False
    UPDATE_README=False

    # Check if there an Auxillary version number is supplied 
    if len(re.split('-',EXTENSION_NEW_VERSION)) == 2:
        if (re.compile(AUX_REGEX_FORMAT)).match((re.split('-',EXTENSION_NEW_VERSION))[1]):
            AUX_VERSION = (re.split('-',EXTENSION_NEW_VERSION))[1]
            FULL_VERSION_REGEX = "(\d+)\.(\d+)\.(\d+)-(\d+)\.(\d+)(\.(\d+))?"
            FULL_VERSION = True
            EXTENSION_NEW_VERSION=(re.split('-',EXTENSION_NEW_VERSION))[0]

    ROOT = pathlib.Path(sys.argv[0]).parent.parent.parent.absolute()

    #Check if GSDK version is in (\d+)\.(\d+)\.(\d+) format
    if len(GDSK_NEW_VERSION.split("."))!=3:
        print("Error: Incorrect usage for GSDK version. Need (\d+)\.(\d+)\.(\d+) format")
        sys.exit()

    #Check if updated to README.md files is required.
    readme_args = README.split("=")
    if(len(readme_args)!=2 or readme_args[0]!="readme"):
        print("Error: Incorrect usage for readme. Example: ./slc/script/update_version.py 2.2.0-1.2 4.4.0 readme=True/False")
        sys.exit()
    else:
        UPDATE_README=True if readme_args[1].upper()=="TRUE" else False

    print("Updating the sdk_extension version to "+EXTENSION_NEW_VERSION)
    print("Updating the simplicity_sdk version to "+GDSK_NEW_VERSION)
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
    replace_text(str(ROOT)+"/matter.slce","  *id: simplicity_sdk\n  *version: "+VERSION_REGEX_FORMAT,"  id: simplicity_sdk\n  version: "+GDSK_NEW_VERSION)

    # Update matter.slsdk
    #
    # REGEX FORMAT:
    # version=0.0.4
    # prop.subLabel=Silicon Labs Matter\\ 1.0.4-1.0
    if FULL_VERSION:
        replace_text(str(ROOT)+"/matter.slsdk",FULL_VERSION_REGEX,EXTENSION_NEW_VERSION+"-"+AUX_VERSION)
    replace_text(str(ROOT)+"/matter.slsdk","version="+VERSION_REGEX_FORMAT,"version="+EXTENSION_NEW_VERSION)

    # Update pipeline_metadata.yml
    #
    # REGEX FORMAT:
    # matterExtensionVersion: '0.0.3'
    replace_text(str(ROOT)+"third_party/matter_private/jenkins/pipeline_metadata.yml","matterExtensionVersion: '"+VERSION_REGEX_FORMAT+"'","matterExtensionVersion: '"+EXTENSION_NEW_VERSION+"'")

    # Update .md files in slc/ directory
    #
    # REGEX FORMAT:
    # https://docs.silabs.com/matter/1.0.4
    if(UPDATE_README):
        readme_files = [os.path.abspath(f) for f in pathlib.Path(ROOT).glob("slc/**/*.md")]
        for file in readme_files:

            replace_text(file,"https://docs.silabs.com/matter/"+VERSION_REGEX_FORMAT, "https://docs.silabs.com/matter/"+EXTENSION_NEW_VERSION)
            if FULL_VERSION:
                replace_text(file,"https://www.silabs.com/documents/public/software/SilabsMatterPi_"+FULL_VERSION_REGEX+".zip", "https://www.silabs.com/documents/public/software/SilabsMatterPi_"+EXTENSION_NEW_VERSION+"-"+AUX_VERSION+".zip", False)

    # Update matter_docs.xml
    #
    # REGEX FORMAT:
    # https://github.com/SiliconLabs/matter_extension/releases/tag/v1.0.4
    # Silicon Labs Matter v1.0.4-1.0
    if FULL_VERSION:
        replace_text(str(ROOT)+"/matter_docs.xml","https://github.com/SiliconLabs/matter_extension/releases/tag/v"+VERSION_REGEX_FORMAT+"","https://github.com/SiliconLabs/matter_extension/releases/tag/v"+EXTENSION_NEW_VERSION)
        replace_text(str(ROOT)+"/matter_docs.xml","Silicon Labs Matter v"+FULL_VERSION_REGEX+"","Silicon Labs Matter v"+EXTENSION_NEW_VERSION+"-"+AUX_VERSION+"")