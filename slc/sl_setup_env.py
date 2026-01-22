#!/usr/bin/env python3

"""
 * @file sl_setup_env.py
 * @brief Environment setup script for Matter project using Silicon Labs Configurator.
 *
 * This script installs and configures the required tools to create a Matter project
 * using Silicon Labs Configurator (SLC). It automates the setup of the development
 * environment and generates a .env file with all necessary environment variables.
 *
 * @section tools_installed Tools Installed
 *   - ARM GCC Toolchain (gcc-arm-none-eabi)
 *   - SLC CLI (Silicon Labs Configurator Command Line Interface)
 *   - ZAP (Zigbee Cluster Library Application Framework)
 *   - Java 21 Runtime Environment
 *   - Ninja Build System
 *   - Simplicity Commander
 *   - SLT CLI (Silicon Labs Tools Command Line Interface)
 *
 * @section usage Usage
 *   @code{.sh}
 *   python3 sl_setup_env.py [--verbose]
 *   @endcode
 *
 * @section options Options
 *   - `--verbose` : Enable verbose (debug) logging output
 *
 * @section output Output
 *   Generates a `.env` file in `slc/tools/` containing all required environment
 *   variables for the build system and tool configuration.
 *
 * @note Requires Python 3.9 or higher
 * @note This script should be run from the root of the Matter SDK directory
 """

import argparse
import logging
import os
import sys
import dload
import stat
import subprocess
import shutil
import re
from datetime import datetime
from zipfile import ZipFile
from pathlib import Path
from script.get_zap_version import get_zap_version



if sys.version_info < (3, 9):
    logging.error("This script requires Python 3.9 or higher!")
    sys.exit(1)


# Full refactor: encapsulate all setup steps in MatterEnvSetup class
class MatterEnvSetup:
    """Class for setting up the Matter development environment with all required tools."""

    def __init__(self, verbose=False):
        """Initialize MatterEnvSetup instance.

        Args:
            verbose: Enable verbose (debug) logging if True
        """
        self.verbose = verbose
        self.setup_logging()
        self.set_root_paths()
        self.set_platform_vars()
        self.MINIMUM_ZAP_REQUIRED = get_zap_version()

    def setup_logging(self):
        """Configure logging level and format based on verbosity setting."""
        level = logging.DEBUG if self.verbose else logging.INFO
        logging.basicConfig(level=level, format='[%(levelname)s] %(message)s')

    def set_root_paths(self):
        """Set root paths for Matter SDK and tools directory."""
        if "SILABS_MATTER_ROOT" not in os.environ:
            logging.info("Using default path for Matter root")
            self.silabs_chip_root = str(Path(__file__).resolve().parents[1])
        else:
            logging.info("Using ENV path for Matter root")
            self.silabs_chip_root = os.environ["SILABS_MATTER_ROOT"]
        self.tools_folder_path = os.path.join(self.silabs_chip_root, "slc", "tools")
        os.makedirs(self.tools_folder_path, exist_ok=True)

    def sync_submodules(self):
        """Sync and initialize Git submodules."""
        logging.info("Syncing and checking out submodules")
        try:
            subprocess.run(["git", "submodule", "sync"], check=True)
            subprocess.run(["git", "submodule", "update", "--init"], check=True)
        except subprocess.CalledProcessError as e:
            logging.error(f"Cannot checkout submodules: {e}")
            sys.exit(1)
        logging.info("Submodules checked out successfully")

    def set_platform_vars(self):
        """Set platform-specific variables and URLs for tool downloads."""
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
            sys.exit(1)
        self.slt_cli_url = f"https://www.silabs.com/documents/public/software/slt-cli-1.0.1-{self.__platform}-x64.zip"
        if platform == "win32":
            self.slt_cli_path = os.path.join(self.tools_folder_path, "slt.exe")
        else:
            self.slt_cli_path = os.path.join(self.tools_folder_path, "slt")
        self.sisdk_root = os.path.join(self.silabs_chip_root, "third_party", "simplicity_sdk")
        self.wiseconnect_root = os.path.join(self.silabs_chip_root, "third_party", "wifi_sdk")
        self.zap_path = os.path.join(self.silabs_chip_root, "slc", "tools", "zap")

    def download_and_extract_slt_cli(self):
        """Download and extract SLT CLI tool."""
        if not os.path.isfile(self.slt_cli_path):
            logging.info(f"Downloading and unzipping slt-cli...")
            slt_zip_path = os.path.join(self.tools_folder_path, "slt.zip")
            try:
                dload.save(self.slt_cli_url, slt_zip_path)
                with ZipFile(slt_zip_path, 'r') as zObject:
                    zObject.extractall(path=self.tools_folder_path)
                os.remove(slt_zip_path)
                if self.platform != "win32":
                    self._make_executable(self.slt_cli_path)
            except Exception as e:
                logging.error(f"Failed to download/extract slt-cli: {e}")
                sys.exit(1)

        update_cmd = [self.slt_cli_path, "update", "--self"]
        try:
            subprocess.run(update_cmd, check=True)
        except subprocess.CalledProcessError as e:
            logging.warning(f"Failed to update slt-cli: {e}")

    def download_and_extract_zap(self, install_without_checking=False):
        """Download and extract ZAP tool.

        Args:
            install_without_checking: Force download even if tool exists
        """
        # Using Non-SLT zap as we often need newer zap than the one from SLT
        zap_url = f"https://github.com/project-chip/zap/releases/download/{self.MINIMUM_ZAP_REQUIRED}/zap-{self._platform}-x64.zip"
        zap_cli_path = os.path.join(self.zap_path, "zap-cli")
        zap_exe_path = os.path.join(self.zap_path, "zap.exe")

        if (not os.path.isfile(zap_cli_path) and not os.path.isfile(zap_exe_path)) or install_without_checking:
            logging.info("Downloading and unzipping zap ...")
            try:
                if self.platform == "darwin":
                    zap_zip = self.zap_path + ".zip"
                    dload.save(zap_url, zap_zip)
                    subprocess.run(["unzip", zap_zip, "-d", self.zap_path], check=True)
                    os.remove(zap_zip)
                    self._make_executable(zap_cli_path)
                    zap_root = os.path.join(self.zap_path, "zap.app", "Contents", "MacOS", "zap")
                    self._make_executable(zap_root)
                elif self.platform == "linux":
                    dload.save_unzip(zap_url, os.path.join(self.tools_folder_path, "zap"), delete_after=True)
                    self._make_executable(zap_cli_path)
                    self._make_executable(os.path.join(self.tools_folder_path, "zap", "zap"))
                elif self.platform == "win32":
                    dload.save_unzip(zap_url, os.path.join(self.tools_folder_path, "zap"), delete_after=True)
            except Exception as e:
                logging.error(f"Failed to download/extract zap: {e}")
                sys.exit(1)
        else:
            logging.info("zap already installed")

    def check_and_update_zap_version(self):
        """Check installed ZAP version and update if necessary."""
        zap = os.path.join(self.zap_path, "zap-cli")
        try:
            output = subprocess.check_output([zap, "--version"], stderr=subprocess.STDOUT, universal_newlines=True)
        except (subprocess.CalledProcessError, FileNotFoundError) as e:
            logging.error(f"Failed to get zap version: {e}")
            return

        match = re.search(r"Version:\s*([\d.]+)", output)
        if not match:
            logging.warning("Could not parse zap version from output")
            return

        installed_zap_version_str = match.group(1)
        min_zap = self.MINIMUM_ZAP_REQUIRED.replace("v", "").replace("-nightly", "")
        date_format = "%Y.%m.%d"

        try:
            installed_zap_version = datetime.strptime(installed_zap_version_str, date_format)
            min_zap_version = datetime.strptime(min_zap, date_format)
        except ValueError as e:
            logging.warning(f"Could not parse version dates: {e}")
            return

        if installed_zap_version < min_zap_version:
            logging.warning(
                f"Installed zap version is {installed_zap_version} which is less than Minimum Required level of {min_zap_version}")
            try:
                logging.info(f"Deleting old version of zap located at {self.zap_path}")
                shutil.rmtree(self.zap_path)
                self.download_and_extract_zap(True)
            except Exception as e:
                logging.error(
                    f"Error while deleting zap located at {self.zap_path}: {e}. Using older version of zap may lead to errors.")

    def write_env_file(self):
        """Write environment variables to .env file."""
        env_path = os.path.expanduser(os.path.join(self.tools_folder_path, ".env"))

        # Validate paths exist
        for tool, path in self.paths.items():
            if not path or not os.path.exists(path):
                logging.error(f"Tool path for {tool} is invalid or does not exist: {path}")
                sys.exit(1)

        arm_gcc_bin = os.path.join(self.paths.get('gcc-arm-none-eabi'), "bin")
        path_separator = ";" if self.platform == "win32" else ":"

        if self.platform == "darwin":
            java_path = os.path.join(self.paths.get('java21'), "jre", "Contents", "Home")
            commander_path = os.path.join(self.paths.get('commander'), "Contents", "MacOS")
        else:
            java_path = os.path.join(self.paths.get('java21'), "jre")
            commander_path = self.paths.get('commander')

        if self.platform == "win32":
            slc_executable = "slc.bat"
            ninja_executable = "ninja.exe"
            commander_executable = "commander.exe"
            ninja_path = os.path.join(self.paths.get('ninja'), ninja_executable)
        else:
            slc_executable = "slc"
            ninja_executable = "ninja"
            commander_executable = "commander"
            ninja_path = ninja_executable

        cmake_bin = os.path.join(self.paths.get('cmake'), "bin")

        try:
            with open(env_path, "w") as outfile:
                outfile.write(f"STUDIO_ADAPTER_PACK_PATH={self.zap_path}\n")
                outfile.write(f"ARM_GCC_DIR={self.paths.get('gcc-arm-none-eabi')}\n")
                outfile.write(f"JAVA_HOME={java_path}\n")
                outfile.write(f"ZAP_INSTALL_PATH={self.zap_path}\n")
                outfile.write(
                    f"TOOLS_PATH={arm_gcc_bin}{path_separator}{self.paths.get('slc-cli')}{path_separator}{os.path.join(java_path, 'bin')}{path_separator}{commander_path}{path_separator}{self.paths.get('ninja')}{path_separator}{cmake_bin}{path_separator}\n")
                outfile.write(f"silabs_chip_root={self.silabs_chip_root}\n")
                outfile.write(f"NINJA_PATH={ninja_path}\n")
                outfile.write(f"SISDK_ROOT={self.sisdk_root}\n")
                outfile.write(f"WISECONNECT_ROOT={self.wiseconnect_root}\n")
                outfile.write(f"SLC_EXECUTABLE={slc_executable}\n")
                outfile.write(f"COMMANDER_EXECUTABLE={commander_executable}\n")
                outfile.write(f"POST_BUILD_EXE={commander_executable}\n")
            logging.info(f"Environment file written to {env_path}")
        except IOError as e:
            logging.error(f"Failed to write environment file: {e}")
            sys.exit(1)

    def install_tools(self, tool):
        """Install and locate a specific tool.

        Args:
            tool: Tool name to install

        Returns:
            str: Path to installed tool

        Raises:
            SystemExit: If tool installation fails
        """
        try:
            result = subprocess.run([self.slt_cli_path, "where", tool], capture_output=True, text=True, check=True)
            tool_dir = result.stdout.strip()
        except subprocess.CalledProcessError as e:
            logging.error(f"Failed to query tool location for {tool}: {e}")
            sys.exit(1)

        if not tool_dir:
            logging.info(f"Downloading {tool}")
            try:
                subprocess.run([self.slt_cli_path, "install", tool], check=True)
                result = subprocess.run([self.slt_cli_path, "where", tool], capture_output=True, text=True, check=True)
                tool_dir = result.stdout.strip()
            except subprocess.CalledProcessError as e:
                logging.error(f"Failed to install {tool}: {e}")
                sys.exit(1)

        logging.info(f"{tool} = {tool_dir}")
        return tool_dir

    def _make_executable(self, path):
        """Make a file executable on Unix-like systems."""
        if path and os.path.exists(path):
            try:
                st = os.stat(path)
                os.chmod(path, st.st_mode | stat.S_IEXEC)
            except OSError as e:
                logging.warning(f"Could not make {path} executable: {e}")
        else:
            logging.warning(f"Path {path} does not exist to make executable.")
    
    def setup_tools(self):
        """Install and configure all required development tools."""
        tools_list = ["slc-cli", "java21", "gcc-arm-none-eabi", "commander", "ninja", "cmake"]
        self.paths = {}
        for tool in tools_list:
            self.paths[tool] = self.install_tools(tool)
        if self.platform == "darwin":
            self._make_executable(os.path.join(self.paths.get('ninja'), "ninja"))
            self._make_executable(os.path.join(self.paths.get('java21'), "jre", "Contents", "Home", "bin", "java"))
        self.download_and_extract_zap()
        self.check_and_update_zap_version()

    def run_setup(self):
        """Execute the complete environment setup process."""
        self.sync_submodules()
        self.download_and_extract_slt_cli()
        self.setup_tools()
        self.write_env_file()
        logging.info("\nEnvironment setup completed successfully")

def main():
    parser = argparse.ArgumentParser(description="Setup environment for Matter project using Silicon Labs Configurator.")
    parser.add_argument('--verbose', action='store_true', help='Enable verbose (debug) logging')
    args = parser.parse_args()
    env_setup = MatterEnvSetup(verbose=args.verbose)
    env_setup.run_setup()


if __name__ == "__main__":
    main()
