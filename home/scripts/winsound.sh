#!/bin/sh

OPEN_SOUND="$HOME/.dotfiles/home/winsound/open.wav"
CLOSE_SOUND="$HOME/.dotfiles/home/winsound/close.wav"

declare -A windows

while true; do
    sleep 0.3
    current=$(hyprctl clients -j | jq -r '.[].address' 2>/dev/null)
    
    for id in "${!windows[@]}"; do
        if [[ "$current" != *"$id"* ]]; then
            paplay "$CLOSE_SOUND" &
            unset windows["$id"]
        fi
    done
    
    for id in $current; do
        if [ -n "$id" ] && [ -z "${windows[$id]}" ]; then
            paplay "$OPEN_SOUND" &
            windows["$id"]=1
        fi
    done
done
