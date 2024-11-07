# Contributing to the Silicon Labs Matter Extension GitHub Repo

**!!! This functionality has not been enabled yet !!!**

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

