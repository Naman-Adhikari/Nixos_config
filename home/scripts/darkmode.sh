#!/bin/sh

################################
# Ghostty dark palette
################################

GHOSTTY_FILE="$HOME/.dotfiles/modules/ghostty/config"

sed -Ei \
-e 's/^background = .*/background = 000000/' \
-e 's/^foreground = .*/foreground = ffffff/' \
-e 's/^cursor-color = .*/cursor-color = ffffff/' \
-e 's/^selection-background = .*/selection-background = 333333/' \
-e 's/^selection-foreground = .*/selection-foreground = ffffff/' \
"$GHOSTTY_FILE"

pkill -USR2 ghostty


################################
# Doom Emacs dark palette
################################

EMACS_THEME="$HOME/.config/doom/theme/doom-custom-theme.el"

sed -Ei '
# --- Make all backgrounds pitch black ---
s/(\(bg[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1000000/
s/(\(bg-alt[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1000000/
s/(\(base0[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1000000/
s/(\(base1[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1000000/
s/(\(base2[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1000000/
s/(\(base3[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1000000/
s/(\(base4[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1000000/
s/(\(base5[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1888888/
s/(\(base6[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1000000/
s/(\(base7[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1000000/
s/(\(base8[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1000000/

# --- Make main foregrounds light ---
s/(\(fg[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1ffffff/
s/(\(fg-alt[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1cccccc/

# --- Make named colors monochrome / light for readability ---
s/(\(white[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1ffffff/
s/(\(grey[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1cccccc/
s/(\(red[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1ffffff/
s/(\(orange[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1ffffff/
s/(\(orange-alt[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1cccccc/
s/(\(green[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1ffffff/
s/(\(green-alt[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1cccccc/
s/(\(teal[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1cccccc/
s/(\(yellow[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1ffffff/
s/(\(blue[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1ffffff/
s/(\(dark-blue[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1cccccc/
s/(\(magenta[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1ffffff/
s/(\(violet[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1ffffff/
s/(\(cyan[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1cccccc/
s/(\(dark-cyan[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1cccccc/
' "$EMACS_THEME"

emacsclient -e "(progn (mapc #'disable-theme custom-enabled-themes) (load-theme 'doom-custom t))"


################################
# Quickshell dark palette
################################

QUICKSHELL_FILE="$HOME/.config/quickshell/theme/Colors.qml"

sed -Ei '
s/^(.*readonly property color background: ).*/\1"#000000"/
s/^(.*readonly property color error: ).*/\1"#ffffff"/
s/^(.*readonly property color error_container: ).*/\1"#cccccc"/
s/^(.*readonly property color inverse_on_surface: ).*/\1"#888888"/
s/^(.*readonly property color inverse_primary: ).*/\1"#cccccc"/
s/^(.*readonly property color inverse_surface: ).*/\1"#111111"/
s/^(.*readonly property color on_background: ).*/\1"#ffffff"/
s/^(.*readonly property color on_error: ).*/\1"#ffffff"/
s/^(.*readonly property color on_error_container: ).*/\1"#cccccc"/
s/^(.*readonly property color on_primary: ).*/\1"#ffffff"/
s/^(.*readonly property color on_primary_container: ).*/\1"#cccccc"/
s/^(.*readonly property color on_primary_fixed: ).*/\1"#ffffff"/
s/^(.*readonly property color on_primary_fixed_variant: ).*/\1"#cccccc"/
s/^(.*readonly property color on_secondary: ).*/\1"#ffffff"/
s/^(.*readonly property color on_secondary_container: ).*/\1"#cccccc"/
s/^(.*readonly property color on_secondary_fixed: ).*/\1"#ffffff"/
s/^(.*readonly property color on_secondary_fixed_variant: ).*/\1"#cccccc"/
s/^(.*readonly property color on_surface: ).*/\1"#ffffff"/
s/^(.*readonly property color on_surface_variant: ).*/\1"#888888"/
s/^(.*readonly property color on_tertiary: ).*/\1"#ffffff"/
s/^(.*readonly property color on_tertiary_container: ).*/\1"#cccccc"/
s/^(.*readonly property color on_tertiary_fixed: ).*/\1"#ffffff"/
s/^(.*readonly property color on_tertiary_fixed_variant: ).*/\1"#cccccc"/
s/^(.*readonly property color outline: ).*/\1"#888888"/
s/^(.*readonly property color outline_variant: ).*/\1"#888888"/
s/^(.*readonly property color primary: ).*/\1"#ffffff"/
s/^(.*readonly property color primary_container: ).*/\1"#cccccc"/
s/^(.*readonly property color primary_fixed: ).*/\1"#ffffff"/
s/^(.*readonly property color primary_fixed_dim: ).*/\1"#cccccc"/
s/^(.*readonly property color scrim: ).*/\1"#000000"/
s/^(.*readonly property color secondary: ).*/\1"#ffffff"/
s/^(.*readonly property color secondary_container: ).*/\1"#cccccc"/
s/^(.*readonly property color secondary_fixed: ).*/\1"#ffffff"/
s/^(.*readonly property color secondary_fixed_dim: ).*/\1"#cccccc"/
s/^(.*readonly property color shadow: ).*/\1"#000000"/
s/^(.*readonly property color source_color: ).*/\1"#cccccc"/
s/^(.*readonly property color surface: ).*/\1"#000000"/
s/^(.*readonly property color surface_bright: ).*/\1"#111111"/
s/^(.*readonly property color surface_container: ).*/\1"#111111"/
s/^(.*readonly property color surface_container_high: ).*/\1"#222222"/
s/^(.*readonly property color surface_container_highest: ).*/\1"#222222"/
s/^(.*readonly property color surface_container_low: ).*/\1"#111111"/
s/^(.*readonly property color surface_container_lowest: ).*/\1"#111111"/
s/^(.*readonly property color surface_dim: ).*/\1"#111111"/
s/^(.*readonly property color surface_tint: ).*/\1"#cccccc"/
s/^(.*readonly property color surface_variant: ).*/\1"#222222"/
s/^(.*readonly property color tertiary: ).*/\1"#cccccc"/
s/^(.*readonly property color tertiary_container: ).*/\1"#222222"/
s/^(.*readonly property color tertiary_fixed: ).*/\1"#cccccc"/
s/^(.*readonly property color tertiary_fixed_dim: ).*/\1"#222222"/
' "$QUICKSHELL_FILE"
