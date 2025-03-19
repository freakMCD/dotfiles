#!/usr/bin/env bash

titles_file="/tmp/mpv_titles"
states_file="/tmp/mpv_states"

# Initialize empty files
true > "$titles_file"
true > "$states_file"

update_output() {
    # Read current entries
    mapfile -t titles < "$titles_file"
    mapfile -t states < "$states_file"
    
    # Always output 3 entries with fallbacks
    for ((i=0; i<3; i++)); do
        num=$((i+1))
        title="${titles[$i]:- }"
        state="${states[$i]:-unknown}"
        echo "mpv${num}_title|string|$title"
        echo "mpv${num}_state|string|$state"
        echo "mpv${num}_number|string|$num."
    done
}

# Initial output
update_output
echo ""

# Watch for changes
while inotifywait -qq -e modify "$titles_file" "$states_file"; do
    update_output
    echo ""
done
