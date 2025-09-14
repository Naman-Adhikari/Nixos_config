#!/bin/sh


CONFIG_DIR="$HOME/.config/waybar"
ACTIVE_STYLE="$CONFIG_DIR/style.css"

if [ ! -e "$ACTIVE_STYLE" ]; then
    ln -s "$CONFIG_DIR/style1.css" "$ACTIVE_STYLE"
fi

target=$(readlink "$ACTIVE_STYLE")
if [[ "$target" == *"style1.css" ]]; then
    ln -sf "$CONFIG_DIR/style2.css" "$ACTIVE_STYLE"
else
    ln -sf "$CONFIG_DIR/style1.css" "$ACTIVE_STYLE"
fi

# --------------------------
# Wallpaper toggle
# --------------------------

WALLPAPER1="$HOME/.dotfiles/home/ghost.jpg"
WALLPAPER2="$HOME/.dotfiles/home/ponyo.jpg"
GIAS="$HOME/.dotfiles/home/gias.png"
ACTIVE_FILE="$HOME/.config/hypr/active_wallpaper"
CURRENT_FILE="$HOME/.config/fastfetch/current.png"

mkdir -p "$HOME/.config/hypr"
mkdir -p "$(dirname "$CURRENT_FILE")"

# Initialize ACTIVE_FILE if missing
if [ ! -f "$ACTIVE_FILE" ]; then
    echo "$WALLPAPER1" > "$ACTIVE_FILE"
    current="$WALLPAPER1"
else
    current=$(cat "$ACTIVE_FILE")
fi

# Determine next wallpaper
if [[ "$current" == "$WALLPAPER1" ]]; then
    next="$WALLPAPER2"
    # For WALLPAPER1, symlink current.png to gias.png
    ln -sf "$GIAS" "$CURRENT_FILE"
else
    next="$WALLPAPER1"
    # For WALLPAPER2, copy ponyo.jpg to current.png (overwrite previous symlink)
    cp "$WALLPAPER2" "$CURRENT_FILE"
fi

# Update ACTIVE_FILE
echo "$next" > "$ACTIVE_FILE"

# Apply wallpaper via swww
if command -v swww >/dev/null 2>&1; then
    if ! pgrep -x swww >/dev/null; then
        swww init
        sleep 1
    fi
    swww img "$next" --transition-type grow --transition-step 25 --transition-fps 155
    echo "Switched wallpaper to: $(basename "$next")"
else
    echo "swww not installed. Please install it for reliable wallpaper switching."
fi

# Restart Waybar
sleep 0.5
pkill waybar && setsid waybar >/dev/null 2>&1 &

