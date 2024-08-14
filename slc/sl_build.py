#!/usr/bin/env python3

import os
import sys
import subprocess
import shutil
import sys
from dotenv import load_dotenv
from sl_create_new_app import createApp

App = createApp()
EXAMPLE_USAGE = "python slc/sl_build.py <PathToReferenceProjectFile(.slcp or .slcw)> <SilabsBoard>"

if len(os.sys.argv) < 3:
    print("Missing arguments")
    print("Example usage:", EXAMPLE_USAGE)
    exit(1)
else:
    reference_project_file = os.sys.argv[1]
    #use appropriate build flag for sample-app/workspaces
    if reference_project_file.endswith('.slcp'):
        project_flag = "-p" 
        silabs_app = os.path.basename(reference_project_file).removesuffix(".slcp")
        output_dir = os.path.dirname(reference_project_file)
        makefile_path = f"{silabs_app}.Makefile"
    elif reference_project_file.endswith('.slcw'):
        project_flag = "-w"
        silabs_app = os.path.basename(reference_project_file).removesuffix(".slcw")
        output_dir = os.path.dirname(reference_project_file)
        makefile_path = f"{silabs_app}.solution.Makefile"
    else:
        print("Argument 1 needs to be a .slcp or .slcw file")
        print("Example usage:", EXAMPLE_USAGE)
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

slc_path = App.slc_path
java_path = App.java_path
#check for soc boards
SoC_boards = ["brd4338a"]
config_args=";wiseconnect3_sdk"  if silabs_board in SoC_boards else ""

subprocess.run([slc_path, "--java-location", java_path, "generate", "-d", output_dir, project_flag, reference_project_file, "--with", silabs_board+config_args, "--force"])

subprocess.run(["make","all", "-C", output_dir, "-f", makefile_path, "-j13"])
