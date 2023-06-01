# Copyright 2020 The Pigweed Authors
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
"""Functions for building code during presubmit checks."""

import contextlib
import itertools
import json
import logging
import os
from pathlib import Path
import re
import subprocess
from shutil import which
import sys
from typing import (
    Any,
    Callable,
    Collection,
    Container,
    ContextManager,
    Dict,
    Iterable,
    Iterator,
    List,
    Mapping,
    Optional,
    Sequence,
    Set,
    Tuple,
    Union,
)

from pw_presubmit.presubmit import (
    call,
    Check,
    FileFilter,
    filter_paths,
    install_package,
    PresubmitContext,
    PresubmitFailure,
    PresubmitResult,
    SubStep,
)
from pw_presubmit import (
    bazel_parser,
    format_code,
    ninja_parser,
)
from pw_presubmit.tools import (
    plural,
    log_run,
    format_command,
)

_LOG = logging.getLogger(__name__)


def bazel(ctx: PresubmitContext, cmd: str, *args: str) -> None:
    """Invokes Bazel with some common flags set.

    Intended for use with bazel build and test. May not work with others.
    """

    num_jobs: List[str] = []
    if ctx.num_jobs is not None:
        num_jobs.extend(('--jobs', str(ctx.num_jobs)))

    keep_going: List[str] = []
    if ctx.continue_after_build_error:
        keep_going.append('--keep_going')

    bazel_stdout = ctx.output_dir / 'bazel.stdout'
    try:
        with bazel_stdout.open('w') as outs:
            call(
                'bazel',
                cmd,
                '--verbose_failures',
                '--verbose_explanations',
                '--worker_verbose',
                f'--symlink_prefix={ctx.output_dir / ".bazel-"}',
                *num_jobs,
                *keep_going,
                *args,
                cwd=ctx.root,
                env=env_with_clang_vars(),
                tee=outs,
            )

    except PresubmitFailure as exc:
        failure = bazel_parser.parse_bazel_stdout(bazel_stdout)
        if failure:
            with ctx.failure_summary_log.open('w') as outs:
                outs.write(failure)

        raise exc


def _gn_value(value) -> str:
    if isinstance(value, bool):
        return str(value).lower()

    if (
        isinstance(value, str)
        and '"' not in value
        and not value.startswith("{")
        and not value.startswith("[")
    ):
        return f'"{value}"'

    if isinstance(value, (list, tuple)):
        return f'[{", ".join(_gn_value(a) for a in value)}]'

    # Fall-back case handles integers as well as strings that already
    # contain double quotation marks, or look like scopes or lists.
    return str(value)


def gn_args(**kwargs) -> str:
    """Builds a string to use for the --args argument to gn gen.

    Currently supports bool, int, and str values. In the case of str values,
    quotation marks will be added automatically, unless the string already
    contains one or more double quotation marks, or starts with a { or [
    character, in which case it will be passed through as-is.
    """
    transformed_args = []
    for arg, val in kwargs.items():
        transformed_args.append(f'{arg}={_gn_value(val)}')

    # Use ccache if available for faster repeat presubmit runs.
    if which('ccache'):
        transformed_args.append('pw_command_launcher="ccache"')

    return '--args=' + ' '.join(transformed_args)


def gn_gen(
    ctx: PresubmitContext,
    *args: str,
    gn_check: bool = True,  # pylint: disable=redefined-outer-name
    gn_fail_on_unused: bool = True,
    export_compile_commands: Union[bool, str] = True,
    preserve_args_gn: bool = False,
    **gn_arguments,
) -> None:
    """Runs gn gen in the specified directory with optional GN args.

    Runs with --check=system if gn_check=True. Note that this does not cover
    generated files. Run gn_check() after building to check generated files.
    """
    all_gn_args = dict(gn_arguments)
    all_gn_args.update(ctx.override_gn_args)
    _LOG.debug('%r', all_gn_args)
    args_option = gn_args(**all_gn_args)

    if not preserve_args_gn:
        # Delete args.gn to ensure this is a clean build.
        args_gn = ctx.output_dir / 'args.gn'
        if args_gn.is_file():
            args_gn.unlink()

    export_commands_arg = ''
    if export_compile_commands:
        export_commands_arg = '--export-compile-commands'
        if isinstance(export_compile_commands, str):
            export_commands_arg += f'={export_compile_commands}'

    call(
        'gn',
        'gen',
        ctx.output_dir,
        '--color=always',
        *(['--check=system'] if gn_check else []),
        *(['--fail-on-unused-args'] if gn_fail_on_unused else []),
        *([export_commands_arg] if export_commands_arg else []),
        *args,
        *([args_option] if all_gn_args else []),
        cwd=ctx.root,
    )


def gn_check(ctx: PresubmitContext) -> PresubmitResult:
    """Runs gn check, including on generated and system files."""
    call(
        'gn',
        'check',
        ctx.output_dir,
        '--check-generated',
        '--check-system',
        cwd=ctx.root,
    )
    return PresubmitResult.PASS


def ninja(
    ctx: PresubmitContext, *args, save_compdb=True, save_graph=True, **kwargs
) -> None:
    """Runs ninja in the specified directory."""

    num_jobs: List[str] = []
    if ctx.num_jobs is not None:
        num_jobs.extend(('-j', str(ctx.num_jobs)))

    keep_going: List[str] = []
    if ctx.continue_after_build_error:
        keep_going.extend(('-k', '0'))

    if save_compdb:
        proc = subprocess.run(
            ['ninja', '-C', ctx.output_dir, '-t', 'compdb', *args],
            capture_output=True,
            **kwargs,
        )
        (ctx.output_dir / 'ninja.compdb').write_bytes(proc.stdout)

    if save_graph:
        proc = subprocess.run(
            ['ninja', '-C', ctx.output_dir, '-t', 'graph', *args],
            capture_output=True,
            **kwargs,
        )
        (ctx.output_dir / 'ninja.graph').write_bytes(proc.stdout)

    ninja_stdout = ctx.output_dir / 'ninja.stdout'
    try:
        with ninja_stdout.open('w') as outs:
            if sys.platform == 'win32':
                # Windows doesn't support pw-wrap-ninja.
                ninja_command = ['ninja']
            else:
                ninja_command = ['pw-wrap-ninja', '--log-actions']

            call(
                *ninja_command,
                '-C',
                ctx.output_dir,
                *num_jobs,
                *keep_going,
                *args,
                tee=outs,
                propagate_sigterm=True,
                **kwargs,
            )

    except PresubmitFailure as exc:
        failure = ninja_parser.parse_ninja_stdout(ninja_stdout)
        if failure:
            with ctx.failure_summary_log.open('w') as outs:
                outs.write(failure)

        raise exc


def get_gn_args(directory: Path) -> List[Dict[str, Dict[str, str]]]:
    """Dumps GN variables to JSON."""
    proc = subprocess.run(
        ['gn', 'args', directory, '--list', '--json'], stdout=subprocess.PIPE
    )
    return json.loads(proc.stdout)


def cmake(
    ctx: PresubmitContext,
    *args: str,
    env: Optional[Mapping['str', 'str']] = None,
) -> None:
    """Runs CMake for Ninja on the given source and output directories."""
    call(
        'cmake',
        '-B',
        ctx.output_dir,
        '-S',
        ctx.root,
        '-G',
        'Ninja',
        *args,
        env=env,
    )


def env_with_clang_vars() -> Mapping[str, str]:
    """Returns the environment variables with CC, CXX, etc. set for clang."""
    env = os.environ.copy()
    env['CC'] = env['LD'] = env['AS'] = 'clang'
    env['CXX'] = 'clang++'
    return env


def _get_paths_from_command(source_dir: Path, *args, **kwargs) -> Set[Path]:
    """Runs a command and reads Bazel or GN //-style paths from it."""
    process = log_run(args, capture_output=True, cwd=source_dir, **kwargs)

    if process.returncode:
        _LOG.error(
            'Build invocation failed with return code %d!', process.returncode
        )
        _LOG.error(
            '[COMMAND] %s\n%s\n%s',
            *format_command(args, kwargs),
            process.stderr.decode(),
        )
        raise PresubmitFailure

    files = set()

    for line in process.stdout.splitlines():
        path = line.strip().lstrip(b'/').replace(b':', b'/').decode()
        path = source_dir.joinpath(path)
        if path.is_file():
            files.add(path)

    return files


# Finds string literals with '.' in them.
_MAYBE_A_PATH = re.compile(
    r'"'  # Starting double quote.
    # Start capture group 1 - the whole filename:
    #   File basename, a single period, file extension.
    r'([^\n" ]+\.[^\n" ]+)'
    # Non-capturing group 2 (optional).
    r'(?: > [^\n"]+)?'  # pw_zip style string "input_file.txt > output_file.txt"
    r'"'  # Ending double quote.
)


def _search_files_for_paths(build_files: Iterable[Path]) -> Iterable[Path]:
    for build_file in build_files:
        directory = build_file.parent

        for string in _MAYBE_A_PATH.finditer(build_file.read_text()):
            path = directory / string.group(1)
            if path.is_file():
                yield path


def _read_compile_commands(compile_commands: Path) -> dict:
    with compile_commands.open('rb') as fd:
        return json.load(fd)


def compiled_files(compile_commands: Path) -> Iterable[Path]:
    for command in _read_compile_commands(compile_commands):
        file = Path(command['file'])
        if file.is_absolute():
            yield file
        else:
            yield file.joinpath(command['directory']).resolve()


def check_compile_commands_for_files(
    compile_commands: Union[Path, Iterable[Path]],
    files: Iterable[Path],
    extensions: Collection[str] = format_code.CPP_SOURCE_EXTS,
) -> List[Path]:
    """Checks for paths in one or more compile_commands.json files.

    Only checks C and C++ source files by default.
    """
    if isinstance(compile_commands, Path):
        compile_commands = [compile_commands]

    compiled = frozenset(
        itertools.chain.from_iterable(
            compiled_files(cmds) for cmds in compile_commands
        )
    )
    return [f for f in files if f not in compiled and f.suffix in extensions]


def check_bazel_build_for_files(
    bazel_extensions_to_check: Container[str],
    files: Iterable[Path],
    bazel_dirs: Iterable[Path] = (),
) -> List[Path]:
    """Checks that source files are in the Bazel builds.

    Args:
        bazel_extensions_to_check: which file suffixes to look for in Bazel
        files: the files that should be checked
        bazel_dirs: directories in which to run bazel query

    Returns:
        a list of missing files; will be empty if there were no missing files
    """

    # Collect all paths in the Bazel builds.
    bazel_builds: Set[Path] = set()
    for directory in bazel_dirs:
        bazel_builds.update(
            _get_paths_from_command(
                directory, 'bazel', 'query', 'kind("source file", //...:*)'
            )
        )

    missing: List[Path] = []

    if bazel_dirs:
        for path in (p for p in files if p.suffix in bazel_extensions_to_check):
            if path not in bazel_builds:
                # TODO(b/234883555) Replace this workaround for fuzzers.
                if 'fuzz' not in str(path):
                    missing.append(path)

    if missing:
        _LOG.warning(
            '%s missing from the Bazel build:\n%s',
            plural(missing, 'file', are=True),
            '\n'.join(str(x) for x in missing),
        )

    return missing


def check_gn_build_for_files(
    gn_extensions_to_check: Container[str],
    files: Iterable[Path],
    gn_dirs: Iterable[Tuple[Path, Path]] = (),
    gn_build_files: Iterable[Path] = (),
) -> List[Path]:
    """Checks that source files are in the GN build.

    Args:
        gn_extensions_to_check: which file suffixes to look for in GN
        files: the files that should be checked
        gn_dirs: (source_dir, output_dir) tuples with which to run gn desc
        gn_build_files: paths to BUILD.gn files to directly search for paths

    Returns:
        a list of missing files; will be empty if there were no missing files
    """

    # Collect all paths in GN builds.
    gn_builds: Set[Path] = set()

    for source_dir, output_dir in gn_dirs:
        gn_builds.update(
            _get_paths_from_command(source_dir, 'gn', 'desc', output_dir, '*')
        )

    gn_builds.update(_search_files_for_paths(gn_build_files))

    missing: List[Path] = []

    if gn_dirs or gn_build_files:
        for path in (p for p in files if p.suffix in gn_extensions_to_check):
            if path not in gn_builds:
                missing.append(path)

    if missing:
        _LOG.warning(
            '%s missing from the GN build:\n%s',
            plural(missing, 'file', are=True),
            '\n'.join(str(x) for x in missing),
        )

    return missing


def check_builds_for_files(
    bazel_extensions_to_check: Container[str],
    gn_extensions_to_check: Container[str],
    files: Iterable[Path],
    bazel_dirs: Iterable[Path] = (),
    gn_dirs: Iterable[Tuple[Path, Path]] = (),
    gn_build_files: Iterable[Path] = (),
) -> Dict[str, List[Path]]:
    """Checks that source files are in the GN and Bazel builds.

    Args:
        bazel_extensions_to_check: which file suffixes to look for in Bazel
        gn_extensions_to_check: which file suffixes to look for in GN
        files: the files that should be checked
        bazel_dirs: directories in which to run bazel query
        gn_dirs: (source_dir, output_dir) tuples with which to run gn desc
        gn_build_files: paths to BUILD.gn files to directly search for paths

    Returns:
        a dictionary mapping build system ('Bazel' or 'GN' to a list of missing
        files; will be empty if there were no missing files
    """

    bazel_missing = check_bazel_build_for_files(
        bazel_extensions_to_check=bazel_extensions_to_check,
        files=files,
        bazel_dirs=bazel_dirs,
    )
    gn_missing = check_gn_build_for_files(
        gn_extensions_to_check=gn_extensions_to_check,
        files=files,
        gn_dirs=gn_dirs,
        gn_build_files=gn_build_files,
    )

    result = {}
    if bazel_missing:
        result['Bazel'] = bazel_missing
    if gn_missing:
        result['GN'] = gn_missing
    return result


@contextlib.contextmanager
def test_server(executable: str, output_dir: Path):
    """Context manager that runs a test server executable.

    Args:
        executable: name of the test server executable
        output_dir: path to the output directory (for logs)
    """

    with open(output_dir / 'test_server.log', 'w') as outs:
        try:
            proc = subprocess.Popen(
                [executable, '--verbose'],
                stdout=outs,
                stderr=subprocess.STDOUT,
            )

            yield

        finally:
            proc.terminate()  # pylint: disable=used-before-assignment


@filter_paths(
    file_filter=FileFilter(endswith=('.bzl', '.bazel'), name=('WORKSPACE',))
)
def bazel_lint(ctx: PresubmitContext):
    """Runs buildifier with lint on Bazel files.

    Should be run after bazel_format since that will give more useful output
    for formatting-only issues.
    """

    failure = False
    for path in ctx.paths:
        try:
            call('buildifier', '--lint=warn', '--mode=check', path)
        except PresubmitFailure:
            failure = True

    if failure:
        raise PresubmitFailure


@Check
def gn_gen_check(ctx: PresubmitContext):
    """Runs gn gen --check to enforce correct header dependencies."""
    gn_gen(ctx, gn_check=True)


_CtxMgrLambda = Callable[[PresubmitContext], ContextManager]
_CtxMgrOrLambda = Union[ContextManager, _CtxMgrLambda]


class GnGenNinja(Check):
    """Thin wrapper of Check for steps that just call gn/ninja.

    Runs gn gen, ninja, then gn check.
    """

    def __init__(
        self,
        *args,
        packages: Sequence[str] = (),
        gn_args: Optional[  # pylint: disable=redefined-outer-name
            Dict[str, Any]
        ] = None,
        ninja_contexts: Sequence[_CtxMgrOrLambda] = (),
        ninja_targets: Union[str, Sequence[str], Sequence[Sequence[str]]] = (),
        **kwargs,
    ):
        """Initializes a GnGenNinja object.

        Args:
            *args: Passed on to superclass.
            packages: List of 'pw package' packages to install.
            gn_args: Dict of GN args.
            ninja_contexts: List of context managers to apply around ninja
                calls.
            ninja_targets: Single ninja target, list of Ninja targets, or list
                of list of ninja targets. If a list of a list, ninja will be
                called multiple times with the same build directory.
            **kwargs: Passed on to superclass.
        """
        super().__init__(self._substeps(), *args, **kwargs)
        self.packages: Sequence[str] = packages
        self.gn_args: Dict[str, Any] = gn_args or {}
        self.ninja_contexts: Tuple[_CtxMgrOrLambda, ...] = tuple(ninja_contexts)

        if isinstance(ninja_targets, str):
            ninja_targets = (ninja_targets,)
        ninja_targets = list(ninja_targets)
        all_strings = all(isinstance(x, str) for x in ninja_targets)
        any_strings = any(isinstance(x, str) for x in ninja_targets)
        if ninja_targets and all_strings != any_strings:
            raise ValueError(repr(ninja_targets))

        self.ninja_target_lists: Tuple[Tuple[str, ...], ...]
        if all_strings:
            targets: List[str] = []
            for target in ninja_targets:
                targets.append(target)  # type: ignore
            self.ninja_target_lists = (tuple(targets),)
        else:
            self.ninja_target_lists = tuple(tuple(x) for x in ninja_targets)

    def _install_package(  # pylint: disable=no-self-use
        self,
        ctx: PresubmitContext,
        package: str,
    ) -> PresubmitResult:
        install_package(ctx, package)
        return PresubmitResult.PASS

    def _gn_gen(self, ctx: PresubmitContext) -> PresubmitResult:
        Item = Union[int, str]
        Value = Union[Item, Sequence[Item]]
        ValueCallable = Callable[[PresubmitContext], Value]
        InputItem = Union[Item, ValueCallable]
        InputValue = Union[InputItem, Sequence[InputItem]]

        # TODO(mohrr) Use typing.TypeGuard instead of "type: ignore"

        def value(val: InputValue) -> Value:
            if isinstance(val, (str, int)):
                return val
            if callable(val):
                return val(ctx)

            result: List[Item] = []
            for item in val:
                if callable(item):
                    call_result = item(ctx)
                    if isinstance(item, (int, str)):
                        result.append(call_result)
                    else:  # Sequence.
                        result.extend(call_result)  # type: ignore
                elif isinstance(item, (int, str)):
                    result.append(item)
                else:  # Sequence.
                    result.extend(item)
            return result

        args = {k: value(v) for k, v in self.gn_args.items()}
        gn_gen(ctx, gn_check=False, **args)  # type: ignore
        return PresubmitResult.PASS

    def _ninja(
        self, ctx: PresubmitContext, targets: Sequence[str]
    ) -> PresubmitResult:
        with contextlib.ExitStack() as stack:
            for mgr in self.ninja_contexts:
                if isinstance(mgr, contextlib.AbstractContextManager):
                    stack.enter_context(mgr)
                else:
                    stack.enter_context(mgr(ctx))  # type: ignore
            ninja(ctx, *targets)

        return PresubmitResult.PASS

    def _substeps(self) -> Iterator[SubStep]:
        for package in self.packages:
            yield SubStep(
                f'install {package} package',
                self._install_package,
                (package,),
            )

        yield SubStep('gn gen', self._gn_gen)

        targets_parts = set()
        for targets in self.ninja_target_lists:
            targets_part = " ".join(targets)
            maxlen = 70
            if len(targets_part) > maxlen:
                targets_part = f'{targets_part[0:maxlen-3]}...'
            assert targets_part not in targets_parts
            targets_parts.add(targets_part)
            yield SubStep(f'ninja {targets_part}', self._ninja, (targets,))

        # Run gn check after building so it can check generated files.
        yield SubStep('gn check', gn_check)
