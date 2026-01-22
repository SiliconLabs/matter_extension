import os
import sys
from conan import ConanFile
from conan.tools.scm import Git
from conan.tools.files import copy, update_conandata
from typing import Iterable, Optional, Generator
import yaml
from pathlib import Path

## repo_root now provided by shared base recipe (MatterBaseRecipe.repo_root)
# For logging and error handling, use functions:
# self.output.success, self.output.info, self.output.warning, self.output.error
# See: https://docs.conan.io/2/reference/conanfile/attributes.html#output-contents

try:
    _PKG_ROOT = Path(__file__).parent.parent  # .../packages
    if str(_PKG_ROOT) not in sys.path:
        sys.path.insert(0, str(_PKG_ROOT))
except Exception:
    pass
from _shared.base_recipe import MatterBaseRecipe


class matter_appRecipe(MatterBaseRecipe):
    name = "matter_app"
    version = "2.6.1-0.dev"
    description = "matter sample-app package"
    # Other attributes
    # revision_mode = "scm"

    # Custom SLT metadata
    # Reference: https://confluence.silabs.com/spaces/SS/pages/669417743/SLT+options+in+conanfile.py
    """
    Available options and their values:
    packageType (string):
        - sdk: SDK packages
        - toolchain: Toolchain packages
        - apack: APACK packages
        - tools: Tool packages
        - system: System packages (not for user-installable packages)
        - software: General software packages (default)
    subPackage (boolean):
        - Only applicable for archive packages
        - Should be set to False for Conan packages
    releaseNotesUrl (string):
        - URL to the release notes document
    compatibleVersion (string):
        - Version compatibility information
    sdkLtsTag (string):
        - Long Term Support (LTS) tag for SDK packages
    """
    # Dictionary to declare properties
    options = {
      "compatibleVersion": ["ANY"],
      "subPackage": [True, False],
      "releaseNotesUrl": ["ANY"],
      "packageType": ["ANY"],
      "sdkLtsTag": ["ANY"]
    }

    # Dictionary to define properties values.
    # Alternative is to set values in def configure(self) of recipe
    default_options = {
      "compatibleVersion": "ANY",
      "subPackage": False,
      "releaseNotesUrl": "",
      "packageType": "sdk",
      "sdkLtsTag": ""
    }

        # Centralized folder reference (mirrors matter recipe pattern). Avoids relying
        # on self.source_folder so repo-relative operations stay consistent.
        @property
        def matter_app_folder(self) -> str:
                return str(self.repo_root)

    def requirements(self):
        pass

    def layout(self):
        pass

    def deploy(self):
        pass

    def export(self):
        pass

    def package_id(self):
        # Completely clear all the info, resulting ``package_id`` will be the same
        self.info.clear()

    def package(self):
        # Define the source folder for the matter_app component (property-backed)
        matter_app_folder = self.matter_app_folder

        # Define the files to be included in the package
        files_to_package = {"License"}

        
        silabs_package_assistant = self.python_requires["silabs_package_assistant"].module

        files_to_package.update(
            self._gather_slc_release_files(
                desired_qualities=["production", "evaluation"],
                desired_packages=["matter"],
                assistant=silabs_package_assistant,
            )
        )

        files_to_package = {file for file in files_to_package if os.path.exists(file) and not os.path.isdir(file)}


        # Get all .a files from files_to_package and copy them
        static_libraries = {file for file in files_to_package if file.endswith(".a")}
        files_to_package -= static_libraries
        for file in static_libraries:
            copy(self, pattern=file, src=matter_app_folder, dst=os.path.join(self.package_folder, "."))

        # Copy slc files using silabs_package_assistant
        silabs_package_assistant.copy_files(
            files_to_package=files_to_package,
            src_folder=matter_app_folder,
            dst_folder=os.path.join(self.package_folder, "."),
        )

        if os.path.exists("conan-matter_app.lock"):
            copy(self, pattern="conan-matter_app.lock", src=matter_app_folder, dst=os.path.join(self.package_folder, "."))

        silabs_package_assistant.generate_metadata(self, files_to_package)



    def build(self):
        # Define the source folder for the matter_app component (property-backed)
        matter_app_folder = self.matter_app_folder

        # Define the files to be included in the package
        files_to_package = {"License"}
        git_extra_files = []

        
        silabs_package_assistant = self.python_requires["silabs_package_assistant"].module

        files_to_package.update(
            self._gather_slc_release_files(
                desired_qualities=["production", "evaluation"],
                desired_packages=["matter"],
                assistant=silabs_package_assistant,
            )
        )

        files_to_package = {file for file in files_to_package if os.path.exists(file) and not os.path.isdir(file)}


        if git_extra_files:
          files_to_package.update(git_extra_files)
        with open("matter_app-filter-repo-filelist.txt","w") as filelistfile:
            for file in files_to_package:
                filelistfile.write(file+'\n')
        git_path_mapping = []
        with open("matter_app-filter-repo-pathmap.txt","w") as pathmapfile:
            for mapping in git_path_mapping:
                pathmapfile.write(mapping+'\n')





    def package_info(self):
        # Reference: https://confluence.silabs.com/pages/viewpage.action?spaceKey=SWARCH&title=Package+Manager%3A+Conan+Metadata+for+SLT+Integration

        # SDK Packages
        self.buildenv_info.append_path("SLC_SDK_PACKAGE_PATH", self.package_folder)

    # --------------------- Helpers ---------------------
    def _gather_slc_release_files(
        self,
        desired_qualities: list[str],
        desired_packages: list[str],
        assistant,
    ) -> set:
        """Discover .slcp/.slcw files (excluding third_party) and collect related release files.

        Returns a set of file paths including the SLC definition file itself plus any related files
        when the assistant reports matches for the given qualities/packages.
        """
        collected: set[str] = set()
        # Use shared repository root provided by base recipe
        root = self.repo_root
        # Scan once for both extensions
        for slc_file in root.rglob("*.slc*"):
            if "third_party" in slc_file.parts:
                continue
            if not slc_file.suffix in (".slcp", ".slcw"):
                continue
            rel_path = str(slc_file)
            try:
                related = assistant.list_files_in_slc_file(
                    slc_file_path=rel_path,
                    desired_qualities=desired_qualities,
                    desired_packages=desired_packages,
                    fail_on_missing_files=False,
                )
            except Exception as e:
                self.output.warning(f"Failed processing {rel_path}: {e}")
                continue
            if related:
                collected.add(rel_path)
                collected.update(related)
        return collected

