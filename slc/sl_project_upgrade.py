#!/usr/bin/env python3

# This script upgrades a given Matter project to a specified matter extension version.
# 
# Prerequisites:
# 1. Checkout the target tag/branch to which you need to upgrade the project.
# 2. Run the `slc/sl_setup_env.py` script to check out dependencies of that target tag/branch.
#
# Usage:
# python sl_project_upgrade.py <PathToReferenceProjectFile(.slcp) <extensionVersion>
#
# Example:
# python3 sl_project_upgrade.py out/lgt/thread/lighting-app-thread.slcp 2.5.0
 
import os
import sys
import subprocess
from sl_create_new_app import createApp

class Upgrade:
    def __init__(self):
        self.EXAMPLE_USAGE = "python slc/sl_project_upgrade.py <PathToReferenceProjectFile(.slcp)> <matterExtensionVersion>"
        self.app = createApp()
        self.validate_arguments()

    def validate_arguments(self):
        if len(sys.argv) < 2:
            print("Missing arguments")
            self.print_usage_and_exit()

        self.reference_project_file = sys.argv[1]
        self.matter_extension_version = sys.argv[2]

        if not os.path.exists(self.reference_project_file):
            print(f"Reference Project File does not exist: {self.reference_project_file}")
            sys.exit(1)

        if not self.reference_project_file.endswith(('.slcp')):
            print("Reference Project File should have a .slcp extension")
            sys.exit(1)

    def print_usage_and_exit(self):
        print(self.EXAMPLE_USAGE)
        sys.exit(1)

    def upgrade_project(self):
        SimplicitySDKpath = "third_party/simplicity_sdk"
        upgrade_cmd = [
            self.app.slc_path, "upgrade", "-s", SimplicitySDKpath, "-p",
            self.reference_project_file, "-extid", f"matter:{self.matter_extension_version}"
        ]
        subprocess.run(upgrade_cmd)
        print(f"Project {self.reference_project_file} upgraded to Matter Extension v{self.matter_extension_version}")

if __name__ == "__main__":
    upgrade = Upgrade()
    upgrade.upgrade_project()