#!/usr/bin/env python3
# Copyright 2022 The Pigweed Authors
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.
"""Python client for pw_transfer integration test."""

import logging
import socket
import sys

from google.protobuf import text_format
from pw_hdlc.rpc import HdlcRpcClient, default_channels
import pw_transfer
from pigweed.pw_transfer import transfer_pb2
from pigweed.pw_transfer.integration_test import config_pb2

_LOG = logging.getLogger('pw_transfer_integration_test_python_client')
_LOG.level = logging.DEBUG
_LOG.addHandler(logging.StreamHandler(sys.stdout))

HOSTNAME: str = "localhost"


def _main() -> int:
    if len(sys.argv) != 2:
        _LOG.critical("Usage: PORT")
        return 1

    # The port is passed via the command line.
    try:
        port = int(sys.argv[1])
    except:
        _LOG.critical("Invalid port specified.")
        return 1

    # Load the config from stdin.
    try:
        text_config = sys.stdin.buffer.read()
        config = text_format.Parse(text_config, config_pb2.ClientConfig())
    except Exception as e:
        _LOG.critical("Failed to parse config file from stdin: %s", e)
        return 1

    # Open a connection to the server.
    try:
        rpc_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        rpc_socket.connect((HOSTNAME, port))
    except:
        _LOG.critical("Failed to connect to server at %s:%d", HOSTNAME, port)
        return 1

    # Initialize an RPC client over the socket and set up the pw_transfer manager.
    rpc_client = HdlcRpcClient(
        lambda: rpc_socket.recv(4096), [transfer_pb2],
        default_channels(lambda data: rpc_socket.sendall(data)),
        lambda data: _LOG.info("%s", str(data)))
    transfer_service = rpc_client.rpcs().pw.transfer.Transfer
    transfer_manager = pw_transfer.Manager(
        transfer_service,
        default_response_timeout_s=config.chunk_timeout_ms / 1000,
        initial_response_timeout_s=config.initial_chunk_timeout_ms / 1000,
        max_retries=config.max_retries,
    )

    # Perform the requested transfer actions.
    for action in config.transfer_actions:
        if action.transfer_type == config_pb2.TransferAction.TransferType.WRITE_TO_SERVER:
            try:
                with open(action.file_path, 'rb') as f:
                    data = f.read()
            except:
                _LOG.critical("Failed to read input file '%s'",
                              action.file_path)
                return 1

            try:
                transfer_manager.write(action.resource_id, data)
            except:
                _LOG.exception("Transfer (write to server) failed")
                return 1
        elif action.transfer_type == config_pb2.TransferAction.TransferType.READ_FROM_SERVER:
            try:
                data = transfer_manager.read(action.resource_id)
            except:
                _LOG.exception("Transfer (read from server) failed")
                return 1

            try:
                with open(action.file_path, 'wb') as f:
                    f.write(data)
            except:
                _LOG.critical("Failed to write output file '%s'",
                              action.file_path)
                return 1
        else:
            _LOG.critical("Unknown transfer type: %d", action.transfer_type)
            return 1

    _LOG.info("All transfers completed successfully")
    return 0


if __name__ == '__main__':
    sys.exit(_main())
