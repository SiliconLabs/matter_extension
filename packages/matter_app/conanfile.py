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
    # Prefer recipe dir (Conan cache e/) so exported e/_shared is found; else packages/.
    _recipe_dir = Path(__file__).resolve().parent
    for _base in (_recipe_dir, _recipe_dir.parent):
        if (_base / "_shared").is_dir() and str(_base) not in sys.path:
            sys.path.insert(0, str(_base))
            break
except Exception:
    pass
from _shared.base_recipe import MatterBaseRecipe


class matter_appRecipe(MatterBaseRecipe):
    name = "matter_app"
    # version set dynamically in MatterBaseRecipe.set_version() from matter.slce + SL_PRERELEASE*
    description = "matter sample-app package"
    # App SDK root marker + Studio templates (same pattern as wifi_app.slsdk).
    _REQUIRED_ROOT_FILES = (
        "matter_app.slsdk",
        "matter_templates.xml",
    )
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
        # Range on line version.
        self.requires(f"matter/{self.matter_conan_range}@{self.user}")

    def layout(self):
        pass

    def deploy(self):
        pass

    def export(self):
        self.export_shared_recipe_support()

    def package_id(self):
        # Completely clear all the info, resulting ``package_id`` will be the same
        self.info.clear()

    def package(self):
        # Define the source folder for the matter_app component (property-backed)
        matter_app_folder = self.matter_app_folder
        repo_root = self.repo_root

        # Define the files to be included in the package
        files_to_package = {"License"}

        silabs_package_assistant = self.python_requires["silabs_package_assistant"].module

        desired_qualities = ["production", "evaluation", "experimental"]
        desired_packages = ["matter"]

        files_to_package.update(
            self._gather_slc_release_files(
                desired_qualities=desired_qualities,
                desired_packages=desired_packages,
                assistant=silabs_package_assistant,
            )
        )
        files_to_package.update(self._gather_required_root_files())
        files_to_package.update(
            self._gather_slcp_external_inputs(
                desired_qualities=desired_qualities,
                desired_packages=desired_packages,
            )
        )

        # Resolve against repo_root — cwd during export-pkg is not always the repo.
        files_to_package = self._existing_repo_relative_files(files_to_package)

        # Root metadata uses repo-relative names; re-add after exists-filter, then hard-require.
        files_to_package.update(self._gather_required_root_files())
        self._require_root_files(files_to_package)

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

        # Package-only builder at package root: <pkg>/build_app.sh
        build_app_src = repo_root / "packages" / "build_app.sh"
        if not build_app_src.is_file():
            raise FileNotFoundError(f"missing {build_app_src}")
        copy(
            self,
            pattern="build_app.sh",
            src=str(build_app_src.parent),
            dst=os.path.join(self.package_folder, "."),
        )

        if (repo_root / "conan-matter_app.lock").is_file():
            copy(self, pattern="conan-matter_app.lock", src=matter_app_folder, dst=os.path.join(self.package_folder, "."))

        silabs_package_assistant.generate_metadata(self, files_to_package)

    def build(self):
        # Define the source folder for the matter_app component (property-backed)
        matter_app_folder = self.matter_app_folder
        repo_root = self.repo_root

        # Define the files to be included in the package
        files_to_package = {"License"}
        git_extra_files = []

        silabs_package_assistant = self.python_requires["silabs_package_assistant"].module

        desired_qualities = ["production", "evaluation", "experimental"]
        desired_packages = ["matter"]

        files_to_package.update(
            self._gather_slc_release_files(
                desired_qualities=desired_qualities,
                desired_packages=desired_packages,
                assistant=silabs_package_assistant,
            )
        )
        files_to_package.update(self._gather_required_root_files())
        files_to_package.update(
            self._gather_slcp_external_inputs(
                desired_qualities=desired_qualities,
                desired_packages=desired_packages,
            )
        )

        files_to_package = self._existing_repo_relative_files(files_to_package)
        files_to_package.update(self._gather_required_root_files())
        self._require_root_files(files_to_package)

        # Repo source path; packaged as <pkg>/build_app.sh (see package()).
        if (repo_root / "packages" / "build_app.sh").is_file():
            files_to_package.add("packages/build_app.sh")

        if git_extra_files:
          files_to_package.update(git_extra_files)
        with open("matter_app-filter-repo-filelist.txt","w") as filelistfile:
            for file in sorted(files_to_package):
                filelistfile.write(file+'\n')
        # Map repo path → package-root layout for filter-repo consumers.
        git_path_mapping = ["packages/build_app.sh:build_app.sh"]
        with open("matter_app-filter-repo-pathmap.txt","w") as pathmapfile:
            for mapping in git_path_mapping:
                pathmapfile.write(mapping+'\n')

    def package_info(self):
        # Reference: https://confluence.silabs.com/pages/viewpage.action?spaceKey=SWARCH&title=Package+Manager%3A+Conan+Metadata+for+SLT+Integration

        # SDK Packages
        self.buildenv_info.append_path("SLC_SDK_PACKAGE_PATH", self.package_folder)

    # --------------------- Helpers ---------------------
    def _existing_repo_relative_files(self, files: set[str]) -> set[str]:
        """Keep existing files as paths relative to repo_root (cwd-independent)."""
        root = self.repo_root.resolve()
        normalized: set[str] = set()
        for file in files:
            p = Path(file)
            if not p.is_absolute():
                p = root / file
            if not p.is_file():
                continue
            try:
                normalized.add(str(p.resolve().relative_to(root)))
            except ValueError:
                normalized.add(str(p.resolve()))
        return normalized

    @staticmethod
    def _iter_slc_path_entries(node) -> Generator[str, None, None]:
        """Yield every string 'path' value from nested SLC YAML structures."""
        if isinstance(node, dict):
            path_val = node.get("path")
            if isinstance(path_val, str):
                yield path_val
            for value in node.values():
                yield from matter_appRecipe._iter_slc_path_entries(value)
        elif isinstance(node, list):
            for item in node:
                yield from matter_appRecipe._iter_slc_path_entries(item)

    # Project input sections only — skip export/artifact build outputs, filter tags, etc.
    _INPUT_PATH_KEYS = (
        "source",
        "include",
        "config_file",
        "other_file",
        "readme",
        "post_build",
    )

    @classmethod
    def _iter_input_path_entries(cls, data: dict) -> Generator[str, None, None]:
        """Yield path values from sample input sections only."""
        for key in cls._INPUT_PATH_KEYS:
            section = data.get(key)
            if section is None:
                continue
            yield from cls._iter_slc_path_entries(section)

    @staticmethod
    def _slc_project_selected(
        data: dict,
        desired_qualities: list[str],
        desired_packages: list[str],
    ) -> bool:
        """Match production/evaluation Matter projects (same intent as assistant filter)."""
        quality = data.get("quality")
        if quality is not None and quality not in desired_qualities:
            return False

        package = data.get("package")
        if package in desired_packages:
            return True

        for ext in data.get("sdk_extension") or []:
            if isinstance(ext, dict) and ext.get("id") in desired_packages:
                return True
        return False

    def _gather_slcp_external_inputs(
        self,
        desired_qualities: list[str],
        desired_packages: list[str],
    ) -> set[str]:
        """Collect files referenced by .slcp/.slcw input paths for packaging.

        Only source/include/config_file/other_file/readme/post_build paths are
        considered. Export artifacts (e.g. artifact/*.o) are ignored.

        Sample projects use repo-relative paths such as
        ../../../../third_party/matter_sdk/... . Those must exist under the
        matter_app package root so customer CLI generate resolves them the same
        way as in the git tree (Zigbee keeps assets inside the app package).
        """
        root = self.repo_root.resolve()
        collected: set[str] = set()
        missing: list[str] = []

        for slc_file in root.rglob("*.slc*"):
            if "third_party" in slc_file.parts:
                continue
            if slc_file.suffix not in (".slcp", ".slcw"):
                continue

            try:
                data = yaml.safe_load(slc_file.read_text(encoding="utf-8")) or {}
            except Exception as e:
                self.output.warning(f"Skip unreadable {slc_file}: {e}")
                continue

            if not isinstance(data, dict):
                continue
            if not self._slc_project_selected(data, desired_qualities, desired_packages):
                continue

            for rel in self._iter_input_path_entries(data):
                # Skip bare file_list names (resolved under their include dir).
                if "/" not in rel and not rel.startswith("."):
                    continue

                resolved = (slc_file.parent / rel).resolve()
                try:
                    resolved.relative_to(root)
                except ValueError:
                    missing.append(f"{slc_file}: {rel} (outside repo)")
                    continue

                if not resolved.exists():
                    missing.append(f"{slc_file}: {rel}")
                    continue

                if resolved.is_file():
                    collected.add(str(resolved))
                elif resolved.is_dir():
                    for file_path in resolved.rglob("*"):
                        if file_path.is_file():
                            collected.add(str(file_path))

        if missing:
            sample = "\n  ".join(missing[:30])
            more = f"\n  ... and {len(missing) - 30} more" if len(missing) > 30 else ""
            raise FileNotFoundError(
                "matter_app packaging missing .slcp/.slcw inputs "
                "(initialize third_party/matter_sdk submodule before export-pkg):\n  "
                f"{sample}{more}"
            )

        self.output.info(
            f"Gathered {len(collected)} files from .slcp/.slcw input path references "
            "for matter_app packaging"
        )
        return collected

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
