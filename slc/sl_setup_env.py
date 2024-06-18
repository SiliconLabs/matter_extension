
#!/usr/bin/env python3

# This script installs the required tools to create a Matter project using Silicon Labs Configurator
# It generates a bash or a .bat script that can be run to set needed environment variables
# 
#
# tools installed: arm-gcc toolchain, slc-cli, zap , Java, and Simplicity Commander
#

import os
import sys
import tarfile
import dload
import stat
import subprocess
from zipfile import ZipFile
import shutil
from sl_create_new_app import createApp

# Use SILABS_MATTER_ROOT or use relative path
if "SILABS_MATTER_ROOT" not in os.environ:
    print("Using default path for Matter root")
    silabs_chip_root = os.path.normpath(os.path.dirname(os.path.abspath(__file__)) + os.sep + os.pardir)
else:
    print("Using ENV path for Matter root")
    silabs_chip_root = os.environ["SILABS_MATTER_ROOT"]

os.makedirs(os.path.join(silabs_chip_root, "slc/tools"), exist_ok=True)

tools_folder_path = os.path.join(silabs_chip_root, "slc","tools")

#Minimum zap level required to work with the projects. 
MINIMUM_ZAP_LEVEL= 99

#setting variables to different tools url and paths
platform = sys.platform
if platform == "win32":
    #urls for all the tools
    arm_toolchain_url = "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-mingw-w64-i686-arm-none-eabi.zip?rev=709f3f15b2ee4763b186c10153ee6ca9&hash=8C0761A17A1E4861B96DDB604C177F5B"
    java_url = "https://corretto.aws/downloads/resources/17.0.8.8.1/amazon-corretto-17.0.8.8.1-windows-x64-jdk.zip"
    slc_cli_url = "https://www.silabs.com/documents/login/software/slc_cli_windows.zip"
    zap_url = "https://github.com/project-chip/zap/releases/download/v2024.06.04-nightly/zap-win-x64.zip"
    commander_url = "https://www.silabs.com/documents/public/software/SimplicityCommander-Windows.zip"
    ninja_url = "https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-win.zip"

    #environment paths for tools
    commander_path = os.path.join(tools_folder_path,"SimplicityCommander-Windows")
    os_name_commander = "Commander_win32"
    java_path = os.path.join(silabs_chip_root, "slc","tools","jdk17.0.8_8")
    arm_gcc_dir = os.path.join(tools_folder_path,"gcc")
    ninja_path = os.path.join(tools_folder_path,"ninja","ninja.exe")
elif platform == "darwin":
    #urls for all the tools
    arm_toolchain_url = "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-darwin-arm64-arm-none-eabi.tar.xz?rev=41f9ad86e18d43cf9999c4bada07f7df&hash=C458A8BF74CBA545BDCA38B7FB40AAF5"
    java_url = "https://corretto.aws/downloads/resources/17.0.8.8.1/amazon-corretto-17.0.8.8.1-macosx-x64.tar.gz"
    slc_cli_url = "https://www.silabs.com/documents/login/software/slc_cli_mac.zip"
    zap_url = "https://github.com/project-chip/zap/releases/download/v2024.06.04/zap-mac-x64.zip"
    commander_url = "https://www.silabs.com/documents/public/software/SimplicityCommander-Mac.zip"
    ninja_url = "https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-mac.zip"
    
    #environment paths for tools
    commander_path = os.path.join(tools_folder_path,"SimplicityCommander-Mac")
    os_name_commander = "Commander_osx"
    commander_app_path = os.path.join(commander_path,"Commander.app","Contents","MacOS")
    java_path = os.path.join(silabs_chip_root, "slc","tools","amazon-corretto-17.jdk")
    arm_gcc_dir = os.path.join(tools_folder_path,"arm-gnu-toolchain-12.2.rel1-darwin-arm64-arm-none-eabi")
    ninja_path = os.path.join(tools_folder_path,"ninja","ninja")
elif platform =="linux":
    #urls for all the tools
    arm_toolchain_url = "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz?rev=7bd049b7a3034e64885fa1a71c12f91d&hash=732D909FA8F68C0E1D0D17D08E057619"
    java_url = "https://corretto.aws/downloads/resources/17.0.8.8.1/amazon-corretto-17.0.8.8.1-linux-x64.tar.gz"
    slc_cli_url = "https://www.silabs.com/documents/login/software/slc_cli_linux.zip"
    zap_url = "https://github.com/project-chip/zap/releases/download/v2024.06.04-nightly/zap-linux-x64.zip"
    commander_url = "https://www.silabs.com/documents/public/software/SimplicityCommander-Linux.zip"
    ninja_url = "https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-linux.zip"
    
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


slc_cli_path = os.path.join(silabs_chip_root, "slc","tools","slc_cli")
zap_path = os.path.join(silabs_chip_root, "slc","tools","zap")
arm_toolchain_path = os.path.join(arm_gcc_dir,"bin")


# Download and extract arm toolchain
if not os.path.isfile(os.path.join(arm_toolchain_path, "arm-none-eabi-gcc")) and not os.path.isfile(os.path.join(arm_toolchain_path, "arm-none-eabi-gcc.exe")):
    print("Downloading and unzipping arm-none-eabi-gcc ...")
    if platform =="win32":
        dload.save(arm_toolchain_url,os.path.join(tools_folder_path,"gcc.zip"))
        with ZipFile(os.path.join(tools_folder_path,"gcc.zip"), 'r') as zObject:
            zObject.extractall(path=tools_folder_path)
        os.remove(os.path.join(tools_folder_path,"gcc.zip"))
        os.chmod(arm_gcc_dir, stat.S_IEXEC)
        os.rename(arm_gcc_dir,os.path.join(tools_folder_path,"gcc"))
    else:
        dload.save(arm_toolchain_url, os.path.join(tools_folder_path,"gcc.tar.xz"))
        tar = tarfile.open(os.path.join(tools_folder_path,"gcc.tar.xz"), "r:xz")  
        tar.extractall(path=tools_folder_path)
        tar.close()
        os.remove("slc/tools/gcc.tar.xz")
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
        dload.save_unzip(zap_url, os.path.join(tools_folder_path,"zap"), delete_after=True)

        # Give execute permissions for zap-cli and zap binaries
        if platform == "darwin":
            st = os.stat(os.path.join(tools_folder_path,"zap","zap-cli"))
            os.chmod(os.path.join(tools_folder_path,"zap","zap-cli"), st.st_mode | stat.S_IEXEC)
        elif platform == "linux":
            st = os.stat(os.path.join(tools_folder_path,"zap","zap-cli"))
            os.chmod(os.path.join(tools_folder_path,"zap","zap-cli"), st.st_mode | stat.S_IEXEC)
            st = os.stat(os.path.join(tools_folder_path,"zap","zap"))
            os.chmod(os.path.join(tools_folder_path,"zap","zap"), st.st_mode | stat.S_IEXEC)
    else:
        print("zap already installed")

download_zap()   
#checking zap version using zap-cli. Expecting following output
###################
#Version: 2024.1.5
#Feature level: 99
#Hash: 9c4b5244168a512112d98c5807285a7dbc8b5f3d
#Date: 2024-01-05T19:47:30.000Z
#Mode: binary
#Executable: zap-cli 
####################

zap = os.path.join(zap_path,"zap-cli")
command = f"{zap} --version"
output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, universal_newlines=True)
result = output.split("\n")
zap_level = int(result[1].split(":")[1])
if zap_level < MINIMUM_ZAP_LEVEL:
    print(f"Installed zap version is {zap_level} which is less that Minimum Required level of {MINIMUM_ZAP_LEVEL}")
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
        os.system(command)
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
       

#Save PATHs in .env file for future use. 
if platform == "darwin":
    with open(os.path.expanduser("slc/tools/.env"), "w") as outfile:
        outfile.write("STUDIO_ADAPTER_PACK_PATH={}\n".format(zap_path))
        outfile.write("POST_BUILD_EXE={}\n".format(os.path.join(commander_app_path,"commander")))
        outfile.write("ARM_GCC_DIR={}\n".format(arm_gcc_dir))
        outfile.write("JAVA17_HOME={}\n".format(os.path.join(java_path, "Contents", "Home")))
        outfile.write("ZAP_INSTALL_PATH={}\n".format(zap_path))
        outfile.write("TOOLS_PATH={}:{}:{}:{}:\n".format(arm_toolchain_path,slc_cli_path,os.path.join(java_path, "Contents", "Home", "bin"),commander_app_path))
        outfile.write("silabs_chip_root={}\n".format(silabs_chip_root))
        outfile.write("NINJA_EXE_PATH={}".format(ninja_path))
elif platform == "win32":
    with open(os.path.expanduser(os.path.join(tools_folder_path,".env")), "w") as outfile:
        outfile.write('STUDIO_ADAPTER_PACK_PATH={}\n'.format(zap_path))
        outfile.write('POST_BUILD_EXE={}\n'.format(os.path.join(commander_path,"Simplicity Commander","commander.exe")))
        outfile.write('ARM_GCC_DIR={}\n'.format(arm_gcc_dir))
        outfile.write('JAVA17_HOME={}\n'.format(java_path))
        outfile.write('ZAP_INSTALL_PATH={}\n'.format(zap_path.replace("\\","/")))
        outfile.write('TOOLS_PATH={};{};{};{};\n'.format(slc_cli_path,zap_path,arm_toolchain_path,java_path+"\\bin"))
        outfile.write('SLC={}\n'.format(slc_cli_path))
        outfile.write("silabs_chip_root={}\n".format(silabs_chip_root))
        outfile.write("NINJA_EXE_PATH={}".format(ninja_path))
elif platform == "linux":
    with open(os.path.expanduser("slc/tools/.env"), "w") as outfile:
        outfile.write("STUDIO_ADAPTER_PACK_PATH={}\n".format(zap_path))
        outfile.write("POST_BUILD_EXE={}\n".format(os.path.join(commander_app_path,"commander")))
        outfile.write("ARM_GCC_DIR={}\n".format(arm_gcc_dir))
        outfile.write("JAVA17_HOME={}\n".format(java_path))
        outfile.write("ZAP_INSTALL_PATH={}\n".format(zap_path))
        outfile.write("TOOLS_PATH={}:{}:{}:{}\n".format(arm_toolchain_path,slc_cli_path,os.path.join(java_path, "bin"),commander_app_path))
        outfile.write("silabs_chip_root={}\n".format(silabs_chip_root))
        outfile.write("NINJA_EXE_PATH={}".format(ninja_path))

#Trust extensions
App = createApp()

#Create file for users to add env variables for Visual Studio based builds
with open(os.path.expanduser(os.path.join(tools_folder_path,"environment_variables_vscode.txt")),"w") as outfile:
    outfile.write("POST_BUILD_EXE = {}\n".format(App.POST_BUILD_EXE))
    outfile.write("NINJA_EXE_PATH = {}\n".format(App.NINJA_EXE_PATH))

trust_wifi="no"
trust_msg = "Do you want to use SiWx91x for development?(yes / no) "
trust_wifi917=input(trust_msg)
trust_wifi917 = trust_wifi917.lower().strip()
if trust_wifi917 not in ["yes","no"]:
    print("\nINVALID response!! Please select from 'yes' / 'no'\n")
    trust_wifi917 = input(trust_msg).strip().lower()
wifi917 = True if trust_wifi917=="yes" else False
App.slc_trust(wifi917)