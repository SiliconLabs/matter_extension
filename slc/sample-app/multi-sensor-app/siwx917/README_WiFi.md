# Matter SiWx917 SoC Multi Sensor Example

The SiWx917 SoC Sensor example provides a baseline demonstration of a Sensor control
device, built using Matter and the Silicon Labs Simplicity SDK. It can be controlled
by a Matter controller over Wifi network.

This examples showcases how a Long Idle Time multi sensor ICD device would operates when having three device types on three disctint endpoints.

1. Matter Occupancy Sensor
2. Matter Temperature Sensor
3. Matter Humidity Sensor

The SiWx917 SoC device can be commissioned over Bluetooth Low Energy (BLE) where the device
and the Matter controller will exchange security information with the Rendez-vous
procedure.

If the LCD is enabled, the LCD on the Silicon Labs WSTK shows a QR Code containing the
commissioning information needed for the BLE connection and starting the
Rendez-vous procedure.

The Sensor example is intended to serve both as a means to explore the
workings of Matter and as a template for creating real products based on the
Silicon Labs platform.

For more general information on running Matter applications and prerequisites see online
documentation for Matter available on docs.silabs.com. Follow Thread demo instructions depending on the example you are running.
[Demo instructions for Thread](https://docs.silabs.com/matter/2.6.1/matter-thread)

## Region code Setting (917 WiFi projects)

In Wifi configurations, the region code can be set in this
[file](https://github.com/SiliconLabsSoftware/matter_sdk/blob/085bd03532990e5b1f99ff4b08ebce4f4ca5edf6/src/platform/silabs/wifi/SiWx/WifiInterface.cpp#L125).
The available region codes can be found
[here](https://github.com/SiliconLabs/wiseconnect/blob/f675628eefa1ac4990e94146abb75dd08b522571/components/device/silabs/si91x/wireless/inc/sl_si91x_types.h#L71)

## Sensor Example User Interface

**LCD** 

The LCD on Silabs WSTK shows a QR Code. This QR Code is be scanned by the CHIP Tool app For the Rendez-vous procedure over BLE.

![QR Code](qr_code_img.png)

A URL can be found in the **RTT logs upon startup OR by pressing BTN0**

**The URL can also be printed by issuing the following matter shell command:**

```shell
matterCli> onboardingcodes ble qrcodeurl
```

Log output example:

```shell
[SVR] Copy/paste the below URL in a browser to see the QR Code:
[SVR] https://project-chip.github.io/connectedhomeip/qrcode.html?data=MT%3A6FCJ142C00KA0648G00
```

Note: This QR Code is only valid for an unprovisioned device. Provisioning may change the QR Code.

**LED 0**

Shows the overall state of the device and its connectivity. The following states are possible:

- _Short Flash On (50 ms on/950 ms off)_: The device is in the unprovisioned (unpaired) state and is waiting for a commissioning application to connect.

- _Rapid Even Flashing (100 ms on/100 ms off)_: The device is in the unprovisioned state and a commissioning application is connected through Bluetooth LE.

- _Short Flash Off (950 ms on/50 ms off)_: The device is fully
  provisioned, but does not yet have full service connectivity.

- _Solid On_: The device is fully provisioned and has full Thread
  network and service connectivity.

> **NOTE:** When the device is configured as an ICD, LED0 when only flash during the factory reset procedure.

**LED 1**

Exposes the state of the Occupancy sensor.

- _Solid On_ ; Occupancy is detected
- _Off_ ; No Occupancy detected

**Push Button 0**

- _Press and Release_: Cycles LED screen and
  start or restart BLE advertisement in fast mode. It will advertise in this mode
  for 30 seconds. The device will then switch to a slower interval advertisement.
  After 15 minutes, the advertisement stops. In addition, this button should also print the QR Code URL to the RTT logs.

- _Pressed and hold for 6 s_: Initiates the factory reset of the device.
  Releasing the button within the 6-second window cancels the factory reset
  procedure. **LEDs** blink in unison when the factory reset procedure is
  initiated.

**Push Button 1**

- Toggles the Occupancy sensor state : detected / undetected.

## Multi-Sensor-app Configuration

The two configuration options available in the Multi Sensor App are the `SL_MATTER_SENSOR_TIMER_PERIOD_S` and the `SL_MATTER_SENSOR_REPORT_THRESHOLD`.
These configuration options are exposed in the `sl_matter_sensor_config.h` header.

The `SL_MATTER_SENSOR_TIMER_PERIOD_S` configures the period at which the device will read the sensor values. The default value for this configuration is 1 minute.
With the default configuration, the device will read the sensor value every second.

The `SL_MATTER_SENSOR_REPORT_THRESHOLD` defines the necessary value change from the last reported value for the device to trigger a subscription update. The configuration option is in centi-unit.
The default value for this configuration is 100.
With this default configuration, the device will only trigger a subscription repport when there is 1 unit of change from the last report value.

## Enabling LCD and LEDs in a Project

If an LCD is supported by the board but not enabled in a project it can be enabled in Studio by installing the _Matter Display_ component under _Silicon Labs Matter_

To enable the QR Code install the _Matter QR Code Display_ component under _Silicon Labs Matter_. (All the dependencies including LCD are installed automatically. There is no need to explicitly install the _Matter Display_ component in this case.)

If LEDs are supported by the board but not enabled in a project they can be enabled as follows:

- Install instances (led0 and led1) of the _Simple LED_ component under _Platform->Driver->LED->Simple LED_
- Install the WSTK LED Support component under _Silicon Labs Matter->Matter->Platform->WSTK LED Support_

## Provision and Control

You can provision and control the Matter device using the python controller, chip-tool (standalone or pre-built), Android, iOS app or the mattertool utility from the Matter Hub package provided by Silicon Labs. The pre-built chip-tool instance ships with the Matter Hub image. More information on using the Matter Hub can be found in the online Matter documentation here: [Silicon Labs Matter Documentation](https://docs.silabs.com/matter/2.6.1/matter-thread/raspi-img) 

More information on using the chip-tool directly can be found here: [CHIPTool](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md)

Here is an example with the chip-tool:

```shell
./chip-tool pairing ble-wifi <Node-ID> $SSID $PSK 20202021 3840
```

### Sensor Commands

```shell
./chip-tool occupancysensing read occupancy <Node-ID> 1
```

Operate on DUT to change the occupancy status by pressing BTN1 and read the occupancy using the above command again.

```shell
./chip-tool temperaturemeasurement read measured-value <Node-ID> 2
```

```shell
./chip-tool relativehumiditymeasurement read measured-value <Node-ID> 2
```
