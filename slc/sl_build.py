#!/usr/bin/env python3

import os
import sys
import subprocess
import shutil
import sys
from dotenv import load_dotenv

try:
    env_path = os.path.join(os.getcwd(),"slc","tools",".env")
    load_dotenv(env_path,override=True)
    os.environ["PATH"] = os.getenv("TOOLS_PATH") + os.environ["PATH"]
    java_path = os.getenv("JAVA17_HOME")
except:
    print("Could not load the .env file. Please run sl_setup_env.p' generate .env file")
    sys.exit(1)

platform = sys.platform

EXAMPLE_USAGE = "python slc/sl_build.py <PathToSlcpFile> <SilabsBoard>"

if len(os.sys.argv) < 3:
    print("Missing arguments")
    print("Example usage:", EXAMPLE_USAGE)
    exit(1)
else:
    silabs_app_path = os.sys.argv[1]
    if not silabs_app_path.endswith(".slcp"):
        print("Argument 1 needs to be an slcp file")
        exit(1)

silabs_board = os.sys.argv[2]

if not shutil.which("slc"):
    print("slc not detected on host")
    print("ERROR: please run slc/sl_setup_env.py to install slc.")
    exit(1)

if not shutil.which("arm-none-eabi-gcc"):
    print("arm-none-eabi-gcc not detected on host")
    print("ERROR: please run slc/sl_setup_env.py to install arm gcc toolchain")
    exit(1)

silabs_app = os.path.basename(silabs_app_path).removesuffix(".slcp")
output_dir = os.path.dirname(silabs_app_path)
makefile_path = f"{silabs_app}.Makefile"
slc_path = "slc"
if platform == "win32":
    try:
        slc_path = os.path.join(os.environ["SLC"],"slc.bat")
    except:
        print("ERROR: SLC undefined. Please run sl_setup_env.py")

subprocess.run([slc_path, "--java-location", java_path, "generate", "-d", output_dir, "-p", silabs_app_path, "--with", silabs_board, "--force"])

subprocess.run(["make", "-C", output_dir, "-f", makefile_path, "-j13"])
