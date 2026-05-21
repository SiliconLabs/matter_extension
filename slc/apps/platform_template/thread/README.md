# Matter over Thread Platform Template Example

A minimal Matter over Thread platform example with essential clusters on Silicon Labs MG24/MG26 and Rainier. Foundation for building Matter applications.

## Table of Contents

- [Purpose/Scope](#purposescope)
- [Prerequisites/Setup Requirements](#prerequisitessetup-requirements)
- [Steps to Run Demo](#steps-to-run-demo)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)
- [Report Bugs & Get Support](#report-bugs--get-support)

## Purpose/Scope

This example demonstrates a minimal Matter platform implementation on Silicon Labs EFR32 (MG24/MG26) devices. It provides the essential Matter clusters required for commissioning, network management, and basic device operation over Thread. This platform app serves as a foundation for building more complex Matter applications.

The device is commissioned over Bluetooth Low Energy (BLE), during which the Matter controller and device exchange security credentials in the Rendez-vous procedure.

**Supported clusters:** Root Node (Endpoint 0): Base, Access Control, Access Control Enforcement, Administrator Commissioning, General Diagnostics, General Commissioning, Group Communication, Localization Configuration, Network Commissioning, Node Operational Credentials, Secure Channel, Thread Network Diagnostic, Time Format Localization. Endpoint 1: Groups.

**Customizing:** You can add Matter clusters by modifying the ZAP configuration and regenerating the data model. Configuration options (network commissioning, device identification, diagnostic intervals, security) can be adjusted via component configuration files. Build steps are documented in the project root README (e.g. `python3 slc/sl_build.py MyNewApp/platform-app.slcw brd4187c`).

## Prerequisites/Setup Requirements

### HW Requirements

For a full list of hardware requirements, see [Matter Hardware Requirements](https://docs.silabs.com/matter/2.9.0/matter-overview/#hardware-requirements) documentation.

### SW Requirements

For a full list of software requirements, see [Matter Software Requirements](https://docs.silabs.com/matter/2.9.0/matter-overview/#software-requirements) documentation. Host build prerequisites include ARM GCC 12.2, ZAP (2024.05.07 or greater), SLC-CLI, and environment variables (ARM_GCC_DIR, TOOLDIR, STUDIO_ADAPTER_PACK_PATH).

## Steps to Run Demo

### Program a Bootloader

If building a solution, the bootloader is included and flashed as part of the combined artifact.

If building the sample application on its own, a bootloader must be flashed separately before the application. Pre-built bootloader binaries for all supported devices are available at [Matter Bootloader Binaries](https://docs.silabs.com/matter/2.9.0/matter-prerequisites/matter-artifacts#matter-bootloader-binaries).

### Configuration and Setup

This sample app works out of the box with no additional configuration required. To customize the device, see the [Custom Matter Device Development](https://docs.silabs.com/matter/2.9.0/matter-references/custom-matter-device#custom-matter-device-development) guide.

**Building:** Build steps are in the project root README. Example (Linux/Mac): `python3 slc/sl_build.py MyNewApp/platform-app.slcw brd4187c`.

**Expected behaviour:** After build and flash, the device advertises over BLE and shows the Matter QR code if the display is enabled. Once commissioned, the device can be managed through Matter controllers for configuration and monitoring.

### Steps for Execution

1. Build and flash the bootloader and application to your board (see project root README for build commands).
2. On startup, the device advertises over BLE and shows the Matter QR code if the display is enabled.
3. Commission the device using chip-tool, Simplicity Connect, or another Matter controller (e.g. `chip-tool pairing ble-thread 1 hex:<operationalDataset> 20202021 3840`).
4. After commissioning, the device can be managed through Matter controllers for configuration and monitoring.

**Button and LED reference:**

This app does not define application-specific buttons or LEDs. If WSTK LED Support is installed, LED 0 may indicate commissioning/connectivity state.

## Troubleshooting

**Device does not advertise over BLE**
- Confirm the bootloader is flashed to the device.

**Commissioning fails**
- Ensure the Thread Border Router is running and reachable.
- Verify the `operationalDataset` hex string matches your Thread network.

**LCD or LEDs not working**
- **LCD:** If the board supports an LCD but it is not enabled, install the _Display_ component under _Silicon Labs Matter > Matter > Platform > Display_. For the QR code on the LCD, install the _QR Code_ component under _Silicon Labs Matter > Matter > Platform > QR Code_ (Display is installed automatically).
- **LEDs:** If the board supports LEDs but they are not enabled, install `led0` and `led1` instances of _Simple LED_ under _Platform > Driver > LED > Simple LED_, then install _WSTK LED Support_ under _Silicon Labs Matter > Matter > Platform > WSTK LED Support_.

## Resources

- [Silicon Labs Matter over Thread Documentation](https://docs.silabs.com/matter/2.9.0/matter-thread)
- [Matter Hub Setup](https://docs.silabs.com/matter/2.9.0/matter-thread/raspi-img)
- [chip-tool README](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md)

## Report Bugs & Get Support

You are always encouraged and welcome to report any issues you found to us via [Silicon Labs Community](https://community.silabs.com).
