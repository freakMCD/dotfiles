#!/bin/bash

trap "echo 'Script interrupted. Exiting...'; exit" SIGINT

cd ~/Music/2015-2022/

# Define a list of URLs and their respective artists
declare -A playlists=(
    ["https://www.youtube.com/playlist?list=PLehPR0Z83CK5NLdMOLxEeTaTkxENI7yCf"]="IU"
    ["https://www.youtube.com/playlist?list=PLPKUmrgeihqyK8ub4qD4q9PqcWwNBDWQv"]="Laur"
    ["https://www.youtube.com/playlist?list=PLcP7SWneqXTRFZzISG8AN_59_0ahOI9pf"]="Sakuzyo"
    ["https://www.youtube.com/playlist?list=PLvoJm-S4aIsz8zZy2vAGl2SOQ8USlGLVo"]="Yo Kaze"
)

# Define filters
default_filter="duration>300 & duration<1500"
common_filter="duration>200 & duration<1500"

# Artists using the common filter
common_filter_artists=("IU")

# Function to determine the filter for a given artist
get_filter() {
    local artist="$1"
    if [[ " ${common_filter_artists[*]} " == *" $artist "* ]]; then
        echo "$common_filter"
    else
        echo "$default_filter"
    fi
}

# Loop through playlists and download with correct artist
for url in "${!playlists[@]}"; do
    artist="${playlists[$url]}"
    filter=$(get_filter "$artist")
    yt-dlp --parse-metadata " $artist: %(meta_artist)s" --match-filter "$filter" "$url"
done
