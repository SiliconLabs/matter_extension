# Silabs Matter Controller + OTBR raspberry pi image

<hr>

-   [Silabs Matter Controller + OTBR raspberrypi image]()
    -   [Introduction](#introduction)
    -   [Openthread Border Router ](#Openthread-Border-Router)
        -   [Usage](#Usage)
    -   [Matter](#matter)
        -   [Usage](#usage-eg)
    -   [Scripts Alias](#scripts-alias)
    -   [Connect WiFi](#connect-wifi)


<hr>

<a name=“intro”></a>

## Introduction
This raspberry pi image is used as a Matter Controller with his own Openthread Border Router
This is a means to fast-track matter end device development with an “out of the box” Matter controller experience.

This image contains the following

### Image tree

```
home
└── ubuntu (You boot here)
    ├── connectedhomeip (git repo -> https://github.com/project-chip/connectedhomeip.git)
    │   ├── .
    ├── ot-br-posix (git repo -> https://github.com/openthread/ot-br-posix.git)
    │   ├── .
    └── scripts (In-house scripts)
        ├── configurations.sh
        ├── matterTool.sh
        └── setupOTBR.sh
```

<a name=“OTBR”></a>

## Openthread Border Router
The pre-installed OTBR in this image was built against the following ot-br-posix commit SHA:
  ```
  commit 1813352247aa60fb8993773918f1e5b4af6f3b79
  ```

This commit was tested and validated to work in combination with the pre-built chip-tool present in this image.

For the OTBR to function, a valid ot-rcp must be connected by usb(ttyACM0) to the raspberry pi
  To build an efr32 ot-rcp see :
  [guide](https://www.silabs.com/documents/public/application-notes/an1256-using-sl-rcp-with-openthread-border-router.pdf)

  **Use ot-efr32 commit 7a567da02a078546eb34136c1c44170c8832dd55 to ensure compatibility with the aforementioned OTBR commit**

The pre-installed OTBR is configured for the infrastructure interface eth0.

Should you want to modify, reinstall or update the OTBR. this easy to use bash script is available
```
otbrsetup
This bash script centralize and simplifies the local otbr installation
Available options  :
 -h, --help                     Print this help
 -if, --interface <eth0|wlan0>  Select infrastructure interface. Default eth0
 -i, --install                  Bootstrap, set up and install the OTBR. Usually for a new installation
 -s, --setup                    Runs the OTBR setup only, use this to change the configured infrastructure interface (use in combination with -if wlan0 for wifi)
 -u, --update                   Update the OTBR installation after the repo is updated
```

### Usage:
  Change infrastructure interface to wlan0
  ```
  otbrsetup -if wlan0 -s
  ```

  Rerun full install for eth0 interface
  ```
  otbrsetup -i
  ```

  Change OTBR commit reference/version
  ```
  cd /home/ubuntu/ot-br-possix
  git fetch
  git checkout <SHA>
  otbrsetup -u
  ```

## Matter

The prebuilt chip-tool in this image was built against the following connectedhomeip commit SHA
commit fb34188d9799649e499a1248d084fdec61cb4518 (HEAD -> sve, origin/sve)

Change chip tool commit reference/version

  ```
  cd /home/ubuntu/connectedhomeip
  git fetch
  git checkout <SHA>
  mattertool buildCT
  ```

The mattertool script centralizes and simplifies the use of chip-tool and starting a clean thread network
Here is an overview of the Available commands :

```
bleThread        -- For Matter Ble thread commissioning with an EFR32 device
bleWifi          -- For Matter Ble WiFI commissioning with an EFR32 device
buildCT          -- Clean build of the chip-tool
cleanVars        -- Erase every Set variable used in the script. They will be set back to default or randomized value
getThreadDataset -- Get and store the Thread datatset hex credentials from the local otbr
help             -- Print an help for this script
off              -- Turn off the Light on the already commissioned EFR32 device
on               -- Turn on the Light on the already commissioned EFR32 device
parsePayload     -- Parse the given Payload (QrCode string)
rebuildCT        -- Rebuild the chip-tool
startThread      -- Start a new thread network and store the operational thread dataset for the commissioning purpose (bleThread)
toggle           -- Toggle the Light on the already commissioned EFR32 device
vars             -- Print the Variables in use by the script
```

Available options  :
 -h, --help     Print this help
 -n, --nodeId DIGIT   Specify the Nodeid you are trying to reach
 -e, --endpoint DIGIT   Specify an endpoint to the desired the cluster
 -d, --dataset HEX_STRING       Thread Operation Dataset
 -s, --ssid STRING    WiFi AP ssid that the end devices needs to connect to
 -p, --password STRING    WiFi AP password
Those configurations are held until the device is rebooted, overwritten or cleared with cleanVars!

Active Vars:
  MATTER_ROOT: /home/ubuntu/connectedhomeip
  CHIPTOOL_PATH: /home/ubuntu/connectedhomeip/out/standalone/chip-tool
  NODE_ID:31354
  THREAD_DATA_SET:
  PINCODE: 20202021
  DISCRIMINATOR: 3840
  SSID:
  lastNodeId: 0
You can preset them with export X=Y before running the script


### Usage e.g:
This example shows how to start a new Thread network from the local OTBR and commission an EFR32 matter end device
and then send the command on and off with the mattertool automated script.

  ```
  mattertool startThread
  mattertool bleThread
  mattertool on
  mattertool off
  ```

You can also enter the full chip-tool command as usual (still using mattertool)

  ```
  mattertool levelcontrol read current-level 106 1
  ```

## Scripts Alias
The commands presented above are liked to scripts
You can edit .bashrc and rename the following alias to your liking

```
alias mattertool=‘source $HOME/scripts/matterTool.sh’
alias otbrsetup=‘source $HOME/scripts/setupOTBR.sh’
```

## Connect WiFi
If you need to have connect your raspberry pi to a WiFi network, you can do so by doing

```
sudo nano /etc/netplan/50-cloud-init.yaml
```

In the wifis section, Change <YOUR_SSID> by your WiFi ssid name and <YOUR_PASSWORD> by your network password

```
network:
    ethernets:
        eth0:
            dhcp4: true
            optional: true
    version: 2
    wifis:
        wlan0:
            optional: true
            access-points:
                <YOUR_SSID>:
                    password: <YOUR_PASSWORD>
            dhcp4: true
```

Press *CTRL+X* and then *Y* to exit and save the file.

Then run the two following commands

  ```
  sudo netplan generate
  sudo netplan apply
  ```


Your raspberry pi should now be connected to your WiFi network. You can validate that you have an IP address with *ifconfig wlan0*
