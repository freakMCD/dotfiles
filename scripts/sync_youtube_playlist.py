#!/usr/bin/env python3
"""Synchronize Edwin's YouTube Music playlist with ~/Music.

Managed tracks use yt-dlp's ``Title [VIDEO_ID].extension`` naming scheme.
The playlist is authoritative for managed-file membership:

* playlist videos missing locally are downloaded;
* managed local tracks absent from the playlist are removed;
* files without a recognizable YouTube video ID are never removed.

Run normally with no arguments. Use ``--dry-run`` to preview changes.
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
import sys
from collections.abc import Iterable, Sequence
from pathlib import Path

PLAYLIST_URL = "https://music.youtube.com/playlist?list=PLIShxClvdhyQ"
MUSIC_DIRECTORY = Path.home() / "Music"
YT_DLP = Path.home() / ".local/bin/yt-dlp"
FORMAT_SELECTOR = "bestaudio[ext=m4a]/bestaudio"
RCLONE_REMOTE = "drive:Music"

VIDEO_ID_RE = re.compile(r"^[A-Za-z0-9_-]{11}$")
MANAGED_FILE_RE = re.compile(
    r"\[([A-Za-z0-9_-]{11})\]\.(?:aac|flac|m4a|mka|mp3|ogg|opus|wav|webm)$",
    re.IGNORECASE,
)
KNOWN_UNAVAILABLE = {
    "needs_auth",
    "premium_only",
    "private",
    "subscriber_only",
}
DOWNLOAD_BATCH_SIZE = 100


class SyncError(RuntimeError):
    """A synchronization error safe to display without a traceback."""


def parse_args(argv: Sequence[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Mirror the configured YouTube Music playlist into ~/Music.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="show downloads and deletions without changing anything",
    )
    return parser.parse_args(argv)


def resolve_yt_dlp() -> str:
    path = YT_DLP.expanduser()
    if not path.is_file():
        raise SyncError(f"yt-dlp executable does not exist: {path}")
    return str(path)


def resolve_rclone() -> str:
    executable = shutil.which("rclone")
    if executable is None:
        raise SyncError("cannot find 'rclone' in PATH")
    return executable


def get_playlist(
    yt_dlp: str,
) -> tuple[list[dict[str, object]], bool]:
    command = [
        yt_dlp,
        "--ignore-config",
        "--yes-playlist",
        "--flat-playlist",
        "--dump-single-json",
        "--no-warnings",
        "--",
        PLAYLIST_URL,
    ]

    try:
        result = subprocess.run(
            command,
            check=True,
            stdout=subprocess.PIPE,
            stderr=None,
            text=True,
        )
    except subprocess.CalledProcessError as error:
        raise SyncError("yt-dlp could not read the complete playlist") from error

    try:
        payload = json.loads(result.stdout)
    except json.JSONDecodeError as error:
        raise SyncError("yt-dlp returned invalid playlist metadata") from error

    raw_entries = payload.get("entries") if isinstance(payload, dict) else None
    if not isinstance(raw_entries, list):
        raise SyncError("the supplied URL did not produce a playlist")

    entries: list[dict[str, object]] = []
    unresolved = False

    for raw_entry in raw_entries:
        if not isinstance(raw_entry, dict):
            unresolved = True
            continue

        video_id = raw_entry.get("id")
        if not isinstance(video_id, str) or not VIDEO_ID_RE.fullmatch(video_id):
            unresolved = True
            continue

        entries.append(raw_entry)

    if not entries:
        raise SyncError(
            "playlist contained no identifiable videos; refusing to synchronize"
        )

    return entries, unresolved


def scan_managed_tracks(directory: Path) -> dict[str, list[Path]]:
    tracks: dict[str, list[Path]] = {}

    for path in directory.iterdir():
        if not path.is_file():
            continue

        match = MANAGED_FILE_RE.search(path.name)
        if match:
            tracks.setdefault(match.group(1), []).append(path)

    return tracks


def chunks(values: Sequence[str], size: int) -> Iterable[Sequence[str]]:
    for start in range(0, len(values), size):
        yield values[start : start + size]


def download_missing(
    yt_dlp: str,
    video_ids: Sequence[str],
    directory: Path,
) -> None:
    output = str(directory / "%(title)s [%(id)s].%(ext)s")

    for batch in chunks(video_ids, DOWNLOAD_BATCH_SIZE):
        urls = [f"https://www.youtube.com/watch?v={video_id}" for video_id in batch]
        command = [
            yt_dlp,
            "--ignore-config",
            "--no-playlist",
            "--no-overwrites",
            "--embed-metadata",
            "--embed-thumbnail",
            "--format",
            FORMAT_SELECTOR,
            "--output",
            output,
            "--",
            *urls,
        ]

        try:
            subprocess.run(command, check=True)
        except subprocess.CalledProcessError as error:
            raise SyncError(
                "one or more downloads failed; no local tracks were deleted"
            ) from error


def sync_drive(rclone: str, directory: Path) -> None:
    try:
        subprocess.run(
            [rclone, "sync", str(directory), RCLONE_REMOTE],
            check=True,
        )
    except subprocess.CalledProcessError as error:
        raise SyncError(
            "local playlist sync completed, but rclone sync failed"
        ) from error


def describe_entry(entry: dict[str, object]) -> str:
    video_id = str(entry["id"])
    title = entry.get("title")
    return f"{title} [{video_id}]" if isinstance(title, str) else video_id


def validate_directory(directory: Path) -> Path:
    resolved = directory.expanduser().resolve()
    home = Path.home().resolve()

    if resolved == Path("/") or resolved == home:
        raise SyncError(f"refusing to use broad destination directory: {resolved}")

    if resolved.exists() and not resolved.is_dir():
        raise SyncError(f"destination is not a directory: {resolved}")

    return resolved


def main(argv: Sequence[str] | None = None) -> int:
    args = parse_args(argv)
    yt_dlp = resolve_yt_dlp()
    rclone = resolve_rclone()
    directory = validate_directory(MUSIC_DIRECTORY)

    print("Reading playlist…")
    entries, unresolved_entries = get_playlist(yt_dlp)

    playlist_ids = {str(entry["id"]) for entry in entries}
    local_tracks = scan_managed_tracks(directory) if directory.exists() else {}
    missing_entries = [entry for entry in entries if entry["id"] not in local_tracks]
    downloadable_entries = [
        entry
        for entry in missing_entries
        if entry.get("availability") not in KNOWN_UNAVAILABLE
    ]
    unavailable_entries = [
        entry
        for entry in missing_entries
        if entry.get("availability") in KNOWN_UNAVAILABLE
    ]
    extra_paths = sorted(
        path
        for video_id, paths in local_tracks.items()
        if video_id not in playlist_ids
        for path in paths
    )

    print(f"Playlist: {len(playlist_ids)} identifiable videos")
    print(f"Local:    {sum(map(len, local_tracks.values()))} managed tracks")
    print(f"Missing:  {len(downloadable_entries)} downloadable tracks")
    print(f"Extra:    {len(extra_paths)} managed tracks")

    if unavailable_entries:
        print(f"Skipped:  {len(unavailable_entries)} unavailable playlist entries")

    if downloadable_entries:
        print("\nWould download:" if args.dry_run else "\nDownloading:")
        for entry in downloadable_entries:
            print(f"  + {describe_entry(entry)}")

    if extra_paths:
        print("\nWould delete:" if args.dry_run else "\nDeleting after downloads:")
        for path in extra_paths:
            print(f"  - {path.name}")

    if unresolved_entries:
        print(
            "\nWarning: playlist contains entries without usable video IDs; "
            "deletion is disabled for safety.",
            file=sys.stderr,
        )

    if args.dry_run:
        print("\nWould run: rclone sync ~/Music drive:Music")
        return 0

    directory.mkdir(parents=True, exist_ok=True)

    if downloadable_entries:
        download_missing(
            yt_dlp,
            [str(entry["id"]) for entry in downloadable_entries],
            directory,
        )

    if not unresolved_entries:
        for path in extra_paths:
            path.unlink()

    print("\nSyncing ~/Music to drive:Music…")
    sync_drive(rclone, directory)

    print("\nSynchronization complete.")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except SyncError as error:
        print(f"error: {error}", file=sys.stderr)
        raise SystemExit(1) from None
