"""
This script copies the contents of the current working directory to a specified target location,
excluding certain directories and files based on predefined rules.

Usage:
    python3 slc/stage_extension.py <target_location>

Example:
    python3 slc/stage_extension.py /path/to/target

Arguments:
    target_location: The directory where the files should be copied to. The script will create a subdirectory
                     named "matter_extension" in the target location and copy the files there.

Example:
    python3 stage_extension.py target_location

The script will copy the files to target_location/matter_extension, excluding specified directories and files.
"""
import os
import shutil
import argparse

# Directories to exclude from copying
exclude_root_directories = [ "matter_extension/out", "matter_extension/demos", "matter_extension/slc/tools"]

exlude_submodules = ['simplicity_sdk', 'wifi_sdk', "matter_private", "third_party_hw_drivers_extension"]

#specific exlude from matter_sdk
matter_sdk_exclude = ['third_party','zzz_generated']

# Specific includes for wiseconnect_wifi_bt_sdk
wiseconnect_wifi_bt_sdk_includes = ['sapi']

# Specific includes for matter_support
matter_support_includes = ['provision', 'mbedtls', "si91x"]

def should_exclude(root, path):
    """
    Check if any part of the path matches the exclude list.
    """
    # Exclude hidden files and directories
    if path.startswith("."):
        #print(f"Excluding hidden path: {path}")
        return True
    
    full_path = os.path.join(root, path)
    
    # Check for wiseconnect_wifi_bt_sdk specific includes
    if "wiseconnect-wifi-bt-sdk/" in full_path:
        if not any(include in full_path for include in wiseconnect_wifi_bt_sdk_includes):
            #print(f"Excluding wiseconnect_wifi_bt_sdk path: {full_path}")
            return True

    # Check for matter_support specific includes
    if "matter_support/matter/" in full_path:
        if not any(include in full_path for include in matter_support_includes):
            #print(f"Excluding matter_support path: {full_path}")
            return True
    
    # Exclude other matter_support directories
    if "matter_support/" in full_path and "matter_support/matter" not in full_path:
        #print(f"Excluding other matter_support path: {full_path}")
        return True

    # Exclude submodules
    if "third_party/" in full_path:
        if any(exclude in full_path for exclude in exlude_submodules):
            #print(f"Excluding submodule path: {full_path}")
            return True
    
    # Exclude matter_sdk directories
    if "matter_sdk/" in full_path:
        if not any(exclude in full_path for exclude in matter_sdk_exclude):
            #print(f"Excluding matter_sdk path: {full_path}")
            return True
    
    # Exclude directories listed in exclude_directory
    for exclude in exclude_root_directories:
        if exclude in full_path:
            #print(f"Excluding directory from exclude list: {full_path}")
            return True

    # Exclude directories if any part of the path matches exclude_directory
    if any(exclude in full_path.split(os.sep) for exclude in exclude_root_directories):
        #print(f"Excluding directory from split path: {full_path}")
        return True

    return False

def copy_directory(source_directory, target_location):
    """
    Copy everything from source_directory to target_location except for specified subdirectories.

    :param source_directory: The directory to copy from.
    :param target_location: The directory to copy to.
    """
    # Define the target location with a subdirectory named "matter_extension"
    target_location = os.path.join(target_location, "matter_extension")
    os.makedirs(target_location, exist_ok=True)

    # Walk through the source directory
    for root, dirs, files in os.walk(source_directory):
        # Skip directories that should be excluded
        dirs[:] = [d for d in dirs if not should_exclude(root, d)]
        
        # Copy files
        for file in files:
            # Skip hidden files
            if file.startswith("."):
                continue
            source_file = os.path.join(root, file)
            relative_path = os.path.relpath(root, source_directory)
            target_dir = os.path.join(target_location, relative_path)
            os.makedirs(target_dir, exist_ok=True)
            shutil.copy2(source_file, os.path.join(target_dir, file))

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Copy directory to target location.")
    parser.add_argument('target_location', type=str, help='The target location to copy the directory to.')
    args = parser.parse_args()
    
    target_location = args.target_location
    
    # Define the source directory as the current working directory
    source_directory = os.getcwd()
    
    # Copy the root directory to the target location, excluding the specified directories
    copy_directory(source_directory, target_location)
    print(f"Copied files to {target_location}/matter_extension.")

if __name__ == "__main__":
    main()