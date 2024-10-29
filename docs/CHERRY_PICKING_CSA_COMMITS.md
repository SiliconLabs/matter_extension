# Directly cherry-picking CSA Matter repo commits into your environment

The Silicon Labs Matter Extension GitHub repo is kept generally up-to-date with the CSA Matter repo: its `third_party/matter_sdk` submodule points to a CSA commit that is within a week or two of the most recent one. These steps are applicable only when needing a specific CSA commit that has not yet made it to the Silicon Labs Matter Extension GitHub repo.

**Note: It is recommended to rely on the CSA updates provided through the Silicon Labs repo and avoid direct cherry-picks and the process described here.**


1. Fork the Silicon Labs Matter SDK GitHub repo by clicking "Fork" in the web UI https://github.com/SiliconLabsSoftware/matter_sdk

1. Clone your fork of the Silicon Labs Matter SDK GitHub repo  `https://github.com/<user-name>/matter_sdk.git` 

1. Add the CSA repo and the Silicon Labs Matter SDK  repo as the upstream remotes:

    ```
    git remote add csa-upstream https://github.com/project-chip/connectedhomeip.git
    git remote add silabs-upstream https://github.com/SiliconLabsSoftware/matter_sdk.git
    ```

1. Cherry pick the commit into your fork:

    ```
    git branch --track <branch-name> origin/master
    git checkout <branch-name>
    git fetch csa-upstream
    git cherry-pick <CSA commit hash>
    git push
    ```


1. Update the submodule URL in your fork of the Matter Extension to point to your fork of the Matter SDK repo. In your local clone of `https://github.com/<user-name>/matter_extension` do:
    
    ```
    git submodule set-url --  third_party/matter_sdk/ https://github.com/<user-name>/matter_sdk
    ```

---

The cherry-picked CSA commit might have source file additions/deletions that affect the composition of Silicon Labs Matter SLC components. Follow this process:

- Examine the changes carried in the commit.
- If neither source nor header files were added/deleted and no GN build flags were modified then no further action is needed.
- If the changes described above are present but only affect platform code other than Silicon Labs' then no further action is needed.
- Otherwise seek input from Silicon Labs on how to incorporate the commit changes into the SLC component definitions. 

