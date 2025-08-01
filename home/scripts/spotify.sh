#!/bin/sh

# Check Spotify first
spotify_status=$(playerctl --player=spotify status 2>/dev/null)

if [[ "$spotify_status" == "Playing" ]] || [[ "$spotify_status" == "Paused" ]]; then
    artist=$(playerctl --player=spotify metadata artist)
    title=$(playerctl --player=spotify metadata title)
    echo "$artist - $title"
else
    # If Spotify isn't playing, check MPD
    mpd_status=$(mpc status 2>/dev/null)
    if [[ $? -eq 0 ]]; then  # mpc command succeeded
        if [[ $(mpc status | grep -c "playing") -eq 1 ]] || [[ $(mpc status | grep -c "paused") -eq 1 ]]; then
            # Get current song from MPD
            current_song=$(mpc current)
            echo "$current_song"
        else
            echo ""
        fi
    else
        echo ""
    fi
fi
