#!/usr/bin/env python3

"""
@file sl_project_upgrade.py
@brief Script to upgrade a Matter project to a specified Matter extension version.

@details
Prerequisites:
  1. Checkout the target tag/branch to which you need to upgrade the project.
  2. Run the slc/sl_setup_env.py script to check out dependencies of that target tag/branch.

@usage
  python sl_project_upgrade.py <PathToReferenceProjectFile(.slcp)> <extensionVersion>

@example
  python3 sl_project_upgrade.py out/lgt/thread/lighting-app.slcp 2.6.0
"""

import argparse
import logging
import os
import sys
import subprocess
import json
from sl_create_new_app import createApp

class Upgrade:
    def __init__(self, reference_project_file, matter_extension_version, verbose=False):
        self.EXAMPLE_USAGE = "python slc/sl_project_upgrade.py <PathToReferenceProjectFile(.slcp)> <matterExtensionVersion>"
        self.app = createApp()
        self.reference_project_file = reference_project_file
        self.matter_extension_version = matter_extension_version
        self.verbose = verbose
        self.warnings = 0
        self.errors = 0
        self.setup_logging()
        self.validate_arguments()

    def setup_logging(self):
        level = logging.DEBUG if self.verbose else logging.INFO
        logging.basicConfig(level=level, format='[%(levelname)s] %(message)s')

    def validate_arguments(self):
        if not self.reference_project_file:
            logging.error("Missing reference project file argument.")
            self.errors += 1
            self.print_usage_and_exit()
        if not self.matter_extension_version:
            logging.error("Missing matter extension version argument.")
            self.errors += 1
            self.print_usage_and_exit()
        if not os.path.exists(self.reference_project_file):
            logging.error(f"Reference Project File does not exist: {self.reference_project_file}")
            self.errors += 1
            sys.exit(1)
        if not self.reference_project_file.endswith('.slcp'):
            logging.error("Reference Project File should have a .slcp extension")
            self.errors += 1
            sys.exit(1)

    def print_usage_and_exit(self):
        logging.info(self.EXAMPLE_USAGE)
        sys.exit(1)


    def git_merge_files(self, base_path, local_path, remote_path):
        """
        Use git merge-file to perform a three-way merge and write the result to output_path (overwrite local_path).
        If there is a conflict, notify the user that manual merging is required.
        Print an error message with all involved paths if merge fails.
        """
        try:
            result = subprocess.run([
                'git', 'merge-file', local_path, base_path, remote_path
            ], check=False, capture_output=True, text=True)
            if result.returncode == 1:
                logging.warning(f"Conflict detected while merging.\n  base: {base_path}\n  local: {local_path}\n  remote: {remote_path}")
                logging.warning(f"Please resolve the conflict manually in {local_path}.")
                self.warnings += 1
            elif result.returncode != 0:
                logging.error(f"git merge-file failed for local: {local_path}, base: {base_path}, remote: {remote_path} . Error: {result.stderr}")
                self.errors += 1
        except subprocess.CalledProcessError as e:
            logging.error(f"git merge-file failed for local: {local_path}, base: {base_path}, remote: {remote_path}. Exception: {e}")
            self.errors += 1

    def read_file(self, path):
        try:
            with open(path, 'r') as f:
                return f.readlines()
        except Exception as e:
            logging.error(f"Could not read {path}: {e}")
            self.errors += 1
            return None

    def write_file(self, path, lines):
        try:
            os.makedirs(os.path.dirname(path), exist_ok=True)
            with open(path, 'w') as f:
                f.writelines(lines)
        except Exception as e:
            logging.error(f"Could not write {path}: {e}")
            self.errors += 1

    def upgrade_project(self):
        # Perform the upgrade as before
        SimplicitySDKpath = "third_party/simplicity_sdk"
        upgrade_cmd = [
            self.app.slc_path, "upgrade", "-s", SimplicitySDKpath, "-p",
            self.reference_project_file, "-extid", f"matter:{self.matter_extension_version}"
        ]
        subprocess.run(upgrade_cmd)
        logging.info(f"Project {self.reference_project_file} upgraded to Matter Extension v{self.matter_extension_version}")

        # Now perform three-way merge for all files in customer_paths using git merge-file
        json_path = os.path.join(os.path.dirname(self.reference_project_file), '.bak', 'source_and_include_paths.json')
        if not os.path.exists(json_path):
            logging.warning(f"source_and_include_paths.json not found at {json_path}, skipping merge.")
            self.warnings += 1
            return
        with open(json_path, 'r') as f:
            paths = json.load(f)

        for kind in ['source', 'include']:
            matter_sdk_paths = paths['matter_sdk_paths'][kind]
            customer_paths = paths['customer_paths'][kind]
            backups_paths = paths['backups_paths'][kind]

            # Build lookup dicts by filename for each path list
            def build_dict_by_filename(path_list):
                return {os.path.basename(p): p for p in path_list}

            sdk_dict = build_dict_by_filename(matter_sdk_paths)
            cust_dict = build_dict_by_filename(customer_paths)
            back_dict = build_dict_by_filename(backups_paths)

            # Only merge files that exist in all three
            common_filenames = set(sdk_dict.keys()) & set(cust_dict.keys()) & set(back_dict.keys())
            for fname in sorted(common_filenames):
                matter_sdk = sdk_dict[fname]
                cust = cust_dict[fname]
                back = back_dict[fname]
                base_path = os.path.abspath(back)
                local_path = os.path.abspath(cust)
                remote_path = os.path.abspath(matter_sdk)
                if not (os.path.exists(base_path) and os.path.exists(local_path) and os.path.exists(remote_path)):
                    logging.warning(f"Skipping merge for {cust} due to missing file.")
                    self.warnings += 1
                    continue
                self.git_merge_files(base_path, local_path, remote_path)
                logging.info(f"Merged file written to {cust}")

    def print_summary(self):
        if self.errors > 0:
            print("\033[91m[FAILURE]\033[0m One or more errors occurred during the upgrade. See log above.")
        elif self.warnings > 0:
            print("\033[93m[WARNING]\033[0m Upgrade completed with warnings. See log above.")
        else:
            print("\033[92m[SUCCESS]\033[0m Upgrade completed successfully.")

def main():
    parser = argparse.ArgumentParser(description="Upgrade a Matter project to a specified Matter extension version.")
    parser.add_argument("-p", "--reference_project_file", dest="reference_project_file", required=False, help="Path to the reference .slcp project file")
    parser.add_argument("-m", "--matter_extension_version", dest="matter_extension_version", required=False, help="Matter extension version to upgrade to")
    parser.add_argument("-v", "--verbose", action="store_true", help="Enable verbose (debug) logging")
    # Accept positional arguments for backward compatibility
    parser.add_argument("args", nargs="*", help=argparse.SUPPRESS)
    args = parser.parse_args()

    # Support both positional and optional arguments for main required fields
    # Priority: optional flags > positional
    if not args.reference_project_file or not args.matter_extension_version:
        if len(args.args) >= 2:
            args.reference_project_file = args.args[0]
            args.matter_extension_version = args.args[1]
        else:
            parser.error("reference_project_file and matter_extension_version are required.")

    upgrade = Upgrade(
        reference_project_file=args.reference_project_file,
        matter_extension_version=args.matter_extension_version,
        verbose=args.verbose
    )
    upgrade.upgrade_project()
    upgrade.print_summary()

    def upgrade_project(self):
        # Three-way merge for all files in customer_paths using git merge-file
        json_path = os.path.join(os.path.dirname(self.reference_project_file), '.bak', 'source_and_include_paths.json')
        if not os.path.exists(json_path):
            print(f"source_and_include_paths.json not found at {json_path}, skipping merge.")
            return
        with open(json_path, 'r') as f:
            paths = json.load(f)

        for kind in ['source', 'include']:
            matter_sdk_paths = paths['matter_sdk_paths'][kind]
            customer_paths = paths['customer_paths'][kind]
            backups_paths = paths['backups_paths'][kind]

            def build_dict_by_filename(path_list):
                return {os.path.basename(p): p for p in path_list}

            sdk_dict = build_dict_by_filename(matter_sdk_paths)
            cust_dict = build_dict_by_filename(customer_paths)
            back_dict = build_dict_by_filename(backups_paths)

            common_filenames = set(sdk_dict.keys()) & set(cust_dict.keys()) & set(back_dict.keys())
            for fname in sorted(common_filenames):
                matter_sdk = sdk_dict[fname]
                cust = cust_dict[fname]
                back = back_dict[fname]
                base_path = os.path.abspath(back)
                local_path = os.path.abspath(cust)
                remote_path = os.path.abspath(matter_sdk)
                if not (os.path.exists(base_path) and os.path.exists(local_path) and os.path.exists(remote_path)):
                    print(f"Skipping merge for {cust} due to missing file.")
                    continue
                try:
                    result = subprocess.run([
                        'git', 'merge-file', local_path, base_path, remote_path
                    ], check=False)
                    if result.returncode == 1:
                        print(f"Conflict detected while merging. Please resolve manually in {local_path}.")
                    elif result.returncode != 0:
                        print(f"git merge-file failed for local: {local_path}, base: {base_path}, remote: {remote_path}")
                except Exception as e:
                    print(f"git merge-file failed for local: {local_path}, base: {base_path}, remote: {remote_path}. Exception: {e}")

if __name__ == "__main__":
    main()