"""
Artifactory client module.

This module handles all Artifactory operations including:
- Uploading artifacts to Artifactory
- Managing Artifactory URLs and authentication
- Handling release vs development branch uploads
"""

import requests
import os
import sys
from urllib.parse import quote

# Add the workspace root to Python path to enable importing internal modules
workspace_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if workspace_root not in sys.path:
    sys.path.insert(0, workspace_root)

import jenkins_integration.config as config


def upload_to_artifactory(filepath, artifact_name, branch_name, build_number):
    """
    Upload an artifact file to Artifactory.
    
    Args:
        filepath (str): Path to the artifact file.
        artifact_name (str): Name of the artifact.
        branch_name (str): Branch name for the artifact.
        build_number (str): Build number for the artifact.
        
    Returns:
        str: The download URI of the uploaded artifact
        
    Raises:
        ValueError: If parameters are invalid
        RuntimeError: If upload fails
        FileNotFoundError: If the artifact file doesn't exist
    """
    _validate_artifactory_parameters(filepath, artifact_name, branch_name, build_number)
    print(f"Uploading {artifact_name} to Artifactory for branch {branch_name}, build {build_number}")
    
    try:
        artifactory_url = _construct_artifactory_url(branch_name, build_number, artifact_name)
        response = _perform_artifactory_upload(filepath, artifactory_url)
        download_uri = response.json()['downloadUri']
        print(f"Successfully uploaded to Artifactory: {download_uri}")
        return download_uri
    except Exception as e:
        error_msg = f"Failed to upload {artifact_name} to Artifactory: {e}"
        print(error_msg)
        raise RuntimeError(error_msg)


def _validate_artifactory_parameters(filepath, artifact_name, branch_name, build_number):
    """
    Validate input parameters for Artifactory upload.
    
    Args:
        filepath (str): Path to the artifact file
        artifact_name (str): Name of the artifact
        branch_name (str): Branch name for the artifact
        build_number (str): Build number for the artifact
        
    Raises:
        ValueError: If any parameter is invalid
        FileNotFoundError: If the artifact file doesn't exist
    """
    if not filepath or not filepath.strip():
        raise ValueError("Filepath cannot be empty")
    
    if not os.path.exists(filepath):
        raise FileNotFoundError(f"Artifact file not found: {filepath}")
    
    if not os.path.isfile(filepath):
        raise ValueError(f"Filepath must be a file, not a directory: {filepath}")
    
    if not artifact_name or not artifact_name.strip():
        raise ValueError("Artifact name cannot be empty")
    
    if not branch_name or not branch_name.strip():
        raise ValueError("Branch name cannot be empty")
    
    if not build_number or not str(build_number).strip():
        raise ValueError("Build number cannot be empty")


def _construct_artifactory_url(branch_name, build_number, artifact_name):
    """
    Construct the Artifactory URL for uploading the artifact.
    
    Args:
        branch_name (str): Branch name for the artifact
        build_number (str): Build number for the artifact
        artifact_name (str): Name of the artifact
        
    Returns:
        str: The encoded Artifactory URL
    """
    if _is_release_branch(branch_name):
        base_url = config.artifact_upload_path_release
    else:
        base_url = config.artifact_upload_path_dev
    
    artifactory_url = f"{base_url}{branch_name}/{build_number}/{artifact_name}"
    encoded_url = quote(artifactory_url, safe=':/')
    print(f"Constructed Artifactory URL: {encoded_url}")
    return encoded_url


def _is_release_branch(branch_name):
    """
    Check if the branch is a release branch.
    
    Args:
        branch_name (str): Branch name to check
        
    Returns:
        bool: True if the branch name contains 'release_' or is 'main', False otherwise
    """
    return "release_" in branch_name or branch_name == "main"


def _perform_artifactory_upload(filepath, artifactory_url):
    """
    Perform the actual upload to Artifactory.
    
    Args:
        filepath (str): Path to the file to upload
        artifactory_url (str): The Artifactory URL to upload to
        
    Returns:
        requests.Response: The response from Artifactory
        
    Raises:
        RuntimeError: If the upload fails
    """
    username = os.environ.get("SL_USERNAME")
    password = os.environ.get("SL_PASSWORD")
    if not username or not password:
        raise RuntimeError("SL_USERNAME and SL_PASSWORD environment variables must be set")
    
    print(f"Uploading file {filepath} to Artifactory")
    try:
        with open(filepath, 'rb') as file_data:
            response = requests.put(
                artifactory_url,
                headers=config.artifactory_headers,
                data=file_data,
                auth=(username, password)
            )
    except Exception as e:
        raise RuntimeError(f"Failed to read or upload file: {e}")
    
    if response.status_code != 201:
        error_msg = (f"Artifactory upload failed. Status: {response.status_code}, "
                    f"Response: {response.text}")
        print(error_msg)
        raise RuntimeError(error_msg)
    
    return response 