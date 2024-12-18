#! /usr/bin/python3
import argparse
import subprocess
from argparse import RawTextHelpFormatter


def get_git_log(start_sha, end_sha, prefixes):
    try:
        # Run the git log command with output format <commit hash> -- <Title>
        result = subprocess.run(
            ['git', 'log', '--pretty=format:%H -- %s %s', f'{start_sha}..{end_sha}'],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=True,
            text=True
        )

        # Split the result into lines
        log_lines = result.stdout.split('\n')

        # Initialize a dictionary to hold commits by prefix
        commits_by_prefix = {prefix: [] for prefix in prefixes}

        # Filter and group commits based on the prefixes
        for line in log_lines:
            for prefix in prefixes:
                if prefix in line:
                    commits_by_prefix[prefix].append(line)
                    break

        return commits_by_prefix

    except subprocess.CalledProcessError as e:
        print(f"Error running git log: {e}")
        return {}


def main():
    parser = argparse.ArgumentParser(formatter_class=RawTextHelpFormatter, description="""
    This script will parse git logs for our silabs prefixes ([SL-UP], [SL-TEMP], [SL-ONLY] or [CSA-CP]) between the commit SHAs provided in parameters
    on the current git branch.
    It will then output, per prefix, the commit sha and commit Title in the following format)
    [PREFIX] commits:
    <full_commit_sha> -- <Commit_Title>
    """,
                                     epilog="""
    Post result developer actions:
       commits grouped under [SL-UP] shall be upstream the CSA master.
       commits grouped under [SL-ONLY] shall be cherry-picked to matter_sdk main branch.
       commits grouped under [SL-TEMP] must be revised. Are they still required, are they needed on main or for the next release. If they are, they need to be cherry-picked.
       commits grouped under [CSA-CP] are purely informative. They already exist in CSA master and will automatically be brought to main or the new release branch through CSA master merges.
    """)
    parser.add_argument('start_sha', type=str, help='The starting commit SHA')
    parser.add_argument('end_sha', type=str, help='The ending commit SHA')

    args = parser.parse_args()

    start_sha = args.start_sha
    end_sha = args.end_sha
    prefixes = ["[SL-UP]", "[SL-TEMP]", "[SL-ONLY]", "[CSA-CP]"]

    commits_by_prefix = get_git_log(start_sha, end_sha, prefixes)
    for prefix, commits in commits_by_prefix.items():
        print(f"{prefix} commits:")
        for commit in commits:
            print(commit)
        print()


if __name__ == "__main__":
    main()
