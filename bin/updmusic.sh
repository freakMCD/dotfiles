#!/bin/bash

trap "echo 'Script interrupted. Exiting...'; exit" SIGINT

base_dir=~/Music/2015-2022/
yo_kaze_dir=~/Music/YoKaze/

mkdir -p "$base_dir" "$yo_kaze_dir"

cd "$base_dir" || { echo "Failed to enter $base_dir. Exiting..."; exit 1; }

declare -A playlists=(
    ["https://www.youtube.com/playlist?list=PLehPR0Z83CK5NLdMOLxEeTaTkxENI7yCf"]="IU"
    ["https://www.youtube.com/playlist?list=PLvoJm-S4aIsyku-i5SCMlYd5mcQqzh3FK"]="Yo Kaze"
    ["https://www.youtube.com/playlist?list=PLC0ZU22UbRa-deDEiJQnHn6TjrEADPuwH"]="HARDCORE TANO*C"
    ["https://www.youtube.com/playlist?list=PLC0ZU22UbRa8VccdFAM_mnfG_zVx3iiXi"]="Camellia"
    ["https://www.youtube.com/playlist?list=PLE_RVPOSunYPwgW6xC_mHzua8Zjj2Ny2E"]="BIGBANG"
    ["https://www.youtube.com/playlist?list=PLC0ZU22UbRa8drknhw_W5j87JOTF_UW85"]="Esther Favs"
    ["https://www.youtube.com/playlist?list=PL-sgowJ2PZIdMPtUu03nTjNyqK9_WawlA"]="Ado"
    ["https://www.youtube.com/playlist?list=PLInyrN_N37Vrf80tu3XR-5SM_OT5fbSaq"]="Reol"
    ["https://www.youtube.com/playlist?list=PLZxF0tSm2vk4rjnqhq_n3xeTeWW7ytGCS"]="Anime songs"
    ["https://www.youtube.com/playlist?list=PLvoe5TSl-_0iiW_1nO00HH6F-TmyM37Uk"]="TOPHAMHAT-KYO Works"
    ["https://www.youtube.com/playlist?list=PLvoe5TSl-_0hLsqxXz9qv1DEsLsP-Wlkw"]="TOPHAMHAT-KYO"
)

# Define filters
default_filter="duration>180 & duration<1500"

# Loop through playlists and download with correct artist
for url in "${!playlists[@]}"; do
    artist="${playlists[$url]}"

    if [[ "$artist" == "Yo Kaze" ]]; then
        download_dir="$yo_kaze_dir"
    else
        download_dir="$base_dir"
    fi

    mkdir -p "$download_dir"
    yt-dlp --parse-metadata " $artist: %(meta_artist)s" --match-filter "$default_filter" "$url"
done
