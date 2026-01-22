#!/usr/bin/env bash

#
# Copyright (c) 2020 Project CHIP Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
set -x

branch_name=$(git branch | grep "^*" | awk '{print $2}')

# Check if origin points to the main repo
origin_url=$(git remote get-url origin 2>/dev/null || echo "")
if [[ "$origin_url" == "https://github.com/SiliconLabsSoftware/matter_sdk.git" ]]; then
    # Main repo setup - fetch restyled branch from origin
    git fetch origin restyled/"$branch_name"
    git merge --ff-only FETCH_HEAD
else
    # Fork setup - ensure upstream remote exists and use it
    if ! git remote | grep -qxF upstream; then
        git remote add upstream https://github.com/SiliconLabsSoftware/matter_sdk.git
    fi
    git fetch upstream restyled/"$branch_name"
    git merge --ff-only FETCH_HEAD
fi

git push
