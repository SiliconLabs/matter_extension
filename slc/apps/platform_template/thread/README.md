# Matter over Thread Platform Template Example

A minimal Matter over Thread platform example with essential clusters on Silicon Labs MG24/MG26 and Rainier. Foundation for building Matter applications.

## Table of Contents

- [Purpose/Scope](#purposescope)
- [Prerequisites/Setup Requirements](#prerequisitessetup-requirements)
- [Steps to Run Demo](#steps-to-run-demo)
- [Extending Base App Implementation](#extending-base-app-implementation)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)
- [Report Bugs & Get Support](#report-bugs--get-support)

## Purpose/Scope

This example demonstrates a minimal Matter platform implementation on Silicon Labs EFR32 (MG24/MG26) devices. It provides the essential Matter clusters required for commissioning, network management, and basic device operation over Thread. This platform app serves as a foundation for building more complex Matter applications.

The device is commissioned over Bluetooth Low Energy (BLE), during which the Matter controller and device exchange security credentials in the Rendez-vous procedure.

**Supported clusters:** Root Node (Endpoint 0): Base, Access Control, Access Control Enforcement, Administrator Commissioning, General Diagnostics, General Commissioning, Group Communication, Localization Configuration, Network Commissioning, Node Operational Credentials, Secure Channel, Thread Network Diagnostic, Time Format Localization. Endpoint 1: Groups.

**Customizing:** You can add Matter clusters by modifying the ZAP configuration and regenerating the data model. Configuration options (network commissioning, device identification, diagnostic intervals, security) can be adjusted via component configuration files. Build steps are documented in the project root README (e.g. `python3 slc/sl_build.py MyNewApp/platform-app.slcw brd4187c`).

## Prerequisites/Setup Requirements

### HW Requirements

For a full list of hardware requirements, see [Matter Hardware Requirements](https://docs.silabs.com/matter/2.9.0/matter-overview/#hardware-requirements) documentation.

### SW Requirements

For a full list of software requirements, see [Matter Software Requirements](https://docs.silabs.com/matter/2.9.0/matter-overview/#software-requirements) documentation. Host build prerequisites include ARM GCC 12.2, ZAP (2024.05.07 or greater), SLC-CLI, and environment variables (ARM_GCC_DIR, TOOLDIR, STUDIO_ADAPTER_PACK_PATH).

## Steps to Run Demo

### Program a Bootloader

If building a solution, the bootloader is included and flashed as part of the combined artifact.

If building the sample application on its own, a bootloader must be flashed separately before the application. Pre-built bootloader binaries for all supported devices are available at [Matter Bootloader Binaries](https://docs.silabs.com/matter/2.9.0/matter-prerequisites/matter-artifacts#matter-bootloader-binaries).

### Configuration and Setup

This sample app works out of the box with no additional configuration required. To customize the device, see the [Custom Matter Device Development](https://docs.silabs.com/matter/2.9.0/matter-references/custom-matter-device#custom-matter-device-development) guide.

**Building:** Build steps are in the project root README. Example (Linux/Mac): `python3 slc/sl_build.py MyNewApp/platform-app.slcw brd4187c`.

**Expected behaviour:** After build and flash, the device advertises over BLE and shows the Matter QR code if the display is enabled. Once commissioned, the device can be managed through Matter controllers for configuration and monitoring.

### Steps for Execution

1. Build and flash the bootloader and application to your board (see project root README for build commands).
2. On startup, the device advertises over BLE and shows the Matter QR code if the display is enabled.
3. Commission the device using chip-tool, Simplicity Connect, or another Matter controller (e.g. `chip-tool pairing ble-thread 1 hex:<operationalDataset> 20202021 3840`).
4. After commissioning, the device can be managed through Matter controllers for configuration and monitoring.

**Button and LED reference:**

This app does not define application-specific buttons or LEDs. If WSTK LED Support is installed, LED 0 may indicate commissioning/connectivity state.

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

### Sample Implementation

The following shows a minimal example `CustomerAppTask` that overrides
`AppInitImpl()` and `ButtonEventHandlerImpl()`.

**CustomerAppTask.h**

```cpp
#pragma once
#include "AppTaskImpl.h"

/**
 * Minimal AppTaskImpl-derived class. Override only the *Impl() methods you need **/
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
#include "AppConfig.h"
#include "AppEvent.h"
#include <platform/CHIPDeviceLayer.h>
#include <platform/silabs/platformAbstraction/SilabsPlatform.h>

using namespace ::chip::DeviceLayer::Silabs;

#define APP_FUNCTION_BUTTON 0
#define APP_USER_ACTION 1

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
    AppEvent button_event           = {};
    button_event.Type               = AppEvent::kEventType_Button;
    button_event.ButtonEvent.Action = btnAction;

    if (button == APP_USER_ACTION)
    {
        button_event.Handler = &CustomerAppTask::ApplicationEventHandler;
        AppTask::GetAppTask().PostEvent(&button_event);
    }
    if (button == APP_FUNCTION_BUTTON)
    {
        button_event.Handler = BaseApplication::ButtonHandler;
        AppTask::GetAppTask().PostEvent(&button_event);
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
- Confirm the bootloader is flashed to the device.

**Commissioning fails**
- Ensure the Thread Border Router is running and reachable.
- Verify the `operationalDataset` hex string matches your Thread network.

**LCD or LEDs not working**
- **LCD:** If the board supports an LCD but it is not enabled, install the _Display_ component under _Silicon Labs Matter > Matter > Platform > Display_. For the QR code on the LCD, install the _QR Code_ component under _Silicon Labs Matter > Matter > Platform > QR Code_ (Display is installed automatically).
- **LEDs:** If the board supports LEDs but they are not enabled, install `led0` and `led1` instances of _Simple LED_ under _Platform > Driver > LED > Simple LED_, then install _WSTK LED Support_ under _Silicon Labs Matter > Matter > Platform > WSTK LED Support_.

## Resources

- [Silicon Labs Matter over Thread Documentation](https://docs.silabs.com/matter/2.9.0/matter-thread)
- [Matter Hub Setup](https://docs.silabs.com/matter/2.9.0/matter-thread/raspi-img)
- [chip-tool README](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md)

## Report Bugs & Get Support

You are always encouraged and welcome to report any issues you found to us via [Silicon Labs Community](https://community.silabs.com).
