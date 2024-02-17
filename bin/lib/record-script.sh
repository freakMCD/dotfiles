#!/bin/bash

output_file=~/MediaHub/recordings/recording_$(date +"%Y%m%d_%H%M%S").mp4
sink="alsa_output.pci-0000_30_00.6.analog-stereo.monitor"

if [[ "$(pidof wf-recorder)" == "" ]]; then
    wf-recorder -f "$output_file" --audio="$sink" -c libx264 -C aac -x yuv420p --geometry "$(slurp && \
    notify-send -t 0 -r 12345 "wf-recorder" "Starting recording" -a 'wf-recorder')"
    
else
    /usr/bin/kill --signal SIGINT wf-recorder
    notify-send -t 3000 -r 12345 "wf-recorder" "Recording Stopped" -a 'wf-recorder'
fi
