#!/usr/bin/env bash
touch /tmp/mpv_titles
touch /tmp/mpv_states
titles_file="/tmp/mpv_titles"
states_file="/tmp/mpv_states"

echo "mpv1_title|string|"
echo "mpv1_state|string|"
echo "mpv2_title|string|"
echo "mpv2_state|string|"
echo "mpv3_title|string|"
echo "mpv3_state|string|"

echo ""

while inotifywait -qq -e modify "$titles_file" "$states_file"; do
    echo "mpv1_title|string|$(sed -n 1p "$titles_file")"
    echo "mpv1_state|string|$(sed -n 1p "$states_file")"
    echo "mpv2_title|string|$(sed -n 2p "$titles_file")"
    echo "mpv2_state|string|$(sed -n 2p "$states_file")"
    echo "mpv3_title|string|$(sed -n 3p "$titles_file")"
    echo "mpv3_state|string|$(sed -n 3p "$states_file")"
    echo ""
done
