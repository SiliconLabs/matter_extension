# Matter over Wi-Fi Air Quality Sensor Example

The Matter over Wi-Fi air quality sensor example is a baseline demonstration of an air quality sensor built with Simplicity SDK. It can be controlled by a Matter controller over a Wi-Fi network.

## Table of Contents

- [Purpose/Scope](#purposescope)
- [Prerequisites/Setup Requirements](#prerequisitessetup-requirements)
- [Steps to Run Demo](#steps-to-run-demo)
- [Extending Base App Implementation](#extending-base-app-implementation)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)
- [Report Bugs & Get Support](#report-bugs--get-support)

## Purpose/Scope

This example demonstrates a sample implementation of a Matter over Wi-Fi air quality sensor
app running on a Silicon Labs SiWx917 SoC.

The device is commissioned over Bluetooth Low Energy (BLE), during which the Matter
controller and device exchange security credentials in the Rendez-vous procedure.
Wi-Fi credentials (SSID and PSK) are then provided so the device joins your Wi-Fi network and can be controlled by any Matter-compliant controller.

If the LCD is enabled, the LCD on the Silicon Labs WSTK shows a QR code containing
the commissioning information for the BLE connection and Rendez-vous procedure.

This example serves as both a functional demonstration of Matter over Wi-Fi and a
starting point for building production products on the Silicon Labs platform.

## Prerequisites/Setup Requirements

### HW Requirements

For a full list of hardware requirements, see [Matter Hardware Requirements](https://docs.silabs.com/matter/2.9.1/matter-overview/#hardware-requirements) documentation.

### SW Requirements

For a full list of software requirements, see [Matter Software Requirements](https://docs.silabs.com/matter/2.9.1/matter-overview/#software-requirements) documentation.

## Steps to Run Demo

### Configuration and Setup

This sample app works out of the box with no additional configuration required. To customize the device, see the
[Custom Matter Device Development](https://docs.silabs.com/matter/2.9.1/matter-references/custom-matter-device#custom-matter-device-development) guide.

**Region code (SiWx917 Wi-Fi):** For Wi-Fi configurations, the region code can be set in this [file](https://github.com/SiliconLabsSoftware/matter_sdk/blob/v2.9.1/src/platform/silabs/wifi/SiWx/WifiInterfaceImpl.cpp). The available region codes can be found [here](https://github.com/SiliconLabs/wiseconnect/blob/v4.1.1-content-for-docs/components/protocol/wifi/inc/sl_wifi_constants.h#L739).

### Steps for Execution

1. Build and flash the application to your board.
2. On startup, **LED 0** flashes short-on (50 ms on / 950 ms off), indicating the
   device is waiting for commissioning.
3. Commission the device using one of the following methods:

   **chip-tool (standalone or pre-built):** The pre-built chip-tool instance ships
   with the Matter Hub image. More information on using the Matter Hub is in the
   [Silicon Labs Matter Hub Documentation](https://docs.silabs.com/matter/2.9.1/matter-thread/raspi-img).
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

4. Control the device:
   ```shell
   chip-tool onoff on 1 1
   chip-tool onoff off 1 1
   ```

**Button and LED reference:**

| Control | Action            | Result                                                          |
|---------|-------------------|-----------------------------------------------------------------|
| BTN0    | Press and release | Start/restart BLE advertisement, print QR code URL to RTT logs |
| BTN0    | Hold 6 s          | Initiate factory reset (release within 6 s to cancel)           |
| BTN1    | Press and release | Toggle light state on/off                                       |
| LED 0   | Short flash on    | Unprovisioned, waiting for commissioning                        |
| LED 0   | Rapid even flash  | BLE connected, commissioning in progress                        |
| LED 0   | Short flash off   | Provisioned, no full service connectivity                       |
| LED 0   | Solid on          | Fully provisioned with service connectivity                     |
| LED 1   | Solid on         | Light is on                                                     |
| LED 1   | Off              | Light is off                                                    |

## Extending Base App Implementation

### CustomerAppTask

To implement custom app behavior you can override any Silicon Labs implemented API in the CustomerAppTask file. This example provides `CustomerAppTask.h` and `CustomerAppTask.cpp` for that purpose. The base implementation and the full set of overridable `*Impl()` APIs are supplied by the build system in `AppTask.cpp` and `AppTaskImpl.h` under `autogen/`. Any `*Impl()` you do not override keeps the Silicon Labs default behavior.

### How to Override APIs

`CustomerAppTask` derives from the base AppTask through the Curiously Recurring
Template Pattern (CRTP). You override only the `*Impl()` methods you need, the
base declares one `*Impl()` per overridable API. Steps:

1. Find the method to override in the base API (see
   [Override API reference](#override-api-reference) below).
2. Declare the same method signature in `CustomerAppTask` in your
   `CustomerAppTask.h` under `private:`. Match the base `*Impl()` signature
   exactly — note that `*Impl()` overrides are **non-static instance methods**
   even when the public dispatcher (e.g. `ButtonEventHandler`) is `static`.
3. Implement the method in `CustomerAppTask.cpp`.
4. Build. The CRTP layer automatically routes each call to your `*Impl()` if
   present, otherwise to the Silicon Labs default.

### DataModelCallbacks and CustomerAppTask

What used to live in `DataModelCallbacks.cpp` now lives in `AppTask.cpp`. The
Matter SDK's `MatterPostAttributeChangeCallback` is implemented in
`examples/platform/silabs/BaseApplication.cpp` and forwards to
`AppTask::DMPostAttributeChangeCallback` (defined in `AppTask.cpp`), which you
can customize via `DMPostAttributeChangeCallbackImpl()` in `CustomerAppTask`.

Forwarding into `AppTask` still goes through CRTP as in
[How to Override APIs](#how-to-override-apis).

-   **Methods that already exist in the AppTask** — Customize them by overriding
    the matching `*Impl()` method in `CustomerAppTask`. Do not edit the
    `AppTask.cpp` for app-specific behavior.

-   **New custom data model methods** — Add them in `CustomerAppTask` directly.
    Do not add new application logic in autogenerated sources; those edits will
    not survive regeneration or project upgrades.

### Sample Implementation

The following shows a minimal example `CustomerAppTask` that overrides
`AppInitImpl()` and `ButtonEventHandlerImpl()`.

**CustomerAppTask.h**

```cpp
#pragma once
#include "AppTaskImpl.h"

/** Minimal AppTaskImpl-derived class. Override only the *Impl() methods you need **/
class CustomerAppTask : public AppTaskImpl<CustomerAppTask>
{
public:
    static CustomerAppTask & GetAppTask() { return sAppTask; }

private:
    friend class AppTaskImpl<CustomerAppTask>;
    CHIP_ERROR AppInitImpl();
    void ButtonEventHandlerImpl(uint8_t button, uint8_t btnAction);
    static CustomerAppTask sAppTask;
};
```

**CustomerAppTask.cpp**

```cpp
#include "CustomerAppTask.h"
#include "AppTask.h"
#include "AppEvent.h"
#include <platform/CHIPDeviceLayer.h>
#include <platform/silabs/platformAbstraction/SilabsPlatform.h>

#define APP_FUNCTION_BUTTON 0

CustomerAppTask CustomerAppTask::sAppTask;

AppTask & AppTask::GetAppTask()
{
    return CustomerAppTask::GetAppTask();
}

CHIP_ERROR CustomerAppTask::AppInitImpl()
{
    SILABS_LOG("CustomerAppTask: custom implementation (AppInitImpl)");
    CHIP_ERROR err = AppTask::AppInit();
    if (err == CHIP_NO_ERROR)
    {
        // Override the SDK default button handler registered in AppTask::AppInit().
        chip::DeviceLayer::Silabs::GetPlatform().SetButtonsCb(CustomerAppTask::ButtonEventHandler);
    }
    return err;
}

void CustomerAppTask::ButtonEventHandlerImpl(uint8_t button, uint8_t btnAction)
{
    SILABS_LOG("CustomerAppTask: custom implementation (ButtonEventHandlerImpl)");
    AppEvent aEvent           = {};
    aEvent.Type               = AppEvent::kEventType_Button;
    aEvent.ButtonEvent.Action = btnAction;

    if (button == APP_FUNCTION_BUTTON)
    {
        aEvent.Handler = BaseApplication::ButtonHandler;
        AppTask::GetAppTask().PostEvent(&aEvent);
    }
}
```

### Override API Reference

The base API and implementation are generated into your project and live under `autogen/` directory. These files are regenerated on every project upgrade and match your installed SDK version. Use them as the reference for overridable methods and app configuration.

| File | Purpose |
|------|--------|
| `autogen/AppTaskImpl.h` | Declarations of every overridable `*Impl()` method. Copy the signatures you need from here into `CustomerAppTask.h`. |
| `autogen/AppTask.cpp` | Silicon Labs default implementation of AppTask. This is what runs for any `*Impl()` you do not override. Use as reference when customizing behavior. |

## Troubleshooting

**Device does not advertise over BLE**
- Press BTN0 to restart BLE advertisement.

**Commissioning fails**
- Ensure the Wi-Fi SSID and PSK are correct and the network is reachable.
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

- [Silicon Labs Matter over Wi-Fi Documentation](https://docs.silabs.com/matter/2.9.1/matter-wifi)
- [Matter Hub Setup](https://docs.silabs.com/matter/2.9.1/matter-thread/raspi-img)
- [chip-tool README](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md)

## Report Bugs & Get Support

You are always encouraged and welcome to report any issues you found to us via [Silicon Labs Community](https://community.silabs.com).
