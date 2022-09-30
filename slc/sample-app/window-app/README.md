# Matter EFR32 Window Covering Example

The EFR32 window-covering example provides a baseline demonstration of a Window
Covering device, built using Matter and the Silicon Labs Gecko SDK. It can be
controlled by a Chip controller over an Openthread network.

The EFR32 device can be commissioned over Bluetooth Low Energy where the device
and the Chip controller will exchange security information with the Rendez-vous
procedure. In the case of Thread, the Thread Network credentials are provided to
the EFR32 device which will then join the Thread network.

If the LCD is enabled, the LCD on the Silabs WSTK shows a QR Code containing the
needed commissioning information for the BLE connection and starting the
Rendez-vous procedure. Once the device is commissioned, the displays shows a
representation of the window covering state.

The window-covering example is intended to serve both as a means to explore the
workings of Matter as well as a template for creating real products based on the
Silicon Labs platform.

For more general information on running matter applications and pre-requisites please look at online 
documentation for Matter available on docs.silabs.com. Follow Thread demo instructions depending on the example you are running.
[Demo instructions for Thread](https://docs.silabs.com/matter/1.0.1/matter-thread/demo-overview)

## Window Covering Application User Interface

**LCD** 

The LCD on Silabs WSTK shows a QR Code. This QR Code is be scanned by the CHIP Tool app For the Rendez-vous procedure over BLE

* On devices that do not have or support the LCD Display like the BRD4166A Thunderboard Sense 2, a URL can be found in the RTT logs.

```shell
[SVR] Copy/paste the below URL in a browser to see the QR Code:
[SVR] https://project-chip.github.io/connectedhomeip/qrcode.html?data=CH%3AI34NM%20-00%200C9SS0
```

**LED 0** 

LED 0 shows the overall state of the device and its connectivity. The following states are possible:

-   _Short Flash On (50 ms on/950 ms off)_ ; The device is in the
            unprovisioned (unpaired) state and is waiting for a commissioning
            application to connect.

-   _Rapid Even Flashing_ ; (100 ms on/100 ms off)_ &mdash; The device is in the
            unprovisioned state and a commissioning application is connected through
            Bluetooth LE.

-   _Short Flash Off_ ; (950ms on/50ms off)_ &mdash; The device is fully
            provisioned, but does not yet have full Thread network or service
            connectivity.

-   _Solid On_ ; The device is fully provisioned and has full Thread
            network and service connectivity.

**LED 1** 

Shows the state of the window covering

-   _Solid On_ ; The window cover if fully open
-   _Off_ ; The window cover if fully closed
-   _Blinking slowly_ ; The window cover is half-open, either by tilt, or lift
-   _Blinking quickly_ ; The window cover is being automatically open or closed

**Push Button 0** 

Increase either tilt or lift, and factory reset

-   Pressed and release: The lift/tilt increases by 10%

-   Pressed and hold for 6 s: Initiates the factory reset of the device.
            Releasing the button within the 6-second window cancels the factory reset
            procedure. **LEDs** blink in unison when the factory reset procedure is
            initiated.

**Push Button 1** 

Decreases either tilt or lift, or switch the cover type

-   Pressed and release: The lift/tilt decreases by 10%

-   Press and hold for 3 s: Cycle between window covering type (Rollershade, Drapery, Tilt Blind - Lift and Tilt).

**Push Button0 and Button1** 

Switch between lift and tilt

- Pressing and release both buttons at the same time: switches between lift and tilt modes. Most window covering types support either lift only, or tilt only, but type 0x08 support both (default)

- Pressing and hold both buttons at the same time: Cycles between window covering 1, and window covering 2.

*   Once the device is provisioned, it will join the Thread network is
    established, look for the RTT log

```shell
[DL] Device Role: CHILD
[DL] Partition Id:0x6A7491B7
[DL] \_OnPlatformEvent default: event->Type = 32778
[DL] OpenThread State Changed (Flags: 0x00000001)
[DL] Thread Unicast Addresses:
[DL]    2001:DB8::E1A2:87F1:7D5D:FECA/64 valid preferred
[DL]    FDDE:AD00:BEEF::FF:FE00:2402/64 valid preferred rloc
[DL]    FDDE:AD00:BEEF:0:383F:5E81:A05A:B168/64 valid preferred
[DL]    FE80::D8F2:592E:C109:CF00/64 valid preferred
[DL] LwIP Thread interface addresses updated
[DL] FE80::D8F2:592E:C109:CF00 IPv6 link-local address, preferred)
[DL] FDDE:AD00:BEEF:0:383F:5E81:A05A:B168 Thread mesh-local address, preferred)
[DL] 2001:DB8::E1A2:87F1:7D5D:FECA IPv6 global unicast address, preferred)
```

(you can verify that the device is on the thread network with the command
    `router table` using a serial terminal (screen / minicom etc.) on the board
    running the window-app example. You can also get the address list with the
    command ipaddr again in the serial terminal )

## Provision and Control

You can provision and control the Matter device using the python controller, Chip tool standalone, Android, iOS app or the Matter Hub provided by Silicon Labs. More information on using the Matter Hub can be found in the online Matter documentation here: [Silicon Labs Matter Documentation](https://docs.silabs.com/matter/1.0.1/matter-thread/demo-overview)

The pre-built chip-tool instance ships with the Matter Hub image which is available from Silicon Labs here: [Silicon Labs Matter Hub](https://www.silabs.com/documents/public/software/SilabsMatterPi.zip)
    
More information on using the chip-tool directly can be found here: [CHIPTool](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md) 

For instance, to set the window covering lift by percentage:

```shell
chip-tool pairing ble-thread 1 hex:<operationalDataset> 20202021 3840

chip-tool onoff on 1 1

chip-tool windowcovering go-to-tilt-percentage 50 0 1 1
```

To see the supported window covering cluster commands, use:

```shell
chip-tool windowcovering
```