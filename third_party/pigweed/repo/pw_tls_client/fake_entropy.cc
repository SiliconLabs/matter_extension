// Copyright 2021 The Pigweed Authors
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

#include "pw_log/log.h"
#include "pw_tls_client/entropy.h"

namespace pw::tls_client {

Status GetRandomBytes(ByteSpan) {
  PW_LOG_INFO(
      "Warning. The TLS client is using a fake enropy source that does "
      "nothing. This should only be used for demo and test purpose."
      "Production code shall not use it");
  return OkStatus();
}

}  // namespace pw::tls_client
