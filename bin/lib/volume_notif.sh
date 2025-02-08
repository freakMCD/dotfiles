audiovolumechange="/home/edwin/Music/freedesktop/audio-volume-change.oga"

function get_volume {
    wpctl get-volume @DEFAULT_SINK@ | awk '{print $2*100}'
}

function volume_notification {
    volume=$(get_volume)

    # Show the volume notification
    notify-send -r 2000 -t 1000 -u low -h int:value:"$volume" "Volume: ${volume}%"

    # Play the volume changed sound
    pw-cat --playback $audiovolumechange

}

function mute_notification {
    muted=$(wpctl get-volume @DEFAULT_SINK@ | awk '{print $3}')

    if [[ $muted == "[MUTED]" ]]; then
        notify-send -r 2000 -t 0 -u low "muted"
    else
        notify-send -r 2000 -t 1000 -u low "unmuted"
        pw-cat --playback $audiovolumechange
    fi
}

function mic_notification {
	volume=$(wpctl get-volume @DEFAULT_SOURCE@ | awk '{print $3}')
	
	if [[ "$volume" == "[MUTED]" ]]; then
		notify-send -r 2001 -t 0 -u low --hint=string:x-dunst-stack-tag:mic "󰍭"
    else
		notify-send -r 2001 -t 5000 -u low --hint=string:x-dunst-stack-tag:mic "󰍬"
    pw-cat --playback $audiovolumechange
	fi
}

case $1 in
    up)
        wpctl set-volume @DEFAULT_SINK@ 0.05+
        volume_notification
        ;;
    down)
        wpctl set-volume @DEFAULT_SINK@ 0.05-
        volume_notification
	    ;;
    mute)
        wpctl set-mute @DEFAULT_SINK@ toggle
        mute_notification
        ;;
    mic)
        wpctl set-mute @DEFAULT_SOURCE@ toggle
        mic_notification
        ;;
    *)
        echo "Usage: $0 up | down | mute"
        ;;
esac
