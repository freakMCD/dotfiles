#!/bin/bash

trap "echo 'Script interrupted. Exiting...'; exit" SIGINT

cd ~/Music/2015-2022/

# Define a list of URLs and their respective artists
declare -A playlists=(
    ["https://www.youtube.com/playlist?list=PLvoJm-S4aIsz8zZy2vAGl2SOQ8USlGLVo"]="Yo Kaze"
    ["https://www.youtube.com/playlist?list=PLjYilp-bySE1qwXLKHWZZcHbqWaetqyaM"]="Feryquitous"
    ["https://www.youtube.com/playlist?list=PLcP7SWneqXTRFZzISG8AN_59_0ahOI9pf"]="Sakuzyo"
    ["https://www.youtube.com/playlist?list=PLjYilp-bySE3Elmd73Irfp6_qSk0jwaRj"]="xi"
    ["https://www.youtube.com/playlist?list=PLBkOG5FFNCKyNGndvIS1GmwmDlKdKLQCc"]="Sennzai"
    ["https://www.youtube.com/playlist?list=PLBkOG5FFNCKzEDtbnzUNvJ3o2EtfCiUFt"]="Seraph"
    ["https://www.youtube.com/playlist?list=PLBkOG5FFNCKzEoPnekVRex2J5UEKKi_Bh"]="Ether"
    ["https://www.youtube.com/playlist?list=PLBkOG5FFNCKzA_SfGWFeV0YJais2TVTe9"]="Suzuha Yumi"
    ["https://www.youtube.com/playlist?list=PLBO2h-GzDvIabo1P-nofvIyRVdVkYqM1c"]="HARDCORE TANO*C - IRREGULAR NATION"
)

# Default filter
filter="duration>300 & duration<1500"

# Loop through playlists and download with correct artist
for url in "${!playlists[@]}"; do
    artist="${playlists[$url]}"
    yt-dlp --parse-metadata " $artist: %(meta_artist)s" --match-filter "$filter" "$url"
done
