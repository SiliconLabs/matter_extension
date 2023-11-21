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
except:
    print("Could not load the .env file. Run sl_setup_env.py generate .env file")
    sys.exit(1)

platform = sys.platform
gsdk_root = os.path.join(os.getcwd() + os.sep + os.pardir + os.sep + os.pardir)

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

    subprocess.run([slc_path, "configuration", "--sdk", gsdk_root])
    subprocess.run([slc_path, "signature", "trust", "--development-trust"])
    subprocess.run([slc_path, "signature", "trust", "--extension", "matter:2.2.0"])
    #subprocess.run(["slc", "signature", "trust", "--sdk", gsdk_root, "--extension-path", wisconnect  ])

    try:
        cmd = [slc_path, "--java-location", java_path, "generate", "-d", new_app_name, "-p", reference_slcp_file, "--with", silabs_board, "--new-project"]
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError:
        print("Error running 'slc generate'")
        sys.exit(1)

if __name__ == "__main__":
    main()
