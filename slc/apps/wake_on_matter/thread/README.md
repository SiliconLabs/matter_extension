# Matter over Thread Wake on Matter Example

The Wake on Matter (WoM) example demonstrates a Matter device that also acts as an OpenThread NCP. When plugged to an OTBR over USB, it provides the Thread radio while running Matter on-chip.

## Table of Contents

- [Purpose/Scope](#purposescope)
- [Prerequisites/Setup Requirements](#prerequisitessetup-requirements)
- [Steps to Run Demo](#steps-to-run-demo)
  - [Establishing Subscriptions](#establishing-subscriptions)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)
- [Report Bugs & Get Support](#report-bugs--get-support)

## Purpose/Scope

This example demonstrates a multi-protocol application running on a Silicon Labs
EFR32 SoC that serves two roles:

1. **OT-NCP**: The device functions as an OpenThread NCP when connected to an OTBR
   via USB. The OTBR communicates with the NCP over the VCOM (USB) serial interface
   using HDLC framing. This uses the multi-instance OpenThread API -- the Matter
   stack uses OpenThread instance 0 while the NCP uses instance 1.

2. **Matter endpoint**: The device runs a minimal Matter stack with only root node
   clusters (no application-level clusters). It is commissioned over BLE and joins
   the Thread network. Subscriptions to device attributes are established using the
   Matter shell Interaction Model (IM) CLI commands.

The Matter debug interface (logs and shell) is exposed on an external EUSART, not on
the USB VCOM port (which is reserved for OT-NCP traffic). The EUSART pin mapping is:

| Signal | Pin | EXP Header |
|--------|-----|------------|
| RX     | PA5 | Pin 7      |
| TX     | PA6 | Pin 11     |

Connect a USB-to-UART adapter to these pins to access the Matter shell and logs.

## Prerequisites/Setup Requirements

### HW Requirements

- A Silicon Labs EFR32 development kit (WSTK + radio board).
- A Raspberry Pi (or equivalent) running the OTBR image, with the EFR32 board
  connected via USB to serve as the NCP.
- A USB-to-UART adapter to access the Matter debug interface on the EXP header.

For a full list of hardware requirements, see [Matter Hardware Requirements](https://docs.silabs.com/matter/2.9.1/matter-overview/#hardware-requirements) documentation.

### SW Requirements

- A custom Silicon Labs based OTBR build is required. See
  [Build and Installation Instructions for the Border Router Host](https://docs.silabs.com/openthread/3.0.2/using-sl-coprocessors-with-openthread-border-routers/build-and-installation-instructions-for-the-border-router-host)
  for more details.

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
2. Connect the board to the OTBR host (e.g. Raspberry Pi) via USB. The OTBR will
   use the device as its Thread NCP over the VCOM serial link.
3. Connect a USB-to-UART adapter to the EXP header (RX on pin 7 / PA5, TX on
   pin 11 / PA6) and open a serial terminal at **115200 baud** to access the Matter
   shell and logs.
4. Commission the device using one of the following methods:

   **chip-tool (standalone or pre-built):** The pre-built chip-tool instance ships
   with the Matter Hub image. More information on using the Matter Hub is in the
   [Silicon Labs Matter Hub Documentation](https://docs.silabs.com/matter/2.9.1/matter-thread/raspi-img).
   ```shell
   chip-tool pairing ble-thread 1 hex:<operationalDataset> 20202021 3840
   ```

   **Simplicity Connect mobile app:** Scan the QR code shown on the LCD or the URL
   printed to the Matter debug EUSART on startup or by pressing BTN0. The URL can
   also be retrieved via the Matter shell:
   ```shell
   matterCli> onboardingcodes ble qrcodeurl
   ```
   Example log output:
   ```
   [SVR] Copy/paste the below URL in a browser to see the QR Code:
   [SVR] https://project-chip.github.io/connectedhomeip/qrcode.html?data=MT%3A6FCJ142C00KA0648G00
   ```

   **Other:** The device can also be provisioned and controlled using the Python controller, Android, or iOS app.

### Establishing Subscriptions

This sample app allows subscriptions to another Matter device. This is useful
to receive state changes and to act accordingly.

1. Commission this application to a Matter Thread network.
2. Grant ACL access to the WoM node on the target device you want to subscribe to:
   ```shell
   chip-tool accesscontrol write acl '[{"fabricIndex": 1, "privilege": 1, "authMode": 2, "subjects": [<WoM node ID>], "targets": null}]' <target node ID> 0
   ```
3. Using `silabs_console.py` or a standard CLI interface (e.g. `screen`, `PuTTY`)
   connected to the EUSART debug interface, run the following shell command on the
   WoM device to establish a subscription:
   ```shell
   matterCli> im subscribe <fabricIndex> <nodeId> <endpointId> <clusterId>
   ```
   For example, to subscribe to the On/Off cluster (ID `6`) on endpoint `1` of
   node `40`:
   ```shell
   matterCli> im subscribe 1 40 1 6
   ```

**Button and LED reference:**

| Control | Action            | Result                                                          |
|---------|-------------------|-----------------------------------------------------------------|
| BTN0    | Press and release | Start/restart BLE advertisement, print QR code URL to logs      |
| BTN0    | Hold 6 s          | Initiate factory reset (release within 6 s to cancel)           |
| LED 0   | Short flash on    | Unprovisioned, waiting for commissioning                        |
| LED 0   | Rapid even flash  | BLE connected, commissioning in progress                        |
| LED 0   | Short flash off   | Provisioned, no full Thread connectivity                        |
| LED 0   | Solid on          | Fully provisioned with Thread connectivity                      |

## Troubleshooting

**OTBR does not detect the NCP**
- Verify the board is connected to the OTBR host via USB and that the VCOM port is
  visible (e.g. `/dev/ttyACM0`).
- Ensure the OTBR service is configured to use the correct serial port.

**No output on the Matter debug EUSART**
- Confirm the USB-to-UART adapter is connected to the correct EXP header pins
  (RX on pin 7 / PA5, TX on pin 11 / PA6).
- Verify the serial terminal is set to **115200 baud, 8N1**.

**Device does not advertise over BLE**
- Press BTN0 to restart BLE advertisement.
- Confirm the bootloader is flashed to the device.

**Commissioning fails**
- Ensure the Thread Border Router is running and reachable.
- Verify the `operationalDataset` hex string matches your Thread network.
- Factory reset the device (hold BTN0 for 6 s) and retry.

## Resources

- [Silicon Labs Matter over Thread Documentation](https://docs.silabs.com/matter/2.9.1/matter-thread)
- [Matter Hub Setup](https://docs.silabs.com/matter/2.9.1/matter-thread/raspi-img)
- [chip-tool README](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md)

## Report Bugs & Get Support

You are always encouraged and welcome to report any issues you found to us via [Silicon Labs Community](https://community.silabs.com).
