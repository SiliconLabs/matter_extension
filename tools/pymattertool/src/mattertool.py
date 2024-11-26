import os
import random
import time
import re
import shutil
import json
import subprocess
import src.matterdevice as matterdevice
import src.mattergroup as mattergroup
import src.logmanager as logmanager
import src.utils as utils

class MatterTool:
    def __init__(self, logManager: logmanager.LogManager) -> None:
        self.JsonPath = os.path.join(os.path.dirname(__file__), '../json/session.json')
        JsonFile = open(self.JsonPath)
        SessionData = json.load(JsonFile)
        self.DevicesPath = os.path.join(os.path.dirname(__file__), '../json/devices.json')
        DevicesData = json.load(open(self.DevicesPath))
        self.BackupPath = os.path.join(os.path.dirname(__file__), '../backup/')

        self.MATTER_ROOT = os.environ["HOME"] + SessionData["MATTER_ROOT"].replace('~', '')
        self.CHIPTOOL_PATH = self.MATTER_ROOT.replace('~', '') + SessionData["CHIPTOOL_PATH"]
        self.PINCODE = SessionData["PINCODE"]
        self.DISCRIMINATOR = SessionData[ "DISCRIMINATOR"]
        self.ENDPOINT = SessionData["ENDPOINT"]
        self.NODE_ID = SessionData["NODE_ID"]
        self.LAST_NODE_ID = SessionData["LAST_NODE_ID"]
        self.THREAD_DATA_SET = SessionData["THREAD_DATA_SET"]
        self.SSID = SessionData["SSID"]
        self.WIFI_PW = SessionData["WIFI_PW"]
        self.VERBOSE = SessionData["VERBOSE"]
        self.DEFAULT_GROUP_INITIALIZED = SessionData["DEFAULT_GROUP_INITIALIZED"]
        self.IsNodeProvided = False
        self.Cmd = ""
        self.OptArgs = []
        self.Groups = []
        self.LogManager = logManager
        self.TargetAlias = ""
        self.TargetDiscriminator = -1

        # Init default groups #1, #2, #3
        self.Groups.append(mattergroup.MatterGroup(0x101, 0x1a1, "Group #1"))
        self.Groups.append(mattergroup.MatterGroup(0x102, 0x1a2, "Group #2"))
        self.Groups.append(mattergroup.MatterGroup(0x103, 0x1a3, "Group #3"))

        self.CmdList = {
            "help": self.PrintHelp,
            "vars": self.PrintVars,
            "cleanVars": self.CleanVars,
            "buildCT": self.CleanBuildChipTool,
            "rebuildCT": self.RebuildChipTool,
            "startThread": self.StartThreadNetwork,
            "getThreadDataset": self.GetThreadDataset,
            "bleThread": self.PairBLEThread,
            "bleThreadAll": self.PairAllBLEThread,
            "bleWifi": self.PairBLEWiFi,
            "on": self.SendOnOffCmds,
            "off": self.SendOnOffCmds,
            "toggle": self.SendOnOffCmds,
            "parsePayload": self.SendParseSetupPayload,
            "toggleVerbose": self.ToggleVerbose,
            "addDevice": self.AddDevice,
            "allDevices": self.PrintAllDevices,
            "cleanDevices": self.CleanDevices,
            "cleanAll": self.CleanAll,
            "groupDeviceDefault": self.AddDeviceToDefaultGroup,
            "cleanLogs": self.LogManager.DeleteCurrentLogFile,
            "printLogs": self.LogManager.PrintCurrentLogFile,
            "listLogs": self.LogManager.ListLogs,
            "restoreSession": self.RestoreSession,
        }

        self.MATTER_DEVICES = []

        # Matter devices parsing
        for device in DevicesData["DEVICES"]:                
            NewDevice = matterdevice.MatterDevice(device["DISCRIMINATOR"], device["PINCODE"], device["NODE_ID"], device["ALIAS"])
            self.MATTER_DEVICES.append(NewDevice)

        if self.NODE_ID == 0:
            self.NODE_ID = 1 + random.randint(0, 32767) % 100000

    def GetMatterDevicesAsJSON(self):
        JsonDevices = [device.__dict__() for device in self.MATTER_DEVICES]
        return JsonDevices
    
    def GetMatterDevice(self, alias: str):
        Device = None
        for matterDevice in self.MATTER_DEVICES:
            if matterDevice._alias == alias:
                Device = matterDevice
                break
        if Device is None:
            utils.print_red(f"Device with alias '{alias}' cannot be found.")
        return Device
    
    def SystemCall(self, command: str, args: list[str], shouldValidate: bool = False):
        Process = None
        Output = []
        try:
            RunArgs = [command] + args
            self.LogManager.DumpCommandInfo(command)
            Process = subprocess.Popen(RunArgs, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True, encoding='utf-8', errors='replace')
        except subprocess.CalledProcessError:
            utils.print_red("Error when running command: " + command)
        else:
            while True:
                RealtimeOutput = Process.stdout.readline()
                Process.poll()
                if RealtimeOutput == '' and Process.poll() is not None:
                    break
                if RealtimeOutput:
                    Output.append(RealtimeOutput)
                    if self.VERBOSE:
                        print(RealtimeOutput.strip(), flush=True)
                    self.LogManager.DumpLine(RealtimeOutput.strip())
        finally:
            self.SaveSession()
            if shouldValidate:
                if self.ValidateOutput(Output):
                    utils.print_green("Sucessfully ran command " + command)
                else:
                    utils.print_red("Error when running command " + command + ", check logs for further informations")
            return Process.returncode
        
    def ValidateOutput(self, output: list[str]) -> bool:
        # This def replace ErrorInfo def by analysing the output of a command instead of just checking the return code
        # Could be further developed to help SQA tasks...

        MatterOutputString = ','.join(output)

        # Extracting InvokeResponseMessage OBJECT
        Start = MatterOutputString.find("InvokeResponseMessage")
        End = MatterOutputString.find("Received Command Response Status")
        SubString = ""
        if Start != -1 and End != -1:
            eol = MatterOutputString.find(',', End, len(MatterOutputString) - 1)
            SubString = MatterOutputString[Start:eol:]
        else:
            return False

        StatusIBStart = SubString.find("status =")
        StatusIBEnd = SubString.find(',', StatusIBStart)

        if StatusIBStart != -1 and StatusIBEnd:
            Status = SubString[StatusIBStart:StatusIBEnd:]
            if 'success' in Status.lower():
                return True

    def ToggleVerbose(self) -> None:
        self.VERBOSE = not self.VERBOSE
        print(f"New verbose value: {str(self.VERBOSE)}")

    def CleanVars(self) -> None:
        self.DISCRIMINATOR = 3840
        self.ENDPOINT = 1
        self.NODE_ID = 0
        self.LAST_NODE_ID = 0
        self.THREAD_DATA_SET = ""
        self.PINCODE = 20202021
        self.SSID = ""
        self.WIFI_PW = ""
        self.MATTER_ROOT = "/connectedhomeip"
        self.VERBOSE = True
        self.DEFAULT_GROUP_INITIALIZED = False
        utils.print_blue("Cleaned all Matter variables!")
        self.PrintVars()

    def CleanAll(self) -> None:
        self.CleanVars()
        self.CleanDevices()

    def PrintVars(self) -> None:
        utils.print_bold("Active Vars:")
        print("MATTER_ROOT: " + self.MATTER_ROOT)
        print("CHIPTOOL_PATH: " + self.CHIPTOOL_PATH)
        print("NODE_ID: " + str(self.NODE_ID))
        print("THREAD_DATA_SET: " + self.THREAD_DATA_SET)
        print("PINCODE: " + str(self.PINCODE))
        print("DISCRIMINATOR: " + str(self.DISCRIMINATOR))
        print("SSID" + self.SSID)
        print("LAST_NODE_ID: " + str(self.LAST_NODE_ID))
        print("ENDPOINT: " + str(self.ENDPOINT))
        print("VERBOSITY: " + str(self.VERBOSE))
        print("DEFAULT GROUP INITIALIZED: " + str(self.DEFAULT_GROUP_INITIALIZED))

    def PrintHelp(self) -> None:
        print("This Python script centralize and simplifies the use of chip-tool and starting a clean thread network")
        print("Here is and overview of the Available cmds :\n")

        for cmd in self.CmdList:
            print(cmd)

        print("\n")

        utils.print_bold("Available options :")
        print(" -h, --help			Print this help")
        print(" -n, --nodeId DIGIT		Specify the Nodeid you are trying to reach")
        print(" -di, --discriminator DIGIT		Specify the discriminator of the device to commission")
        print(" -e, --endpoint DIGIT		Specify an endpoint to the desired the cluster")
        print(" -d, --dataset HEX_STRING       Thread Operation Dataset")
        print(" -s, --ssid STRING		WiFi AP ssid that the end devices needs to connect to")
        print(" -p, --password STRING		WiFi AP password")
        print(" --add-device DISCRIMINATOR[DIGIT] ALIAS[STRING] PINCODE[DIGIT]		Specify the device to add to the known devices")
        print(" -a OR --alias ALIAS[STRING] CMD [OPTIONAL ARGS]		Use a device alias as a target for any valid command")

        utils.print_green("Those configurations are held until the device is rebooted !")
        self.PrintVars()
        utils.print_green("You can also enter the full chip-tool command (without the chip-tool) e.g: Mattertool levelcontrol read current-level 106 1")

    def ErrorInfo(self, return_code, cmd: str) -> bool:
        if return_code != 0:
            utils.print_red(f"Error when running command: {cmd}")
            return False
        else:
            utils.print_green(f"\'{cmd}\' success!")
            return True
        
    def GetNewNodeId(self) -> int:
        ExistingNodeIDs = [device._node_id for device in self.MATTER_DEVICES]
        NewNodeID = 1 + random.randint(0, 32767) % 100000
        while NewNodeID in ExistingNodeIDs:
            NewNodeID = 1 + random.randint(0, 32767) % 100000
        return NewNodeID
        
    def AddDevice(self, discriminator: int, alias:str, pincode: int) -> bool:
        NodeID = 1 + random.randint(0, 32767) % 100000

        for existingDevice in self.MATTER_DEVICES:
            if existingDevice._discriminator == discriminator:
                utils.print_red(f"A device with the same discriminator value ({str(discriminator)}) already exists. Remove it before adding a new device.")
                return False
            if existingDevice._alias == alias:
                utils.print_red(f"A device with the same alias ({alias}) already exists. Remove it before adding a new device.")
                return False
            while existingDevice._node_id == NodeID:
                NodeID = 1 + random.randint(0, 32767) % 100000
            
        Device = matterdevice.MatterDevice(discriminator, pincode, NodeID, alias)
        self.MATTER_DEVICES.append(Device)
        utils.print_green("Successfully added a new device.")
        print(Device)
        return True

    def SetCurrentDevice(self, alias: str) -> None:
        Device = self.GetMatterDevice(alias)
        if Device:
            self.PINCODE = Device._pincode
            self.DISCRIMINATOR = Device._discriminator
            self.NODE_ID = Device._node_id
            utils.print_green(f"Successfully set current device!")
            print(Device)
            return

    def PrintAllDevices(self) -> None:  
        for Device in self.MATTER_DEVICES:
            print("-------------")
            print(Device)

    def UnpairDevice(self, alias: str) -> None:
        Device = self.GetMatterDevice(alias)
        if Device:
            self.SystemCall(f"{self.CHIPTOOL_PATH} pairing unpair {Device._node_id}", [])
            utils.print_green(f"Unpaired device {Device._alias} with node ID {Device._node_id}")

    def CleanDevices(self) -> None:
        for device in self.MATTER_DEVICES:
            self.SystemCall(f"{self.CHIPTOOL_PATH} pairing unpair {device._node_id}", [])

        for file in os.listdir("/tmp"):
            if "chip_" in file:
                os.remove("/tmp/" + file)

        self.MATTER_DEVICES = []
        utils.print_blue("Cleaned all Matter devices!")

    def InitDefaultGroup(self) -> None:
        self.SystemCall(f"{self.CHIPTOOL_PATH} groupsettings add-group DefaultGroup 0x4141", [])
        self.SystemCall(f"{self.CHIPTOOL_PATH} groupsettings add-keysets 0xAAAA 0 0x000000000021dfe0 hex:d0d1d2d3d4d5d6d7d8d9dadbdcdddedf", [])
        self.SystemCall(f"{self.CHIPTOOL_PATH} groupsettings bind-keyset 0x4141 0xAAAA", [])
        self.DEFAULT_GROUP_INITIALIZED = True

    def AddDeviceToDefaultGroup(self, alias: str) -> None:
        if not self.DEFAULT_GROUP_INITIALIZED:
            self.InitDefaultGroup()

        Device = self.GetMatterDevice(alias)

        if not Device:
            return

        GroupKeySet = {
            "groupKeySetID": 43690, 
            "groupKeySecurityPolicy": 0, 
            "epochKey0": "d0d1d2d3d4d5d6d7d8d9dadbdcdddedf", 
            "epochStartTime0": 2220000,
            "epochKey1": "d1d1d2d3d4d5d6d7d8d9dadbdcdddedf", 
            "epochStartTime1": 2220001,
            "epochKey2": "d2d1d2d3d4d5d6d7d8d9dadbdcdddedf", 
            "epochStartTime2": 2220002 }
        
        AttributeValues = [{
            "groupId": 16705,
            "groupKeySetID": 43690
        }]

        self.SystemCall(f"{self.CHIPTOOL_PATH} groupkeymanagement key-set-write {str(GroupKeySet)} {str(Device._node_id)} 0", [])
        self.SystemCall(f"{self.CHIPTOOL_PATH} groupkeymanagement write group-key-map {str(AttributeValues)} {str(Device._node_id)} 0", [])
        self.SystemCall(f"{self.CHIPTOOL_PATH} groups add-group 0x4141 DefaultGroup {str(Device._node_id)} 1", [])

    def StartThreadNetwork(self) -> None:
        Password = "raspberrypi"
        utils.print_green("Starting a new thread network")
        subprocess.call("echo {} | sudo ot-ctl factoryreset".format(Password), shell=True)
        time.sleep(3)
        subprocess.call("echo {} | sudo ot-ctl srp server disable".format(Password), shell=True)
        subprocess.call("echo {} | sudo ot-ctl thread stop".format(Password), shell=True)
        subprocess.call("echo {} | sudo ot-ctl ifconfig down".format(Password), shell=True)
        subprocess.call("echo {} | sudo ot-ctl dataset init new".format(Password), shell=True)
        subprocess.call("echo {} | sudo ot-ctl dataset commit active".format(Password), shell=True)
        subprocess.call("echo {} | sudo ot-ctl srp server enable".format(Password), shell=True)
        subprocess.call("echo {} | sudo ot-ctl ifconfig up".format(Password), shell=True)
        subprocess.call("echo {} | sudo ot-ctl thread start".format(Password), shell=True)
        time.sleep(7)
        self.GetThreadDataset()

    def SaveSession(self) -> None:
        for file in os.listdir("/tmp"):
            if "chip_" in file:
                shutil.copy("/tmp/" + file, self.BackupPath)

    def RestoreSession(self) -> None:
        for file in os.listdir(self.BackupPath):
            if "chip_" in file:
                shutil.copy(self.BackupPath + file, "/tmp/")

    def GetThreadDataset(self) -> None: 
        self.THREAD_DATA_SET = os.popen("sudo ot-ctl dataset active -x").read().split("\n")[0]
        utils.print_green("New ThreadDataset: " + self.THREAD_DATA_SET)

    def PairBLEThread(self) -> None:
        if self.THREAD_DATA_SET == "0":
            utils.print_blue("Provide OpenThread DataSet")
            return
        
        if self.TargetAlias != "":
            Device = self.GetMatterDevice(self.TargetAlias)
            if Device is None:
                utils.print_blue("Commissioning a new device onto the network...")
                Discriminator = self.TargetDiscriminator if self.TargetDiscriminator != -1 else 3840
                Success = self.AddDevice(Discriminator, self.TargetAlias, 20202021)
                if Success:
                    NewDevice = self.GetMatterDevice(self.TargetAlias)
                    SysCallResult = self.SystemCall(f"{self.CHIPTOOL_PATH} pairing ble-thread {str(NewDevice._node_id)} hex:{self.THREAD_DATA_SET} {str(NewDevice._pincode)} {str(NewDevice._discriminator)}", [])
        else:
            if self.LAST_NODE_ID == self.NODE_ID:
                self.NODE_ID = 1 + random.randint(0, 32767) % 100000

            self.LAST_NODE_ID = self.NODE_ID

            SysCallResult = self.SystemCall(f"{self.CHIPTOOL_PATH} pairing ble-thread {str(self.NODE_ID)} hex:{self.THREAD_DATA_SET} {str(self.PINCODE)} {str(self.DISCRIMINATOR)}", [])
            if self.ErrorInfo(SysCallResult, "Pairing BLE device on Thread network"):
                utils.print_blue("The Node id of the commissioned device is " + str(self.NODE_ID))

    def PairAllBLEThread(self) -> None:
        if len(self.MATTER_DEVICES) == 0:
            utils.print_red("No devices to pair, terminating.")
            return
        
        if self.THREAD_DATA_SET == "0":
            utils.print_blue("Provide OpenThread DataSet")
            return
        
        for device in self.MATTER_DEVICES:
            SysCallResult = self.SystemCall(f"{self.CHIPTOOL_PATH} pairing ble-thread {str(device._node_id)} hex:{self.THREAD_DATA_SET} {str(device._pincode)} {device._discriminator}", [])

            if self.ErrorInfo(SysCallResult, f"Pairing BLE device with alias {device._alias} and node ID {device._node_id}"):
                utils.print_blue("The Node id of the commissioned device is " + str(device._node_id))

    def PairBLEWiFi(self) -> None:
        if "SSID" == "":
            utils.print_blue("Provide SSID")
            return
        
        if "WIFI_PW" == "":
            utils.print_blue("Provide SSID password")
            return
        
        if self.LAST_NODE_ID == self.NODE_ID and self.IsNodeProvided:
            self.NODE_ID = 1 + random.randint(0, 32767) % 100000

        utils.print_green("Set Node id for the commissioned device : " + str(self.NODE_ID))
        self.LAST_NODE_ID = self.NODE_ID

        SysCallResult = self.SystemCall(f"{self.CHIPTOOL_PATH} pairing ble-wifi {str(self.NODE_ID)} {self.SSID} {self.WIFI_PW} {str(self.PINCODE)} {str(self.DISCRIMINATOR)}", [])
        self.ErrorInfo(SysCallResult, "Pairing BLE device on WiFi network")

    def SendOnOffCmds(self, device: matterdevice.MatterDevice = None) -> None:
        SysCallResult = self.SystemCall(f"{self.CHIPTOOL_PATH} onoff {self.cmd} {str(self.NODE_ID)} {str(self.ENDPOINT)}", [], shouldValidate=True)
        
    def SendParseSetupPayload(self) -> None:
        SysCallResult = self.SystemCall(f"{self.CHIPTOOL_PATH} payload parse-setup-payload {' '.join(self.OptArgs)}", [])
        self.ErrorInfo(SysCallResult, "Parse setup payload")

    def CleanBuildChipTool(self) -> None:
        utils.print_blue("Clean Build of Chip-tool")
        self.SystemCall(f"rm -rf {self.MATTER_ROOT}/out", [])

        for directory in os.listdir(self.MATTER_ROOT + "/tmp/"):
            if re.fullmatch("chp_.*", directory):
                shutil.rmtree(directory)

        self.SystemCall(f"{self.MATTER_ROOT}/scripts/examples/gn_build_example.sh {self.MATTER_ROOT}/examples/chip-tool {self.MATTER_ROOT}/out/standalone", [])
    
    def RebuildChipTool(self) -> None:
        utils.print_blue("Rebuild Chip-tool")
        self.SystemCall(f"{self.MATTER_ROOT}/scripts/examples/gn_build_example.sh {self.MATTER_ROOT}/examples/chip-tool {self.MATTER_ROOT}/out/standalone", [])