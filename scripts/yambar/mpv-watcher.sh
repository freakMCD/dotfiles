#!/usr/bin/env bash

titles_file="/tmp/mpv_count"

# Create file if it doesn't exist
touch "$titles_file"

# Initial output in Yambar format
echo "mpv_count|string|$(cat "$titles_file")"
echo ""

# Watch for file changes and update
inotifywait -q -m -e modify "$titles_file" | while read -r event
do
  # Read current value and format for Yambar
  echo "mpv_count|string|$(cat "$titles_file")"
  echo ""
done
