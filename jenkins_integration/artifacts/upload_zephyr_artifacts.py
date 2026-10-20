"""
Download Build Zephyr artifacts from GitHub Actions and upload board binaries to UBAI.

Expects GHA layout (see build-zephyr.yaml):
    <app_name>/<TARGET>/<binary_name>.<ext>
        -> UBAI Name=<binary_name>, app_name="", target=<TARGET>

Add another app by exporting under a new <app_name>/ tree in the workflow; no
uploader changes required.

Usage:
    python upload_zephyr_artifacts.py --branch_name <branch> --build_number <n>
"""

import argparse
import os
import shutil
import sys
import time
import zipfile
from urllib.parse import quote

workspace_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if workspace_root not in sys.path:
    sys.path.insert(0, workspace_root)

import jenkins_integration.config as config
from jenkins_integration.github.github_workflow import _make_github_api_request
from jenkins_integration.artifacts.ubai_client import upload_to_ubai

ARTIFACT_NAME = 'dev-artifacts-zephyr'
WORKFLOW_NAME = 'Build Zephyr'
WAIT_ATTEMPTS = 20
WAIT_SECONDS = 60


def _parse_args():
    parser = argparse.ArgumentParser(description='Upload Build Zephyr binaries to UBAI')
    parser.add_argument('--branch_name', required=True)
    parser.add_argument('--build_number', required=True)
    return parser.parse_args()


def _matches_zephyr_run(run, branch_name, pr_number, pr_head=None):
    if run.get('name') != WORKFLOW_NAME:
        return False
    if pr_number is not None:
        prs = run.get('pull_requests') or []
        if prs:
            return prs[0].get('number') == pr_number
        return (
            pr_head is not None
            and run.get('event') == 'pull_request'
            and run.get('head_branch') == pr_head['ref']
            and run.get('head_sha') == pr_head['sha']
            and (run.get('head_repository') or {}).get('id') == pr_head['repo']['id']
        )
    elif run.get('head_branch') != branch_name:
        return False
    return True


def _find_zephyr_workflow(branch_name):
    """
    Return workflow run id for the latest Build Zephyr run on this branch/PR.

    Only the newest matching run is considered. Failed runs are not skipped in
    favor of older successful runs.
    """
    pr_head = None
    if branch_name.startswith('PR'):
        pr_number = int(branch_name.split('-')[1])
        pr = _make_github_api_request(f"{config.pr_sha_url}/{pr_number}").json()
        pr_head = pr.get('head') or {}
        if not (pr_head.get('ref') and pr_head.get('sha') and (pr_head.get('repo') or {}).get('id')):
            raise RuntimeError(f"Incomplete head metadata for {branch_name}")
        head_branch = pr_head['ref']
        pr_base = f"{config.actions_runs_base_url}?event=pull_request&per_page=100"
        if head_branch:
            runs_url = f"{pr_base}&branch={quote(head_branch, safe='')}"
        else:
            runs_url = pr_base
    else:
        runs_url = (
            f"{config.actions_runs_base_url}?per_page=100&branch={quote(branch_name, safe='')}"
        )
        pr_number = None

    print(f"Fetching workflow runs from: {runs_url}")
    runs = _make_github_api_request(runs_url).json().get('workflow_runs', [])

    for run in runs:
        if not _matches_zephyr_run(run, branch_name, pr_number, pr_head):
            continue

        workflow_id = run.get('id')
        status = run.get('status')
        conclusion = run.get('conclusion')
        if status == 'completed' and conclusion == 'success':
            print(f"Build Zephyr workflow {workflow_id} for commit {run.get('head_sha')}")
            return workflow_id
        if status == 'in_progress':
            print(f"Build Zephyr workflow {workflow_id} still in progress")
            return workflow_id
        raise RuntimeError(
            f"Latest Build Zephyr run {workflow_id} is not usable: "
            f"status={status}, conclusion={conclusion}"
        )

    raise RuntimeError(f"No Build Zephyr workflow run found for {branch_name}")


def _get_workflow_run(workflow_id):
    url = f"{config.actions_runs_base_url}/{workflow_id}"
    return _make_github_api_request(url).json()


def _get_artifact_download_url(workflow_id):
    url = f"{config.actions_runs_base_url}/{workflow_id}/artifacts"
    artifacts = _make_github_api_request(url).json().get('artifacts') or []
    artifact = next((a for a in artifacts if a['name'] == ARTIFACT_NAME), None)
    if not artifact:
        available = [a['name'] for a in artifacts]
        raise RuntimeError(
            f"No {ARTIFACT_NAME} on workflow {workflow_id}. Available: {available}"
        )
    return artifact['archive_download_url'], artifact['name'] + '.zip'


def _download_and_extract(download_url, artifact_name):
    artifact_file = os.path.join('.', artifact_name)
    extracted_folder = os.path.join('.', artifact_name.replace('.zip', ''))

    if os.path.exists(artifact_file):
        os.remove(artifact_file)
    if os.path.exists(extracted_folder):
        shutil.rmtree(extracted_folder)

    print(f"Downloading {artifact_name}")
    response = _make_github_api_request(download_url)
    with open(artifact_file, 'wb') as f:
        f.write(response.content)

    os.makedirs(extracted_folder, exist_ok=True)
    with zipfile.ZipFile(artifact_file, 'r') as zf:
        zf.extractall(extracted_folder)
    print(f"Extracted to {extracted_folder}")
    return extracted_folder


def _download_zephyr_artifact(workflow_id):
    for attempt in range(1, WAIT_ATTEMPTS + 1):
        run = _get_workflow_run(workflow_id)
        status = run.get('status')
        conclusion = run.get('conclusion')
        if status == 'completed' and conclusion != 'success':
            raise RuntimeError(
                f"Build Zephyr workflow {workflow_id} failed with conclusion '{conclusion}'"
            )

        try:
            download_url, name = _get_artifact_download_url(workflow_id)
            return _download_and_extract(download_url, name)
        except RuntimeError as e:
            if attempt < WAIT_ATTEMPTS and ARTIFACT_NAME in str(e) and status != 'completed':
                print(
                    f"Artifact not ready ({attempt}/{WAIT_ATTEMPTS}), "
                    f"waiting {WAIT_SECONDS}s..."
                )
                time.sleep(WAIT_SECONDS)
                continue
            raise


def _iter_zephyr_binaries(root):
    """Yield (app_name, target, file_path) for each <app>/<TARGET>/<file> binary."""
    for app_name in sorted(os.listdir(root)):
        app_dir = os.path.join(root, app_name)
        if not os.path.isdir(app_dir):
            continue
        for target in sorted(os.listdir(app_dir)):
            target_dir = os.path.join(app_dir, target)
            if not os.path.isdir(target_dir):
                continue
            for file_name in sorted(os.listdir(target_dir)):
                file_path = os.path.join(target_dir, file_name)
                if os.path.isfile(file_path):
                    yield app_name, target, file_path


def _upload_binaries(root, branch_name, build_number):
    failures = []
    uploaded = 0

    for app_name, target, file_path in _iter_zephyr_binaries(root):
        file_name = os.path.basename(file_path)
        print(f"Uploading {app_name}/{target}/{file_name} to UBAI (target={target})")
        if upload_to_ubai(file_path, "", target, branch_name, build_number):
            uploaded += 1
        else:
            failures.append(f"{app_name}/{target}/{file_name}")

    if uploaded == 0 and not failures:
        raise RuntimeError(
            f"No Zephyr binaries found under {root}. Expected <app>/<TARGET>/<name>.<ext>"
        )
    if failures:
        raise RuntimeError(f"UBAI upload failed: {', '.join(failures)}")
    print(f"Uploaded {uploaded} Zephyr binary(ies) to UBAI")


def main():
    args = _parse_args()
    workflow_id = _find_zephyr_workflow(args.branch_name)
    extracted = _download_zephyr_artifact(workflow_id)
    _upload_binaries(extracted, args.branch_name, args.build_number)
    artifact_file = os.path.join('.', ARTIFACT_NAME + '.zip')
    if not upload_to_ubai(
        file_path=artifact_file,
        app_name="matter",
        target="matter",
        branch_name=args.branch_name,
        build_number=args.build_number,
    ):
        raise RuntimeError(f"UBAI upload failed: {artifact_file}")


if __name__ == '__main__':
    main()
