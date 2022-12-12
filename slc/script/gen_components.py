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

PIGWEED_ALLOW_LIST = ['check_backend', 'intrusive_list']

if __name__ == '__main__':

    root  = str(pathlib.Path(os.path.realpath(__file__)).parent.parent.parent)

    MATTER_APP = sys.argv[1].split("/")[1]

    with open(sys.argv[1]) as f:
        compile_commands = json.load(f) # returns a list of dictionaries, parses the json file, breaks it down into three fields, directory, file and command

    libs = {}

    for cmd in compile_commands:
        dir = pathlib.Path(cmd['directory']) # instantiates a pathlib.PurePath object with the 'directory field of the command as an arguement. provides Computational operations 
                                             # but not I/O operations, cross-platform way of dealing with paths.

        file = (dir / cmd['file']).resolve() # concatenates the 'directory' and 'file' fields and resolves the resulting path which makes the path absolute, without any symlinks .. etc

        command = cmd['command'] # extracts the 'command' field from the dictionary entry and stores it in command var

        obj_path = pathlib.Path(command.split(' ')[-1])  # splits the command at every white space and grabs the last component of the command which is the path to the generated object file

        lib = obj_path.stem.split('.')[0] # splits the path of the generated object file at every '.' and grabs the first element which

        # skips the command if it has anything to do with pigweed ..
        if 'pigweed' in obj_path.parts and not lib.startswith('pw_') and lib not in PIGWEED_ALLOW_LIST:
            # internal pigweed stuff that we don't care about -- skip creating library
            continue

        # Skip the sdk component
        if lib == 'sdk':
            continue

        # Skip our example app
        if 'chip-efr32-' in lib and 'example' in lib:
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
            lambda x: str((dir / x.removeprefix('-I').removeprefix('-isystem')).resolve().relative_to(pathlib.Path.cwd())),

            filter(# the filter function here is filtering the list of arguements given in the 'command' and removing any that start with '-I'
                   # returns an iterator object that is the input of the lambda function above 

                lambda x: x.startswith('-I'),# or x.startswith('-isystem'),

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
            lambda x: x.removeprefix('"-D').removesuffix('"') if x.startswith('"') else x.removeprefix('-D'), # removes the -D prefix and any quotation marks from substring

            filter(# filters the command by only including arguments starting with the -D flag, which indicates MACROS and DEFINES, returns and iterator object
                lambda x: x.startswith(('-D', '"-D')), 
                command.split(' ') # splits the command string at every whitespace and returns a list 
            )
        )


        libs[lib]['defines'] |= set(defines) # update 'defines' entry of the dict

    os.makedirs('slc/component/matter-core', exist_ok=True) # creates directories recursively 
    for name, data in libs.items():
        name = name.lower().replace('-', '_') # takes name of library and replaces char '-' with '_'
        with open(f"slc/component/matter-core/{name}.slcc", 'w') as f: # creates an SLCC file and opens in write mode 
            component = {} #creates a dict called component 
            component['id'] = name # creates an "id" entry and sets its value to 'name'
            component['description'] = name # does the same thing as the line above
            component['quality'] = 'production' 
            component['package'] = 'Matter'
            component['category'] = 'Matter|Core'
            component['label'] = name
            component['provides'] = [{'name': f'matter_{name}'}] # creates a 'provides' entry in the component dict and assigns it to a list of dicts
            component['source'] = []
            for src in sorted(data['src']): # loops the 'src' set in data pertaining to the library 'name'
                if any(path in src for path in ["zzz_generated/" + MATTER_APP, 'freertos_bluetooth.c']):
                    # Skip sources related to sample apps
                    continue

                if src.endswith('gatt_db.c'):
                    # GATT database should be generated by btconf tool
                    # creates a 'config file' entry in the component dict and sets it to the following list of dicts on the right 
                    component['config_file'] = [{'path': src.replace('gatt_db.c', 'gatt.btconf'), 'directory': 'btconf'}]
                    component['provides'].append({'name': 'gatt_configuration'}) 
                    component['template_contribution'] = [{'name': 'component_catalog', 'value': 'gatt_configuration'}]
                else:
                    component['source'].append({'path': src})
            component['include'] = [] # creates an 'includes' entry in the component dict and assigns it an empty list 
            for inc in sorted(data['inc']): # sorts the 'inc' set entry in the data dict and loops it
                # Skip includes related to Gecko SDK and sample apps
                if any(path in inc for path in ['openthread', sys.argv[1].removesuffix('compile_commands.json')+'gen/include', sys.argv[1].removesuffix('compile_commands.json')+'protocol_buffer', 'RTT', "zzz_generated/" + MATTER_APP, "examples/" + MATTER_APP + "/efr32/include"]):
                    continue
                # Skip any references to third_party/silabs
                if 'third_party/silabs' in inc:
                    continue

                if 'out' == str(inc.split(os.sep)[0]):
                    continue 
                component['include'].append({'path': inc}) # appends a dict with a 'path: inc' entry to the list of includes 
            component['define'] = [] # creates a 'define' entry in the component dict and assigns it an empty list 
            for define in sorted(data['defines']): # sorts the 'define' set in the data dict and loops it 
                value = None
                if '=' in define: # looks for defines and splits the string to a define, value pair 
                    define, value = define.split('=')
                
                if define.startswith(('__', 'SL_', 'NVM3_', 'MBEDTLS_', 'EFR32', 'CORTEXM3', 'CONFIG', 'BOARD', 'BRD', 'PLATFORM', 'KVS')) or define in ['USE_NVM3', 'MICRO', 'PLAT', 'PHY', 'CHIP_DEVICE_CONFIG_THREAD_ENABLE_CLI','ENABLE_WSTK_LEDS']:
                    # Skip defines related to Gecko SDK
                    continue

                if value is not None: # if the value is not empty string, create a dict with the following keys and values and assigns it to the 'define' entry in the component dict
                    component['define'].append({'name': define, 'value': value}) 
                else:
                    component['define'].append({'name': define})
            yaml.dump(component, f, Dumper=yaml.SafeDumper, default_flow_style=False, indent=4) 
            # inserts the data in the component dict to the open SLCC file passed as 'f' in YAML format 
