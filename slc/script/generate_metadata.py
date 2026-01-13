import os
import xml.etree.ElementTree as ET
import xml.dom.minidom
import pathlib
import sys


###########################################################################################
# Generates matter_demos.xml                                                              #
# use case:                                                                               #
# slc/script/generate_metadata.py <full path to binaries folder>                          #
# example:                                                                                #
# python3 slc/script/generate_metadata.py ../out/release/                                 #
#                                                                                         #
###########################################################################################


root_dir = pathlib.Path(sys.argv[0]).parent.parent.parent.absolute()

# Check if required command line argument is provided
if len(sys.argv) < 2:
    print("ERROR: Missing required argument!")
    print("Usage: python3 generate_metadata.py <full path to binaries folder>")
    print("Example: python3 generate_metadata.py ../out/release/")
    sys.exit(1)

out_folder_dir = sys.argv[1]
internal_boards = ['brd4319f']
internal_sample_apps = ['performance-test-app','platform-app','lock-li']

# Read version from matter.slce file
matterExtensionVersion = None
matter_slce_path = os.path.join(root_dir, "matter.slce")
if os.path.exists(matter_slce_path):
    with open(matter_slce_path, 'r') as stream:
        for line in stream:
            if line.startswith('version:'):
                matterExtensionVersion = line.split(':')[1].strip()
                break

if matterExtensionVersion is None:
    print("ERROR: Could not find version in matter.slce file!")
    print("Please verify matter.slce file exists and contains a version line.")
    sys.exit(1)

asset_prefix = "asset://extension.matter_"+matterExtensionVersion+"/"+"demos/"

if not os.path.exists(out_folder_dir):
    print("ERROR: Binaries output folder can't be found!")
    print("Please verify path to binaries is correct.")
    sys.exit(1)

demos_map = {
    'demos': {}
}

'''
Recurse all directories to remove undesired files and Scan Examples folder to account for all demos present
'''

def recurse_dir(file_or_dir):

    if os.path.isdir(file_or_dir):
        subdirs = os.listdir(file_or_dir)
        for unit in subdirs:
            recurse_dir(os.path.join(file_or_dir, unit))
    else:
        if '.ds_store' in file_or_dir.lower():
            os.remove(file_or_dir)
        elif '.asset' in file_or_dir:
            return
        exclude_patterns = ['-lto', 'trustzone', 'peripherals']
        if (file_or_dir.endswith('-full.s37') or file_or_dir.endswith('.rps')) and not any(p in file_or_dir for p in exclude_patterns):
            brd = None
            for leaf in file_or_dir.split('/'):
                if 'brd' in leaf.lower():
                    brd = leaf
                    break
            
            if brd is None:
                return
            
            if 'series-2' in file_or_dir or 'series-3' in file_or_dir:
                tech_ = 'OpenThread'
            else:
                tech_ = 'WiFi'

            basename = os.path.basename(file_or_dir).replace('.s37', '').replace('.rps','')
            basename = basename.replace('-full', '').replace('-internal', '')
            board_type = (str(basename).split('-'))[-1]
            
            if board_type == "ncp":
                board_type = "917-ncp"
            elif board_type == "brd4357a":
                board_type = "917-ncp-brd4357a"
            elif board_type == "soc" or board_type == "example" or board_type == "siwx":
                board_type = "917-soc"
            elif board_type == "wf200":
                board_type = "wf200"

            if brd not in demos_map['demos'].keys():
                demos_map['demos'][brd] = {'OpenThread': [], 'WiFi': {'917-soc': [], '917-ncp': [], '917-ncp-brd4357a': [], 'wf200': []}}

            rel_path = os.path.relpath(file_or_dir, out_folder_dir)
            
            if tech_ == 'OpenThread':
                demos_map['demos'][brd][tech_].append(rel_path)
            elif tech_ == 'WiFi':
                demos_map['demos'][brd][tech_][board_type].append(rel_path)
  

recurse_dir(out_folder_dir)


# helper function to skip internal apps
def is_internal_app(demo_name, internal_apps):
    """Check if the demo name contains any internal app names."""
    return any(internal_app in demo_name for internal_app in internal_apps)

'''
generate demo metadata
'''

demos = ET.Element('demos')

demos.set('xmlns:xsi', "http://www.w3.org/2001/XMLSchema-instance")
demos.set('xsi:noNamespaceSchemaLocation',
          "http://www.silabs.com/ss/Demo.ecore")

for brd, val in demos_map['demos'].items():
    if brd.lower() in internal_boards:
        continue
    for technology in val.keys():
        if technology == 'OpenThread':
            for demo_path in val[technology]:
                demo_filename = os.path.basename(demo_path).replace('.s37', '')
                
                # Skip internal apps
                if is_internal_app(demo_filename, internal_sample_apps):
                    continue
                    
                demo_name = ""

                for name in demo_filename.split("-"):
                    if name in ['app', 'thread', 'series', 'full', 'internal']:
                        break
                    else:
                        demo_name += name + " "

                if "window" in demo_name:
                    demo_name_ = "Window Covering"
                elif "thermostat" in demo_name:
                    demo_name = "thermostat"
                    demo_name_ = "Thermostat"
                else:
                    demo_name_ = demo_name.strip()

                demo_name = demo_name.strip()
                demo_name_ = ' '.join(elem.capitalize() for elem in demo_name_.split())

                variant_suffix = ""
                if "sequential" in demo_path:
                    variant_suffix = " Sequential"
                elif "concurrent" in demo_path:
                    variant_suffix = " Concurrent"
                
                if variant_suffix:
                    demo_name_ = demo_name_ + variant_suffix

                demo = ET.SubElement(demos, 'demo')
                blurbProp = ET.SubElement(demo, 'property')
                partCompatibilityProp = ET.SubElement(demo, 'property')
                boardCompatibilityProp = ET.SubElement(demo, 'property')
                imageFileProp = ET.SubElement(demo, 'property')
                readmeFileProp = ET.SubElement(demo, 'property')
                filtersProp = ET.SubElement(demo, 'property')
                qualityProp = ET.SubElement(demo, 'property')
                description = ET.SubElement(demo, 'description')

                demo.set('name', brd.lower()+".demo."+(demo_name + " app thread").replace(" ", "_"))
                demo.set('label', "Matter" + " - " + "SoC " +
                        demo_name_ + " over Thread")

                blurbProp.set('key', 'demos.blurb')
                blurbProp.set('value', "Matter"+ " - " + "SoC " +
                            demo_name_ + " app")

                partCompatibilityProp.set('key', 'core.partCompatibility')
                partCompatibilityProp.set('value', ".*")

                boardCompatibilityProp.set('key', 'core.boardCompatibility')
                boardCompatibilityProp.set('value', brd.lower())

                imageFileProp.set('key', 'demos.imageFile')
                imageFileProp.set('value', asset_prefix + demo_path)

                readmeFileProp.set('key', 'core.readmeFiles')

                # generate README path for slc app structure
                demo_name_dir = demo_name.replace(" ", "-")
                if demo_name_dir == "zigbee-matter-light":
                    app_dir = "zigbee-matter-light"
                elif demo_name_dir == "thermostat":
                    app_dir = "thermostat"
                else:
                    app_dir = demo_name_dir + "-app"

                readmeFileProp.set(
                    'value',  os.path.join("slc","apps", app_dir, "thread","README.md"))

                filtersProp.set('key', 'filters')
                filtersProp.set('value', "Type|SoC Project\\ Difficulty|Advanced Wireless\\ Technology|Matter")

                qualityProp.set('key', 'core.quality')
                qualityProp.set('value', "PRODUCTION")
                
                # special case for zigbee matter light to avoid redundant "Matter" prefix
                if "zigbee matter light" in demo_name_.lower():
                    description.text = "".join("This is a " + demo_name_ +
                                                " Application over Thread for " + brd.upper())
                else:
                    description.text = "".join("This is a Matter " + demo_name_ +
                                                " Application over Thread for " + brd.upper())

        elif technology == 'WiFi':
            for board_type in val[technology].keys():
                for demo_path in val[technology][board_type]:
                    demo_filename = os.path.basename(demo_path).replace('.s37', '').replace('.rps', '')
                    
                    demo_name = ""
                    # Skip internal apps
                    if is_internal_app(demo_filename, internal_sample_apps):
                        continue
                        
                    for name in demo_filename.split("-"):
                        if name in ['app', 'siwx', 'series', 'full', 'internal']:
                            break
                        else:
                            demo_name += name + " "

                    if "window" in demo_name:
                        demo_name_ = "Window Covering"
                    elif "thermostat" in demo_name:
                        demo_name = "thermostat"
                        demo_name_ = "Thermostat"
                    elif "lighting" in demo_name:
                        demo_name_ = "Lighting"
                    elif "switch" in demo_name:
                        demo_name_ = "Light Switch"
                    elif "dishwasher" in demo_name:
                        demo_name_ = "Dishwasher"
                    elif "lock" in demo_name:
                        demo_name_ = "Lock"
                    elif "onoff" in demo_name:
                        demo_name_ = "Onoff Plug"
                    else:
                        demo_name_ = demo_name.strip()

                    demo_name_ = ' '.join(elem.capitalize() for elem in demo_name_.split())
                    demo_name = demo_name.strip()
                    demo = ET.SubElement(demos, 'demo')
                    blurbProp = ET.SubElement(demo, 'property')
                    partCompatibilityProp = ET.SubElement(demo, 'property')
                    boardCompatibilityProp = ET.SubElement(demo, 'property')
                    imageFileProp = ET.SubElement(demo, 'property')
                    readmeFileProp = ET.SubElement(demo, 'property')
                    filtersProp = ET.SubElement(demo, 'property')
                    qualityProp = ET.SubElement(demo, 'property')
                    description = ET.SubElement(demo, 'description')

                    demo.set('name', brd.lower()+".demo." +
                                "".join(demo_name.replace(" ", "_")) + "_app_" +  ("siwx917" if "soc" in board_type else board_type.replace("-", "_")))
                    demo.set('label', "Matter" + " - " + ("SoC" if "soc" in board_type else "NCP") + " " +
                                demo_name_ + " over Wi-Fi")

                    blurbProp.set('key', 'demos.blurb')
                    blurbProp.set('value', "Matter"+ " - " + ("SiWx917 SoC" if "soc" in board_type else "NCP") + " " +
                                    demo_name_ + " app")

                    partCompatibilityProp.set('key', 'core.partCompatibility')
                    partCompatibilityProp.set('value', ".*")

                    boardCompatibilityProp.set('key', 'core.boardCompatibility')
                    boardCompatibilityProp.set('value', brd.lower())

                    imageFileProp.set('key', 'demos.imageFile')
                    imageFileProp.set('value', asset_prefix + demo_path)
                    readmeFileProp.set('key', 'core.readmeFiles')
                    
                    # generate README path for slc app structure
                    demo_name_dir = demo_name.replace(" ", "-")
                    if demo_name_dir == "thermostat":
                        app_dir = "thermostat"
                    else:
                        app_dir = demo_name_dir + "-app"
                    
                    readmeFileProp.set('value', os.path.join("slc","apps", app_dir, "wifi","README.md"))

                    filtersProp.set('key', 'filters')
                    filtersProp.set('value', "Type|" + ("SoC" if "soc" in board_type else "NCP") + " Project\\ Difficulty|Advanced Wireless\\ Technology|Matter")

                    qualityProp.set('key', 'core.quality')
                    qualityProp.set('value', "PRODUCTION")
                    if "soc" in board_type:
                        description.text = "This is a Matter " + demo_name_ + " Application for " + brd.upper() + " with SiWx917 Wi-Fi SoC"
                    else:
                        description.text = "This is a Matter " + demo_name_ + " Application for " + brd.upper() + " to be used with Wi-Fi " + board_type.upper()

outputString = ET.tostring(demos, encoding='UTF-8')
dom = xml.dom.minidom.parseString(outputString)
pretty_xml_as_string = dom.toprettyxml()

demosXmlFilePath = os.path.join(root_dir, "matter_demos.xml")
with open(demosXmlFilePath, "w") as demosXmlFile:
    demosXmlFile.write(pretty_xml_as_string)
    print("Successfully generated",demosXmlFilePath)
