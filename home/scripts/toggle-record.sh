#!/bin/sh

OUTPUT_DIR="$HOME/Videos/Recordings"

latest_webm=$(ls -t "$OUTPUT_DIR"/*.webm 2>/dev/null | head -n1)
if [ -n "$latest_webm" ]; then
    timestamp=$(date +%Y-%m-%d-%H-%M-%S)
    final_mp4="$OUTPUT_DIR/Rec-$timestamp.mp4"
    ffmpeg -y -i "$latest_webm" -c:v libx264 -c:a aac "$final_mp4"
    rm -f "$latest_webm"
else
    mkdir -p "$OUTPUT_DIR"
    kooha &
fi
