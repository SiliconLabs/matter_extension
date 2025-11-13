"""
This script updates GitHub check runs with SQA test results for the Matter project workflows.

It interacts with GitHub Actions to:
- Retrieve the check run ID for a specific commit and job name ("Wait for Test Results").
- Update the check run with SQA test results and summary.
- Retry operations to handle delays in job startup or API propagation.

Usage:
    python send_results_to_github.py --commit_sha <sha> --sqa_result <PASS|FAIL> --sqa_summary <summary> --jenkins_url <url>

Arguments:
    --commit_sha    Commit SHA to update the check run for.
    --sqa_result    The overall result of the SQA tests (PASS/FAIL).
    --sqa_summary   The summary text of the SQA tests.
    --jenkins_url   The Jenkins build URL for this run.

Environment Variables:
    (None required directly; uses config.py for API URLs and headers.)

Dependencies:
    - requests
    - config.py (must define required URLs, repo info, and headers)
"""

import argparse
import sys
import time
import requests
import os

# Add the workspace root to Python path to enable importing internal modules
workspace_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if workspace_root not in sys.path:
    sys.path.insert(0, workspace_root)

import jenkins_integration.config as config


MAX_RETRIES = 5
RETRY_DELAY = 300  # seconds
JOB_NAME = "Wait for Test Results"
CHECK_RUN_TITLE = "SQA Test Results"


def main():
    """Main function to parse arguments and send test results to GitHub."""
    args = parse_arguments()
    send_test_results_to_github(
        args.commit_sha, 
        args.sqa_result, 
        args.sqa_summary, 
        args.jenkins_url
    )


def parse_arguments():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument("--commit_sha", required=True)
    parser.add_argument("--sqa_result", required=True)
    parser.add_argument("--sqa_summary", required=True)
    parser.add_argument("--jenkins_url", required=True)
    return parser.parse_args()


def send_test_results_to_github(commit_sha, sqa_result, sqa_summary, jenkins_url):
    """
    Update the check run with the test results.
    
    Args:
        commit_sha (str): The commit SHA to update the check run for.
        sqa_result (str): The overall result of the SQA tests (PASS/FAIL).
        sqa_summary (str): The summary text of the SQA tests.
        jenkins_url (str): The Jenkins build URL for this run.
    """
    check_run_id = get_check_run_id(commit_sha)
    if not check_run_id:
        print("Check run ID not found. Exiting.")
        return
    
    conclusion = "failure" if sqa_result == "FAIL" else "success"
    update_check_run(check_run_id, conclusion, sqa_result, sqa_summary, jenkins_url)


def update_check_run(check_run_id, conclusion, sqa_result, sqa_summary, jenkins_url):
    """
    Update the check run with retry logic.
    
    Args:
        check_run_id (int): The check run ID to update.
        conclusion (str): The conclusion status (success/failure).
        sqa_result (str): The SQA test result.
        sqa_summary (str): The SQA test summary.
        jenkins_url (str): The Jenkins build URL.
    """
    data = create_check_run_payload(conclusion, sqa_result, sqa_summary, jenkins_url)
    check_run_url = f"https://api.github.com/repos/{config.repo_owner}/{config.repo_name}/check-runs/{check_run_id}"
    
    print("PATCH Request Details:")
    print(f"URL: {check_run_url}")
    print(f"Headers: {config.github_headers}")
    print(f"Payload: {data}")
    
    for attempt in range(MAX_RETRIES):
        response = requests.patch(check_run_url, headers=config.github_headers, json=data)
        
        if response.status_code == 200:
            print(f"Attempt {attempt + 1}/{MAX_RETRIES}: Check run updated successfully.")
            return
        
        print(f"Attempt {attempt + 1}/{MAX_RETRIES}: Failed to update check run. "
              f"Status code: {response.status_code}, Response: {response.text}")
        
        if attempt < MAX_RETRIES - 1:
            time.sleep(RETRY_DELAY)
    
    print(f"Attempt {MAX_RETRIES}/{MAX_RETRIES}: Check run update failed after maximum retries.")
    sys.exit(1)


def create_check_run_payload(conclusion, sqa_result, sqa_summary, jenkins_url):
    """
    Create the payload for updating the check run.
    
    Args:
        conclusion (str): The conclusion status.
        sqa_result (str): The SQA test result.
        sqa_summary (str): The SQA test summary.
        jenkins_url (str): The Jenkins build URL.
    
    Returns:
        dict: The payload for the PATCH request.
    """
    return {
        "status": "completed",
        "conclusion": conclusion,
        "output": {
            "title": CHECK_RUN_TITLE,
            "summary": sqa_result,
            "text": f"{sqa_summary}\nSee test results here: {jenkins_url}",
        }
    }


def get_check_run_id(commit_sha):
    """
    Retrieve the check run ID for a specific job name, with retries to handle delays in job startup.
    
    Args:
        commit_sha (str): The commit SHA to fetch check runs for.
    
    Returns:
        int or None: The check run ID if found, otherwise None.
    """
    check_runs_url = f"{config.commits_url}/{commit_sha}/check-runs"
    print(f"Fetching check runs from: {check_runs_url}")
    
    for attempt in range(MAX_RETRIES):
        response = requests.get(check_runs_url, headers=config.github_headers)
        
        if response.status_code == 200:
            check_run_id = find_check_run_by_name(response.json().get("check_runs", []))
            if check_run_id:
                return check_run_id
            
            print(f"Attempt {attempt + 1}/{MAX_RETRIES}: No matching check run found for job: {JOB_NAME}.")
        else:
            print(f"Attempt {attempt + 1}/{MAX_RETRIES}: Failed to retrieve check runs. "
                  f"Status code: {response.status_code}, Response: {response.text}")
        
        if attempt < MAX_RETRIES - 1:
            time.sleep(RETRY_DELAY)
    
    print(f"Exceeded maximum retries ({MAX_RETRIES}). Check run ID not found.")
    sys.exit(1)
    return None


def find_check_run_by_name(check_runs):
    """
    Find a check run by its name.
    
    Args:
        check_runs (list): List of check run objects.
    
    Returns:
        int or None: The check run ID if found, otherwise None.
    """
    for check_run in check_runs:
        if check_run["name"] == JOB_NAME:
            return check_run["id"]
    return None


if __name__ == '__main__':
    main()
