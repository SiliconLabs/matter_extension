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

#include "gtest/gtest.h"
#include "pw_rpc/pwpb/internal/common.h"
#include "pw_rpc_test_protos/test.pwpb.h"
#include "pw_span/span.h"
#include "pw_status/status_with_size.h"

namespace pw::rpc::internal {
namespace {

namespace TestRequest = ::pw::rpc::test::pwpb::TestRequest;

constexpr PwpbSerde kTestRequest(&TestRequest::kMessageFields);
constexpr TestRequest::Message kProto{.integer = 3, .status_code = 0};

TEST(PwpbSerde, Encode) {
  std::byte buffer[32] = {};

  StatusWithSize result = kTestRequest.Encode(kProto, buffer);
  EXPECT_EQ(OkStatus(), result.status());
  EXPECT_EQ(result.size(), 2u);
  EXPECT_EQ(buffer[0], std::byte{1} << 3);
  EXPECT_EQ(buffer[1], std::byte{3});
}

TEST(PwpbSerde, Encode_TooSmall) {
  std::byte buffer[1] = {};
  EXPECT_EQ(Status::ResourceExhausted(),
            kTestRequest.Encode(kProto, buffer).status());
}

TEST(PwpbSerde, Decode) {
  constexpr std::byte buffer[]{std::byte{1} << 3, std::byte{3}};
  TestRequest::Message proto = {};

  EXPECT_EQ(OkStatus(), kTestRequest.Decode(buffer, proto));

  EXPECT_EQ(3, proto.integer);
  EXPECT_EQ(0u, proto.status_code);
}

}  // namespace
}  // namespace pw::rpc::internal
