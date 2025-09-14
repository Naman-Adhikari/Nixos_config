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
ACTIVE_FILE="$HOME/.config/hypr/active_wallpaper"

mkdir -p "$HOME/.config/hypr"

if [ ! -f "$ACTIVE_FILE" ]; then
    echo "$WALLPAPER1" > "$ACTIVE_FILE"
    current="$WALLPAPER1"
else
    current=$(cat "$ACTIVE_FILE")
fi

if [[ "$current" == "$WALLPAPER1" ]]; then
    next="$WALLPAPER2"
else
    next="$WALLPAPER1"
fi

echo "$next" > "$ACTIVE_FILE"

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

# --------------------------
# Ghostty theme toggle
# --------------------------
CONFIG_DIR="$HOME/.config/ghostty"
COLOR1="colors1.conf"
COLOR2="colors2.conf"
ACTIVE_COLOR_FILE="$CONFIG_DIR/active_color"

if [[ "$next" == "$WALLPAPER1" ]]; then
    theme="$COLOR1"
else
    theme="$COLOR2"
fi

echo "$theme" > "$ACTIVE_COLOR_FILE"

# Combine base + theme (plain text)
cat "$CONFIG_DIR/config.template" "$CONFIG_DIR/$theme" > "$CONFIG_DIR/config"
echo "Applied Ghostty theme: $theme"

# --------------------------
# Restart Waybar
# --------------------------
sleep 0.5
pkill waybar && setsid waybar >/dev/null 2>&1 &
