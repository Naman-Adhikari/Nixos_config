#!/bin/sh

WALL=$(find ~/.dotfiles/home/wallpapers -type f | shuf -n 1)

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
