import os
import sys
import re
import yaml
'''
    This script is to be ran after gen_components.py has been ran to generate the core Matter components. It will modify
    the components within slc/component/matter-core-sdk to explicitly list their included header files using the
    "file_list:" SLC specification. This is needed when performing the "copy-contents" step on project generation.
    This script recursviely searches the provided directory for any .slcc files. It removes any "include:" section
    and populates the "include:" section with a list of any header files within the directories that
    the .c or .cpp files under the "source:" section reside in
'''
rootDir  = os.getcwd()
dirToSearch = rootDir + "/slc/component/matter-core-sdk"
# These directories do not include any source files within the components
includeWholeDir =  [rootDir + "/src/include/platform", rootDir + "/src/include/platform/internal",
                    rootDir + "/src/platform/logging", rootDir + "/src/include/platform/internal/testing",
                    rootDir + "/src/lib/dnssd/platform",   rootDir +"/src/lib/dnssd/platform",
                    rootDir + "/src/app/common",          rootDir + "/src/platform/silabs/multi-ota",
                    rootDir +  "/src/lwip/silabs",         rootDir + "/examples/platform/silabs/display",
                    rootDir + "/examples/platform/silabs"]
# Way source code is written requires SLC to perform weird gymnastics when writing out filepath
specialCases =       ["src/app/util", "src/dnssd/platform", "src/app/data-model"]
# Main platform components
mainComponents =     ["efr32.slcc", "efr32_wifi.slcc", "siwx917.slcc"]
manualFiles = ["matter_nlassert.slcc", "matter_includes.slcc", "matter_nlio.slcc"]
# Returns dictionary of slcc files to included header files
def find_slcc_files(directory):
    if not os.path.exists(directory):
        raise ValueError("Directory does not exist.")
    slccFiles = []
    # Recursively search the directory for .slcc files
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(".slcc"):
                slccFiles.append(os.path.join(root, file))
    return slccFiles
# Returns include directories in the provided slcc file
def get_included_dirs(file_path):
    includeDirectories = []
    try:
        with open(file_path, 'r') as file:
            # Add directories of any source files within the .slcc to search
            for line in file:
                line = line.strip()
                line = line.split(" ")[-1]
                line = rootDir + "/" + line
                if line.endswith(".c") or line.endswith(".cpp"):
                    includeDirectories.append(os.path.dirname(line))
    except:
        pass
    return includeDirectories
def add_key_value_to_yaml(file_path: str, foundIncludesDirs):
    try:
        # Open the YAML file for reading and writing
        with open(file_path, 'r') as file:
            yaml_data = yaml.safe_load(file)
            fileModified = False
            if "include" not in yaml_data:
                yaml_data["include"] = []
            relFileName = file_path.split("/")[-1]
            # Do not change manual files
            if relFileName in manualFiles:
                return
            print("\nAdding includes for: " + relFileName)
            # Add whole include directory to efr32 components
            if (relFileName in mainComponents):
                for dir in includeWholeDir:
                    headers = []
                    relativeDir = dir.replace(rootDir + "/", '')
                    print("Adding directory: " + relativeDir)
                    file_list = []
                    # Add whole include directory to efr32 components
                    for file_name in os.listdir(dir):
                        if file_name.endswith(".h") or file_name.endswith(".hpp") or file_name.endswith(".ipp"):
                            file_list.append({"path":file_name})
                    yaml_data["include"].append({"path": relativeDir, "file_list": file_list})
                    fileModified = True
            # Add include files for the given directories
            for dir in foundIncludesDirs:
                if os.path.exists(dir):
                    file_list = []
                    file_name = ""
                    relativeDir = dir.replace(rootDir + "/", '')
                    directory = relativeDir
                    print("Adding directory: " + relativeDir)
                    for header in os.listdir(dir):
                        if header.endswith(".h") or header.endswith(".hpp") or header.endswith(".ipp"):
                            file_name = header
                            for dirToChange in specialCases:
                                if relativeDir.startswith(dirToChange):
                                    file_name = dirToChange.split("/", 2)[2] + "/" + header
                                    directory = dirToChange.split("/", 2)[0] + "/" + dirToChange.split("/", 2)[1]
                            file_list.append({"path": file_name})
                    if file_list:
                        yaml_data["include"].append({"path": directory, "file_list": file_list})
                        fileModified = True
            if fileModified:
                with open(file_path, 'w') as file:
                    yaml.safe_dump(yaml_data, file, default_flow_style=False, sort_keys=False, indent=4)
    except FileNotFoundError:
        raise FileNotFoundError(f"The file '{file_path}' does not exist.")
# Main function
slccFiles = find_slcc_files(dirToSearch)
for slccFile in slccFiles:
    foundHeaders = []
    foundIncDirs = get_included_dirs(slccFile)
    add_key_value_to_yaml(slccFile, set(foundIncDirs))
    