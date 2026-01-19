#!/bin/sh

WALL=$(find ~/.dotfiles/home/wallpapers -type f | shuf -n 1)

swww img "$WALL" --transition-type grow --transition-step 25 --transition-fps 155

matugen image "$WALL"

GHOSTTY_CONFIG="$HOME/.dotfiles/modules/ghostty/config";

cp "$GHOSTTY_CONFIG" "$GHOSTTY_CONFIG.bak"

sed -i "s|^background-image = .*|background-image = \"$WALL\"|" "$GHOSTTY_CONFIG"

