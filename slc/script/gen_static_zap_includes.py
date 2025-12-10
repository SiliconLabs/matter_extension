#!/usr/bin/env python3

# This script generates the matter_static_generated_zap_content.slcc file
# from the zzz_generated/app-common/clusters directory
# USAGE: python3 slc/script/gen_static_zap_includes.py

import os
import pathlib

# Get the root directory of the project
root = str(pathlib.Path(os.path.realpath(__file__)).parent.parent.parent)
os.chdir(root)

# Define the path to the clusters directory
clusters_dir_path = "third_party/matter_sdk/zzz_generated/app-common/clusters"

# Define the output slcc file path
output_slcc_path = "slc/component/sdk-content/zap/matter_static_generated_zap_content.slcc"

# Initialize the file content with the header section
filedata = []
filedata.append("category: Matter|Stack")
filedata.append("description: This component brings in statically-generated ZAP content for Matter")
filedata.append("id: matter_static_generated_zap_content")
filedata.append("label: Statically-generated ZAP content")
filedata.append("package: matter")
filedata.append("provides:")
filedata.append("  - name: matter_static_generated_zap_content")
filedata.append("quality: production")
filedata.append("metadata:")
filedata.append("  sbom:")
filedata.append("    license: Zlib")
filedata.append("ui_hints:")
filedata.append("    visibility: never")
filedata.append("include:")

# Add the top-level app-common directory entry first
filedata.append("  - path: third_party/matter_sdk/zzz_generated/app-common/")
filedata.append("    unless: [matter_zap_custom_generation]")

# Get all subdirectories in the clusters directory
cluster_subdirs = []
for item in os.listdir(clusters_dir_path):
    item_path = os.path.join(clusters_dir_path, item)
    # Only process directories, skip files like BUILD.gn and MetadataQuery.h
    if os.path.isdir(item_path):
        cluster_subdirs.append(item)

# Sort the subdirectories alphabetically for consistent output
cluster_subdirs.sort()

# Process each cluster subdirectory
for cluster_subdir in cluster_subdirs:
    cluster_path = os.path.join(clusters_dir_path, cluster_subdir)
    
    # Get all files in the cluster subdirectory
    files_in_cluster = []
    try:
        for file in os.listdir(cluster_path):
            file_path = os.path.join(cluster_path, file)
            # Only include files, not subdirectories
            # Exclude .gn files (BUILD.gn and other .gn files)
            if os.path.isfile(file_path) and not file.endswith('.gn'):
                files_in_cluster.append(file)
    except Exception as e:
        print(f"Error reading directory {cluster_path}: {e}")
        continue
    
    # Skip if no files found
    if len(files_in_cluster) == 0:
        continue
    
    # Sort files alphabetically
    files_in_cluster.sort()
    
    # Add the path entry for this cluster (without /clusters/<cluster_name>)
    filedata.append("  - path: third_party/matter_sdk/zzz_generated/app-common")
    filedata.append("    unless: [matter_zap_custom_generation]")
    filedata.append("    file_list:")
    
    # Add each file in the file_list with clusters/<cluster_name>/ prefix
    for file_name in files_in_cluster:
        filedata.append(f"      - path: clusters/{cluster_subdir}/{file_name}")

# Write the generated content to the output file
with open(output_slcc_path, 'w') as f:
    for line in filedata:
        f.write(line + '\n')

print(f"Successfully generated {output_slcc_path}")
print(f"Processed {len(cluster_subdirs)} cluster subdirectories")