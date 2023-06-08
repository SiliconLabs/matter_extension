#!/usr/bin/env python
# Copyright 2022 The Pigweed Authors
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.
"""Pigweed Watch argparser."""

import argparse
from pathlib import Path

from pw_build.project_builder_argparse import add_project_builder_arguments

WATCH_PATTERN_DELIMITER = ','

WATCH_PATTERNS = (
    '*.bloaty',
    '*.c',
    '*.cc',
    '*.css',
    '*.cpp',
    '*.cmake',
    'CMakeLists.txt',
    '*.dts',
    '*.dtsi',
    '*.gn',
    '*.gni',
    '*.go',
    '*.h',
    '*.hpp',
    '*.ld',
    '*.md',
    '*.options',
    '*.proto',
    '*.py',
    '*.rs',
    '*.rst',
    '*.s',
    '*.S',
    '*.toml',
)


def add_parser_arguments(
    parser: argparse.ArgumentParser,
) -> argparse.ArgumentParser:
    """Sets up an argument parser for pw watch."""
    parser = add_project_builder_arguments(parser)

    watch_group = parser.add_argument_group(title='Watch Options')

    watch_group.add_argument(
        '--patterns',
        help=('Comma delimited list of globs to watch to trigger recompile.'),
        default=WATCH_PATTERN_DELIMITER.join(WATCH_PATTERNS),
    )

    watch_group.add_argument(
        '--ignore-patterns',
        dest='ignore_patterns_string',
        help=('Comma delimited list of globs to ignore events from.'),
    )

    watch_group.add_argument(
        '--exclude-list',
        nargs='+',
        type=Path,
        help=(
            'Directories to ignore during pw watch. This option may be '
            'repeated. Directories are passed as separate arguments.'
        ),
        default=[],
    )

    watch_group.add_argument(
        '--no-restart',
        dest='restart',
        action='store_false',
        help='do not restart ongoing builds if files change',
    )

    watch_group.add_argument(
        '--serve-docs',
        dest='serve_docs',
        action='store_true',
        default=False,
        help='Start a webserver for docs on localhost. The port for this '
        ' webserver can be set with the --serve-docs-port option. '
        ' Defaults to http://127.0.0.1:8000',
    )

    watch_group.add_argument(
        '--serve-docs-port',
        dest='serve_docs_port',
        type=int,
        default=8000,
        help='Set the port for the docs webserver. Default: 8000.',
    )

    watch_group.add_argument(
        '--serve-docs-path',
        dest='serve_docs_path',
        type=Path,
        default='docs/gen/docs',
        help='Set the path for the docs to serve. Default: docs/gen/docs'
        ' in the build directory.',
    )

    watch_group.add_argument(
        '-f',
        '--fullscreen',
        action='store_true',
        help='Use a fullscreen interface.',
    )

    return parser
