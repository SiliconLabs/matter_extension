# Matter EFR32 Light Switch Example

The EFR32 light switch example provides a baseline demonstration of a on-off
light switch device, built using Matter and the Silicon Labs Gecko SDK. It can
be controlled by a Chip controller over an Openthread network.

The EFR32 device can be commissioned over Bluetooth Low Energy where the device
and the Chip controller will exchange security information with the Rendez-vous
procedure. If using Thread, Thread Network credentials are then provided to the
EFR32 device which will then join the network.

If the LCD is enabled, the LCD on the Silabs WSTK shows a QR Code containing the
needed commissioning information for the BLE connection and starting the
Rendez-vous procedure.

The light switch example is intended to serve both as a means to explore the
workings of Matter as well as a template for creating real products based on the
Silicon Labs platform. **This example is defaulted to use full ICD functionality
out-of-the-box and therefore has the matter_icd_management component enabled.**

For more general information on running matter applications and pre-requisites please look at online
documentation for Matter available on docs.silabs.com. Follow Thread demo instructions depending on the example you are running.
[Demo instructions for Thread](https://docs.silabs.com/matter/2.2.2/matter-thread)

## Light Switch Specific Interface

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

-   **ICD Configuration (Default)** - LED is only active under two circumstances:

    1. Factory reset sequence - LED will blink when initiated upon press and hold of
    Button 0 after 3 seconds
    2. An Identify command was received

-   **Non-ICD Configuration** - shows the overall state of the device and its connectivity. The
    following states are possible:

    - *Short Flash On* (50 ms on/950 ms off): The device is in the
    unprovisioned (unpaired) state and is waiting for a commissioning
    application to connect.

    - *Rapid Even Flashing* (100 ms on/100 ms off): The device is in the
    unprovisioned state and a commissioning application is connected through
    Bluetooth LE.

    - *Short Flash Off* (950ms on/50ms off): The device is fully
    provisioned, but does not yet have full Thread network or service
    connectivity.

    - *Solid On*: The device is fully provisioned and has full Thread
    network and service connectivity.

**Push Button 0**

-   _Press and Release_ : Start, or restart, BLE advertisement in fast mode. It will advertise in this mode
for 30 seconds. The device will then switch to a slower interval advertisement.
After 15 minutes, the advertisement stops. In addition, this button should also print the QR Code URL to the RTT logs.

-   _Pressed and hold for 6 s_ : Initiates the factory reset of the device. Releasing the button within the 6-second window cancels the factory reset procedure. **LEDs** blink in unison when the factory reset procedure is initiated.

**Push Button 1**

-   Sends a Toggle command to bound light app

**Matter shell**

**_OnOff Cluster_**

-  'switch onoff on'            : Sends unicast On command to bound device
-  'switch onoff off'           : Sends unicast Off command to bound device
-  'switch onoff toggle'        : Sends unicast Toggle command to bound device

-  'switch groups onoff on'     : Sends On group command to bound group
-  'switch groups onoff off'    : Sends On group command to bound group
-  'switch groups onoff toggle' : Sends On group command to bound group

**_Binding Cluster_**

- 'switch binding unicast  [*fabric index*] [*node id*] [*endpoint*]' : Creates a unicast binding
- 'switch binding group [*fabric index*] [*group id*]'              : Creates a group binding


## Enabling LCD and LEDs in a Project

If an LCD is supported by the board but not enabled in a project it can be enabled in Studio by installing the _Display_ component under _Silicon Labs Matter->Matter->Platform->Display_

To enable the QR Code install the _QR Code_ component under _Silicon Labs Matter->Matter->Platform->QR Code_. (All the dependencies including LCD are installed automatically, there is no need to explicitly install the _Display_ component in this case.)

If LEDs are supported by the board but not enabled in a project they can be enabled as follows:
-   Install instances (led0 and led1) of the _Simple LED_ component under _Platform->Driver->LED->Simple LED_
-   Install the WSTK LED Support component under _Silicon Labs Matter->Matter->Platform->WSTK LED Support_