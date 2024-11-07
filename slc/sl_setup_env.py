
#!/usr/bin/env python3

# This script installs the required tools to create a Matter project using Silicon Labs Configurator
# It generates a bash or a .bat script that can be run to set needed environment variables
# 
#
# tools installed: arm-gcc toolchain, slc-cli, zap , Java, ninja,  and Simplicity Commander
#

import os
import sys
import tarfile
import dload
import stat
import subprocess
from zipfile import ZipFile
import shutil
import json
from datetime import datetime
import re 
from pathlib import Path
from sl_create_new_app import createApp
from script.get_zap_version import get_zap_version

if sys.version_info < (3, 6):
    print("This script requires Python 3.6 or higher!")
    sys.exit(1)

# Use SILABS_MATTER_ROOT or use relative path
if "SILABS_MATTER_ROOT" not in os.environ:
    print("Using default path for Matter root")
    silabs_chip_root = Path(__file__).resolve().parents[1]
else:
    print("Using ENV path for Matter root")
    silabs_chip_root = os.environ["SILABS_MATTER_ROOT"]

tools_folder_path = os.path.join(silabs_chip_root, "slc","tools")
os.makedirs(tools_folder_path, exist_ok=True)

print("\nSyncing and checking out submodules")
# Checkout submodules
try:
    subprocess.run(["git", "submodule", "sync"])
    subprocess.run(["git", "submodule", "update", "--init"])
except Exception as e:
    print(e)
    print("Cannot checkout submodules")
    sys.exit(1)
print("Submodules checked out successfully\n")

#setting variables to different tools url and paths
platform = sys.platform
if platform == "win32":
    _platform = "win"
    __platform = "windows"
    #urls for all the tools
    arm_toolchain_url = "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-mingw-w64-i686-arm-none-eabi.zip?rev=709f3f15b2ee4763b186c10153ee6ca9&hash=8C0761A17A1E4861B96DDB604C177F5B"
    java_url = "https://corretto.aws/downloads/resources/17.0.8.8.1/amazon-corretto-17.0.8.8.1-windows-x64-jdk.zip"

    #environment paths for tools
    commander_path = os.path.join(tools_folder_path,"SimplicityCommander-Windows")
    os_name_commander = "Commander_win32"
    java_path = os.path.join(silabs_chip_root, "slc","tools","jdk17.0.8_8")
    arm_gcc_dir = os.path.join(tools_folder_path,"gcc")
    arm_gcc_download_dir = os.path.join( tools_folder_path, "arm-gnu-toolchain-12.2.rel1-mingw-w64-i686-arm-none-eabi" )
    ninja_path = os.path.join(tools_folder_path,"ninja","ninja.exe")
elif platform == "darwin":
    _platform = "mac"
    __platform = "mac"
    #urls for all the tools
    arm_toolchain_url = "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-darwin-arm64-arm-none-eabi.tar.xz?rev=41f9ad86e18d43cf9999c4bada07f7df&hash=C458A8BF74CBA545BDCA38B7FB40AAF5"
    java_url = "https://corretto.aws/downloads/resources/17.0.8.8.1/amazon-corretto-17.0.8.8.1-macosx-x64.tar.gz"
    
    #environment paths for tools
    commander_path = os.path.join(tools_folder_path,"SimplicityCommander-Mac")
    os_name_commander = "Commander_osx"
    commander_app_path = os.path.join(commander_path,"Commander.app","Contents","MacOS")
    java_path = os.path.join(silabs_chip_root, "slc","tools","amazon-corretto-17.jdk")
    arm_gcc_dir = os.path.join(tools_folder_path,"arm-gnu-toolchain-12.2.rel1-darwin-arm64-arm-none-eabi")
    ninja_path = os.path.join(tools_folder_path,"ninja","ninja")
elif platform =="linux":
    _platform = platform
    __platform = platform
    #urls for all the tools
    arm_toolchain_url = "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz?rev=7bd049b7a3034e64885fa1a71c12f91d&hash=732D909FA8F68C0E1D0D17D08E057619"
    java_url = "https://corretto.aws/downloads/resources/17.0.8.8.1/amazon-corretto-17.0.8.8.1-linux-x64.tar.gz"
    
    #environment paths for tools
    commander_path = os.path.join(tools_folder_path,"SimplicityCommander-Linux")
    os_name_commander = "Commander_linux_x86_64"
    java_path = os.path.join(silabs_chip_root, "slc","tools","amazon-corretto-17.0.8.8.1-linux-x64")
    commander_app_path = os.path.join(commander_path,"commander")
    arm_gcc_dir = os.path.join(tools_folder_path,"arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi")
    ninja_path = os.path.join(tools_folder_path,"ninja","ninja")
    
else:
    print("ERROR: Platform ", platform, " is not supported")
    sys.exit()

MINIMUM_ZAP_REQUIRED = get_zap_version()
#urls for all the tools
zap_url = f"https://github.com/project-chip/zap/releases/download/{MINIMUM_ZAP_REQUIRED}/zap-{_platform}-x64.zip"
ninja_url = f"https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-{_platform}.zip"
commander_url = f"https://www.silabs.com/documents/public/software/SimplicityCommander-{__platform.capitalize()}.zip"
slc_cli_url = f"https://www.silabs.com/documents/login/software/slc_cli_{__platform}.zip"

#paths for all the tools
slc_cli_path = os.path.join(silabs_chip_root, "slc","tools","slc_cli")
zap_path = os.path.join(silabs_chip_root, "slc","tools","zap")
arm_toolchain_path = os.path.join(arm_gcc_dir,"bin")
sisdk_root = os.path.join(silabs_chip_root,"third_party","simplicity_sdk")
wifi_sdk_path = os.path.join(silabs_chip_root,"third_party","wifi_sdk")


# Download and extract arm toolchain
if not os.path.isfile(os.path.join(arm_toolchain_path, "arm-none-eabi-gcc")) and not os.path.isfile(os.path.join(arm_toolchain_path, "arm-none-eabi-gcc.exe")):
    print("Downloading and unzipping arm-none-eabi-gcc ...")
    if platform =="win32":
        gcc_zip_path = os.path.join(tools_folder_path,"gcc.zip")
        dload.save(arm_toolchain_url,gcc_zip_path)
        with ZipFile(gcc_zip_path, 'r') as zObject:
            zObject.extractall(path=tools_folder_path)
        os.remove(gcc_zip_path)
        os.chmod(arm_gcc_download_dir, stat.S_IEXEC)
        os.rename(arm_gcc_download_dir,os.path.join(tools_folder_path,"gcc"))
    else:
        dload.save(arm_toolchain_url, os.path.join(tools_folder_path,"gcc.tar.xz"))
        tar = tarfile.open(os.path.join(tools_folder_path,"gcc.tar.xz"), "r:xz")  
        tar.extractall(path=tools_folder_path)
        tar.close()
        os.remove(tools_folder_path+"/gcc.tar.xz")
else:
    print("arm-none-eabi-gcc already installed")

# Download and unzip java
if not os.path.isdir(java_path):
    print("Downloading and unzipping java ...")
    if platform =="win32":
        dload.save(java_url,os.path.join(tools_folder_path,"java.zip"))
        with ZipFile(os.path.join(tools_folder_path,"java.zip"), 'r') as zObject:
            zObject.extractall(path=tools_folder_path)
        os.remove(os.path.join(tools_folder_path,"java.zip"))
    else:
        dload.save(java_url, os.path.join(tools_folder_path,"java.tar.gz"))
        tar = tarfile.open(os.path.join(tools_folder_path,"java.tar.gz"), "r:gz")
        tar.extractall(path=tools_folder_path)
        tar.close()
        os.remove("slc/tools/java.tar.gz")
else:
    print("java already installed")    

# Download and unzip slc_cli
if not os.path.isfile(os.path.join(slc_cli_path, "slc")):
    print("Downloading and unzipping slc_cli ...")
    dload.save_unzip(slc_cli_url, tools_folder_path, delete_after=True)

    # Give execute permissions for slc-cli binary
    st = os.stat(os.path.join(tools_folder_path,"slc_cli","slc"))
    os.chmod(os.path.join(tools_folder_path,"slc_cli","slc"), st.st_mode | stat.S_IEXEC)
    if platform == "darwin":
        st = os.stat(os.path.join(tools_folder_path,"slc_cli","bin","slc-cli","slc-cli.app","Contents","MacOS","slc-cli"))
        os.chmod(os.path.join(tools_folder_path,"slc_cli","bin","slc-cli","slc-cli.app","Contents","MacOS","slc-cli"), st.st_mode | stat.S_IEXEC)
    elif platform == "linux":
        st = os.stat(os.path.join(tools_folder_path,"slc_cli","bin","slc-cli","slc-cli"))
        os.chmod(os.path.join(tools_folder_path,"slc_cli","bin","slc-cli","slc-cli"), st.st_mode | stat.S_IEXEC) 
else:
    print("slc_cli already installed")


# Download and unzip zap
def download_zap(install_without_checking = False):
    if (not os.path.isfile(os.path.join(zap_path, "zap-cli")) and not os.path.isfile(os.path.join(zap_path, "zap.exe"))) or install_without_checking :
        print("Downloading and unzipping zap ...")
    
        # Give execute permissions for zap-cli and zap binaries
        if platform == "darwin":
            dload.save(zap_url, zap_path+".zip")
            command = "unzip "+ zap_path+".zip" + " -d " + zap_path
            os.system(f"{command} > /dev/null 2>&1")
            os.remove(zap_path+".zip")
            st = os.stat(os.path.join(zap_path,"zap-cli"))
            os.chmod(os.path.join(zap_path,"zap-cli"), st.st_mode | stat.S_IEXEC)

            zap_root = os.path.join(zap_path,"zap.app","Contents","MacOS","zap")
            st = os.stat(zap_root)
            os.chmod(zap_root, st.st_mode | stat.S_IEXEC)
        elif platform == "linux":
            dload.save_unzip(zap_url, os.path.join(tools_folder_path,"zap"), delete_after=True)
            st = os.stat(os.path.join(tools_folder_path,"zap","zap-cli"))
            os.chmod(os.path.join(tools_folder_path,"zap","zap-cli"), st.st_mode | stat.S_IEXEC)
            st = os.stat(os.path.join(tools_folder_path,"zap","zap"))
            os.chmod(os.path.join(tools_folder_path,"zap","zap"), st.st_mode | stat.S_IEXEC)
        elif platform == "win32":
            dload.save_unzip(zap_url, os.path.join(tools_folder_path,"zap"), delete_after=True)
    else:
        print("zap already installed")

download_zap()

zap = os.path.join(zap_path,"zap-cli")
command = f"{zap} --version"
output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, universal_newlines=True)
# Extract version using regex
installed_zap_version = re.search(r"Version:\s*([\d.]+)", output).group(1)
#get version from MINIMUM_ZAP_REQUIRED
MINIMUM_ZAP_REQUIRED = MINIMUM_ZAP_REQUIRED.replace("v","").replace("-nightly","")
#Convert to datetime object for comparison
date_format="%Y.%m.%d"
installed_zap_version = datetime.strptime(installed_zap_version, date_format)
MINIMUM_ZAP_REQUIRED = datetime.strptime(MINIMUM_ZAP_REQUIRED, date_format)

#Check if installed zap version is less than minimum required version
if installed_zap_version < MINIMUM_ZAP_REQUIRED:
    print(f"Installed zap version is {installed_zap_version} which is less that Minimum Required level of {MINIMUM_ZAP_REQUIRED}")
    # Try to delete old zap.
    try:
        print(f"Deleting old version of zap located at {zap_path}")
        shutil.rmtree(zap_path)
        download_zap(True)
    except:
        print(f"Error while deleting zap located at {zap_path}\nUsing older version of zap may lead to errors.")
    
#Download and extract Simplicity Commander
if not os.path.isfile(os.path.join(commander_path,"Commander.app","Contents","MacOS","commander")) and not os.path.isfile(os.path.join(commander_path,"Simplicity Commander","commander.exe")) and not os.path.isfile(os.path.join(commander_path,"commander","commander")) :
    print("Downloading and unzipping Simplicity Commander ...")
    dload.save_unzip(commander_url, tools_folder_path, delete_after=True)
    for filename in os.listdir(commander_path):
        if os_name_commander in filename:
            commander_zip = os.path.join(commander_path,filename)
            break
    else:
        print("Cannot find Simplicity Commander ...")
        sys.ext(1)
    if platform == "darwin":
        command = "unzip "+ commander_zip + " -d " + commander_path
        os.system(f"{command} > /dev/null 2>&1")
        os.remove(commander_zip)
    if platform == "win32":
        with ZipFile(commander_zip, 'r') as zObject:
            zObject.extractall(path=commander_path)
        os.remove(commander_zip)
    if platform == "linux":
        tar = tarfile.open(commander_zip, "r:bz2")  
        tar.extractall(path=commander_path)
        tar.close()
        os.remove(commander_zip)
else:
    print("Simplicity Commander already installed")

try:
    #Downlaod and extract ninja build
    if not os.path.isfile(ninja_path):
        print("Downloading and unzipping ninja ...")
        dload.save_unzip(ninja_url, os.path.join(tools_folder_path,"ninja"), delete_after=True)

    else:
        print("ninja already installed")
    print(f"For Visual Studio Code and CMAKE based builds please add '{ninja_path}' as NINJA_EXE_PATH environment variable\n ")
except:
    print("\n\n============Could not install ninja!!============\n\n")

print("All tools installed successfully")

def create_symlink(target, link_name):
    # Create a symbolic link if it does not already exist
    try:
        if not os.path.islink(link_name):
            os.symlink(target, link_name)
    except Exception as e:
        print(e)
        print(f"Cannot create symbolic link for {link_name}")
        sys.exit(1)

# Define the extension directory path
extension_dir = os.path.join(sisdk_root, "extension")

# Create the extension directory if it does not exist
if not os.path.exists(extension_dir):
    os.makedirs(extension_dir)

# Define the paths for matter_extension and wiseconnect
matter_root = os.path.join(extension_dir, "matter_extension")
wiseconnect_root = os.path.join(extension_dir, "wiseconnect")

print("Creating symbolic links for matter_extension and wiseconnect")
# Create symbolic links for matter_extension and wiseconnect
create_symlink(silabs_chip_root, matter_root)
create_symlink(wifi_sdk_path, wiseconnect_root)
print("Symbolic links created successfully\n")

#Save PATHs in .env file for future use. 
if platform == "darwin":
    with open(os.path.expanduser("slc/tools/.env"), "w") as outfile:
        outfile.write("STUDIO_ADAPTER_PACK_PATH={}\n".format(zap_path))
        outfile.write("POST_BUILD_EXE={}\n".format(os.path.join(commander_app_path,"commander")))
        outfile.write("ARM_GCC_DIR={}\n".format(arm_gcc_dir))
        outfile.write("JAVA17_HOME={}\n".format(os.path.join(java_path, "Contents", "Home")))
        outfile.write("ZAP_INSTALL_PATH={}\n".format(zap_path))
        outfile.write("TOOLS_PATH={}:{}:{}:{}:\n".format(arm_toolchain_path,slc_cli_path,os.path.join(java_path, "Contents", "Home", "bin"),commander_app_path))
        outfile.write("silabs_chip_root={}\n".format(matter_root))
        outfile.write("NINJA_EXE_PATH={}\n".format(ninja_path))
        outfile.write("SISDK_ROOT={}\n".format(sisdk_root))
        outfile.write("WISECONNECT_ROOT={}\n".format(wiseconnect_root))
elif platform == "win32":
    with open(os.path.expanduser(os.path.join(tools_folder_path,".env")), "w") as outfile:
        outfile.write('STUDIO_ADAPTER_PACK_PATH={}\n'.format(zap_path))
        outfile.write('POST_BUILD_EXE={}\n'.format(os.path.join(commander_path,"Simplicity Commander","commander.exe")))
        outfile.write('ARM_GCC_DIR={}\n'.format(arm_gcc_dir))
        outfile.write('JAVA17_HOME={}\n'.format(java_path))
        outfile.write('ZAP_INSTALL_PATH={}\n'.format(zap_path.replace("\\","/")))
        outfile.write('TOOLS_PATH={};{};{};{};\n'.format(slc_cli_path,zap_path,arm_toolchain_path,java_path+"\\bin"))
        outfile.write('SLC={}\n'.format(slc_cli_path))
        outfile.write("silabs_chip_root={}\n".format(matter_root))
        outfile.write("NINJA_EXE_PATH={}\n".format(ninja_path))
        outfile.write("SISDK_ROOT={}\n".format(sisdk_root))
        outfile.write("WISECONNECT_ROOT={}\n".format(wiseconnect_root))
elif platform == "linux":
    with open(os.path.expanduser("slc/tools/.env"), "w") as outfile:
        outfile.write("STUDIO_ADAPTER_PACK_PATH={}\n".format(zap_path))
        outfile.write("POST_BUILD_EXE={}\n".format(os.path.join(commander_app_path,"commander")))
        outfile.write("ARM_GCC_DIR={}\n".format(arm_gcc_dir))
        outfile.write("JAVA17_HOME={}\n".format(java_path))
        outfile.write("ZAP_INSTALL_PATH={}\n".format(zap_path))
        outfile.write("TOOLS_PATH={}:{}:{}:{}\n".format(arm_toolchain_path,slc_cli_path,os.path.join(java_path, "bin"),commander_app_path))
        outfile.write("silabs_chip_root={}\n".format(matter_root))
        outfile.write("NINJA_EXE_PATH={}\n".format(ninja_path))
        outfile.write("SISDK_ROOT={}\n".format(sisdk_root))
        outfile.write("WISECONNECT_ROOT={}\n".format(wiseconnect_root))

#Trust extensions
App = createApp()

#Create file for users to add env variables for Visual Studio based builds
with open(os.path.expanduser(os.path.join(tools_folder_path,"environment_variables_vscode.txt")),"w") as outfile:
    outfile.write("POST_BUILD_EXE = {}\n".format(App.POST_BUILD_EXE))
    outfile.write("NINJA_EXE_PATH = {}\n".format(App.NINJA_EXE_PATH))

print("Trust SDK and extensions")
App.slc_trust()
print("\nTrust completed successfully")

print("\nEnvironment setup completed successfully")