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
"""pw_ide CLI command handlers."""

import logging
from pathlib import Path
import shlex
import subprocess
import sys
from typing import cast, Dict, List, Optional, Set

from pw_cli.env import pigweed_environment

from pw_ide.cpp import (
    COMPDB_FILE_NAME,
    ClangdSettings,
    CppCompilationDatabase,
    CppCompilationDatabaseFileHashes,
    CppCompilationDatabaseFileTargets,
    CppCompilationDatabasesMap,
    CppIdeFeaturesState,
    CppIdeFeaturesTarget,
)

from pw_ide.exceptions import (
    BadCompDbException,
    InvalidTargetException,
    MissingCompDbException,
)

from pw_ide.python import PythonPaths

from pw_ide.settings import (
    PigweedIdeSettings,
    SupportedEditor,
)

from pw_ide.status_reporter import StatusReporter

from pw_ide import vscode
from pw_ide.vscode import VscSettingsManager, VscSettingsType

_LOG = logging.getLogger(__package__)
env = pigweed_environment()


def _make_working_dir(
    reporter: StatusReporter, settings: PigweedIdeSettings, quiet: bool = False
) -> None:
    if not settings.working_dir.exists():
        settings.working_dir.mkdir()
        if not quiet:
            reporter.new(
                'Initialized the Pigweed IDE working directory at '
                f'{settings.working_dir}'
            )


def _report_unrecognized_editor(reporter: StatusReporter, editor: str) -> None:
    supported_editors = ', '.join(sorted([ed.value for ed in SupportedEditor]))
    reporter.wrn(f'Unrecognized editor: {editor}')
    reporter.wrn('This may not be an automatically-supported editor.')
    reporter.wrn(f'Automatically-supported editors: {supported_editors}')


def cmd_sync(
    reporter: StatusReporter = StatusReporter(),
    pw_ide_settings: PigweedIdeSettings = PigweedIdeSettings(),
) -> None:
    """Setup or sync your Pigweed project IDE features.

    This will automatically set up your development environment with all the
    features that Pigweed IDE supports, with sensible defaults.

    At minimum, this command will create the .pw_ide working directory and
    create settings files for all supported editors. Projects can define
    additional setup steps in .pw_ide.yaml.

    When new IDE features are introduced in the future (either by Pigweed or
    your downstream project), you can re-run this command to set up the new
    features. It will not overwrite or break any of your existing configuration.
    """
    reporter.info('Syncing pw_ide...')
    _make_working_dir(reporter, pw_ide_settings)

    for command in pw_ide_settings.sync:
        _LOG.debug("Running: %s", command)
        subprocess.run(shlex.split(command), check=True)

    if pw_ide_settings.editor_enabled('vscode'):
        cmd_vscode()

    reporter.info('Done')


def cmd_setup(
    reporter: StatusReporter = StatusReporter(),
    pw_ide_settings: PigweedIdeSettings = PigweedIdeSettings(),
) -> None:
    """Deprecated! Please use `pw ide sync`."""
    reporter.wrn(
        "The `setup` command is now `sync`. Next time, run `pw ide sync`."
    )
    cmd_sync(reporter, pw_ide_settings)


def cmd_vscode(
    include: Optional[List[VscSettingsType]] = None,
    exclude: Optional[List[VscSettingsType]] = None,
    reporter: StatusReporter = StatusReporter(),
    pw_ide_settings: PigweedIdeSettings = PigweedIdeSettings(),
) -> None:
    """Configure support for Visual Studio Code.

    This will replace your current Visual Studio Code (VSC) settings for this
    project (in ``.vscode/settings.json``, etc.) with the following sets of
    settings, in order:

    - The Pigweed default settings
    - Your project's settings, if any (in ``.vscode/pw_project_settings.json``)
    - Your personal settings, if any (in ``.vscode/pw_user_settings.json``)

    In other words, settings files lower on the list can override settings
    defined by those higher on the list. Settings defined in the sources above
    are not active in VSC until they are merged and output to the current
    settings file by running:

    .. code-block:: bash

       pw ide vscode

    Refer to the Visual Studio Code documentation for more information about
    these settings: https://code.visualstudio.com/docs/getstarted/settings

    This command also manages VSC tasks (``.vscode/tasks.json``) and extensions
    (``.vscode/extensions.json``). You can explicitly control which of these
    settings types ("settings", "tasks", and "extensions") is modified by
    this command by using the ``--include`` or ``--exclude`` options.

    Your current VSC settings will never change unless you run ``pw ide``
    commands. Since the current VSC settings are an artifact built from the
    three settings files described above, you should avoid manually editing
    that file; it will be replaced the next time you run ``pw ide vscode``. A
    backup of your previous settings file will be made, and you can diff it
    against the new file to see what changed.

    These commands will never modify your VSC user settings, which are
    stored outside of the project repository and apply globally to all VSC
    instances.

    The settings files are system-specific and shouldn't be checked into the
    repository, except for the project settings (those with ``pw_project_``),
    which can be used to define consistent settings for everyone working on the
    project.

    Note that support for VSC can be disabled at the project level or the user
    level by adding the following to .pw_ide.yaml or .pw_ide.user.yaml
    respectively:

    .. code-block:: yaml

        editors:
          vscode: false

    Likewise, it can be enabled by setting that value to true. It is enabled by
    default.
    """
    if not pw_ide_settings.editor_enabled('vscode'):
        reporter.wrn('Visual Studio Code support is disabled in settings!')
        sys.exit(1)

    if not vscode.DEFAULT_SETTINGS_PATH.exists():
        vscode.DEFAULT_SETTINGS_PATH.mkdir()

    vsc_manager = VscSettingsManager(pw_ide_settings)

    if include is None and exclude is None:
        include_set = set(VscSettingsType.all())
        exclude_set: Set[VscSettingsType] = set()

    elif include is None:
        include_set = set(VscSettingsType.all())
        exclude_set = set(exclude if exclude is not None else [])

    elif exclude is None:
        include_set = set(include if include is not None else [])
        exclude_set = set()

    else:
        include_set = set(include if include is not None else [])
        exclude_set = set(exclude if exclude is not None else [])

    types_to_update = cast(
        List[VscSettingsType], tuple(include_set - exclude_set)
    )

    for settings_type in types_to_update:
        prev_settings_hash = ''
        active_settings_existed = vsc_manager.active(settings_type).is_present()

        if active_settings_existed:
            prev_settings_hash = vsc_manager.active(settings_type).hash()

        with vsc_manager.active(settings_type).build() as active_settings:
            vsc_manager.default(settings_type).sync_to(active_settings)
            vsc_manager.project(settings_type).sync_to(active_settings)
            vsc_manager.user(settings_type).sync_to(active_settings)

        new_settings_hash = vsc_manager.active(settings_type).hash()
        settings_changed = new_settings_hash != prev_settings_hash

        _LOG.debug(
            'VS Code %s prev hash: %s',
            settings_type.name.lower(),
            prev_settings_hash,
        )
        _LOG.debug(
            'VS Code %s curr hash: %s',
            settings_type.name.lower(),
            new_settings_hash,
        )

        if settings_changed:
            verb = 'Updated' if active_settings_existed else 'Created'
            reporter.new(
                f'{verb} Visual Studio Code active ' f'{settings_type.value}'
            )


def _process_compdbs(  # pylint: disable=too-many-locals
    reporter: StatusReporter,
    pw_ide_settings: PigweedIdeSettings,
    always_output_new: bool = False,
):
    """Find and process compilation databases in the project.

    This essentially does four things:
    - Find all the compilation databases it can in the build directory
    - For any databases we've seen before and are unchanged, skip them
    - For any we haven't seed before or are changed, process them
    - Save the state to disk so that other commands can examine/change targets
    """

    state = CppIdeFeaturesState(pw_ide_settings)

    # If a compilation database was seen before and is unchanged, or if it's new
    # and we process it, it will end up in the new hashes dict. If we saw it
    # in the past but it no longer exists, it will not move over to the new
    # hashes dict.
    prev_compdb_hashes = state.compdb_hashes
    new_compdb_hashes: CppCompilationDatabaseFileHashes = {}
    prev_compdb_targets = state.compdb_targets
    new_compdb_targets: CppCompilationDatabaseFileTargets = {}

    targets: List[CppIdeFeaturesTarget] = []
    num_new_unprocessed_targets = 0
    num_new_processed_targets = 0
    num_carried_over_targets = 0
    num_removed_targets = len(state.targets.values())

    unprocessed_compdb_files: List[Path] = []
    processed_compdb_files: List[Path] = []

    # Associate processed compilation databases with their original sources
    all_processed_compdbs: Dict[Path, CppCompilationDatabasesMap] = {}

    build_dir: Path = pw_ide_settings.build_dir
    compdb_file_paths = list(build_dir.rglob(str(COMPDB_FILE_NAME)))

    for compdb_file_path in compdb_file_paths:
        # Load the compilation database
        try:
            compdb = CppCompilationDatabase.load(compdb_file_path, build_dir)
        except MissingCompDbException:
            reporter.err(f'File not found: {str(compdb_file_path)}')
            sys.exit(1)
        # TODO(chadnorvell): Recover more gracefully from errors.
        except BadCompDbException:
            reporter.err(
                'File does not match compilation database format: '
                f'{str(compdb_file_path)}'
            )
            sys.exit(1)

        # Check the hash of the compilation database against our cache of
        # database hashes. Have we see this before and is the hash the same?
        # Then we can skip this database.
        if (
            compdb_file_path in prev_compdb_hashes
            and compdb.file_hash == prev_compdb_hashes[compdb_file_path]
        ):
            # Store this hash in the new hash registry.
            new_compdb_hashes[compdb_file_path] = compdb.file_hash
            # Copy the targets associated with this file...
            new_compdb_targets[compdb_file_path] = prev_compdb_targets[
                compdb_file_path
            ]
            # ... and add them to the targets list.
            targets.extend(new_compdb_targets[compdb_file_path])
            num_carried_over_targets += len(
                new_compdb_targets[compdb_file_path]
            )
            num_removed_targets -= len(new_compdb_targets[compdb_file_path])
            continue

        # We haven't seen this database before. Process it.
        processed_compdbs = compdb.process(
            settings=pw_ide_settings,
            path_globs=pw_ide_settings.clangd_query_drivers(),
            always_output_new=always_output_new,
        )

        # The source database doesn't actually need processing, so use it as is.
        if processed_compdbs is None:
            # Infer the name of the target from the path
            name = '_'.join(
                compdb_file_path.relative_to(build_dir).parent.parts
            )

            target = CppIdeFeaturesTarget(
                name=name,
                compdb_file_path=compdb_file_path,
                num_commands=len(
                    CppCompilationDatabase.load(compdb_file_path, build_dir)
                ),
            )

            # An unprocessed database will have only one target.
            new_compdb_targets[compdb_file_path] = [target]
            unprocessed_compdb_files.append(compdb_file_path)
            targets.append(target)
            num_new_unprocessed_targets += 1

            # Remember that we've seen this database.
            new_compdb_hashes[compdb_file_path] = compdb.file_hash

        else:
            # We need to use the processed databases, so store them for writing.
            # We'll add the targets associated with the processed databases
            # later.
            all_processed_compdbs[compdb_file_path] = processed_compdbs
            processed_compdb_files.append(compdb_file_path)

    if len(all_processed_compdbs) > 0:
        # Merge into one map of target names to compilation database.
        merged_compdbs = CppCompilationDatabasesMap.merge(
            *all_processed_compdbs.values()
        )

        # Write processed databases to files.
        try:
            merged_compdbs.write()
        except TypeError:
            reporter.err('Could not serialize file to JSON!')
            reporter.wrn('pw_ide state will not be persisted.')
            return False

        # Grab the target and file info from the processed databases.
        for target_name, compdb in merged_compdbs.items():
            target = CppIdeFeaturesTarget(
                name=target_name,
                compdb_file_path=cast(Path, compdb.file_path),
                num_commands=len(compdb),
            )

            targets.append(target)
            num_new_processed_targets += 1

            if (
                source := cast(Path, compdb.source_file_path)
            ) not in new_compdb_targets:
                new_compdb_targets[source] = [target]
                new_compdb_hashes[source] = cast(str, compdb.source_file_hash)
            else:
                new_compdb_targets[source].append(target)

    # Write out state.
    targets_dict = {target_data.name: target_data for target_data in targets}
    state.targets = targets_dict
    state.compdb_hashes = new_compdb_hashes
    state.compdb_targets = new_compdb_targets

    # If the current target is no longer valid, unset it.
    if (
        state.current_target is not None
        and state.current_target.name not in targets_dict
    ):
        state.current_target = None

    num_total_targets = len(targets)
    num_new_targets = num_new_processed_targets + num_new_unprocessed_targets

    # Report the results.
    # Return True if anything meaningful changed as a result of the processing.
    # If the new state is essentially identical to the old state, return False
    # so the caller can avoid needlessly updating anything else.
    if num_new_targets > 0 or num_removed_targets > 0:
        found_compdb_text = (
            f'Found {len(compdb_file_paths)} compilation database'
        )

        if len(compdb_file_paths) > 1:
            found_compdb_text += 's'

        reporter.ok(found_compdb_text)

        reporter_lines = []

        if len(unprocessed_compdb_files) > 0:
            reporter_lines.append(
                f'Linked {len(unprocessed_compdb_files)} '
                'unmodified compilation databases'
            )

        if len(processed_compdb_files) > 0:
            working_dir_path = pw_ide_settings.working_dir.relative_to(
                Path(env.PW_PROJECT_ROOT)
            )
            reporter_lines.append(
                f'Processed {len(processed_compdb_files)} to working dir at '
                f'{working_dir_path}'
            )

        if len(reporter_lines) > 0:
            reporter_lines.extend(
                [
                    f'{num_total_targets} targets are now available '
                    f'({num_new_targets} are new, '
                    f'{num_removed_targets} were removed)',
                ]
            )

            reporter.new(reporter_lines)

        return True
    return False


def cmd_cpp(  # pylint: disable=too-many-arguments, too-many-locals, too-many-branches, too-many-statements
    should_list_targets: bool,
    should_get_target: bool,
    target_to_set: Optional[str],
    build_dir: Optional[Path],
    process: bool = True,
    use_default_target: bool = False,
    clangd_command: bool = False,
    clangd_command_system: Optional[str] = None,
    reporter: StatusReporter = StatusReporter(),
    pw_ide_settings: PigweedIdeSettings = PigweedIdeSettings(),
) -> None:
    """Configure C/C++ code intelligence support.

    Code intelligence can be provided by clangd or other language servers that
    use the clangd compilation database format, defined at:
    https://clang.llvm.org/docs/JSONCompilationDatabase.html

    This command helps you use clangd with Pigweed projects, which use multiple
    toolchains within a distinct environment, and often define multiple targets.
    This means compilation units are likely have multiple compile commands, and
    clangd is not equipped to deal with this out of the box. We handle this by:

    - Processing the compilation database produced the build system into
      multiple internally-consistent compilation databases, one for each target
      (where a "target" is a particular build for a particular system using a
      particular toolchain).

    - Providing commands to select which target you want to use for code
      analysis.

    Refer to the Pigweed documentation or your build system's documentation to
    learn how to produce a clangd compilation database. Once you have one, run
    this command to process it (or provide a glob to process multiple):

    .. code-block:: bash

        pw ide cpp --process {path to compile_commands.json}

    If you're using GN to generate the compilation database, you can do that and
    process it in a single command:

    .. code-block:: bash

       pw ide cpp --gn

    You can do the same for a Ninja build (whether it was generated by GN or
    another way):

    .. code-block:: bash

       pw ide cpp --ninja

    You can now examine the targets that are available to you:

    .. code-block:: bash

        pw ide cpp --list

    ... and select the target you want to use:

    .. code-block:: bash

        pw ide cpp --set host_clang

    As long as your editor or language server plugin is properly configured, you
    will now get code intelligence features relevant to that particular target.

    You can see what target is selected by running:

    .. code-block:: bash

        pw ide cpp

    Whenever you switch to a target you haven't used before, clangd will need to
    index the build, which may take several minutes. These indexes are cached,
    so you can switch between targets without re-indexing each time.

    If your build configuration changes significantly (e.g. you add a new file
    to the project), you will need to re-process the compilation database for
    that change to be recognized. Your target selection will not change, and
    your index will only need to be incrementally updated.

    You can generate the clangd command your editor needs to run with:

    .. code-block:: bash

        pw ide cpp --clangd-command

    If your editor uses JSON for configuration, you can export the same command
    in that format:

    .. code-block:: bash

        pw ide cpp --clangd-command-for json
    """
    _make_working_dir(reporter, pw_ide_settings, quiet=True)

    # If true, no arguments were provided so we do the default behavior.
    default = True

    state = CppIdeFeaturesState(pw_ide_settings)
    should_update_ides = False

    build_dir = (
        build_dir if build_dir is not None else pw_ide_settings.build_dir
    )

    if process:
        default = False
        should_update_ides = _process_compdbs(reporter, pw_ide_settings)

    if state.current_target is None:
        use_default_target = True

    if use_default_target:
        defined_default = pw_ide_settings.default_target

        if defined_default is None and state.max_commands_target is None:
            reporter.err('Can\'t use default target because none is defined!')
            reporter.wrn('Have you processed a compilation database yet?')
            sys.exit(1)
        else:
            max_commands_target = cast(
                CppIdeFeaturesTarget, state.max_commands_target
            )

        default_target = (
            defined_default
            if defined_default is not None
            else max_commands_target.name
        )

        if state.current_target != default:
            target_to_set = default_target

    if target_to_set is not None:
        default = False

        try:
            CppIdeFeaturesState(pw_ide_settings).current_target = state.targets[
                target_to_set
            ]
            should_update_ides = True
        except InvalidTargetException:
            reporter.err(
                [
                    f'Invalid target! {target_to_set} not among the '
                    'defined targets.',
                    'Check .pw_ide.yaml or .pw_ide.user.yaml for defined '
                    'targets.',
                ]
            )
            sys.exit(1)
        except MissingCompDbException:
            reporter.err(
                [
                    f'File not found for target! {target_to_set}',
                    'Did you run pw ide cpp --process '
                    '{path to compile_commands.json}?',
                ]
            )
            sys.exit(1)

        reporter.new(
            'Set C/C++ language server analysis target to: ' f'{target_to_set}'
        )

    if should_update_ides:
        if pw_ide_settings.editor_enabled('vscode'):
            cmd_vscode()

    if clangd_command:
        default = False
        reporter.info(
            [
                'Command to run clangd with Pigweed paths:',
                ClangdSettings(pw_ide_settings).command(),
            ]
        )

    if clangd_command_system is not None:
        default = False
        reporter.info(
            [
                'Command to run clangd with Pigweed paths for '
                f'{clangd_command_system}:',
                ClangdSettings(pw_ide_settings).command(clangd_command_system),
            ]
        )

    if should_list_targets:
        default = False
        targets_list_status = [
            'C/C++ targets available for language server analysis:'
        ]

        for target in sorted(CppIdeFeaturesState(pw_ide_settings).targets):
            targets_list_status.append(f'\t{target}')

        reporter.info(targets_list_status)

    if should_get_target or default:
        current_target = CppIdeFeaturesState(pw_ide_settings).current_target
        name = 'None' if current_target is None else current_target.name

        reporter.info(f'Current C/C++ language server analysis target: {name}')


def cmd_python(
    should_print_venv: bool, reporter: StatusReporter = StatusReporter()
) -> None:
    """Configure Python code intelligence support.

    You can generate the path to the Python virtual environment interpreter that
    your editor/language server should use with:

    .. code-block:: bash

       pw ide python --venv
    """
    # If true, no arguments were provided and we should do the default
    # behavior.
    default = True

    if should_print_venv or default:
        reporter.info(
            [
                'Location of the Pigweed Python virtual environment:',
                PythonPaths().interpreter,
            ]
        )
