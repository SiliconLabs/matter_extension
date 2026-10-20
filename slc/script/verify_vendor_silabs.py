#!/usr/bin/env python3

"""
This script scans a specified directory for `.slcp`, `.slce`, and `.slcc` files and verifies whether they contain 
the string `vendor: silabs`. It excludes the `third_party` directory during the scan.

Usage:
    python3 verify_vendor_silabs.py --directory <directory_to_scan> [--verbose]

Example:
    python3 verify_vendor_silabs.py --directory /example/directory --verbose

Arguments:
    - --directory: The directory to scan for `.slcp`, `.slce`, and `.slcc` files.
    - --verbose: Enable detailed output.

Output:
    - Warnings for files missing the required string are printed to the console.
    - A list of files missing the required string is saved to `missing_vendor_silabs.txt`.

Example:
    If the user provides `/example/directory` as input, the script scans for `.slcp`, `.slce`, and `.slcc` files, 
    checks for the required string, and logs the results. Files missing the required string are saved to 
    `missing_vendor_silabs.txt`.
"""

import os
import argparse
import logging


class VerifyVendorSilabs:
    def __init__(self, verbose=False):
        """
        Initialize the VerifyVendorSilabs class with logging configuration.
        """
        self.logger = logging.getLogger(__name__)
        self.configure_logging(verbose)
        self.ignore_files = ["openthread-border-router-doc.slcp"]

    def configure_logging(self, verbose):
        """
        Configure logging level based on the verbose flag.
        """
        level = logging.DEBUG if verbose else logging.INFO
        logging.basicConfig(level=level, format='%(asctime)s - %(levelname)s - %(message)s')

    def find_files_with_extension(self, directory, extensions):
        """
        Recursively find all files with the given extensions in the specified directory,
        excluding the 'third_party' directory and specific files.
        """
        files = []
        for root, dirnames, filenames in os.walk(directory):
            # Exclude 'third_party' directory
            dirnames[:] = [d for d in dirnames if d != 'third_party']
            for filename in filenames:
                if filename.endswith(extensions) and filename not in self.ignore_files:
                    files.append(os.path.join(root, filename))
        return files

    def verify_vendor_silabs_file(self, file_path):
        """
        Verify if the file contains the string 'vendor: silabs' and performs additional checks for `.slcc` files.
        """
        contains_vendor = True
        # Checking file: {file_path}
        try:
            if file_path.endswith(".slcc"):
                import yaml
                with open(file_path, 'r') as file:
                    data = yaml.safe_load(file)
                recommends = data.get('recommends', [])
                if not recommends:
                    return True
                for idx, item in enumerate(recommends):
                    component_id = item.get('id') if isinstance(item, dict) else None
                    if component_id:
                        if "matter" not in component_id:
                            vendor = item.get('vendor', None)
                            if vendor != 'silabs':
                                return False
            else:
                with open(file_path, 'r') as file:
                    lines = file.readlines()
                if file_path.endswith(".slce"):
                    contains_vendor = any('vendor: silabs' in line for line in lines)
                if file_path.endswith('.slcp'):
                    contains_vendor = any('vendor: silabs' in line for line in lines)
        except Exception as e:
            self.logger.error(f"Error reading {file_path}: {e}")
        # Final contains_vendor for {file_path}: {contains_vendor}
        return contains_vendor
    def process_directory(self, directory, extensions):
        """
        Process the given directory to verify files with the specified extensions.
        """
        files = self.find_files_with_extension(directory, extensions)
        if not files:
            self.logger.info("No .slcp, .slce, or .slcc files found.")
            return

        missing_files = []

        for file_path in files:
            if not self.verify_vendor_silabs_file(file_path):
                self.logger.warning(f"'vendor: silabs' NOT found in: {file_path}")
                missing_files.append(file_path)

        # Save missing files to a file
        if missing_files:
            output_file = "missing_vendor_silabs.txt"
            with open(output_file, 'w') as f:
                for file_path in missing_files:
                    f.write(file_path + '\n')
            self.logger.info(f"List of files without 'vendor: silabs' saved to {output_file}")
        else:
            self.logger.info("All .slcp, .slce, and .slcc files contain the required string.")


def main():
    """
    Main function to parse .slcp, .slce, and .slcc files and verify 'vendor: silabs'.
    """
    parser = argparse.ArgumentParser(description="Scan .slcp, .slce, and .slcc files for 'vendor: silabs'.")
    parser.add_argument("--directory", type=str, required=True, help="Directory to scan for .slcp, .slce, and .slcc files.")
    parser.add_argument("--verbose", action="store_true", help="Enable verbose logging.")
    args = parser.parse_args()

    verifier = VerifyVendorSilabs(verbose=args.verbose)
    verifier.process_directory(args.directory, extensions=('.slcp', '.slce', '.slcc'))


if __name__ == "__main__":
    main()