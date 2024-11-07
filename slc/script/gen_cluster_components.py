#!/usr/bin/env python3

#This script is creates cluster components from the src/app/clusters directory
#USAGE : python3 slc/script/gen_cluster_components.py


import os
import pathlib
import shutil
import json
import yaml

root  = str(pathlib.Path(os.path.realpath(__file__)).parent.parent.parent)
os.chdir(root)
cluster_dir_path = "third_party/matter_sdk/src/app/clusters"
cluster_xml_path = ["third_party/matter_sdk/src/app/zap-templates/zcl/data-model/chip"] 

# Create a dictionary of all the clusters from Cluster_Dir_Path with the headers, source files,
# and if it is a server cluster or not
cluster_data = {}

subdirs = os.listdir(cluster_dir_path)

for subdir in subdirs:
    headers = []
    sources = []
    clustercomponentname = ""
    clustername = ""
    clientOrServer = ""

    for file in os.listdir(os.path.join(cluster_dir_path, subdir)):
        # Check if the file is a header file
        if file.endswith(".h") or file.endswith(".hpp") or file.endswith(".ipp"):
            headers.append(file)
        # Check if the file is a source file
        elif file.endswith(".c") or file.endswith(".cpp"):
            sources.append(os.path.join(cluster_dir_path, subdir, file))
        
        # Replace hyphens with underscores in the subdirectory name to form the cluster component name
        clustercomponentname = subdir.replace("-", "_")
        clustername = clustercomponentname
        
        # Determine if the cluster is a server or client
        if "server" in clustercomponentname:
            clientOrServer = " Server"
            clustername = clustercomponentname.replace("_server", "")
        if "client" in clustername:
            clientOrServer = " Client"
            clustername = clustercomponentname.replace("_client", "")
        
        # Set the include path for the cluster
        include = os.path.join(cluster_dir_path, subdir)

    # If a cluster component name is found and there are source or header files
    if clustercomponentname != "":
        if len(sources) + len(headers) > 0:
            # Populate the cluster data dictionary with the relevant information
            cluster_data[clustercomponentname] = {}
            cluster_data[clustercomponentname]["clustername"] = clustername
            cluster_data[clustercomponentname]["headers"] = headers
            cluster_data[clustercomponentname]["include"] = include
            cluster_data[clustercomponentname]["sources"] = sources
            cluster_data[clustercomponentname]["clientOrServer"] = clientOrServer

# Get the categories of clusters through the chip data
# Create list of clusternames
clusternames = []
for clustercomponentname in cluster_data.keys():
    # Append each cluster name to the clusternames list
    clusternames.append(cluster_data[clustercomponentname]["clustername"])

namecategories = {}
#create dictionary with categories and names mapped to clustername
for xml_path in cluster_xml_path:
    for xmlfile in os.listdir(xml_path):
        filename = xmlfile.split(".")[0]

        # Handle special cases for filename differences
        if "ota" in filename:
            clustername = "ota_requestor"
        elif "occupancy" in filename:
            clustername = "occupancy_sensor"
        elif "test" in filename:
            clustername = "test_cluster"
        elif "scene" in filename:
            clustername = "scenes"
        elif "onoff" in filename:
            clustername = "on_off"
        elif "binding" in filename:
            clustername = "bindings"
        elif "laundry-washer" in filename:
            clustername = "laundry_washer_controls"
        else:
            # Replace specific substrings to standardize the cluster name
            clustername = filename.replace("-cluster", "").replace("-", "_")

        # Skip if the clustername is not in the clusternames list
        if clustername not in clusternames:
            continue

        # Construct the full file path
        filepath = os.path.join(root, xml_path, xmlfile)
        with open(filepath) as f:
            data = f.read()
            content = data.split("\n")
            category = ""
            name = ""
            for line in content:
                # Extract the category from the <domain> tag
                if "<domain>" in line:
                    category = line.split("<domain>")[-1].split("<")[0]
                    # Standardize the category if it contains "Measurement"
                    if "Measurement" in category:
                        category = "Measurement"
                # Extract the name from the <name> tag
                if "<name>" in line:
                    name = line.split("<name>")[-1].split("<")[0]
            # If both category and name are found, store them in the dictionary
            if category != "" and name != "":
                if "ota" in clustername:
                    namecategories[clustername] = {}
                    namecategories[clustername]["category"] = category
                    namecategories[clustername]["name"] = name
                    clustername = "ota_provider"
                    namecategories[clustername] = {}
                    namecategories[clustername]["category"] = category
                    namecategories[clustername]["name"] = name.replace("Requestor", "Provider")
                else:
                    namecategories[clustername] = {}
                    namecategories[clustername]["category"] = category
                    namecategories[clustername]["name"] = name
            else :
                namecategories[clustername] = {}
                namecategories[clustername]["category"] = "General"
                namecategories[clustername]["name"] = clustername

#add category and name from xml to the cluster_data           
#For the except condition check the name of the xml files and update the above loop to match clustername
for clustercomponentname in cluster_data.keys():
    try:
        clustername = cluster_data[clustercomponentname]["clustername"]
        cluster_data[clustercomponentname]["category"] = namecategories[clustername]["category"]
        cluster_data[clustercomponentname]["name"] = namecategories[clustername]["name"]
    except:
        print("xml not found for", clustercomponentname)
# Create slcc from the cluster_data dictionary
component_dir = os.path.join(root, "slc", "component", "matter-clusters")


for clustercomponentname in sorted(cluster_data.keys()):
    filedata = [""]
    clustername = cluster_data[clustercomponentname]["clustername"]
    try:
        # Special cases for filename differences
        if "client" in clustername:
            category = cluster_data[clustername.replace("_client", "")]["category"]
        else:
            category = cluster_data[clustercomponentname]["category"]
    except:
        category = "General"
    
    category_str = "category: Clusters|{}".format(category)
    filedata.append(category_str)
    try:
        name = cluster_data[clustercomponentname]["name"].replace("_", " ").replace("matter ", "")
    except:
        name = clustername.replace("_", " ").replace("matter ", "").title()
    if "ota" in clustername:
        name = name.replace('Ota', 'OTA')
    
    label = "{}{} Cluster".format(name, cluster_data[clustercomponentname]['clientOrServer'])
    description = "description: >\n  Implementation of the {}.".format(label)
    description += f"\n  The user has to enable the {label} in the ZCL Advanced Platform (ZAP) tool in order to enable this functionality."
    filedata.append(description)
    
    if cluster_data[clustercomponentname]['clientOrServer'] == " Client":
        clustername = clustername + "_client"

    #get data from current SLCC file
    component_location = os.path.join(component_dir, "matter_{}.slcc".format(clustername))
    includes = []
    source_data = []
    defines = []
    try:
        with open(component_location, 'r') as file:
            content = yaml.safe_load(file)
        # Extract the required sections
        current_source_data = content.get('source', [])
        current_include_data = content.get('include', [])
        current_define_data = content.get('define', [])

        #merge with extracted source and include data and remove duplicates
        for path in current_source_data:
            source_data.append(path["path"])
        if len(current_include_data)>1:
            include = {}
            for i in range(len(current_include_data)):
                if current_include_data[i]["path"] not in cluster_data[clustercomponentname]["include"]:
                    headers = []
                    for header in current_include_data[i]["file_list"]:
                        headers.append(header["path"])
                    include = {"path": current_include_data[i]["path"], "file_list": headers}
                    includes.append(include)
        
        #merge with extracted define data and remove duplicates
        for define in current_define_data:
            df = {}
            df["name"] = define["name"]
            df["value"] = define["value"]
            defines.append(df)
        os.remove(component_location)
    except Exception as e:
        print("EXCEPTION for component ", e , component_location)

    source_data = list(set(source_data + cluster_data[clustercomponentname]["sources"]))
    if len(cluster_data[clustercomponentname]["headers"]) > 0:
        include = {"path": cluster_data[clustercomponentname]["include"], "file_list": cluster_data[clustercomponentname]["headers"]}
        includes.append(include)
    current_define_data = []
    
    id_str = "matter_" + clustername
    id = "id: {}".format(id_str)
    filedata.append(id)
    filedata.append("package: Matter")
    
    label_str = "label: {}".format(label)
    filedata.append(label_str)
    # special case as only component with experimental quality
    if clustername == "scenes":
        filedata.append("quality: experimental")
    else:
        filedata.append("quality: production")

    filedata.append("metadata:")
    filedata.append("  sbom:")
    filedata.append('    license: "Apache 2.0"')
    filedata.append("provides:")
    provides = "  - name: {}".format(id_str)
    filedata.append(provides)

    if len(source_data) > 0:
        filedata.append("source:")
        for src in sorted(source_data,key=str.casefold):
            path = "  - path: {}".format(src)
            filedata.append(path)

    if len(includes) > 0:
        filedata.append("include:")
        for include in includes:
            path = "  - path: {}".format(include["path"])
            filedata.append(path)
            filedata.append("    file_list:")
            for header in sorted(include["file_list"],key=str.casefold):
                path = "      - path: {}".format(header)
                filedata.append(path)

    filedata.append("template_contribution:")
    filedata.append("  - name: component_catalog")
    value = "    value: {}".format(id_str)
    filedata.append(value)

    if defines != []:
        filedata.append("define:")
        for define in defines:
            name = "  - name: {}".format(define["name"])
            filedata.append(name)
            filedata.append("    value: {}".format(define["value"]))

    with open(component_location, 'w') as f:
        f.write("\n".join(filedata))
        # print("created = ","slc/component/matter-clusters/{}.slcc".format(clustername))

print("Cluster components created successfully.")

# Create the cluster-to-component-dependencies.json
jsonfilepath = os.path.join(root, "src/app/zap-templates/cluster-to-component-dependencies.json")
lst = []

# Iterate over each cluster component name in the cluster_data dictionary
for clustercomponentname in sorted(cluster_data.keys()):
    # Initialize an empty dictionary to store the dependencies for the current cluster component
    dependanciesDic = {}
    
    # Get the cluster name for the current cluster component
    clustername = cluster_data[clustercomponentname]["clustername"]
    
    try:
        # Try to get the cluster code by converting the name to lowercase
        clusterCode = cluster_data[clustercomponentname]["name"].lower()
    except:
        # If an exception occurs, generate the cluster code by replacing parts of the cluster name
        clusterCode = clustername.replace("matter_", "")
        clusterCode = clusterCode.replace("_", " ")
    
    # Determine if the cluster is a server or client and adjust the cluster code accordingly
    if cluster_data[clustercomponentname]["clientOrServer"] == "" or cluster_data[clustercomponentname]["clientOrServer"] == " Server":
        clusterCode = clusterCode + "-server"
    else:
        clusterCode = clusterCode + "-client"
        clustername = clustername + "_client"
    
    # Create the value string for the dependency
    value_str = "%extension-matter%matter_" + clustername
    
    # Special case handling for OTA requestor
    if "matter_ota_requestor" in value_str:
        clusterCode = clusterCode.replace("provider", "requestor")
    
    # Add the cluster code and value to the dependencies dictionary
    dependanciesDic["clusterCode"] = clusterCode
    value = [value_str]
    dependanciesDic["value"] = value
    
    # Append the dependencies dictionary to the list
    lst.append(dependanciesDic)

# Convert the list of dependencies to a JSON object with indentation for readability
json_object = json.dumps(lst, indent=2)

# Write the JSON object to the specified file
with open(jsonfilepath, "w") as outfile:
    outfile.write(json_object)

print("Cluster-to-component-dependencies.json created successfully.")

# Load the JSON file
matter_sdk_zcl_file_path = "third_party/matter_sdk/src/app/zap-templates/zcl/zcl.json"
matter_extension_zcl_file_path = "src/app/zap-templates/zcl/zcl.json"
with open(matter_sdk_zcl_file_path, 'r') as file:
    data = json.load(file)

# Update paths in the list
data['xmlRoot'] = [f"./../../../../third_party/matter_sdk/src/app/zap-templates/zcl/{path.replace('./','')}" for path in data['xmlRoot']]

# Update manufacturersXml path
data['manufacturersXml'] = "../../../../third_party/matter_sdk/" + data['manufacturersXml'].split('./')[-1]

# Write the updated JSON back to the file
with open(matter_extension_zcl_file_path, 'w') as file:
    json.dump(data, file, indent=4)

print("Updated zcl.json file successfully.")