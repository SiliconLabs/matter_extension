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
"""Keep specified lists sorted."""

import argparse
import dataclasses
import difflib
import logging
import os
from pathlib import Path
import re
import sys
from typing import (
    Callable,
    Collection,
    Dict,
    List,
    Optional,
    Pattern,
    Sequence,
    Tuple,
    Union,
)

import pw_cli
from . import cli, format_code, git_repo, presubmit, tools

DEFAULT_PATH = Path('out', 'presubmit', 'keep_sorted')

_COLOR = pw_cli.color.colors()
_LOG: logging.Logger = logging.getLogger(__name__)

# Ignore a whole section. Please do not change the order of these lines.
_START = re.compile(r'keep-sorted: (begin|start)', re.IGNORECASE)
_END = re.compile(r'keep-sorted: (stop|end)', re.IGNORECASE)
_IGNORE_CASE = re.compile(r'ignore-case', re.IGNORECASE)
_ALLOW_DUPES = re.compile(r'allow-dupes', re.IGNORECASE)
_IGNORE_PREFIX = re.compile(r'ignore-prefix=(\S+)', re.IGNORECASE)
_STICKY_COMMENTS = re.compile(r'sticky-comments=(\S+)', re.IGNORECASE)

# Only include these literals here so keep_sorted doesn't try to reorder later
# test lines.
(
    START,
    END,
) = """
keep-sorted: start
keep-sorted: end
""".strip().splitlines()


@dataclasses.dataclass
class KeepSortedContext:
    paths: List[Path]
    fix: bool
    output_dir: Path
    failure_summary_log: Path
    failed: bool = False

    def fail(
        self,
        description: str = '',
        path: Optional[Path] = None,
        line: Optional[int] = None,
    ) -> None:
        if not self.fix:
            self.failed = True

        line_part: str = ''
        if line is not None:
            line_part = f'{line}:'

        log = _LOG.error
        if self.fix:
            log = _LOG.warning

        if path:
            log('%s:%s %s', path, line_part, description)
        else:
            log('%s', description)


class KeepSortedParsingError(presubmit.PresubmitFailure):
    pass


@dataclasses.dataclass
class _Line:
    value: str = ''
    sticky_comments: Sequence[str] = ()
    continuations: Sequence[str] = ()

    @property
    def full(self):
        return ''.join((*self.sticky_comments, self.value, *self.continuations))

    def __lt__(self, other):
        if not isinstance(other, _Line):
            return NotImplemented
        left = (self.value, self.continuations, self.sticky_comments)
        right = (other.value, other.continuations, other.sticky_comments)
        return left < right


@dataclasses.dataclass
class _Block:
    ignore_case: bool = False
    allow_dupes: bool = False
    ignored_prefixes: Sequence[str] = dataclasses.field(default_factory=list)
    sticky_comments: Tuple[str, ...] = ()
    start_line_number: int = -1
    start_line: str = ''
    end_line: str = ''
    lines: List[str] = dataclasses.field(default_factory=list)


class _FileSorter:
    def __init__(
        self,
        ctx: Union[presubmit.PresubmitContext, KeepSortedContext],
        path: Path,
        errors: Optional[Dict[Path, Sequence[str]]] = None,
    ):
        self.ctx = ctx
        self.path: Path = path
        self.all_lines: List[str] = []
        self.changed: bool = False
        self._errors: Dict[Path, Sequence[str]] = {}
        if errors is not None:
            self._errors = errors

    def _process_block(self, block: _Block) -> Sequence[str]:
        raw_lines: List[str] = block.lines
        lines: List[_Line] = []

        prefix = lambda x: len(x) - len(x.lstrip())

        prev_prefix: Optional[int] = None
        comments: List[str] = []
        for raw_line in raw_lines:
            curr_prefix: int = prefix(raw_line)
            _LOG.debug('prev_prefix %r', prev_prefix)
            _LOG.debug('curr_prefix %r', curr_prefix)
            # A "sticky" comment is a comment in the middle of a list of
            # non-comments. The keep-sorted check keeps this comment with the
            # following item in the list. For more details see
            # https://pigweed.dev/pw_presubmit/#sorted-blocks.
            if block.sticky_comments and raw_line.lstrip().startswith(
                block.sticky_comments
            ):
                _LOG.debug('found sticky %r', raw_line)
                comments.append(raw_line)
            elif prev_prefix is not None and curr_prefix > prev_prefix:
                _LOG.debug('found continuation %r', raw_line)
                lines[-1].continuations = (*lines[-1].continuations, raw_line)
                _LOG.debug('modified line %s', lines[-1])
            else:
                _LOG.debug('non-sticky %r', raw_line)
                line = _Line(raw_line, tuple(comments))
                _LOG.debug('line %s', line)
                lines.append(line)
                comments = []
                prev_prefix = curr_prefix
        if comments:
            self.ctx.fail(
                f'sticky comment at end of block: {comments[0].strip()}',
                self.path,
                block.start_line_number,
            )

        if not block.allow_dupes:
            lines = list({x.full: x for x in lines}.values())

        StrLinePair = Tuple[str, _Line]
        sort_key_funcs: List[Callable[[StrLinePair], StrLinePair]] = []

        if block.ignored_prefixes:

            def strip_ignored_prefixes(val):
                """Remove one ignored prefix from val, if present."""
                wo_white = val[0].lstrip()
                white = val[0][0 : -len(wo_white)]
                for prefix in block.ignored_prefixes:
                    if wo_white.startswith(prefix):
                        return (f'{white}{wo_white[len(prefix):]}', val[1])
                return (val[0], val[1])

            sort_key_funcs.append(strip_ignored_prefixes)

        if block.ignore_case:
            sort_key_funcs.append(lambda val: (val[0].lower(), val[1]))

        def sort_key(line):
            vals = (line.value, line)
            for sort_key_func in sort_key_funcs:
                vals = sort_key_func(vals)
            return vals

        for val in lines:
            _LOG.debug('For sorting: %r => %r', val, sort_key(val))

        sorted_lines = sorted(lines, key=sort_key)
        raw_sorted_lines: List[str] = []
        for line in sorted_lines:
            raw_sorted_lines.extend(line.sticky_comments)
            raw_sorted_lines.append(line.value)
            raw_sorted_lines.extend(line.continuations)

        if block.lines != raw_sorted_lines:
            self.changed = True
            diff = difflib.Differ()
            diff_lines = ''.join(diff.compare(block.lines, raw_sorted_lines))

            self._errors.setdefault(self.path, [])
            self._errors[self.path] = (
                f'@@ {block.start_line_number},{len(block.lines)+2} '
                f'{block.start_line_number},{len(raw_sorted_lines)+2} @@\n'
                f'  {block.start_line}{diff_lines}  {block.end_line}'
            )

        return raw_sorted_lines

    def _parse_file(self, ins):
        block: Optional[_Block] = None

        for i, line in enumerate(ins, start=1):
            if block:
                if _START.search(line):
                    raise KeepSortedParsingError(
                        f'found {line.strip()!r} inside keep-sorted block',
                        self.path,
                        i,
                    )

                if _END.search(line):
                    _LOG.debug('Found end line %d %r', i, line)
                    block.end_line = line
                    self.all_lines.extend(self._process_block(block))
                    block = None
                    self.all_lines.append(line)

                else:
                    _LOG.debug('Adding to block line %d %r', i, line)
                    block.lines.append(line)

            elif start_match := _START.search(line):
                _LOG.debug('Found start line %d %r', i, line)

                block = _Block()

                block.ignore_case = bool(_IGNORE_CASE.search(line))
                _LOG.debug('ignore_case: %s', block.ignore_case)

                block.allow_dupes = bool(_ALLOW_DUPES.search(line))
                _LOG.debug('allow_dupes: %s', block.allow_dupes)

                match = _IGNORE_PREFIX.search(line)
                if match:
                    block.ignored_prefixes = match.group(1).split(',')

                    # We want to check the longest prefixes first, in case one
                    # prefix is a prefix of another prefix.
                    block.ignored_prefixes.sort(key=lambda x: (-len(x), x))
                _LOG.debug('ignored_prefixes: %r', block.ignored_prefixes)

                match = _STICKY_COMMENTS.search(line)
                if match:
                    if match.group(1) == 'no':
                        block.sticky_comments = ()
                    else:
                        block.sticky_comments = tuple(match.group(1).split(','))
                else:
                    prefix = line[: start_match.start()].strip()
                    if prefix and len(prefix) <= 3:
                        block.sticky_comments = (prefix,)
                _LOG.debug('sticky_comments: %s', block.sticky_comments)

                block.start_line = line
                block.start_line_number = i
                self.all_lines.append(line)

                remaining = line[start_match.end() :].strip()
                remaining = _IGNORE_CASE.sub('', remaining, count=1).strip()
                remaining = _ALLOW_DUPES.sub('', remaining, count=1).strip()
                remaining = _IGNORE_PREFIX.sub('', remaining, count=1).strip()
                remaining = _STICKY_COMMENTS.sub('', remaining, count=1).strip()
                if remaining.strip():
                    raise KeepSortedParsingError(
                        f'unrecognized directive on keep-sorted line: '
                        f'{remaining}',
                        self.path,
                        i,
                    )

            elif _END.search(line):
                raise KeepSortedParsingError(
                    f'found {line.strip()!r} outside keep-sorted block',
                    self.path,
                    i,
                )

            else:
                self.all_lines.append(line)

        if block:
            raise KeepSortedParsingError(
                f'found EOF while looking for "{END}"', self.path
            )

    def sort(self) -> None:
        """Check for unsorted keep-sorted blocks."""
        _LOG.debug('Evaluating path %s', self.path)
        try:
            with self.path.open() as ins:
                _LOG.debug('Processing %s', self.path)
                self._parse_file(ins)

        except UnicodeDecodeError:
            # File is not text, like a gif.
            _LOG.debug('File %s is not a text file', self.path)

    def write(self, path: Optional[Path] = None) -> None:
        if not self.changed:
            return
        if not path:
            path = self.path
        with path.open('w') as outs:
            outs.writelines(self.all_lines)
            _LOG.info('Applied keep-sorted changes to %s', path)


def _print_howto_fix(paths: Sequence[Path]) -> None:
    def path_relative_to_cwd(path):
        try:
            return Path(path).resolve().relative_to(Path.cwd().resolve())
        except ValueError:
            return Path(path).resolve()

    message = (
        f'  pw keep-sorted --fix {path_relative_to_cwd(path)}' for path in paths
    )
    _LOG.warning('To sort these blocks, run:\n\n%s\n', '\n'.join(message))


def _process_files(
    ctx: Union[presubmit.PresubmitContext, KeepSortedContext]
) -> Dict[Path, Sequence[str]]:
    fix = getattr(ctx, 'fix', False)
    errors: Dict[Path, Sequence[str]] = {}

    for path in ctx.paths:
        if path.is_symlink() or path.is_dir():
            continue

        try:
            sorter = _FileSorter(ctx, path, errors)

            sorter.sort()
            if sorter.changed:
                if fix:
                    sorter.write()

        except KeepSortedParsingError as exc:
            ctx.fail(str(exc))

    if not errors:
        return errors

    ctx.fail(f'Found {tools.plural(errors, "file")} with keep-sorted errors:')

    with ctx.failure_summary_log.open('w') as outs:
        for path, diffs in errors.items():
            diff = ''.join(
                [
                    f'--- {path} (original)\n',
                    f'+++ {path} (sorted)\n',
                    *diffs,
                ]
            )

            outs.write(diff)
            print(format_code.colorize_diff(diff))

    return errors


@presubmit.check(name='keep_sorted')
def presubmit_check(ctx: presubmit.PresubmitContext) -> None:
    """Presubmit check that ensures specified lists remain sorted."""

    errors = _process_files(ctx)

    if errors:
        _print_howto_fix(list(errors.keys()))


def parse_args() -> argparse.Namespace:
    """Creates an argument parser and parses arguments."""

    parser = argparse.ArgumentParser(description=__doc__)
    cli.add_path_arguments(parser)
    parser.add_argument(
        '--fix', action='store_true', help='Apply fixes in place.'
    )

    parser.add_argument(
        '--output-directory',
        type=Path,
        help=f'Output directory (default: {"<repo root>" / DEFAULT_PATH})',
    )

    return parser.parse_args()


def keep_sorted_in_repo(
    paths: Collection[Union[Path, str]],
    fix: bool,
    exclude: Collection[Pattern[str]],
    base: str,
    output_directory: Optional[Path],
) -> int:
    """Checks or fixes keep-sorted blocks for files in a Git repo."""

    files = [Path(path).resolve() for path in paths if os.path.isfile(path)]
    repo = git_repo.root() if git_repo.is_repo() else None

    # Implement a graceful fallback in case the tracking branch isn't available.
    if base == git_repo.TRACKING_BRANCH_ALIAS and not git_repo.tracking_branch(
        repo
    ):
        _LOG.warning(
            'Failed to determine the tracking branch, using --base HEAD~1 '
            'instead of listing all files'
        )
        base = 'HEAD~1'

    # If this is a Git repo, list the original paths with git ls-files or diff.
    project_root = pw_cli.env.pigweed_environment().PW_PROJECT_ROOT
    if repo:
        _LOG.info(
            'Sorting %s',
            git_repo.describe_files(
                repo, Path.cwd(), base, paths, exclude, project_root
            ),
        )

        # Add files from Git and remove duplicates.
        files = sorted(
            set(tools.exclude_paths(exclude, git_repo.list_files(base, paths)))
            | set(files)
        )
    elif base:
        _LOG.critical(
            'A base commit may only be provided if running from a Git repo'
        )
        return 1

    outdir: Path
    if output_directory:
        outdir = output_directory
    elif repo:
        outdir = repo / DEFAULT_PATH
    else:
        outdir = project_root / DEFAULT_PATH

    ctx = KeepSortedContext(
        paths=files,
        fix=fix,
        output_dir=outdir,
        failure_summary_log=outdir / 'failure-summary.log',
    )
    errors = _process_files(ctx)

    if not fix and errors:
        _print_howto_fix(list(errors.keys()))

    return int(ctx.failed)


def main() -> int:
    return keep_sorted_in_repo(**vars(parse_args()))


if __name__ == '__main__':
    pw_cli.log.install(logging.INFO)
    sys.exit(main())
