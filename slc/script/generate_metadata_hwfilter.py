#!/usr/bin/env python3
"""
This script uses hwfilter tools to generate
  - matter_templates.xml
  - matter_demos.xml  
  - board_compatibility_matrix.html

Config files in slc/script/
  - hwfilter-config.yml: Board & device allowlists, flash requirements, quality requirements
  - metadata-generation.yml: Demo variants, board overrides, template exclusions
"""

import fnmatch
import os
import subprocess
import sys
import tempfile
import shutil
import yaml
import json
from dataclasses import dataclass
from pathlib import Path
from typing import Tuple, List, Dict

_SCRIPT_DIR = Path(__file__).resolve().parent

HWFILTER_REPO = "https://github.com/SiliconLabsInternal/hwfilter.git"
HWFILTER_BRANCH = "main"

# Maps use_ci_boards_for_demos ci_source values to json glob pattern
CI_SOURCE_JSON_GLOBS: Dict[str, str] = {
    '_ncp_917':   'silabs-builds-917-ncp.json',
    '_trustzone': 'silabs-builds-*trustzone*.json',
}
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    NC = '\033[0m'

def log_info(message: str):
    print(f"{Colors.GREEN}[INFO]{Colors.NC} {message}")

def log_warn(message: str):
    print(f"{Colors.YELLOW}[WARN]{Colors.NC} {message}")

def log_error(message: str):
    print(f"{Colors.RED}[ERROR]{Colors.NC} {message}")
@dataclass(frozen=True)
class CiJsonRecord:
    path: Path
    name: str
    is_internal: bool
    build: Dict

def load_ci_json_records(github_dir: Path, build_type: str) -> tuple[CiJsonRecord, ...]:
    """Load all CI json files once"""
    if not github_dir.is_dir():
        return ()
    out: list[CiJsonRecord] = []
    for json_file in sorted(github_dir.glob("silabs-builds-*.json")):
        try:
            with open(json_file, "r", encoding="utf-8") as f:
                config = json.load(f)
            out.append(
                CiJsonRecord(
                    path=json_file,
                    name=json_file.name,
                    is_internal="-internal" in json_file.name,
                    build=config.get(build_type, {}) or {},
                )
            )
        except (json.JSONDecodeError, OSError) as e:
            log_warn(f"Error loading {json_file.name}: {e}")
    return tuple(out)

def get_app_suffix_from_json(json_filename: str) -> str:
    """Map CI json filename to app suffix"""
    if "917-ncp" in json_filename:
        return "_917_ncp"
    elif "siwx" in json_filename:
        return "_siwx"
    elif "sixg301" in json_filename:
        return "_series_3"
    elif any(x in json_filename for x in ["mg24", "mgm24", "mg26", "mgm26"]):
        return "_series_2"
    else:
        return "_series"

def variant_matrix_from_records(records: tuple[CiJsonRecord, ...]) -> Dict[str, Dict[str, List[str]]]:
    """
    Boards grouped by effective CI app key and output_suffix variant

    Returns:
        effective_app_name -> {suffix -> [boards]}
    """
    ci_boards: Dict[str, Dict[str, List[str]]] = {}

    for rec in records:
        app_suffix = get_app_suffix_from_json(rec.name)
        build_config = rec.build

        for app_name, build_entries in build_config.items():
            if app_name == "default":
                if "917-ncp" in rec.name:
                    effective_app_name = "_ncp_917_default"
                else:
                    continue
            else:
                effective_app_name = f"{app_name}{app_suffix}"

            for entry in build_entries:
                boards = entry.get("boards", [])
                arguments = entry.get("arguments", [])
                suffix = None
                for arg in arguments:
                    if "--output_suffix" in arg:
                        parts = arg.split()
                        for i, part in enumerate(parts):
                            if part == "--output_suffix" and i + 1 < len(parts):
                                suffix = parts[i + 1].split(",")[0]
                                break
                        break

                if not suffix and boards:
                    suffix = "_base"

                if not suffix or not boards:
                    continue

                if effective_app_name not in ci_boards:
                    ci_boards[effective_app_name] = {}
                if suffix not in ci_boards[effective_app_name]:
                    ci_boards[effective_app_name][suffix] = []

                slot = ci_boards[effective_app_name][suffix]
                for board in boards:
                    board_lower = board.lower()
                    if board_lower not in slot:
                        slot.append(board_lower)
                    if "," in board_lower:
                        base_board = board_lower.split(",")[0]
                        if base_board not in slot:
                            slot.append(base_board)

    return ci_boards

def boards_for_workspace_from_records(
    records: tuple[CiJsonRecord, ...],
    workspace_name: str,
    ci_source: str,
) -> List[str]:
    """Boards for one workspace from CI"""
    if not records:
        return []

    if ci_source in CI_SOURCE_JSON_GLOBS:
        pattern = CI_SOURCE_JSON_GLOBS[ci_source]
        json_files = [r for r in records if fnmatch.fnmatch(r.name, pattern)]
        app_name = "default"
    else:
        is_internal = "_internal" in workspace_name
        json_files = [r for r in records if r.is_internal == is_internal]
        app_name = ci_source

    boards: List[str] = []
    for rec in json_files:
        if app_name not in rec.build:
            continue
        for entry in rec.build[app_name]:
            for board in entry.get("boards", []):
                b = board.lower()
                if b not in boards:
                    boards.append(b)
    return boards

def load_variants_config() -> Dict:
    path = _SCRIPT_DIR / "metadata-generation.yml"
    if not path.exists():
        return {}
    try:
        with open(path, "r", encoding="utf-8") as f:
            data = yaml.safe_load(f)
        return data if isinstance(data, dict) else {}
    except (yaml.YAMLError, OSError) as e:
        log_warn(f"Could not load metadata-generation.yml: {e}")
        return {}

def run_command(cmd: list, check: bool = True, capture: bool = False, cwd: Path | None = None) -> Tuple[int, str, str]:
    """Run a shell command"""
    try:
        if capture:
            result = subprocess.run(cmd, check=check, capture_output=True, text=True, cwd=cwd)
            return result.returncode, result.stdout, result.stderr
        else:
            result = subprocess.run(cmd, check=check, cwd=cwd)
            return result.returncode, "", ""
    except subprocess.CalledProcessError as e:
        return e.returncode, getattr(e, 'stdout', '') or "", getattr(e, 'stderr', '') or ""
    except FileNotFoundError:
        log_error(f"Command not found: {cmd[0]}")
        if check:
            sys.exit(1)
        return 1, "", ""

def check_command_exists(command: str) -> bool:
    return shutil.which(command) is not None

def check_hwfilter_installed() -> bool:
    if check_command_exists("hwstudio"):
        log_info(f"hwfilter tools found: {shutil.which('hwstudio')}")
        return True
    return False

def check_virtualenv():
    """Check if running inside a virtual environment"""
    in_venv = (
        hasattr(sys, 'real_prefix') or
        (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix)
    )
    if not in_venv:
        log_error("This script must be run inside a Python virtual environment")
        log_error("Create and activate a venv first:")
        log_error("  python3 -m venv .venv")
        log_error("  source .venv/bin/activate")
        sys.exit(1)

def install_hwfilter():
    """Install hwfilter from GitHub"""
    log_info("Installing hwfilter from GitHub...")

    with tempfile.TemporaryDirectory() as temp_dir:
        log_info("Cloning hwfilter repository...")
        returncode, _, stderr = run_command(
            ["git", "clone", "--depth", "1", "-b", HWFILTER_BRANCH, HWFILTER_REPO, "hwfilter"],
            check=False, capture=True, cwd=Path(temp_dir)
        )

        if returncode != 0:
            log_error(f"Failed to clone hwfilter: {stderr}")
            sys.exit(1)

        hwfilter_dir = Path(temp_dir) / "hwfilter"
        log_info("Installing hwfilter package...")
        returncode, _, stderr = run_command(
            [sys.executable, "-m", "pip", "install", "."],
            check=False, capture=True, cwd=hwfilter_dir
        )

        if returncode != 0:
            log_error(f"Failed to install hwfilter: {stderr}")
            sys.exit(1)

    log_info("hwfilter installed successfully")

def check_prerequisites():
    """Check all prerequisites"""
    log_info("Checking prerequisites...")
    
    if sys.version_info < (3, 10):
        log_error("Python 3.10 or higher is required")
        sys.exit(1)
    
    check_virtualenv()
    
    if not check_command_exists("slt"):
        log_error("slt is not installed")
        sys.exit(1)
    
    if not check_command_exists("conan"):
        log_error("Conan is not installed")
        sys.exit(1)
    
    if not check_hwfilter_installed():
        log_warn("hwfilter tools not found")
        try:
            response = input("Install hwfilter now? (y/n) ").strip().lower()
            if response in ['y', 'yes']:
                install_hwfilter()
            else:
                log_error("hwfilter is required")
                sys.exit(1)
        except (EOFError, KeyboardInterrupt):
            sys.exit(1)
    
    if not check_command_exists("envsubst"):
        log_error("envsubst not installed (part of gettext package)")
        sys.exit(1)

def log_conan_download_notice() -> None:
    log_info(
        "Apply Conan remotes from packages/, then `slt update` for simplicity-sdk and wiseconnect."
    )

def setup_conan_environment():
    """Set up Conan environment variables"""
    conan_home = os.path.expanduser("~/.silabs/slt/installs/conan")
    os.environ["CONAN_HOME"] = conan_home
    os.environ["SLT_CI"] = "true"
    log_info(f"CONAN_HOME: {conan_home}")

def configure_conan_remotes(repo_root: Path):
    """Configure Conan remotes from packages/"""
    log_info("Configuring Conan remotes...")
    packages_dir = repo_root / "packages"
    
    returncode, _, stderr = run_command(
        ["conan", "config", "install", str(packages_dir)],
        check=False, capture=True, cwd=Path.home()
    )
    
    if returncode != 0:
        log_error(f"Failed to configure Conan remotes: {stderr}")
        sys.exit(1)

def _slt_where(package: str) -> str | None:
    """Return the install path for an slt package, or None if not found."""
    rc, out, _ = run_command(["slt", "where", package], check=False, capture=True)
    return out.strip() if rc == 0 and out.strip() else None

def update_slt_packages():
    """Update required slt packages"""
    log_info("Updating slt packages...")

    for package in ["simplicity-sdk", "wiseconnect"]:
        if not _slt_where(package):
            log_error(f"{package} not found; run: slt install {package}")
            sys.exit(1)
        run_command(["slt", "update", package], check=False, capture=True)

def get_slt_paths() -> dict:
    """Get slt package paths from simplicity-sdk and wiseconnect"""
    paths = {}

    simpl = _slt_where("simplicity-sdk")
    if not simpl:
        log_error("simplicity-sdk not found; run: slt install simplicity-sdk")
        sys.exit(1)

    device_component_dir = Path(simpl) / "platform_core" / "platform" / "Device" / "component"
    if not device_component_dir.exists():
        log_error(f"Device component path not found: {device_component_dir}")
        sys.exit(1)
    paths["THREAD_DEVICE_PATH"] = str(device_component_dir)

    board_component_dir = Path(simpl) / "boards" / "hardware" / "board" / "component"
    if not board_component_dir.exists():
        log_error(f"Board component path not found: {board_component_dir}")
        sys.exit(1)
    paths["THREAD_BOARD_PATH"] = str(board_component_dir)

    # SiWx91x components from wiseconnect
    wiseconnect = _slt_where("wiseconnect")
    if not wiseconnect:
        log_error("wiseconnect not found; run: slt install wiseconnect")
        sys.exit(1)
    paths["SI91X_DEVICE_PATH"] = f"{wiseconnect}/components/device/silabs/si91x/mcu/core/chip/component"
    paths["SI91X_BOARD_PATH"] = f"{wiseconnect}/components/board/silabs/component"

    return paths

def prepare_config(slt_paths: dict) -> Path:
    """Substitute environment variables in config file"""
    config_source = _SCRIPT_DIR / "hwfilter-config.yml"
    
    if not config_source.exists():
        log_error(f"Config not found: {config_source}")
        sys.exit(1)
    
    env = os.environ.copy()
    env.update(slt_paths)
    
    temp_fd, temp_path = tempfile.mkstemp(suffix='_hwfilter-config.yml', text=True)
    with os.fdopen(temp_fd, 'w') as f_out:
        with open(config_source, 'r') as f_in:
            subprocess.run(["envsubst"], stdin=f_in, stdout=f_out, env=env, check=True)
    
    return Path(temp_path)

def get_wifi_boards(slt_paths: dict) -> List[str]:
    """Get WiFi boards using hwfilter"""
    si91x_device = slt_paths.get("SI91X_DEVICE_PATH")
    si91x_board = slt_paths.get("SI91X_BOARD_PATH")
    
    if not si91x_device or not si91x_board:
        log_error("Missing Si91x paths")
        sys.exit(1)
    
    returncode, stdout, stderr = run_command(
        ["hwfilter", "+d", "device_si91x", "--devices", si91x_device, "--boards", si91x_board],
        check=False, capture=True
    )
    
    if returncode != 0:
        log_error(f"Failed to query WiFi boards: {stderr}")
        sys.exit(1)
    
    boards: List[str] = []
    text = stdout.strip()
    if text.startswith("{"):
        try:
            data = json.loads(text)
            raw = data.get("boards", [])
            boards = [str(b).lower() for b in raw if b]
        except json.JSONDecodeError:
            boards = []
    if not boards:
        in_boards = False
        for line in text.split("\n"):
            line = line.strip()
            if line.startswith("BOARDS"):
                in_boards = True
                continue
            if in_boards and line and not line.startswith("DEVICES"):
                boards.append(line.lower())
    
    if not boards:
        log_error("No WiFi boards found")
        sys.exit(1)
    
    return boards

def _demo_variant_rules_from_ci(
    ci_records: tuple[CiJsonRecord, ...],
    variants_config: Dict,
) -> List[dict]:
    """Build app_variant_rules list for demos.xml.j2 from CI variant matrix + enabled_variants"""
    app_variant_rules: List[dict] = []
    enabled_variants = variants_config.get("enabled_variants", {}) or {}
    ci_boards = variant_matrix_from_records(ci_records)
    default_patterns = {"_ncp_917_default": "917_ncp"}

    for ci_app_name, ci_suffixes in ci_boards.items():
        pattern = default_patterns.get(ci_app_name, ci_app_name)
        if ci_app_name.startswith("_") and ci_app_name not in default_patterns:
            continue
        for ci_suffix, boards in ci_suffixes.items():
            if ci_suffix == "_base":
                continue
            if ci_suffix not in enabled_variants:
                continue
            meta = enabled_variants[ci_suffix]
            app_variant_rules.append(
                {
                    "pattern": pattern,
                    "variants": [
                        {
                            "suffix": meta.get("demo_suffix", ""),
                            "label_suffix": meta.get("label_suffix", ""),
                            "blurb_suffix": meta.get("blurb_suffix", ""),
                            "description_suffix": meta.get("description_suffix", ""),
                            "solution_suffix": f"_{ci_suffix}",
                            "boards": boards,
                        }
                    ],
                }
            )
    return app_variant_rules

def prepare_template_with_version(
    repo_root: Path,
    template_name: str,
    slt_paths: dict,
    ci_records: tuple[CiJsonRecord, ...],
    variants_config: Dict,
) -> Path:

    app_variant_rules: List[dict] = []
    board_overrides: Dict[str, Dict[str, List[str]]] = {}

    templates_exclude = variants_config.get("templates_exclude", []) or []
    demos_exclude = variants_config.get("demos_exclude", []) or []

    if template_name == "templates.xml.j2":
        for app, config in (variants_config.get("templates_board_overrides") or {}).items():
            board_overrides[app] = {"boards": config.get("boards", [])}

    if template_name == "demos.xml.j2":
        use_ci_boards = variants_config.get("use_ci_boards_for_demos", {}) or {}
        for workspace_name, ci_source in use_ci_boards.items():
            boards = boards_for_workspace_from_records(ci_records, workspace_name, ci_source)
            if boards:
                board_overrides[workspace_name] = {"boards": boards}
        app_variant_rules = _demo_variant_rules_from_ci(ci_records, variants_config)

    slce_path = repo_root / "matter.slce"
    with open(slce_path, "r", encoding="utf-8") as f:
        slce_data = yaml.safe_load(f)
    matter_version = slce_data.get("version") if isinstance(slce_data, dict) else None
    if not matter_version:
        log_error("Version not found in matter.slce")
        sys.exit(1)
    wifi_boards = get_wifi_boards(slt_paths)

    template_path = _SCRIPT_DIR / template_name
    with open(template_path, "r", encoding="utf-8") as f:
        content = f.read()
    lines = [
        f'{{% set matter_version = "{matter_version}" -%}}',
        f'{{% set wifi_boards = {wifi_boards} -%}}',
    ]

    if template_name == "demos.xml.j2":
        lines.append(f'{{% set app_variant_rules = {app_variant_rules} -%}}')
    if board_overrides:
        lines.append(f'{{% set board_overrides = {board_overrides} -%}}')
    if templates_exclude:
        lines.append(f'{{% set templates_exclude = {templates_exclude} -%}}')
    if demos_exclude:
        lines.append(f'{{% set demos_exclude = {demos_exclude} -%}}')

    content = "\n".join(lines) + "\n" + content

    temp_fd, temp_path = tempfile.mkstemp(suffix=f"_{template_name}", text=True)
    with os.fdopen(temp_fd, "w", encoding="utf-8") as f:
        f.write(content)

    return Path(temp_path)

def _run_hwstudio(
    output_file: str,
    config_path: Path,
    template_path: Path,
    demo: bool = False,
) -> bool:
    cmd = ["hwstudio"]
    if demo:
        cmd.append("--demo")
    cmd.extend([
        "-o", output_file,
        "slc/apps/**/*.slc[pw]",
        "-c", str(config_path),
        "-t", str(template_path),
        "-q", "internal",
    ])
    run_command(cmd, check=False, capture=True)
    return Path(output_file).exists()

def generate_metadata(
    repo_root: Path,
    slt_paths: dict,
    config_path: Path,
    ci_records: tuple[CiJsonRecord, ...],
    variants_config: Dict,
):
    os.chdir(repo_root)

    temp_files = []

    try:
        temp_templates = prepare_template_with_version(
            repo_root, "templates.xml.j2", slt_paths, ci_records, variants_config
        )
        temp_files.append(temp_templates)

        log_info("Generating templates XML...")
        if _run_hwstudio("matter_templates.xml", config_path, temp_templates):
            log_info("Generated matter_templates.xml")

        temp_demos = prepare_template_with_version(
            repo_root, "demos.xml.j2", slt_paths, ci_records, variants_config
        )
        temp_files.append(temp_demos)

        log_info("Generating demos XML...")
        if _run_hwstudio("matter_demos.xml", config_path, temp_demos, demo=True):
            log_info("Generated matter_demos.xml")

        log_info("Generating board compatibility matrix...")
        run_command(
            ["hwmatrix", "-o", "board_compatibility_matrix.html",
             "slc/apps/**/*.slc[pw]", "-c", str(config_path)],
            check=False, capture=True,
        )
        if (repo_root / "board_compatibility_matrix.html").exists():
            log_info("Generated board_compatibility_matrix.html")

    finally:
        for f in temp_files:
            if f and f.exists():
                f.unlink()

def main():
    repo_root = _SCRIPT_DIR.parent.parent
    
    print("=" * 42)
    print("Generate Matter studio metadata")
    print("=" * 42)
    print()
    
    check_prerequisites()
    print()
    
    log_conan_download_notice()
    print()

    setup_conan_environment()
    configure_conan_remotes(repo_root)
    update_slt_packages()
    print()
    
    slt_paths = get_slt_paths()
    print()
    
    config_path = prepare_config(slt_paths)

    variants_config = load_variants_config()
    ci_records = load_ci_json_records(repo_root / ".github", "full")

    try:
        generate_metadata(repo_root, slt_paths, config_path, ci_records, variants_config)
    finally:
        if config_path and config_path.exists():
            config_path.unlink()
    
    print()
    print("=" * 42)
    print("Metadata generation complete")
    print("=" * 42)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print()
        log_error("Cancelled")
        sys.exit(1)
    except Exception as e:
        log_error(f"Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
