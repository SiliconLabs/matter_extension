#!/usr/bin/env python3

"""
This script scans a specified directory for `.slcc`, `.slcp`, `.slce`, and `.slcw` files and verifies whether they
contain specific strings (`package: matter` or `id: matter`). It also triggers the `verify_vendor_silabs` function to
check for the presence of `vendor: silabs` in the same files. It excludes the `third_party` directory during the scan.

Usage:
    python3 verify_package_matter.py --directory <directory_to_scan> [--verbose]

Example:
    python3 verify_package_matter.py --directory /example/directory --verbose

Arguments:
    - --directory: The directory to scan for `.slcc`, `.slcp`, `.slce`, and `.slcw` files.
    - --verbose: Enable detailed output.

Output:
    - Warnings for files missing the required strings are printed to the console.
    - A list of files missing the required strings is saved to `missing_package_matter.txt`.
"""
import os
import argparse
import logging
import sys

from verify_vendor_silabs import VerifyVendorSilabs

# Configure logging
logger = logging.getLogger(__name__)

def configure_logging(verbose):
    """
    Configure logging level based on the verbose flag.
    """
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(level=level, format='%(asctime)s - %(levelname)s - %(message)s')

def write_list_to_file(paths, output_file, success_message=None):
    """
    Write a list of file paths to a file (one per line) and log a message.

    Args:
        paths (list[str]): List of file paths to write.
        output_file (str): Destination file path.
        success_message (str|None): Optional custom log message. If provided,
            you can include '{output_file}' which will be formatted with the filename.

    Returns:
        None. Logs info or errors.
    """
    try:
        with open(output_file, 'w') as f:
            for file_path in paths:
                f.write(file_path + '\n')
        if success_message:
            logger.info(success_message.format(output_file=output_file))
        else:
            logger.info("Wrote %d entries to %s", len(paths), output_file)
    except OSError as e:
        logger.error("Failed to write %s: %s", output_file, e)

def find_files_with_extension(directory, extensions):
    """
    Recursively find all files with the given extensions in the specified directory,
    excluding the 'third_party' directory.
    """
    files = []
    for root, dirnames, filenames in os.walk(directory):
        # Exclude 'third_party' directory
        dirnames[:] = [d for d in dirnames if d != 'third_party']
        for filename in filenames:
            if filename.endswith(extensions):
                files.append(os.path.join(root, filename))
    return files

def verify_package_matter(file_path):
    """
    Verify if the file contains the string 'package: matter' or 'id: matter'.
    """
    try:
        with open(file_path, 'r') as file:
            for line in file:
                if file_path.endswith('.slce'):
                    if 'id: matter' in line:
                        return True
                elif 'package: matter' in line:
                    return True
        return False
    except Exception as e:
        logger.error(f"Error reading file {file_path}: {e}")
        return False

def main():
    """
    Main function to parse .slcc, .slcp, .slce, and .slcw files and verify 'package: matter' or 'id: matter'.
    Also triggers `VerifyVendorSilabs` for additional checks.
    """
    parser = argparse.ArgumentParser(description="Scan .slcc, .slcp, .slce, and .slcw files for 'package: matter' or 'id: matter'.")
    parser.add_argument("--directory", type=str, required=True, help="Directory to scan for .slcc, .slcp, .slce, and .slcw files.")
    parser.add_argument("--verbose", action="store_true", help="Enable verbose logging.")
    parser.add_argument("--ci", action="store_true", help="CI mode: exit with status 0 on success, 1 on failure.")
    args = parser.parse_args()

    # Configure logging
    configure_logging(args.verbose)

    directory = args.directory
    extensions = ('.slcc', '.slcp', '.slce', '.slcw')
    files = find_files_with_extension(directory, extensions)

    # Instantiate VerifyVendorSilabs
    verifier = VerifyVendorSilabs(verbose=args.verbose)

    if not files:
        logger.info("No .slcc, .slcp, .slce, or .slcw files found.")
        return

    missing_files = []
    missing_vendor_files = []

    for file_path in files:
        # Verify 'package: matter' or 'id: matter'
        if not verify_package_matter(file_path):
            if file_path.endswith(".slce"):
                logger.warning(f"'id: matter' NOT found in: {file_path}")
            else:
                logger.warning(f"'package: matter' NOT found in: {file_path}")
            missing_files.append(file_path)

        # Trigger VerifyVendorSilabs for additional checks
        if not verifier.verify_vendor_silabs_file(file_path):
            logger.warning(f"'vendor: silabs' NOT found in: {file_path}")
            missing_vendor_files.append(file_path)

    # Save missing files to files
    if missing_files:
        write_list_to_file(
            missing_files,
            "missing_package_matter.txt",
            "List of files without 'package: matter' or 'id: matter' saved to {output_file}",
        )

    if missing_vendor_files:
        write_list_to_file(
            missing_vendor_files,
            "missing_vendor_silabs.txt",
            "List of files without 'vendor: silabs' saved to {output_file}",
        )

    if not missing_files and not missing_vendor_files:
        logger.info("All .slcc, .slcp, .slcw, and .slce files contain the required strings.")
        if args.ci:
            sys.exit(0)
        return

    # If we reach here there was at least one failure
    if args.ci:
        sys.exit(1)

if __name__ == "__main__":
    main()