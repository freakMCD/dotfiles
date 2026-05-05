#!/usr/bin/env python3
import os
import re
import subprocess
from pathlib import Path

BASE_DIR = Path.home() / "Music"
COOKIES = "firefox"

PLAYLISTS = {
        "Reol": "https://youtube.com/playlist?list=PL4CmunqMOJjIEOx2QykN5aYmcBt9IVt6q",
        "IU": "https://youtube.com/playlist?list=PL4CmunqMOJjIx9FVH6nkaCZ-Iqwt6RjjM",
        "The Hall": "https://youtube.com/playlist?list=PL4CmunqMOJjKV-YIN5He2Bq08gFMLSOs9",
}

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


# --- Actions ---

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
                title, vid = line.split("|||", 1)
                print(f"  + {title}")
                added.append(title)

        proc.wait()

    return added

# --- Core reconciliation ---

def sync_playlist(name: str, url: str):
    outdir = BASE_DIR / name
    outdir.mkdir(parents=True, exist_ok=True)

    remote_ids = get_remote_ids(url)
    local_map = get_local_files(outdir)

    local_ids = set(local_map.keys())

    to_delete = local_ids - remote_ids
    to_download = remote_ids - local_ids

    # --- delete phase ---
    removed = delete_stale(local_map, to_delete)

    print(f"\033[93mSyncing {name}\033[0m") # Print header in yellow
    added = download_missing(to_download, outdir)

    # --- OUTPUT ---
    if added or removed:
        for r in removed:
            print(f"  - {r}")

        print(f"   → +{len(added)} / -{len(removed)} ({len(remote_ids)})\n")
        print(f"✔️ {name} updated")
    else:
        print(f"✔️ {name} is up to date ({len(remote_ids)})")

    final_map = get_local_files(outdir)
    final_ids = set(final_map.keys())

    if final_ids != remote_ids:
        missing = remote_ids - final_ids
        extra = final_ids - remote_ids

        print(f"[WARN] {name} out of sync")
        if missing:
            print(f"  missing: {len(missing)}")
        if extra:
            print(f"  extra: {len(extra)}")

    return len(remote_ids)

# --- Main ---

def main():
    BASE_DIR.mkdir(parents=True, exist_ok=True)
    os.chdir(BASE_DIR)

    total = 0

    for i, (name, url) in enumerate(PLAYLISTS.items()):
        total += sync_playlist(name, url)
        if i < len(PLAYLISTS) - 1:
            print()

    print(f"Total: {total}")

if __name__ == "__main__":
    main()
