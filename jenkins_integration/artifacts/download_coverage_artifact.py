"""
Download the lcov coverage artifact produced by the GitHub Actions workflow
'.github/workflows/coverage-builder.yaml' for a given workflow run.

If no matching artifact is present (expected for runs that are not main/release_*
with build-type=full), the script exits 0 with a clear message.

Usage:
    python download_coverage_artifact.py --workflow_id <id> [--dest_dir <dir>]

Environment variables:
    GITHUB_ACCESS_TOKEN     GitHub token used by jenkins_integration.config
"""

import argparse
import fnmatch
import os
import shutil
import sys

workspace_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if workspace_root not in sys.path:
    sys.path.insert(0, workspace_root)

import jenkins_integration.config as config
from jenkins_integration.github.github_workflow import _make_github_api_request
from jenkins_integration.artifacts.artifact_processor import _download_artifact, _extract_artifact


COVERAGE_ARTIFACT_GLOB = "lcov-report-*-coverage"


def _parse_args():
    parser = argparse.ArgumentParser(description="Download lcov coverage artifact from a GitHub Actions workflow run")
    parser.add_argument("--workflow_id", required=True, help="GitHub Actions workflow run id")
    parser.add_argument("--dest_dir", default="./coverage", help="Directory to extract the artifact into (default: ./coverage)")
    return parser.parse_args()


def _find_coverage_artifact(workflow_id):
    url = f"{config.actions_runs_base_url}/{workflow_id}/artifacts?per_page=100"
    print(f"Listing artifacts for workflow {workflow_id}: {url}")
    response = _make_github_api_request(url)
    artifacts = response.json().get("artifacts") or []
    for artifact in artifacts:
        if fnmatch.fnmatch(artifact.get("name", ""), COVERAGE_ARTIFACT_GLOB):
            return artifact
    print(f"[skip] no coverage artifact matching '{COVERAGE_ARTIFACT_GLOB}' found for workflow {workflow_id}. "
          f"Available: {[a.get('name') for a in artifacts]}")
    return None


def download_coverage_artifact(workflow_id, dest_dir):
    """
    Download and extract the lcov coverage artifact for the given workflow run.

    Returns the path to the directory the artifact was extracted into, or None
    if no coverage artifact is available for that workflow run.
    """
    artifact = _find_coverage_artifact(workflow_id)
    if artifact is None:
        return None

    artifact_name = artifact["name"] + ".zip"
    download_url = artifact["archive_download_url"]
    print(f"Found coverage artifact '{artifact['name']}' (id={artifact['id']}, size={artifact.get('size_in_bytes')})")

    artifact_file = _download_artifact(download_url, artifact_name)
    extracted_folder = _extract_artifact(artifact_file)

    os.makedirs(dest_dir, exist_ok=True)
    for entry in os.listdir(extracted_folder):
        src = os.path.join(extracted_folder, entry)
        dst = os.path.join(dest_dir, entry)
        if os.path.exists(dst):
            if os.path.isdir(dst):
                shutil.rmtree(dst)
            else:
                os.remove(dst)
        os.rename(src, dst)

    print(f"Coverage artifact extracted to: {dest_dir}")
    return dest_dir


def main():
    args = _parse_args()
    try:
        download_coverage_artifact(args.workflow_id, args.dest_dir)
    except Exception as exc:
        print(f"ERROR: failed to download coverage artifact: {exc}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
