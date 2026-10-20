#
# Copyright (c) 2026 Project CHIP Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if(NOT DEFINED APP_TASK_IMPL_HEADER OR APP_TASK_IMPL_HEADER STREQUAL "")
    set(APP_TASK_IMPL_HEADER "SilabsAppTask.h")
endif()


target_sources(app PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/SilabsAppTask.h
    ${CMAKE_CURRENT_LIST_DIR}/SilabsAppTask.cpp
)
target_include_directories(app PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}
)

if(CONFIG_CHIP_FACTORY_DATA)
    target_sources(app PRIVATE
        ${CHIP_ROOT}/examples/platform/silabs/provision/ProvisionStorageReaderCommon.cpp
        ${CHIP_ROOT}/examples/platform/silabs/provision/zephyr/ProvisionStorageReader.cpp
    )
    target_include_directories(app PRIVATE
        ${CHIP_ROOT}/examples/platform/silabs
        ${CHIP_ROOT}/third_party/silabs/matter_support/provision
    )
    target_compile_definitions(app PRIVATE
        SL_PROVISION_GENERATOR=0
    )
endif()
