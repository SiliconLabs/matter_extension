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

import com.google.common.util.concurrent.ListenableFuture;
import dev.pigweed.pw_log.Logger;
import dev.pigweed.pw_rpc.Call;
import dev.pigweed.pw_rpc.ChannelOutputException;
import dev.pigweed.pw_rpc.MethodClient;
import dev.pigweed.pw_rpc.RpcError;
import dev.pigweed.pw_rpc.Status;
import dev.pigweed.pw_rpc.StreamObserver;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.time.temporal.TemporalUnit;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.Semaphore;
import java.util.concurrent.TimeUnit;
import java.util.function.BooleanSupplier;
import java.util.function.Consumer;
import javax.annotation.Nullable;

/** Manages the active transfers and dispatches events to them. */
class TransferEventHandler {
  private static final Logger logger = Logger.forClass(TransferEventHandler.class);

  // Instant and BlockingQueue use different time unit types.
  private static final TemporalUnit TIME_UNIT = ChronoUnit.MICROS;
  private static final TimeUnit POLL_TIME_UNIT = TimeUnit.MICROSECONDS;

  private final MethodClient readMethod;
  private final MethodClient writeMethod;

  private final BlockingQueue<Event> events = new LinkedBlockingQueue<>();

  // Maps resource ID to transfer
  private final Map<Integer, Transfer<?>> transfers = new HashMap<>();

  @Nullable private Call.ClientStreaming<Chunk> readStream = null;
  @Nullable private Call.ClientStreaming<Chunk> writeStream = null;
  private boolean processEvents = true;

  TransferEventHandler(MethodClient readMethod, MethodClient writeMethod) {
    this.readMethod = readMethod;
    this.writeMethod = writeMethod;
  }

  ListenableFuture<Void> startWriteTransferAsClient(int resourceId,
      int transferTimeoutMillis,
      int initialTransferTimeoutMillis,
      int maxRetries,
      byte[] data,
      Consumer<TransferProgress> progressCallback,
      BooleanSupplier shouldAbortCallback) {
    WriteTransfer transfer = new WriteTransfer(resourceId,
        new TransferInterface() {
          @Override
          Call.ClientStreaming<Chunk> getStream() throws ChannelOutputException {
            if (writeStream == null) {
              writeStream = writeMethod.invokeBidirectionalStreaming(new ChunkHandler() {
                @Override
                void resetStream() {
                  writeStream = null;
                }
              });
            }
            return writeStream;
          }
        },
        transferTimeoutMillis,
        initialTransferTimeoutMillis,
        maxRetries,
        data,
        progressCallback,
        shouldAbortCallback);
    startTransferAsClient(transfer);
    return transfer.getFuture();
  }

  ListenableFuture<byte[]> startReadTransferAsClient(int resourceId,
      int transferTimeoutMillis,
      int initialTransferTimeoutMillis,
      int maxRetries,
      TransferParameters parameters,
      Consumer<TransferProgress> progressCallback,
      BooleanSupplier shouldAbortCallback) {
    ReadTransfer transfer = new ReadTransfer(resourceId,
        new TransferInterface() {
          @Override
          Call.ClientStreaming<Chunk> getStream() throws ChannelOutputException {
            if (readStream == null) {
              readStream = readMethod.invokeBidirectionalStreaming(new ChunkHandler() {
                @Override
                void resetStream() {
                  readStream = null;
                }
              });
            }
            return readStream;
          }
        },
        transferTimeoutMillis,
        initialTransferTimeoutMillis,
        maxRetries,
        parameters,
        progressCallback,
        shouldAbortCallback);
    startTransferAsClient(transfer);
    return transfer.getFuture();
  }

  private void startTransferAsClient(Transfer<?> transfer) {
    enqueueEvent(() -> {
      if (transfers.put(transfer.getResourceId(), transfer) != null) {
        transfer.cleanUp(new TransferError("A transfer for resource ID " + transfer.getResourceId()
                + " is already in progress! Only one read/write transfer per resource is supported at a time",
            Status.ALREADY_EXISTS));
        return;
      }
      transfer.start();
    });
  }

  /** Handles events until stop() is called. */
  void run() {
    while (processEvents) {
      handleNextEvent();
    }
  }

  /** Stops the transfer event handler from processing events. */
  void stop() {
    enqueueEvent(() -> {
      logger.atFine().log("Terminating TransferEventHandler");
      transfers.values().forEach(Transfer::handleTermination);
      processEvents = false;
    });
  }

  /** Blocks until all events currently in the queue are processed; for test use only. */
  void waitUntilEventsAreProcessedForTest() {
    Semaphore semaphore = new Semaphore(0);
    enqueueEvent(semaphore::release);
    try {
      semaphore.acquire();
    } catch (InterruptedException e) {
      throw new AssertionError("Unexpectedly interrupted", e);
    }
  }

  private void enqueueEvent(Event event) {
    while (true) {
      try {
        events.put(event);
        return;
      } catch (InterruptedException e) {
        // Ignore and keep trying.
      }
    }
  }

  private void handleNextEvent() {
    final long sleepFor = TIME_UNIT.between(Instant.now(), getNextTimeout());
    try {
      Event event = events.poll(sleepFor, POLL_TIME_UNIT);
      if (event != null) {
        event.handle();
      }
    } catch (InterruptedException e) {
      // If interrupted, check for timeouts anyway.
    }

    for (Transfer<?> transfer : transfers.values()) {
      transfer.handleTimeoutIfDeadlineExceeded();
    }
  }

  private Instant getNextTimeout() {
    Optional<Transfer<?>> transfer =
        transfers.values().stream().min(Comparator.comparing(Transfer::getDeadline));
    return transfer.isPresent() ? transfer.get().getDeadline() : Transfer.NO_TIMEOUT;
  }

  /** This interface gives a Transfer access to the TransferEventHandler. */
  abstract class TransferInterface {
    private TransferInterface() {}

    /**
     *  Sends the provided transfer chunk.
     *
     *  Must be called on the transfer therad.
     */
    void sendChunk(Chunk chunk) throws TransferError {
      try {
        getStream().send(chunk);
      } catch (ChannelOutputException | RpcError e) {
        throw new TransferError("Failed to send chunk for write transfer", e);
      }
    }

    /**
     *  Removes this transfer from the list of active transfers.
     *
     *  Must be called on the transfer therad.
     */
    void unregisterTransfer(int sessionId) {
      transfers.remove(sessionId);
    }

    /**
     * Initiates the cancellation process for the provided transfer.
     *
     * May be called from any thread.
     */
    void cancelTransfer(Transfer<?> transfer) {
      enqueueEvent(transfer::handleCancellation);
    }

    /** Gets either the read or write stream. */
    abstract Call.ClientStreaming<Chunk> getStream() throws ChannelOutputException;
  }

  /** Handles responses on the pw_transfer RPCs. */
  private abstract class ChunkHandler implements StreamObserver<Chunk> {
    @Override
    public final void onNext(Chunk chunk) {
      enqueueEvent(() -> {
        Transfer<?> transfer = transfers.get(chunk.getTransferId());
        if (transfer != null) {
          logger.atFinest().log(
              "Transfer %d received chunk: %s", transfer.getSessionId(), chunkToString(chunk));
          transfer.handleChunk(chunk);
        } else {
          logger.atWarning().log(
              "Ignoring unrecognized transfer session ID %d", chunk.getTransferId());
        }
      });
    }

    @Override
    public final void onCompleted(Status status) {
      onError(Status.INTERNAL); // This RPC should never complete: treat as an internal error.
    }

    @Override
    public final void onError(Status status) {
      enqueueEvent(() -> {
        resetStream();

        // The transfers remove themselves from the Map during cleanup, iterate over a copied list.
        List<Transfer<?>> activeTransfers = new ArrayList<>(transfers.values());

        // FAILED_PRECONDITION indicates that the stream packet was not recognized as the stream is
        // not open. This could occur if the server resets. Notify pending transfers that this has
        // occurred so they can restart.
        if (status.equals(Status.FAILED_PRECONDITION)) {
          activeTransfers.forEach(Transfer::handleDisconnection);
        } else {
          TransferError error = new TransferError(
              "Transfer stream RPC closed unexpectedly with status " + status, Status.INTERNAL);
          activeTransfers.forEach(t -> t.cleanUp(error));
        }
      });
    }

    abstract void resetStream();
  }

  private static String chunkToString(Chunk chunk) {
    StringBuilder str = new StringBuilder();
    str.append("transferId:").append(chunk.getTransferId()).append(" ");
    str.append("windowEndOffset:").append(chunk.getWindowEndOffset()).append(" ");
    str.append("offset:").append(chunk.getOffset()).append(" ");
    // Don't include the actual data; it's too much.
    str.append("len(data):").append(chunk.getData().size()).append(" ");
    if (chunk.hasPendingBytes()) {
      str.append("pendingBytes:").append(chunk.getPendingBytes()).append(" ");
    }
    if (chunk.hasMaxChunkSizeBytes()) {
      str.append("maxChunkSizeBytes:").append(chunk.getMaxChunkSizeBytes()).append(" ");
    }
    if (chunk.hasMinDelayMicroseconds()) {
      str.append("minDelayMicroseconds:").append(chunk.getMinDelayMicroseconds()).append(" ");
    }
    if (chunk.hasRemainingBytes()) {
      str.append("remainingBytes:").append(chunk.getRemainingBytes()).append(" ");
    }
    if (chunk.hasStatus()) {
      str.append("status:").append(chunk.getStatus()).append(" ");
    }
    if (chunk.hasType()) {
      str.append("type:").append(chunk.getTypeValue()).append(" ");
    }
    if (chunk.hasResourceId()) {
      str.append("resourceId:").append(chunk.getSessionId()).append(" ");
    }
    if (chunk.hasSessionId()) {
      str.append("sessionId:").append(chunk.getSessionId()).append(" ");
    }
    return str.toString();
  }

  // Represents an event that occurs during a transfer
  private interface Event {
    void handle();
  }
}
