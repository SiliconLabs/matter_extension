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

#include "pw_rpc/internal/call.h"

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstring>
#include <optional>

#include "gtest/gtest.h"
#include "pw_rpc/internal/test_utils.h"
#include "pw_rpc/service.h"
#include "pw_rpc_private/fake_server_reader_writer.h"
#include "pw_rpc_private/test_method.h"

namespace pw::rpc {

class TestService : public Service {
 public:
  constexpr TestService(uint32_t id) : Service(id, method) {}

  static constexpr internal::TestMethodUnion method = internal::TestMethod(8);
};

namespace internal {
namespace {

constexpr Packet kPacket(pwpb::PacketType::REQUEST, 99, 16, 8);

using ::pw::rpc::internal::test::FakeServerReader;
using ::pw::rpc::internal::test::FakeServerReaderWriter;
using ::pw::rpc::internal::test::FakeServerWriter;
using ::std::byte;
using ::testing::Test;

static_assert(sizeof(Call) ==
                  // IntrusiveList::Item pointer
                  sizeof(IntrusiveList<Call>::Item) +
                      // Endpoint pointer
                      sizeof(Endpoint*) +
                      // call_id, channel_id, service_id, method_id
                      4 * sizeof(uint32_t) +
                      // Packed state and properties
                      sizeof(void*) +
                      // on_error and on_next callbacks
                      2 * sizeof(Function<void(Status)>),
              "Unexpected padding in Call!");

static_assert(sizeof(CallProperties) == sizeof(uint8_t));

TEST(CallProperties, ValuesMatch) {
  constexpr CallProperties props_1(
      MethodType::kBidirectionalStreaming, kClientCall, kRawProto);
  static_assert(props_1.method_type() == MethodType::kBidirectionalStreaming);
  static_assert(props_1.call_type() == kClientCall);
  static_assert(props_1.callback_proto_type() == kRawProto);

  constexpr CallProperties props_2(
      MethodType::kClientStreaming, kServerCall, kProtoStruct);
  static_assert(props_2.method_type() == MethodType::kClientStreaming);
  static_assert(props_2.call_type() == kServerCall);
  static_assert(props_2.callback_proto_type() == kProtoStruct);

  constexpr CallProperties props_3(
      MethodType::kUnary, kClientCall, kProtoStruct);
  static_assert(props_3.method_type() == MethodType::kUnary);
  static_assert(props_3.call_type() == kClientCall);
  static_assert(props_3.callback_proto_type() == kProtoStruct);
}

class ServerWriterTest : public Test {
 public:
  ServerWriterTest() : context_(TestService::method.method()) {
    rpc_lock().lock();
    FakeServerWriter writer_temp(context_.get().ClaimLocked());
    rpc_lock().unlock();
    writer_ = std::move(writer_temp);
  }

  ServerContextForTest<TestService> context_;
  FakeServerWriter writer_;
};

TEST_F(ServerWriterTest, ConstructWithContext_StartsOpen) {
  EXPECT_TRUE(writer_.active());
}

TEST_F(ServerWriterTest, Move_ClosesOriginal) {
  FakeServerWriter moved(std::move(writer_));

#ifndef __clang_analyzer__
  EXPECT_FALSE(writer_.active());
#endif  // ignore use-after-move
  EXPECT_TRUE(moved.active());
}

TEST_F(ServerWriterTest, DefaultConstruct_Closed) {
  FakeServerWriter writer;
  EXPECT_FALSE(writer.active());
}

TEST_F(ServerWriterTest, Construct_RegistersWithServer) {
  RpcLockGuard lock;
  IntrusiveList<Call>::iterator call = context_.server().FindCall(kPacket);
  ASSERT_NE(call, context_.server().calls_end());
  EXPECT_EQ(static_cast<void*>(&*call), static_cast<void*>(&writer_));
}

TEST_F(ServerWriterTest, Destruct_RemovesFromServer) {
  {
    // Note `lock_guard` cannot be used here, because while the constructor
    // of `FakeServerWriter` requires the lock be held, the destructor acquires
    // it!
    rpc_lock().lock();
    FakeServerWriter writer(context_.get().ClaimLocked());
    rpc_lock().unlock();
  }

  RpcLockGuard lock;
  EXPECT_EQ(context_.server().FindCall(kPacket), context_.server().calls_end());
}

TEST_F(ServerWriterTest, Finish_RemovesFromServer) {
  EXPECT_EQ(OkStatus(), writer_.Finish());
  RpcLockGuard lock;
  EXPECT_EQ(context_.server().FindCall(kPacket), context_.server().calls_end());
}

TEST_F(ServerWriterTest, Finish_SendsResponse) {
  EXPECT_EQ(OkStatus(), writer_.Finish());

  ASSERT_EQ(context_.output().total_packets(), 1u);
  const Packet& packet = context_.output().last_packet();
  EXPECT_EQ(packet.type(), pwpb::PacketType::RESPONSE);
  EXPECT_EQ(packet.channel_id(), context_.channel_id());
  EXPECT_EQ(packet.service_id(), context_.service_id());
  EXPECT_EQ(packet.method_id(), context_.get().method().id());
  EXPECT_TRUE(packet.payload().empty());
  EXPECT_EQ(packet.status(), OkStatus());
}

TEST_F(ServerWriterTest, Finish_ReturnsStatusFromChannelSend) {
  context_.output().set_send_status(Status::Unauthenticated());

  // All non-OK statuses are remapped to UNKNOWN.
  EXPECT_EQ(Status::Unknown(), writer_.Finish());
}

TEST_F(ServerWriterTest, Finish) {
  ASSERT_TRUE(writer_.active());
  EXPECT_EQ(OkStatus(), writer_.Finish());
  EXPECT_FALSE(writer_.active());
  EXPECT_EQ(Status::FailedPrecondition(), writer_.Finish());
}

TEST_F(ServerWriterTest, Open_SendsPacketWithPayload) {
  constexpr byte data[] = {byte{0xf0}, byte{0x0d}};
  ASSERT_EQ(OkStatus(), writer_.Write(data));

  byte encoded[64];
  auto result = context_.server_stream(data).Encode(encoded);
  ASSERT_EQ(OkStatus(), result.status());

  ConstByteSpan payload = context_.output().last_packet().payload();
  EXPECT_EQ(sizeof(data), payload.size());
  EXPECT_EQ(0, std::memcmp(data, payload.data(), sizeof(data)));
}

TEST_F(ServerWriterTest, Closed_IgnoresFinish) {
  EXPECT_EQ(OkStatus(), writer_.Finish());
  EXPECT_EQ(Status::FailedPrecondition(), writer_.Finish());
}

TEST_F(ServerWriterTest, DefaultConstructor_NoClientStream) {
  FakeServerWriter writer;
  RpcLockGuard lock;
  EXPECT_FALSE(writer.as_server_call().has_client_stream());
  EXPECT_FALSE(writer.as_server_call().client_requested_completion());
}

TEST_F(ServerWriterTest, Open_NoClientStream) {
  RpcLockGuard lock;
  EXPECT_FALSE(writer_.as_server_call().has_client_stream());
  EXPECT_TRUE(writer_.as_server_call().has_server_stream());
  EXPECT_FALSE(writer_.as_server_call().client_requested_completion());
}

class ServerReaderTest : public Test {
 public:
  ServerReaderTest() : context_(TestService::method.method()) {
    rpc_lock().lock();
    FakeServerReader reader_temp(context_.get().ClaimLocked());
    rpc_lock().unlock();
    reader_ = std::move(reader_temp);
  }

  ServerContextForTest<TestService> context_;
  FakeServerReader reader_;
};

TEST_F(ServerReaderTest, DefaultConstructor_StreamClosed) {
  FakeServerReader reader;
  EXPECT_FALSE(reader.as_server_call().active());
  RpcLockGuard lock;
  EXPECT_FALSE(reader.as_server_call().client_requested_completion());
}

TEST_F(ServerReaderTest, Open_ClientStreamStartsOpen) {
  RpcLockGuard lock;
  EXPECT_TRUE(reader_.as_server_call().has_client_stream());
  EXPECT_FALSE(reader_.as_server_call().client_requested_completion());
}

TEST_F(ServerReaderTest, Close_ClosesStream) {
  EXPECT_TRUE(reader_.as_server_call().active());
  rpc_lock().lock();
  EXPECT_FALSE(reader_.as_server_call().client_requested_completion());
  rpc_lock().unlock();
  EXPECT_EQ(OkStatus(),
            reader_.as_server_call().CloseAndSendResponse(OkStatus()));

  EXPECT_FALSE(reader_.as_server_call().active());
  RpcLockGuard lock;
  EXPECT_TRUE(reader_.as_server_call().client_requested_completion());
}

TEST_F(ServerReaderTest, RequestCompletion_OnlyMakesClientNotReady) {
  EXPECT_TRUE(reader_.active());
  rpc_lock().lock();
  EXPECT_FALSE(reader_.as_server_call().client_requested_completion());
  reader_.as_server_call().HandleClientRequestedCompletion();

  EXPECT_TRUE(reader_.active());
  RpcLockGuard lock;
  EXPECT_TRUE(reader_.as_server_call().client_requested_completion());
}

class ServerReaderWriterTest : public Test {
 public:
  ServerReaderWriterTest() : context_(TestService::method.method()) {
    rpc_lock().lock();
    FakeServerReaderWriter reader_writer_temp(context_.get().ClaimLocked());
    rpc_lock().unlock();
    reader_writer_ = std::move(reader_writer_temp);
  }

  ServerContextForTest<TestService> context_;
  FakeServerReaderWriter reader_writer_;
};

TEST_F(ServerReaderWriterTest, Move_MaintainsClientStream) {
  FakeServerReaderWriter destination;

  rpc_lock().lock();
  EXPECT_FALSE(destination.as_server_call().client_requested_completion());
  rpc_lock().unlock();

  destination = std::move(reader_writer_);
  RpcLockGuard lock;
  EXPECT_TRUE(destination.as_server_call().has_client_stream());
  EXPECT_FALSE(destination.as_server_call().client_requested_completion());
}

TEST_F(ServerReaderWriterTest, Move_MovesCallbacks) {
  int calls = 0;
  reader_writer_.set_on_error([&calls](Status) { calls += 1; });
  reader_writer_.set_on_next([&calls](ConstByteSpan) { calls += 1; });
  reader_writer_.set_on_completion_requested_if_enabled(
      [&calls]() { calls += 1; });

  FakeServerReaderWriter destination(std::move(reader_writer_));
  rpc_lock().lock();
  destination.as_server_call().HandlePayload({});
  rpc_lock().lock();
  destination.as_server_call().HandleClientRequestedCompletion();
  rpc_lock().lock();
  destination.as_server_call().HandleError(Status::Unknown());

  EXPECT_EQ(calls, 2 + PW_RPC_COMPLETION_REQUEST_CALLBACK);
}

TEST_F(ServerReaderWriterTest, Move_ClearsCallAndChannelId) {
  rpc_lock().lock();
  reader_writer_.set_id(999);
  EXPECT_NE(reader_writer_.channel_id_locked(), 0u);
  rpc_lock().unlock();

  FakeServerReaderWriter destination(std::move(reader_writer_));

  RpcLockGuard lock;
  EXPECT_EQ(reader_writer_.id(), 0u);
  EXPECT_EQ(reader_writer_.channel_id_locked(), 0u);
}

TEST_F(ServerReaderWriterTest, Move_SourceAwaitingCleanup_CleansUpCalls) {
  std::optional<Status> on_error_cb;
  reader_writer_.set_on_error([&on_error_cb](Status error) {
    ASSERT_FALSE(on_error_cb.has_value());
    on_error_cb = error;
  });

  rpc_lock().lock();
  context_.server().CloseCallAndMarkForCleanup(reader_writer_.as_server_call(),
                                               Status::NotFound());
  rpc_lock().unlock();

  FakeServerReaderWriter destination(std::move(reader_writer_));

  EXPECT_EQ(Status::NotFound(), on_error_cb);
}

TEST_F(ServerReaderWriterTest, Move_BothAwaitingCleanup_CleansUpCalls) {
  rpc_lock().lock();
  // Use call ID 123 so this call is distinct from the other.
  FakeServerReaderWriter destination(context_.get(123).ClaimLocked());
  rpc_lock().unlock();

  std::optional<Status> destination_on_error_cb;
  destination.set_on_error([&destination_on_error_cb](Status error) {
    ASSERT_FALSE(destination_on_error_cb.has_value());
    destination_on_error_cb = error;
  });

  std::optional<Status> source_on_error_cb;
  reader_writer_.set_on_error([&source_on_error_cb](Status error) {
    ASSERT_FALSE(source_on_error_cb.has_value());
    source_on_error_cb = error;
  });

  // Simulate these two calls being closed by another thread.
  rpc_lock().lock();
  context_.server().CloseCallAndMarkForCleanup(destination.as_server_call(),
                                               Status::NotFound());
  context_.server().CloseCallAndMarkForCleanup(reader_writer_.as_server_call(),
                                               Status::Unauthenticated());
  rpc_lock().unlock();

  destination = std::move(reader_writer_);

  EXPECT_EQ(Status::NotFound(), destination_on_error_cb);
  EXPECT_EQ(Status::Unauthenticated(), source_on_error_cb);
}

TEST_F(ServerReaderWriterTest, Close_ClearsCallAndChannelId) {
  rpc_lock().lock();
  reader_writer_.set_id(999);
  EXPECT_NE(reader_writer_.channel_id_locked(), 0u);
  rpc_lock().unlock();

  EXPECT_EQ(OkStatus(), reader_writer_.Finish());

  RpcLockGuard lock;
  EXPECT_EQ(reader_writer_.id(), 0u);
  EXPECT_EQ(reader_writer_.channel_id_locked(), 0u);
}

}  // namespace
}  // namespace internal
}  // namespace pw::rpc
