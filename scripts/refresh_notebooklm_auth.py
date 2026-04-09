#!/usr/bin/env python3
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path


DEFAULT_NOTEBOOKLM = Path.home() / ".codex-tools" / "notebooklm-py" / "bin" / "notebooklm"
DEFAULT_VENV_PYTHON = Path.home() / ".codex-tools" / "notebooklm-py" / "bin" / "python"
DEFAULT_STORAGE = Path.home() / ".notebooklm" / "storage_state.json"
DEFAULT_PROFILE = Path.home() / ".notebooklm" / "browser_profile_realchrome_fresh"
DEFAULT_CHROME = Path("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")
NOTEBOOKLM_URL = "https://notebooklm.google.com/"
GOOGLE_ACCOUNTS_URL = "https://accounts.google.com/"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Refresh NotebookLM auth using the locally installed Google Chrome.",
    )
    parser.add_argument(
        "--mode",
        choices=("refresh", "login"),
        default="refresh",
        help="Use refresh for non-interactive cookie rehydrate or login for manual sign-in.",
    )
    parser.add_argument("--notebooklm-bin", default=str(DEFAULT_NOTEBOOKLM))
    parser.add_argument("--python-bin", default=str(DEFAULT_VENV_PYTHON))
    parser.add_argument("--storage", default=str(DEFAULT_STORAGE))
    parser.add_argument("--profile-dir", default=str(DEFAULT_PROFILE))
    parser.add_argument("--chrome-executable", default=str(DEFAULT_CHROME))
    return parser.parse_args()


def auth_check(notebooklm_bin: Path, storage: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [str(notebooklm_bin), "--storage", str(storage), "auth", "check", "--test"],
        check=False,
        text=True,
        capture_output=True,
    )


def auth_check_is_valid(result: subprocess.CompletedProcess[str]) -> bool:
    output = "\n".join(part for part in (result.stdout, result.stderr) if part)
    if "Token fetch" in output and "✗ fail" in output:
        return False
    if "Authentication expired or invalid" in output:
        return False
    return result.returncode == 0


def run_playwright_refresh(
    python_bin: Path,
    storage: Path,
    profile_dir: Path,
    chrome_executable: Path,
    mode: str,
) -> int:
    refresh_snippet = r"""
from pathlib import Path
from playwright.sync_api import sync_playwright

storage = Path(__STORAGE__)
profile_dir = Path(__PROFILE__)
chrome_executable = Path(__CHROME__)
mode = __MODE__

storage.parent.mkdir(parents=True, exist_ok=True)
profile_dir.mkdir(parents=True, exist_ok=True)

with sync_playwright() as p:
    context = p.chromium.launch_persistent_context(
        user_data_dir=str(profile_dir),
        headless=False,
        executable_path=str(chrome_executable),
        args=[
            "--disable-blink-features=AutomationControlled",
            "--password-store=basic",
        ],
        ignore_default_args=["--enable-automation"],
    )
    try:
        page = context.pages[0] if context.pages else context.new_page()
        page.goto(__GOOGLE__, wait_until="load")
        page.goto(__NOTEBOOKLM__, wait_until="load")

        if mode == "login" and "notebooklm.google.com" not in page.url:
            print("Complete Google login in the opened Chrome window, then return here.")
            input("[Press ENTER when NotebookLM is open] ")
            page.goto(__GOOGLE__, wait_until="load")
            page.goto(__NOTEBOOKLM__, wait_until="load")

        print(f"FINAL_URL={page.url}")
        if "notebooklm.google.com" not in page.url:
            raise SystemExit(2)

        context.storage_state(path=str(storage))
        storage.chmod(0o600)
    finally:
        context.close()
"""
    snippet = (
        refresh_snippet.replace("__STORAGE__", repr(str(storage)))
        .replace("__PROFILE__", repr(str(profile_dir)))
        .replace("__CHROME__", repr(str(chrome_executable)))
        .replace("__MODE__", repr(mode))
        .replace("__GOOGLE__", repr(GOOGLE_ACCOUNTS_URL))
        .replace("__NOTEBOOKLM__", repr(NOTEBOOKLM_URL))
    )
    completed = subprocess.run(
        [str(python_bin), "-c", snippet],
        check=False,
        text=True,
    )
    return completed.returncode


def main() -> int:
    args = parse_args()
    notebooklm_bin = Path(args.notebooklm_bin).expanduser()
    python_bin = Path(args.python_bin).expanduser()
    storage = Path(args.storage).expanduser()
    profile_dir = Path(args.profile_dir).expanduser()
    chrome_executable = Path(args.chrome_executable).expanduser()

    initial_check = auth_check(notebooklm_bin, storage)
    if auth_check_is_valid(initial_check) and args.mode == "refresh":
        print("NotebookLM auth already valid.")
        return 0

    refresh_code = run_playwright_refresh(
        python_bin=python_bin,
        storage=storage,
        profile_dir=profile_dir,
        chrome_executable=chrome_executable,
        mode=args.mode,
    )
    if refresh_code != 0:
        print("NotebookLM browser auth refresh did not reach NotebookLM.")
        return refresh_code

    final_check = auth_check(notebooklm_bin, storage)
    sys.stdout.write(final_check.stdout)
    sys.stderr.write(final_check.stderr)
    return 0 if auth_check_is_valid(final_check) else 1


if __name__ == "__main__":
    raise SystemExit(main())
