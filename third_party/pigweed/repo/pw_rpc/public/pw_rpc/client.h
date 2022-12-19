// Copyright 2020 The Pigweed Authors
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

#include <cstddef>

#include "pw_bytes/span.h"
#include "pw_rpc/channel.h"
#include "pw_rpc/internal/channel.h"
#include "pw_rpc/internal/endpoint.h"
#include "pw_rpc/internal/lock.h"
#include "pw_span/span.h"

namespace pw::rpc {

class Client : public internal::Endpoint {
 public:
  // Creates a client that uses a set of RPC channels. Channels can be shared
  // between a client and a server, but not between multiple clients.
  _PW_RPC_CONSTEXPR Client(span<Channel> channels) : Endpoint(channels) {}

  // Processes an incoming RPC packet. The packet may be an RPC response or a
  // control packet, the result of which is processed in this function. Returns
  // whether the packet was able to be processed:
  //
  //   OK - The packet was processed by the client.
  //   DATA_LOSS - Failed to decode the packet.
  //   INVALID_ARGUMENT - The packet is intended for a server, not a client.
  //   UNAVAILABLE - No RPC channel with the requested ID was found.
  //
  Status ProcessPacket(ConstByteSpan data)
      PW_LOCKS_EXCLUDED(internal::rpc_lock());

 private:
  // Remove these internal::Endpoint functions from the public interface.
  using Endpoint::active_call_count;
  using Endpoint::GetInternalChannel;
};

}  // namespace pw::rpc
