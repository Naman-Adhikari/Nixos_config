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

    palette=0=#1a1a1a
    palette=1=#444444
    palette=2=#555555
    palette=3=#666666
    palette=4=#777777
    palette=5=#888888
    palette=6=#999999
    palette=7=#aaaaaa
    palette=8=#bbbbbb
    palette=9=#cccccc
    palette=10=#dddddd
    palette=11=#e5e5e5
    palette=12=#ebebeb
    palette=13=#f2f2f2
    palette=14=#f7f7f7
    palette=15=#ffffff

    window-titlebar-background = #000000
    background-opacity = 1
    background-blur-radius = 20
    mouse-hide-while-typing = true
    window-decoration = false
    confirm-close-surface = false

    # Uncomment if needed:
    # custom-shader-animation = always
    # custom-shader = ${shaderPath}

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
