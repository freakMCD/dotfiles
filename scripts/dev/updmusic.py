#!/usr/bin/env python3
import re
import subprocess
from pathlib import Path

BASE_DIR = Path.home() / "Music"
COOKIES = "firefox"
AUDIO_EXTENSIONS = {".m4a", ".mp3", ".webm"}

RCLONE_REMOTE = "drive:Music"

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

PLAYLISTS = {
        "Korean": "https://youtube.com/playlist?list=PLIezlQjSDDHQ",
        "Japanese": "https://youtube.com/playlist?list=PLF2OjHLf89co",
        "The Hall": "https://youtube.com/playlist?list=PLAKUPxjXy7d0",
        }

PARSE_TITLE = r"title:^(?i:)(?:[\【\[].*?[\】\]]\s*)*(?P<title>.*?)(?:\s*(?:[\【\[].*?[\】\]]|\(Audio\)|Official))*$"
CLEAR_METADATA = r":(?P<meta_synopsis>)(?P<meta_description>)(?P<meta_purl>)"


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


VIDEO_ID = re.compile(r"\[([A-Za-z0-9_-]{11})\]")

def get_local_files(directory: Path) -> dict[str, Path]:
    return {
            match.group(1): file
            for file in directory.iterdir()
            if file.suffix.lower() in AUDIO_EXTENSIONS
            if (match := VIDEO_ID.search(file.name))
            }


# --- Actions ---
def delete_stale(local_map: dict[str, Path], to_delete: set[str]) -> list[str]:
    removed = []

    for vid in to_delete:
        path = local_map.get(vid)
        if path:
            path.unlink(missing_ok=True)
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

            "--parse-metadata", PARSE_TITLE,
            "--parse-metadata", CLEAR_METADATA,
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

def rclone_sync():
    cmd = [
            "rclone",
            *RCLONE_OPTS,
            "sync",
            str(BASE_DIR),
            RCLONE_REMOTE,
            ]

    print("\033[96mRunning rclone sync\033[0m")

    subprocess.run(cmd, check=True)

# --- Core reconciliation ---
def sync_playlist(name: str, url: str):
    outdir = BASE_DIR / name
    outdir.mkdir(parents=True, exist_ok=True)

    remote_ids = get_remote_ids(url)
    local_map = get_local_files(outdir)

    local_ids = set(local_map)

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

    final_ids = set(get_local_files(outdir))

    if final_ids != remote_ids:
        missing = remote_ids - final_ids
        extra = final_ids - remote_ids

        print(f"[WARN] {name} out of sync")
        if missing:
            print(f"  missing: {len(missing)}")
        if extra:
            print(f"  extra: {len(extra)}")

    return len(remote_ids), len(added) + len(removed)

# --- Main ---

def main():
    BASE_DIR.mkdir(parents=True, exist_ok=True)

    total = 0
    total_changes = 0

    for i, (name, url) in enumerate(PLAYLISTS.items()):
        playlist_total, changes = sync_playlist(name, url)
        total += playlist_total
        total_changes += changes

        if i < len(PLAYLISTS) - 1:
            print()

    print(f"Total: {total}\n")

    if total_changes > 0:
        rclone_sync()
    else:
        print("No changes. Skipping rclone sync.")

if __name__ == "__main__":
    main()
