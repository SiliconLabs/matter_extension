# Matter EFR32 Wake on Matter Example

An example showing the use of CHIP on the Silicon Labs EFR32 MG24.

<hr>

-   [Matter EFR32 Wake on Matter Example](#matter-efr32-wake-on-matter-example)
    -   [Introduction](#introduction)
    -   [Building](#building)
    -   [Flashing the Application](#flashing-the-application)
    -   [Viewing Logging Output](#viewing-logging-output)
        -   [SEGGER RTT (recommended)](#segger-rtt-recommended)
        -   [Console Log](#console-log)
            -   [Configuring the VCOM](#configuring-the-vcom)
        -   [Using the console](#using-the-console)
    -   [Running the Complete Example](#running-the-complete-example)
        -   [Notes](#notes)
    -   [Running RPC console](#running-rpc-console)
    -   [Device Tracing](#device-tracing)
    -   [Memory settings](#memory-settings)
    -   [OTA Software Update](#ota-software-update)
    -   [Group Communication (Multicast)](#group-communication-multicast)
    -   [Building options](#building-options)
        -   [Disabling logging](#disabling-logging)
        -   [Debug build / release build](#debug-build--release-build)
        -   [Disabling LCD](#disabling-lcd)
        -   [KVS maximum entry count](#kvs-maximum-entry-count)

<hr>

> **NOTE:** Silicon Laboratories now maintains a public matter GitHub repo with
> frequent releases thoroughly tested and validated. Developers looking to
> develop matter products with silabs hardware are encouraged to use our latest
> release with added tools and documentation.
> [Silabs matter_sdk Github](https://github.com/SiliconLabsSoftware/matter_sdk/tags)

## Introduction

The EFR32 wake on Matter example provides a baseline demonstration of an OT-NCP
combined with a Matter node that receives subscription to wake up the host.

## Building

-   Download the
    [Simplicity Commander](https://www.silabs.com/mcu/programming-options)
    command line tool, and ensure that `commander` is your shell search path.
    (For Mac OS X, `commander` is located inside
    `Commander.app/Contents/MacOS/`.)

-   Download and install a suitable ARM gcc tool chain (For most Host, the
    bootstrap already installs the toolchain):
    [GNU Arm Embedded Toolchain 12.2 Rel1](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads)

-   Install some additional tools (likely already present for CHIP developers):

    -   Linux: `sudo apt-get install git ninja-build`

    -   Mac OS X: `brew install ninja`

-   Supported hardware:

    -   > For the latest supported hardware please refer to the
        > [Hardware Requirements](https://docs.silabs.com/matter/latest/matter-prerequisites/hardware-requirements)
        > in the Silicon Labs Matter Documentation

    MG24 boards :

    -   BRD2601B / SLWSTK6000B / Wireless Starter Kit / 2.4GHz@10dBm
    -   BRD2703A / SLWSTK6000B / Wireless Starter Kit / 2.4GHz@10dBm
    -   BRD4186A / SLWSTK6006A / Wireless Starter Kit / 2.4GHz@10dBm
    -   BRD4186C / SLWSTK6006A / Wireless Starter Kit / 2.4GHz@10dBm
    -   BRD4187A / SLWSTK6006A / Wireless Starter Kit / 2.4GHz@20dBm
    -   BRD4187C / SLWSTK6006A / Wireless Starter Kit / 2.4GHz@20dBm
    -   BRD2703A / MG24 Explorer Kit
    -   BRD2704A / SparkFun Thing Plus MGM240P board

*   Build the example application:

            cd ~/connectedhomeip
            ./scripts/examples/gn_silabs_example.sh ./examples/wake-on-matter/silabs/ ./out/wake-on-matter BRD4187C

-   To delete generated executable, libraries and object files use:

            $ cd ~/connectedhomeip
            $ rm -rf ./out/

    OR use GN/Ninja directly

            $ cd ~/connectedhomeip/examples/wake-on-matter/silabs
            $ git submodule update --init
            $ source third_party/connectedhomeip/scripts/activate.sh
            $ export SILABS_BOARD=BRD4187C
            $ gn gen out/debug
            $ ninja -C out/debug

-   To delete generated executable, libraries and object files use:

            $ cd ~/connectedhomeip/examples/wake-on-matter/silabs
            $ rm -rf out/

For more build options, help is provided when running the build script without
arguments

         ./scripts/examples/gn_silabs_example.sh

## Flashing the Application

-   On the command line:

            $ cd ~/connectedhomeip/examples/wake-on-matter/silabs
            $ python3 out/debug/matter-silabs-wake-on-matter-example.flash.py

-   Or with the Ozone debugger, just load the .out file.

All EFR32 boards require a bootloader, see Silicon Labs documentation for more
info. Pre-built bootloader binaries are available on the
[Matter Software Artifacts page](https://docs.silabs.com/matter/latest/matter-prerequisites/matter-artifacts#matter-bootloader-binaries).

### Console Log

If the binary was built with this option or if you're using the Siwx917 WiFi
SoC, the logs and the CLI (if enabled) will be available on the serial console.

This console required a baudrate of **115200** with CTS/RTS. This is the default
configuration of Silicon Labs dev kits.

**HOWEVER** the console will required a baudrate of **921600** with CTS/RTS if
the verbose mode is selected (--verbose)

#### Configuring the VCOM

-   Using (Simplicity
    Studio)[https://community.silabs.com/s/article/wstk-virtual-com-port-baudrate-setting?language=en_US]
-   Using commander-cli
    ```
    commander vcom config --baudrate 921600 --handshake rtscts
    ```

### Using the console

With any serial terminal application such as screen, putty, minicom etc.

### Notes

-   Depending on your network settings your router might not provide native ipv6
    addresses to your devices (Border router / PC). If this is the case, you
    need to add a static ipv6 addresses on both device and then an ipv6 route to
    the border router on your PC

    -   On Border Router: `sudo ip addr add dev <Network interface> 2002::2/64`

    -   On PC(Linux): `sudo ip addr add dev <Network interface> 2002::1/64`

    -   Add Ipv6 route on PC(Linux)
        `sudo ip route add <Thread global ipv6 prefix>/64 via 2002::2`

### Debug build / release build

`--release`

    $ ./scripts/examples/gn_silabs_example.sh ./examples/wake-on-matter/silabs ./out/wake-on-matter BRD4164A "is_debug=false"

# Matter Wake on Lan configuration

This samples apps allows subscriptions to another Matter device. This is usefull
to receive state changes and to act accordingly

Steps

1. Commission this applications to a matter thread network
2. Give ACL to the desired node with which you want to establish a subscription
   with the following command

```
    chip-tool accesscontrol write acl '[{"fabricIndex": 1, "privilege": 1, "authMode": 2, "subjects": [<woM node ID>], "targets": null}]' <target node id> 0

3. Using the silabs_console.py or a standard CLI interface like screen or PuTTY run the following shell commands
4. run this command in the WoM device shell so that a subscription can be establish between the node and the WoM device
```

    im subscribe <fabricIndex> <nodeId> <endpointId> <clusterId>
    matterCli> im subscribe 1 40 1 6 0
