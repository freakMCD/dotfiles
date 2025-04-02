#!/usr/bin/env bash

cd ~/MediaHub/recordings/
output_file=~/MediaHub/recordings/recording_$(date +"%Y%m%d_%H%M%S").mp4
sink="alsa_output.pci-0000_30_00.6.analog-stereo.monitor"

if ! pgrep -x wf-recorder >/dev/null; then
    geometry=$(slurp) || exit 1  # Exit immediately if slurp is canceled
    
    notify-send -u low -t 0 -r 12345 "wf-recorder" "Recording" -a 'wf-recorder' &
    wf-recorder -f "$output_file" \
        --audio="$sink" \
        -c libx264 \
        -C aac \
        -x yuv420p \
        --geometry "$geometry"
else
    pkill -INT -x wf-recorder
    notify-send -r 12345 -t 2000 "wf-recorder" "Recording stopped" -a 'wf-recorder'
fi
