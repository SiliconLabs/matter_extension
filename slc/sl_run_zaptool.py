#!/usr/bin/env python3

import os
import subprocess
import argparse
import logging
from sl_create_new_app import createApp

EXAMPLE_USAGE = "python slc/sl_run_zaptool.py <PathToReferenceZapFile(.zap)>"

def main():
    parser = argparse.ArgumentParser(description="Run zaptool with a reference .zap file.")
    parser.add_argument("zapfile", metavar="PathToReferenceZapFile", type=str, help="Path to the .zap file")
    parser.add_argument("--verbose", action="store_true", help="Enable verbose logging")
    args = parser.parse_args()

    # Set up logging
    log_level = logging.DEBUG if args.verbose else logging.INFO
    logging.basicConfig(level=log_level, format='%(levelname)s: %(message)s')

    reference_zap_file = args.zapfile
    reference_zap_file = os.path.join("..", "..", reference_zap_file)
    logging.debug(f"Reference zap file: {reference_zap_file}")

    App = createApp()
    matter_sdk_path = os.path.join(os.getcwd(), "third_party/matter_sdk")
    logging.debug(f"Changing directory to: {matter_sdk_path}")
    os.chdir(matter_sdk_path)

    zaptool_path = os.path.join("scripts", "tools", "zap", "run_zaptool.sh")
    cmd = [zaptool_path, reference_zap_file]
    logging.info(f"Running command: {' '.join(cmd)}")
    try:
        subprocess.run(cmd, check=True)
        logging.info("zaptool ran successfully.")
    except subprocess.CalledProcessError as e:
        logging.error(f"zaptool failed: {e}")
        exit(1)

if __name__ == "__main__":
    main()