{ config, pkgs, ... }:

{
  xdg.configFile."kitty/kitty.conf".text = ''
    bold_font auto
    bold_italic_font auto
    allow_remote_control yes
    background_image ${config.home.homeDirectory}/.dotfiles/home/emoergo.png
    background_image_layout scaled
    background_opacity 1.0

    font_size 10
    disable_ligatures never

    open_url_with flatpak run app.zen_browser.zen

    background            #000000
    foreground            #85d4d1
    cursor                #ff0017
    selection_background  #f6d56a
    color0                #341a0d
    color8                #874227
    color1                #95bd5e
    color9                #ff4230
    color2                #f77d02 
    color10               #95bd5e
    color3                #c26e27
    color11               #ff9565
    color4                #d0d4c9
    color12               #9eb2b3
    color5                #9b1d29
    color13               #ff5b6a
    color6                #588056
    color14               #89cc8e
    color7                #000000
    color15               #ffffff
    selection_foreground  #52363f
  '';
}
