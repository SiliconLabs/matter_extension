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

// This file defines the ClientReaderWriter, ClientReader, ClientWriter,
// and UnaryReceiver classes for the pw_protobuf RPC interface. These classes
// are used for bidirectional, client, and server streaming, and unary RPCs.
#pragma once

#include "pw_bytes/span.h"
#include "pw_function/function.h"
#include "pw_rpc/channel.h"
#include "pw_rpc/internal/client_call.h"
#include "pw_rpc/pwpb/internal/common.h"

namespace pw::rpc {
namespace internal {

// internal::PwpbUnaryResponseClientCall extends
// internal::UnaryResponseClientCall by adding a method serializer/deserializer
// passed in to Start(), typed request messages to the Start() call, and an
// on_completed callback templated on the response type.
template <typename Response>
class PwpbUnaryResponseClientCall : public UnaryResponseClientCall {
 public:
  // Start() can be called with zero or one request objects.
  template <typename CallType, typename... Request>
  static CallType Start(Endpoint& client,
                        uint32_t channel_id,
                        uint32_t service_id,
                        uint32_t method_id,
                        const PwpbMethodSerde& serde,
                        Function<void(const Response&, Status)>&& on_completed,
                        Function<void(Status)>&& on_error,
                        const Request&... request)
      PW_LOCKS_EXCLUDED(rpc_lock()) {
    rpc_lock().lock();
    CallType call(
        client.ClaimLocked(), channel_id, service_id, method_id, serde);

    call.set_pwpb_on_completed_locked(std::move(on_completed));
    call.set_on_error_locked(std::move(on_error));

    if constexpr (sizeof...(Request) == 0u) {
      call.SendInitialClientRequest({});
    } else {
      PwpbSendInitialRequest(call, serde.request(), request...);
    }

    client.CleanUpCalls();
    return call;
  }

 protected:
  // Derived classes allow default construction so that users can declare a
  // variable into which to move client reader/writers from RPC calls.
  constexpr PwpbUnaryResponseClientCall() = default;

  PwpbUnaryResponseClientCall(LockedEndpoint& client,
                              uint32_t channel_id,
                              uint32_t service_id,
                              uint32_t method_id,
                              MethodType type,
                              const PwpbMethodSerde& serde)
      PW_EXCLUSIVE_LOCKS_REQUIRED(rpc_lock())
      : UnaryResponseClientCall(
            client, channel_id, service_id, method_id, StructCallProps(type)),
        serde_(&serde) {}

  // Allow derived classes to be constructed moving another instance.
  PwpbUnaryResponseClientCall(PwpbUnaryResponseClientCall&& other)
      PW_LOCKS_EXCLUDED(rpc_lock()) {
    *this = std::move(other);
  }

  // Allow derived classes to use move assignment from another instance.
  PwpbUnaryResponseClientCall& operator=(PwpbUnaryResponseClientCall&& other)
      PW_LOCKS_EXCLUDED(rpc_lock()) {
    RpcLockGuard lock;
    MovePwpbUnaryResponseClientCallFrom(other);
    return *this;
  }

  ~PwpbUnaryResponseClientCall() { DestroyClientCall(); }

  // Implement moving by copying the serde pointer and on_completed function.
  void MovePwpbUnaryResponseClientCallFrom(PwpbUnaryResponseClientCall& other)
      PW_EXCLUSIVE_LOCKS_REQUIRED(rpc_lock()) {
    MoveUnaryResponseClientCallFrom(other);
    serde_ = other.serde_;
    set_pwpb_on_completed_locked(std::move(other.pwpb_on_completed_));
  }

  void set_on_completed(
      Function<void(const Response& response, Status)>&& on_completed)
      PW_LOCKS_EXCLUDED(rpc_lock()) {
    RpcLockGuard lock;
    set_pwpb_on_completed_locked(std::move(on_completed));
  }

  // Sends a streamed request.
  // Returns the following Status codes:
  //
  //   OK - the request was successfully sent
  //   FAILED_PRECONDITION - the writer is closed
  //   INTERNAL - pw_rpc was unable to encode the pw_protobuf protobuf
  //   other errors - the ChannelOutput failed to send the packet; the error
  //       codes are determined by the ChannelOutput implementation
  //
  template <typename Request>
  Status SendStreamRequest(const Request& request)
      PW_LOCKS_EXCLUDED(rpc_lock()) {
    RpcLockGuard lock;
    return PwpbSendStream(*this, request, serde_);
  }

 private:
  void set_pwpb_on_completed_locked(
      Function<void(const Response& response, Status)>&& on_completed)
      PW_EXCLUSIVE_LOCKS_REQUIRED(rpc_lock()) {
    pwpb_on_completed_ = std::move(on_completed);

    UnaryResponseClientCall::set_on_completed_locked(
        [this](ConstByteSpan payload, Status status)
            PW_NO_LOCK_SAFETY_ANALYSIS {
              DecodeToStructAndInvokeOnCompleted(
                  payload, serde_->response(), pwpb_on_completed_, status);
            });
  }

  const PwpbMethodSerde* serde_ PW_GUARDED_BY(rpc_lock());
  Function<void(const Response&, Status)> pwpb_on_completed_
      PW_GUARDED_BY(rpc_lock());
};

// internal::PwpbStreamResponseClientCall extends
// internal::StreamResponseClientCall by adding a method serializer/deserializer
// passed in to Start(), typed request messages to the Start() call, and an
// on_next callback templated on the response type.
template <typename Response>
class PwpbStreamResponseClientCall : public StreamResponseClientCall {
 public:
  // Start() can be called with zero or one request objects.
  template <typename CallType, typename... Request>
  static CallType Start(Endpoint& client,
                        uint32_t channel_id,
                        uint32_t service_id,
                        uint32_t method_id,
                        const PwpbMethodSerde& serde,
                        Function<void(const Response&)>&& on_next,
                        Function<void(Status)>&& on_completed,
                        Function<void(Status)>&& on_error,
                        const Request&... request)
      PW_LOCKS_EXCLUDED(rpc_lock()) {
    rpc_lock().lock();
    CallType call(
        client.ClaimLocked(), channel_id, service_id, method_id, serde);

    call.set_pwpb_on_next_locked(std::move(on_next));
    call.set_on_completed_locked(std::move(on_completed));
    call.set_on_error_locked(std::move(on_error));

    if constexpr (sizeof...(Request) == 0u) {
      call.SendInitialClientRequest({});
    } else {
      PwpbSendInitialRequest(call, serde.request(), request...);
    }
    client.CleanUpCalls();
    return call;
  }

 protected:
  // Derived classes allow default construction so that users can declare a
  // variable into which to move client reader/writers from RPC calls.
  constexpr PwpbStreamResponseClientCall() = default;

  PwpbStreamResponseClientCall(LockedEndpoint& client,
                               uint32_t channel_id,
                               uint32_t service_id,
                               uint32_t method_id,
                               MethodType type,
                               const PwpbMethodSerde& serde)
      PW_EXCLUSIVE_LOCKS_REQUIRED(rpc_lock())
      : StreamResponseClientCall(
            client, channel_id, service_id, method_id, StructCallProps(type)),
        serde_(&serde) {}

  // Allow derived classes to be constructed moving another instance.
  PwpbStreamResponseClientCall(PwpbStreamResponseClientCall&& other)
      PW_LOCKS_EXCLUDED(rpc_lock()) {
    *this = std::move(other);
  }

  // Allow derived classes to use move assignment from another instance.
  PwpbStreamResponseClientCall& operator=(PwpbStreamResponseClientCall&& other)
      PW_LOCKS_EXCLUDED(rpc_lock()) {
    RpcLockGuard lock;
    MovePwpbStreamResponseClientCallFrom(other);
    return *this;
  }

  ~PwpbStreamResponseClientCall() { DestroyClientCall(); }

  // Implement moving by copying the serde pointer and on_next function.
  void MovePwpbStreamResponseClientCallFrom(PwpbStreamResponseClientCall& other)
      PW_EXCLUSIVE_LOCKS_REQUIRED(rpc_lock()) {
    MoveStreamResponseClientCallFrom(other);
    serde_ = other.serde_;
    set_pwpb_on_next_locked(std::move(other.pwpb_on_next_));
  }

  void set_on_next(Function<void(const Response& response)>&& on_next)
      PW_LOCKS_EXCLUDED(rpc_lock()) {
    RpcLockGuard lock;
    set_pwpb_on_next_locked(std::move(on_next));
  }

  // Sends a streamed request.
  // Returns the following Status codes:
  //
  //   OK - the request was successfully sent
  //   FAILED_PRECONDITION - the writer is closed
  //   INTERNAL - pw_rpc was unable to encode the pw_protobuf protobuf
  //   other errors - the ChannelOutput failed to send the packet; the error
  //       codes are determined by the ChannelOutput implementation
  //
  template <typename Request>
  Status SendStreamRequest(const Request& request)
      PW_LOCKS_EXCLUDED(rpc_lock()) {
    RpcLockGuard lock;
    return PwpbSendStream(*this, request, serde_);
  }

 private:
  void set_pwpb_on_next_locked(
      Function<void(const Response& response)>&& on_next)
      PW_EXCLUSIVE_LOCKS_REQUIRED(rpc_lock()) {
    pwpb_on_next_ = std::move(on_next);

    Call::set_on_next_locked(
        [this](ConstByteSpan payload) PW_NO_LOCK_SAFETY_ANALYSIS {
          DecodeToStructAndInvokeOnNext(
              payload, serde_->response(), pwpb_on_next_);
        });
  }

  const PwpbMethodSerde* serde_ PW_GUARDED_BY(rpc_lock());
  Function<void(const Response&)> pwpb_on_next_ PW_GUARDED_BY(rpc_lock());
};

}  // namespace internal

// The PwpbClientReaderWriter is used to send and receive typed messages in a
// pw_protobuf bidirectional streaming RPC.
//
// These classes use private inheritance to hide the internal::Call API while
// allow direct use of its public and protected functions.
template <typename Request, typename Response>
class PwpbClientReaderWriter
    : private internal::PwpbStreamResponseClientCall<Response> {
 public:
  // Allow default construction so that users can declare a variable into
  // which to move client reader/writers from RPC calls.
  constexpr PwpbClientReaderWriter() = default;

  PwpbClientReaderWriter(PwpbClientReaderWriter&&) = default;
  PwpbClientReaderWriter& operator=(PwpbClientReaderWriter&&) = default;

  using internal::Call::active;
  using internal::Call::channel_id;

  // Writes a request. Returns the following Status codes:
  //
  //   OK - the request was successfully sent
  //   FAILED_PRECONDITION - the writer is closed
  //   INTERNAL - pw_rpc was unable to encode the pw_protobuf message
  //   other errors - the ChannelOutput failed to send the packet; the error
  //       codes are determined by the ChannelOutput implementation
  //
  Status Write(const Request& request) {
    return internal::PwpbStreamResponseClientCall<Response>::SendStreamRequest(
        request);
  }

  // Notifies the server that the client has requested to stop communication by
  // sending CLIENT_REQUEST_COMPLETION.
  using internal::ClientCall::RequestCompletion;

  // Cancels this RPC. Closes the call locally and sends a CANCELLED error to
  // the server.
  using internal::Call::Cancel;

  // Closes this RPC locally. Sends a CLIENT_REQUEST_COMPLETION, but no
  // cancellation packet. Future packets for this RPC are dropped, and the
  // client sends a FAILED_PRECONDITION error in response because the call is
  // not active.
  using internal::ClientCall::Abandon;

  // Functions for setting RPC event callbacks.
  using internal::PwpbStreamResponseClientCall<Response>::set_on_next;
  using internal::StreamResponseClientCall::set_on_completed;
  using internal::StreamResponseClientCall::set_on_error;

 protected:
  friend class internal::PwpbStreamResponseClientCall<Response>;

  PwpbClientReaderWriter(internal::LockedEndpoint& client,
                         uint32_t channel_id_v,
                         uint32_t service_id,
                         uint32_t method_id,
                         const PwpbMethodSerde& serde)
      PW_EXCLUSIVE_LOCKS_REQUIRED(internal::rpc_lock())
      : internal::PwpbStreamResponseClientCall<Response>(
            client,
            channel_id_v,
            service_id,
            method_id,
            MethodType::kBidirectionalStreaming,
            serde) {}
};

// The PwpbClientReader is used to receive typed messages and send a typed
// response in a pw_protobuf client streaming RPC.
//
// These classes use private inheritance to hide the internal::Call API while
// allow direct use of its public and protected functions.
template <typename Response>
class PwpbClientReader
    : private internal::PwpbStreamResponseClientCall<Response> {
 public:
  // Allow default construction so that users can declare a variable into
  // which to move client reader/writers from RPC calls.
  constexpr PwpbClientReader() = default;

  PwpbClientReader(PwpbClientReader&&) = default;
  PwpbClientReader& operator=(PwpbClientReader&&) = default;

  using internal::StreamResponseClientCall::active;
  using internal::StreamResponseClientCall::channel_id;

  using internal::Call::Cancel;
  using internal::Call::RequestCompletion;
  using internal::ClientCall::Abandon;

  // Functions for setting RPC event callbacks.
  using internal::PwpbStreamResponseClientCall<Response>::set_on_next;
  using internal::StreamResponseClientCall::set_on_completed;
  using internal::StreamResponseClientCall::set_on_error;

 private:
  friend class internal::PwpbStreamResponseClientCall<Response>;

  PwpbClientReader(internal::LockedEndpoint& client,
                   uint32_t channel_id_v,
                   uint32_t service_id,
                   uint32_t method_id,
                   const PwpbMethodSerde& serde)
      PW_EXCLUSIVE_LOCKS_REQUIRED(internal::rpc_lock())
      : internal::PwpbStreamResponseClientCall<Response>(
            client,
            channel_id_v,
            service_id,
            method_id,
            MethodType::kServerStreaming,
            serde) {}
};

// The PwpbClientWriter is used to send typed responses in a pw_protobuf server
// streaming RPC.
//
// These classes use private inheritance to hide the internal::Call API while
// allow direct use of its public and protected functions.
template <typename Request, typename Response>
class PwpbClientWriter
    : private internal::PwpbUnaryResponseClientCall<Response> {
 public:
  // Allow default construction so that users can declare a variable into
  // which to move client reader/writers from RPC calls.
  constexpr PwpbClientWriter() = default;

  PwpbClientWriter(PwpbClientWriter&&) = default;
  PwpbClientWriter& operator=(PwpbClientWriter&&) = default;

  using internal::UnaryResponseClientCall::active;
  using internal::UnaryResponseClientCall::channel_id;

  // Writes a request. Returns the following Status codes:
  //
  //   OK - the request was successfully sent
  //   FAILED_PRECONDITION - the writer is closed
  //   INTERNAL - pw_rpc was unable to encode the pw_protobuf message
  //   other errors - the ChannelOutput failed to send the packet; the error
  //       codes are determined by the ChannelOutput implementation
  //
  Status Write(const Request& request) {
    return internal::PwpbUnaryResponseClientCall<Response>::SendStreamRequest(
        request);
  }

  using internal::Call::Cancel;
  using internal::Call::RequestCompletion;
  using internal::ClientCall::Abandon;

  // Functions for setting RPC event callbacks.
  using internal::PwpbUnaryResponseClientCall<Response>::set_on_completed;
  using internal::UnaryResponseClientCall::set_on_error;

 private:
  friend class internal::PwpbUnaryResponseClientCall<Response>;

  PwpbClientWriter(internal::LockedEndpoint& client,
                   uint32_t channel_id_v,
                   uint32_t service_id,
                   uint32_t method_id,
                   const PwpbMethodSerde& serde)
      PW_EXCLUSIVE_LOCKS_REQUIRED(internal::rpc_lock())

      : internal::PwpbUnaryResponseClientCall<Response>(
            client,
            channel_id_v,
            service_id,
            method_id,
            MethodType::kClientStreaming,
            serde) {}
};

// The PwpbUnaryReceiver is used to handle a typed response to a pw_protobuf
// unary RPC.
//
// These classes use private inheritance to hide the internal::Call API while
// allow direct use of its public and protected functions.
template <typename Response>
class PwpbUnaryReceiver
    : private internal::PwpbUnaryResponseClientCall<Response> {
 public:
  // Allow default construction so that users can declare a variable into
  // which to move client reader/writers from RPC calls.
  constexpr PwpbUnaryReceiver() = default;

  PwpbUnaryReceiver(PwpbUnaryReceiver&&) = default;
  PwpbUnaryReceiver& operator=(PwpbUnaryReceiver&&) = default;

  using internal::Call::active;
  using internal::Call::channel_id;

  // Functions for setting RPC event callbacks.
  using internal::Call::set_on_error;
  using internal::PwpbUnaryResponseClientCall<Response>::set_on_completed;

  using internal::Call::Cancel;
  using internal::ClientCall::Abandon;

 private:
  friend class internal::PwpbUnaryResponseClientCall<Response>;

  PwpbUnaryReceiver(internal::LockedEndpoint& client,
                    uint32_t channel_id_v,
                    uint32_t service_id,
                    uint32_t method_id,
                    const PwpbMethodSerde& serde)
      PW_EXCLUSIVE_LOCKS_REQUIRED(internal::rpc_lock())
      : internal::PwpbUnaryResponseClientCall<Response>(client,
                                                        channel_id_v,
                                                        service_id,
                                                        method_id,
                                                        MethodType::kUnary,
                                                        serde) {}
};

}  // namespace pw::rpc
