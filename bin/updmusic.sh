#!/bin/bash

trap "echo 'Script interrupted. Exiting...'; exit" SIGINT

music_dir=~/Music/2015-2022/
if [[ ! -d "$music_dir" ]]; then
    echo "Directory $music_dir does not exist. Creating it..."
    mkdir -p "$music_dir"
fi
cd "$music_dir" || { echo "Failed to enter $music_dir. Exiting..."; exit 1; }

# Define a list of URLs and their respective artists
declare -A playlists=(
    ["https://www.youtube.com/playlist?list=PLehPR0Z83CK5NLdMOLxEeTaTkxENI7yCf"]="IU"
    ["https://www.youtube.com/playlist?list=PLvoJm-S4aIsyku-i5SCMlYd5mcQqzh3FK"]="Yo Kaze"
    ["https://www.youtube.com/playlist?list=PLC0ZU22UbRa-deDEiJQnHn6TjrEADPuwH"]="HARDCORE TANO*C"
    ["https://www.youtube.com/playlist?list=PLC0ZU22UbRa8VccdFAM_mnfG_zVx3iiXi"]="Camellia"
    ["https://www.youtube.com/playlist?list=PLE_RVPOSunYPwgW6xC_mHzua8Zjj2Ny2E"]="BIGBANG"
    ["https://www.youtube.com/playlist?list=PLC0ZU22UbRa8drknhw_W5j87JOTF_UW85"]="Esther Favs"
)

# Define filters
default_filter="duration>200 & duration<1500"

# Loop through playlists and download with correct artist
for url in "${!playlists[@]}"; do
    artist="${playlists[$url]}"
    yt-dlp --parse-metadata " $artist: %(meta_artist)s" --match-filter "$default_filter" "$url"
done
