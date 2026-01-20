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

GHOSTTY_CONFIG="$HOME/.dotfiles/modules/ghostty/config";
ROFI_CONFIG="$HOME/.dotfiles/modules/rofi/config.rasi";

cp "$GHOSTTY_CONFIG" "$GHOSTTY_CONFIG.bak"
cp "$ROFI_CONFIG" "$ROFI_CONFIG.bak"

sed -i "s|^background-image = .*|background-image = \"$WALL\"|" "$GHOSTTY_CONFIG"
sed -i "s|^background-image: .*|background-image: url(\"$WALL\", none);|" "$ROFI_CONFIG"
sleep 0.8
pkill -USR2 ghostty
