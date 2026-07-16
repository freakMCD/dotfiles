#!/usr/bin/env python3

import random
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

from mutagen import File

AUDIO_EXTENSIONS = {".mp3", ".m4a", ".flac", ".ogg"}
LIBRARY_ROOT = Path.home() / "Music"
UNKNOWN_ALBUM = "(Unknown Album)"


def get_album(path):
    audio = File(path, easy=True)
    if audio is None:
        return None

    album = audio.get("album")
    return album[0].strip() if album else UNKNOWN_ALBUM


def get_track(path):
    track = File(path, easy=True).get("tracknumber")
    try:
        return int(track[0].split("/")[0]) if track else float("inf")
    except ValueError:
        return float("inf")


def main():
    if len(sys.argv) != 2:
        raise SystemExit(f"Usage: {sys.argv[0]} DIRECTORY")

    music_dir = Path(sys.argv[1]).expanduser().resolve()
    if not music_dir.is_dir():
        raise SystemExit(f"{music_dir} is not a directory")

    albums = defaultdict(list)

    for path in music_dir.rglob("*"):
        if path.is_file() and path.suffix.lower() in AUDIO_EXTENSIONS:
            album = get_album(path)
            if album is not None:
                albums[album].append(path)

    if not albums:
        raise SystemExit(f"No albums found in {music_dir}")

    album, songs = random.choice(list(albums.items()))
    songs.sort(key=lambda path: (get_track(path), path.name.casefold()))

    subprocess.run(["mpc", "clear"], check=True)
    subprocess.run(
        ["mpc", "add", *(str(song.relative_to(LIBRARY_ROOT)) for song in songs)],
        check=True,
        stdout=subprocess.DEVNULL,
    )

    print(f"Loaded: {album} ({len(songs)} tracks)")


if __name__ == "__main__":
    main()
