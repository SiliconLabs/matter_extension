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

#include "pw_rpc/pwpb/client_reader_writer.h"

#include <optional>

#include "gtest/gtest.h"
#include "pw_rpc/pwpb/client_testing.h"
#include "pw_rpc_test_protos/test.rpc.pwpb.h"

PW_MODIFY_DIAGNOSTICS_PUSH();
PW_MODIFY_DIAGNOSTIC(ignored, "-Wmissing-field-initializers");

namespace pw::rpc {
namespace {

using test::pw_rpc::pwpb::TestService;

void FailIfCalled(Status) { FAIL(); }
template <typename T>
void FailIfOnNextCalled(const T&) {
  FAIL();
}
template <typename T>
void FailIfOnCompletedCalled(const T&, Status) {
  FAIL();
}

TEST(PwpbUnaryReceiver, DefaultConstructed) {
  PwpbUnaryReceiver<test::TestResponse::Message> call;

  ASSERT_FALSE(call.active());
  EXPECT_EQ(call.channel_id(), Channel::kUnassignedChannelId);

  EXPECT_EQ(Status::FailedPrecondition(), call.Cancel());

  call.set_on_completed([](const test::TestResponse::Message&, Status) {});
  call.set_on_error([](Status) {});
}

TEST(PwpbClientWriter, DefaultConstructed) {
  PwpbClientWriter<test::TestRequest::Message,
                   test::TestStreamResponse::Message>
      call;

  ASSERT_FALSE(call.active());
  EXPECT_EQ(call.channel_id(), Channel::kUnassignedChannelId);

  EXPECT_EQ(Status::FailedPrecondition(), call.Write({}));
  EXPECT_EQ(Status::FailedPrecondition(), call.Cancel());
  EXPECT_EQ(Status::FailedPrecondition(), call.CloseClientStream());

  call.set_on_completed(
      [](const test::TestStreamResponse::Message&, Status) {});
  call.set_on_error([](Status) {});
}

TEST(PwpbClientReader, DefaultConstructed) {
  PwpbClientReader<test::TestStreamResponse::Message> call;

  ASSERT_FALSE(call.active());
  EXPECT_EQ(call.channel_id(), Channel::kUnassignedChannelId);

  EXPECT_EQ(Status::FailedPrecondition(), call.Cancel());

  call.set_on_completed([](Status) {});
  call.set_on_next([](const test::TestStreamResponse::Message&) {});
  call.set_on_error([](Status) {});
}

TEST(PwpbClientReaderWriter, DefaultConstructed) {
  PwpbClientReaderWriter<test::TestRequest::Message,
                         test::TestStreamResponse::Message>
      call;

  ASSERT_FALSE(call.active());
  EXPECT_EQ(call.channel_id(), Channel::kUnassignedChannelId);

  EXPECT_EQ(Status::FailedPrecondition(), call.Write({}));
  EXPECT_EQ(Status::FailedPrecondition(), call.Cancel());
  EXPECT_EQ(Status::FailedPrecondition(), call.CloseClientStream());

  call.set_on_completed([](Status) {});
  call.set_on_next([](const test::TestStreamResponse::Message&) {});
  call.set_on_error([](Status) {});
}

TEST(PwpbUnaryReceiver, Closed) {
  PwpbClientTestContext ctx;
  PwpbUnaryReceiver<test::TestResponse::Message> call =
      TestService::TestUnaryRpc(
          ctx.client(),
          ctx.channel().id(),
          {},
          FailIfOnCompletedCalled<test::TestResponse::Message>,
          FailIfCalled);
  ASSERT_EQ(OkStatus(), call.Cancel());

  ASSERT_FALSE(call.active());
  EXPECT_EQ(call.channel_id(), Channel::kUnassignedChannelId);

  EXPECT_EQ(Status::FailedPrecondition(), call.Cancel());

  call.set_on_completed([](const test::TestResponse::Message&, Status) {});
  call.set_on_error([](Status) {});
}

TEST(PwpbClientWriter, Closed) {
  PwpbClientTestContext ctx;
  PwpbClientWriter<test::TestRequest::Message,
                   test::TestStreamResponse::Message>
      call = TestService::TestClientStreamRpc(
          ctx.client(),
          ctx.channel().id(),
          FailIfOnCompletedCalled<test::TestStreamResponse::Message>,
          FailIfCalled);
  ASSERT_EQ(OkStatus(), call.Cancel());

  ASSERT_FALSE(call.active());
  EXPECT_EQ(call.channel_id(), Channel::kUnassignedChannelId);

  EXPECT_EQ(Status::FailedPrecondition(), call.Write({}));
  EXPECT_EQ(Status::FailedPrecondition(), call.Cancel());
  EXPECT_EQ(Status::FailedPrecondition(), call.CloseClientStream());

  call.set_on_completed(
      [](const test::TestStreamResponse::Message&, Status) {});
  call.set_on_error([](Status) {});
}

TEST(PwpbClientReader, Closed) {
  PwpbClientTestContext ctx;
  PwpbClientReader<test::TestStreamResponse::Message> call =
      TestService::TestServerStreamRpc(
          ctx.client(),
          ctx.channel().id(),
          {},
          FailIfOnNextCalled<test::TestStreamResponse::Message>,
          FailIfCalled,
          FailIfCalled);
  ASSERT_EQ(OkStatus(), call.Cancel());

  ASSERT_FALSE(call.active());
  EXPECT_EQ(call.channel_id(), Channel::kUnassignedChannelId);

  EXPECT_EQ(Status::FailedPrecondition(), call.Cancel());

  call.set_on_completed([](Status) {});
  call.set_on_next([](const test::TestStreamResponse::Message&) {});
  call.set_on_error([](Status) {});
}

TEST(PwpbClientReaderWriter, Closed) {
  PwpbClientTestContext ctx;
  PwpbClientReaderWriter<test::TestRequest::Message,
                         test::TestStreamResponse::Message>
      call = TestService::TestBidirectionalStreamRpc(
          ctx.client(),
          ctx.channel().id(),
          FailIfOnNextCalled<test::TestStreamResponse::Message>,
          FailIfCalled,
          FailIfCalled);
  ASSERT_EQ(OkStatus(), call.Cancel());

  ASSERT_FALSE(call.active());
  EXPECT_EQ(call.channel_id(), Channel::kUnassignedChannelId);

  EXPECT_EQ(Status::FailedPrecondition(), call.Write({}));
  EXPECT_EQ(Status::FailedPrecondition(), call.Cancel());
  EXPECT_EQ(Status::FailedPrecondition(), call.CloseClientStream());

  call.set_on_completed([](Status) {});
  call.set_on_next([](const test::TestStreamResponse::Message&) {});
  call.set_on_error([](Status) {});
}

TEST(PwpbUnaryReceiver, CallbacksMoveCorrectly) {
  PwpbClientTestContext ctx;

  struct {
    test::TestResponse::Message payload = {.value = 12345678};
    std::optional<Status> status;
  } reply;

  PwpbUnaryReceiver<test::TestResponse::Message> call_2;
  {
    PwpbUnaryReceiver call_1 = TestService::TestUnaryRpc(
        ctx.client(),
        ctx.channel().id(),
        {},
        [&reply](const test::TestResponse::Message& response, Status status) {
          reply.payload = response;
          reply.status = status;
        });

    call_2 = std::move(call_1);
  }

  ctx.server().SendResponse<TestService::TestUnaryRpc>({.value = 9000},
                                                       Status::NotFound());
  EXPECT_EQ(reply.payload.value, 9000);
  EXPECT_EQ(reply.status, Status::NotFound());
}

TEST(PwpbClientReaderWriter, CallbacksMoveCorrectly) {
  PwpbClientTestContext ctx;

  test::TestStreamResponse::Message payload = {.chunk = {}, .number = 13579};

  PwpbClientReaderWriter<test::TestRequest::Message,
                         test::TestStreamResponse::Message>
      call_2;
  {
    PwpbClientReaderWriter call_1 = TestService::TestBidirectionalStreamRpc(
        ctx.client(),
        ctx.channel().id(),
        [&payload](const test::TestStreamResponse::Message& response) {
          payload = response;
        });

    call_2 = std::move(call_1);
  }

  ctx.server().SendServerStream<TestService::TestBidirectionalStreamRpc>(
      {.chunk = {}, .number = 5050});
  EXPECT_EQ(payload.number, 5050u);
}

}  // namespace
}  // namespace pw::rpc

PW_MODIFY_DIAGNOSTICS_POP();
