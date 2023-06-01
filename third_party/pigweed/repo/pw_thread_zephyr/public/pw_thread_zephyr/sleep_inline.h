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

#include <zephyr/kernel.h>
#include <zephyr/sys/util.h>

#include "pw_chrono/system_clock.h"
#include "pw_thread/sleep.h"

namespace pw::this_thread {

inline void sleep_for(chrono::SystemClock::duration sleep_duration) {
  sleep_until(chrono::SystemClock::TimePointAfterAtLeast(sleep_duration));
}

}  // namespace pw::this_thread
