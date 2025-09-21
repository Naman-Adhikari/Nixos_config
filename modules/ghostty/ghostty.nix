{ pkgs, ... }:

let
  shaderPath = toString ../home/shaders/matrixhall.glsl;
in {
  xdg.configFile."ghostty/config".text = ''
    font-family = JetbrainsMono
    font-size = 14

	background            = #0a0a0a
	foreground            = #e0e0e0
	cursor-color          = #ffffff
	selection-background  = #303030
	selection-foreground  = #ffffff

	palette=0=#1b1b1b
	palette=1=#ff5555
	palette=2=#50fa7b
	palette=3=#f1fa8c
	palette=4=#bd93f9
	palette=5=#ff79c6
	palette=6=#8be9fd
	palette=7=#f8f8f2
	palette=8=#661111
	palette=9=#ff6e6e
	palette=10=#69ff94
	palette=11=#ffffa5
	palette=12=#d6acff
	palette=13=#ff92df
	palette=14=#ff4444
	palette=15=#ffffff



    window-titlebar-background = #000000
    background-opacity         = 0.2
    background-blur-radius     = 70
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
home.file.".config/starship.toml".source = ./starship.toml;

}
