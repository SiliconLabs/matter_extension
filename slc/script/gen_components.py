#!/usr/bin/env python3

# This script generates Matter SLC components out of the output of a Matter GN build (compile_commands.json).
# The compile_commands.json file must reside in the directory where it is placed by the GN build.
# Example usage:
#./slc/script/gen_components.py out/lock-app/BRD4161A/compile_commands.json

import os
import sys
import yaml
import json
import pathlib


root  = str(pathlib.Path(os.path.realpath(__file__)).parent.parent.parent)
enable_copy_contents_path = str(os.path.join(root, 'slc', 'script'))
sys.path.append(enable_copy_contents_path)

import enable_copy_contents
# If adding a new app, update this along with APP_NAME_THREAD
APP_NAME = ['lock', 'lighting', 'light-switch', 'window', 'thermostat']
APP_NAME_COMMON = 'lock_common', 'lighting_common', 'thermostat_common', 'window_common'
APP_NAME_SILABS = 'silabs_lock', 'silabs_lighting', 'silabs_thermostat', 'silabs_window'

# If adding a new app, update this along with APP_NAME
APP_NAME_THREAD = ['lock-app', 'lighting-app', 'light-switch-app', 'window-app', 'thermostat']
APP_NAME_WIFI = [s + '-wifi' for s in APP_NAME_THREAD]
APP_NAME_ALL = APP_NAME_THREAD + [s + '-wifi' for s in APP_NAME_THREAD] 

MATTER_APP = ""

if __name__ == '__main__':

    # loop through the provided list of compile_commands file paths
    for compile_commands_file_path in sys.argv[1:]:    

        wifi = False
        # check if file compile_commands.json file exists 
        if os.path.isfile(os.path.join(root,compile_commands_file_path)):
            for app in APP_NAME_THREAD:
                if app in compile_commands_file_path:
                    # figure out app name from path of compile_commands.json file 
                    MATTER_APP = app
                    break        
            if 'wifi' in compile_commands_file_path:
                wifi = True
            libs = {}
            if MATTER_APP == "":
                print("Could Not found a matching app for {app}".format(app=compile_commands_file_path))
                sys.exit(1)

            with open(compile_commands_file_path) as f:
                compile_commands = json.load(f) # Load compile_commands.json

            for cmd in compile_commands: # Loop through compile_commands.json
    
                dir = pathlib.Path(cmd['directory']) # Grab directory from compile_commands object

                file = (dir / cmd['file']).resolve() # concatenates the 'directory' and 'file' fields and resolves the resulting path which makes the path absolute, without any symlinks .. etc

                command = cmd['command'] # extracts the 'command' field from the dictionary entry and stores it in command var

                obj_path = pathlib.Path(command.split(' ')[-1])  # splits the command at every white space and grabs the last component of the command which is the path to the generated object file

                lib = obj_path.stem.split('.')[0] # splits the path of the generated object file at every '.' and grabs the first element which

                # skips the command if it has anything to do with pigweed ..
                if 'pigweed' in obj_path.parts or lib.startswith('pw_'):
                    # internal pigweed stuff that we don't care about -- skip creating library
                    continue

                # Skip the sdk component
                if lib == 'sdk':
                    continue

                # Skip our example app
                if ('chip-efr32-' in lib or 'chip-siwx917-' in lib) and 'example' in lib:
                    continue

                # Skip clusters
                if 'src' in file.parts and 'app' in file.parts and 'clusters' in file.parts:
                    continue

                # creates a dictionary with the following entries, checks if lib entry exists, if not, its added
                if lib not in libs:
                    libs[lib] = {
                        'src': set(),
                        'inc': set(),
                        'options': set(),
                        'defines': set(),
                    }
                libs[lib]['src'].add(str(file.relative_to(pathlib.Path.cwd()))) # grabs the path of the 'file', finds its relative path to the current working directory, and stores that in 'src' entry of the dict

                inc = map( # creates a map object 

                    # this initial lambda function takes the filtered list of arguments (any arg that starts with -I), removes the -I/-system prefix
                    # resolves the path to a path relative to the current working directory and finally turns it into a string
                    #lambda x: str((dir / x.removeprefix('-I').removeprefix('-isystem')).resolve().relative_to(pathlib.Path.cwd())),
                    lambda x: str((dir / x.replace('-I', '', 1).replace('-isystem', '', 1)).resolve().relative_to(pathlib.Path.cwd())), # For python-3.8

                    filter(# the filter function here is filtering the list of arguements given in the 'command' and removing any that start with '-I'
                        # returns an iterator object that is the input of the lambda function above 

                        lambda x: x.startswith('-I') or x.startswith('-isystem'),

                        command.split(' ') # splits the 'command' at every whitespace and turns it into a list which is input to lambda on the line above
                    )
                )
                
                libs[lib]['inc'] |= set(inc) # turns the filtered 'inc' map from the previous operation into a 'set' object and updates the 'inc'
                                            # entry of the dictionary 

                opt = filter( # filters the list of the arguements of 'command' by only including any g++ option that starts with -f or -W, returns iterator object
                    lambda x: x.startswith('-f') or x.startswith('-W'),
                    command.split(' ') # splits the 'command' at every whitespace and turns it into a list which is input to lambda on the line above

                )
                libs[lib]['options'] |= set(opt)# turns the filtered 'opt' iterator from the previous operation into a 'set' object and updates the 'opt'
                                                # entry of the dictionary 

                defines = map(# creates a map object
                    #lambda x: x.removeprefix('"-D').removesuffix('"') if x.startswith('"') else x.removeprefix('-D'), # removes the -D prefix and any quotation marks from substring
                    lambda x: x.replace('"-D', '', 1).replace('"', '', 1) if x.startswith('"') else x.replace('-D', '', 1), # removes the -D prefix and any quotation marks from substring # For Python-3.8

                    filter(# filters the command by only including arguments starting with the -D flag, which indicates MACROS and DEFINES, returns and iterator object
                        lambda x: x.startswith(('-D', '"-D')), 
                        command.split(' ') # splits the command string at every whitespace and returns a list 
                    )
                )


                libs[lib]['defines'] |= set(defines) # update 'defines' entry of the dict

            os.makedirs('slc/component/matter-core-sdk', exist_ok=True) # creates directories recursively 
            for name, data in libs.items():
                name = name.lower().replace('-', '_') # takes name of library and replaces char '-' with '_'
                # Rename app component to app-common 
                if name in [s.lower().replace('-', '_') for s in APP_NAME_COMMON]: # check if name is in APP_NAME_COMMON (with '-' switch to '_')
                    name = 'app_common'

                # Skip APP_NAME_COMMON
                if name.startswith((APP_NAME_COMMON)):
                    continue

                # Skip APP_NAME_SILABS and matter_silabs and provision example
                if name.startswith((APP_NAME_SILABS)) or name.startswith(('matter_silabs')) or name.startswith(('provision')):
                    continue

                # Create a separate wifi component for these components
                if name in ['efr32', 'dnssd', 'libinetlayer', 'libdevicelayer'] and wifi == True:
                    name += '_wifi'

                # Skip autogenerated minimal_mdns component, create our own
                if name in ['minimal_mdns', 'lwip']:
                    continue

                with open(f"slc/component/matter-core-sdk/{name}.slcc", 'w') as f: # creates an SLCC file and opens in write mode 
                    component = {} #creates a dict called component 
                    component['id'] = name # creates an "id" entry and sets its value to 'name'
                    component['description'] = name # does the same thing as the line above
                    component['quality'] = 'production' 
                    component['package'] = 'Matter'
                    component['category'] = 'Matter|Core'
                    component['label'] = name
                    component['provides'] = [{'name': f'matter_{name}'}] # creates a 'provides' entry in the component dict and assigns it to a list of dicts
                    component['source'] = []
                    component['ui_hints'] =  {'visibility': 'never'}
                    for src in sorted(data['src']): # loops the 'src' set in data pertaining to the library 'name'
                        if any(path in src for path in ["zzz_generated/" + MATTER_APP, 'freertos_bluetooth.c']):
                            # Skip sources related to sample apps
                            continue

                        if "silabs/third_party/connectedhomeip" in src:
                            src = src.partition("silabs/third_party/connectedhomeip")[-1].lstrip('/')

                        # Skip any references to third_party/silabs
                        if 'third_party/silabs' in src:
                            continue

                        # Skip any references to rs911x
                        if 'examples/platform/silabs/efr32/rs911x' in src:
                            continue

                        # Skip any sources under zzz_generated
                        if 'zzz_generated' in src:
                            continue

                        # Skip any references to BLEManagerImpl.cpp for WiFi
                        if 'BLEManagerImpl.cpp' in src and wifi == True:
                            # Adding for SiWx917 SoC
                            if 'siwx917' not in name:
                                continue

                        # Skip any references to BLEManagerImpl.cpp for WiFi
                        if 'gatt_db.c' in src and wifi == True:
                            continue

                        # Skip any references to wfx_sl_ble_init.cpp, added manually in 9116 WiFi component
                        if 'wfx_sl_ble_init.cpp' in src:
                            # Adding for SiWx917 SoC
                            if 'siwx917' not in name:
                                continue

                        if src.endswith('gatt_db.c'):
                            continue

                        component['source'].append({'path': src})

                    component['include'] = [] # creates an 'includes' entry in the component dict and assigns it an empty list 
                    for inc in sorted(data['inc']): # sorts the 'inc' set entry in the data dict and loops it
                        # Skip includes related to Gecko SDK and sample apps
                        if any(path in inc for path in ['openthread', compile_commands_file_path.replace('compile_commands.json', "", 1)+'gen/include', compile_commands_file_path.replace('compile_commands.json', "", 1)+'protocol_buffer', 'RTT', "zzz_generated/" + MATTER_APP, "examples/" + MATTER_APP + "/silabs/efr32/include"]): # For Python-3.8
                            continue
                        if any(path in inc for path in ['openthread', sys.argv[1].removesuffix('compile_commands.json') + 'gen/include', sys.argv[1].removesuffix('compile_commands.json') + 'protocol_buffer', 'RTT', "zzz_generated/" + MATTER_APP, "examples/" + MATTER_APP + "/silabs/include"]):
                            continue
                        if any(path in inc for path in ['openthread', compile_commands_file_path.replace('compile_commands.json', "", 1)+'gen/include', compile_commands_file_path.replace('compile_commands.json', "", 1)+'protocol_buffer', 'RTT', "zzz_generated/" + MATTER_APP, "examples/" + MATTER_APP + "/silabs/SiWx917/include"]):
                            continue
                        # Skip any references to third_party/silabs
                        if 'third_party/silabs' in inc:
                            continue

                        # Skip any references to pigweed
                        if 'pigweed' in inc:
                            continue

                        # Skip any references to rs911x
                        if 'examples/platform/silabs/efr32/rs911x' in inc or 'src/platform/silabs/rs911x' in inc:
                            continue

                        # Skip any references to rs911x
                        if 'silabs/efr32/include' in inc:
                            continue

                        # Skip any references to third_party/mbedtls
                        if 'third_party/mbedtls' in inc:
                            continue

                        # Skip reference to examples/platform/silabs/display. Not sure why this is brought by 917 SoC
                        if 'examples/platform/silabs/display' in inc:
                            continue

                        if 'out' == str(inc.split(os.sep)[0]):
                            continue 

                        # Skip lwip
                        if 'lwip' in inc:
                            continue

                        # Skip zzz_generated
                        if 'zzz_generated' in inc:
                            continue
                        
                        # Skip wifi NCP extension includes
                        if 'wifi' in inc or 'wf200' in inc or 'rs9116' in inc:
                            # Adding for SiWx917 SoC
                            if 'siwx917' not in name:
                                continue

                        if "silabs/third_party/connectedhomeip" in inc:
                            inc = inc.partition("silabs/third_party/connectedhomeip")[-1].lstrip('/')

                        if inc == '':
                            continue
                        # no need to add include path for all components
                        if ('/platform/silabs/efr32' in inc or '/platform/silabs/SiWx917' in inc) and not ('efr32' in name or 'siwx917' in name):
                            continue

                        component['include'].append({'path': inc}) # appends a dict with a 'path: inc' entry to the list of includes 
                    component['define'] = [] # creates a 'define' entry in the component dict and assigns it an empty list 
                    for define in sorted(data['defines']): # sorts the 'define' set in the data dict and loops it 
                        value = None
                        if '=' in define: # looks for defines and splits the string to a define, value pair 
                            define, value = define.split('=')

                        if define.startswith(('DISPLAY_ENABLED', 'QR_CODE_ENABLED')):
                            # Skip defines related to LCD
                            continue
                        
                        if define.startswith(('__', 'SL_', 'NVM3_', 'MBEDTLS_','SILABS_LOG', 'HARD_FAULT_LOG', 'EFR32', 'CORTEXM3', 'CONFIG', 'BOARD', 'BRD', 'PLATFORM', 'KVS', 'LWIP', 'WF200', 'CHIP_MINMDNS_', 'EFX32', 'RS911X', 'RSI', 'NDEBUG', 'CCP_', 'SIWX', 'TINYCRYPT', 'LITTLE_', 'OPTIMIZE_TINYCRYPT', 'CHIP_917', 'CHIP_9117', 'ENABLE_', 'BLE_', 'ROM_', 'DEBUG_', 'FLASH_', 'TA_DEEP_', 'ROM_WIRELESS' , 'EXECUTION_' , 'HARD_FAULT_LOG_ENABLE' , 'ROMDRIVER_PRESENT' , 'SILABS_LOG_ENABLED' , 'SI917' , 'SILABS_OTA_ENABLED' , '_CHIP_9118')) or define in ['USE_NVM3', 'MICRO', 'PLAT', 'PHY', 'CHIP_DEVICE_CONFIG_THREAD_ENABLE_CLI','ENABLE_WSTK_LEDS', 'OTA_PERIODIC_TIMEOUT']:
                            # Skip defines related to Gecko SDK and LWIP
                            continue

                        if define.startswith(('DISPLAY_ENABLED', 'EXT_IRQ_COUNT', 'QR_CODE_ENABLED', 'SLI_', 'SI91X_', 'SPI_MULTI', 'SRAM_', 'SYSCALLS_', 'configUSE_', 'SiWG917', 'EXP_BOARD')):
                            # Blanket skip all defines added by 917, this needs to be fixed in CSA eventually
                            continue

                        if define.startswith(('CHIP_CONFIG_SYNCHRONOUS')):
                            # Blanket skip sleepy related defines that come from the lock-app
                            continue

                        if value is not None: # if the value is not empty string, create a dict with the following keys and values and assigns it to the 'define' entry in the component dict
                            component['define'].append({'name': define, 'value': value}) 
                        else:
                            component['define'].append({'name': define})
                    yaml.dump(component, f, Dumper=yaml.SafeDumper, default_flow_style=False, indent=4) 
                    # inserts the data in the component dict to the open SLCC file passed as 'f' in YAML format 