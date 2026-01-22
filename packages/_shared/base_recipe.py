from pathlib import Path
from conan import ConanFile
import yaml

# Shared metadata and helpers for matter packages

_RECIPE_PATH = Path(__file__).resolve()
try:
    SHARED_REPO_ROOT = _RECIPE_PATH.parents[2]
except IndexError:
    SHARED_REPO_ROOT = _RECIPE_PATH.parent

class MatterBaseRecipe(ConanFile):
    user = "silabs"
    license = "www.silabs.com/about-us/legal/master-software-license-agreement"
    author = "Silicon Laboratories Inc."
    homepage = "https://github.com/SiliconLabsSoftware/matter_extension/blob/main/README.md"
    url = "https://github.com/SiliconLabsSoftware/matter_extension"
    topics = "silabs"
    python_requires = "silabs_package_assistant/[>=1]@silabs"

    # Central SL metadata
    sl_metadata = {
        "slack_channel": "#matter-development",
        "team": "MATTER",
        "confluence_doc": "",
        "jira_project": "https://jira.silabs.com/projects/MATTER/summary",
        "maintainers": [],
    }

    def set_version(self):
        # Allow downstream override; placeholder for future dynamic version logic
        pass

    def package_id(self):
        # Unified behavior: header-only / content-only style id
        self.info.clear()

    @property
    def repo_root(self) -> Path:
        """Repository root directory (shared across all Matter recipes)."""
        return SHARED_REPO_ROOT

    # --------------- Shared dependency versions ---------------
    @property
    def dep_versions(self) -> dict:
        """Access centralized dependency versions loaded from canonical YAML.

        Path: <repo_root>/slc/script/dependency_versions.yaml
        Raises FileNotFoundError or RuntimeError if missing/malformed to fail fast.
        Cached at module import time for performance.
        """
        return _DEP_VERSIONS


def _load_dep_versions_shared(filename: str = "dependency_versions.yaml") -> dict:
    target = SHARED_REPO_ROOT / "slc" / "script" / filename
    if not target.exists():
        raise FileNotFoundError(
            f"Dependency versions file not found at expected canonical path: {target}"
        )
    try:
        with target.open("r", encoding="utf-8") as f:
            data = yaml.safe_load(f) or {}
            return data
    except Exception as e:
        raise RuntimeError(
            f"Failed to parse dependency versions file {target}: {e}"
        )


_DEP_VERSIONS = _load_dep_versions_shared()
