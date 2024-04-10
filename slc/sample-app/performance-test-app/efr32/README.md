# Matter Performance Testing

## Overview

Matter Performance Testing commands are the "perf ping" and "perf mx" Matter Shell CLI commands. Both tests send the EmptyCommand command to the custom Performance Testing cluster in the Endpoint 0 of the destination node. In case of ping the command is sent to the destination NodeId and the command response is considered a ping reply. In the case of multicast the command is sent to a groupId, no response is expected.

The node where the Matter Shell CLI commands are issued is referred to as "sender". The node that is supposed to process the command is referred to as "receiver".

The Performance Testing commands are enabled on the sender and receiver nodes by installing the Performance Testing Utilities and CLI (matter_performance_testing.slcc) component in a Studio or SLC Matter project.

## Commands
-   `perf ping <count> <fabricIndex> <destNodeId> <timeout_ms>`
    - count: Number of commands to send
    - fabricIndex: Fabric index on the sender node
    - destNodeId:  Receiver Node ID
    - timeout_ms: Timeout in milliseconds before an individual ping (EmptyCommand) command is considered to have failed

-   `perf mx <fabricIndex> <destGroupId> <sequence number>`
    - fabricIndex: Fabric index on the sender node
    - destNodeId:  Group ID the command is sent to
    - sequence number: Sequence number (uint16_t) that will be printed to the PTI debug channel (with EM_DEBUG_LATENCY and "BBD" parameters) by the sender and the receiver node.

## Enabling the functionality

- Simplicity Studio: Create any Matter over Thread project. Install the Performance Testing Utilities component under Silicon Labs Matter->Platform. In ZAP ( Configuration Tools -> Zigbee Cluster Configurator) enable the Groups cluster server on Endpoint 0 (this step is only needed for the multicast command). Build the project, the resulting binary can be used as both the sender and the receiver.

- SLC CLI: In any Thread sample app edit the ZAP file specified in the project's .slcp file under config_file and set "enabled:" to 1 in the "Groups" "server" cluster entry in the "MA-rootdevice" endpoint array entry. Generate the project supplying the `--with "matter_performance_testing;matter"` parameter to the `slc generate` command. The resulting binary can be used as both the sender and the receiver.

## Network Configuration
### Ping
The ping command requires an ACL entry on the receiver that gives the sender management privileges to the Endpoint 0 connecting over CASE sessions; this can be configured through the standard Matter commands, there is nothing specific to performance testing.

Receiver:
For example, the following ACL gives management privileges to all nodes (subjects) and all clusters:

              ./out/chip-tool accesscontrol write acl '[{"fabricIndex": 1, "privilege": 5, "authMode": 2, "subjects": null, "targets": null }]' <receiver NodeId> 0

### Multicast
The multicast command requires that: (1) A group is created both on the sender and the receiver and (2) An ACL entry exists on the receiver to that gives the sender management privileges to the Endpoint 0 connecting over the group. This can be configured through the standard Matter commands, there is nothing specific to performance testing. The following is a set of example commands that configure Group 257 and the corresponding ACL


Sender:

            ./out/chip-tool groupkeymanagement key-set-write '{"groupKeySetID": 42,   "groupKeySecurityPolicy": 0, "epochKey0":    "d0d1d2d3d4d5d6d7d8d9dadbdcdddedf", "epochStartTime0": 2220000,"epochKey1":   "d1d1d2d3d4d5d6d7d8d9dadbdcdddedf", "epochStartTime1": 2220001,"epochKey2":   "d2d1d2d3d4d5d6d7d8d9dadbdcdddedf", "epochStartTime2": 2220002 }' <sender NodeId> 0

            ./out/chip-tool groupkeymanagement write group-key-map '[{"groupId": 257, "groupKeySetID": 42}]' <sender NodeId> 0

            ./out/chip-tool groups add-group 257 "GroupName" <sender NodeId> 0


Receiver:

            ./out/chip-tool groupkeymanagement key-set-write '{"groupKeySetID": 42,   "groupKeySecurityPolicy": 0, "epochKey0":    "d0d1d2d3d4d5d6d7d8d9dadbdcdddedf", "epochStartTime0": 2220000,"epochKey1":   "d1d1d2d3d4d5d6d7d8d9dadbdcdddedf", "epochStartTime1": 2220001,"epochKey2":   "d2d1d2d3d4d5d6d7d8d9dadbdcdddedf", "epochStartTime2": 2220002 }' <receiver NodeId> 0

            ./out/chip-tool groupkeymanagement write group-key-map '[{"groupId": 257, "groupKeySetID": 42}]' <receiver NodeId> 0

            ./out/chip-tool groups add-group 257 "GroupName" <receiver NodeId> 0

            ./out/chip-tool accesscontrol write acl '[{ "fabricIndex": 1, "privilege": 5,  "authMode": 2, "subjects": null,"targets": null},{"fabricIndex": 1, "privilege": 4, "authMode": 3, "subjects": [257], "targets": null}]' <receiver NodeId> 0

## Implementation

In the ping command the sender establishes a CASE session with the receiver and transmits an EmptyCommand command. When a response is received the next EmptyCommand command is sent, etc. When the <count> number of commands have been transmitted the sender prints the following text to the Matter Shell:

            Ping: 44 packets transmitted, 44 packets received.

In the multicast case there is no CASE session, the command is sent directly to the group address, no response is expected.

For ping and multicast tests both sender and receiver print a packet sequence number to the PTI channel: for multicast the sequence number is the <sequence number> command parameter, for ping it is the magic number 1729.

 
