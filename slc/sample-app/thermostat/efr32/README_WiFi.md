# Matter EFR32 Thermostat Example

The EFR32 Thermostat example provides a baseline demonstration of a thermostat
device, built using Matter and the Silicon Labs Gecko SDK. It can be controlled
by a Matter controller over Wifi network.

The EFR32 device can be commissioned over Bluetooth Low Energy where the device
and the Matter controller will exchange security information with the Rendez-vous
procedure.

If the LCD is enabled, the LCD on the Silabs WSTK shows a QR Code containing the
needed commissioning information for the BLE connection and starting the
Rendez-vous procedure.

The light switch example is intended to serve both as a means to explore the
workings of Matter as well as a template for creating real products based on the
Silicon Labs platform.

For more general information on running matter applications and pre-requisites please look at online 
documentation for Matter available on docs.silabs.com. Follow Wi-Fi demo instructions depending on the example you are running.
[Demo instructions for Wi-Fi](https://docs.silabs.com/matter/2.4.0/matter-wifi)

## Thermostat Application User Interface

**LCD** 

The LCD on Silabs WSTK shows a QR Code. This QR Code is be scanned by the CHIP Tool app For the Rendez-vous procedure over BLE.

On devices that do not have or support the LCD Display like the BRD4166A Thunderboard Sense 2, a URL can be found in the **RTT logs upon startup OR by issuing the following matter shell command:**

```shell
matterCli> onboardingcodes ble qrcodeurl
```

Log output example:

```shell
[SVR] Copy/paste the below URL in a browser to see the QR Code:
[SVR] https://project-chip.github.io/connectedhomeip/qrcode.html?data=CH%3AI34NM%20-00%200C9SS0
```

**LED 0** 

LED 0 shows the overall state of the device and its connectivity. The following states are possible:

-   Short Flash On (50 ms on/950 ms off): The device is in the unprovisioned (unpaired) state and is waiting for a commissioning application to connect.

-   Rapid Even Flashing (100 ms on/100 ms off): The device is in the unprovisioned state and a commissioning application is connected through Bluetooth LE.

-   Short Flash Off (950ms on/50ms off): The device is fully provisioned, but does not yet have full service connectivity.

-   Solid On: The device is fully provisioned and has full service connectivity.

**Push Button 0**

-   _Press and Release_ : Start, or restart, BLE advertisement in fast mode. It will advertise in this mode
for 30 seconds. The device will then switch to a slower interval advertisement.
After 15 minutes, the advertisement stops. In addition, this button should also print the QR Code URL to the RTT logs.

-   _Pressed and hold for 6 s_ : Initiates the factory reset of the device. Releasing the button within the 6-second window cancels the factory reset procedure. **LEDs** blink in unison when the factory reset procedure is initiated.

## Provision and Control

You can provision and control the Matter device using the python controller, chip-tool (standalone or pre-built), Android, iOS app or the mattertool utility from the Matter Hub package provided by Silicon Labs. The pre-built chip-tool instance ships with the Matter Hub image. More information on using the Matter Hub can be found in the online Matter documentation here: [Silicon Labs Matter Documentation](https://docs.silabs.com/matter/2.4.0/matter-thread/raspi-img)


    
More information on using the chip-tool directly can be found here: [CHIPTool](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md)

Here is an example for provisioning the thermostat application with the chip-tool:

Pairing with chip-tool:
```shell
./chip-tool pairing ble-wifi <node-id> $SSID $PSK <PinCode> <Discriminator>

./chip-tool pairing ble-wifi 1 $SSID $PSK 20202021 3840
```

Setting the occupied cooling setpoint:
```shell
./chip-tool thermostat write occupied-cooling-setpoint <temperature> <node-id> <endpoint-id>

./chip-tool thermostat write occupied-cooling-setpoint 2500 1 1

Note: On chip-tool verify that DUT sends a success response
[1676031143.386639][19597:19599] CHIP:DMG:                         StatusIB =
[1676031143.386683][19597:19599] CHIP:DMG:                         {
[1676031143.386729][19597:19599] CHIP:DMG:                                 status = 0x00 (SUCCESS),
[1676031143.386773][19597:19599] CHIP:DMG:                         },
```
Read thermostat attributes:
```shell
./chip-tool thermostat read occupied-cooling-setpoint <node-id> <endpoint-id>

./chip-tool thermostat read occupied-cooling-setpoint 1 1

Note: On chip-tool verify that the occupied cooling setpoint attribute value which is provided in previous step
[1676028659.980049][19359:19361] CHIP:TOO:   OccupiedCoolingSetpoint: 2500
```
