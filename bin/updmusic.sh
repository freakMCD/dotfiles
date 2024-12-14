#!/bin/bash

trap "echo 'Script interrupted. Exiting...'; exit" SIGINT

cd ~/Music/2015-2022/

# Define a list of URLs and their respective artists
declare -A playlists=(
    ["https://www.youtube.com/playlist?list=PLehPR0Z83CK5NLdMOLxEeTaTkxENI7yCf"]="IU"
    ["https://www.youtube.com/playlist?list=PLvoJm-S4aIsyku-i5SCMlYd5mcQqzh3FK"]="Yo Kaze"
)

# Define filters
default_filter="duration>200 & duration<1500"

# Loop through playlists and download with correct artist
for url in "${!playlists[@]}"; do
    artist="${playlists[$url]}"
    yt-dlp --parse-metadata " $artist: %(meta_artist)s" --match-filter "$default_filter" "$url"
done
