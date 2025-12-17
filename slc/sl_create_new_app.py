
#!/usr/bin/env python3

"""
 * @file sl_create_new_app.py
 * @brief Create a new Matter application from a reference project file.
 * This script generates a new Matter application directory using a reference .slcp or .slcw project file
 * and a Silicon Labs board name. It sets up environment variables
 * and ensures all required trust and configuration steps are performed for the new app.

 * Recommended usage (flags):
 *   python3 sl_create_new_app.py \
 *       --new_app_name <NewAppName> \
 *       --reference_project_file <PathToReferenceProjectFile(.slcp or .slcw)> \
 *       --silabs_board <SilabsBoard> \
 *       [--build_type <makefile|cmake|vscode>] [--verbose]

 * Note: Positional arguments for new_app_name, reference_project_file and silabs_board
 * are deprecated and will be removed in a future release. Use the flag-based
 * form shown above instead.

 """

import argparse
import json
import logging
import os
import re
import subprocess
import sys
from pathlib import Path

import shutil
import yaml
from dotenv import load_dotenv

class CreateApp:
    """Class for creating new Matter applications from reference projects."""

    def __init__(self, build_type="cmake"):
        """Initialize CreateApp instance.

        Args:
            build_type: Build system type to generate (makefile, cmake, vscode)
        """
        self.EXAMPLE_USAGE = (
            "python slc/sl_create_new_app.py "
            "--new_app_name <NewAppName> "
            "--reference_project_file <PathToReferenceProjectFile(.slcp or .slcw)> "
            "--silabs_board <SilabsBoard> "
            "[--build_type <makefile|cmake|vscode>]"
        )
        # Supported build types: makefile, cmake, vscode
        self.build_type = build_type
        self.get_environment()

    def print_usage_and_exit(self):
        """Print usage information and exit with error code."""
        logging.info(f"Example usage: {self.EXAMPLE_USAGE}")
        sys.exit(1)

    def extract_from_slcp(self, app_slcp_full_path):
        """Extract source, include paths and project name from a .slcp file."""
        src_paths = []
        include_paths = []
        project_name = None
        try:
            with open(app_slcp_full_path, 'r') as f:
                doc = yaml.safe_load(f)
            # Parse project_name
            if 'project_name' in doc:
                project_name = doc['project_name']
            # Extract 'source' paths
            if 'source' in doc:
                for entry in doc['source']:
                    if isinstance(entry, dict) and 'path' in entry:
                        src_paths.append(entry['path'])
            # Extract 'include' file_list paths, prepending the parent include path
            if 'include' in doc:
                for entry in doc['include']:
                    if isinstance(entry, dict):
                        include_base = entry.get('path', '')
                        if 'file_list' in entry and isinstance(entry['file_list'], list):
                            for file_entry in entry['file_list']:
                                if isinstance(file_entry, dict) and 'path' in file_entry:
                                    file_path = file_entry['path']
                                    if include_base and not file_path.startswith(include_base):
                                        file_path = os.path.join(include_base, file_path)
                                    include_paths.append(file_path)
            return src_paths, include_paths, project_name
        except (IOError, yaml.YAMLError) as e:
            logging.error(f"Failed to extract from slcp: {e}")
            return [], [], None

    def trim_to_str(self, path, substr):
        """Keep only the paths starting from a specific substring."""
        idx = path.find(substr)
        return path[idx:] if idx != -1 else path

    def extract_and_save_paths(self):
        """Extract paths from .slcp and save to JSON file."""
        self.app_slcp_full_path = self.get_project_name_from_slcp()
        matter_sdk_src, matter_sdk_inc, project_name = self.extract_from_slcp(self.app_slcp_full_path)

        if self.use_solutions:
            self.sample_app_out_path = os.path.join(self.new_app_name, project_name)
        else:
            self.sample_app_out_path = self.new_app_name

        # Copy the folder self.sample_app_out_path/src to .bak/original/src/
        try:
            src_dir = os.path.join(self.sample_app_out_path, 'src')
            dest_dir = os.path.join(self.sample_app_out_path, '.bak', 'original', 'src')
            if os.path.exists(src_dir):
                shutil.copytree(src_dir, dest_dir, dirs_exist_ok=True)
                logging.info(f"Copied {src_dir} to {dest_dir}")
            else:
                logging.warning(f"Source directory {src_dir} does not exist, skipping copy.")
        except OSError as e:
            logging.error(f"Failed to copy src directory: {e}")
            sys.exit(1)

        # Copy the folder self.sample_app_out_path/include to .bak/original/include/
        try:
            include_dir = os.path.join(self.sample_app_out_path, 'include')
            dest_include_dir = os.path.join(self.sample_app_out_path, '.bak', 'original', 'include')
            if os.path.exists(include_dir):
                shutil.copytree(include_dir, dest_include_dir, dirs_exist_ok=True)
                logging.info(f"Copied {include_dir} to {dest_include_dir}")
            else:
                logging.warning(f"Include directory {include_dir} does not exist, skipping copy.")
        except OSError as e:
            logging.error(f"Failed to copy include directory: {e}")
            sys.exit(1)

        trimmed_src_paths = [self.trim_to_str(p, 'third_party') for p in matter_sdk_src]
        trimmed_inc_paths = [self.trim_to_str(p, 'third_party') for p in matter_sdk_inc]
        customer_src = [os.path.join(self.sample_app_out_path, 'src', os.path.basename(p)) for p in trimmed_src_paths]
        customer_inc = [os.path.join(self.sample_app_out_path, 'include', os.path.basename(p)) for p in trimmed_inc_paths]
        upgrade_src_dir = os.path.join(self.sample_app_out_path, '.bak', 'original', 'src')
        upgrade_inc_dir = os.path.join(self.sample_app_out_path, '.bak', 'original', 'include')
        upgrade_src = []
        upgrade_inc = []
        if os.path.exists(upgrade_src_dir):
            for fname in os.listdir(upgrade_src_dir):
                fpath = os.path.join(upgrade_src_dir, fname)
                if os.path.isfile(fpath):
                    upgrade_src.append(fpath)
        if os.path.exists(upgrade_inc_dir):
            for fname in os.listdir(upgrade_inc_dir):
                fpath = os.path.join(upgrade_inc_dir, fname)
                if os.path.isfile(fpath):
                    upgrade_inc.append(fpath)
        output_data = {
            'matter_sdk_paths': {
                'source': trimmed_src_paths,
                'include': trimmed_inc_paths
            },
            'customer_paths': {
                'source': customer_src,
                'include': customer_inc
            },
            'backups_paths': {
                'source': upgrade_src,
                'include': upgrade_inc
            }
        }
        output_file_json = os.path.join(self.sample_app_out_path, '.bak', 'source_and_include_paths.json')
        os.makedirs(self.sample_app_out_path, exist_ok=True)
        try:
            with open(output_file_json, 'w') as out_json:
                json.dump(output_data, out_json, indent=2)
            logging.info(f"Saved source and include paths to {output_file_json}")
        except IOError as e:
            logging.error(f"Failed to write paths file: {e}")
            sys.exit(1)
        
    def get_project_name_from_slcp(self):
        """Extract project name from .slcp or .slcw file."""
        # If .slcp, extract directly; if .slcw, find application .slcp and extract from that
        if not self.use_solutions:
            return self.reference_project_file
        else:
            try:
                with open(self.reference_project_file, 'r') as f:
                    doc = yaml.safe_load(f)
                app_slcp_path = None
                if 'project' in doc and isinstance(doc['project'], list):
                    for proj in doc['project']:
                        if isinstance(proj, dict) and proj.get('id') == 'application' and 'path' in proj:
                            app_slcp_path = proj['path']
                            break
                if app_slcp_path is None:
                    logging.error("No application project with .slcp path found in .slcw file.")
                    sys.exit(1)

                self.app_slcp_full_path = os.path.join(os.path.dirname(self.reference_project_file), app_slcp_path)
                if not os.path.exists(self.app_slcp_full_path):
                    logging.error(f"Application .slcp file does not exist: {self.app_slcp_full_path}")
                    sys.exit(1)

                return self.app_slcp_full_path
            except (IOError, yaml.YAMLError) as e:
                logging.error(f"Failed to parse .slcw file for application .slcp: {e}")
                sys.exit(1)

    @staticmethod
    def validate_tools():
        """Validate that all required build tools are available on the system.
        
        This validates all tools installed by sl_setup_env.py:
        - slc (Silicon Labs Configurator CLI)
        - arm-none-eabi-gcc (ARM GCC Toolchain)
        - ninja (Ninja build system)
        - commander (Simplicity Commander)
        - java (Java Runtime Environment)
        
        Raises:
            SystemExit: If any required tool is not found
        """
        slc_exe = os.getenv("SLC_EXECUTABLE", "slc")
        ninja_exe = os.getenv("NINJA_EXECUTABLE", "ninja") 
        commander_exe = os.getenv("COMMANDER_EXECUTABLE", "commander")
        
        tools = [
            (slc_exe, "slc not detected on host. Please run slc/sl_setup_env.py to install slc."),
            ("arm-none-eabi-gcc", "arm-none-eabi-gcc not detected on host. Please run slc/sl_setup_env.py to install arm gcc toolchain."),
            (ninja_exe, "ninja not detected on host. Please run slc/sl_setup_env.py to install ninja."),
            (commander_exe, "commander not detected on host. Please run slc/sl_setup_env.py to install Simplicity Commander."),
            ("java", "java not detected on host. Please run slc/sl_setup_env.py to install java21.")
        ]
        
        missing_tools = []
        for tool, error_msg in tools:
            if not shutil.which(tool):
                logging.error(error_msg)
                missing_tools.append(tool)
        
        if missing_tools:
            logging.error(f"Missing tools: {', '.join(missing_tools)}")
            sys.exit(1)
        
        logging.info(f"Required tools found: {', '.join([tool for tool, _ in tools])}")

    def validate_board_argument(self, board):
        """Validate board argument format.

        Args:
            board: Board identifier string

        Returns:
            True if valid, False otherwise
        """
        if not re.fullmatch(r"brd\d{4}[abc]", board, re.IGNORECASE):
            logging.error("The second positional argument (silabs_board) must be of the form 'brdXXXXY', where XXXX are digits and Y is a/b/c.")
            return False
        return True

    def validate_arguments(self):
        """Validate and parse command-line arguments.

        Raises:
            SystemExit: If validation fails
        """
        if len(sys.argv) < 4:
            logging.error("Missing arguments")
            self.print_usage_and_exit()

        self.new_app_name = sys.argv[1]
        self.reference_project_file = sys.argv[2]
        self.silabs_board = sys.argv[3].lower()
        self.use_solutions = False

        if not os.path.exists(self.reference_project_file):
            logging.error(f"ReferenceProject File does not exist: {self.reference_project_file}")
            sys.exit(1)

        if not self.reference_project_file.endswith('.slcp') and not self.reference_project_file.endswith('.slcw'):
            logging.error("ReferenceSlcp File should have a .slcp or .slcw extension")
            sys.exit(1)

        if not self.silabs_board:
            logging.error("Missing SilabsBoard argument")
            self.print_usage_and_exit()
        
        if self.reference_project_file.endswith(".slcw"):
            self.use_solutions = True

        if not self.validate_board_argument(self.silabs_board):
            sys.exit(1)

        # Checkout third_party_hw_drivers_extension submodule for air-quality-sensor-app-sparkfun-thread app and trust the extension
        if "sparkfun" in self.reference_project_file:
            third_party_hw_drivers_extension_path = os.path.join(os.getcwd(), "third_party", "third_party_hw_drivers_extension")
            try:
                subprocess.run(["git", "submodule", "update", "--init", "--checkout", third_party_hw_drivers_extension_path], check=True)
            except subprocess.CalledProcessError as e:
                logging.error(f"Failed to checkout submodule: {e}")
                sys.exit(1)

    def get_environment(self):
        """Load environment variables from .env file.

        Raises:
            SystemExit: If .env file cannot be loaded
        """
        try:
            env_path = os.path.join(os.getcwd(), "slc", "tools", ".env")
            load_dotenv(env_path, override=True)
            os.environ["PATH"] = os.getenv("TOOLS_PATH") + os.environ["PATH"]
            self.java_path = os.getenv("JAVA_HOME")
            self.silabs_chip_root = os.getenv("silabs_chip_root")
            self.POST_BUILD_EXE = os.getenv("POST_BUILD_EXE")
            self.NINJA_EXE_PATH = os.getenv("NINJA_EXE_PATH")
            self.sisdk_root = os.getenv("SISDK_ROOT")
            self.wiseconnect_root = os.getenv("WISECONNECT_ROOT")
            self.arm_toolchain_path = os.path.join(os.getenv("ARM_GCC_DIR"))

        except (TypeError, AttributeError) as e:
            logging.error(f"Could not load the .env file: {e}. Run sl_setup_env.py to generate .env file")
            sys.exit(1)

        self.slc_path = os.getenv("SLC_EXECUTABLE", "slc")

    def generate(self):
        """Generate a new Matter app from reference project.

        Raises:
            SystemExit: If generation fails
        """
        # Validate required tools are available
        self.validate_tools()
        # Use appropriate build flag for sample-app/solutions
        project_flag = "-p" if self.reference_project_file.endswith('.slcp') else "-w"
        # Map build_type to slc output option
        output_map = {
            "cmake": "cmake",
            "makefile": "makefile",
            "vscode": "vscode",
        }
        output_type = output_map.get(self.build_type, "cmake")
        # Run slc generate to create copy of sample app at the 'new_app_name' location
        try:
            cmd = [self.slc_path, "generate"]
            cmd += ["-d", self.new_app_name, project_flag, self.reference_project_file]
            cmd += ["--sdk-package-path", self.sisdk_root, "--sdk-package-path", self.wiseconnect_root, "--sdk-package-path", self.silabs_chip_root]
            cmd += ["--with", self.silabs_board, "--new-project", "--generator-timeout=180", "-o", output_type]
            logging.info(f"Running command: {' '.join(cmd)}")
            subprocess.run(cmd, check=True)
            # After generation, extract and save src/include paths
            self.extract_and_save_paths()
        except subprocess.CalledProcessError as e:
            logging.error(f"Error running 'slc generate': {e}")
            sys.exit(1)

def main():
    parser = argparse.ArgumentParser(description="Create a new Matter app from a reference project file.")
    parser.add_argument("-n", "--new_app_name", dest="new_app_name", required=False, help="Name of the new app directory to create")
    parser.add_argument("-p", "--reference_project_file", dest="reference_project_file", required=False, help="Path to the reference .slcp or .slcw project file")
    parser.add_argument("-b", "--silabs_board", dest="silabs_board", required=False, help="Silabs board name")
    parser.add_argument("-v", "--verbose", action="store_true", help="Enable verbose (debug) logging")
    parser.add_argument("-t", "--build_type", dest="build_type", choices=["makefile", "cmake", "vscode"], default="cmake", help="Build system type to generate (makefile, cmake, vscode)")
    
    ## Deprecated
    # Accept positional arguments for backward compatibility
    parser.add_argument("args", nargs="*", help=argparse.SUPPRESS)
    args = parser.parse_args()

    # Support both positional and optional arguments for main required fields
    # Priority: optional flags > positional
    if not args.new_app_name or not args.reference_project_file or not args.silabs_board:
        if len(args.args) >= 3:
            logging.warning(
                "Positional arguments for new_app_name, reference_project_file and silabs_board "
                "are deprecated and will be removed in a future release. "
                "Please use -n/--new_app_name, -p/--reference_project_file and -b/--silabs_board instead."
            )
            args.new_app_name = args.args[0]
            args.reference_project_file = args.args[1]
            args.silabs_board = args.args[2]
        else:
            parser.error("new_app_name, reference_project_file, and silabs_board are required.")

    # Setup logging
    level = logging.DEBUG if args.verbose else logging.INFO
    logging.basicConfig(level=level, format='[%(levelname)s] %(message)s')

    # Patch sys.argv for legacy code
    sys.argv = [sys.argv[0], args.new_app_name, args.reference_project_file, args.silabs_board]

    app = CreateApp(build_type=args.build_type)
    app.validate_arguments()
    app.generate()

if __name__ == "__main__":
    main()
