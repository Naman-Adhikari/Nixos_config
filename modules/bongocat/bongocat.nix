{ config, pkgs, ... }:

{
  xdg.configFile."wayland-bongocat/bongocat.conf".text = ''
    keyboard_device=/dev/input/event18   # Your Fantech keyboard (from evtest)
    keyboard_device=/dev/input/event0    # Built-in keyboard (alternative)

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
