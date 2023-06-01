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

// clang-format off
#include "pw_rpc/internal/log_config.h"  // PW_LOG_* macros must be first.

#include "pw_rpc/internal/channel.h"
// clang-format on

#include "pw_bytes/span.h"
#include "pw_log/log.h"
#include "pw_protobuf/decoder.h"
#include "pw_rpc/internal/config.h"
#include "pw_rpc/internal/encoding_buffer.h"

namespace pw::rpc {

Result<uint32_t> ExtractChannelId(ConstByteSpan packet) {
  protobuf::Decoder decoder(packet);

  while (decoder.Next().ok()) {
    if (static_cast<internal::pwpb::RpcPacket::Fields>(decoder.FieldNumber()) !=
        internal::pwpb::RpcPacket::Fields::kChannelId) {
      continue;
    }
    uint32_t channel_id;
    PW_TRY(decoder.ReadUint32(&channel_id));
    return channel_id;
  }

  return Status::DataLoss();
}

namespace internal {

Status Channel::Send(const Packet& packet) {
  ByteSpan buffer = encoding_buffer.GetPacketBuffer(packet.payload().size());
  Result encoded = packet.Encode(buffer);

  if (!encoded.ok()) {
    encoding_buffer.Release();
    PW_LOG_ERROR(
        "Failed to encode RPC packet type %u to channel %u buffer, status %u",
        static_cast<unsigned>(packet.type()),
        static_cast<unsigned>(id()),
        encoded.status().code());
    return Status::Internal();
  }

  Status sent = output().Send(encoded.value());
  encoding_buffer.Release();

  if (!sent.ok()) {
    PW_LOG_DEBUG("Channel %u failed to send packet with status %u",
                 static_cast<unsigned>(id()),
                 sent.code());

    return Status::Unknown();
  }
  return OkStatus();
}

}  // namespace internal
}  // namespace pw::rpc
