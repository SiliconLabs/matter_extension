####Imports
import subprocess
import sys
import json
from pathlib import Path
import os
from code_size_analyzer_client.client_wrapper import ClientWrapper

#Defines
code_size_command = 'code_size_analyzer_cli --map_file {path} --stack_name matter --target_part {board} --compiler gcc --output_file {ouput_path}'
output_folder_name = 'matter_{network}-{app}-{type}_{board}/gcc'
complete_json_path = '{prefix}/{app}-{type}.json'

found = False

for root, dirs, files in os.walk("./out/CSA/"):
    for file in files:
        if file.endswith(".map"):
            found = True
            map_file_path = os.path.join(root, file)
            # Retrieve info from map file path
            build_info = map_file_path.replace("./out/CSA", "").split('/')

            # Generate JSON used for IoT code size report
            complete_output_path = "./out/iot_reports/" + output_folder_name.format(app=build_info[1], network=build_info[2], type=build_info[3], board=build_info[4])
            Path(complete_output_path).mkdir(parents=True, exist_ok=True)

            # Run de code size analyzer
            json_file_path = complete_json_path.format(prefix=complete_output_path, app=build_info[1], type=build_info[3])
            client_wrapper = ClientWrapper(server_url="https://code-size-analyzer.dev.silabs.net", verify_ssl=True)
            r = client_wrapper.analyze_map_file(
                map_file_path, "matter", build_info[4], "gcc", None )
            j = json.dumps(r.to_dict(), indent=2)

            with open(json_file_path, "w") as f:
                f.write(j)

if not found:
    print("Nothing found!!!")
    exit(1)