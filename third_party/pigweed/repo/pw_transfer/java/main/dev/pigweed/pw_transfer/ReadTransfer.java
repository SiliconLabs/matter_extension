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

package dev.pigweed.pw_transfer;

import static dev.pigweed.pw_transfer.TransferProgress.UNKNOWN_TRANSFER_SIZE;
import static java.lang.Math.max;

import dev.pigweed.pw_log.Logger;
import dev.pigweed.pw_rpc.Status;
import dev.pigweed.pw_transfer.TransferEventHandler.TransferInterface;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.List;
import java.util.function.BooleanSupplier;
import java.util.function.Consumer;

class ReadTransfer extends Transfer<byte[]> {
  private static final Logger logger = Logger.forClass(ReadTransfer.class);

  // The fractional position within a window at which a receive transfer should
  // extend its window size to minimize the amount of time the transmitter
  // spends blocked.
  //
  // For example, a divisor of 2 will extend the window when half of the
  // requested data has been received, a divisor of three will extend at a third
  // of the window, and so on.
  private static final int EXTEND_WINDOW_DIVISOR = 2;

  // To minimize copies, store the ByteBuffers directly from the chunk protos in a list.
  private final List<ByteBuffer> dataChunks = new ArrayList<>();
  private int totalDataSize = 0;

  private final TransferParameters parameters;

  private long remainingTransferSize = UNKNOWN_TRANSFER_SIZE;

  private int offset = 0;
  private int windowEndOffset;

  ReadTransfer(int resourceId,
      TransferInterface transferManager,
      int timeoutMillis,
      int initialTimeoutMillis,
      int maxRetries,
      TransferParameters transferParameters,
      Consumer<TransferProgress> progressCallback,
      BooleanSupplier shouldAbortCallback) {
    super(resourceId,
        transferManager,
        timeoutMillis,
        initialTimeoutMillis,
        maxRetries,
        progressCallback,
        shouldAbortCallback);
    this.parameters = transferParameters;
    this.windowEndOffset = parameters.maxPendingBytes();
  }

  @Override
  State getWaitingForDataState() {
    return new ReceivingData();
  }

  @Override
  Chunk getChunkForRetry() {
    return prepareTransferParameters(/*extend=*/false).build();
  }

  class ReceivingData extends State {
    @Override
    void handleTimeout() {
      setState(new Recovery());
    }

    @Override
    void handleDataChunk(Chunk chunk) {
      if (chunk.getOffset() != offset) {
        logger.atFine().log(
            "Transfer %d expected offset %d, received %d; resending transfer parameters",
            getSessionId(),
            offset,
            chunk.getOffset());

        // For now, only in-order transfers are supported. If data is received out of order,
        // discard this data and retransmit from the last received offset.
        sendChunk(prepareTransferParameters(/*extend=*/false));
        setNextChunkTimeout();
        return;
      }

      // Add the underlying array(s) to a list to avoid making copies of the data.
      dataChunks.addAll(chunk.getData().asReadOnlyByteBufferList());
      totalDataSize += chunk.getData().size();

      offset += chunk.getData().size();

      if (chunk.hasRemainingBytes()) {
        if (chunk.getRemainingBytes() == 0) {
          sendFinalChunk(Status.OK);
          setState(new Completed());
          return;
        }

        remainingTransferSize = chunk.getRemainingBytes();
      } else if (remainingTransferSize != UNKNOWN_TRANSFER_SIZE) {
        // If the remaining size was not specified, update based on the most recent estimate, if
        // any.
        remainingTransferSize = max(remainingTransferSize - chunk.getData().size(), 0);
      }

      if (remainingTransferSize == UNKNOWN_TRANSFER_SIZE || remainingTransferSize == 0) {
        updateProgress(offset, offset, UNKNOWN_TRANSFER_SIZE);
      } else {
        updateProgress(offset, offset, offset + remainingTransferSize);
      }

      int remainingWindowSize = windowEndOffset - offset;
      boolean extendWindow =
          remainingWindowSize <= parameters.maxPendingBytes() / EXTEND_WINDOW_DIVISOR;

      if (remainingWindowSize == 0) {
        logger.atFiner().log(
            "Transfer %d received all pending bytes; sending transfer parameters update",
            getSessionId());
        sendChunk(prepareTransferParameters(/*extend=*/false));
      } else if (extendWindow) {
        sendChunk(prepareTransferParameters(/*extend=*/true));
      }
      setNextChunkTimeout();
    }
  }

  @Override
  void setFutureResult() {
    updateProgress(totalDataSize, totalDataSize, totalDataSize);

    ByteBuffer result = ByteBuffer.allocate(totalDataSize);
    dataChunks.forEach(result::put);
    getFuture().set(result.array());
  }

  private Chunk.Builder prepareTransferParameters(boolean extend) {
    windowEndOffset = offset + parameters.maxPendingBytes();

    Chunk.Type type = extend ? Chunk.Type.PARAMETERS_CONTINUE : Chunk.Type.PARAMETERS_RETRANSMIT;

    Chunk.Builder chunk = newChunk(type)
                              .setPendingBytes(parameters.maxPendingBytes())
                              .setMaxChunkSizeBytes(parameters.maxChunkSizeBytes())
                              .setOffset(offset)
                              .setWindowEndOffset(windowEndOffset);
    if (parameters.chunkDelayMicroseconds() > 0) {
      chunk.setMinDelayMicroseconds(parameters.chunkDelayMicroseconds());
    }

    return chunk;
  }
}
