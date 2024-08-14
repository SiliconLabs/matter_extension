#!/usr/bin/env python

import os
import sys
import subprocess
from dotenv import load_dotenv
from pathlib import Path

class createApp:
    """Class used to create new app from given arguments and slc"""
    def __init__(self):
        self.EXAMPLE_USAGE = "python slc/sl_create_new_app.py <NewAppName> <PathToReferenceProjectFile(.slcp or .slcw)> <SilabsBoard>"
        self.SoC_boards = ["brd4338a"]
        self.get_environment()

    def print_usage_and_exit(self):
        print("Example usage:", self.EXAMPLE_USAGE)
        sys.exit(1)

    def validate_arguments(self):
        if len(sys.argv) < 4:
            print("Missing arguments")
            self.print_usage_and_exit()

        self.new_app_name = sys.argv[1]
        self.reference_project_file = sys.argv[2]
        self.silabs_board = sys.argv[3]

        #check if app is siwx917 wifi app
        self.wifi917 = True if "917" in self.reference_project_file else False
        if not os.path.exists(self.reference_project_file):
            print("ReferenceProject File does not exist:", self.reference_project_file)
            sys.exit(1)

        if not self.reference_project_file.endswith('.slcp') and not self.reference_project_file.endswith('.slcw'):
            print("ReferenceSlcp File should have a .slcp or .slcw extension")
            sys.exit(1)

        if not self.silabs_board:
            print("Missing SilabsBoard argument")
            self.print_usage_and_exit()
        
        if self.silabs_board in self.SoC_boards:
            if not os.path.isdir(self.wiseconnect_root):
                print(f"\nThe Wifi Extension required to build the {self.reference_project_file} does not exist at location:{self.wiseconnect_root}")
                sys.exit(1)

    def get_environment(self):
        try:
            env_path = os.path.join(os.getcwd(),"slc","tools",".env")
            load_dotenv(env_path,override=True)
            os.environ["PATH"] = os.getenv("TOOLS_PATH") +  os.environ["PATH"]
            self.java_path = os.getenv("JAVA17_HOME")
            self.silabs_chip_root = os.getenv("silabs_chip_root")
            self.POST_BUILD_EXE = os.getenv("POST_BUILD_EXE")
            self.NINJA_EXE_PATH = os.getenv("NINJA_EXE_PATH")
            self.gsdk_root = Path(os.getcwd()).parent.parent
            self.wiseconnect_root = os.path.join(self.gsdk_root,"extension","wiseconnect")
            self.arm_toolchain_path = os.path.join(os.getenv("ARM_GCC_DIR"))
        except:
            print("Could not load the .env file. Run sl_setup_env.py generate .env file")
            sys.exit(1)
        
        self.slc_path = "slc"
        if sys.platform == "win32":
            try:
                self.slc_path = os.path.join(os.getenv("SLC"),"slc.bat")
            except:
                print("SLC undefined. Set SLC from the sl_env_vars.bat")

    def trust_location(self, trust_locations):
        #Ask user permission to trust SDK/Extension at given location
        #verify the location
        sdk_ext = ""
        for locations in trust_locations:
            sdk_or_ext = locations[0]
            location = locations[1]
            if not os.path.isdir(location):
                print(f"\nThe {sdk_or_ext} does not exist at location:{location}")
                sys.exit(1)
            locations_str = sdk_or_ext + ":" + str(location)
            sdk_ext += locations_str + "\n"

        trust = "no"
        trust_msg = f"\nSLC is trying to trust the following SDKs/Extensions.\n\n{sdk_ext}\n\
SDKs/Extensions can provide executables and scripts that SLC may automatically execute.\n\
They can also provide malicious embedded code or libraries\n\
SLC cannot verify the contents of the SDKs/Extensions.\n\
Do you want to trust above SDKs/Extensions (yes / no) ? : "
        
        
        trust = input(trust_msg ).strip().lower()
        if trust not in ["yes","no"]:
            print("\nINVALID response!! Please select from 'yes' / 'no'\n")
            trust = input(trust_msg ).strip().lower()
        if trust == "yes":
            for locations in trust_locations:
                sdk_or_ext = locations[0]
                location = locations[1] 
                if sdk_or_ext=="SDK":
                    subprocess.run([self.slc_path, "configuration", "--sdk", location])
                    subprocess.run([self.slc_path, "signature", "trust", "--sdk", location])
                else:#sdk_ext="Extension":
                    subprocess.run([self.slc_path, "signature", "trust", "--extension-path", location])
        else:
            print(f"{sdk_or_ext} : '{location}' not trusted")
            sys.exit(1)

    def slc_trust(self , wifi917):
        #Get user permission to trust simplicity_sdk and extensions with use arm gcc
        #use arm-gcc toolchain with slc
        subprocess.run([self.slc_path, "configuration","-gcc", self.arm_toolchain_path])

        trust_locations = [["SDK",self.gsdk_root],["Extension", self.silabs_chip_root]]
        if wifi917:
            trust_locations.append(["Extension",self.wiseconnect_root])

        self.trust_location(trust_locations)


    def generate(self):
        #use appropriate build flag for sample-app/workspaces
        project_flag = "-p" if self.reference_project_file.endswith('.slcp') else "-w"
        #check for soc boards
        config_args=";wiseconnect3_sdk"  if self.silabs_board in self.SoC_boards else ""
        #run slc generate to create copy of sample app at the 'new_app_name' location
        try:
            cmd = [self.slc_path, "--java-location", self.java_path, "generate", "-d", self.new_app_name,project_flag, self.reference_project_file, "--with", self.silabs_board+config_args, "--new-project", "--force"]
            subprocess.run(cmd, check=True)
        except subprocess.CalledProcessError:
            print("Error running 'slc generate'")
            sys.exit(1)
            

if __name__ == "__main__":
    app = createApp()
    app.validate_arguments()
    app.generate()
