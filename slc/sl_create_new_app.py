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
        self.SoC_boards = ["brd4338a", "brd4342a", "brd4343a", "brd2605a", "brd2708a", "brd2911a"]
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
        self.silabs_board = sys.argv[3].lower()

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
        #Checkout third_party_hw_drivers_extension submodule for air-quality-sensor-app-sparkfun-thread app and trust the extension
        if "sparkfun" in self.reference_project_file:
            third_party_hw_drivers_extension_path = os.path.join(os.getcwd(),"third_party","third_party_hw_drivers_extension")
            subprocess.run(["git", "submodule", "update", "--init", "--checkout",third_party_hw_drivers_extension_path ])
            subprocess.run([self.slc_path, "signature", "trust", "--extension-path", third_party_hw_drivers_extension_path])

    def get_environment(self):
        try:
            env_path = os.path.join(os.getcwd(),"slc","tools",".env")
            load_dotenv(env_path,override=True)
            os.environ["PATH"] = os.getenv("TOOLS_PATH") +  os.environ["PATH"]
            self.java_path = os.getenv("JAVA17_HOME")
            self.silabs_chip_root = os.getenv("silabs_chip_root")
            self.POST_BUILD_EXE = os.getenv("POST_BUILD_EXE")
            self.NINJA_EXE_PATH = os.getenv("NINJA_EXE_PATH")
            self.sisdk_root = os.getenv("SISDK_ROOT")
            self.wiseconnect_root = os.getenv("WISECONNECT_ROOT")
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
        for locations in trust_locations:
            sdk_or_ext = locations[0]
            location = locations[1]

            #verify the location of sdk and extensions
            if not os.path.isdir(location):
                print(f"\nThe {sdk_or_ext} does not exist at location:{location}")
                sys.exit(1)

            #trust the sdk and extensions
            print(f"\nTrusting {sdk_or_ext} at location: {location}")
            try:
                if sdk_or_ext=="SDK":
                    subprocess.run([self.slc_path, "configuration", "--sdk", location])
                    subprocess.run([self.slc_path, "signature", "trust", "--sdk", location])
                else:#sdk_ext="Extension":
                    subprocess.run([self.slc_path, "signature", "trust", "--extension-path", location])
            except Exception as e:
                print("Error while trusting the location",location)
                print(e)
                sys.exit(1)

    def slc_trust(self):
        #Get user permission to trust simplicity_sdk and extensions with use arm gcc
        #use arm-gcc toolchain with slc
        subprocess.run([self.slc_path, "configuration","-gcc", self.arm_toolchain_path])

        trust_locations = [["SDK",self.sisdk_root],["Extension", self.silabs_chip_root],
                                                    ["Extension",self.wiseconnect_root]]
        self.trust_location(trust_locations)


    def generate(self):
        #use appropriate build flag for sample-app/solutions
        project_flag = "-p" if self.reference_project_file.endswith('.slcp') else "-w"
        #check for soc boards
        config_args=";wiseconnect3_sdk"  if self.silabs_board in self.SoC_boards else ""
        #run slc generate to create copy of sample app at the 'new_app_name' location
        try:
            cmd = [self.slc_path, "--java-location", self.java_path, "generate", "-d", self.new_app_name,project_flag, self.reference_project_file, "--with", self.silabs_board+config_args, "--new-project", "--force", "--generator-timeout=180", "-o", "makefile"]
            subprocess.run(cmd, check=True)
        except subprocess.CalledProcessError:
            print("Error running 'slc generate'")
            sys.exit(1)
            

if __name__ == "__main__":
    app = createApp()
    app.validate_arguments()
    app.generate()
