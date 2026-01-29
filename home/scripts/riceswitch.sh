#!/bin/sh


WALL_DIR="$HOME/.dotfiles/home/wallpapers"
LIST_FILE="$HOME/.cache/wallpaper_list"

if [ ! -s "$LIST_FILE" ]; then
    find "$WALL_DIR" -type f | shuf > "$LIST_FILE"
fi

WALL=$(head -n 1 "$LIST_FILE")

sed -i '1d' "$LIST_FILE"


swww img "$WALL" --transition-type grow --transition-step 25 --transition-fps 155

matugen image "$WALL"

sleep 0.8
pkill -USR2 ghostty

for pid in $(pgrep -x fish); do
    kill -USR1 "$pid"
done

emacsclient -e "(progn (mapc #'disable-theme custom-enabled-themes) (load-theme 'doom-custom t))"
