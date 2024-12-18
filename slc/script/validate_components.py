#!/usr/bin/env python3
import os
import subprocess
import sys

# Example usage from the root matter directory:
# $ ./slc/script/validate_components.py [optional directory to search] [optional SLC location - absolute path]

# Or to save output to a log file:
# $ python -u "./slc/script/validate_components.py" | tee component_validation.log

# Default values
slc = "slc"
componentDir = "slc/component"

# Allow user to pass in directory to validate and/or location of SLC to use
if len(sys.argv) > 3:
    print("Too many arguments. Expecting directory of components to validate and/or location of SLC to use.")
    sys.exit()
elif len(sys.argv) == 1:
    print("Using default 'slc' as command.")
elif len(sys.argv) == 2:
    componentDir = sys.argv[1]
    print("Using default 'slc' as command.")
elif len(sys.argv) == 3:
    componentDir = sys.argv[1]
    slc = sys.argv[2]
    print(f"Using {slc} as command.")

    # Sanitize input
    if (not slc) or ("slc" != os.path.basename(slc)):
        raise ValueError("Binary location cannot be empty.")
    invalid_chars = [';', '&', '|', '<', '>', '$', '`', '(', ')', '{', '}', '[', ']', '\\', '\'', '\"', '..']
    for char in invalid_chars:
        if char in slc:
            raise ValueError("Binary location contains invalid characters.")
    slc = slc.strip()



# Parses the components within a given directory and validates them with slc
# Returns a list with the results of the validation at the end of the test
def validate_slcc_files(directory):
    # Checking if the provided directory exists
    if not os.path.isdir(directory):
        raise ValueError("Directory does not exist.")

    success = True
    print(f"Validating components within {directory}.\n")

    # Recursively search the directory for .slcc files
    for root, dirs, files in os.walk(directory):
        for file in files:
            results = []
            if file.endswith(".slcc"):
                # Constructing the command to validate the file
                command = f"{slc} --daemon validate {os.path.join(root, file)} --extension-path='./'"
 
                # Running the command using subprocess
                try:
                    output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, universal_newlines=True)
                    results.append(output.strip())
                except subprocess.CalledProcessError as e:
                    # If the command fails, append the error message to the results
                    results.append(e.output.strip())
                    success = False
            printCleansed(results)

    return success

# Validates the upgrade file within the root directory
def validate_upgrade_file(directory):
    # Validate upgrade.slcu
    command = (f"{slc} validate-upgrade {directory}/upgrade.slcu")
    results = []
    try:
        output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, universal_newlines=True)
        results.append(output.strip())
        print("Upgrade file validation successful.\n")
    except subprocess.CalledProcessError as e:
        # If the command fails, append the error message to the results
        results.append(e.output.strip())
        print("Upgrade file validation unsuccessful.\n")

        printCleansed(results)

# Print results and remove extra noise from SLC            
def printCleansed(output):
    for item in output:
        lines = item.split('\n')
        #Do not print logs for components without any issues.
        if "No issues detected" in lines[-1]:
            break
        cleanedOutput = '\n'.join(lines[2:])
        print(cleanedOutput + "\n")

if __name__ == "__main__":
    rootDir  = os.getcwd()
    dirToSearch = rootDir + "/" + componentDir
    validate_upgrade_file(rootDir)
 
    if validate_slcc_files(dirToSearch):
        print("Validation successful! No issues detected.")
        sys.exit()
    else:
        print("Validation warnings/errors. Please see the above logs.")
        sys.exit(1)