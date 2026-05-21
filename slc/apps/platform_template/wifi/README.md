# Matter over Wi-Fi Platform Template Example

A minimal Matter over Wi-Fi platform example with essential clusters on Silicon Labs SiWx917 SoC. Foundation for building Matter applications.

## Table of Contents

- [Purpose/Scope](#purposescope)
- [Prerequisites/Setup Requirements](#prerequisitessetup-requirements)
- [Steps to Run Demo](#steps-to-run-demo)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)
- [Report Bugs & Get Support](#report-bugs--get-support)

## Purpose/Scope

This example demonstrates a minimal Matter platform implementation on Silicon Labs SiWx917 SoC devices. It provides the essential Matter clusters required for commissioning, network management, and basic device operation over Wi-Fi. This platform app serves as a foundation for building more complex Matter applications.

The device is commissioned over Bluetooth Low Energy (BLE), during which the Matter controller and device exchange security credentials in the Rendez-vous procedure. Wi-Fi credentials (SSID and PSK) are then provided so the device joins your Wi-Fi network and can be controlled by any Matter-compliant controller.

**Supported clusters:** Root Node (Endpoint 0): Base, Access Control, Access Control Enforcement, Administrator Commissioning, General Diagnostics, General Commissioning, Group Communication, Localization Configuration, Network Commissioning, Node Operational Credentials, Secure Channel, WiFi Network Diagnostic, Time Format Localization. Endpoint 1: Groups.

**Customizing:** You can add Matter clusters by modifying the ZAP configuration and regenerating the data model. Configuration options (network commissioning, device identification, diagnostic intervals, security) can be adjusted via component configuration files. Build steps are documented in the project root README (e.g. `python3 slc/sl_build.py MyNewApp/platform-app-917.slcw brd4338a`).

## Prerequisites/Setup Requirements

### HW Requirements

For a full list of hardware requirements, see [Matter Hardware Requirements](https://docs.silabs.com/matter/2.9.0/matter-overview/#hardware-requirements) documentation.

### SW Requirements

For a full list of software requirements, see [Matter Software Requirements](https://docs.silabs.com/matter/2.9.0/matter-overview/#software-requirements) documentation. Host build prerequisites include ARM GCC 12.2, ZAP (2024.05.07 or greater), SLC-CLI, and environment variables (ARM_GCC_DIR, TOOLDIR, STUDIO_ADAPTER_PACK_PATH).

## Steps to Run Demo

### Configuration and Setup

This sample app works out of the box with no additional configuration required. To customize the device, see the [Custom Matter Device Development](https://docs.silabs.com/matter/2.9.0/matter-references/custom-matter-device#custom-matter-device-development) guide.

**Building:** Build steps are in the project root README. Example (Linux/Mac): `python3 slc/sl_build.py MyNewApp/platform-app-917.slcw brd4338a`.

**Expected behaviour:** After build and flash, the device advertises over BLE and shows the Matter QR code if the display is enabled. Once commissioned, the device can be managed through Matter controllers over Wi-Fi for configuration and monitoring.

**Region code (SiWx917 Wi-Fi):** For Wi-Fi configurations, the region code can be set in this [file](https://github.com/SiliconLabsSoftware/matter_sdk/blob/v2.9.0/src/platform/silabs/wifi/SiWx/WifiInterfaceImpl.cpp). The available region codes can be found [here](https://github.com/SiliconLabs/wiseconnect/blob/v4.1.0-content-for-docs/components/protocol/wifi/inc/sl_wifi_constants.h#L739).

### Steps for Execution

1. Build and flash the application to your board (see project root README for build commands).
2. On startup, the device advertises over BLE and shows the Matter QR code if the display is enabled.
3. Commission the device using chip-tool, Simplicity Connect, or another Matter controller (e.g. `chip-tool pairing ble-wifi 1 <SSID> <PSK> 20202021 3840`).
4. After commissioning, the device can be managed through Matter controllers over Wi-Fi for configuration and monitoring.

**Button and LED reference:**

This app does not define application-specific buttons or LEDs. If WSTK LED Support is installed, LED 0 may indicate commissioning/connectivity state.

## Troubleshooting

**Device does not advertise over BLE**
- Restart the device and ensure the application is flashed correctly.

**Commissioning fails**
- Ensure the Wi-Fi SSID and PSK are correct and the network is reachable.
- Verify the region code is set appropriately for your locale.

**LCD or LEDs not working**
- **LCD:** If the board supports an LCD but it is not enabled, install the _Display_ component under _Silicon Labs Matter > Matter > Platform > Display_. For the QR code on the LCD, install the _QR Code_ component under _Silicon Labs Matter > Matter > Platform > QR Code_ (Display is installed automatically).
- **LEDs:** If the board supports LEDs but they are not enabled, install `led0` and `led1` instances of _Simple LED_ under _Platform > Driver > LED > Simple LED_, then install _WSTK LED Support_ under _Silicon Labs Matter > Matter > Platform > WSTK LED Support_.

## Resources

- [Silicon Labs Matter over Wi-Fi Documentation](https://docs.silabs.com/matter/2.9.0/matter-wifi)
- [Matter Hub Setup](https://docs.silabs.com/matter/2.9.0/matter-thread/raspi-img)
- [chip-tool README](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md)

## Report Bugs & Get Support

You are always encouraged and welcome to report any issues you found to us via [Silicon Labs Community](https://community.silabs.com).
