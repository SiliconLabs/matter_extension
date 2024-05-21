# Matter EFR32 Sensor Example

The EFR32 Sensor example provides a baseline demonstration of a Sensor control
device, built using Matter and the Silicon Labs Gecko SDK. It can be controlled
by a Chip controller over a Wi-Fi network.

When you create the sensor project it defaults to Occupancy Sensor. To switch between
the sensors, **uninstall** the 'Matter Occupancy Sensor'/current sensor component and **install** the
respective sensor component to enable it. **One sensor component should be enabled for the app to build. **
The sensors and their components are as follows:  
1. Temperature sensor   : Matter Temperature Sensor
2. Contact Sensor       : Matter Contact Sensor  
3. Occupancy Sensor     : Matter Occupancy Sensor

The EFR32 device can be commissioned over Bluetooth Low Energy (BLE) where the device
and the Chip controller will exchange security information with the Rendez-vous
procedure.

If the LCD is enabled, the LCD on the Silicon Labs WSTK shows a QR Code containing the
commissioning information needed for the BLE connection and starting the
Rendez-vous procedure.

The Sensor example is intended to serve both as a means to explore the
workings of Matter and as a template for creating real products based on the
Silicon Labs platform.

For more general information on running Matter applications and prerequisites see the online 
documentation for Matter available on docs.silabs.com. Follow Wi-Fi instructions depending on the example you are running.
[Demo instructions for Wi-Fi](https://docs.silabs.com/matter/2.3.0/matter-wifi)

## Sensor Example User Interface

**LCD** 

The LCD on the Silicon Labs WSTK shows a QR Code. This QR Code is be scanned by the chip-tool app for the Rendez-vous procedure over BLE.

On devices that do not have or support the LCD Display like the BRD4166A Thunderboard Sense 2, a URL can be found in the **RTT logs upon startup OR by issuing the following matter shell command:**

```shell
matterCli> onboardingcodes ble qrcodeurl
```

Log output example:

```shell
[SVR] Copy/paste the following URL in a browser to see the QR Code:
[SVR] https://project-chip.github.io/connectedhomeip/qrcode.html?data=CH%3AI34NM%20-00%200C9SS0
```

**LED 0** 

Shows the overall state of the device and its connectivity. The following states are possible:

-   _Short Flash On (50 ms on/950 ms off)_: The device is in the unprovisioned (unpaired) state and is waiting for a commissioning application to connect.

-   _Rapid Even Flashing (100 ms on/100 ms off)_: The device is in the unprovisioned state and a commissioning application is connected through Bluetooth LE.

-   _Short Flash Off (950 ms on/50 ms off)_: The device is fully
provisioned, but does not yet have full service
connectivity.

-   _Solid On_: The device is fully provisioned and has full service connectivity.

**LED 1** 

Simulates the Sensor state. The following states are possible:

-   _Solid On_ ; Sesnor has occupant/ has contact/ have temperature
-   _Off_ ; Sensor no occupant/ no contact/ no temperature

    
**Push Button 0**

-   _Press and Release_: Start or restart BLE advertisement in fast mode. It will advertise in this mode
for 30 seconds. The device will then switch to a slower interval advertisement.
After 15 minutes, the advertisement stops. In addition, this button should also print the QR Code URL to the RTT logs.

-   _Press and hold for 6 s_  Initiates the factory reset of the device.
 Releasing the button within the 6-second window cancels the factory reset
 procedure. **LEDs** blink in unison when the factory reset procedure is
 initiated.

**Push Button 1** 

- Toggles the Sensor state On/Off

## Provision and Control

You can provision and control the Matter device using the Python controller, chip-tool standalone, Android or iOS app, or the Matter Hub provided by Silicon Labs. More information on using the Matter Hub can be found in the online [Silicon Labs Matter Documentation](https://docs.silabs.com/matter/2.3.0/matter-thread/raspi-img)

The pre-built chip-tool instance ships with the Matter Hub image which is available from Silicon Labs here: [Silicon Labs Matter Hub](https://www.silabs.com/documents/public/software/SilabsMatterPi_2.2.1-1.2-extension.zip)
    
More information on using the chip-tool directly can be found here: [chip-tool](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md)


Here is an example with the chip-tool:

```shell
chip-tool pairing ble-wifi 1122 $SSID $PSK 20202021 3840

chip-tool onoff on 1 1
```