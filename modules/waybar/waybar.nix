{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        margin = "5 20 0 20";
        modules-left = [ "custom/updates" "hyprland/workspaces" "custom/spotify" "custom/cava" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "pulseaudio" "backlight" "battery" "custom/ytube" "tray" "custom/recorder" ];

        # Module configurations
        "custom/updates" = {
          format = "   ";
          interval = 7200;
          on-click = "dolphin";
          signal = 8;
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "•";
            "2" = "•";
            "3" = "•";
            "4" = "•";
            "5" = "•";
            active = "";
            default = "";
          };
          "persistent-workspaces" = {
            "*" = [ 2 3 ];
          };
          on-click = "activate";
          all-outputs = true;
        };

        "custom/spotify" = {
          format = "  {}";
          interval = 5;
          on-click = "flatpak run com.spotify.client";
          exec = "~/.dotfiles/home/scripts/spotify.sh";
        };

        clock = {
          tooltip-format = "<big>{:%y %b}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%a | %d %b | %I:%M %p}";
        };

        network = {
          "format-wifi" = "󰤨  {essid} ({signalStrength}%)";
          "format-ethernet" = "󰈁 Ethernet";
          "format-disconnected" = "󰤭 Disconnected";
          "on-click" = "~/.dotfiles/home/scripts/nmtui.sh";
        };

        pulseaudio = {
          "reverse-scrolling" = 1;
          format = "{volume}% {icon}";
          "format-bluetooth" = "{volume}% {icon}";
          "format-muted" = " {format_source}";
          "format-source-muted" = "Mute 🚫";
          "format-icons" = {
            headphone = "";
            default = [ "🕨" "🕩" "🕪" ];
          };
          "on-click" = "pavucontrol";
          "min-length" = 13;
        };

        backlight = {
          device = "intel_backlight";
          format = "{percent}% {icon}";
          "format-icons" = [ "🌑" "🌒" "🌓" "🌔" "🌕" ];
          "min-length" = 5;
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = " {capacity}% {icon} ";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          "format-icons" = [ "▁" "▂" "▃" "▄" "▅" ];
        };

        tray = {
          "icon-size" = 16;
          spacing = 4;
        };

        "custom/recorder" = {
          exec = "~/.dotfiles/home/scripts/record-status.sh";
          interval = 1;
          "on-click" = "~/.dotfiles/home/scripts/toggle-record.sh";
          "return-type" = "json";
        };
      };
    };


  };

  home.file.".config/waybar/style1.css".source = ./style1.css;
  home.file.".config/waybar/style2.css".source = ./style2.css;

  home.file.".config/waybar/scripts" = {
    source = ../../home/scripts;  
    recursive = true;
  };
}
