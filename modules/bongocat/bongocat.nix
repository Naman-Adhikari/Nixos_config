{ config, pkgs, ... }:

{
  xdg.configFile."wayland-bongocat/bongocat.conf".text = ''
    keyboard_device=/dev/input/by-id/usb-LIZHI_Flash_IC_Fantech_ATOM_Mechanical_Keyboard-event-kbd
    

    cat_x_offset=150
    cat_y_offset=0
    cat_height=40
    overlay_height=60

    idle_frame=0
    keypress_duration=150
    fps=60

    overlay_opacity=0  
    enable_debug=0
  '';
}
