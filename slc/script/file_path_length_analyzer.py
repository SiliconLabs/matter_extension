#!/usr/bin/env python3

"""
This script scans a specified directory and calculates the lengths of file paths after appending a given prefix.
It groups file paths with lengths greater than 240 into blocks of 10 (e.g., 240-249, 250-259) and writes these 
grouped paths to an output file. Additionally, it prints warnings for file paths exceeding 240 characters.

Usage:
    python3 slc/script/file_path_length_analyzer.py --directory <directory_to_scan> [--verbose]

Example:
    python3 slc/script/file_path_length_analyzer.py --directory /example/directory --verbose

Arguments:
    - --directory: The directory to scan for file paths.
    - --verbose: Enable detailed output.

Output:
    - Warnings for file paths exceeding 240 characters are printed to the console.
    - Grouped file paths with lengths greater than 240 are written to "long_file_paths.txt".

Example:
    If the user provides "/example/directory" as input, the script calculates the lengths of file paths after 
    appending the prefix, groups paths longer than 240 characters, and writes the grouped paths to "long_file_paths.txt".
"""

import os
import sys
import argparse
import logging
import sys
from io import BufferedWriter

# The prefix represents a base file path commonly found on Windows machines. 
prefix = r"C:\Users\longusername\.silabs\slt\installs\conan\p\matter_extension"

# Configure logging
logger = logging.getLogger(__name__)

def count_file_path_lengths(directory, prefix, verbose):
    # Dictionary to store counts grouped in blocks of 10
    grouped_paths = {}
    for root, _, files in os.walk(directory):
        for file in files:
            relative_path = os.path.relpath(os.path.join(root, file), directory)
            updated_path = os.path.join(prefix, relative_path)
            path_length = len(updated_path)
            # Log a warning for file paths longer than 240
            if path_length > 240:
                logger.warning(f"File path exceeds 240 characters: {relative_path}")

            # Group lengths in blocks of 10
            if path_length > 240:
                group = (path_length // 10) * 10
                if group not in grouped_paths:
                    grouped_paths[group] = []
                grouped_paths[group].append(relative_path)

    return grouped_paths

def write_long_file_paths(grouped_paths, output_file):
    if not grouped_paths:  # Check if there are no file paths exceeding 240 characters
        logger.info("No file paths exceeding 240 characters were detected. Nothing will be written to the file.")
        return

    logger.info(f"Updated file paths with length > 240 have been written to {output_file}")
    with open(output_file, 'wb') as file:  # Open in binary mode for BufferedWriter
        buffer = BufferedWriter(file)
        try:
            for group, paths in sorted(grouped_paths.items()):
                buffer.write(f"Group {group}-{group+9}:\n".encode('utf-8'))
                for path in paths:
                    buffer.write(f"  {path}\n".encode('utf-8'))
                buffer.write(b"\n")
            buffer.write(f"file paths are calculated by adding a prefix: {prefix}, of length {len(prefix)}  to the paths\n".encode('utf-8'))
        except Exception as e:
            logger.error(f"Error while writing to file: {e}")
        finally:
            buffer.flush()

def main():
    parser = argparse.ArgumentParser(description="Analyze file path lengths in a directory.")
    parser.add_argument(
        "--directory",
        required=True,
        help="The directory to scan for file paths."
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Enable detailed output."
    )
    parser.add_argument(
        "--ci",
        action="store_true",
        help="CI mode: exit with status 0 on success, 1 on failure"
    )
    args = parser.parse_args()

    # Configure logging level based on verbosity
    logging.basicConfig(level=logging.DEBUG if args.verbose else logging.INFO)

    directory = os.path.abspath(args.directory)
    if not os.path.isdir(directory):
        logger.error(f"Error: {directory} is not a valid directory.")
        sys.exit(1)

    output_file = "long_file_paths.txt"

    grouped_paths = count_file_path_lengths(directory, prefix, args.verbose)

    if not args.ci:
        if grouped_paths:
            # Log grouped counts
            logger.info("Updated file path length counts grouped in blocks of 10:")
            for group, paths in sorted(grouped_paths.items()):
                logger.info(f"{group}-{group+9}: {len(paths)}")

        # Write long file paths to a file
        write_long_file_paths(grouped_paths, output_file)
        if grouped_paths:
            logger.info(f"File paths are calculated by adding a prefix: {prefix}, of length {len(prefix)} to the paths")

    # CI mode: exit with status 0 on success, 1 on failure
    if args.ci:
        if grouped_paths:
            print("File paths exceeding 240 characters detected!")
            sys.exit(1)
        else:
            print("No file paths exceeding 240 characters were detected. Success.")
            sys.exit(0)

if __name__ == "__main__":
    main()