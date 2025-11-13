import os
from pathlib import Path
from conan import ConanFile
from conan.tools.scm import Git
from conan.tools.files import copy, update_conandata
from typing import Iterable, Optional, Generator
import sys
import yaml
# For logging and error handling, use functions:
# self.output.success, self.output.info, self.output.warning, self.output.error
# See: https://docs.conan.io/2/reference/conanfile/attributes.html#output-contents

## repo_root now provided by shared base recipe (MatterBaseRecipe.repo_root)


try:
    _PKG_ROOT = Path(__file__).parent.parent  # .../packages
    if str(_PKG_ROOT) not in sys.path:
        sys.path.insert(0, str(_PKG_ROOT))
except Exception:
    pass
from _shared.base_recipe import MatterBaseRecipe


class matterRecipe(MatterBaseRecipe):
    # Specific description (can override base if needed)
    description = "Matter extension for Simplicity SDK Suite"

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
        "sdkLtsTag": ["ANY"],
    }

    # Dictionary to define properties values.
    # Alternative is to set values in def configure(self) of recipe
    default_options = {
        "compatibleVersion": "ANY",
        "subPackage": False,
        "releaseNotesUrl": "",
        "packageType": "sdk",
        "sdkLtsTag": "",
    }

    # Provide a unified folder reference for the recipe logic without needing
    # to override __init__ (Conan discourages custom __init__ implementations).
    @property
    def matter_folder(self) -> str:
        return str(self.repo_root)

    def requirements(self):
        """Declare recipe dependencies using centralized version mapping.

        Rationale:
            Centralizing dependency versions makes alignment with other tooling
            (e.g. generation scripts) simpler and reduces risk of version skew.

        To update a version, modify the DEP_VERSIONS mapping defined below the
        class. Optionally, future work could externalize this to a single
        versions file consumed by both scripts and recipes.
        """

        for dep_name, dep_version in self.dep_versions.items():  # preserves insertion order (Python 3.7+)
            self.requires(f"{dep_name}/{dep_version}@{self.user}")

    def slt_requirements(self):
        req = {}
        req["zap"] = "~"
        req["slc_cli"] = "~"
        return req

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
        # Define the source folder for the matter component (centralized via property)
        matter_folder = self.matter_folder

        # Define the files to be included in the package
        files_to_package = {"License"}
        extra_files = []

        # Process matter.slce.extra (shared helper)
        extra_info = self._process_slce_extra()
        files_to_package.update(extra_info["extra_files_including_descriptor"])  # includes descriptor itself

        silabs_package_assistant = self.python_requires[
            "silabs_package_assistant"
        ].module

        slce_file = self._get_local_slce_file()

        files = silabs_package_assistant.find_slc_files_to_release(
            slc_sdk_or_extension_def_file=slce_file,
            desired_qualities=["production", "evaluation", "experimental"],
            fail_on_missing_files=False,
            include_slcp=False,
            include_slcc=True,
            # Defaults to slce extension ID;
            # SLCCs with slcc:package field set to
            # the package names in desired_packages will be included
            desired_packages=["matter"],
        )
        files_to_package.update(files)

        files_to_package = {
            file
            for file in files_to_package
            if os.path.exists(file) and not os.path.isdir(file)
        }

        # Get all .a files from files_to_package and copy them
        static_libraries = {
            file for file in files_to_package if file.endswith(".a")
        }
        files_to_package -= static_libraries
        for file in static_libraries:
            copy(
                self,
                pattern=file,
                src=matter_folder,
                dst=os.path.join(self.package_folder, "."),
            )

        # Copy slc files using silabs_package_assistant
        silabs_package_assistant.copy_files(
            files_to_package=files_to_package,
            src_folder=matter_folder,
            dst_folder=os.path.join(self.package_folder, "."),
        )

        if os.path.exists("conan-matter.lock"):
            copy(
                self,
                pattern="conan-matter.lock",
                src=matter_folder,
                dst=os.path.join(self.package_folder, "."),
            )

        silabs_package_assistant.generate_metadata(self, files_to_package)

    def build(self):
        # Define the source folder for the matter component (property-backed)

        # Define the files to be included in the package
        files_to_package = {"License"}
        extra_files = []
        git_extra_files = []

        # Process matter.slce.extra (shared helper)
        extra_info = self._process_slce_extra()
        files_to_package.update(extra_info["extra_files_including_descriptor"])  # includes descriptor itself
        git_extra_files = extra_info["git_extra_files"]
        git_path_mapping = extra_info["git_path_mapping"]

        silabs_package_assistant = self.python_requires[
            "silabs_package_assistant"
        ].module

        slce_file = self._get_local_slce_file()

        files = silabs_package_assistant.find_slc_files_to_release(
            slc_sdk_or_extension_def_file=slce_file,
            desired_qualities=["production", "evaluation"],
            fail_on_missing_files=False,
            include_slcp=False,
            include_slcc=True,
            # Defaults to slce extension ID;
            # SLCCs with slcc:package field set to
            # the package names in desired_packages will be included
            desired_packages=["matter"],
        )
        files_to_package.update(files)

        files_to_package = {
            file
            for file in files_to_package
            if os.path.exists(file) and not os.path.isdir(file)
        }

        if git_extra_files:
            files_to_package.update(git_extra_files)
        with open("matter-filter-repo-filelist.txt", "w") as filelistfile:
            for file in files_to_package:
                filelistfile.write(file + "\n")
        with open("matter-filter-repo-pathmap.txt", "w") as pathmapfile:
            for mapping in git_path_mapping:
                pathmapfile.write(mapping + "\n")

    def package_info(self):
        # Reference: https://confluence.silabs.com/pages/viewpage.action?spaceKey=SWARCH&title=Package+Manager%3A+Conan+Metadata+for+SLT+Integration

        # SDK Packages
        self.buildenv_info.append_path(
            "SLC_SDK_PACKAGE_PATH", self.package_folder
        )

    # ------------------------- Helpers -------------------------
    def _process_slce_extra(self, filename: str = "matter.slce.extra") -> dict:
        """Parse matter.slce.extra and collect extra packaging metadata.

        Returns a dictionary with keys:
            extra_files_including_descriptor: set of files (descriptor + validated extra_files)
            git_extra_files: list of additional git export file paths (may be empty)
            git_path_mapping: list of path mapping entries (may be empty or None)

        Missing or malformed YAML gracefully degrades with warnings.
        """
        filename = os.path.join(self.repo_root, filename)
        os.chdir(self.repo_root)
        result = {
            "extra_files_including_descriptor": set(),
            "git_extra_files": [],
            "git_path_mapping": [],
        }
        if not os.path.exists(filename):
            return result

        result["extra_files_including_descriptor"].add(filename)
        try:
            with open(filename, "r", encoding="utf-8") as f:
                data = yaml.safe_load(f) or {}
        except Exception as e:
            self.output.warning(f"Failed to parse {filename}: {e}")
            return result

        # extra_files
        extra_files = data.get("extra_files") or []
        for path in extra_files:
            if os.path.exists(path):
                result["extra_files_including_descriptor"].add(path)
            else:
                self.output.warning(
                    f"matter.slce.extra: referenced extra file missing and skipped: {path}"
                )

        # git extras
        git_extra_files = data.get("git_extra_files") or []
        if git_extra_files:
            result["git_extra_files"] = git_extra_files

        # path mapping
        git_path_mapping = data.get("git_path_mapping") or []
        if git_path_mapping:
            result["git_path_mapping"] = git_path_mapping

        return result

    def _get_local_slce_file(self, filename: str = "matter.slce") -> str:
        """Return relative path to required SLCE definition, raising if missing.

        Keeps logic centralized so build() and package() stay DRY.
        """
        filename = os.path.join(self.repo_root, filename)
        if not os.path.exists(filename):
            raise FileNotFoundError(f"SLCE file not found: {filename}")
        # Maintain previous usage of a relative string path
        return f"./{filename}"