#!/usr/bin/env python3

"""
@file sl_project_upgrade.py
@brief Script to upgrade a Matter project using the checked-out Matter extension and SDKs.

@details
Prerequisites:
  1. Checkout the target tag/branch to which you need to upgrade the project.
  2. Run the slc/sl_setup_env.py script to check out dependencies of that target tag/branch.

@usage
  python sl_project_upgrade.py <PathToReferenceProjectFile(.slcp)>

@example
  python3 sl_project_upgrade.py out/lgt/thread/lighting-app.slcp
"""

import argparse
import logging
import os
import sys
import subprocess
from sl_create_new_app import CreateApp

class Upgrade:
    def __init__(self, reference_project_file, verbose=False):
        self.EXAMPLE_USAGE = "python slc/sl_project_upgrade.py <PathToReferenceProjectFile(.slcp)>"
        self.app = CreateApp()
        self.reference_project_file = reference_project_file
        self.verbose = verbose
        self.setup_logging()
        self.validate_arguments()

    def setup_logging(self):
        level = logging.DEBUG if self.verbose else logging.INFO
        logging.basicConfig(level=level, format='[%(levelname)s] %(message)s')

    def validate_arguments(self):
        if not self.reference_project_file:
            logging.error("Missing reference project file argument.")
            self.print_usage_and_exit()
        if not os.path.exists(self.reference_project_file):
            logging.error(f"Reference Project File does not exist: {self.reference_project_file}")
            sys.exit(1)
        if not self.reference_project_file.endswith('.slcp'):
            logging.error("Reference Project File should have a .slcp extension")
            sys.exit(1)

    def print_usage_and_exit(self):
        logging.info(self.EXAMPLE_USAGE)
        sys.exit(1)

    def upgrade_project(self):
        SimplicitySDKpath = self.app.sisdk_root
        WiseconnectPath = self.app.wiseconnect_root
        MatterExtensionPath = self.app.silabs_chip_root
        if not SimplicitySDKpath:
            logging.error("SISDK_ROOT is not set. Run slc/sl_setup_env.py to generate the .env file.")
            sys.exit(1)
        if not WiseconnectPath:
            logging.error("WISECONNECT_ROOT is not set. Run slc/sl_setup_env.py to generate the .env file.")
            sys.exit(1)
        if not MatterExtensionPath:
            logging.error("silabs_chip_root is not set. Run slc/sl_setup_env.py to generate the .env file.")
            sys.exit(1)
        upgrade_cmd = [
            self.app.slc_path, "upgrade", "-p", self.reference_project_file,
            "--sdk-package-path", SimplicitySDKpath,
            "--sdk-package-path", MatterExtensionPath,
            "--sdk-package-path", WiseconnectPath,
        ]
        subprocess.run(upgrade_cmd)
        logging.info(f"Project {self.reference_project_file} upgraded")

def main():
    parser = argparse.ArgumentParser(description="Upgrade a Matter project using the checked-out Matter extension and SDKs.")
    parser.add_argument("-p", "--reference_project_file", dest="reference_project_file", required=False, help="Path to the reference .slcp project file")
    parser.add_argument("-v", "--verbose", action="store_true", help="Enable verbose (debug) logging")
    # Accept positional arguments for backward compatibility
    parser.add_argument("args", nargs="*", help=argparse.SUPPRESS)
    args = parser.parse_args()

    # Support both positional and optional arguments for main required fields
    # Priority: optional flags > positional
    if not args.reference_project_file:
        if len(args.args) >= 1:
            args.reference_project_file = args.args[0]
        else:
            parser.error("reference_project_file is required.")

    upgrade = Upgrade(
        reference_project_file=args.reference_project_file,
        verbose=args.verbose
    )
    upgrade.upgrade_project()

if __name__ == "__main__":
    main()
