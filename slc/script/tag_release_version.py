#!/usr/bin/env python3
import argparse
import os
import sys
import pathlib
import re

def append_tag_to_version(filename, version_string, tag):
    with open(filename, 'r') as file:
        filedata = file.read()

    # Replace all occurrences of search_string with replacement
    new_filedata = filedata.replace(version_string, version_string + '-' + tag)

    with open(filename, 'w') as file:
        file.write(new_filedata)

def main():
    parser = argparse.ArgumentParser(description='Parse files for a given version string and append a provided tag.')
    parser.add_argument('-f', '--file', required=True, help='File(s) to parse')
    parser.add_argument('-v', '--version', required=True, help='Version to search for in the file')
    parser.add_argument('-t', '--tag', required=True, help='tag to append')
    args = parser.parse_args()

    append_tag_to_version(args.file, args.version, args.tag)

if __name__ == "__main__":
    main()