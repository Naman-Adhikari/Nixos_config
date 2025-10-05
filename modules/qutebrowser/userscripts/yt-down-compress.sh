#!/usr/bin/env bash

url="$1"
output_dir="$HOME/Videos/Youtube"
mkdir -p "$output_dir"

{
    echo "Downloading: $url"

    filename=$(yt-dlp -f 'bestvideo[height<=720]+bestaudio/best[height<=720]' \
        -o "$output_dir/%(title)s.%(ext)s" --no-color --print filename "$url")

    echo "Will download as: $filename"

    yt-dlp -f 'bestvideo[height<=720]+bestaudio/best[height<=720]' \
        -o "$output_dir/%(title)s.%(ext)s" --no-color --no-progress "$url"

    if [ $? -eq 0 ] && [ -f "$filename" ]; then
        echo "Download completed successfully: $filename"

        output_file="${filename%.mp4}_compressed.mp4"
        echo "Compressing to: $output_file"

        ffmpeg -hide_banner -loglevel error \
            -i "$filename" -vf "scale='min(640,iw)':'min(360,ih)'" \
            -c:v h264_nvenc -b:v 800k -c:a aac -b:a 96k \
            "$output_file"

        if [ $? -eq 0 ]; then
            rm "$filename"
            echo "Successfully compressed and removed original"
        else
            echo "Compression failed, keeping original file"
        fi
    else
        echo "Download failed or file not found: $filename"
        exit 1
    fi
} > "$HOME/Videos/Youtube/download.log" 2>&1 & disown

