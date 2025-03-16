#!/usr/bin/env bash

titles_file="/tmp/mpv_titles"
states_file="/tmp/mpv_states"

# Initialize files
touch "$titles_file" "$states_file"
printf '\n\n\n' > "$titles_file"
printf '\n\n\n' > "$states_file"


# Function to generate numbered output
update_output() {
    local count=0
    while IFS= read -r title && IFS= read -r state <&3; do
        ((count++))
        echo "mpv${count}_title|string|${title:- }  "
        echo "mpv${count}_state|string|${state:-unknown}"
        echo "mpv${count}_number|string|  $count."
    done < "$titles_file" 3< "$states_file"
}

# Initial output
update_output
echo ""

# Watch for changes
while inotifywait -qq -e modify "$titles_file" "$states_file"; do
    update_output
    echo ""
done
