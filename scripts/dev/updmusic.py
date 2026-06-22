#!/usr/bin/env python3
import re
import subprocess
from pathlib import Path

OUTDIR = Path.home() / "Music"
RCLONE_REMOTE = "drive:Music"

PLAYLIST_URL = "https://youtube.com/playlist?list=PL4CmunqMOJjLdhvhCILv7kwHRMSzdKLIm"
COOKIES = "firefox"

RCLONE_OPTS = [
    "--transfers", "8",
    "--checkers", "16",
    "-P",
    "--retries", "3",
    "--retries-sleep", "10s",
    "--fast-list",
    "--timeout", "300s",
    "--contimeout", "60s",
    "--size-only",
]

parse_title = r"title:^(?i:)(?:[\【\[].*?[\】\]]\s*)*(?P<title>.*?)(?:\s*(?:[\【\[].*?[\】\]]|\(Audio\)|Official))*$"
clear_metadata = r":(?P<meta_synopsis>)(?P<meta_description>)(?P<meta_purl>)"

# --- State extraction ---
def get_remote_ids(url: str) -> set[str]:
    cmd = [
        "yt-dlp",
        "--flat-playlist",
        "--cookies-from-browser", COOKIES,
        "--print", "%(id)s",
        "--compat-options", "no-youtube-unavailable-videos",
        url
    ]

    result = subprocess.run(cmd, capture_output=True, text=True, check=True)
    return set(line.strip() for line in result.stdout.splitlines() if line.strip())

def get_local_files(directory: Path) -> dict[str, Path]:
    """
    Returns mapping: video_id -> file_path
    """
    mapping = {}

    for file in directory.iterdir():
        if file.suffix.lower() in (".m4a", ".mp3", ".webm"):
            m = re.search(r"\[([A-Za-z0-9_-]{11})\]", file.name)
            if m:
                mapping[m.group(1)] = file

    return mapping

def delete_stale(local_map: dict[str, Path], to_delete: set[str]) -> list[str]:
    removed = []

    for vid in to_delete:
        path = local_map.get(vid)
        if path and path.exists():
            path.unlink()
            removed.append(path.name)

    return removed

def download_missing(to_download: set[str], outdir: Path) -> list[str]:
    if not to_download:
        return []

    video_urls = [f"https://www.youtube.com/watch?v={vid}" for vid in to_download]

    cmd = [
        "yt-dlp",
        "-f", "bestaudio[ext=m4a]/bestaudio",
        "--remux-video", "m4a",
        "--cookies-from-browser", COOKIES,
        "--restrict-filenames",

        "--parse-metadata", parse_title,
        "--parse-metadata", clear_metadata,
        "--embed-metadata",
        "--embed-thumbnail",

        "--compat-options", "no-youtube-unavailable-videos",
        "--no-simulate",

        "--print", "after_move:%(title)s|||%(id)s",

        "-o", str(outdir / "%(title)s [%(id)s].%(ext)s"),
        *video_urls
    ]

    added: list[str] = []

    with subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True) as proc:
        for line in proc.stdout:
            line = line.strip()
            if "|||" in line:
                title, _ = line.split("|||", 1)
                print(f"  + {title}")
                added.append(title)

        proc.wait()

    return added

def rclone_sync():
    cmd = [
        "rclone",
        *RCLONE_OPTS,
        "sync",
        str(OUTDIR),
        RCLONE_REMOTE,
    ]

    print("\033[96mRunning rclone sync\033[0m")

    subprocess.run(cmd, check=True)

# --- Core reconciliation ---

def sync_playlist():
    OUTDIR.mkdir(parents=True, exist_ok=True)

    remote_ids = get_remote_ids(PLAYLIST_URL)
    local_map = get_local_files(OUTDIR)

    local_ids = set(local_map)

    to_delete = local_ids - remote_ids
    to_download = remote_ids - local_ids

    # --- delete phase ---
    removed = delete_stale(local_map, to_delete)
    added = download_missing(to_download, OUTDIR)

    # --- OUTPUT ---
    if added or removed:
        for r in removed:
            print(f"  - {r}")

        print(f"   → +{len(added)} / -{len(removed)} ({len(remote_ids)})\n")
        print("✔️ Updated")
    else:
        print(f"✔️ Playlist is up to date ({len(remote_ids)})")

    final_map = get_local_files(OUTDIR)
    final_ids = set(final_map)

    if final_ids != remote_ids:
        missing = remote_ids - final_ids
        extra = final_ids - remote_ids

        print("[WARN] Playlist out of sync")
        if missing:
            print(f"  missing: {len(missing)}")
        if extra:
            print(f"  extra: {len(extra)}")

    return bool(added or removed)

def main():
    if sync_playlist():
        rclone_sync()
    else:
        print("No changes. Skipping rclone sync.")

if __name__ == "__main__":
    main()
