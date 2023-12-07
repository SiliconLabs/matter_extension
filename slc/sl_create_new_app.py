#!/usr/bin/env python

import os
import sys
import subprocess
from dotenv import load_dotenv

try:
    env_path = os.path.join(os.getcwd(),"slc","tools",".env")
    load_dotenv(env_path,override=True)
    os.environ["PATH"] = os.getenv("TOOLS_PATH") +  os.environ["PATH"]
    java_path = os.getenv("JAVA17_HOME")
    silabs_chip_root = os.getenv("silabs_chip_root")
except:
    print("Could not load the .env file. Run sl_setup_env.py generate .env file")
    sys.exit(1)

platform = sys.platform
gsdk_root = os.path.join(os.getcwd() + os.sep + os.pardir + os.sep + os.pardir)
# wiseconnect =  os.path.join(silabs_chip_root + os.sep + os.pardir + os.sep + "wifi_sdk")
EXAMPLE_USAGE = "python slc/sl_create_new_app.py <NewAppName> <PathToReferenceSlcpFile> <SilabsBoard>"

def print_usage_and_exit():
    print("Example usage:", EXAMPLE_USAGE)
    sys.exit(1)

def main():
    if len(sys.argv) < 4:
        print("Missing arguments")
        print_usage_and_exit()

    new_app_name = sys.argv[1]
    reference_slcp_file = sys.argv[2]
    silabs_board = sys.argv[3]

    if not os.path.exists(reference_slcp_file):
        print("ReferenceSlcpFile does not exist:", reference_slcp_file)
        sys.exit(1)

    if not reference_slcp_file.endswith('.slcp'):
        print("ReferenceSlcpFile should have a .slcp extension")
        sys.exit(1)

    if not silabs_board:
        print("Missing SilabsBoard argument")
        print_usage_and_exit()

    slc_path = "slc"
    if platform == "win32":
        try:
            slc_path = os.path.join(os.getenv("SLC"),"slc.bat")
        except:
            print("SLC undefined. Set SLC from the sl_env_vars.bat")
    
    #Ask user permission for trusting gecko_sdk
    sdk_trust = "no"
    sdk_msg = "\nSLC is trying to trust the SDK located at '{}'.\n\
SDKs can provide executables and scripts that SLC may automatically execute.\n\
They can also provide malicious embedded code or libraries\n\
SLC cannot verify the contents of the SDK.\n\
Do you want to trust sdk located at : '{}' ? (trust / no) :".format(gsdk_root,gsdk_root)
    sdk_trust = input(sdk_msg).lower()
    if sdk_trust not in ["trust","no"]:
        print("\nINVALID response!! Please select from 'trust' / 'no'\n")
        sdk_trust = input(sdk_msg ).lower()
    if sdk_trust == "trust":
        subprocess.run([slc_path, "configuration", "--sdk", gsdk_root])
        subprocess.run([slc_path, "signature", "trust", "--sdk", gsdk_root])
    else:
        print("SDK : '{}' not trusted".format(gsdk_root))
        sys.exit(1)

    #Ask user permission to trust matter_extension
    ext_trust = "no"
    ext_msg = "\nSLC is trying to trust the Extension located at '{}'.\n\
Extension can provide executables and scripts that SLC may automatically execute.\n\
They can also provide malicious embedded code or libraries\n\
SLC cannot verify the contents of the extension.\n\
Do you want to trust Extension located at : '{}' ? (trust / no) :".format(silabs_chip_root,silabs_chip_root)
    ext_trust = input(ext_msg)
    if ext_trust not in ["trust","no"]:
        print("\nINVALID response!! Please select from 'trust' / 'no'\n")
        ext_trust = input(ext_msg ).lower()
    if ext_trust == "trust":
        subprocess.run([slc_path, "signature", "trust", "--extension-path", silabs_chip_root])
    else:
        print("Extension : '{}' not trusted".format(silabs_chip_root))
        sys.exit(1)

    # subprocess.run(["slc", "signature", "trust","--extension-path="+wiseconnect])

    try:
        cmd = [slc_path, "--java-location", java_path, "generate", "-d", new_app_name, "-p", reference_slcp_file, "--with", silabs_board, "--new-project", "--force"]
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError:
        print("Error running 'slc generate'")
        sys.exit(1)

if __name__ == "__main__":
    main()
