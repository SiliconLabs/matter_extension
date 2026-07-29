# Matter over Thread Closure Example

The Matter over Thread closure example is a baseline demonstration of a closure device built with Simplicity SDK. It can be controlled by a Matter controller over a Thread network.

## Table of Contents

- [Purpose/Scope](#purposescope)
- [Prerequisites/Setup Requirements](#prerequisitessetup-requirements)
- [Steps to Run Demo](#steps-to-run-demo)
- [Extending Base App Implementation](#extending-base-app-implementation)
  - [CustomerAppManager](#customerappmanager)
  - [How to Override APIs](#how-to-override-apis)
  - [DataModelCallbacks and CustomerAppManager](#datamodelcallbacks-and-customerappmanager)
  - [Sample Implementation](#sample-implementation)
  - [Override API Reference](#override-api-reference)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)
- [Report Bugs & Get Support](#report-bugs--get-support)

## Purpose/Scope

This example demonstrates a sample implementation of a Matter over Thread closure
app running on a Silicon Labs EFR32 SoC.

The device is commissioned over Bluetooth Low Energy (BLE), during which the Matter
controller and device exchange security credentials in the Rendez-vous procedure.

If the LCD is enabled, the LCD on the Silicon Labs WSTK shows a QR Code containing the needed
commissioning information for the BLE connection and starting the Rendez-vous procedure.

This example serves as both a functional demonstration of Matter over Thread and a
starting point for building production closure products on the Silicon Labs platform.

Sample endpoint configuration for Closure: see [Closure Sample Endpoint](/slc/image/closure-sample-endpoint.png).

## Prerequisites/Setup Requirements

### HW Requirements

For a full list of hardware requirements, see [Matter Hardware Requirements](https://docs.silabs.com/matter/2.9.1/matter-overview/#hardware-requirements) documentation.

### SW Requirements

For a full list of software requirements, see [Matter Software Requirements](https://docs.silabs.com/matter/2.9.1/matter-overview/#software-requirements) documentation.

## Steps to Run Demo

### Program a Bootloader

If building a solution, the bootloader is included and flashed as part of the combined
artifact.

If building the sample application on its own, a bootloader must be flashed separately
before the application. Pre-built bootloader binaries for all supported devices are
available at [Matter Bootloader Binaries](https://docs.silabs.com/matter/2.9.1/matter-prerequisites/matter-artifacts#matter-bootloader-binaries).

### Configuration and Setup

This sample app works out of the box with no additional configuration required. To customize the device, see the
[Custom Matter Device Development](https://docs.silabs.com/matter/2.9.1/matter-references/custom-matter-device#custom-matter-device-development) guide.

### Sample Endpoint Configuration for Closure

![Closure Sample Endpoint](/slc/image/closure-sample-endpoint.png)

### Steps for Execution

1. Build and flash the bootloader and application to your board.
2. On startup, **LED 0** flashes short-on (50 ms on / 950 ms off), indicating the
   device is waiting for commissioning.
3. Commission the device using one of the following methods:

   **chip-tool (standalone or pre-built):** The pre-built chip-tool instance ships
   with the Matter Hub image. More information on using the Matter Hub is in the
   [Silicon Labs Matter Hub Documentation](https://docs.silabs.com/matter/2.9.1/matter-thread/raspi-img).
   ```shell
   chip-tool pairing ble-thread 1 hex:<operationalDataset> 20202021 3840
   ```

   **Simplicity Connect mobile app:** scan the QR code shown on the LCD or the URL
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

4. Control the device. For sample endpoint configuration, see [Closure Sample Endpoint](/slc/image/closure-sample-endpoint.png).

   **Closure control (chip-tool)** (after commissioning, use your node-id if different from 1):
   ```shell
   chip-tool closurecontrol read cluster-revision 1 1
   ```

**Button and LED reference:**

| Control | Action            | Result                                                          |
|---------|-------------------|-----------------------------------------------------------------|
| BTN0    | Press and release | Start/restart BLE advertisement, print QR code URL to RTT logs |
| BTN0    | Hold 6 s          | Initiate factory reset (release within 6 s to cancel)          |
| BTN1    | Press and release | Toggle closure fully open / fully closed (stops motion if already in progress) |
| LED 0   | Short flash on    | Unprovisioned, waiting for commissioning                        |
| LED 0   | Rapid even flash  | BLE connected, commissioning in progress                        |
| LED 0   | Short flash off   | Provisioned, no full Thread connectivity                        |
| LED 0   | Solid on          | Fully provisioned with Thread connectivity                      |

## Extending Base App Implementation

See [Extending Base App Implementation](https://docs.silabs.com/matter/2.9.1/matter-references/custom-matter-device#extending-base-app-implementation)
for `CustomerAppTask` customization, CRTP `*Impl()` hooks, and data model
callback routing. Per-example AppTask API references:
`autogen/AppTaskImpl.h`, `autogen/AppTask.cpp`.

| Concern | Base | CRTP hook layer | Customer leaf |
| ------- | ---- | --------------- | ------------- |
| Lifecycle / UI / buttons / DM callbacks | `AppTask` | `AppTaskImpl` | `CustomerAppTask` |
| Closure domain logic (motion, latch, panels) | `ClosureManager` | `ClosureManagerImpl` | `CustomerAppManager` |

### CustomerAppManager

Closure domain logic lives on `ClosureManager`. The customer leaf is provided as
`CustomerAppManager.h` and `CustomerAppManager.cpp`. Override `*Impl()` hooks
there; do not edit `ClosureManager.cpp` for app-specific behavior. See
`autogen/ClosureManagerImpl.h` for the full hook list.

### How to Override APIs

Both leaves use the Curiously Recurring Template Pattern (CRTP). You override only the `*Impl()` methods you need; each base declares one `*Impl()` per overridable API. Steps:

1. Find the method to override in the base API (see [Override API reference](#override-api-reference) below).
2. Declare the same method signature in `CustomerAppTask.h` or `CustomerAppManager.h` under `private:`. Match the base `*Impl()` signature exactly — note that `*Impl()` overrides are non-static instance methods even when the public dispatcher (e.g. `ButtonEventHandler`) is static.
3. Implement the method in the corresponding `.cpp`.
4. Build the project. Each overridable API is resolved as follows: **if you implemented that `*Impl()` in the customer leaf, your implementation is used, otherwise the Silicon Labs default implementation is used.** You only implement what you need, everything else falls back to the default automatically.

Some `ClosureManager` APIs (`Init`, cluster `On*Command` handlers) are virtual
so shared `closure-common/` code can reach your leaf. Override the matching
`*Impl()` on `CustomerAppManager` — do not override the virtuals directly.

### DataModelCallbacks and CustomerAppManager

In addition to the general data model callback routing described in
[Extending Base App Implementation](https://docs.silabs.com/matter/2.9.1/matter-references/custom-matter-device#datamodelcallbacks-and-customerapptask),
this app forwards closure-specific cluster attribute-changed callbacks
(`MatterClosureControlClusterServerAttributeChangedCallback`,
`MatterClosureDimensionClusterServerAttributeChangedCallback`) from `AppTask.cpp`
to `DMClosureControlClusterAttributeChangedCallback` /
`DMClosureDimensionClusterAttributeChangedCallback`, customized via the matching
`*Impl()` hooks on `CustomerAppTask`.

Forwarding into `AppTask` still goes through CRTP as in
[How to Override APIs](#how-to-override-apis).

-   **Methods that already exist in the ClosureManager** — Customize them by
    overriding the matching `*Impl()` method in `CustomerAppManager`. Do not
    edit `ClosureManager.cpp` for app-specific behavior.

-   **New custom data model methods** — Add them in `CustomerAppTask` or
    `CustomerAppManager` directly. Do not add new application logic in
    autogenerated sources; those edits will not survive regeneration or project
    upgrades.

### Sample Implementation

The following shows a minimal example that overrides `AppInitImpl()` and
`ButtonEventHandlerImpl()` on `CustomerAppTask`, and adds
`OnMoveToCommandImpl()` to the existing `CustomerAppManager` leaf. Declare the
manager hook under `private:` without replacing `GetInstance` / `sInstance`.

**CustomerAppTask.h**

```cpp
#pragma once
#include "AppTaskImpl.h"

/**
 * Minimal AppTaskImpl-derived class. Override only the *Impl() methods you need;
 * add AppInitImpl(), GetAppTask(), and sAppTask as required by the CRTP base.
 */
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
#define APP_CLOSURE_BUTTON  1

CustomerAppTask CustomerAppTask::sAppTask;

AppTask & AppTask::GetAppTask()
{
    return CustomerAppTask::GetAppTask();
}

CHIP_ERROR CustomerAppTask::AppInitImpl()
{
    SILABS_LOG("CustomerAppTask: custom implementation (AppInitImpl)");
    CHIP_ERROR err = this->AppTask::AppInit();
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
    if (button == APP_CLOSURE_BUTTON && btnAction == static_cast<uint8_t>(SilabsPlatform::ButtonAction::ButtonPressed))
    {
        button_event.Handler = &CustomerAppTask::ClosureButtonActionEventHandler;
        AppTask::GetAppTask().PostEvent(&button_event);
    }
    else if (button == APP_FUNCTION_BUTTON)
    {
        button_event.Handler = BaseApplication::ButtonHandler;
        AppTask::GetAppTask().PostEvent(&button_event);
    }
}
```

**CustomerAppManager.h**

```cpp
chip::Protocols::InteractionModel::Status OnMoveToCommandImpl(
    const chip::Optional<chip::app::Clusters::ClosureControl::TargetPositionEnum> position,
    const chip::Optional<bool> latch,
    const chip::Optional<chip::app::Clusters::Globals::ThreeLevelAutoEnum> speed);
```

**CustomerAppManager.cpp**

```cpp
chip::Protocols::InteractionModel::Status CustomerAppManager::OnMoveToCommandImpl(
    const chip::Optional<chip::app::Clusters::ClosureControl::TargetPositionEnum> position,
    const chip::Optional<bool> latch,
    const chip::Optional<chip::app::Clusters::Globals::ThreeLevelAutoEnum> speed)
{
    SILABS_LOG("CustomerAppManager: custom implementation (OnMoveToCommandImpl)");
    // Call through for default motion behavior, or drive real hardware here.
    return ClosureManager::OnMoveToCommand(position, latch, speed);
}
```

### Override API Reference

This example has a ClosureManager CRTP chain in addition to the AppTask chain
documented in
[Extending Base App Implementation](https://docs.silabs.com/matter/2.9.1/matter-references/custom-matter-device#override-api-reference):

| File | Purpose |
|------|--------|
| `autogen/ClosureManagerImpl.h` | Declarations of every overridable `*Impl()` method. Copy the signatures you need from here into `CustomerAppManager.h`. |
| `autogen/ClosureManager.cpp` | Silicon Labs default implementation of ClosureManager. This is what runs for any `*Impl()` you do not override. Use as reference when customizing behavior. |

## Troubleshooting

**Device does not advertise over BLE**
- Press BTN0 to restart BLE advertisement.
- Confirm the bootloader is flashed to the device.

**Commissioning fails**
- Ensure the Thread Border Router is running and reachable.
- Verify the `operationalDataset` hex string matches your Thread network.
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

- [Silicon Labs Matter over Thread Documentation](https://docs.silabs.com/matter/2.9.1/matter-thread)
- [Matter Hub Setup](https://docs.silabs.com/matter/2.9.1/matter-thread/raspi-img)
- [chip-tool README](https://github.com/project-chip/connectedhomeip/blob/master/examples/chip-tool/README.md)

## Report Bugs & Get Support

You are always encouraged and welcome to report any issues you found to us via [Silicon Labs Community](https://community.silabs.com).
