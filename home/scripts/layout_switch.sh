#!/usr/bin/env bash

CONF="$HOME/.dotfiles/modules/hyprland/hyprland.conf
LAYOUTS="$CONF scrolling-master.conf"

get_current() {
    grep -oP 'general:layout\s*=\s*\K\w+' "$CONF"
}

set_layout() {
    local name="$1"
    sed -i "/general:layout/ s/=.*$/= $name/" "$CONF"
    hyprctl keyword general:layout "$name"
}

get_index() {
    local current="$1"
    local i=0
    for lay in "${LAYOUTS[@]}"; do
        if [[ "$lay" == "$current" ]]; then
            echo "$i"
            return
        fi
        ((i++))
    done
    echo "0"   # fallback
}

# ────────────────────────────────────────────────

current=$(get_current)
total=${#LAYOUTS[@]}

case "$1" in
    next)
        idx=$(get_index "$current")
        new_idx=$(( (idx + 1) % total ))
        new_layout="${LAYOUTS[new_idx]}"
        set_layout "$new_layout"
        notify-send "Hyprland Layout" "Switched to: $new_layout"
        ;;

    prev)
        idx=$(get_index "$current")
        new_idx=$(( (idx - 1 + total) % total ))
        new_layout="${LAYOUTS[new_idx]}"
        set_layout "$new_layout"
        notify-send "Hyprland Layout" "Switched to: $new_layout"
        ;;

    *)
        echo "Usage: $0 {next|prev}"
        exit 1
        ;;
esac

# Optional: re-apply master layout settings if needed
hyprctl dispatch "exec [daemonize] insertprev [daemonize] scrolling-master"

exit 0
