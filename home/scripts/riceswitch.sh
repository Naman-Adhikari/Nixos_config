#!/bin/sh

WALL_DIR="$HOME/.dotfiles/home/wallpapers"
THUMB_DIR="$HOME/.cache/wall-thumbs"

mkdir -p "$THUMB_DIR"

# generate thumbnails
for img in "$WALL_DIR"/*; do
    [ -f "$img" ] || continue
    thumb="$THUMB_DIR/$(basename "$img")"

    if [ ! -f "$thumb" ]; then
        magick "$img" -thumbnail 256x256^ -gravity center -extent 256x256 "$thumb"
    fi
done

CHOICE=$(
for img in "$WALL_DIR"/*; do
    name=$(basename "$img")
    echo -en "$name\0icon\x1f$THUMB_DIR/$name\n"
done | shuf | rofi -dmenu -show-icons -theme ~/.config/rofi/wallpaper.rasi -p "Wallpaper"
)

[ -z "$CHOICE" ] && exit

WALL="$WALL_DIR/$CHOICE"

# cuz matugen doesnt change ghostty back to black
GHOSTTY_FILE="$HOME/.dotfiles/modules/ghostty/config"

sed -Ei \
-e 's/^background = .*/background = 000000/' \
"$GHOSTTY_FILE"
################################
# set wallpaper
################################

swww img "$WALL" --transition-type grow --transition-step 25 --transition-fps 155


################################
# THEME SWITCHING
################################

if [ "$CHOICE" = "white.jpg" ] || [ "$CHOICE" = "white.png" ]; then
    ~/.dotfiles/home/scripts/lightmode.sh

elif [ "$CHOICE" = "black.jpg" ] || [ "$CHOICE" = "black.png" ]; then
    ~/.dotfiles/home/scripts/darkmode.sh

else
    matugen image "$WALL"
fi
################################
# reload apps
################################

sleep 0.8

pkill -USR2 ghostty

pgrep -x fish | while read -r pid; do
    kill -USR1 "$pid"
done

emacsclient -e "(progn (mapc #'disable-theme custom-enabled-themes) (load-theme 'doom-custom t))"
