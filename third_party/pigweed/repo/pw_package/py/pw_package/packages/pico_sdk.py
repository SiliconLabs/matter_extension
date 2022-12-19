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
"""Install and check status of the Raspberry Pi Pico SDK."""

import pathlib
from typing import Sequence

import pw_package.git_repo
import pw_package.package_manager


class PiPicoSdk(pw_package.git_repo.GitRepo):
    """Install and check status of the Raspberry Pi Pico SDK."""
    def __init__(self, *args, **kwargs):
        super().__init__(*args,
                         name='pico_sdk',
                         url='https://github.com/raspberrypi/pico-sdk',
                         commit='2062372d203b372849d573f252cf7c6dc2800c0a',
                         **kwargs)

    def info(self, path: pathlib.Path) -> Sequence[str]:
        return (
            f'{self.name} installed in: {path}',
            "Enable by running 'gn args out' and adding this line:",
            f'  PICO_SRC_DIR = "{path}"',
        )


pw_package.package_manager.register(PiPicoSdk)
