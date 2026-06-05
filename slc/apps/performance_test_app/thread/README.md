# Matter over Thread Performance Test Example

Matter performance testing via "perf ping" and "perf mx" Matter Shell commands. Sender and receiver use the Performance Testing cluster on Endpoint 1.

## Table of Contents

- [Purpose/Scope](#purposescope)
- [Prerequisites/Setup Requirements](#prerequisitessetup-requirements)
- [Steps to Run Demo](#steps-to-run-demo)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)
- [Report Bugs & Get Support](#report-bugs--get-support)

## Purpose/Scope

This example enables Matter performance testing on Silicon Labs EFR32 SoC over Thread. The **perf ping** and **perf mx** Matter Shell CLI commands send the EmptyCommand to the custom Performance Testing cluster on Endpoint 1 of the destination node. For ping, the command is sent to a destination NodeId and the response is the ping reply. For multicast, the command is sent to a groupId with no response expected. The node issuing commands is the "sender", the node processing the command is the "receiver."

The device is commissioned over BLE. Credentials are then provided so the device joins the Thread network. Enable the functionality by installing the Performance Testing Utilities and CLI component and adding the custom Performance Testing cluster (see [Defining a Custom Cluster](https://docs.silabs.com/matter/2.9.0/matter-references/matter-zap#defining-a-custom-cluster)), cluster XML: [`performance-test-cluster.xml`](https://github.com/SiliconLabsSoftware/matter_extension/blob/v2.8.1/slc/apps/performance-test-app/thread/performance-test-cluster.xml). For multicast, enable the Groups cluster server on Endpoint 1 in ZAP.

**Commands:** `perf ping <count> <fabricIndex> <destNodeId> <timeout_ms>`,`perf mx <fabricIndex> <destGroupId> <sequence number>`.

## Prerequisites/Setup Requirements

### HW Requirements

For a full list of hardware requirements, see [Matter Hardware Requirements](https://docs.silabs.com/matter/2.9.0/matter-overview/#hardware-requirements) documentation.

### SW Requirements

For a full list of software requirements, see [Matter Software Requirements](https://docs.silabs.com/matter/2.9.0/matter-overview/#software-requirements) documentation.

## Steps to Run Demo

### Program a Bootloader

If building a solution, the bootloader is included and flashed as part of the combined artifact.

If building the sample application on its own, a bootloader must be flashed separately before the application. Pre-built bootloader binaries for all supported devices are available at [Matter Bootloader Binaries](https://docs.silabs.com/matter/2.9.0/matter-prerequisites/matter-artifacts#matter-bootloader-binaries).

### Configuration and Setup

**Enabling the functionality**

- **Simplicity Studio:** Create a Matter over Thread project. Install the Performance Testing Utilities component under _Silicon Labs Matter > Platform_. In ZAP (Configuration Tools > Zigbee Cluster Configurator) enable the Groups cluster server on Endpoint 1 (required for multicast). Add the custom Performance Testing cluster per [Defining a Custom Cluster](https://docs.silabs.com/matter/2.9.0/matter-references/matter-zap#defining-a-custom-cluster), cluster XML: [`performance-test-cluster.xml`](https://github.com/SiliconLabsSoftware/matter_extension/blob/v2.8.1/slc/apps/performance-test-app/thread/performance-test-cluster.xml). Build, the same binary can act as sender and receiver.
- **SLC CLI:** In a Thread sample app, edit the ZAP file (see project .slcp), set Groups server enabled on the  endpoint 1, add the custom Performance Testing cluster as above, then run `slc generate` with `--with "matter_performance_testing"`. The same binary can act as sender and receiver.

See [Custom Matter Device Development](https://docs.silabs.com/matter/2.9.0/matter-references/custom-matter-device#custom-matter-device-development) for customization.

### Steps for Execution

1. Build and flash the bootloader and application to your board. The same binary can act as sender and receiver.
2. Commission sender and receiver to the same Thread network.
3. **Ping:** On the receiver, add an ACL entry that grants the sender management privileges to Endpoint 1. Example:
   ```shell
   chip-tool accesscontrol write acl '[{"fabricIndex": 1, "privilege": 5, "authMode": 2, "subjects": null, "targets": null}]' <receiverNodeId> 1
   ```
   On the sender, run `perf ping <count> <fabricIndex> <destNodeId> <timeout_ms>`. The sender establishes a CASE session and sends EmptyCommand. When the count is done it prints e.g. "Ping: 44 packets transmitted, 44 packets received." Ping and multicast both print a sequence number to the PTI channel (ping uses 1729).
4. **Multicast:** Create the same group and group key set on sender and receiver, then add an ACL on the receiver for the group. Example for Group 257 (run on sender then receiver, use your node IDs):
   ```shell
   chip-tool groupkeymanagement key-set-write '{"groupKeySetID": 42, "groupKeySecurityPolicy": 0, "epochKey0": "d0d1d2d3d4d5d6d7d8d9dadbdcdddedf", "epochStartTime0": 2220000, "epochKey1": "d1d1d2d3d4d5d6d7d8d9dadbdcdddedf", "epochStartTime1": 2220001, "epochKey2": "d2d1d2d3d4d5d6d7d8d9dadbdcdddedf", "epochStartTime2": 2220002}' <nodeId> 1
   chip-tool groupkeymanagement write group-key-map '[{"groupId": 257, "groupKeySetID": 42}]' <nodeId> 1
   chip-tool groups add-group 257 "GroupName" <nodeId> 1
   ```
   On the receiver only, add ACL for the group:
   ```shell
   chip-tool accesscontrol write acl '[{"fabricIndex": 1, "privilege": 5, "authMode": 2, "subjects": null, "targets": null},{"fabricIndex": 1, "privilege": 4, "authMode": 3, "subjects": [257], "targets": null}]' <receiverNodeId> 1
   ```
   On the sender, run `perf mx <fabricIndex> <destGroupId> <sequence>`. Multicast sends EmptyCommand to the group address with no response expected.

**Button and LED reference:**

This app focuses on performance-test CLI commands, button/LED behavior follows the base Matter platform (e.g. LED 0 for commissioning state if WSTK LED Support is installed).

## Troubleshooting

**Ping or multicast fails**
- Ensure sender and receiver are on the same fabric and Thread network.
- For ping, verify the receiver ACL grants the sender management access to Endpoint 1.
- For multicast, verify group key set and group membership match on both nodes and receiver ACL allows the group.

**Commissioning fails**
- Ensure the Thread Border Router is running and the `operationalDataset` matches your network.

**LCD or LEDs not working**
- **LCD:** If the board supports an LCD but it is not enabled, install the _Display_ component under _Silicon Labs Matter > Matter > Platform > Display_. For the QR code on the LCD, install the _QR Code_ component under _Silicon Labs Matter > Matter > Platform > QR Code_ (Display is installed automatically).
- **LEDs:** If the board supports LEDs but they are not enabled, install `led0` and `led1` instances of _Simple LED_ under _Platform > Driver > LED > Simple LED_, then install _WSTK LED Support_ under _Silicon Labs Matter > Matter > Platform > WSTK LED Support_.

## Resources

- [Silicon Labs Matter over Thread Documentation](https://docs.silabs.com/matter/2.9.0/matter-thread)
- [Matter Hub Setup](https://docs.silabs.com/matter/2.9.0/matter-thread/raspi-img)
- [chip-tool README](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md)

## Report Bugs & Get Support

You are always encouraged and welcome to report any issues you found to us via [Silicon Labs Community](https://community.silabs.com).
