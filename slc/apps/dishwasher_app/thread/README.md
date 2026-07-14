# Matter over Thread Dishwasher Example

The Matter over Thread dishwasher example is a baseline demonstration of a dishwasher built with Simplicity SDK. It can be controlled by a Matter controller over a Thread network.

## Table of Contents

- [Purpose/Scope](#purposescope)
- [Prerequisites/Setup Requirements](#prerequisitessetup-requirements)
- [Steps to Run Demo](#steps-to-run-demo)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)
- [Report Bugs & Get Support](#report-bugs--get-support)

## Purpose/Scope

This example demonstrates a sample implementation of a Matter over Thread dishwasher
app running on a Silicon Labs EFR32 SoC.

The device is commissioned over Bluetooth Low Energy (BLE), during which the Matter
controller and device exchange security credentials in the Rendez-vous procedure.

If the LCD is enabled, the LCD on the Silicon Labs WSTK shows a QR code containing
the commissioning information for the BLE connection and Rendez-vous procedure.

This example serves as both a functional demonstration of Matter over Thread and a
starting point for building production products on the Silicon Labs platform.

## Prerequisites/Setup Requirements

### HW Requirements

For a full list of hardware requirements, see [Matter Hardware Requirements](https://docs.silabs.com/matter/2.9.1/matter-overview/#hardware-requirements) documentation.

### SW Requirements

For a full list of software requirements, see [Matter Software Requirements](https://docs.silabs.com/matter/2.9.1/matter-overview/#software-requirements) documentation.

## Steps to Run Demo

### Program a Bootloader

If building a solution, the bootloader is included and flashed as part of the combined
artifact.

If building the sample application on its own, a bootloader must be flashed separately
before the application. Pre-built bootloader binaries for all supported devices are
available at [Matter Bootloader Binaries](https://docs.silabs.com/matter/2.9.1/matter-prerequisites/matter-artifacts#matter-bootloader-binaries).

### Configuration and Setup

This sample app works out of the box with no additional configuration required. To customize the device, see the
[Custom Matter Device Development](https://docs.silabs.com/matter/2.9.1/matter-references/custom-matter-device#custom-matter-device-development) guide.

### Steps for Execution

1. Build and flash the bootloader and application to your board.
2. On startup, **LED 0** flashes short-on (50 ms on / 950 ms off), indicating the
   device is waiting for commissioning.
3. Commission the device using one of the following methods:

   **chip-tool (standalone or pre-built):** The pre-built chip-tool instance ships
   with the Matter Hub image. More information on using the Matter Hub is in the
   [Silicon Labs Matter Hub Documentation](https://docs.silabs.com/matter/2.9.1/matter-thread/raspi-img).
   ```shell
   chip-tool pairing ble-thread 1 hex:<operationalDataset> 20202021 3840
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

4. Control the dishwasher:
   ```shell
   chip-tool onoff on 1 1
   chip-tool onoff off 1 1
   ```

**Button and LED reference:**

| Control | Action            | Result                                                          |
|---------|-------------------|-----------------------------------------------------------------|
| BTN0    | Press and release | Start/restart BLE advertisement, print QR code URL to RTT logs |
| BTN0    | Hold 6 s          | Initiate factory reset (release within 6 s to cancel)           |
| BTN1    | Press and release | Toggle dishwasher on/off                                       |
| LED 0   | Short flash on    | Unprovisioned, waiting for commissioning                        |
| LED 0   | Rapid even flash  | BLE connected, commissioning in progress                        |
| LED 0   | Short flash off   | Provisioned, no full Thread connectivity                        |
| LED 0   | Solid on         | Fully provisioned with Thread connectivity                      |
| LED 1   | Solid on         | Dishwasher is on                                              |
| LED 1   | Off              | Dishwasher is off                                              |

## Troubleshooting

**Device does not advertise over BLE**
- Press BTN0 to restart BLE advertisement.
- Confirm the bootloader is flashed to the device.

**Commissioning fails**
- Ensure the Thread Border Router is running and reachable.
- Verify the `operationalDataset` hex string matches your Thread network.
- Factory reset the device (hold BTN0 for 6 s) and retry.

**LCD or LEDs not working**
- **LCD:** If the board supports an LCD but it is not enabled, install the _Display_
  component under _Silicon Labs Matter > Matter > Platform > Display_. For the QR code
  on the LCD, install the _QR Code_ component under _Silicon Labs Matter > Matter >
  Platform > QR Code_ (Display is installed automatically).
- **LEDs:** If the board supports LEDs but they are not enabled, install `led0` and
  `led1` instances of _Simple LED_ under _Platform > Driver > LED > Simple LED_, then
  install _WSTK LED Support_ under _Silicon Labs Matter > Matter > Platform > WSTK LED Support_.

## Resources

- [Silicon Labs Matter over Thread Documentation](https://docs.silabs.com/matter/2.9.1/matter-thread)
- [Matter Hub Setup](https://docs.silabs.com/matter/2.9.1/matter-thread/raspi-img)
- [chip-tool README](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md)

## Report Bugs & Get Support

You are always encouraged and welcome to report any issues you found to us via [Silicon Labs Community](https://community.silabs.com).
