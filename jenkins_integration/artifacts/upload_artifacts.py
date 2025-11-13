"""
This script automates the process of downloading, extracting, and uploading build artifacts for Matter project workflows.

It interacts with GitHub Actions, UBAI, and Artifactory to:
- Determine the latest commit SHA and workflow run for a given branch or PR.
- Wait for build artifacts to be available from GitHub Actions workflows.
- Download and extract artifacts from GitHub.
- Upload individual and merged artifacts to UBAI and Artifactory.
- Check if artifacts are already present in UBAI to avoid redundant uploads.

Usage:
    python upload_artifacts.py --branch_name <branch> --build_number <build_number> --sqa <true|false> --commit_sha <sha>
    --workflow_id <workflow_id> --run_number <number>

Arguments:
    --branch_name   Name of the branch or PR (e.g., 'main', 'PR-123').
    --build_number  Jenkins Run Number (e.g., '2').
    --sqa           Boolean flag to indicate SQA builds (true/false).
    --commit_sha    Commit SHA to use (required for SQA).
    --workflow_id   Workflow id of the run (e.g. 19287668054).
    --run_number    Workflow run number (required for SQA).

Environment Variables:
    SL_USERNAME     Username for authentication with Artifactory/UBAI.
    SL_PASSWORD     Password for authentication with Artifactory/UBAI.

Dependencies:
    - requests
    - config.py (must define required URLs and headers)
    - ubai_upload_cli, ubai_search_cli (must be available in PATH, need to use GSDK docker image )
"""

import os
import sys

# Add the workspace root to Python path to enable importing internal modules
workspace_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if workspace_root not in sys.path:
    sys.path.insert(0, workspace_root)

from jenkins_integration.utils import parse_arguments, get_dev_workflow_info, artifacts_already_uploaded, process_artifacts


def main():
    """
    Main entry point for the artifact upload script.
    Orchestrates the artifact upload process by parsing arguments, determining workflow info,
    checking for existing artifacts, and coordinating the upload process.
    """
    args = parse_arguments()
    if not args.sqa:
        workflow_info = get_dev_workflow_info(args)
    else:
        workflow_info = {
            'commit_sha': args.commit_sha,
            'workflow_id': args.workflow_id,
            'branch_name': args.branch_name,
            'build_number': args.build_number,
        }
    if artifacts_already_uploaded(workflow_info, args.sqa):
        print("Merged artifacts file present in UBAI. Do not download and upload artifacts.")
        return
    process_artifacts(workflow_info, args.sqa)


if __name__ == '__main__':
    main()

