#!/bin/bash
cd ~/Music/2015-2022/

# Define a list of URLs and their respective artists
declare -A playlists=(
    ["https://www.youtube.com/playlist?list=PLvoJm-S4aIsz8zZy2vAGl2SOQ8USlGLVo"]="Yo Kaze"
    ["https://www.youtube.com/playlist?list=PLFn7Hmwztb-eHrNwDNNH2gjtbcNpSa3L3"]="Laur"
    ["https://www.youtube.com/playlist?list=PLjYilp-bySE1qwXLKHWZZcHbqWaetqyaM"]="Feryquitous"
    ["https://www.youtube.com/playlist?list=PLcP7SWneqXTRFZzISG8AN_59_0ahOI9pf"]="Sakuzyo"
    ["https://www.youtube.com/playlist?list=PLjYilp-bySE3Elmd73Irfp6_qSk0jwaRj"]="xi"
    ["https://www.youtube.com/playlist?list=PL-sgowJ2PZIdMPtUu03nTjNyqK9_WawlA"]="Ado"
    ["https://www.youtube.com/playlist?list=PLBkOG5FFNCKyNGndvIS1GmwmDlKdKLQCc"]="Sennzai"
    ["https://www.youtube.com/playlist?list=PLBkOG5FFNCKzEDtbnzUNvJ3o2EtfCiUFt"]="Seraph"
    ["https://www.youtube.com/playlist?list=PLBkOG5FFNCKzEoPnekVRex2J5UEKKi_Bh"]="Ether"
    ["https://www.youtube.com/playlist?list=PLBkOG5FFNCKzA_SfGWFeV0YJais2TVTe9"]="Suzuka Yumi"
)

# Loop through playlists and download with correct artist
for url in "${!playlists[@]}"; do
    artist="${playlists[$url]}"
    yt-dlp --parse-metadata " $artist: %(artist)s" "$url"
done
