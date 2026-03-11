#!/bin/sh

################################
# Ghostty light palette
################################

GHOSTTY_FILE="$HOME/.dotfiles/modules/ghostty/config"

sed -Ei \
-e 's/^background = .*/background = ffffff/' \
-e 's/^foreground = .*/foreground = 000000/' \
-e 's/^cursor-color = .*/cursor-color = 000000/' \
-e 's/^selection-background = .*/selection-background = e6e6e6/' \
-e 's/^selection-foreground = .*/selection-foreground = 000000/' \
"$GHOSTTY_FILE"

pkill -USR2 ghostty


################################
# Doom Emacs light palette
################################

EMACS_THEME="$HOME/.config/doom/theme/doom-custom-theme.el"

sed -Ei '
# --- Keep all backgrounds bright ---
s/(\(bg[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1ffffff/
s/(\(bg-alt[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1f5f5f5/
s/(\(base0[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1fafafa/
s/(\(base1[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1f0f0f0/
s/(\(base2[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1e6e6e6/
s/(\(base3[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1dcdcdc/
s/(\(base4[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1cfcfcf/
s/(\(base5[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1bdbdbd/
s/(\(base6[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1a8a8a8/
s/(\(base7[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1999999/
s/(\(base8[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1888888/

# --- Darken main foregrounds ---
s/(\(fg[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1222222/
s/(\(fg-alt[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1444444/

# --- Darken named colors by name, regardless of hash ---
s/(\(white[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\111111/
s/(\(grey[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1222222/
s/(\(red[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1222222/
s/(\(orange[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1222222/
s/(\(orange-alt[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1222222/
s/(\(green[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1222222/
s/(\(green-alt[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1222222/
s/(\(teal[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1222222/
s/(\(yellow[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1222222/
s/(\(blue[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1222222/
s/(\(dark-blue[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1222222/
s/(\(magenta[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1222222/
s/(\(violet[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1222222/
s/(\(cyan[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1222222/
s/(\(dark-cyan[[:space:]]+'\''\("#)[0-9a-fA-F]{6}/\1222222/
' "$EMACS_THEME"

emacsclient -e "(progn (mapc #'disable-theme custom-enabled-themes) (load-theme 'doom-custom t))"


################################
# Quickshell light palette
################################

QUICKSHELL_FILE="$HOME/.config/quickshell/theme/Colors.qml"

sed -Ei '
s/^(.*readonly property color background: ).*/\1"#ffffff"/
s/^(.*readonly property color error: ).*/\1"#ff5555"/
s/^(.*readonly property color error_container: ).*/\1"#ff9999"/
s/^(.*readonly property color inverse_on_surface: ).*/\1"#dcdcdc"/
s/^(.*readonly property color inverse_primary: ).*/\1"#666666"/
s/^(.*readonly property color inverse_surface: ).*/\1"#f0f0f0"/
s/^(.*readonly property color on_background: ).*/\1"#222222"/
s/^(.*readonly property color on_error: ).*/\1"#990000"/
s/^(.*readonly property color on_error_container: ).*/\1"#ffe6e6"/
s/^(.*readonly property color on_primary: ).*/\1"#004422"/
s/^(.*readonly property color on_primary_container: ).*/\1"#ccffdd"/
s/^(.*readonly property color on_primary_fixed: ).*/\1"#001100"/
s/^(.*readonly property color on_primary_fixed_variant: ).*/\1"#003322"/
s/^(.*readonly property color on_secondary: ).*/\1"#334433"/
s/^(.*readonly property color on_secondary_container: ).*/\1"#e6f0e6"/
s/^(.*readonly property color on_secondary_fixed: ).*/\1"#112211"/
s/^(.*readonly property color on_secondary_fixed_variant: ).*/\1"#223322"/
s/^(.*readonly property color on_surface: ).*/\1"#222222"/
s/^(.*readonly property color on_surface_variant: ).*/\1"#888888"/
s/^(.*readonly property color on_tertiary: ).*/\1"#003344"/
s/^(.*readonly property color on_tertiary_container: ).*/\1"#bfe9f9"/
s/^(.*readonly property color on_tertiary_fixed: ).*/\1"#001f28"/
s/^(.*readonly property color on_tertiary_fixed_variant: ).*/\1"#234c59"/
s/^(.*readonly property color outline: ).*/\1"#cccccc"/
s/^(.*readonly property color outline_variant: ).*/\1"#888888"/
s/^(.*readonly property color primary: ).*/\1"#99ddbb"/
s/^(.*readonly property color primary_container: ).*/\1"#33aa77"/
s/^(.*readonly property color primary_fixed: ).*/\1"#ccffdd"/
s/^(.*readonly property color primary_fixed_dim: ).*/\1"#99ddbb"/
s/^(.*readonly property color scrim: ).*/\1"#000000"/
s/^(.*readonly property color secondary: ).*/\1"#ddeedd"/
s/^(.*readonly property color secondary_container: ).*/\1"#334433"/
s/^(.*readonly property color secondary_fixed: ).*/\1"#e6f0e6"/
s/^(.*readonly property color secondary_fixed_dim: ).*/\1"#ddeedd"/
s/^(.*readonly property color shadow: ).*/\1"#000000"/
s/^(.*readonly property color source_color: ).*/\1"#666666"/
s/^(.*readonly property color surface: ).*/\1"#ffffff"/
s/^(.*readonly property color surface_bright: ).*/\1"#f0f0f0"/
s/^(.*readonly property color surface_container: ).*/\1"#f7f7f7"/
s/^(.*readonly property color surface_container_high: ).*/\1"#e6e6e6"/
s/^(.*readonly property color surface_container_highest: ).*/\1"#dddddd"/
s/^(.*readonly property color surface_container_low: ).*/\1"#f5f5f5"/
s/^(.*readonly property color surface_container_lowest: ).*/\1"#f0f0f0"/
s/^(.*readonly property color surface_dim: ).*/\1"#f7f7f7"/
s/^(.*readonly property color surface_tint: ).*/\1"#99ddbb"/
s/^(.*readonly property color surface_variant: ).*/\1"#cccccc"/
s/^(.*readonly property color tertiary: ).*/\1"#a4cddd"/
s/^(.*readonly property color tertiary_container: ).*/\1"#234c59"/
s/^(.*readonly property color tertiary_fixed: ).*/\1"#bfe9f9"/
s/^(.*readonly property color tertiary_fixed_dim: ).*/\1"#a4cddd"/
' "$QUICKSHELL_FILE"
