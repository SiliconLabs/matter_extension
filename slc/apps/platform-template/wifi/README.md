# Matter Platform Template Example

A minimal Matter platform template example supporting essential clusters on Silicon Labs SiWx917 SoC devices.

<hr>

- [Matter Platform Template Example](#matter-platform-template-example)
- [Introduction](#introduction)
  - [Region code Setting (917 WiFi projects)](#region-code-setting-917-wifi-projects)
- [Building](#building)
  - [Prerequisite](#prerequisite)
  - [Building command](#building-command)
- [Expected Behaviour](#expected-behaviour)
- [Supported Clusters](#supported-clusters)
  - [Root Node (Endpoint 0)](#root-node-endpoint-0)
  - [Endpoint 1](#endpoint-1)
- [Customizing](#customizing)
  - [Adding Matter Clusters](#adding-matter-clusters)
  - [Configuration Options](#configuration-options)

<hr>

# Introduction

This sample app demonstrates a minimal Matter platform implementation on Silicon Labs SiWx917 SoC devices. It provides the essential Matter clusters required for commissioning, network management, and basic device operation over a WiFi network. This platform app serves as a foundation for building more complex Matter applications.

For more information on running Matter applications and pre-requisites please refer to the online 
documentation for Matter available at docs.silabs.com. Follow the instructions for the desired Matter over Wi-Fi application.
[Demo instructions for Wi-Fi](https://docs.silabs.com/matter/latest/matter-wifi)

## Region code Setting (917 WiFi projects)

In Wifi configurations, the region code can be set in this
[file](https://github.com/SiliconLabsSoftware/matter_sdk/blob/085bd03532990e5b1f99ff4b08ebce4f4ca5edf6/src/platform/silabs/wifi/SiWx/WifiInterface.cpp#L125).
The available region codes can be found
[here](https://github.com/SiliconLabs/wiseconnect/blob/f675628eefa1ac4990e94146abb75dd08b522571/components/device/silabs/si91x/wireless/inc/sl_si91x_types.h#L71)

# Building

## Prerequisite

The following prerequisites need to be installed on the host machine:

- ARM GCC 12.2
- ZAP (version 2024.05.07 or greater)
- SLC-CLI
- Various environment variables set such as:
    - ARM_GCC_DIR
    - TOOLDIR
    - STUDIO_ADAPTER_PACK_PATH

## Building command
To build this project, follow the build steps detailed in:
{matter_extension_root}/README.md.

You can replicate the build command for your specific application.
E.g. (For a Linux/Mac system)
```
python3 slc/sl_build.py MyNewApp/platform-app-917.slcw brd4338a
```

# Expected Behaviour

Once the application is built and flashed onto the device, you should see the Matter QR code displayed and if you're using a BLE sniffer like the EFRConnect app you should be able to see the device being advertised and ready to be commissioned into a Matter network.

The platform app provides basic Matter functionality including commissioning over BLE, WiFi network management, and diagnostic capabilities. After commissioning, the device can be managed through Matter controllers over WiFi network for configuration and monitoring purposes.

# Supported Clusters

This platform app supports the following Matter clusters:

## Root Node (Endpoint 0)
- **Base** - Basic device information and capabilities
- **Access Control** - Access control list management
- **Access Control Enforcement** - Access control enforcement
- **Administrator Commissioning** - Device commissioning management
- **General Diagnostics** - Device diagnostic information
- **General Commissioning** - General commissioning procedures
- **Group Communication** - Group messaging support
- **Localization Configuration** - Device localization settings
- **Network Commissioning** - Network credential management
- **Node Operational Credentials** - Device certificate management
- **Secure Channel** - Secure communication channel
- **WiFi Network Diagnostic** - WiFi network diagnostic information
- **Time Format Localization** - Time format configuration

## Endpoint 1
- **Groups Cluster** - Group management functionality

# Customizing 

This platform app can be customized to fit your specific needs:

## Adding Matter Clusters
You can extend this platform app by adding additional Matter clusters and endpoints as needed for your application. Simply modify the ZAP configuration file to include the desired clusters and regenerate the data model.

## Configuration Options
Various Matter configuration options can be modified through the component configuration files to adjust behavior such as:
- Network commissioning parameters
- Device identification information
- Diagnostic reporting intervals
- Security settings
