#!/usr/bin/env python3

"""
sl_setup_env.py

Environment setup script for Matter project using Silicon Labs Configurator.

This script installs the required tools to create a Matter project using Silicon Labs Configurator.
It also generates a .env file that can be sourced or used to set the needed environment variables for your shell or command prompt.

Tools installed:
  - arm-gcc toolchain
  - slc-cli
  - zap
  - Java
  - ninja
  - Simplicity Commander

Usage:
  python3 sl_setup_env.py [--verbose]
"""

import argparse
import logging
import os
import sys
import tarfile
import dload
import stat
import subprocess
import shutil
import json
import re 
from datetime import datetime
from zipfile import ZipFile
from pathlib import Path
from sl_create_new_app import createApp
from script.get_zap_version import get_zap_version


if sys.version_info < (3, 9):
    logging.error("This script requires Python 3.9 or higher!")
    sys.exit(1)


# Full refactor: encapsulate all setup steps in MatterEnvSetup class
class MatterEnvSetup:
    def __init__(self, verbose=False):
        self.verbose = verbose
        self.setup_logging()
        self.set_root_paths()
        self.set_platform_vars()
        self.set_tool_urls_and_paths()
        self.MINIMUM_ZAP_REQUIRED = get_zap_version()

    def setup_logging(self):
        level = logging.DEBUG if self.verbose else logging.INFO
        logging.basicConfig(level=level, format='[%(levelname)s] %(message)s')

    def set_root_paths(self):
        if "SILABS_MATTER_ROOT" not in os.environ:
            logging.info("Using default path for Matter root")
            self.silabs_chip_root = Path(__file__).resolve().parents[1]
        else:
            logging.info("Using ENV path for Matter root")
            self.silabs_chip_root = os.environ["SILABS_MATTER_ROOT"]
        self.tools_folder_path = os.path.join(self.silabs_chip_root, "slc", "tools")
        os.makedirs(self.tools_folder_path, exist_ok=True)

    def sync_submodules(self):
        logging.info("Syncing and checking out submodules")
        try:
            subprocess.run(["git", "submodule", "sync"])
            subprocess.run(["git", "submodule", "update", "--init"])
        except Exception as e:
            logging.error(f"Cannot checkout submodules: {e}")
            sys.exit(1)
        logging.info("Submodules checked out successfully\n")

    def set_platform_vars(self):
        platform = sys.platform
        self.platform = platform
        if platform == "win32":
            self._platform = "win"
            self.__platform = "windows"
        elif platform == "darwin":
            self._platform = "mac"
            self.__platform = "mac"
        elif platform == "linux":
            self._platform = platform
            self.__platform = platform
        else:
            logging.error(f"ERROR: Platform {platform} is not supported")
            sys.exit()

    def set_tool_urls_and_paths(self):
        # URLs and paths for all tools, platform-dependent
        p = self.platform
        t = self.tools_folder_path
        r = self.silabs_chip_root
        if p == "win32":
            self.arm_toolchain_url = "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-mingw-w64-i686-arm-none-eabi.zip?rev=709f3f15b2ee4763b186c10153ee6ca9&hash=8C0761A17A1E4861B96DDB604C177F5B"
            self.java_url = "https://corretto.aws/downloads/resources/21.0.7.6.1/amazon-corretto-21.0.7.6.1-windows-x64-jdk.zip"
            self.commander_path = os.path.join(t, "SimplicityCommander-Windows")
            self.os_name_commander = "Commander_win32"
            self.java_path = os.path.join(r, "slc", "tools", "jdk21.0.7_6")
            self.arm_gcc_dir = os.path.join(t, "gcc")
            self.arm_gcc_download_dir = os.path.join(t, "arm-gnu-toolchain-12.2.rel1-mingw-w64-i686-arm-none-eabi")
            self.ninja_path = os.path.join(t, "ninja", "ninja.exe")
        elif p == "darwin":
            self.arm_toolchain_url = "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-darwin-arm64-arm-none-eabi.tar.xz?rev=41f9ad86e18d43cf9999c4bada07f7df&hash=C458A8BF74CBA545BDCA38B7FB40AAF5"
            self.java_url = "https://corretto.aws/downloads/resources/21.0.7.6.1/amazon-corretto-21.0.7.6.1-macosx-x64.tar.gz"
            self.commander_path = os.path.join(t, "SimplicityCommander-Mac")
            self.os_name_commander = "Commander_osx"
            self.commander_app_path = os.path.join(self.commander_path, "Commander.app", "Contents", "MacOS")
            self.java_path = os.path.join(r, "slc", "tools", "amazon-corretto-21.jdk")
            self.arm_gcc_dir = os.path.join(t, "arm-gnu-toolchain-12.2.rel1-darwin-arm64-arm-none-eabi")
            self.ninja_path = os.path.join(t, "ninja", "ninja")
        elif p == "linux":
            self.arm_toolchain_url = "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz?rev=7bd049b7a3034e64885fa1a71c12f91d&hash=732D909FA8F68C0E1D0D17D08E057619"
            self.java_url = "https://corretto.aws/downloads/resources/21.0.7.6.1/amazon-corretto-21.0.7.6.1-linux-x64.tar.gz"
            self.commander_path = os.path.join(t, "SimplicityCommander-Linux")
            self.os_name_commander = "Commander_linux_x86_64"
            self.java_path = os.path.join(r, "slc", "tools", "amazon-corretto-21.0.7.6.1-linux-x64")
            self.commander_app_path = os.path.join(self.commander_path, "commander")
            self.arm_gcc_dir = os.path.join(t, "arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi")
            self.ninja_path = os.path.join(t, "ninja", "ninja")

        self.sisdk_root = os.path.join(r, "third_party", "simplicity_sdk")
        self.wifi_sdk_path = os.path.join(r, "third_party", "wifi_sdk")
        self.slc_cli_path = os.path.join(r, "slc", "tools", "slc_cli")
        self.zap_path = os.path.join(r, "slc", "tools", "zap")
        self.arm_toolchain_path = os.path.join(self.arm_gcc_dir, "bin")

    def download_and_extract_arm_toolchain(self):
        if not os.path.isfile(os.path.join(self.arm_toolchain_path, "arm-none-eabi-gcc")) and not os.path.isfile(os.path.join(self.arm_toolchain_path, "arm-none-eabi-gcc.exe")):
            logging.info("Downloading and unzipping arm-none-eabi-gcc ...")
            if self.platform == "win32":
                gcc_zip_path = os.path.join(self.tools_folder_path, "gcc.zip")
                dload.save(self.arm_toolchain_url, gcc_zip_path)
                with ZipFile(gcc_zip_path, 'r') as zObject:
                    zObject.extractall(path=self.tools_folder_path)
                os.remove(gcc_zip_path)
                os.chmod(self.arm_gcc_download_dir, stat.S_IEXEC)
                os.rename(self.arm_gcc_download_dir, os.path.join(self.tools_folder_path, "gcc"))
            else:
                dload.save(self.arm_toolchain_url, os.path.join(self.tools_folder_path, "gcc.tar.xz"))
                tar = tarfile.open(os.path.join(self.tools_folder_path, "gcc.tar.xz"), "r:xz")
                tar.extractall(path=self.tools_folder_path)
                tar.close()
                os.remove(os.path.join(self.tools_folder_path, "gcc.tar.xz"))
        else:
            logging.info("arm-none-eabi-gcc already installed")

    def download_and_extract_java(self):
        if not os.path.isdir(self.java_path):
            logging.info("Downloading and unzipping java ...")
            if self.platform == "win32":
                dload.save(self.java_url, os.path.join(self.tools_folder_path, "java.zip"))
                with ZipFile(os.path.join(self.tools_folder_path, "java.zip"), 'r') as zObject:
                    zObject.extractall(path=self.tools_folder_path)
                os.remove(os.path.join(self.tools_folder_path, "java.zip"))
            else:
                dload.save(self.java_url, os.path.join(self.tools_folder_path, "java.tar.gz"))
                tar = tarfile.open(os.path.join(self.tools_folder_path, "java.tar.gz"), "r:gz")
                tar.extractall(path=self.tools_folder_path)
                tar.close()
                os.remove(os.path.join(self.tools_folder_path, "java.tar.gz"))
        else:
            logging.info("java already installed")

    def download_and_extract_slc_cli(self):
        if not os.path.isfile(os.path.join(self.slc_cli_path, "slc")):
            logging.info("Downloading and unzipping slc_cli ...")
            slc_cli_url = f"https://www.silabs.com/documents/login/software/slc_cli_{self.__platform}.zip"
            dload.save_unzip(slc_cli_url, self.tools_folder_path, delete_after=True)
            st = os.stat(os.path.join(self.tools_folder_path, "slc_cli", "slc"))
            os.chmod(os.path.join(self.tools_folder_path, "slc_cli", "slc"), st.st_mode | stat.S_IEXEC)
            if self.platform == "darwin":
                st = os.stat(os.path.join(self.tools_folder_path, "slc_cli", "bin", "slc-cli", "slc-cli.app", "Contents", "MacOS", "slc-cli"))
                os.chmod(os.path.join(self.tools_folder_path, "slc_cli", "bin", "slc-cli", "slc-cli.app", "Contents", "MacOS", "slc-cli"), st.st_mode | stat.S_IEXEC)
            elif self.platform == "linux":
                st = os.stat(os.path.join(self.tools_folder_path, "slc_cli", "bin", "slc-cli", "slc-cli"))
                os.chmod(os.path.join(self.tools_folder_path, "slc_cli", "bin", "slc-cli", "slc-cli"), st.st_mode | stat.S_IEXEC)
        else:
            logging.info("slc_cli already installed")

    def download_and_extract_zap(self, install_without_checking=False):
        zap_url = f"https://github.com/project-chip/zap/releases/download/{self.MINIMUM_ZAP_REQUIRED}/zap-{self._platform}-x64.zip"
        if (not os.path.isfile(os.path.join(self.zap_path, "zap-cli")) and not os.path.isfile(os.path.join(self.zap_path, "zap.exe"))) or install_without_checking:
            logging.info("Downloading and unzipping zap ...")
            if self.platform == "darwin":
                dload.save(zap_url, self.zap_path + ".zip")
                command = f"unzip {self.zap_path}.zip -d {self.zap_path}"
                os.system(f"{command} > /dev/null 2>&1")
                os.remove(self.zap_path + ".zip")
                st = os.stat(os.path.join(self.zap_path, "zap-cli"))
                os.chmod(os.path.join(self.zap_path, "zap-cli"), st.st_mode | stat.S_IEXEC)
                zap_root = os.path.join(self.zap_path, "zap.app", "Contents", "MacOS", "zap")
                st = os.stat(zap_root)
                os.chmod(zap_root, st.st_mode | stat.S_IEXEC)
            elif self.platform == "linux":
                dload.save_unzip(zap_url, os.path.join(self.tools_folder_path, "zap"), delete_after=True)
                st = os.stat(os.path.join(self.tools_folder_path, "zap", "zap-cli"))
                os.chmod(os.path.join(self.tools_folder_path, "zap", "zap-cli"), st.st_mode | stat.S_IEXEC)
                st = os.stat(os.path.join(self.tools_folder_path, "zap", "zap"))
                os.chmod(os.path.join(self.tools_folder_path, "zap", "zap"), st.st_mode | stat.S_IEXEC)
            elif self.platform == "win32":
                dload.save_unzip(zap_url, os.path.join(self.tools_folder_path, "zap"), delete_after=True)
        else:
            logging.info("zap already installed")

    def check_and_update_zap_version(self):
        zap = os.path.join(self.zap_path, "zap-cli")
        command = f"{zap} --version"
        output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, universal_newlines=True)
        installed_zap_version = re.search(r"Version:\s*([\d.]+)", output).group(1)
        min_zap = self.MINIMUM_ZAP_REQUIRED.replace("v", "").replace("-nightly", "")
        date_format = "%Y.%m.%d"
        installed_zap_version = datetime.strptime(installed_zap_version, date_format)
        min_zap = datetime.strptime(min_zap, date_format)
        if installed_zap_version < min_zap:
            logging.warning(f"Installed zap version is {installed_zap_version} which is less than Minimum Required level of {min_zap}")
            try:
                logging.info(f"Deleting old version of zap located at {self.zap_path}")
                shutil.rmtree(self.zap_path)
                self.download_and_extract_zap(True)
            except Exception as e:
                logging.error(f"Error while deleting zap located at {self.zap_path}: {e}\nUsing older version of zap may lead to errors.")

    def download_and_extract_commander(self):
        commander_url = f"https://www.silabs.com/documents/public/software/SimplicityCommander-{self.__platform.capitalize()}.zip"
        if not (os.path.isfile(os.path.join(self.commander_path, "Commander.app", "Contents", "MacOS", "commander")) or \
                os.path.isfile(os.path.join(self.commander_path, "Simplicity Commander", "commander.exe")) or \
                os.path.isfile(os.path.join(self.commander_path, "commander", "commander"))):
            logging.info("Downloading and unzipping Simplicity Commander ...")
            dload.save_unzip(commander_url, self.tools_folder_path, delete_after=True)
            commander_zip = None
            for filename in os.listdir(self.commander_path):
                if self.os_name_commander in filename:
                    commander_zip = os.path.join(self.commander_path, filename)
                    break
            if not commander_zip:
                logging.error("Cannot find Simplicity Commander ...")
                sys.exit(1)
            if self.platform == "darwin":
                command = f"unzip {commander_zip} -d {self.commander_path}"
                os.system(f"{command} > /dev/null 2>&1")
                os.remove(commander_zip)
            elif self.platform == "win32":
                with ZipFile(commander_zip, 'r') as zObject:
                    zObject.extractall(path=self.commander_path)
                os.remove(commander_zip)
            elif self.platform == "linux":
                tar = tarfile.open(commander_zip, "r:bz2")
                tar.extractall(path=self.commander_path)
                tar.close()
                os.remove(commander_zip)
        else:
            logging.info("Simplicity Commander already installed")

    def download_and_extract_ninja(self):
        ninja_url = f"https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-{self._platform}.zip"
        try:
            if not os.path.isfile(self.ninja_path):
                logging.info("Downloading and unzipping ninja ...")
                dload.save_unzip(ninja_url, os.path.join(self.tools_folder_path, "ninja"), delete_after=True)
            else:
                logging.info("ninja already installed")
            logging.info(f"For Visual Studio Code and CMAKE based builds please add '{self.ninja_path}' as NINJA_EXE_PATH environment variable\n ")
        except Exception as e:
            logging.error(f"============Could not install ninja!!============ {e}")

    def create_symlink(self, target, link_name):
        try:
            if not os.path.islink(link_name):
                os.symlink(target, link_name)
        except Exception as e:
            logging.error(e)
            logging.error(f"Cannot create symbolic link for {link_name}")
            sys.exit(1)

    def create_extension_symlinks(self):
        extension_dir = os.path.join(self.sisdk_root, "extension")
        if not os.path.exists(extension_dir):
            os.makedirs(extension_dir)
        matter_root = os.path.join(extension_dir, "matter_extension")
        wiseconnect_root = os.path.join(extension_dir, "wiseconnect")
        logging.info("Creating symbolic links for matter_extension and wiseconnect")
        self.create_symlink(self.silabs_chip_root, matter_root)
        self.create_symlink(self.wifi_sdk_path, wiseconnect_root)
        logging.info("Symbolic links created successfully\n")
        self.matter_root = matter_root
        self.wiseconnect_root = wiseconnect_root

    def write_env_file(self):
        if self.platform == "darwin":
            env_path = os.path.expanduser("slc/tools/.env")
            with open(env_path, "w") as outfile:
                outfile.write(f"STUDIO_ADAPTER_PACK_PATH={self.zap_path}\n")
                outfile.write(f"POST_BUILD_EXE={os.path.join(self.commander_app_path, 'commander')}\n")
                outfile.write(f"ARM_GCC_DIR={self.arm_gcc_dir}\n")
                outfile.write(f"JAVA17_HOME={os.path.join(self.java_path, 'Contents', 'Home')}\n")
                outfile.write(f"ZAP_INSTALL_PATH={self.zap_path}\n")
                outfile.write(f"TOOLS_PATH={self.arm_toolchain_path}:{self.slc_cli_path}:{os.path.join(self.java_path, 'Contents', 'Home', 'bin')}:{self.commander_app_path}:\n")
                outfile.write(f"silabs_chip_root={self.matter_root}\n")
                outfile.write(f"NINJA_EXE_PATH={self.ninja_path}\n")
                outfile.write(f"SISDK_ROOT={self.sisdk_root}\n")
                outfile.write(f"WISECONNECT_ROOT={self.wiseconnect_root}\n")
        elif self.platform == "win32":
            env_path = os.path.expanduser(os.path.join(self.tools_folder_path, ".env"))
            with open(env_path, "w") as outfile:
                outfile.write(f'STUDIO_ADAPTER_PACK_PATH={self.zap_path}\n')
                outfile.write(f'POST_BUILD_EXE={os.path.join(self.commander_path, "Simplicity Commander", "commander.exe")}\n')
                outfile.write(f'ARM_GCC_DIR={self.arm_gcc_dir}\n')
                outfile.write(f'JAVA17_HOME={self.java_path}\n')
                outfile.write('ZAP_INSTALL_PATH='+self.zap_path.replace("\\", "/")+'\n')
                outfile.write(f'TOOLS_PATH={self.slc_cli_path};{self.zap_path};{self.arm_toolchain_path};{self.java_path}\\bin;\n')
                outfile.write(f'SLC={self.slc_cli_path}\n')
                outfile.write(f'silabs_chip_root={self.matter_root}\n')
                outfile.write(f'NINJA_EXE_PATH={self.ninja_path}\n')
                outfile.write(f'SISDK_ROOT={self.sisdk_root}\n')
                outfile.write(f'WISECONNECT_ROOT={self.wiseconnect_root}\n')
        elif self.platform == "linux":
            env_path = os.path.expanduser("slc/tools/.env")
            with open(env_path, "w") as outfile:
                outfile.write(f"STUDIO_ADAPTER_PACK_PATH={self.zap_path}\n")
                outfile.write(f"POST_BUILD_EXE={os.path.join(self.commander_app_path, 'commander')}\n")
                outfile.write(f"ARM_GCC_DIR={self.arm_gcc_dir}\n")
                outfile.write(f"JAVA17_HOME={self.java_path}\n")
                outfile.write(f"ZAP_INSTALL_PATH={self.zap_path}\n")
                outfile.write(f"TOOLS_PATH={self.arm_toolchain_path}:{self.slc_cli_path}:{os.path.join(self.java_path, 'bin')}:{self.commander_app_path}\n")
                outfile.write(f"silabs_chip_root={self.matter_root}\n")
                outfile.write(f"NINJA_EXE_PATH={self.ninja_path}\n")
                outfile.write(f"SISDK_ROOT={self.sisdk_root}\n")
                outfile.write(f"WISECONNECT_ROOT={self.wiseconnect_root}\n")

    def trust_extensions(self):
        App = createApp()
        with open(os.path.expanduser(os.path.join(self.tools_folder_path, "environment_variables_vscode.txt")), "w") as outfile:
            outfile.write(f"POST_BUILD_EXE = {App.POST_BUILD_EXE}\n")
            outfile.write(f"NINJA_EXE_PATH = {App.NINJA_EXE_PATH}\n")
            logging.info("Trust SDK and extensions")
            App.slc_trust()
            logging.info("Trust completed successfully")
            logging.info("\nEnvironment setup completed successfully")

    def run_setup(self):
        self.sync_submodules()
        self.download_and_extract_arm_toolchain()
        self.download_and_extract_java()
        self.download_and_extract_slc_cli()
        self.download_and_extract_zap()
        self.check_and_update_zap_version()
        self.download_and_extract_commander()
        self.download_and_extract_ninja()
        self.create_extension_symlinks()
        self.write_env_file()
        self.trust_extensions()


def main():
    parser = argparse.ArgumentParser(description="Setup environment for Matter project using Silicon Labs Configurator.")
    parser.add_argument('--verbose', action='store_true', help='Enable verbose (debug) logging')
    args = parser.parse_args()
    env_setup = MatterEnvSetup(verbose=args.verbose)
    env_setup.run_setup()

if __name__ == "__main__":
    main()