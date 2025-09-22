{ config, pkgs, ... }:

{
  xdg.configFile."wayland-bongocat/bongocat.conf".text = ''
    input_device = "/dev/input/event18"
    position = "top"
    layer = "overlay"
    opacity = 200
    fps = 60
  '';
}
