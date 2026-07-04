#!/usr/bin/env python3

import random
import subprocess
import sys
from pathlib import Path
from mutagen import File
from collections import defaultdict

AUDIO_EXTENSIONS = {
    ".mp3",
    ".m4a",
    ".flac",
    ".ogg",
}

library_root = Path.home() / "Music"   # or read from mpd.conf

def chunks(lst, n=500):
    for i in range(0, len(lst), n):
        yield lst[i:i+n]

def get_album(path: Path):
    audio = File(path, easy=True)
    if audio is None:
        return None

    album = audio.get("album")
    if album:
        return album[0].strip()

    return "(Unknown Album)"

def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} DIRECTORY")
        sys.exit(1)

    music_dir = Path(sys.argv[1]).expanduser().resolve()

    if not music_dir.is_dir():
        print(f"{music_dir} is not a directory")
        sys.exit(1)

    albums = defaultdict(list)

    for f in music_dir.rglob("*"):
        if f.is_file() and f.suffix.lower() in AUDIO_EXTENSIONS:
            album = get_album(f)
            if album is None:
                print(f"Skipping {f.name}: no album tag")
                continue
            albums[album].append(f)

    order = list(albums)
    random.shuffle(order)

    subprocess.run(["mpc", "clear"], check=True)

    print("Album order:\n")

    playlist = []

    for i, album in enumerate(order, 1):
        print(f"{i:2}. {album}")

        songs = sorted(albums[album], key=lambda p: p.name.casefold())
        playlist.extend(str(song.relative_to(library_root)) for song in songs)

    for chunk in chunks(playlist):
        subprocess.run(
            ["mpc", "add", *chunk],
            check=True,
            stdout=subprocess.DEVNULL,
        )

    print("\nDone.")

if __name__ == "__main__":
    main()
