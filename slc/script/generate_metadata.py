from genericpath import isdir
import os
import xml.etree.ElementTree as ET
import xml.dom.minidom
import pathlib
import sys
import yaml


###########################################################################################
# Generates matter_demos.xml                                                              #
# use case:                                                                               #
# slc/script/generate_metadata.py <full path to binaries folder>                          #
# example:                                                                                #
# python3 slc/script/generate_metadata.py ../out/release/                                 #
#                                                                                         #
###########################################################################################


root_dir = pathlib.Path(sys.argv[0]).parent.parent.parent.absolute()
out_folder_dir = sys.argv[1]
examples_dir = os.path.join(root_dir, "Examples")
root_sub_dirs = os.listdir(root_dir)
internal_boards = ['brd4319f']
with open(os.path.join(root_dir,"third_party","matter_private","jenkins","pipeline_metadata.yml"), 'r') as stream:
    pipeline_metadata = yaml.safe_load(stream)

matterExtensionVersion = pipeline_metadata['toolchain_info']['matterExtensionVersion']
asset_prefix = "asset://extension.matter_"+matterExtensionVersion+"/"

if not os.path.exists(out_folder_dir):
    print("ERROR: Binaries output folder can't be found!")
    print("Please verify path to binaries is correct.")
    sys.exit()

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
        elif '.s37' in file_or_dir or '.rps' in file_or_dir:
            for leaf in file_or_dir.split('/'):
                if 'BRD' in leaf:
                    brd = leaf
                elif 'OpenThread' in leaf or 'WiFi' in leaf:
                    tech_ = leaf

            board_type = (str(os.path.basename(file_or_dir).replace('.s37', '')).replace('.rps','').split('-'))[-1]
            if board_type == "ncp":
                board_type = "917-ncp"
            elif board_type == "soc" or board_type == "example":
                board_type = "917-soc"

            if brd not in demos_map['demos'].keys():
                demos_map['demos'][brd] = {'OpenThread': [], 'WiFi': {'917-soc': [], '917-ncp': [], 'wf200': [], 'rs911x': []}}

            if tech_ == 'OpenThread':
                demos_map['demos'][brd][tech_].append(str(os.path.basename(file_or_dir).replace('.s37', '')))
            elif tech_ == 'WiFi':
                demos_map['demos'][brd][tech_][board_type].append(str(os.path.basename(file_or_dir).replace('.s37', '').replace('.rps','')))
  

recurse_dir(out_folder_dir)



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
            for demo_ in val[technology]:
                demo_name = ""

                for name in demo_.split("-"):
                    if name == 'app' or name == 'thread':
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
                imageFileProp.set('value', asset_prefix + os.path.join(
                    "demos", brd, technology, demo_ + ".s37"))

                readmeFileProp.set('key', 'core.readmeFiles')

                readmeFileProp.set(
                    'value',  os.path.join("slc","sample-app", '-'.join([demo_name.replace(" ", "-"), 'app']) if demo_name != 'thermostat' else demo_name, "efr32","README.md"))

                filtersProp.set('key', 'filters')
                filtersProp.set('value', "Type|SoC Project\\ Difficulty|Advanced Wireless\\ Technology|Matter")

                qualityProp.set('key', 'core.quality')
                qualityProp.set('value', "PRODUCTION")
                description.text = "".join("This is a Matter " + demo_name_ +
                                        " Application over Thread for " + brd.upper())

        elif technology == 'WiFi':
            for board_type in val[technology].keys():
                for demo_ in val[technology][board_type]:
                    demo_name = ""
                    for name in demo_.split("-"):
                        if name == 'app':
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

                    print(demo_name)

                    imageFileProp.set('key', 'demos.imageFile')
                    if "soc" in board_type:
                        #exception for thermostat app name 
                        if demo_name=="thermostat":
                            demo_name = "SiWx917-thermostat-example"
                        demoFilename = demo_name.replace(' ','-') + ".rps"
                    else:
                        demoFilename = (("".join(demo_name+" "+board_type if 'thermostat' in demo_name else demo_name+" app"+" "+board_type)).replace(" ", "-") + ".s37")
                    imageFileProp.set('value', asset_prefix + os.path.join("demos", brd, technology, demoFilename))
                    readmeFileProp.set('key', 'core.readmeFiles')
                    readmeFileProp.set(
                        'value',  os.path.join("slc","sample-app", '-'.join([demo_name.replace(" ", "-").replace("SiWx917-","").replace("-example","").replace('.rps',''), 'app']) if 'thermostat' not in demo_name else "thermostat", ("siwx917" if "soc" in board_type else "efr32"),"README_WiFi.md"))

                    filtersProp.set('key', 'filters')
                    filtersProp.set('value', "Type|" + ("SoC" if "soc" in board_type else "NCP") + " Project\\ Difficulty|Advanced Wireless\\ Technology|Matter")

                    qualityProp.set('key', 'core.quality')
                    qualityProp.set('value', "PRODUCTION")
                    description.text = "".join("This is a Matter " + demo_name_ +
                                                " Application for " + brd.upper() #+ " to be used with Wi-Fi " +
                                                + (' with SiWx917 Wi-Fi SoC' if "soc" in board_type else (" to be used with Wi-Fi " + ('RS9116' if board_type == 'rs911x' else board_type.upper()))))

outputString = ET.tostring(demos, encoding='UTF-8')
dom = xml.dom.minidom.parseString(outputString)
pretty_xml_as_string = dom.toprettyxml()

demosXmlFilePath = os.path.join(root_dir, "matter_demos.xml")
with open(demosXmlFilePath, "w") as demosXmlFile:
    demosXmlFile.write(pretty_xml_as_string)
    print("Successfully generated",demosXmlFilePath)
