#!/usr/bin/env bash

count_file="/tmp/mpv_count"

# Create file if it doesn't exist
touch "$count_file"

# Initial output in Yambar format
echo "mpv_count|string|$(cat "$count_file")"
echo ""

# Watch for file changes and update
inotifywait -q -m -e modify "$count_file" | while read -r event
do
  # Read current value and format for Yambar
  echo "mpv_count|string|$(cat "$count_file")"
  echo ""
done
