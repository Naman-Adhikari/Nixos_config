#!/bin/sh

OPEN_SOUND="$HOME/.dotfiles/home/winsound/open.wav"
CLOSE_SOUND="$HOME/.dotfiles/home/winsound/open.wav"
MOVE_SOUND="$HOME/.dotfiles/home/winsound/open.wav"

# Listen to Hyprland events
hyprctl -j listen | while read -r line; do
    [[ -z "$line" ]] && continue
    if echo "$line" | grep -q '"openwindow"'; then
        paplay "$OPEN_SOUND" &
    elif echo "$line" | grep -q '"closewindow"'; then
        paplay "$CLOSE_SOUND" &
    elif echo "$line" | grep -q '"movewindow"' || echo "$line" | grep -q '"resizewindow"'; then
        paplay "$MOVE_SOUND" &
    fi
done

