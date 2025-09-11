#!/usr/bin/env python3

"""
 * @file sl_build.py
 * @brief Build a Matter application from a reference project file.
 *
 * This script generates and builds a Matter application using a reference .slcp or .slcw project file
 * and a Silicon Labs board name. It invokes SLC and Make to produce the application binaries.
 *
 * Usage:
 *   python3 sl_build.py <PathToReferenceProjectFile(.slcp or .slcw)> <SilabsBoard>
 *
 * Example:
 *   python3 sl_build.py path/to/sample.slcp brd4338a
 *

"""

import os
import sys
import subprocess
import shutil
import argparse
import logging
from sl_create_new_app import createApp

def main():

    parser = argparse.ArgumentParser(description="Build a Matter application from a reference project file.")
    parser.add_argument("-p", "--reference_project_file", dest="reference_project_file", required=False, help="Path to the reference .slcp or .slcw project file")
    parser.add_argument("-b", "--silabs_board", dest="silabs_board", required=False, help="Silabs board name")
    parser.add_argument("-v", "--verbose", action="store_true", help="Enable verbose (debug) logging")
    # Accept positional arguments for backward compatibility
    parser.add_argument("args", nargs="*", help=argparse.SUPPRESS)
    args = parser.parse_args()
    App = createApp()

    # Support both positional and optional arguments for main required fields
    # Priority: optional flags > positional
    if not args.reference_project_file or not args.silabs_board:
        if len(args.args) >= 2:
            args.reference_project_file = args.args[0]
            args.silabs_board = args.args[1]
            board = args.silabs_board
            if not App.validate_board_argument(board):
                sys.exit(1)
        else:
            parser.error("reference_project_file and silabs_board are required.")

    # Setup logging
    level = logging.DEBUG if args.verbose else logging.INFO
    logging.basicConfig(level=level, format='[%(levelname)s] %(message)s')

    reference_project_file = args.reference_project_file
    silabs_board = args.silabs_board.lower()

    # use appropriate build flag for sample-app/solutions
    if reference_project_file.endswith('.slcp'):
        project_flag = "-p"
        silabs_app = os.path.basename(reference_project_file)[:-5]
        output_dir = os.path.dirname(reference_project_file)
        makefile_path = f"{silabs_app}.Makefile"
    elif reference_project_file.endswith('.slcw'):
        project_flag = "-w"
        silabs_app = os.path.basename(reference_project_file)[:-5]
        output_dir = os.path.dirname(reference_project_file)
        makefile_path = f"{silabs_app}.solution.Makefile"
    else:
        logging.error("Argument 1 needs to be a .slcp or .slcw file")
        logging.info("Example usage: python slc/sl_build.py <PathToReferenceProjectFile(.slcp or .slcw)> <SilabsBoard>")
        sys.exit(1)

    if not shutil.which("slc"):
        logging.error("slc not detected on host")
        logging.error("ERROR: please run slc/sl_setup_env.py to install slc.")
        sys.exit(1)

    if not shutil.which("arm-none-eabi-gcc"):
        logging.error("arm-none-eabi-gcc not detected on host")
        logging.error("ERROR: please run slc/sl_setup_env.py to install arm gcc toolchain")
        sys.exit(1)

    slc_path = App.slc_path
    java_path = App.java_path
    SoC_boards = App.SoC_boards
    config_args = ";wiseconnect3_sdk" if silabs_board in SoC_boards else ""

    logging.info("Generating project files with SLC...")
    result = subprocess.run([
        slc_path, "--java-location", java_path, "generate", "-d", output_dir, project_flag,
        reference_project_file, "--with", silabs_board + config_args, "--force", "--generator-timeout=180", "-o", "makefile"
    ])
    if result.returncode != 0:
        logging.error("SLC project generation failed.")
        sys.exit(result.returncode)

    logging.info("Building project with make...")
    result = subprocess.run(["make", "all", "-C", output_dir, "-f", makefile_path, "-j13"])
    if result.returncode != 0:
        logging.error("Make build failed.")
        sys.exit(result.returncode)
    logging.info("Build completed successfully.")

if __name__ == "__main__":
    main()