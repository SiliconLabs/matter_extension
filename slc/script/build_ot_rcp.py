import os
import subprocess
import shutil
import argparse

# This script generates and builds ot-rcp binaries for the supported boards in the list.
# It takes no additional arguments, builds from third_party/simplicity_sdk by default.
#
# Example usage: python3 build_ot_rcp.py

boards = [
    "BRD4180B", # MG21
    "BRD4186A", # MG24
    "BRD4186C",
    "BRD4187A",
    "BRD4187C",
    "BRD2601B",
    "BRD2703A",
    "BRD4316A", # MGM24
    "BRD4317A", 
    "BRD4318A", 
    "BRD4319A", 
    "BRD2704A", 
    "BRD4337A",
    "BRD4116A", # MG26
    "BRD4117A", 
    "BRD4118A", 
    "BRD2608A",
    "BRD4121A",
    "BRD2709A", # MGM26
    "BRD4350A",
    "BRD4351A",
    "BRD1019A", # series-3
    "BRD4407A",
    "BRD4408A",
]

def build_with_sisdk_slc(sdk_path):
    root_path = os.getcwd()
    sisdk_path = os.path.join(root_path,sdk_path)
    ot_rcp_out_path = os.path.join(root_path,"ot-rcp")
    slcp_file_path = os.path.join(sisdk_path, "protocol/openthread/sample-apps/ot-ncp/ot-rcp.slcp")

    if not os.path.exists(ot_rcp_out_path):
        os.makedirs(ot_rcp_out_path)

    subprocess.run(["slc", "configuration", "--sdk", sisdk_path], check=True)
    subprocess.run(["slc", "signature", "trust", "--sdk", sisdk_path], check=True)
    for board_name in boards:
        silabs_board = str(board_name).lower()
        output_path = os.path.join(root_path, "out/ot-rcp-binaries", silabs_board)
        try:
            subprocess.run(["slc", "generate", slcp_file_path, "-d", output_path, "--with", silabs_board], check=True)
            subprocess.run(["make", "-f", "ot-rcp.Makefile", "all"], cwd=output_path, check=True)
            shutil.copyfile("{}/build/debug/ot-rcp.s37".format(output_path), "{}/ot-rcp/ot-rcp_{}.s37".format(root_path, silabs_board))
        except Exception as error:
            # handle the exception
            print("An exception occurred:", error)
    shutil.make_archive("out/ot-rcp_binaries", 'zip', ot_rcp_out_path)
    # print location of output zip file
    print("Output zip file: {}/out/ot-rcp_binaries.zip".format(root_path))

def main():
    parser = argparse.ArgumentParser(description='Build ot-rcp binaries from sisdk')

    parser.add_argument("--sdk", type=str, help="path to the sisdk")
    
    args = parser.parse_args()
    # you must define ARM_GCC_DIR in your path
    # export ARM_GCC_DIR="/Applications/ArmGNUToolchain/12.2.rel1/arm-none-eabi"
    sisdk_path = "third_party/simplicity_sdk"
    if args.sdk:
        sisdk_path =args.sdk
    build_with_sisdk_slc(sisdk_path)

if __name__ == "__main__":
    main()