// Copyright 2022 The Pigweed Authors
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

#include "pw_perf_test/perf_test.h"

#include "gtest/gtest.h"

void TestingFunction(pw::perf_test::State& state) {
  while (state.KeepRunning()) {
    // Intentionally empty.
  }
}

// This function is intentionally left blank
void SimpleFunction() {}

void SimpleFunctionWithArgs(int, bool) {}

namespace pw::perf_test {
namespace {

PW_PERF_TEST(TestingComponentRegistration, TestingFunction);

PW_PERF_TEST_SIMPLE(TestingSimpleRegistration, SimpleFunction);

PW_PERF_TEST_SIMPLE(TestingSimpleRegistrationArgs,
                    SimpleFunctionWithArgs,
                    123,
                    false);

}  // namespace
}  // namespace pw::perf_test
