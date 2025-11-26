"""
Artifact processing module.

This module handles all artifact processing operations including:
- Downloading artifacts from GitHub Actions
- Extracting artifact files
- Processing individual binary artifacts
- Managing artifact uploads to UBAI
"""

import os
import shutil
import sys
import zipfile
import re

# Add the workspace root to Python path to enable importing internal modules
workspace_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if workspace_root not in sys.path:
    sys.path.insert(0, workspace_root)

import jenkins_integration.config as config
from jenkins_integration.github.github_workflow import _make_github_api_request
from jenkins_integration.artifacts.ubai_client import upload_to_ubai
from jenkins_integration.artifacts.artifactory_client import upload_to_artifactory


def _get_matter_extension_version():
    """
    Extract the version from the matter.slce file.
    
    Returns:
        str: Version string from matter.slce file
        
    Raises:
        RuntimeError: If matter.slce file is not found or version cannot be parsed
    """
    matter_slce_path = os.path.join(workspace_root, 'matter.slce')
    
    if not os.path.exists(matter_slce_path):
        raise RuntimeError(f"matter.slce file not found at: {matter_slce_path}")
    
    try:
        with open(matter_slce_path, 'r') as file:
            content = file.read()
            
        version_match = re.search(r'^version:\s*([^\s]+)', content, re.MULTILINE)
        if version_match:
            version = version_match.group(1)
            print(f"Extracted Matter extension version: {version}")
            return version
        else:
            raise RuntimeError("Could not find version field in matter.slce")
            
    except Exception as e:
        raise RuntimeError(f"Error: {e}")


def _generate_artifactory_artifact_name(original_name):
    """
    Generate a custom artifact name for Artifactory uploads in the format extension.matter_<version>.
    
    Args:
        original_name (str): Original artifact name from GitHub Actions
        
    Returns:
        str: Custom artifact name for Artifactory (e.g., 'extension.matter_2.8.0.zip')
    """
    try:
        version = _get_matter_extension_version()
        extension = '.zip' if original_name.endswith('.zip') else ''
        artifactory_name = f"extension.matter_{version}{extension}"
        print(f"Generated Artifactory artifact name: {artifactory_name}")
        return artifactory_name
    except Exception as e:
        print(f"Warning: Failed to generate custom artifact name, using original: {e}")
        return original_name


def download_and_upload_artifacts(workflow_id, branch_name, build_number, sqa=False):
    """
    Download artifacts from GitHub Actions and upload them to UBAI and Artifactory.
    
    Args:
        workflow_id (int): Workflow run ID to download artifacts from.
        branch_name (str): Branch name for artifacts.
        build_number (int): Build number for artifacts.
        sqa (bool): Whether to upload SQA artifacts (default: False).
        
    Raises:
        ValueError: If parameters are invalid
        RuntimeError: If downloading or uploading fails
    """
    _validate_artifact_parameters(workflow_id, branch_name, build_number)
    print(f"Starting artifact download and upload process for workflow {workflow_id}")
    try:
        artifact_info = _download_and_extract_artifacts(workflow_id, sqa)
        print("Uploading individual artifacts to UBAI.")
        _upload_individual_artifacts(artifact_info['extracted_folder'], branch_name, build_number, sqa)
        print("Uploading merged artifacts to UBAI and Artifactory.")
        _upload_merged_artifacts(artifact_info['artifact_file'], artifact_info['artifact_name'], 
                               branch_name, build_number, sqa)
        print("Artifact download and upload process completed successfully.")
    except Exception as e:
        print(f"Error during artifact processing: {e}")
        raise RuntimeError(f"Failed to process artifacts: {e}")


def upload_binaries_individually_to_ubai(binaries_folder, branch_name, build_number, sqa):
    """
    Upload individual binary files from the extracted artifact folder to UBAI.
    
    Args:
        binaries_folder (str): Path to the folder containing binaries.
        branch_name (str): Branch name for the upload.
        build_number (int): Build number for the upload.
        sqa (bool): Bool to indicate if artifacts are sqa
    Raises:
        ValueError: If parameters are invalid
        RuntimeError: If upload fails
    """
    _validate_binaries_upload_parameters(binaries_folder, branch_name, build_number)
    print(f"Starting individual binary uploads")
    
    try:
        for artifact in os.listdir(binaries_folder):
            artifact_path = os.path.join(binaries_folder, artifact)
            print(f"Processing artifact: {artifact}")
            _process_individual_artifact(artifact, artifact_path, branch_name, build_number, sqa)
        print("Individual binary uploads completed successfully.")
    except Exception as e:
        error_msg = f"Failed to upload individual binaries: {e}"
        print(error_msg)
        raise RuntimeError(error_msg)


def _validate_artifact_parameters(workflow_id, branch_name, build_number):
    """
    Validate input parameters for artifact processing.
    
    Args:
        workflow_id (int): Workflow run ID
        branch_name (str): Branch name
        build_number (int): Build number
        
    Raises:
        ValueError: If any parameter is invalid
    """
    if not workflow_id or int(workflow_id) <= 0:
        raise ValueError("Workflow ID must be a positive integer")
    if not branch_name or not branch_name.strip():
        raise ValueError("Branch name cannot be empty")
    if not build_number or int(build_number) <= 0:
        raise ValueError("Run number must be a positive integer")


def _download_and_extract_artifacts(workflow_id, sqa=False):
    """
    Download artifacts from GitHub Actions and extract them locally.
    
    Args:
        workflow_id (int): Workflow run ID to download artifacts from
        sqa (bool): Whether to upload SQA artifacts (true/false).
    Returns:
        dict: Information about the downloaded and extracted artifacts
        
    Raises:
        RuntimeError: If downloading or extraction fails
    """
    artifact_info = _get_artifact_info(workflow_id, sqa)
    artifact_file = _download_artifact(artifact_info['download_url'], artifact_info['name'])
    extracted_folder = _extract_artifact(artifact_file)
    return {
        'artifact_file': artifact_file,
        'artifact_name': artifact_info['name'],
        'extracted_folder': extracted_folder
    }


def _get_artifact_info(workflow_id, sqa):
    """
    Get artifact information from GitHub Actions API.
    
    Args:
        workflow_id (int): Workflow run ID
        sqa (bool): Indicate if we are looking for SQA artifacts.
    Returns:
        dict: Artifact information containing download_url and name
        
    Raises:
        RuntimeError: If API request fails or no artifacts found
    """
    workflow_artifact_url = f"{config.actions_runs_base_url}/{workflow_id}/artifacts"
    print(f"Fetching artifacts from URL: {workflow_artifact_url}")
    response = _make_github_api_request(workflow_artifact_url)
    artifacts_data = response.json()
    if not artifacts_data.get('artifacts'):
        raise RuntimeError(f"No artifacts found for workflow {workflow_id}")
    if not sqa:
        artifact = artifacts_data['artifacts'][0]
    else:
        artifact = artifacts_data['artifacts'][1]
    return {
        'download_url': artifact['archive_download_url'],
        'name': artifact['name'] + '.zip'
    }


def _download_artifact(download_url, artifact_name):
    """
    Download an artifact from GitHub Actions.
    
    Args:
        download_url (str): URL to download the artifact from
        artifact_name (str): Name of the artifact file
        
    Returns:
        str: Path to the downloaded artifact file
        
    Raises:
        RuntimeError: If download fails
    """
    print(f"Downloading artifact {artifact_name} from URL: {download_url}")
    
    # Clean up existing files/folders before downloading
    artifact_file = os.path.join('.', artifact_name)
    extracted_folder = os.path.join('.', artifact_name.replace('.zip', ''))
    
    # Delete existing artifact file if it exists
    if os.path.exists(artifact_file):
        print(f"Removing existing artifact file: {artifact_file}")
        os.remove(artifact_file)
    
    # Delete existing extracted folder if it exists
    if os.path.exists(extracted_folder):
        print(f"Removing existing extracted folder: {extracted_folder}")
        shutil.rmtree(extracted_folder)
    
    response = _make_github_api_request(download_url)
    with open(artifact_file, 'wb') as f:
        f.write(response.content)
    print(f"Successfully downloaded {artifact_name}")
    return artifact_file


def _extract_artifact(artifact_file):
    """
    Extract a downloaded artifact ZIP file.
    
    Args:
        artifact_file (str): Path to the artifact ZIP file
        
    Returns:
        str: Path to the extracted folder
        
    Raises:
        RuntimeError: If extraction fails
    """
    artifact_name = os.path.basename(artifact_file)
    extracted_folder = os.path.join('.', artifact_name.replace('.zip', ''))
    print(f"Extracting {artifact_name} to {extracted_folder}")
    try:
        os.makedirs(extracted_folder, exist_ok=True)
        with zipfile.ZipFile(artifact_file, 'r') as zip_ref:
            zip_ref.extractall(extracted_folder)
        print(f"Successfully extracted {artifact_name}")
        return extracted_folder
    except Exception as e:
        raise RuntimeError(f"Failed to extract {artifact_name}: {e}")


def _upload_individual_artifacts(extracted_folder, branch_name, build_number, sqa):
    """
    Upload individual binary artifacts to UBAI.
    
    Args:
        extracted_folder (str): Path to the extracted artifacts folder
        branch_name (str): Branch name for the upload
        build_number (int): Build number for the upload
        sqa (bool): Bool to indicate if artifacts are sqa
    Raises:
        RuntimeError: If upload fails
    """
    try:
        upload_binaries_individually_to_ubai(extracted_folder, branch_name, build_number, sqa)
    except Exception as e:
        raise RuntimeError(f"Failed to upload individual artifacts: {e}")


def _upload_merged_artifacts(artifact_file, artifact_name, branch_name, build_number, sqa=False):
    """
    Upload the merged artifact to both UBAI and Artifactory.
    
    Args:
        artifact_file (str): Path to the artifact file
        artifact_name (str): Name of the artifact
        branch_name (str): Branch name for the upload
        build_number (int): Build number for the upload

    Raises:
        RuntimeError: If upload fails
    """
    try:
        upload_to_ubai(
            file_path=artifact_file,
            app_name="matter",
            stack="matter",
            target="matter",
            branch_name=branch_name,
            build_number=build_number
        )
        if not sqa:
            artifactory_artifact_name = _generate_artifactory_artifact_name(artifact_name)
            upload_to_artifactory(artifact_file, artifactory_artifact_name, branch_name, str(build_number))
    except Exception as e:
        raise RuntimeError(f"Failed to upload merged artifacts: {e}")


def _validate_binaries_upload_parameters(binaries_folder, branch_name, build_number):
    """
    Validate input parameters for binary uploads.
    
    Args:
        binaries_folder (str): Path to the binaries folder
        branch_name (str): Branch name
        build_number (int): Build number
        
    Raises:
        ValueError: If any parameter is invalid
    """
    if not binaries_folder or not os.path.exists(binaries_folder):
        raise ValueError(f"Binaries folder does not exist: {binaries_folder}")
    if not os.path.isdir(binaries_folder):
        raise ValueError(f"Binaries folder must be a directory: {binaries_folder}")
    if not branch_name or not branch_name.strip():
        raise ValueError("Branch name cannot be empty")
    if not build_number or int(build_number) <= 0:
        raise ValueError("Run number must be a positive integer")


def _process_individual_artifact(artifact_name, artifact_path, branch_name, build_number, sqa):
    """
    Process an individual artifact based on its type.
    
    Args:
        artifact_name (str): Name of the artifact
        artifact_path (str): Path to the artifact
        branch_name (str): Branch name for upload
        build_number (int): Build number for upload
        sqa (bool): Bool to indicate if artifacts are sqa
    """
    if artifact_name == "chip-tool":
        _upload_chip_tool(artifact_path, branch_name, build_number)
    elif artifact_name == "chip-ota-provider-app":
        _upload_chip_ota_provider(artifact_path, branch_name, build_number)
    elif artifact_name == "provision.zip":
        _upload_provision_zip(artifact_path, branch_name, build_number)
    elif artifact_name == "ota-scripts.zip":
        _upload_ota_scripts(artifact_path, branch_name, build_number)
    elif os.path.isdir(artifact_path):
        if artifact_name == "WiFi-Firmware":
            _upload_wifi_firmware(artifact_path, branch_name, build_number)
        else:
            _upload_board_artifacts(artifact_name, artifact_path, branch_name, build_number, sqa)


def _upload_chip_tool(artifact_path, branch_name, build_number):
    """Upload chip-tool artifact to UBAI."""
    print("Uploading chip-tool to UBAI.")
    upload_to_ubai(artifact_path, "Chiptool", "linux-arm64-ipv6only-clang", branch_name, build_number)


def _upload_chip_ota_provider(artifact_path, branch_name, build_number):
    """Upload chip-ota-provider-app artifact to UBAI."""
    print("Uploading chip-ota-provider-app to UBAI.")
    upload_to_ubai(artifact_path, "OTA", "linux-arm64-ipv6only-clang", branch_name, build_number)


def _upload_provision_zip(artifact_path, branch_name, build_number):
    """Upload provision.zip artifact to UBAI."""
    print("Uploading provision to UBAI.")
    upload_to_ubai(artifact_path, "matter_provision", "matter", branch_name, build_number)


def _upload_ota_scripts(artifact_path, branch_name, build_number):
    """Upload ota-scripts.zip artifact to UBAI."""
    print("Uploading ota-scripts to UBAI.")
    upload_to_ubai(artifact_path, "matter", "matter", branch_name, build_number)


def _upload_wifi_firmware(wifi_firmware_path, branch_name, build_number):
    """
    Upload Wi-Fi firmware artifacts to UBAI.

    Args:
        wifi_firmware_path (str): Path to the WiFi-Firmware directory
        branch_name (str): Branch name for upload
        build_number (int): Build number for upload
    """
    print("Processing WiFi-Firmware artifacts.")
    for board_folder in os.listdir(wifi_firmware_path):
        board_path = os.path.join(wifi_firmware_path, board_folder)
        if os.path.isdir(board_path):
            _upload_wifi_firmware_files(board_path, board_folder, branch_name, build_number)


def _upload_wifi_firmware_files(board_path, board_folder, branch_name, build_number):
    """
    Upload Wi-Fi firmware files for a specific board.

    Args:
        board_path (str): Path to the board directory
        board_folder (str): Board folder name
        branch_name (str): Branch name for upload
        build_number (int): Build number for upload
    """
    ubai_app_name = f"WiFi-Firmware-{board_folder}"
    for dirpath, _, filenames in os.walk(board_path):
        for fw_file in filenames:
            if fw_file.endswith('.rps'):
                fw_file_path = os.path.join(dirpath, fw_file)
                print(f"Uploading WiFi firmware: {fw_file_path}")
                upload_to_ubai(fw_file_path, ubai_app_name, board_folder, branch_name, build_number)


def _upload_board_artifacts(board_id, board_path, branch_name, build_number, sqa):
    """
    Upload board-specific artifacts to UBAI.

    Args:
        board_id (str): Board identifier
        board_path (str): Path to the board directory
        branch_name (str): Branch name for upload
        build_number (int): Build number for upload
        sqa (bool): Bool to indicate if artifacts are sqa
    """
    board_id_upper = board_id.upper()
    print(f"Processing board ID: {board_id_upper}")
    for app_name_folder in os.listdir(board_path):
        app_name_path = os.path.join(board_path, app_name_folder)
        print(f"Sample App Path: {app_name_path}")
        if os.path.isdir(app_name_path):
            _process_board_app(app_name_folder, app_name_path, board_id_upper, branch_name, build_number, sqa)


def _process_board_app(app_name_folder, app_name_path, board_id, branch_name, build_number, sqa):
    """
    Process a board application and upload its artifacts.

    Args:
        app_name_folder (str): Application folder name
        app_name_path (str): Path to the application directory
        board_id (str): Board identifier
        branch_name (str): Branch name for upload
        build_number (int): Build number for upload
        sqa (bool): Bool to indicate if artifacts are sqa
    """
    app_info = _determine_app_info(app_name_folder, board_id, sqa)
    print(f"Sample App Name: {app_info['app_name']}")
    artifact_folder = os.path.join(app_name_path, 'artifact')
    if os.path.exists(artifact_folder) and os.path.isdir(artifact_folder):
        _upload_board_artifact_files(artifact_folder, app_info, board_id, branch_name, build_number)


def _determine_app_info(app_name_folder, board_id, sqa):
    """
    Determine application information based on folder name.

    Args:
        app_name_folder (str): Application folder name
        board_id (str): Board identifier
        sqa (bool): Bool to indicate if artifacts are sqa
    Returns:
        dict: Application information containing app_name and app_type
    """
    board_id = board_id.split(",")[0] # Handles 1019A 3MB BRD1019A,SIMG301M113WIH
    if "series-" in app_name_folder:
        app_name = f"{board_id}-OpenThread"
    else:
        app_name = f"{board_id}-WiFi"
    app_type = None
    # Default zigbee-matter-light app which is concurrent.
    if "zigbee-matter-light" in app_name_folder and "sequential" not in app_name_folder:
        app_type = "concurrent"
    if app_name_folder.split("solution")[1] is not None:
        folder_app_name = app_name_folder.split("solution")[0].split("-series")[0]
        app_name_suffix = app_name_folder.split("solution")[1]
        cmp_apps = ["zigbee-matter-light", "thermostat"]
        if folder_app_name in cmp_apps and "sequential" in app_name_suffix:
            app_type = "sequential"
            app_name_suffix = app_name_suffix.split("sequential")[1]
        elif folder_app_name in cmp_apps and "cmp-concurrent" in app_name_suffix:
            app_type = "concurrent"
            app_name_suffix = app_name_suffix.split("cmp-concurrent")[1]
        elif folder_app_name in cmp_apps and "concurrent-listening" in app_name_suffix:
            app_type = "concurrent-listening"
        elif "lto" in app_name_suffix:
            app_type = "lto"
            app_name_suffix = app_name_suffix.split("lto")[1]
        elif "icd" in app_name_suffix:
            app_type = "icd"
            app_name_suffix = app_name_suffix.split("icd")[1]
        elif "brd4357a" in app_name_suffix:
            app_type = "brd4357a"
            app_name_suffix = app_name_suffix.split("brd4357a")[1]
        elif "trustzone" in app_name_suffix:
            app_type = "trustzone"
            app_name_suffix = app_name_suffix.split("trustzone")[1]
        if sqa:
            app_name = f"{app_name}{app_name_suffix}"
    return {
            'app_name': app_name,
            'app_type': app_type
        }


def _upload_board_artifact_files(artifact_folder, app_info, board_id, branch_name, build_number):
    """
    Upload board artifact files to UBAI.

    Args:
        artifact_folder (str): Path to the artifact folder
        app_info (dict): Application information
        board_id (str): Board identifier
        branch_name (str): Branch name for upload
        build_number (int): Build number for upload
    """
    board_id = board_id.split(",")[0]  # Handles 1019A 3MB BRD1019A,SIMG301M113WIH
    for file_name in os.listdir(artifact_folder):
        file_path = os.path.join(artifact_folder, file_name)
        if os.path.isfile(file_path) and file_name.endswith(('.s37', '.rps')):
            if app_info['app_type'] is not None:
                name_part, ext = file_name.rsplit('.', 1)
                new_file_name = f"{name_part}-{app_info['app_type']}.{ext}"
            else:
                new_file_name = file_name
            new_file_path = os.path.join(artifact_folder, new_file_name)
            os.rename(file_path, new_file_path)
            print(f"Renamed file {file_name} to {new_file_name}.")
            upload_to_ubai(new_file_path, app_info['app_name'], board_id, branch_name, build_number)

def _extract_sample_app_name(file_name):
    """
    Extract the sample app name from the file name.
    
    Args:
        file_name (str): Original file name
        
    Returns:
        str: Extracted sample app name
    """
    if "series-" in file_name:
        return file_name.split("-series")[0]
    else:
        return file_name 