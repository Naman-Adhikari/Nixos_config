{ pkgs, ... }:

let
  shaderPath = toString ../home/shaders/matrixhall.glsl;
in {
  xdg.configFile."ghostty/config".text = ''
    font-family = JetbrainsMono
    font-size = 14

    background            = #000000
    foreground            = #f0f0f0
    cursor-color          = #ffffff
    selection-background  = #2a2a2a
    selection-foreground  = #e6e6e6

	palette=0=#0b1c2c
	palette=1=#1f3a50
	palette=2=#2e5c7f
	palette=3=#3f7aa0
	palette=4=#53a0c3
	palette=5=#68c2e0
	palette=6=#8be1ff
	palette=7=#b3f0ff
	palette=8=#d0f7ff
	palette=9=#e0fbff
	palette=10=#e6fdff
	palette=11=#f0ffff
	palette=12=#f5ffff
	palette=13=#f8ffff
	palette=14=#fbffff
	palette=15=#ffffff

    window-titlebar-background = #000000
    background-opacity         = 0
    background-blur-radius     = 20
    mouse-hide-while-typing    = true
    window-decoration          = false
    confirm-close-surface      = false

    # Uncomment if needed:
    # custom-shader-animation = always
    # custom-shader           = ${shaderPath}

    ## KEYBINDS ##
    keybind = ctrl+s=new_split:right
    keybind = ctrl+left=goto_split:left
    keybind = ctrl+right=goto_split:right
    keybind = ctrl+shift+left=resize_split:left,20
    keybind = ctrl+shift+right=resize_split:right,20
    keybind = ctrl+w=close_surface
    keybind = ctrl+c=copy_to_clipboard
    keybind = ctrl+v=paste_from_clipboard
    keybind = ctrl+a=select_all
    keybind = ctrl+t=new_tab
    keybind = ctrl+tab=next_tab
    keybind = ctrl+shift>tab=previous_tab
    keybind = alt+c=open_config
    keybind = ctrl+d=toggle_window_decorations
    keybind = global:ctrl+shift+w=toggle_quick_terminal
    keybind = ctrl+i=inspector:toggle
    keybind = ctrl+shift+plus=increase_font_size:1
    keybind = ctrl+shift+minus=decrease_font_size:1
  '';
}

