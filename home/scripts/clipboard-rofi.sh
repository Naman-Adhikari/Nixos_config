#!/bin/sh

cliphist list \
  | head -n 10 \
  | rofi -dmenu \
      -p "Clipboard" \
      -theme-str '
        window { width: 750px; }
        listview { lines: 10; }
      ' \
  | cliphist decode \
  | wl-copy
