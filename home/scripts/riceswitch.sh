#!/bin/sh

WALL_DIR="$HOME/.dotfiles/home/wallpapers"
THUMB_DIR="$HOME/.cache/wall-thumbs"

mkdir -p "$THUMB_DIR"

# generate thumbnails if missing
for img in "$WALL_DIR"/*; do
    [ -f "$img" ] || continue
    thumb="$THUMB_DIR/$(basename "$img")"

    if [ ! -f "$thumb" ]; then
        magick "$img" -thumbnail 256x256^ -gravity center -extent 256x256 "$thumb"
    fi
done

# build rofi menu
CHOICE=$(
for img in "$WALL_DIR"/*; do
    name=$(basename "$img")
    echo -en "$name\0icon\x1f$THUMB_DIR/$name\n"
done | shuf | rofi -dmenu -show-icons -theme ~/.config/rofi/wallpaper.rasi -p "Wallpaper"
)

[ -z "$CHOICE" ] && exit

WALL="$WALL_DIR/$CHOICE"

# set wallpaper
swww img "$WALL" --transition-type grow --transition-step 25 --transition-fps 155

# regenerate colors
matugen image "$WALL"

sleep 0.8
pkill -USR2 ghostty

# reload fish colors
pgrep -x fish | while read -r pid; do
    kill -USR1 "$pid"
done

# reload emacs theme
emacsclient -e "(progn (mapc #'disable-theme custom-enabled-themes) (load-theme 'doom-custom t))"
