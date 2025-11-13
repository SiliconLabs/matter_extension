#!/usr/bin/env python3
"""
@file validate_components.py
@brief Validate SLC components (.slcc) and optional upgrade file using Silicon Labs SLC tool.

This script recursively scans a components directory for .slcc files and invokes the
SLC validator for each. It can also validate an optional upgrade file (upgrade.slcu)
located at the repository root.

Usage examples (from repository root):
  - Validate with defaults:
      ./slc/script/validate_components.py

  - Validate a custom directory with a specific SLC binary:
      ./slc/script/validate_components.py -d slc/component -s /path/to/slc

  - Backwards-compatible positional args (directory [slc]):
      ./slc/script/validate_components.py slc/component /path/to/slc
"""

import argparse
import logging
import os
import subprocess
import sys
from typing import Iterable, List


logger = logging.getLogger(__name__)


def _sanitize_slc_path(slc_path: str) -> str:
    """!
    @brief Validate and sanitize the SLC binary path.

    @param slc_path Path to the SLC binary (or just "slc" on PATH).
    @return The sanitized SLC path.
    @throws ValueError If the path is invalid or potentially unsafe.
    """
    if not slc_path:
        raise ValueError("Binary location cannot be empty.")

    # Require the basename to be exactly 'slc' to match original behavior
    if os.path.basename(slc_path) != "slc":
        raise ValueError("Binary location must point to an 'slc' executable.")

    # Basic character screening (extra-safe even though we avoid shell=True)
    invalid_chars = [';', '&', '|', '<', '>', '$', '`', '(', ')', '{', '}', '[', ']', '\\', '\'', '"', '..']
    for ch in invalid_chars:
        if ch in slc_path:
            raise ValueError("Binary location contains invalid characters.")

    return slc_path.strip()


def print_cleansed(output: Iterable[str], stash: bool = False) -> None:
    """!
    @brief Print validator output while removing extra noise.

    Do not print logs for components without any issues (those that end with
    "No issues detected").

    @param output Iterable of output strings to cleanse and log.
    @param stash  If True, drop the first 2 lines from SLC output (stash-mode formatting).
    """
    for item in output:
        lines = item.split('\n')
        if lines and "No issues detected" in lines[-1]:
            break
        cleaned_output = '\n'.join(lines[2:]) if stash else '\n'.join(lines)
        cleaned_output = cleaned_output.strip()
        if cleaned_output:
            logger.info("%s\n", cleaned_output)


def validate_slcc_files(directory: str, slc_cmd: str, stash: bool = False) -> bool:
    """!
    @brief Validate all .slcc component files under a directory using SLC.

    @param directory Directory to search recursively for .slcc files.
    @param slc_cmd Path to the SLC executable (or 'slc' if on PATH).
    @param stash If True, enable stash-mode output formatting when printing.
    @return True if all validations succeeded; False if any failed.
    @throws ValueError If the directory does not exist.
    """
    if not os.path.isdir(directory):
        raise ValueError("Directory does not exist.")

    success = True
    logger.info("Validating components within %s.\n", directory)

    for root, _dirs, files in os.walk(directory):
        for file in files:
            results: List[str] = []
            if file.endswith(".slcc"):
                file_path = os.path.join(root, file)
                cmd = [slc_cmd, "--daemon", "validate", file_path, "--extension-path=./"]
                try:
                    completed = subprocess.run(
                        cmd,
                        check=True,
                        capture_output=True,
                        text=True,
                    )
                    results.append((completed.stdout or "").strip())
                except subprocess.CalledProcessError as e:
                    out = (e.stdout or "")
                    err = (e.stderr or "")
                    combined = (out + ("\n" if out and err else "") + err).strip()
                    results.append(combined)
                    success = False
                except FileNotFoundError as e:
                    # slc not installed or not found on PATH
                    results.append(str(e))
                    success = False
            # Keep printing behavior per original script
            print_cleansed(results, stash)

    return success


def validate_upgrade_file(directory: str, slc_cmd: str, stash: bool = False) -> None:
    """!
    @brief Validate an upgrade.slcu file at the repository root (if present).

    @param directory Root directory where 'upgrade.slcu' is expected.
    @param slc_cmd Path to the SLC executable (or 'slc' if on PATH).
    @param stash If True, enable stash-mode output formatting when printing.
    """
    upgrade_path = os.path.join(directory, "upgrade.slcu")
    if not os.path.isfile(upgrade_path):
        logger.debug("No upgrade.slcu found at %s; skipping upgrade validation.", upgrade_path)
        return

    cmd = [slc_cmd, "validate-upgrade", upgrade_path]
    results: List[str] = []
    try:
        completed = subprocess.run(cmd, check=True, capture_output=True, text=True)
        results.append((completed.stdout or "").strip())
        logger.info("Upgrade file validation successful.\n")
    except subprocess.CalledProcessError as e:
        out = (e.stdout or "")
        err = (e.stderr or "")
        combined = (out + ("\n" if out and err else "") + err).strip()
        results.append(combined)
        logger.info("Upgrade file validation unsuccessful.\n")
        print_cleansed(results, stash)
    except FileNotFoundError as e:
        results.append(str(e))
        logger.info("Upgrade file validation unsuccessful.\n")
        print_cleansed(results, stash)


def parse_args(argv: List[str]) -> argparse.Namespace:
    """!
    @brief Parse command line arguments.

    @param argv The list of command-line arguments (excluding program name).
    @return Parsed arguments namespace.
    """
    parser = argparse.ArgumentParser(
        description="Validate SLC components (.slcc) and optional upgrade file using SLC.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    # Backwards-compatible positional arguments: [directory] [slc]
    parser.add_argument(
        "pos_directory",
        nargs="?",
        help="Positional: directory to search recursively for .slcc files",
    )
    parser.add_argument(
        "pos_slc",
        nargs="?",
        help="Positional: path to SLC binary or 'slc' if available on PATH",
    )
    parser.add_argument(
        "-d",
        "--directory",
        default=None,
        help="Directory to search recursively for .slcc files",
    )
    parser.add_argument(
        "-s",
        "--slc",
        default=None,
        help="Path to SLC binary or 'slc' if available on PATH",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Enable verbose logging",
    )
    parser.add_argument(
        "--stash",
        action="store_true",
        help="Trim first two lines of SLC output (stash-mode formatting)",
    )
    return parser.parse_args(argv)


def main(argv: List[str]) -> int:
    """!
    @brief Program entry point.

    @param argv Command-line arguments (excluding program name).
    @return Exit code compatible with shell conventions (0 success, non-zero otherwise).
    """
    args = parse_args(argv)

    # Logging setup
    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format="%(levelname)s: %(message)s",
    )

    # Resolve effective inputs with backward compatibility
    directory = args.pos_directory or args.directory or "slc/component"
    slc_arg = args.pos_slc or args.slc or "slc"

    # Legacy-style info messages
    if (args.pos_slc is None) and (args.slc is None):
        logger.info("Using default 'slc' as command.")
    else:
        logger.info("Using %s as command.", slc_arg)

    try:
        slc_cmd = _sanitize_slc_path(slc_arg)
    except ValueError as ex:
        logger.error(str(ex))
        return 2

    root_dir = os.getcwd()
    dir_to_search = os.path.join(root_dir, directory)

    # Validate optional upgrade file
    validate_upgrade_file(root_dir, slc_cmd, args.stash)

    # Validate components
    try:
        if validate_slcc_files(dir_to_search, slc_cmd, args.stash):
            logger.info("Validation successful! No issues detected.")
            return 0
        else:
            logger.info("Validation warnings/errors. Please see the above logs.")
            return 1
    except ValueError as ex:
        logger.error(str(ex))
        return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
