# MATTER EFR32 Onoff-plug Example

An example showing the use of MATTER on the Silicon Labs EFR32 MG24.

<hr>

- [MATTER EFR32 Onoff-plug Example](#matter-efr32-onoff-plug-example)
  - [Introduction](#introduction)
  - [Building](#building)
  - [Flashing the Application](#flashing-the-application)
  - [Viewing Logging Output](#viewing-logging-output)
  - [Running the Complete Example](#running-the-complete-example)
    - [Notes](#notes)
  - [Running RPC console](#running-rpc-console)
  - [Device Tracing](#device-tracing)
  - [Memory settings](#memory-settings)
  - [OTA Software Update](#ota-software-update)
  - [Group Communication (Multicast)](#group-communication-multicast)
  - [Building options](#building-options)
    - [Disabling logging](#disabling-logging)
    - [Debug build / release build](#debug-build--release-build)
    - [Disabling LCD](#disabling-lcd)
    - [KVS maximum entry count](#kvs-maximum-entry-count)

<hr>

<a name="intro"></a>

## Introduction

The EFR32 onoff-plug example provides a baseline demonstration of a Plug/outlet
control device, built using Matter and the Silicon Labs simplicity SDK. It can be
controlled by a Matter controller over Openthread network..

The EFR32 device can be commissioned over Bluetooth Low Energy where the device
and the Matter controller will exchange security information with the
Rendez-vous procedure. Thread Network credentials are then provided to the EFR32
device which will then join the network.

The LCD on the Silabs WSTK shows a QR Code containing the needed commissioning
information for the BLE connection and starting the Rendez-vous procedure.

The onoff-plug example is intended to serve both as a means to explore the
workings of MATTER as well as a template for creating real products based on the
Silicon Labs platform.

<a name="building"></a>

## Building

-   Download the
    [Simplicity Commander](https://www.silabs.com/mcu/programming-options)
    command line tool, and ensure that `commander` is your shell search path.
    (For Mac OS X, `commander` is located inside
    `Commander.app/Contents/MacOS/`.)

-   Download and install a suitable ARM gcc tool chain:
    [GNU Arm Embedded Toolchain 9-2019-q4-major](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads)

-   Install some additional tools (likely already present for MATTER
    developers):

    -   Linux: `sudo apt-get install git ninja-build`

    -   Mac OS X: `brew install ninja`

-   Supported hardware:

    -   > For the latest supported hardware please refer to the
        > [Hardware Requirements](https://github.com/SiliconLabs/matter/blob/latest/docs/silabs/general/HARDWARE_REQUIREMENTS.md)
        > in the Silicon Labs Matter Github Repo

    MG24 boards :

    -   BRD4186A / SLWSTK6006A / Wireless Starter Kit / 2.4GHz@10dBm
    -   BRD4187A / SLWSTK6006A / Wireless Starter Kit / 2.4GHz@20dBm

*   Build the example application:

          cd ~/connectedhomeip
          ./scripts/examples/gn_efr32_example.sh ./examples/onoff-plug-app/efr32/ ./out/onoff-plug-app BRD4186C

-   To delete generated executable, libraries and object files use:

          $ cd ~/connectedhomeip
          $ rm -rf ./out/

    OR use GN/Ninja directly

          $ cd ~/connectedhomeip/examples/onoff-plug-app/efr32
          $ git submodule update --init
          $ source third_party/connectedhomeip/scripts/activate.sh
          $ export EFR32_BOARD=BRD4186C
          $ gn gen out/debug
          $ ninja -C out/debug

-   To delete generated executable, libraries and object files use:

          $ cd ~/connectedhomeip/examples/onoff-plug-app/efr32
          $ rm -rf out/

*   Build the example as Sleepy End Device (SED)

          $ ./scripts/examples/gn_efr32_example.sh ./examples/onoff-plug-app/efr32/ ./out/onoff-plug-app_SED BRD4161A --sed

    or use gn as previously mentioned but adding the following arguments:

          $ gn gen out/debug '--args=silabs_board="BRD4161A" enable_sleepy_device=true matter_openthread_ftd=false'

For more build options, help is provided when running the build script without
arguments

         ./scripts/examples/gn_efr32_example.sh

<a name="flashing"></a>

## Flashing the Application

-   On the command line:

          $ cd ~/connectedhomeip/examples/onoff-plug-app/efr32
          $ python3 out/debug/matter-efr32-onoff-plug-example.flash.py

-   Or with the Ozone debugger, just load the .out file.

<a name="view-logging"></a>

## Viewing Logging Output

The example application is built to use the SEGGER Real Time Transfer (RTT)
facility for log output. RTT is a feature built-in to the J-Link Interface MCU
on the WSTK development board. It allows bi-directional communication with an
embedded application without the need for a dedicated UART.

Using the RTT facility requires downloading and installing the _SEGGER J-Link
Software and Documentation Pack_
([web site](https://www.segger.com/downloads/jlink#J-LinkSoftwareAndDocumentationPack)).

Alternatively, SEGGER Ozone J-Link debugger can be used to view RTT logs too
after flashing the .out file.

-   Download the J-Link installer by navigating to the appropriate URL and
    agreeing to the license agreement.

-   [JLink_Linux_x86_64.deb](https://www.segger.com/downloads/jlink/JLink_Linux_x86_64.deb)
-   [JLink_MacOSX.pkg](https://www.segger.com/downloads/jlink/JLink_MacOSX.pkg)

*   Install the J-Link software

          $ cd ~/Downloads
          $ sudo dpkg -i JLink_Linux_V*_x86_64.deb

*   In Linux, grant the logged in user the ability to talk to the development
    hardware via the linux tty device (/dev/ttyACMx) by adding them to the
    dialout group.

          $ sudo usermod -a -G dialout ${USER}

Once the above is complete, log output can be viewed using the JLinkExe tool in
combination with JLinkRTTClient as follows:

-   Run the JLinkExe tool with arguments to autoconnect to the WSTK board:

    For MG21 use:

          $ JLinkExe -device EFR32MG21AXXXF1024 -if SWD -speed 4000 -autoconnect 1

-   In a second terminal, run the JLinkRTTClient to view logs:

          $ JLinkRTTClient

<a name="running-complete-example"></a>

## Running the Complete Example

-   It is assumed here that you already have an OpenThread border router
    configured and running. If not see the following guide
    [Openthread_border_router](https://github.com/project-matter/connectedhomeip/blob/master/docs/guides/openthread_border_router_pi.md)
    for more information on how to setup a border router on a raspberryPi.

    Take note that the RCP code is available directly through
    [Simplicity Studio 5](https://www.silabs.com/products/development-tools/software/simplicity-studio/simplicity-studio-5)
    under File->New->Project Wizard->Examples->Thread : ot-rcp

-   User interface : **LCD** The LCD on Silabs WSTK shows a QR Code. This QR
    Code is be scanned by the MATTER Tool app For the Rendez-vous procedure over
    BLE

        * On devices that do not have or support the LCD Display like the BRD4166A Thunderboard Sense 2,
          a URL can be found in the RTT logs.

          <info  > [SVR] Copy/paste the below URL in a browser to see the QR Code:
          <info  > [SVR] https://project-matter.github.io/connectedhomeip/qrcode.html?data=CH%3AI34NM%20-00%200C9SS0

    **LED 0** shows the overall state of the device and its connectivity. The
    following states are possible:

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

    **LED 1** Simulates the Plug/Outlet state The following states are possible:

        -   _Solid On_ ; Plug/Outlet provides power
        -   _Off_ ; Plug/Outlet is off

    **Push Button 0**

        -   _Press and Release_ : Start, or restart, BLE advertisement in fast mode. It will advertise in this mode
            for 30 seconds. The device will then switch to a slower interval advertisement.
            After 15 minutes, the advertisement stops.

        -   _Pressed and hold for 6 s_ : Initiates the factory reset of the device.
            Releasing the button within the 6-second window cancels the factory reset
            procedure. **LEDs** blink in unison when the factory reset procedure is
            initiated.

    **Push Button 1** Toggles the plug state On/Off

### Commissioning

  You can provision and control the Matter device using the python controller,
  `mattertool` standalone, Android, or iOS app.

  Silabs provides `mattertool` as a wrapper function and more user-friendly method of using 
  [chip-tool](../../examples/chip-tool/README.md) within the pre-built Raspberry Pi image. For more info on using `mattertool`, see 
  [Mattertool](../../docs/silabs/thread/CHIP_TOOL.md).

  Here is an example using `mattertool`:

    $ mattertool startThread
    $ mattertool bleThread
    $ mattertool occupancysensing read occupancy 1 1

### Notes

-   Depending on your network settings your router might not provide native ipv6
    addresses to your devices (Border router / PC). If this is the case, you
    need to add a static ipv6 addresses on both device and then an ipv6 route to
    the border router on your PC

    -   On Border Router: `sudo ip addr add dev <Network interface> 2002::2/64`

    -   On PC(Linux): `sudo ip addr add dev <Network interface> 2002::1/64`

    -   Add Ipv6 route on PC(Linux)
        `sudo ip route add <Thread global ipv6 prefix>/64 via 2002::2`

<a name="running-pigweed-rpc-console"></a>

## Running RPC console

    Currently not supported

## Device Tracing

Device tracing is available to analyze the device performance. To turn on
tracing, build with RPC enabled. See Build the example with pigweed RPC.

Obtain tracing json file.

    $ ./{PIGWEED_REPO}/pw_trace_tokenized/py/pw_trace_tokenized/get_trace.py -d {PORT} -o {OUTPUT_FILE} \
    -t {ELF_FILE} {PIGWEED_REPO}/pw_trace_tokenized/pw_trace_protos/trace_rpc.proto

## Memory settings

While most of the RAM usage in MATTER is static, allowing easier debugging and
optimization with symbols analysis, we still need some HEAP for the crypto and
OpenThread. Size of the HEAP can be modified by changing the value of the
`configTOTAL_HEAP_SIZE` define inside of the FreeRTOSConfig.h file of this
example. Please take note that a HEAP size smaller than 13k can and will cause a
Mbedtls failure during the BLE rendez-vous or CASE session

To track memory usage you can set `enable_heap_monitoring = true` either in the
BUILD.gn file or pass it as a build argument to gn. This will print on the RTT
console the RAM usage of each individual task and the number of Memory
allocation and Free. While this is not extensive monitoring you're welcome to
modify `examples/platform/silabs/efr32/MemMonitoring.cpp` to add your own memory
tracking code inside the `trackAlloc` and `trackFree` function

## OTA Software Update

For the description of Software Update process with EFR32 example applications
see
[EFR32 OTA Software Update](../../docs/guides/silabs_efr32_software_update.md)

## Group Communication (Multicast)

With this onoff-plug example you can also use group communication to send
Onoff-plug commands to multiples devices at once. Please refer to the
[matter-tool documentation](../../matter-tool/README.md) _Configuring the server
side for Group Commands_ and _Using the Client to Send Group (Multicast) Matter
Commands_

## Building options

All of Silabs's examples within the Matter repo have all the features enabled by
default, as to provide the best end user experience. However some of those
features can easily be toggled on or off. Here is a short list of options to be
passed to the build scripts.

### Disabling logging

`matter_progress_logging, matter_detail_logging, matter_automation_logging`

    $ ./scripts/examples/gn_efr32_example.sh ./examples/onoff-plug-app/efr32 ./out/onoff-plug-app BRD4164A "matter_detail_logging=false matter_automation_logging=false matter_progress_logging=false"

### Debug build / release build

`is_debug`

    $ ./scripts/examples/gn_efr32_example.sh ./examples/onoff-plug-app/efr32 ./out/onoff-plug-app BRD4164A "is_debug=false"

### Disabling LCD

`show_qr_code`

    $ ./scripts/examples/gn_efr32_example.sh ./examples/onoff-plug-app/efr32 ./out/onoff-plug-app BRD4164A "show_qr_code=false"

### KVS maximum entry count

`kvs_max_entries`

    Set the maximum Kvs entries that can be stored in NVM (Default 75)
    Thresholds: 30 <= kvs_max_entries <= 255

    $ ./scripts/examples/gn_efr32_example.sh ./examples/onoff-plug-app/efr32 ./out/onoff-plug-app BRD4164A kvs_max_entries=50
