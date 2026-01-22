#!/usr/bin/env python3

# This is a script to validate paths in matter_templats.xml
# Script is in initial development phase
# python3 slc/script/validate_matter_templates.py


import xml.etree.ElementTree as ET
import os 
import pathlib
import sys

def validate_matter_templates():
    Matter_Repo =  str(pathlib.Path(os.path.realpath(__file__)).parent.parent.parent)
    tree = ET.parse(os.path.join(Matter_Repo,'matter_templates.xml'))
    root = tree.getroot()
    file_data = []
    for descriptors in tree.findall('descriptors'):
        i = descriptors.findall('properties')
        for num in range(len(i)):
            if i[num].attrib["key"]=="solutionReferenceId":
                val = i[num].attrib['value'].replace(".","/").replace("/slc",".slc")
                if not os.path.isfile(val):
                    result = "Could not find file at path: "+i[num].attrib['value']
                    print(result)
                    file_data.append(result)
            elif i[num].attrib["key"]=="projectFilePaths":
                val = i[num].attrib['value']
                if not os.path.isfile(val):
                    result = "Could not find file at path: "+i[num].attrib['value']
                    print(result)
                    file_data.append(result)
            if i[num].attrib["key"]=="solutionProjects":
                lst = i[num].attrib['value'].split(" ")
                for j in lst:      
                    val = j.replace(".","/").replace("/slc",".slc")   
                    path = os.path.join(Matter_Repo,val)
                    if not os.path.isfile(path):
                        result = "Could not find file at path: "+j
                        print(result)
                        file_data.append(result)
            if i[num].attrib["key"]=="readmeFiles":
                val = i[num].attrib['value']
                path = os.path.join(val)
                if not os.path.isfile(path):
                    result = "Could not find file at path: "+i[num].attrib['value']
                    print(result)
                    file_data.append(result)
                    
    if len(file_data) == 0:
        print("All files found")
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == '__main__':
    validate_matter_templates()