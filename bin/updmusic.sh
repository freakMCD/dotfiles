#!/bin/bash

trap "echo 'Script interrupted. Exiting...'; exit" SIGINT

study_dir=~/Music/study/
hype_dir=~/Music/hype/
cd ~/Music
mkdir -p "$study_dir" "$hypr_dir"

declare -A playlists=(
    ["https://www.youtube.com/playlist?list=PLZxF0tSm2vk4rjnqhq_n3xeTeWW7ytGCS"]="Anime songs"
    ["https://www.youtube.com/playlist?list=PLehPR0Z83CK5NLdMOLxEeTaTkxENI7yCf"]="IU"
    ["https://www.youtube.com/playlist?list=PLvoJm-S4aIsyku-i5SCMlYd5mcQqzh3FK"]="Yo Kaze"

    ["https://www.youtube.com/playlist?list=PLInyrN_N37Vrf80tu3XR-5SM_OT5fbSaq"]="Reol"
    ["https://www.youtube.com/playlist?list=PLE_RVPOSunYPwgW6xC_mHzua8Zjj2Ny2E"]="BIGBANG"
    ["https://www.youtube.com/playlist?list=PLC0ZU22UbRa8VccdFAM_mnfG_zVx3iiXi"]="Camellia"
    ["https://www.youtube.com/playlist?list=PLC0ZU22UbRa-deDEiJQnHn6TjrEADPuwH"]="HARDCORE TANO*C"
    ["https://www.youtube.com/playlist?list=PLSOcZYrm14UdAuNOWz8c8-XuAC0sI1Neq"]="Stray Kids"
)

# Loop through playlists and download with correct artist
for url in "${!playlists[@]}"; do
    artist="${playlists[$url]}"

    if [[ "$artist" =~ ^(Anime songs|IU)$ ]];then
        download_dir="$study_dir"
        filter="duration>120 & duration<1500"
    elif [[ "$artist" =~ ^(Yo Kaze)$ ]]; then
        download_dir="$study_dir"
        filter="duration>240 & duration<1500"

    elif [[ "$artist" =~ ^(Reol|BIGBANG|Stray Kids)$ ]];then 
        download_dir="$hype_dir"
        filter="duration>120 & duration<1500"
    else
        download_dir="$hype_dir"
        filter="duration>180 & duration<1500"
    fi
    yt-dlp --parse-metadata " $artist: %(meta_artist)s" --match-filter "$filter" -o "$download_dir/%(title)s_%(id)s.%(ext)s"  "$url" 
done
