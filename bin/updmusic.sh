#!/bin/bash

# Exit on interrupt signal
trap "echo 'Script interrupted. Exiting...'; exit" SIGINT

# Define directories
dir=~/Music/2024
cd ~/Music
mkdir -p "$dir"

declare -A chill=(
    ["https://www.youtube.com/playlist?list=PL4CmunqMOJjKi1Mtlc3N5pedFJ5UgFobk"]="The Hall"
    ["https://www.youtube.com/playlist?list=PL4CmunqMOJjIkStqqrywj_o2whWaO9uRQ"]="Echo\: 2"
    ["https://www.youtube.com/playlist?list=PLf07F-mOry4_rJPuq0Km1I78Q6HMCujMO"]="Reol"
    ["https://www.youtube.com/playlist?list=PLz6DOTcCHlPCqi3MXe0Qlu-IeMPmymss2"]="Ado"
    ["https://www.youtube.com/playlist?list=PL1JxBieKp06LBAiOlziByhHyRwfMOLbDj"]="Babymetal"
    ["https://www.youtube.com/playlist?list=PLNv9SARzk_JYaL6MXCJym1PvtCWlaexcw"]="Fujii Kaze"
    ["https://www.youtube.com/playlist?list=PLBkOG5FFNCKwuqigmVPE_DrrdKKgEHpsZ"]="Sound Horizon"
    ["https://www.youtube.com/playlist?list=PLAsdGJurTv1DnTJwZAXc3Ct1C1Hgexari"]="IU"
    ["https://www.youtube.com/playlist?list=PLGhOCcpfhWjcakpbHXzej5KUYm-DH8vWk"]="IU Covers"
    ["https://www.youtube.com/playlist?list=PL4CmunqMOJjLJngQzRR6tExqelkRKa0Vc"]="Classics"
)

download_playlists() {
    declare -n playlists="$1"

    for url in "${!playlists[@]}"; do
        artist="${playlists[$url]}"
        filter="duration > 120 & duration < 600"

    echo -e "\e[1;32mDownloading $artist's playlist...\e[0m"

    yt-dlp -q --progress --parse-metadata " $artist:%(meta_artist)s" --match-filters "$filter & title!~='(?i)\blive\b'" \
           -o "$dir/%(title)s_%(id)s.%(ext)s" "$url"
done
}
download_playlists chill
