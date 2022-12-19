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
#pragma once

#include "pw_chrono/system_clock.h"
#include "pw_rpc/writer.h"
#include "pw_stream/stream.h"

namespace pw::transfer::internal {

enum class TransferType : bool { kTransmit, kReceive };

enum class TransferStream {
  kClientRead,
  kClientWrite,
  kServerRead,
  kServerWrite,
};

enum class EventType {
  // Begins a new transfer in an available context.
  kNewClientTransfer,
  kNewServerTransfer,

  // Processes an incoming chunk for a transfer.
  kClientChunk,
  kServerChunk,

  // Runs the timeout handler for a transfer.
  kClientTimeout,
  kServerTimeout,

  // Terminates an ongoing transfer with a specified status, optionally sending
  // a status chunk to the other end of the transfer.
  kClientEndTransfer,
  kServerEndTransfer,

  // Sends a status chunk to terminate a transfer. This does not call into the
  // transfer context's completion handler; it is for out-of-band termination.
  kSendStatusChunk,

  // Updates one of the transfer thread's RPC streams.
  kSetTransferStream,

  // Manages the list of transfer handlers for a transfer service.
  kAddTransferHandler,
  kRemoveTransferHandler,

  // For testing only: aborts the transfer thread.
  kTerminate,
};

// Forward declarations required for events.
class Handler;
class TransferParameters;
class TransferThread;

struct NewTransferEvent {
  TransferType type;
  uint32_t session_id;
  uint32_t resource_id;
  rpc::Writer* rpc_writer;
  const TransferParameters* max_parameters;
  chrono::SystemClock::duration timeout;
  uint32_t max_retries;
  TransferThread* transfer_thread;

  union {
    stream::Stream* stream;  // In client-side transfers.
    Handler* handler;        // In server-side transfers.
  };
};

struct ChunkEvent {
  uint32_t session_id;
  const std::byte* data;
  size_t size;
};

struct EndTransferEvent {
  uint32_t session_id;
  Status::Code status;
  bool send_status_chunk;
};

struct SendStatusChunkEvent {
  uint32_t session_id;
  Status::Code status;
  TransferStream stream;
};

struct Event {
  EventType type;

  union {
    NewTransferEvent new_transfer;
    ChunkEvent chunk;
    EndTransferEvent end_transfer;
    SendStatusChunkEvent send_status_chunk;
    TransferStream set_transfer_stream;
    Handler* add_transfer_handler;
    Handler* remove_transfer_handler;
  };
};

}  // namespace pw::transfer::internal
