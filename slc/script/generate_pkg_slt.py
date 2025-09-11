#!/usr/bin/env python3

"""
@file generate_pkg_slt.py
@brief Generate pkg.slt files next to SLC projects that contain .slcp files.

@details
    - Recursively walks a base directory provided via --directory/-d.
    - For each directory that contains at least one .slcp file, writes a pkg.slt
        file with default content that pins the Matter stack dependency to
        version "2.6.1" using the Conan installer.
    - Existing pkg.slt files at the same path will be overwritten.

@usage
    python3 generate_pkg_slt.py [--directory <BASE_PATH>] [--verbose]

@args
    --directory, -d  Optional. Base directory to search for .slcp files.
                     Defaults to slc/sample-app (relative to this script).
    --verbose, -v    Optional. Enable verbose logging output.

@output
    - Creates pkg.slt files alongside .slcp projects and logs progress to stdout.
"""

import os
import argparse
import logging

# Content of the pkg.slt file
pkg_slt_content = """# Version defaults to "0" if not defined
version = "0"
 
 
[dependency]
# Get a specific version of the package
matter = { version = "2.6.1", installer ="conan"}
"""

def generate_pkg_slt_files(base_directory, verbose):
    # Configure logging
    logging.basicConfig(level=logging.DEBUG if verbose else logging.INFO, format="%(message)s")
    logger = logging.getLogger()

    for root, dirs, files in os.walk(base_directory):
        # Check if a .slcp file exists in the current directory
        if any(file.endswith(".slcp") for file in files):
            pkg_slt_path = os.path.join(root, "pkg.slt")
            try:
                # Write the pkg.slt file
                with open(pkg_slt_path, "w") as pkg_slt_file:
                    pkg_slt_file.write(pkg_slt_content)
                logger.info(f"Generated pkg.slt in: {pkg_slt_path}")
            except Exception as e:
                logger.error(f"Failed to generate pkg.slt in {pkg_slt_path}: {e}")

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Generate pkg.slt files in directories containing .slcp files.")

    # Compute default directory as slc/sample-app relative to this script's location
    script_dir = os.path.dirname(os.path.abspath(__file__))
    default_dir = os.path.abspath(os.path.join(script_dir, "..", "sample-app"))

    parser.add_argument(
        "--directory",
        "-d",
        required=False,
        default=default_dir,
        help=f"Base directory to search for .slcp files (default: {default_dir}).",
    )
    parser.add_argument("--verbose", "-v", action="store_true", help="Enable verbose logging.")
    args = parser.parse_args()

    # Call the function to generate pkg.slt files
    logging.info(f"Using base directory: {args.directory}")
    generate_pkg_slt_files(args.directory, args.verbose)

if __name__ == "__main__":
    main()