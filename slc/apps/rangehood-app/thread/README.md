# Matter EFR32 Rangehood Example

The EFR32 rangehood example provides a baseline demonstration of a Rangehood
device, built using Matter and the Silicon Labs simplicity SDK. It can be
controlled by a Matter controller over an OpenThread network.

The EFR32 device can be commissioned over Bluetooth Low Energy where the device
and the Matter controller will exchange security information with the
Rendez-vous procedure. Thread network credentials are then provided to the
EFR32 device which will join the Thread network.

If the LCD is enabled, the LCD on the Silabs WSTK shows a QR Code containing
the needed commissioning information for the BLE connection and starting the
Rendez-vous procedure.

For more general information on running matter applications and pre-requisites
please look at online documentation for Matter available on docs.silabs.com.
Follow Thread demo instructions depending on the example you are running.
[Demo instructions for Thread](https://docs.silabs.com/matter/2.8.1/matter-thread)

## Rangehood Application User Interface

**LCD**

The LCD on Silabs WSTK shows a QR Code. This QR Code is scanned by the CHIP Tool
app for the Rendez-vous procedure over BLE.

![QR Code](qr_code_img.png)

A URL can be found in the **RTT logs upon startup OR by pressing BTN0**

**The URL can also be printed by issuing the following matter shell command:**

```shell
matterCli> onboardingcodes ble qrcodeurl
```

**Push Button 0**

- _Press and Release_: Start, or restart, BLE advertisement in fast mode. It
  will advertise in this mode for 30 seconds. The device will then switch to a
  slower interval advertisement. After 15 minutes, the advertisement stops. In
  addition, this button should also print the QR Code URL to the RTT logs.

- _Pressed and hold for 6 s_: Initiates the factory reset of the device.
  Releasing the button within the 6-second window cancels the factory reset
  procedure.

## Provision and Control

You can provision and control the Matter device using the python controller,
chip-tool (standalone or pre-built), Android, iOS app or the mattertool utility
from the Matter Hub package provided by Silicon Labs. The pre-built chip-tool
instance ships with the Matter Hub image. More information on using the Matter
Hub can be found in the online Matter documentation here: [Silicon Labs Matter
Documentation](https://docs.silabs.com/matter/2.8.1/matter-thread/raspi-img)

More information on using the chip-tool directly can be found here:
[CHIPTool](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md)

Here is an example with the CHIPTool:

```shell
chip-tool pairing ble-thread 1 hex:<operationalDataset> 20202021 3840
```
