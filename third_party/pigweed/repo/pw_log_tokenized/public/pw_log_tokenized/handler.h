// Copyright 2023 The Pigweed Authors
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not
// use this file except in compliance with the License. You may obtain a copy of
// the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations under
// the License.
#pragma once

#include <stddef.h>
#include <stdint.h>

#include "pw_preprocessor/util.h"

PW_EXTERN_C_START

/// Function that is called for each log message. The metadata `uint32_t` can be
/// converted to a @cpp_type{pw::log_tokenized::Metadata}. The message is passed
/// as a pointer to a buffer and a size. The pointer is invalidated after this
/// function returns, so the buffer must be copied.
void pw_log_tokenized_HandleLog(uint32_t metadata,
                                const uint8_t encoded_message[],
                                size_t size_bytes);

PW_EXTERN_C_END
