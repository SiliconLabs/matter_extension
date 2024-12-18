# CHIP SiWx917 SoC Lock Example

The SiWx917 SoC lock example provides a baseline demonstration of a door lock control
device, built using Matter and the Silicon Labs Gecko SDK. It can be controlled by
a Matter controller over Wifi network.
    
The SiWx917 SoC device can be commissioned over Bluetooth Low Energy where the device
and the Matter controller will exchange security information with the Rendez-vous
procedure.
    
The LCD on the Silabs WSTK shows a QR Code containing the needed commissioning
information for the BLE connection and starting the Rendez-vous procedure.
    
The lock example is intended to serve both as a means to explore the
workings of Matter as well as a template for creating real products based on the
Silicon Labs platform. **This example is defaulted to use full ICD functionality
out-of-the-box and therefore has the matter_icd_management component enabled.**

For more general information on running matter applications and pre-requisites please look at online 
documentation for Matter available on docs.silabs.com. Follow Wi-Fi instructions depending on the example you are running.
[Demo instructions for Wi-Fi](https://docs.silabs.com/matter/2.5.0/matter-wifi)

## Lock Application User Interface

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

-   _Short Flash On (50 ms on/950 ms off)_ ; The device is in the unprovisioned (unpaired) state and is waiting for a commissioning application to connect.

-   _Rapid Even Flashing_ ; (100 ms on/100 ms off)_ &mdash; The device is in the unprovisioned state and a commissioning application is connected through Bluetooth LE.

-   _Short Flash Off_ ; (950ms on/50ms off)_ &mdash; The device is fully provisioned, but does not yet have full service connectivity.

-   _Solid On_ ; The device is fully provisioned and has full service connectivity.

**LED 1** 

Simulates the Lock The following states are possible:

-   _Solid On_ ; Bolt is unlocked
-   _Blinking_ ; Bolt is moving to the desired state
-   _Off_ ; Bolt is locked

**Push Button 0**

-   _Press and Release_ : Start, or restart, BLE advertisement in fast mode. It will advertise in this mode
for 30 seconds. The device will then switch to a slower interval advertisement.
After 15 minutes, the advertisement stops. In addition, this button should also print the QR Code URL to the RTT logs.

-   _Pressed and hold for 6 s_ : Initiates the factory reset of the device. Releasing the button within the 6-second window cancels the factory reset procedure. **LEDs** blink in unison when the factory reset procedure is initiated.

**Push Button 1** 

- Toggles the bolt state On/Off

## Provision and Control

You can provision and control the Matter device using the python controller, chip-tool (standalone or pre-built), Android, iOS app or the mattertool utility from the Matter Hub package provided by Silicon Labs. The pre-built chip-tool instance ships with the Matter Hub image. More information on using the Matter Hub can be found in the online Matter documentation here: [Silicon Labs Matter Documentation](https://docs.silabs.com/matter/2.5.0/matter-thread/raspi-img)


    
More information on using the chip-tool directly can be found here: [CHIPTool](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md)

Here is some CHIPTool examples:

Pairing with chip-tool:
```shell
chip-tool pairing ble-wifi 1122 $SSID $PSK 20202021 3840
```

Set a user:
```shell
./out/chip-tool doorlock set-user OperationType UserIndex UserName UserUniqueId UserStatus UserType CredentialRule node-id/group-id

./out/chip-tool doorlock set-user 0 1 "mike" 5 1 0 0 1 1 --timedInteractionTimeoutMs 1000
```

Set a credential:
```shell
./out/chip-tool doorlock set-credential OperationType Credential CredentialData UserIndex UserStatus UserType node-id/group-id

./out/chip-tool doorlock set-credential 0 '{ "credentialType": 1, "credentialIndex": 1 }' "123456" 1 null null 1 1 --timedInteractionTimeoutMs 1000
```

Changing a credential:
```shell
./out/chip-tool doorlock set-credential OperationType Credential CredentialData UserIndex UserStatus UserType node-id/group-id

./out/chip-tool doorlock set-credential 2 '{ "credentialType": 1, "credentialIndex": 1 }' "123457" 1 null null 1 1 --timedInteractionTimeoutMs 1000
```

Get a user:
```shell
./out/chip-tool doorlock get-user UserIndex node-id/group-id

./out/chip-tool doorlock get-user 1 1 1
```

Unlock door:
```shell
./out/chip-tool doorlock unlock-door node-id/group-id

./out/chip-tool doorlock unlock-door 1 1 --timedInteractionTimeoutMs 2000
```

Lock door:
```shell
./out/chip-tool doorlock lock-door node-id/group-id

./out/chip-tool doorlock lock-door 1 1 --timedInteractionTimeoutMs 2000
```
