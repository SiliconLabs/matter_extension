import sys
import src.utils as utils
import json
import atexit
import subprocess
import argparse
import itertools
import threading
import time
import src.mattertool as mattertool
import src.logmanager as logmanager

TaskDone = False
def loading_animate():
    for loadingSymbol in itertools.cycle(["⢿", "⣻", "⣽", "⣾", "⣷", "⣯", "⣟", "⡿"]):
        if TaskDone:
            break
        sys.stdout.write('\r' + loadingSymbol)
        sys.stdout.flush()
        time.sleep(0.05)
    sys.stdout.write('\n')

LogManager = logmanager.LogManager()
MatterTool = mattertool.MatterTool(logManager=LogManager)

# Save session values when exiting the script, this handler is called everytime the main.py script ends.
def atexit_handler():
    JsonFile = open(MatterTool.JsonPath)
    DevicesFile = open(MatterTool.DevicesPath)
    SessionData = json.load(JsonFile)
    DevicesData = json.load(DevicesFile)
    SessionData["NODE_ID"] = MatterTool.NODE_ID
    SessionData["DISCRIMINATOR"] = MatterTool.DISCRIMINATOR
    SessionData["LAST_NODE_ID"] = MatterTool.LAST_NODE_ID
    SessionData["THREAD_DATA_SET"] = MatterTool.THREAD_DATA_SET
    SessionData["SSID"] = MatterTool.SSID
    SessionData["WIFI_PW"] = MatterTool.WIFI_PW
    SessionData["VERBOSE"] = MatterTool.VERBOSE
    DevicesData["DEVICES"] = MatterTool.GetMatterDevicesAsJSON()
    SessionData["DEFAULT_GROUP_INITIALIZED"] = MatterTool.DEFAULT_GROUP_INITIALIZED

    # Clear the JSON file before updating
    open(MatterTool.JsonPath, "w").close() 
    open(MatterTool.DevicesPath, "w").close()

    JsonFile = open(MatterTool.JsonPath, 'w')
    DevicesFile = open(MatterTool.DevicesPath, 'w')
    json.dump(SessionData, JsonFile, indent=2)
    json.dump(DevicesData, DevicesFile, indent=2)
    JsonFile.close()
    DevicesFile.close()

    LogManager.ExitRoutine()

# Function run on program termination
atexit.register(atexit_handler)

# Inquire Matter environment activation if it isn't already activated
if sys.prefix == sys.base_prefix:
    utils.print_blue("Environment is not activated, run:")
    utils.print_bold("source " + MatterTool.MATTER_ROOT + "/scripts/activate.sh")
    sys.exit()

# Get arguments and remove the first one (invocation of mattertool.py)
Parser = argparse.ArgumentParser(add_help=False)

Parser.add_argument("cmd", nargs="*", default="", type=str)
Parser.add_argument("--add-device", nargs=3, type=str)
Parser.add_argument("-gdd", "--group-device-default", help="Add a device with its alias to the default group.", nargs=1, type=str)
Parser.add_argument("-cur", "--current", help="Set a Matter device as main device to use short commands.", type=str)
Parser.add_argument("-a", "--alias", help="Alias of the targeted device.", type=str)
Parser.add_argument("-h", "--help", help="Learn more about the options of mattertool", action="store_true")
Parser.add_argument("-n", "--nodeId", help="Provide a node ID value", type=int)
Parser.add_argument("-di", "--discriminator", help="Provide a discriminator value", type=int)
Parser.add_argument("-e", "--endpoint", help="Provide an enpoint value", type=int)
Parser.add_argument("-d", "--dataset", help="Provide a OpenThread dataset value in HEX format", type=str)
Parser.add_argument("-s", "--ssid", help="Provide the SSID of the WiFi network to use", type=str)
Parser.add_argument("-p", "--password", help="Provide the password of the WiFi network to use", type = str)
Parser.add_argument("-ud", "--unpair-device", help="Provide the alias of the device to unpair", type=str)


Args = Parser.parse_args()

if Args.help:
    MatterTool.PrintHelp()
if Args.nodeId:
    utils.print_blue(f"Set node ID value to {str(Args.nodeId)}")
    MatterTool.NODE_ID = Args.nodeId
    MatterTool.IsNodeProvided = True
if Args.discriminator:
    utils.print_blue(f"Set discriminator value to {str(Args.discriminator)}")
    MatterTool.DISCRIMINATOR = Args.discriminator
    MatterTool.TargetDiscriminator = Args.discriminator
if Args.endpoint:
    utils.print_blue(f"Set endpoint value to {str(Args.endpoint)}")
    MatterTool.ENDPOINT = Args.endpoint
if Args.dataset:
    utils.print_blue(f"Set OpenThread dataset value.")
    MatterTool.THREAD_DATA_SET = Args.dataset
if Args.ssid:
    utils.print_blue(f"Set WiFi network SSID value to {Args.ssid}")
    MatterTool.SSID = Args.ssid
if Args.password:
    utils.print_blue(f"Set WiFi password value.")
    MatterTool.WIFI_PW = Args.password
if Args.cmd and len(Args.cmd) > 0:
    for argIdx, arg in enumerate(Args.cmd):
        if argIdx == 0:
            MatterTool.cmd = arg
        else:
            MatterTool.OptArgs.append(arg)
if Args.add_device:
    if len(Args.add_device) != 3:
        utils.print_red(f"Adding a device requires 3 arguments (discriminator, alias and pincode), only {str(len(Args.add_device))} provided.")
    discriminator = Args.add_device[0]
    alias = Args.add_device[1]
    pincode = Args.add_device[2]

    if not discriminator.isdigit():
        utils.print_red("DISCRIMINATOR should be an integer.")
        sys.exit()
    if not pincode.isdigit():
        utils.print_red("PINCODE should be an integer.")
        sys.exit()
    
    discriminator = int(discriminator)
    pincode = int(pincode)
    MatterTool.AddDevice(discriminator, alias, pincode)
    sys.exit()
if Args.alias is not None:
    device = MatterTool.GetMatterDevice(Args.alias)
    if device is not None:
        MatterTool.NODE_ID = device._node_id
    else:
        MatterTool.TargetAlias = Args.alias
if Args.current:
    device = MatterTool.GetMatterDevice(Args.current)
    if device is not None:
        MatterTool.SetCurrentDevice(device._alias)
    sys.exit()
if Args.group_device_default:
    device = MatterTool.GetMatterDevice(Args.group_device_default[0])
    if device is not None:
        MatterTool.AddDeviceToDefaultGroup(device._alias)
    sys.exit()
if Args.unpair_device:
    MatterTool.UnpairDevice(Args.unpair_device)
    sys.exit()

# Animation thread starting
threading.Thread(target=loading_animate).start()

if MatterTool.cmd in MatterTool.CmdList:
    MatterTool.CmdList[MatterTool.cmd]()
    TaskDone = True
else:
    runArgs = [MatterTool.CHIPTOOL_PATH, MatterTool.cmd] + MatterTool.OptArgs
    subprocess.run(runArgs, shell=True)
    TaskDone = True

# TODO: should write a matterTool.reset function if more variables should be reset
MatterTool.TargetAlias = ""
MatterTool.TargetDiscriminator = -1