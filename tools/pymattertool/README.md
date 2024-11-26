# Silicon Labs Mattertool
Python wrapper of CSA chip-tool

### Usage:
Mattertool can be used with a wide array of commands. Keep in mind that since it's a wrapper of CSA's chip-tool, any valid command on chip-tool is also valid with Mattertool, [browse chip-tool guide here](https://github.com/project-chip/connectedhomeip/blob/master/docs/guides/chip_tool_guide.md). This README file only covers additional behaviour of Mattertool.

---
### Setting up alias
To ease the utilization of Mattertool, you can create an alias to run the script:

**MacOS:**
Open up zsh profile file:
```
nano ~/.zshrc
```

Add the following line:
```
alias pymattertool='python3 [PATH_TO_PYMATTERTOOL_FOLDER]/pymattertool/main.py'
```
---
**Linux**:
Open up bash profile file:
```
nano ~/.bash_aliases
```

Add the following line:
```
alias pymattertool='python3 [PATH_TO_PYMATTERTOOL_FOLDER]/pymattertool/main.py'
```
---
To invoke Mattertool after setting up an alias, use:
```
pymattertool
```

By default, calling Mattertool without any arguments will call chip-tool, printing all the different available clusters.

Mattertool includes a wide-array of new functionalities:
- [Silicon Labs Mattertool](#silicon-labs-mattertool)
    - [Usage:](#usage)
    - [Setting up alias](#setting-up-alias)
    - [**Add devices with aliases**](#add-devices-with-aliases)
    - [**Quickly add and pair a device with aliases**](#quickly-add-and-pair-a-device-with-aliases)
    - [**Send commands to a device using its alias**](#send-commands-to-a-device-using-its-alias)
    - [**Commission multiple devices with one command**](#commission-multiple-devices-with-one-command)
    - [**Clean Mattertool variables and known devices**](#clean-mattertool-variables-and-known-devices)
    - [**Set a device as the current main device**](#set-a-device-as-the-current-main-device)
    - [**Add device to the default group to broadcast commands**](#add-device-to-the-default-group-to-broadcast-commands)
    - [**Save command logs into text files**](#save-command-logs-into-text-files)

---

### **Add devices with aliases**
A Matter device can be added to known devices using:
```
pymattertool --add-device [discriminator] [alias] [pincode]
```

Arguments:
- [discriminator]: a 12-bits discriminator used to commission the device on the network
- [alias]: a string representing the device, will be used later to identify the device
- [pincode]: the pincode used by Spake2p encryption during session establishment

Example:
```
pymattertool --add-device 187 brd4187c 2021
```
This command will add a device with discriminator 187, alias "brd4187c" and pincode 2021 to the list of known devices.

The node ID is randomly generated and unique among all the known devices already registered. Once the device is added to the known devices, one can use the alias as a way to route a command. To see all the known devices, use:

```
pymattertool allDevices
```
This command will print all the devices, discriminators, aliases, and node IDs associated, as well as pincodes.

---

### **Quickly add and pair a device with aliases**
A Matter device can be added to known devices and commissioned via BLE using:
```
pymattertool -a [alias] -di [discriminator] bleThread
```
Arguments:
- [alias]: a string representing the new device, will be used later to identify the device
- [discriminator] (OPTIONAL): a 12-bits discriminator used to commission the device on the network, if not provided, the new device will be commissioned with the **default discriminator 3840**.

Example:
```
pymattertool -a light1 -di 187 bleThread
```
This command will add a device with discriminator 187, alias light1 and commission it to the current OpenThread via  BLE. The node is randomly generated and unique among all the known devices already registered.

---

### **Send commands to a device using its alias**
The alias of a known device can be used to send commands to that specific device using:
```
pymattertool [-a or --alias] [alias] [cmd] [optional args]
```

Arguments:
- [alias]: a string representing the device, will be used later to identify the device
- [cmd]: a valid chip-tool command
- [optional args]: any optional arguments associated with the corresponding chip-tool command

Example:
```
pymattertool --alias brd4187c toggle
```
This command will trigger the toggle function on a device with alias "brd4187c" accepting on/off command.

---

### **Commission multiple devices with one command**
All the known devices not already commissioned on the OpenThread network can be commissioned via BlueTooth using:
```
pymattertool bleThreadAll
```
This command will succinctly commission every device among the known devices list on the OpenThread network.

---

### **Clean Mattertool variables and known devices**
Variables (such as current device node ID, discriminator...) and known devices can be cleaned using:
```
pymattertool cleanAll
```

This command will reset the variables to their default values, and it will clear out the known device array.

If you want to clean **only the variables**, use:
```
pymattertool cleanVars
```

If you want to clean **only the known devices**, use:
```
pymattertool cleanDevices
```

---

### **Set a device as the current main device**
A known device can be set as the main device, making it the target of the short commands (e.g. `pymattertool toggle`) using:
```
pymattertool [-cur or --current] [alias]
```

Argument:
- [alias]: a string representing the device to set as the current device

Example:
```
pymattertool --current brd4187c
```
This command will set the device with alias "brd4187c" as the current device, if the command `pymattertool toggle` is used, the command will be sent to the device "brd4187c" directly without mentioning the alias or node ID of the device.

---

### **Add device to the default group to broadcast commands**
It's possible to add a known device to the default group to send commands in broadcast mode, using:
```
pymattertool [-gdd or --group-device-default] [alias]
```

Argument:
- [alias]: a string representing the device to add to the default group

Example:
```
pymattertool --group-device-default brd4187c
```
This command will add the device with alias "brd4187c" to the default 
group for broadcast commands.

---

### **Save command logs into text files**
Logs are saved in the `logs` folder (`MATTERTOOL_FOLDER/logs`). A new log file is created every 24 hours. Log files older than 10 days are automatically deleted when starting up Mattertool. It's possible to change for how long logs are stored by changing the variable `LOGS_LIFESPAN_DAYS` in the `session.json` file.

To **list all the log files** and their creation/modification time, use:
```
pymattertool listLogs
```

To print the **current log file** (namely the log file younger than 24 hours), use:
```
pymattertool printLogs
```

To **erase the current log file**, use:
```
pymattertool cleanLogs
```

