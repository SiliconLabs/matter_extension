
#!/usr/bin/env python3

# This script installs the required tools to create a Matter project using Silicon Labs Configurator
# It generates a bash or a .bat script that can be run to set needed environment variables
# 
#
# tools installed: arm-gcc toolchain, slc-cli, zap
#

import os
import sys
import tarfile
import dload
import stat
from zipfile import ZipFile
# Use SILABS_MATTER_ROOT or use relative path
if "SILABS_MATTER_ROOT" not in os.environ:
    print("Using default path for Matter root")
    silabs_chip_root = os.path.normpath(os.path.dirname(os.path.abspath(__file__)) + os.sep + os.pardir)
else:
    print("Using ENV path for Matter root")
    silabs_chip_root = os.environ["SILABS_MATTER_ROOT"]

os.makedirs(os.path.join(silabs_chip_root, "slc/tools"), exist_ok=True)

tools_folder_path = os.path.join(silabs_chip_root, "slc","tools")

platform = sys.platform

if platform == "win32":
    arm_toolchain_url = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-win32.zip/?"
    java_url = "https://corretto.aws/downloads/latest/amazon-corretto-17-x64-windows-jdk.zip"
    slc_cli_url = "https://www.silabs.com/documents/login/software/slc_cli_windows.zip"
    zap_url = "https://github.com/project-chip/zap/releases/download/v2023.09.22-nightly/zap-win-x64.zip"
    commander_url = "https://www.silabs.com/documents/public/software/SimplicityCommander-Windows.zip"
    commander_path = os.path.join(tools_folder_path,"SimplicityCommander-Windows")
    commander_zip = os.path.join(commander_path,"Commander_win32_x64_1v16p0b1441.zip")
elif platform == "darwin":
    arm_toolchain_url = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-mac.tar.bz2?rev=58ed196feb7b4ada8288ea521fa87ad5&hash=62C9BE56E5F15D7C2D98F48BFCF2E839D7933597"
    java_url = "https://corretto.aws/downloads/latest/amazon-corretto-17-x64-macos-jdk.tar.gz"
    slc_cli_url = "https://www.silabs.com/documents/login/software/slc_cli_mac.zip"
    zap_url = "https://github.com/project-chip/zap/releases/download/v2023.09.22-nightly/zap-mac-x64.zip"
    commander_url = "https://www.silabs.com/documents/public/software/SimplicityCommander-Mac.zip"
    commander_path = os.path.join(tools_folder_path,"SimplicityCommander-Mac")
    commander_zip = os.path.join(commander_path,"Commander_osx_1v16p0b1441.zip")
    commander_app_path = os.path.join(commander_path,"Commander.app","Contents","MacOS")
elif platform =="linux":
    arm_toolchain_url = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2?rev=78196d3461ba4c9089a67b5f33edf82a&hash=5631ACEF1F8F237389F14B41566964EC"
    java_url = "https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.tar.gz"
    slc_cli_url = "https://www.silabs.com/documents/login/software/slc_cli_linux.zip"
    zap_url = "https://github.com/project-chip/zap/releases/download/v2023.09.22-nightly/zap-linux-x64.zip"
    commander_url = "https://www.silabs.com/documents/public/software/SimplicityCommander-Linux.zip"
    commander_path = os.path.join(tools_folder_path,"SimplicityCommander-Linux")
    commander_zip = os.path.join(commander_path,"Commander_linux_x86_64_1v16p0b1441.tar.bz")
else:
    print("ERROR: Platform ", platform, " is not supported")
    sys.exit()
    
arm_toolchain_path = os.path.join(silabs_chip_root, "slc", "tools","gcc-arm-none-eabi-10.3-2021.10","bin")
java_path = os.path.join(silabs_chip_root, "slc","tools","amazon-corretto-17.jdk")
java_path_win = os.path.join(silabs_chip_root, "slc","tools","jdk17.0.8_8")
java_path_linux = os.path.join(silabs_chip_root, "slc","tools","amazon-corretto-17.0.8.8.1-linux-x64")
slc_cli_path = os.path.join(silabs_chip_root, "slc","tools","slc_cli")
zap_path = os.path.join(silabs_chip_root, "slc","tools","zap")
arm_gcc_dir = os.path.join(tools_folder_path,"gcc-arm-none-eabi-10.3-2021.10")

# Download and extract arm toolchain
if not os.path.isfile(os.path.join(arm_toolchain_path, "arm-none-eabi-gcc")) and not os.path.isfile(os.path.join(arm_toolchain_path, "arm-none-eabi-gcc.exe")):
    print("Downloading and unzipping arm-none-eabi-gcc ...")
    if platform =="win32":
        dload.save_unzip(arm_toolchain_url,tools_folder_path, delete_after=True)
    else:
        dload.save(arm_toolchain_url, os.path.join(tools_folder_path,"gcc.tar.bz2"))
    
        tar = tarfile.open(os.path.join(tools_folder_path,"gcc.tar.bz2"), "r:bz2")  
        tar.extractall(path=tools_folder_path)
        tar.close()
        os.remove("slc/tools/gcc.tar.bz2")
else:
    print("arm-none-eabi-gcc already installed")

# Download and unzip java
if not os.path.isdir(java_path) and not os.path.isdir(java_path_win):
    print("Downloading and unzipping java ...")
    if platform =="win32":
        dload.save_unzip(java_url,tools_folder_path, delete_after=True)
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
if not os.path.isfile(os.path.join(zap_path, "zap-cli")) and not os.path.isfile(os.path.join(zap_path, "zap.exe")) :
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
    
#Download and extract Simplicity Commander
if not os.path.isfile(os.path.join(commander_path,"Commander.app","Contents","MacOS","commander")) and not os.path.isfile(os.path.join(commander_path,"Simplicity Commander","commander.exe")) and not os.path.isfile(os.path.join(commander_path,"commander","commander")) :
    print("Downloading and unzipping Simplicity Commander ...")
    dload.save_unzip(commander_url, tools_folder_path, delete_after=True)
    
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
if platform == "darwin":
    with open(os.path.expanduser("slc/tools/sl_env_vars.sh"), "w") as outfile:
        outfile.write("#!/usr/bin/env bash\n")
        outfile.write("export PATH=\"$PATH:" + arm_toolchain_path + "\"\n")
        outfile.write("export PATH=\"$PATH:" + slc_cli_path + "\"\n")
        outfile.write("export PATH=\"" + os.path.join(java_path, "Contents", "Home", "bin") + ":$PATH\"\n")
        outfile.write("export PATH=\""+ os.path.join(commander_app_path) + ":$PATH\"\n")
        outfile.write("export POST_BUILD_EXE=\""+os.path.join(commander_app_path,"commander") + "\"\n")
        outfile.write("export STUDIO_ADAPTER_PACK_PATH=\"" + zap_path + "\"\n")
        outfile.write("export ARM_GCC_DIR=\"" + arm_gcc_dir+ "\"\n")
        outfile.write("export JAVA17_HOME=\"" + os.path.join(java_path, "Contents", "Home\"\n"))
        outfile.write("export ZAP_INSTALL_PATH=\"" + zap_path + "\"\n")
elif platform == "win32":
    with open(os.path.expanduser(os.path.join(tools_folder_path,"sl_env_vars.bat")), "w") as outfile:
        outfile.write('SETX SLC "{}"\n'.format(slc_cli_path))
        outfile.write('SETX STUDIO_ADAPTER_PACK_PATH "{}"\n'.format(zap_path))
        outfile.write('SETX POST_BUILD_EXE "{}"\n'.format(os.path.join(commander_path,"Simplicity Commander","commander.exe")))
        outfile.write('SETX ARM_GCC_DIR "{}"\n'.format(arm_gcc_dir))
        outfile.write('SETX JAVA17_HOME "{}"\n'.format(java_path_win))
        outfile.write('SETX ZAP_INSTALL_PATH "{}"'.format(zap_path.replace("\\","/")))
    with open(os.path.expanduser(os.path.join(tools_folder_path,"sl_windows_path.txt")), "w") as outfile2:
        outfile2.write('{}\n{}\n{}\n{}\n'.format(slc_cli_path,zap_path,arm_toolchain_path,java_path_win+"\\bin"))
elif platform == "linux":
    with open(os.path.expanduser("slc/tools/sl_env_vars.sh"), "w") as outfile:
        outfile.write("#!/usr/bin/env bash\n")
        outfile.write("export PATH=\"$PATH:" + arm_toolchain_path + "\"\n")
        outfile.write("export PATH=\"$PATH:" + slc_cli_path + "\"\n")
        outfile.write("export PATH=\"" + os.path.join(java_path_linux, "bin") + ":$PATH\"\n")
        outfile.write("export STUDIO_ADAPTER_PACK_PATH=\"" + zap_path + ":" + commander_path+ "\"\n")
        outfile.write("export ARM_GCC_DIR=\"" + arm_gcc_dir+ "\"\n")
        outfile.write("export JAVA17_HOME=\"" + java_path_linux + "\"\n")
        outfile.write("export ZAP_INSTALL_PATH=\"" + zap_path + "\"\n")
