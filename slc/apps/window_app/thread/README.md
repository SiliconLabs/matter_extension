# Matter over Thread Window Covering Example

The Matter over Thread window covering example is a baseline demonstration of a window covering built with Simplicity SDK. It can be controlled by a Matter controller over a Thread network.

## Table of Contents

- [Purpose/Scope](#purposescope)
- [Prerequisites/Setup Requirements](#prerequisitessetup-requirements)
- [Steps to Run Demo](#steps-to-run-demo)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)
- [Report Bugs & Get Support](#report-bugs--get-support)

## Purpose/Scope

This example demonstrates a sample implementation of a Matter over Thread window covering
app running on a Silicon Labs EFR32 SoC.

The device is commissioned over Bluetooth Low Energy (BLE), during which the Matter
controller and device exchange security credentials in the Rendez-vous procedure.

If the LCD is enabled, the LCD on the Silicon Labs WSTK shows a QR code containing
the commissioning information for the BLE connection and Rendez-vous procedure. Once
commissioned, the display shows a representation of the window covering state.

This example serves as both a functional demonstration of Matter over Thread and a
starting point for building production products on the Silicon Labs platform.

## Prerequisites/Setup Requirements

### HW Requirements

For a full list of hardware requirements, see [Matter Hardware Requirements](https://docs.silabs.com/matter/2.9.0/matter-overview/#hardware-requirements) documentation.

### SW Requirements

For a full list of software requirements, see [Matter Software Requirements](https://docs.silabs.com/matter/2.9.0/matter-overview/#software-requirements) documentation.

## Steps to Run Demo

### Program a Bootloader

If building a solution, the bootloader is included and flashed as part of the combined
artifact.

If building the sample application on its own, a bootloader must be flashed separately
before the application. Pre-built bootloader binaries for all supported devices are
available at [Matter Bootloader Binaries](https://docs.silabs.com/matter/2.9.0/matter-prerequisites/matter-artifacts#matter-bootloader-binaries).

### Configuration and Setup

This sample app works out of the box with no additional configuration required. To customize the device, see the
[Custom Matter Device Development](https://docs.silabs.com/matter/2.9.0/matter-references/custom-matter-device#custom-matter-device-development) guide.

Once the device is provisioned, it will join the Thread network once established, look for the RTT log. You can verify that the device is on the Thread network with the command `router table` using a serial terminal (screen / minicom etc.) on the board running the window-app example. You can also get the address list with the command `ipaddr` in the serial terminal.

Example RTT log output:
```shell
[DL] Device Role: CHILD
[DL] Partition Id:0x6A7491B7
[DL] \_OnPlatformEvent default: event->Type = 32778
[DL] OpenThread State Changed (Flags: 0x00000001)
[DL] Thread Unicast Addresses:
[DL]    2001:DB8::E1A2:87F1:7D5D:FECA/64 valid preferred
[DL]    FDDE:AD00:BEEF::FF:FE00:2402/64 valid preferred rloc
[DL]    FDDE:AD00:BEEF:0:383F:5E81:A05A:B168/64 valid preferred
[DL]    FE80::D8F2:592E:C109:CF00/64 valid preferred
[DL] LwIP Thread interface addresses updated
[DL] FE80::D8F2:592E:C109:CF00 IPv6 link-local address, preferred)
[DL] FDDE:AD00:BEEF:0:383F:5E81:A05A:B168 Thread mesh-local address, preferred)
[DL] 2001:DB8::E1A2:87F1:7D5D:FECA IPv6 global unicast address, preferred)
```

### Steps for Execution

1. Build and flash the bootloader and application to your board.
2. On startup, **LED 0** flashes short-on (50 ms on / 950 ms off), indicating the
   device is waiting for commissioning.
3. Commission the device using one of the following methods:

   **chip-tool (standalone or pre-built):** The pre-built chip-tool instance ships
   with the Matter Hub image. More information on using the Matter Hub is in the
   [Silicon Labs Matter Hub Documentation](https://docs.silabs.com/matter/2.9.0/matter-thread/raspi-img).
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

4. Control the window covering:
   ```shell
   chip-tool windowcovering go-to-tilt-percentage 50 0 1 1
   ```
   To see supported window covering cluster commands: `chip-tool windowcovering`

**Button and LED reference:**

| Control   | Action                    | Result                                                          |
|-----------|----------------------------|-----------------------------------------------------------------|
| BTN0      | Press and release          | Increase lift/tilt by 10%                                      |
| BTN0      | Hold 6 s                   | Initiate factory reset (release within 6 s to cancel)           |
| BTN1      | Press and release          | Decrease lift/tilt by 10%                                      |
| BTN1      | Hold 3 s                   | Cycle window covering type (Rollershade, Drapery, Tilt Blind)  |
| BTN0+BTN1 | Press and release together | Switch between lift and tilt modes                             |
| BTN0+BTN1 | Hold together              | Cycle between window covering 1 and 2                          |
| LED 0     | Short flash on             | Unprovisioned, waiting for commissioning                        |
| LED 0     | Rapid even flash           | BLE connected, commissioning in progress                        |
| LED 0     | Short flash off            | Provisioned, no full Thread connectivity                        |
| LED 0     | Solid on                   | Fully provisioned with Thread connectivity                      |
| LED 1     | Solid on                   | Window cover fully open                                         |
| LED 1     | Off                        | Window cover fully closed                                       |
| LED 1     | Blinking slowly             | Window cover half-open (tilt or lift)                           |
| LED 1     | Blinking quickly           | Window cover being automatically opened or closed               |

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

- [Silicon Labs Matter over Thread Documentation](https://docs.silabs.com/matter/2.9.0/matter-thread)
- [Matter Hub Setup](https://docs.silabs.com/matter/2.9.0/matter-thread/raspi-img)
- [chip-tool README](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md)

## Report Bugs & Get Support

You are always encouraged and welcome to report any issues you found to us via [Silicon Labs Community](https://community.silabs.com).
