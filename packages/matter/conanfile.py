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
    # Prefer recipe dir (Conan cache e/) so exported e/_shared is found; else packages/.
    _recipe_dir = Path(__file__).resolve().parent
    for _base in (_recipe_dir, _recipe_dir.parent):
        if (_base / "_shared").is_dir() and str(_base) not in sys.path:
            sys.path.insert(0, str(_base))
            break
except Exception:
    pass
from _shared.base_recipe import MatterBaseRecipe


class matterRecipe(MatterBaseRecipe):
    name = "matter"
    # version set dynamically in MatterBaseRecipe.set_version() from matter.slce + SL_PRERELEASE*
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

    _REQUIRED_ROOT_FILES = (
        "matter.slsdk",
        "src/app/zap-templates/app-templates.json",
        "src/app/zap-templates/zcl/zcl.json",
    )

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
        req["slc-cli"] = "~"
        return req

    def layout(self):
        pass

    def deploy(self):
        pass

    def export(self):
        self.export_shared_recipe_support()
        # Ship packaging manifest with the recipe (not only under repo_root).
        extra = Path(self.recipe_folder) / "matter.slce.extra"
        if extra.is_file():
            copy(self, extra.name, src=str(extra.parent), dst=self.export_folder)

    def package_id(self):
        # Completely clear all the info, resulting ``package_id`` will be the same
        self.info.clear()

    def package(self):
        # Define the source folder for the matter component (centralized via property)
        matter_folder = self.matter_folder
        os.chdir(self.repo_root)

        # Define the files to be included in the package
        files_to_package = {"License"}

        # Process matter.slce.extra (shared helper)
        extra_info = self._process_slce_extra()
        files_to_package.update(extra_info["extra_files_including_descriptor"])

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
            desired_packages=["matter"],
        )
        files_to_package.update(files)
        files_to_package.update(self._gather_required_root_files())

        files_to_package = self._normalize_existing_repo_files(files_to_package)
        self._require_root_files(files_to_package)

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

        if (self.repo_root / "conan-matter.lock").is_file():
            copy(
                self,
                pattern="conan-matter.lock",
                src=matter_folder,
                dst=os.path.join(self.package_folder, "."),
            )

        silabs_package_assistant.generate_metadata(self, files_to_package)

    def build(self):
        os.chdir(self.repo_root)

        files_to_package = {"License"}

        extra_info = self._process_slce_extra()
        files_to_package.update(extra_info["extra_files_including_descriptor"])
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
            desired_packages=["matter"],
        )
        files_to_package.update(files)
        files_to_package.update(self._gather_required_root_files())

        files_to_package = self._normalize_existing_repo_files(files_to_package)
        self._require_root_files(files_to_package)

        if git_extra_files:
            files_to_package.update(
                self._normalize_existing_repo_files(git_extra_files)
            )
        with open("matter-filter-repo-filelist.txt", "w") as filelistfile:
            for file in sorted(files_to_package):
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
    def _resolve_repo_path(self, path: str) -> Path:
        """Resolve a packaging path against repo_root (absolute or relative)."""
        p = Path(path)
        if not p.is_absolute():
            p = self.repo_root / p
        return p

    def _to_repo_relative(self, path: str) -> str:
        """Return path relative to repo_root for copy_files(src_folder=repo)."""
        resolved = self._resolve_repo_path(path).resolve()
        try:
            return str(resolved.relative_to(self.repo_root.resolve()))
        except ValueError:
            return str(resolved)

    def _normalize_existing_repo_files(self, files: Iterable[str]) -> set[str]:
        """Keep only existing files, as paths relative to repo_root."""
        normalized: set[str] = set()
        for file in files:
            resolved = self._resolve_repo_path(file)
            if resolved.is_file():
                normalized.add(self._to_repo_relative(str(resolved)))
        return normalized

    def _matter_extra_skip_reason(self, path: str) -> Optional[str]:
        """Return skip reason for paths owned by matter_app, else None."""
        p = path.replace("\\", "/")
        if p.startswith("slc/apps/"):
            return "sample-app content (owned by matter_app package)"
        if p.endswith((".slcp", ".slcw")):
            return "sample project/workspace (owned by matter_app package)"
        if p.startswith("slc/script/internal/") or p == "slc/script/internal":
            return "internal scripts (not packaged)"
        return None

    def _process_slce_extra(self, filename: str = "matter.slce.extra") -> dict:
        """Parse matter.slce.extra and collect extra packaging metadata.

        Returns a dictionary with keys:
            extra_files_including_descriptor: set of files (descriptor + validated extra_files)
            git_extra_files: list of additional git export file paths (may be empty)
            git_path_mapping: list of path mapping entries (may be empty or None)

        Missing or malformed YAML gracefully degrades with warnings.
        Sample-app paths are skipped (belong in matter_app) and logged with reason.
        """
        candidates: list[tuple[Path, str]] = []
        # Recipe-local copy (packages/matter/matter.slce.extra, or e/ when exported)
        if getattr(self, "recipe_folder", None):
            recipe_extra = Path(self.recipe_folder) / filename
            if recipe_extra.is_file():
                try:
                    rel = str(recipe_extra.resolve().relative_to(self.repo_root.resolve()))
                except ValueError:
                    rel = str(recipe_extra)
                candidates.append((recipe_extra, rel))
        # Canonical in-repo path
        repo_pkg_extra = self.repo_root / "packages" / "matter" / filename
        if repo_pkg_extra.is_file():
            candidates.append(
                (repo_pkg_extra, str(repo_pkg_extra.relative_to(self.repo_root.resolve())))
            )
        # Legacy: repo-root matter.slce.extra (usually absent)
        root_extra = self.repo_root / filename
        if root_extra.is_file():
            candidates.append((root_extra, filename))

        os.chdir(self.repo_root)
        result = {
            "extra_files_including_descriptor": set(),
            "git_extra_files": [],
            "git_path_mapping": [],
        }
        if not candidates:
            self.output.warning(f"matter.slce.extra not found (looked under recipe and packages/matter)")
            return result

        extra_path, descriptor_rel = candidates[0]
        result["extra_files_including_descriptor"].add(descriptor_rel)
        try:
            with extra_path.open("r", encoding="utf-8") as f:
                data = yaml.safe_load(f) or {}
        except Exception as e:
            self.output.warning(f"Failed to parse {extra_path}: {e}")
            return result

        extra_files = data.get("extra_files") or []
        skipped_count = 0
        missing_count = 0
        for path in extra_files:
            reason = self._matter_extra_skip_reason(path)
            if reason:
                self.output.info(f"matter.slce.extra: skipped {path}: {reason}")
                skipped_count += 1
                continue

            resolved = self._resolve_repo_path(path)
            if resolved.is_file():
                result["extra_files_including_descriptor"].add(
                    self._to_repo_relative(str(resolved))
                )
            else:
                self.output.warning(
                    f"matter.slce.extra: referenced extra file missing and skipped: {path}"
                )
                missing_count += 1

        self.output.info(
            f"matter.slce.extra: skipped {skipped_count} sample-app path(s), "
            f"{missing_count} missing path(s); "
            f"kept {len(result['extra_files_including_descriptor'])} file(s)"
        )

        git_extra_files = data.get("git_extra_files") or []
        if git_extra_files:
            result["git_extra_files"] = git_extra_files

        git_path_mapping = data.get("git_path_mapping") or []
        if git_path_mapping:
            result["git_path_mapping"] = git_path_mapping

        return result

    def _get_local_slce_file(self, filename: str = "matter.slce") -> str:
        """Return repo-relative path to required SLCE definition, raising if missing."""
        slce_path = self.repo_root / filename
        if not slce_path.is_file():
            raise FileNotFoundError(f"SLCE file not found: {slce_path}")
        return filename
