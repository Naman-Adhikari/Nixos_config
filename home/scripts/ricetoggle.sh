#!/bin/sh

CONFIG_DIR="$HOME/.config/waybar"
ACTIVE_STYLE="$CONFIG_DIR/style.css"

if [ -L "$ACTIVE_STYLE" ]; then
    target=$(readlink "$ACTIVE_STYLE")
    if [[ "$target" == *"style1.css" ]]; then
        ln -sf "$CONFIG_DIR/style2.css" "$ACTIVE_STYLE"
    else
        ln -sf "$CONFIG_DIR/style1.css" "$ACTIVE_STYLE"
    fi
else
    ln -sf "$CONFIG_DIR/style1.css" "$ACTIVE_STYLE"
fi

pkill waybar && setsid waybar >/dev/null 2>&1 &

