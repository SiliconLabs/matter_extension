# Copyright 2021 The Pigweed Authors
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
"""Pigweed Console entry point."""

import argparse
import inspect
import logging
from pathlib import Path
import sys

import pw_cli.log
import pw_cli.argument_types

import pw_console
import pw_console.python_logging
from pw_console.log_store import LogStore
from pw_console.plugins.calc_pane import CalcPane
from pw_console.plugins.clock_pane import ClockPane

_LOG = logging.getLogger(__package__)
_ROOT_LOG = logging.getLogger('')


# TODO(tonymd): Remove this when no downstream projects are using it.
def create_temp_log_file():
    return pw_console.python_logging.create_temp_log_file()


def _build_argument_parser() -> argparse.ArgumentParser:
    """Setup argparse."""
    parser = argparse.ArgumentParser(description=__doc__)

    parser.add_argument('-l',
                        '--loglevel',
                        type=pw_cli.argument_types.log_level,
                        default=logging.DEBUG,
                        help='Set the log level'
                        '(debug, info, warning, error, critical)')

    parser.add_argument('--logfile', help='Pigweed Console log file.')

    parser.add_argument('--test-mode',
                        action='store_true',
                        help='Enable fake log messages for testing purposes.')
    parser.add_argument('--config-file',
                        type=Path,
                        help='Path to a pw_console yaml config file.')
    parser.add_argument('--console-debug-log-file',
                        help='Log file to send console debug messages to.')

    return parser


def main() -> int:
    """Pigweed Console."""

    parser = _build_argument_parser()
    args = parser.parse_args()

    if not args.logfile:
        # Create a temp logfile to prevent logs from appearing over stdout. This
        # would corrupt the prompt toolkit UI.
        args.logfile = pw_console.python_logging.create_temp_log_file()

    pw_cli.log.install(level=args.loglevel,
                       use_color=True,
                       hide_timestamp=False,
                       log_file=args.logfile)

    if args.console_debug_log_file:
        pw_cli.log.install(level=logging.DEBUG,
                           use_color=True,
                           hide_timestamp=False,
                           log_file=args.console_debug_log_file,
                           logger=logging.getLogger('pw_console'))

    global_vars = None
    default_loggers = {}
    if args.test_mode:
        root_log_store = LogStore()
        _ROOT_LOG.addHandler(root_log_store)
        _ROOT_LOG.debug('pw_console test-mode starting...')

        fake_logger = logging.getLogger(
            pw_console.console_app.FAKE_DEVICE_LOGGER_NAME)
        default_loggers = {
            # Don't include pw_console package logs (_LOG) in the log pane UI.
            # Add the fake logger for test_mode.
            'Fake Device Logs': [fake_logger],
            'PwConsole Debug': [logging.getLogger('pw_console')],
            'All Logs': root_log_store,
        }
        # Give access to adding log messages from the repl via: `LOG.warning()`
        global_vars = dict(LOG=fake_logger)

    help_text = None
    app_title = None
    if args.test_mode:
        app_title = 'Console Test Mode'
        help_text = inspect.cleandoc("""
            Welcome to the Pigweed Console Test Mode!

            Example commands:

              rpcs.pw.rpc.EchoService.Echo(msg='hello!')

              LOG.warning('Message appears console log window.')
        """)

    console = pw_console.PwConsoleEmbed(
        global_vars=global_vars,
        loggers=default_loggers,
        test_mode=args.test_mode,
        help_text=help_text,
        app_title=app_title,
        config_file_path=args.config_file,
    )

    # Add example plugins used to validate behavior in the Pigweed Console
    # manual test procedure: https://pigweed.dev/pw_console/testing.html
    if args.test_mode:
        _ROOT_LOG.debug('pw_console.PwConsoleEmbed init complete')
        _ROOT_LOG.debug('Adding plugins...')
        console.add_window_plugin(ClockPane())
        console.add_window_plugin(CalcPane())
        _ROOT_LOG.debug('Starting prompt_toolkit full-screen application...')

    console.embed()

    if args.logfile:
        print(f'Logs saved to: {args.logfile}')

    return 0


if __name__ == '__main__':
    sys.exit(main())
