import os
import subprocess
from sl_create_new_app import createApp

EXAMPLE_USAGE = "python slc/sl_run_zaptool.py <PathToReferenceZapFile(.zap)>"

# User input for the path to the .zap file
if len(os.sys.argv) < 2:
    print("Missing arguments")
    print("Example usage:", EXAMPLE_USAGE)
    exit(1)
reference_zap_file = os.sys.argv[1]
# add ../../ to the reference_zap_file
reference_zap_file = "../../" + reference_zap_file

App = createApp()
# change dir to matter_sdk
matter_sdk_path = os.path.join(os.getcwd(), "third_party/matter_sdk")
os.chdir(matter_sdk_path)

zaptool_path = os.path.join("scripts", "tools", "zap", "run_zaptool.sh")

cmd = [zaptool_path, reference_zap_file]

# run scripts/run_zaptool.sh , use subprocess.run() to run the script
subprocess.run(cmd, check=True)