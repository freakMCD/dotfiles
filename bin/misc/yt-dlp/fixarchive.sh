archive_file=~/bin/misc/yt-dlp/yt_songs.txt
music_directory=~/Music/
output_file=~/Music/updated_yt_songs.txt

# Generate a list of VIDEOIDs from your music files
find "$music_directory" -type f -name '*???????????.m4a' -exec basename {} \; | sed -E 's/.*([A-Za-z0-9_-]{11})\.m4a$/\1/' > music_ids.txt

# Remove lines from 2015-2020.txt based on music_ids.txt
grep -f music_ids.txt "$archive_file" > "$output_file"

# Optionally, overwrite the original 2015-2020.txt file with the updated content
mv "$output_file" "$archive_file"

# Cleaning
rm music_ids.txt
