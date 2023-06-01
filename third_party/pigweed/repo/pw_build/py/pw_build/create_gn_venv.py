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
"""Crate a venv."""

import argparse
import os
import pathlib
import shutil
import sys
import venv


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        '--depfile',
        type=pathlib.Path,
        required=True,
        help='Path at which a depfile should be written.',
    )
    parser.add_argument(
        '--destination-dir',
        type=pathlib.Path,
        required=True,
        help='Path to venv directory.',
    )
    parser.add_argument(
        '--stampfile',
        type=pathlib.Path,
        required=True,
        help="Path to this target's stamp file.",
    )
    return parser.parse_args()


def main(
    depfile: pathlib.Path,
    destination_dir: pathlib.Path,
    stampfile: pathlib.Path,
) -> None:
    # Create the virtualenv.
    if destination_dir.exists():
        shutil.rmtree(destination_dir)
    venv.create(destination_dir, symlinks=True, with_pip=True)

    # Write out the depfile, making sure the Python path is
    # relative to the outdir so that this doesn't add user-specific
    # info to the build.
    out_dir_path = pathlib.Path(os.getcwd()).resolve()
    python_path = pathlib.Path(sys.executable).resolve()
    rel_python_path = os.path.relpath(python_path, start=out_dir_path)
    depfile.write_text(f'{stampfile}: \\\n  {rel_python_path}')


if __name__ == '__main__':
    main(**vars(_parse_args()))
