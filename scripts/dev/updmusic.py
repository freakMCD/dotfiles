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
        ]

EQUILIBRIUM = {
     "Sennzai": "https://youtube.com/playlist?list=PLJ0hTVb5gQ2k",
     "Sakuzyo": "https://youtube.com/playlist?list=PLSjvpXedvrGM",
}

PLAYLISTS = {
    "The Hall": "https://youtube.com/playlist?list=PLHr6QN96Td6g",
    **{f"Equilibrium/{lang}": url for lang, url in EQUILIBRIUM.items()},
}

METADATA_REPLACEMENTS = [
    # Collapse duplicated titles: X (X) -> X
    (r"^(.+)\s+\(\1\)$", r"\1"),

    # Strip everything after a comma
    (r"\s*,.*", ""),

    # Strip everything after a parenthesis/bracket preceded by whitespace
    (r"\s+[\(\[【].*$", "")
]

# Force these embedded metadata fields to empty values
CLEAR_METADATA = r":(?P<meta_synopsis>)(?P<meta_description>)(?P<meta_purl>)"

# --- State extraction ---
def get_youtube_ids(url: str) -> set[str]:
    cmd = [
        "yt-dlp",
        "--flat-playlist",
        "--cookies-from-browser", COOKIES,
        "--print", "%(id)s",
        "--compat-options", "no-youtube-unavailable-videos",
        url,
    ]

    try:
        stdout = subprocess.run(cmd,capture_output=True,text=True,check=True,).stdout
    except subprocess.CalledProcessError as e:
        error = (e.stderr or e.stdout or str(e)).strip()
        raise RuntimeError(f"yt-dlp failed reading playlist:\n{error}") from e

    return {line for line in map(str.strip, stdout.splitlines()) if line}


VIDEO_ID = re.compile(r" \[([A-Za-z0-9_-]{11})\]$")

def get_local_files(directory: Path) -> dict[str, Path]:
    return {
            match.group(1): file
            for file in directory.iterdir()
            if file.suffix.lower() in AUDIO_EXTENSIONS
            if (match := VIDEO_ID.search(file.stem))
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

def download_missing(
    to_download: set[str],
    outdir: Path,
    artist_override: str | None = None,
) -> list[str]:
    if not to_download:
        return []

    video_urls = [f"https://www.youtube.com/watch?v={vid}" for vid in to_download]

    cmd = [
        "yt-dlp",
        "-f", "bestaudio[ext=m4a]/bestaudio",
        "--remux-video", "m4a",
        "--cookies-from-browser", COOKIES,
        "--restrict-filenames",
        "--compat-options", "no-youtube-unavailable-videos",
        "--no-simulate",
    ]

    cmd += [
        "--parse-metadata", "%(title)s:%(meta_title)s",
    ]

    if artist_override is not None:
        cmd += [
            "--parse-metadata", f" {artist_override}: %(meta_artist)s",
        ]
    else:
        cmd += [
            "--parse-metadata",
            "%(artist,artists,creator,creators,uploader,uploader_id|)s:%(meta_artist)s",
        ]

    for field in ("meta_title", "meta_artist"):
        for pattern, replacement in METADATA_REPLACEMENTS:
            cmd += ["--replace-in-metadata", field, pattern, replacement]

    cmd += [
        "--parse-metadata", CLEAR_METADATA,
        "--embed-metadata",
        "--embed-thumbnail",
        "--print", "after_move:%(meta_title)s|||%(id)s",

        "-o", str(outdir / "%(meta_title)s [%(id)s].%(ext)s"),
        *video_urls,
    ]

    added: list[str] = []

    with subprocess.Popen(cmd, stdout=subprocess.PIPE, text=True) as proc:
        assert proc.stdout is not None

        for line in proc.stdout:
            line = line.strip()
            if "|||" in line:
                title, _ = line.split("|||", 1)
                print(f"  + {title}")
                added.append(title)

        returncode = proc.wait()

    if returncode != 0:
        raise subprocess.CalledProcessError(returncode, cmd)

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

    print(f"\033[93mSyncing {name}\033[0m")

    youtube_ids = get_youtube_ids(url)
    local_map = get_local_files(outdir)
    local_ids = set(local_map)

    to_delete = local_ids - youtube_ids
    to_download = youtube_ids - local_ids

    artist_override = None
    if name.startswith("Equilibrium/"):
        artist_override = Path(name).name

    removed = delete_stale(local_map, to_delete)
    added = download_missing(to_download, outdir, artist_override=artist_override)

    # --- OUTPUT ---
    if added or removed:
        for r in removed:
            print(f"  - {r}")

        print(f"   → +{len(added)} / -{len(removed)} ({len(youtube_ids)})\n")
        print(f"✔️ {name} updated")
    else:
        print(f"✔️ {name} is up to date ({len(youtube_ids)})")

    final_ids = set(get_local_files(outdir))

    if final_ids != youtube_ids:
        missing = youtube_ids - final_ids
        extra = final_ids - youtube_ids

        print(f"[ERROR] {name} local mirror does not match YouTube")
        if missing:
            print(f"  missing from local: {len(missing)}")
        if extra:
            print(f"  extra in local: {len(extra)}")

        raise RuntimeError(f"{name} did not sync cleanly")

    return len(youtube_ids), len(added) + len(removed)

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
