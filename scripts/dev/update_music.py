#!/usr/bin/env python3

import re
import subprocess
from pathlib import Path

BASE_DIR = Path.home() / "Music"
COOKIES = "firefox"
RCLONE_REMOTE = "drive:Music"

PLAYLISTS = {
    "Sennzai": "https://youtube.com/playlist?list=PLJ0hTVb5gQ2k",
    "The Hall": "https://youtube.com/playlist?list=PLHr6QN96Td6g",
}

AUDIO_EXTENSIONS = {".m4a", ".mp3", ".opus", ".webm"}
VIDEO_ID = re.compile(r" \[([A-Za-z0-9_-]{11})\]$")

def metadata_options(artist: str | None):
    source = (
        f" {artist}" if artist else
        "%(artist,artists,creator,creators,uploader,uploader_id|)s"
    )
    options = [
        "--parse-metadata", "%(title)s:%(meta_title)s",
        "--parse-metadata", f"{source}:%(meta_artist)s",
    ]

    replacements = (
        (r"^(.+)\s+\(\1\)$", r"\1"),
        (r"\s*,.*", ""),
        (r"\s+[\(\[【].*$", ""),
    )
    for field in ("meta_title", "meta_artist"):
        for pattern, replacement in replacements:
            options += ["--replace-in-metadata", field, pattern, replacement]

    return options + [
        "--parse-metadata",
        r":(?P<meta_synopsis>)(?P<meta_description>)(?P<meta_purl>)",
    ]

def get_youtube_ids(url: str):
    return set(subprocess.check_output([
        "yt-dlp", "--flat-playlist",
        "--cookies-from-browser", COOKIES,
        "--compat-options", "no-youtube-unavailable-videos",
        "--print", "%(id)s", url,
    ], text=True).split())

def get_local_ids(directory: Path) -> set[str]:
    return {
        match.group(1)
        for file in directory.iterdir()
        if file.is_file()
        if file.suffix.lower() in AUDIO_EXTENSIONS
        if (match := VIDEO_ID.search(file.stem))
    }

def download(video_ids: set[str], outdir: Path, artist: str | None):
    if not video_ids:
        return

    urls = [
        f"https://www.youtube.com/watch?v={video_id}"
        for video_id in sorted(video_ids)
    ]

    subprocess.run(
        [
            "yt-dlp",
            "-f", "bestaudio[ext=m4a]/bestaudio",
            "--remux-video", "m4a",
            "--cookies-from-browser", COOKIES,
            "--restrict-filenames",
            *metadata_options(artist),
            "--embed-metadata",
            "--embed-thumbnail",
            "-o", str(outdir / "%(meta_title)s [%(id)s].%(ext)s"),
            *urls,
        ],
        check=True,
    )

def update_playlist(name: str, url: str):
    outdir = BASE_DIR / name
    outdir.mkdir(parents=True, exist_ok=True)

    print(f"\033[93mUpdating {name}\033[0m")

    youtube_ids = get_youtube_ids(url)
    missing = youtube_ids - get_local_ids(outdir)
    artist = None if name == "The Hall" else Path(name).name

    download(missing, outdir, artist)

    remaining = youtube_ids - get_local_ids(outdir)
    if remaining:
        raise RuntimeError(f"{name}: {len(remaining)} tracks remain missing")

    print(
        f"✔ {name}: {len(missing)} downloaded, "
        f"{len(youtube_ids)} visible entries"
    )

    return len(youtube_ids), len(missing)

def rclone_sync():
    print("\033[96mRunning rclone sync\033[0m")
    subprocess.run(["rclone", "--transfers", "8", "--checkers", "16",
                    "--retries-sleep", "10s", "-P", "sync",
                    str(BASE_DIR), RCLONE_REMOTE], check=True)

def main():
    BASE_DIR.mkdir(parents=True, exist_ok=True)
    total_entries = total_added = 0

    for name, url in PLAYLISTS.items():
        entries, added = update_playlist(name, url)
        total_entries += entries
        total_added += added
        print()

    print(f"Visible playlist entries: {total_entries}")
    print(f"Downloaded: {total_added}\n")

    rclone_sync()


if __name__ == "__main__":
    main()
