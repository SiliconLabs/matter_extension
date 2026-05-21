# Matter over Wi-Fi Thermostat Example

The Matter over Wi-Fi thermostat example is a baseline demonstration of a thermostat built with Simplicity SDK. It can be controlled by a Matter controller over a Wi-Fi network.

## Table of Contents

- [Matter over Wi-Fi Thermostat Example](#matter-over-wi-fi-thermostat-example)
  - [Table of Contents](#table-of-contents)
  - [Purpose/Scope](#purposescope)
  - [Prerequisites/Setup Requirements](#prerequisitessetup-requirements)
    - [HW Requirements](#hw-requirements)
    - [SW Requirements](#sw-requirements)
  - [Steps to Run Demo](#steps-to-run-demo)
    - [Configuration and Setup](#configuration-and-setup)
    - [Steps for Execution](#steps-for-execution)
  - [Troubleshooting](#troubleshooting)
  - [Resources](#resources)
  - [Report Bugs \& Get Support](#report-bugs--get-support)

## Purpose/Scope

This example provides a baseline demonstration of a thermostat device, built using Matter and the Silicon Labs Simplicity SDK. It can be controlled by a Matter controller over a Wi-Fi network.

The device can be commissioned over Bluetooth Low Energy, the device and the Matter controller exchange security information in the Rendez-vous procedure.

If the LCD is enabled, the LCD on the Silicon Labs WSTK shows a QR code containing the commissioning information for the BLE connection and Rendez-vous procedure.

This example is intended to serve both as a means to explore Matter and as a template for creating real products based on the Silicon Labs platform.

For general information on running Matter applications and prerequisites, see the [Matter Wi-Fi documentation](https://docs.silabs.com/matter/2.9.0/matter-wifi) on docs.silabs.com.

## Prerequisites/Setup Requirements

### HW Requirements

For a full list of hardware requirements, see [Matter Hardware Requirements](https://docs.silabs.com/matter/2.9.0/matter-overview/#hardware-requirements) documentation.

### SW Requirements

For a full list of software requirements, see [Matter Software Requirements](https://docs.silabs.com/matter/2.9.0/matter-overview/#software-requirements) documentation.

## Steps to Run Demo

### Configuration and Setup

This sample app works out of the box with no additional configuration required. To customize the device, see the [Custom Matter Device Development](https://docs.silabs.com/matter/2.9.0/matter-references/custom-matter-device#custom-matter-device-development) guide.

**Region code (SiWx917 Wi-Fi):** In Wi-Fi configurations, the region code can be set in this [file](https://github.com/SiliconLabsSoftware/matter_sdk/blob/v2.9.0/src/platform/silabs/wifi/SiWx/WifiInterfaceImpl.cpp). The available region codes can be found [here](https://github.com/SiliconLabs/wiseconnect/blob/v4.1.0-content-for-docs/components/protocol/wifi/inc/sl_wifi_constants.h#L739).

### Steps for Execution

1. Build and flash the application to your board.
2. On startup, **LED 0** flashes short-on (50 ms on / 950 ms off), indicating the
   device is waiting for commissioning.
3. Commission the device using one of the following methods:

   **chip-tool (standalone or pre-built):** The pre-built chip-tool instance ships
   with the Matter Hub image. More information on using the Matter Hub is in the
   [Silicon Labs Matter Hub Documentation](https://docs.silabs.com/matter/2.9.0/matter-thread/raspi-img).
   ```shell
   chip-tool pairing ble-wifi <node-id> $SSID $PSK <PinCode> <Discriminator>
   chip-tool pairing ble-wifi 1 $SSID $PSK 20202021 3840
   ```

   **Simplicity Connect mobile app:** Scan the QR code shown on the LCD or the URL
   printed to RTT logs on startup or by pressing BTN0. The URL can also be retrieved
   via the Matter shell:
   ```shell
   matterCli> onboardingcodes ble qrcodeurl
   ```
   Example RTT log output:
   ```
   [SVR] Copy/paste the below URL in a browser to see the QR Code:
   [SVR] https://project-chip.github.io/connectedhomeip/qrcode.html?data=MT%3A6FCJ142C00KA0648G00
   ```
   This QR code is only valid for an unprovisioned device, provisioning may change it.

   **Other:** The device can also be provisioned and controlled using the Python controller, Android, or iOS app.

4. Read or write thermostat attributes. Examples:

   Setting the occupied cooling setpoint:
   ```shell
   ./chip-tool thermostat write occupied-cooling-setpoint <temperature> <node-id> <endpoint-id>
   ./chip-tool thermostat write occupied-cooling-setpoint 2500 1 1
   ```
   On chip-tool, verify that the DUT sends a success response. Example:
   ```
   [1676031143.386639][19597:19599] CHIP:DMG:                         StatusIB =
   [1676031143.386683][19597:19599] CHIP:DMG:                         {
   [1676031143.386729][19597:19599] CHIP:DMG:                                 status = 0x00 (SUCCESS),
   [1676031143.386773][19597:19599] CHIP:DMG:                         },
   ```

   Read thermostat attributes:
   ```shell
   ./chip-tool thermostat read occupied-cooling-setpoint <node-id> <endpoint-id>
   ./chip-tool thermostat read occupied-cooling-setpoint 1 1
   ```
   On chip-tool, verify the occupied cooling setpoint attribute value. Example:
   ```
   [1676028659.980049][19359:19361] CHIP:TOO:   OccupiedCoolingSetpoint: 2500
   ```

**Button and LED reference:**

| Control | Action            | Result                                                          |
|---------|-------------------|-----------------------------------------------------------------|
| BTN0    | Press and release | Start/restart BLE advertisement, print QR code URL to RTT logs |
| BTN0    | Hold 6 s          | Initiate factory reset (release within 6 s to cancel)          |
| LED 0   | Short flash on    | Unprovisioned, waiting for commissioning                        |
| LED 0   | Rapid even flash  | BLE connected, commissioning in progress                        |
| LED 0   | Short flash off   | Provisioned, no full Wi-Fi connectivity                          |
| LED 0   | Solid on          | Fully provisioned with Wi-Fi connectivity                        |

## Troubleshooting

**Device does not advertise over BLE**
- Press BTN0 to restart BLE advertisement.

**Commissioning fails**
- Ensure the Wi-Fi SSID and PSK are correct and the network is reachable.
- Factory reset the device (hold BTN0 for 6 s) and retry.

**LCD or LEDs not working**
- **LCD:** If the board supports an LCD but it is not enabled, install the _Display_ component under _Silicon Labs Matter > Matter > Platform > Display_. For the QR code on the LCD, install the _QR Code_ component under _Silicon Labs Matter > Matter > Platform > QR Code_ (Display is installed automatically).
- **LEDs:** If the board supports LEDs but they are not enabled, install `led0` and `led1` instances of _Simple LED_ under _Platform > Driver > LED > Simple LED_, then install _WSTK LED Support_ under _Silicon Labs Matter > Matter > Platform > WSTK LED Support_.

## Resources

- [Silicon Labs Matter over Wi-Fi Documentation](https://docs.silabs.com/matter/2.9.0/matter-wifi)
- [Matter Hub Setup](https://docs.silabs.com/matter/2.9.0/matter-thread/raspi-img)
- [chip-tool README](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md)

## Report Bugs & Get Support

You are always encouraged and welcome to report any issues you found to us via [Silicon Labs Community](https://community.silabs.com).