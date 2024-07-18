#!/bin/bash
pactl load-module module-null-sink sink_name=merged1
pactl load-module module-loopback source=alsa_input.usb-GENERAL_WEBCAM-02.pro-input-0 sink=merged1
pactl load-module module-loopback source=alsa_output.pci-0000_30_00.6.analog-stereo.monitor sink=merged1
