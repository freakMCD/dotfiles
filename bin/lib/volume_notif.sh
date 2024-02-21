#!/bin/bash
# changeVolume
audiovolumechange="/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"

function get_volume {
    pactl get-sink-volume 0 | awk '{print $5}' | cut -d '%' -f 1
}

function volume_notification {
    volume=$(get_volume)

    # Show the volume notification
    notify-send -r 2000 -u low -h int:value:"$volume" "Volume: ${volume}%"

    # Play the volume changed sound
    paplay $audiovolumechange

}

function mute_notification {
    muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

    if [ $muted == 'yes' ]
    then
        notify-send -r 2000 -t 0 "muted"
    else
        notify-send -r 2000 -t 1000 "unmuted"
        paplay $audiovolumechange
    fi
}

function mic_notification {
	volume=$(pactl get-source-mute 0)
	
	if [[ "$volume" == "Mute: yes" ]]; then
		notify-send -r 2001 -t 0 --hint=string:x-dunst-stack-tag:mic ""
	elif [[ "$volume" == "Mute: no" ]]; then
		notify-send -r 2001 -t 5000 --hint=string:x-dunst-stack-tag:mic ""
	else 
		notify-send "CODE WHEN WRONG"
	fi
}

case $1 in
    up)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        volume_notification
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        volume_notification
	    ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        mute_notification
        ;;
    mic)
        pactl set-source-mute @DEFAULT_SOURCE@ toggle
        mic_notification
        ;;
    *)
        echo "Usage: $0 up | down | mute"
        ;;
esac
