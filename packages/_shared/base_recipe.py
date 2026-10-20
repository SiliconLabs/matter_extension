from pathlib import Path
from conan import ConanFile
from conan.tools.files import copy
import os
import re
import yaml

# Shared metadata and helpers for matter packages

_RECIPE_PATH = Path(__file__).resolve()
try:
    SHARED_REPO_ROOT = _RECIPE_PATH.parents[2]
except IndexError:
    SHARED_REPO_ROOT = _RECIPE_PATH.parent

_LINE_VERSION_RE = re.compile(r"^\d+\.\d+\.\d+$")


class MatterBaseRecipe(ConanFile):
    user = "silabs"
    license = "www.silabs.com/about-us/legal/master-software-license-agreement"
    author = "Silicon Laboratories Inc."
    homepage = "https://github.com/SiliconLabsSoftware/matter_extension/blob/main/README.md"
    url = "https://github.com/SiliconLabsSoftware/matter_extension"
    topics = "silabs"
    python_requires = "silabs_package_assistant/[>=1 <2]@silabs"

    # Central SL metadata
    sl_metadata = {
        "slack_channel": "#matter-development",
        "team": "MATTER",
        "confluence_doc": "",
        "jira_project": "https://jira.silabs.com/projects/MATTER/summary",
        "maintainers": [],
    }

    def set_version(self):
        """Resolve Conan version (SLCE base + SL_PRERELEASE*).

        Priority:
          1. MATTER_PACKAGE_VERSION env (explicit override for local/CI one-offs)
          2. silabs_package_assistant.get_version(matter.slce)
             - local: base + "-0.dev" (e.g. 2.10.0-0.dev)
             - CI with SL_PRERELEASE + SL_PRERELEASE_NUMBER: base + "-alpha.N"
        """
        override = os.environ.get("MATTER_PACKAGE_VERSION", "").strip()
        if override:
            self.version = override
            return

        assistant = self.python_requires["silabs_package_assistant"].module
        self.version = self.version or assistant.get_version(self.matter_slce_path)

    def package_id(self):
        # Unified behavior: header-only / content-only style id
        self.info.clear()

    def export_shared_recipe_support(self) -> None:
        """Copy helpers into the Conan export folder so cached recipes can import _shared.

        Without this, slt install reloads e/conanfile.py and fails with:
        ModuleNotFoundError: No module named '_shared'
        """
        shared_src = Path(self.recipe_folder).parent / "_shared"
        if shared_src.is_dir():
            copy(
                self,
                "*",
                src=str(shared_src),
                dst=os.path.join(self.export_folder, "_shared"),
                excludes=("__pycache__", "*.pyc", "*.sh"),
            )
        for dep_src in _dependency_versions_candidates(self.repo_root):
            if dep_src.is_file():
                copy(
                    self,
                    dep_src.name,
                    src=str(dep_src.parent),
                    dst=self.export_folder,
                )
                break
        slce_src = self.repo_root / "matter.slce"
        if slce_src.is_file():
            copy(self, slce_src.name, src=str(slce_src.parent), dst=self.export_folder)

    @property
    def repo_root(self) -> Path:
        """Repository root directory (shared across all Matter recipes)."""
        return SHARED_REPO_ROOT

    @property
    def matter_slce_path(self) -> str:
        """Path to matter.slce (repo root, or beside exported recipe in Conan cache)."""
        candidates = [self.repo_root / "matter.slce"]
        recipe_folder = getattr(self, "recipe_folder", None)
        if recipe_folder:
            candidates.insert(0, Path(recipe_folder) / "matter.slce")
        for candidate in candidates:
            if candidate.is_file():
                return str(candidate)
        return str(self.repo_root / "matter.slce")

    @property
    def matter_line_version(self) -> str:
        """X.Y.Z line version from matter.slce (no prerelease suffix)."""
        assistant = self.python_requires["silabs_package_assistant"].module
        line = assistant.get_base_version(self.matter_slce_path)
        if not _LINE_VERSION_RE.match(line):
            raise RuntimeError(
                f"matter.slce version must be X.Y.Z, got {line!r}"
            )
        return line

    @property
    def matter_conan_range(self) -> str:
        """Conan requires() range for matter (includes prereleases)."""
        line = self.matter_line_version
        major, minor, patch = line.split(".")
        upper = f"{major}.{minor}.{int(patch) + 1}"
        return f"[>={line} <{upper},include_prerelease]"

    # --------------- Required root metadata files ---------------
    # Subclasses define _REQUIRED_ROOT_FILES as a tuple of repo-relative paths.
    # Then: files_to_package.update(self._gather_required_root_files())
    #       self._require_root_files(files_to_package)

    def _gather_required_root_files(self) -> set[str]:
        """Return repo-relative paths from _REQUIRED_ROOT_FILES that exist on disk."""
        required = getattr(self, "_REQUIRED_ROOT_FILES", ())
        collected: set[str] = set()
        for name in required:
            if (self.repo_root / name).is_file():
                collected.add(name)
        return collected

    def _require_root_files(self, files_to_package: set[str]) -> None:
        """Hard-fail if any _REQUIRED_ROOT_FILES entry is missing from the package set."""
        required = getattr(self, "_REQUIRED_ROOT_FILES", ())
        if not required:
            return

        root = self.repo_root.resolve()
        packaged_rels: set[str] = set()
        packaged_resolved: set[Path] = set()
        for entry in files_to_package:
            p = Path(entry)
            if not p.is_absolute():
                p = root / p
            try:
                resolved = p.resolve()
                packaged_resolved.add(resolved)
                packaged_rels.add(str(resolved.relative_to(root)))
            except (ValueError, OSError):
                packaged_rels.add(str(entry))

        missing = [
            name
            for name in required
            if name not in files_to_package
            and name not in packaged_rels
            and (root / name).resolve() not in packaged_resolved
        ]
        if missing:
            pkg = getattr(self, "name", type(self).__name__)
            raise FileNotFoundError(
                f"{pkg} package is missing required root metadata files: {missing}. "
                "Ensure they exist under the repo root and are packaged successfully."
            )

    # --------------- Shared dependency versions ---------------
    @property
    def dep_versions(self) -> dict:
        """Access centralized dependency versions loaded from canonical YAML.

        Path: <repo_root>/slc/script/dependency_versions.yaml
        Raises FileNotFoundError or RuntimeError if missing/malformed to fail fast.
        Cached at module import time for performance.
        """
        return _DEP_VERSIONS


def _dependency_versions_candidates(repo_root: Path) -> list[Path]:
    """Repo path plus copy co-located with exported recipe (cache e/)."""
    candidates: list[Path] = [
        repo_root / "slc" / "script" / "dependency_versions.yaml",
    ]
    # When this file lives at e/_shared/base_recipe.py, yaml is at e/
    if _RECIPE_PATH.parent.name == "_shared":
        candidates.insert(0, _RECIPE_PATH.parents[1] / "dependency_versions.yaml")
    return candidates


def _load_dep_versions_shared(filename: str = "dependency_versions.yaml") -> dict:
    """Load dependency versions as a flat name->version map for Conan recipes.

    Supports the grouped YAML format (common/thread/wifi) used by generation
    scripts, and the legacy flat format. For the stack package, all groups are
    merged (common, then thread, then wifi; later entries override duplicates).
    """
    target = None
    for candidate in _dependency_versions_candidates(SHARED_REPO_ROOT):
        # Allow override of filename for the last path segment when searching repo
        if candidate.name != filename and candidate.parent.name == "script":
            candidate = candidate.parent / filename
        if candidate.is_file():
            target = candidate
            break
    if target is None:
        raise FileNotFoundError(
            f"Dependency versions file '{filename}' not found under "
            f"{SHARED_REPO_ROOT}/slc/script or exported recipe folder"
        )
    try:
        with target.open("r", encoding="utf-8") as f:
            data = yaml.safe_load(f) or {}
    except Exception as e:
        raise RuntimeError(
            f"Failed to parse dependency versions file {target}: {e}"
        )

    if not isinstance(data, dict):
        raise RuntimeError(
            f"Dependency versions file {target} must contain a mapping"
        )

    if any(k in data for k in ("common", "thread", "wifi")):
        merged: dict = {}
        for group in ("common", "thread", "wifi"):
            group_data = data.get(group) or {}
            if not isinstance(group_data, dict):
                raise RuntimeError(
                    f"Dependency group '{group}' in {target} must be a mapping"
                )
            for name, version in group_data.items():
                if version is None:
                    continue
                merged[name] = version
        return merged

    return {k: v for k, v in data.items() if v is not None}


_DEP_VERSIONS = _load_dep_versions_shared()
