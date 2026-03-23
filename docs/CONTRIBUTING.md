# Contributing to the Silicon Labs Matter Extension GitHub Repo

Silicon Labs maintains the following public GitHub repos for Matter development:
- Matter Extension: https://github.com/SiliconLabsSoftware/matter_extension
- Matter SDK: https://github.com/SiliconLabsSoftware/matter_sdk

Matter SDK is a submodule of Matter Extension residing under third_party/matter_sdk

## Contributing to the Silicon Labs Matter Extension Repo
1. Create and check out a working branch for your new feature:

    ```
    git branch --track <branch-name> origin/main
    git checkout <branch-name>
    ```

1. Implement and commit your changes:

    ```
    git add <file1> <file2>
    git commit
    ```

1. If there were any new upstream commits, rebase your development branch:

    ```
    git checkout main
    git pull upstream main
    git checkout <branch-name>
    git rebase main
    ```

1. Push to your GitHub fork:

    ```
    git checkout <branch-name>
    git push origin <branch-name>
    ```

1. Create a PR in the GitHub GUI for your fork `https://github.com/<user-name>/matter_extension`

1. All the PR Checks will run automatically. Make sure all the "Build" and "Validate" checks succeed, push additional changes if necessary. Once the "Build" and "Validate" checks succeed additional tests are run in a separate Silicon Labs environment and the "Wait for Test Results" action completes -- this step is triggered by Silicon Labs and does not require any action from the user beyond opening the PR. If the tests fail due to the PR changes the relevant info will be added as PR comments. 

1. Once all the checks pass the Silicon Labs team will review and merge the PR. 

## Contributing to the Silicon Labs Matter SDK Repo

1. Fork and clone the Matter SDK repo https://github.com/SiliconLabsSoftware/matter_sdk

1. Create and check out a working branch for your new feature:

    ```
    git branch --track <branch-name> origin/main
    git checkout <branch-name>
    ```

1. Implement and commit your changes:

    ```
    git add <file1> <file2>
    git commit
    ```

1. If there were any new upstream commits, rebase your development branch:

    ```
    git checkout main
    git pull upstream main
    git checkout <branch-name>
    git rebase main
    ```

1. Push to your GitHub fork:

    ```
    git checkout <branch-name>
    git push origin <branch-name>
    ```

1. Create a PR in the GitHub GUI for your fork `https://github.com/<user-name>/matter_sdk`. Make sure all the PR checks pass. 

1. Create a PR in the Matter Extension repo that updates the third_party/matter_sdk submodule to point to your matter_sdk PR branch. Make sure all PR checks pass, including "Wait for Test Results".

1. Once the Matter Extension PR passes all the checks add a link to that PR to the Matter SDK PR. The Silicon Labs team will then review and merge the PR. 