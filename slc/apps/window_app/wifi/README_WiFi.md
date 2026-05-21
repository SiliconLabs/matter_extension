# Matter over Wi-Fi Window Covering Example

The Matter over Wi-Fi window covering example is a baseline demonstration of a window covering built with Simplicity SDK. It can be controlled by a Matter controller over a Wi-Fi network.

## Table of Contents

- [Purpose/Scope](#purposescope)
- [Prerequisites/Setup Requirements](#prerequisitessetup-requirements)
- [Steps to Run Demo](#steps-to-run-demo)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)
- [Report Bugs & Get Support](#report-bugs--get-support)

## Purpose/Scope

This example provides a baseline demonstration of a window covering device, built using Matter and the Silicon Labs Simplicity SDK. It can be controlled by a Matter controller over a Wi-Fi network.

The device can be commissioned over Bluetooth Low Energy, the device and the Matter controller exchange security information in the Rendez-vous procedure.

If the LCD is enabled, the LCD on the Silicon Labs WSTK shows a QR code containing the commissioning information for the BLE connection and Rendez-vous procedure. Once commissioned, the display shows a representation of the window covering state.

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
   chip-tool pairing ble-wifi 1 <SSID> <PSK> 20202021 3840
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
   chip-tool windowcovering up-or-open 1 1
   chip-tool windowcovering down-or-close 1 1
   ```
   To see supported window covering cluster commands: `chip-tool windowcovering`

**Button and LED reference:**

| Control | Action            | Result                                                          |
|---------|-------------------|-----------------------------------------------------------------|
| BTN0    | Press and release | Start/restart BLE advertisement, print QR code URL to RTT logs, increase lift/tilt by 10% |
| BTN0    | Hold 6 s          | Initiate factory reset (release within 6 s to cancel)           |
| BTN1    | Press and release | Decrease lift/tilt by 10%                                      |
| BTN1    | Hold 3 s          | Cycle window covering type (Rollershade, Drapery, Tilt Blind)   |
| BTN0+1  | Press and release both | Switch between lift and tilt (type 0x08 supports both)     |
| BTN0+1  | Hold both         | Cycle between window covering 1 and 2                           |
| LED 0   | Short flash on    | Unprovisioned, waiting for commissioning                        |
| LED 0   | Rapid even flash  | BLE connected, commissioning in progress                        |
| LED 0   | Short flash off   | Provisioned, no full Wi-Fi connectivity                          |
| LED 0   | Solid on          | Fully provisioned with Wi-Fi connectivity                        |
| LED 1   | Solid on          | Window cover fully open                                         |
| LED 1   | Off               | Window cover fully closed                                       |
| LED 1   | Blinking slowly   | Window cover half-open (tilt or lift)                           |
| LED 1   | Blinking quickly  | Window cover moving automatically                               |

Once the device is provisioned, it joins the Wi-Fi network. You can verify in RTT logs, for example:

```shell
[DL] Device Role: CHILD
[DL] Partition Id:0x6A7491B7
[DL] \_OnPlatformEvent default: event->Type = 32778
[DL] Wifi State Changed (Flags: 0x00000001)
[DL] Wifi Unicast Addresses:
[DL]    2001:DB8::E1A2:87F1:7D5D:FECA/64 valid preferred
[DL]    FDDE:AD00:BEEF::FF:FE00:2402/64 valid preferred rloc
[DL]    FDDE:AD00:BEEF:0:383F:5E81:A05A:B168/64 valid preferred
[DL]    FE80::D8F2:592E:C109:CF00/64 valid preferred
[DL] LwIP Wifi face addresses updated
```

You can also verify with the `router table` or `ipaddr` commands in the serial terminal.

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
