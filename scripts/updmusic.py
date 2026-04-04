#!/usr/bin/env python3

import re
import subprocess
from pathlib import Path

MUSIC_DIR = Path.home() / "Music"

PLAYLISTS = {
    "IU": "https://youtube.com/playlist?list=PL4CmunqMOJjLgSDqC8hShU51YH_ORsCXA",
    "Sakuzyo": "https://youtube.com/playlist?list=PL4CmunqMOJjJi3tbYxKbWV1HUzI6ZhsPZ",
    "Feryquitous": "https://youtube.com/playlist?list=PLjYilp-bySE1qwXLKHWZZcHbqWaetqyaM",
}

def get_playlist_ids(url):
    result = subprocess.run(
        ["yt-dlp", "--flat-playlist", "--print", "id", url],
        capture_output=True,
        text=True,
    )
    return {line for line in result.stdout.splitlines() if line}

def extract_id(filename):
    m = re.search(r"\[([a-zA-Z0-9_-]{11})\]", filename)
    return m.group(1) if m else None


def clean_archive(archive_file, removed_ids):
    if not archive_file.exists() or not removed_ids:
        return

    lines = archive_file.read_text().splitlines()
    with open(archive_file, "w") as f:
        for line in lines:
            if not any(vid in line for vid in removed_ids):
                f.write(line + "\n")

    print("Archive cleaned")


try:
    for name, url in PLAYLISTS.items():
        print(f"\n== {name} ==")

        playlist_dir = MUSIC_DIR / name
        playlist_dir.mkdir(parents=True, exist_ok=True)

        archive_file = playlist_dir / ".archive"
        output_template = playlist_dir / "%(title)s [%(id)s].%(ext)s"

        # --- Fetch remote playlist IDs ---
        playlist_ids = get_playlist_ids(url)

        if not playlist_ids:
            print("[!] Failed to fetch playlist IDs. Skipping to avoid data loss.")
            continue

        # --- Scan local files and extract video IDs ---
        local_ids = set()
        files = list(playlist_dir.glob("*.*"))

        for file in files:
            vid = extract_id(file.name)
            if vid:
                local_ids.add(vid)

        # --- Differences ---
        missing_ids = playlist_ids - local_ids
        removed_ids = local_ids - playlist_ids

        # Allow re-download of missing files by updating the archive
        if archive_file.exists() and missing_ids:
            lines = archive_file.read_text().splitlines()
            with open(archive_file, "w") as f:
                for line in lines:
                    if not any(vid in line for vid in missing_ids):
                        f.write(line + "\n")

            print(f"Restoring {len(missing_ids)} missing files")

        parse_title = r"title:^(?i:)(?:[\【\[].*?[\】\]]\s*)*(?P<title>.*?)(?:\s*(?:[\【\[].*?[\】\]]|\(Audio\)|Official))*$"
        clear_metadata = r":(?P<meta_synopsis>)(?P<meta_description>)(?P<meta_purl>)"

        # --- download ---
        print("Downloading...\n")

        proc = subprocess.Popen([
            "yt-dlp",
            "-f", "bestaudio[ext=m4a]/bestaudio",
            "--remux-video", "m4a",
            "--cookies-from-browser", "firefox",
            "--restrict-filenames",

            "--parse-metadata", parse_title,
            "--parse-metadata", clear_metadata, 
            "--embed-metadata", 
            "--embed-thumbnail",

            "--compat-options", "no-youtube-unavailable-videos",
            "--yes-playlist",
            "--print", "%(playlist_index)s - %(title)s", "--no-simulate",
            "--download-archive", str(archive_file),
            "-o", str(output_template),
            url
        ])

        proc.wait()

        # Remove local files that were deleted from the remote playlist
        if removed_ids:
            print(f"\nRemoving {len(removed_ids)} files...")
            for file in files:
                vid = extract_id(file.name)
                if vid in removed_ids:
                    print(f"  - {file.name}")
                    file.unlink()

        # --- archive consistency ---
        clean_archive(archive_file, removed_ids)


except KeyboardInterrupt:
    print("\n[!] Interrupted. Exiting cleanly.")
