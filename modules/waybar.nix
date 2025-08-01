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

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: JetBrainsMono Nerd Font, monospace;
        font-size: 14px;
        min-height: 0px;
      }

      window#waybar {
        background: transparent;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #custom-updates {
        padding-left: 10px;
        padding-right: 10px;
        border-radius: 5px 20px 5px 20px;
        border: solid 3px;
        border-color: #484a4a;
        transition: background 0.3s ease, color 0.3s ease, border-radius 0.3s ease;
        color: #ffffff;
        background: linear-gradient(
          to bottom,
          #999999 0%,
          #777777 2%,
          #666666 8%,
          #000000 50%,
          #666666 92%,
          #777777 98%,
          #999999 100%
        );
      }

      #custom-updates:hover {
    border-radius: 20px 5px 20px 5px;
    color: #000000;
    background: linear-gradient(
        to bottom,
        #000000 0%,
        #222222 1%,
        #555555 4%,
        #999999 50%,
        #555555 96%,
        #222222 99%,
        #000000 100%
    );
}

#workspaces {
    margin-left: 8px;
    padding-left: 10px;
    padding-right: 10px;
    border-radius: 5px 20px 5px 20px;
    border: solid 3px;
    border-color: #484a4a;
    transition: all 0.3s ease-in-out;
    color: #ffffff;
    background: linear-gradient(
        to bottom,
        #999999 0%,
        #777777 2%,
        #666666 8%,
        #000000 50%,
        #666666 92%,
        #777777 98%,
        #999999 100%
    );
}

#workspaces button {
    padding: 0 5px;
    color: inherit;
    background: transparent;
    border: none;
}

#workspaces button.active {
    color: #ffffff; 
    text-shadow: 0 0 5px #1adff4;
}

#workspaces button:hover {
    color: #000000;
    background: rgba(255, 255, 255, 0.2);
}

#workspaces:hover {
    border-radius: 20px 5px 20px 5px;
    color: #000000;
    background: linear-gradient(
        to bottom,
        #000000 0%,
        #222222 1%,
        #555555 4%,
        #999999 50%,
        #555555 96%,
        #222222 99%,
        #000000 100%
    );
}

#custom-spotify {
    margin-left: 8px;
    padding-left: 10px;
    padding-right: 10px;
    border-radius: 5px 20px 5px 20px;
    border: solid 3px;
    border-color: #484a4a;
    transition: background 0.3s ease-in-out, color 0.3s ease, border-radius 0.3s ease-in-out;
    color: #ffffff;
    background: linear-gradient(
        to bottom,
        #999999 0%,
        #777777 2%,
        #666666 8%,
        #000000 50%,
        #666666 92%,
        #777777 98%,
        #999999 100%
    );
}

#custom-spotify:hover {
    border-radius: 20px 5px 20px 5px;
    color: #000000;
    background: linear-gradient(
        to bottom,
        #000000 0%,
        #222222 1%,
        #555555 4%,
        #999999 50%,
        #555555 96%,
        #222222 99%,
        #000000 100%
    );
}

#clock {
    padding-left: 16px;
    padding-right: 16px;
    border-radius: 5px 5px 20px 20px;
    border: solid 3px;
    border-color: #484a4a;
    transition: background 0.3s ease, color 0.3s ease, border-radius 0.3s ease;
    color: #ffffff;
    background: linear-gradient(
        to bottom,
        #999999 0%,
        #777777 2%,
        #666666 8%,
        #000000 50%,
        #666666 92%,
        #777777 98%,
        #999999 100%
    );
}

#clock:hover {
    border-radius: 20px 20px 5px 5px;
    color: #000000;
    background: linear-gradient(
        to bottom,
        #000000 0%,
        #222222 1%,
        #555555 4%,
        #999999 50%,
        #555555 96%,
        #222222 99%,
        #000000 100%
    );
}

#custom-cava {
    margin-left: 8px;
}

#network {
    margin-right: 8px;
    padding-right: 15px;
    padding-left: 15px;
    border-radius: 20px 5px 20px 5px;
    border: solid 3px;
    border-color: #484a4a;
    transition: background 0.3s ease, color 0.3s ease, border-radius 0.3s ease;
    color: #ffffff;
    background: linear-gradient(
        to bottom,
        #999999 0%,
        #777777 2%,
        #666666 8%,
        #000000 50%,
        #666666 92%,
        #777777 98%,
        #999999 100%
    );
}

#network:hover {
    border-radius: 5px 20px 5px 20px;
    color: #000000;
    background: linear-gradient(
        to bottom,
        #000000 0%,
        #222222 1%,
        #555555 4%,
        #999999 50%,
        #555555 96%,
        #222222 99%,
        #000000 100%
    );
}

#pulseaudio {
    margin-right: 8px;
    border-radius: 20px 5px 20px 5px;
    padding-left: 0px;
    padding-right: 0px;
    border: solid 3px;
    border-color: #484a4a;
    transition: background 0.3s ease, color 0.3s ease, border-radius 0.3s ease;
    color: #ffffff;
    background: linear-gradient(
        to bottom,
        #999999 0%,
        #777777 2%,
        #666666 8%,
        #000000 50%,
        #666666 92%,
        #777777 98%,
        #999999 100%
    );
}

#pulseaudio:hover {
    border-radius: 5px 20px 5px 20px;
    color: #000000;
    background: linear-gradient(
        to bottom,
        #000000 0%,
        #222222 1%,
        #555555 4%,
        #999999 50%,
        #555555 96%,
        #222222 99%,
        #000000 100%
    );
}

#backlight {
    margin-right: 8px;
    padding-left: 10px;
    padding-right: 10px;
    border-radius: 20px 5px 20px 5px;
    border: solid 3px;
    border-color: #484a4a;
    transition: background 0.3s ease, color 0.3s ease, border-radius 0.3s ease;
    color: #ffffff;
    background: linear-gradient(
        to bottom,
        #999999 0%,
        #777777 2%,
        #666666 8%,
        #000000 50%,
        #666666 92%,
        #777777 98%,
        #999999 100%
    );
}

#backlight:hover {
    border-radius: 5px 20px 5px 20px;
    color: #000000;
    background: linear-gradient(
        to bottom,
        #000000 0%,
        #222222 1%,
        #555555 4%,
        #999999 50%,
        #555555 96%,
        #222222 99%,
        #000000 100%
    );
}

#battery {
    margin-right: 8px;
    padding-left: 1px;
    padding-right: 1px;
    border-radius: 20px 5px 20px 5px;
    border: solid 3px;
    border-color: #484a4a;
    transition: background 0.3s ease, color 0.3s ease, border-radius 0.3s ease;
    color: #ffffff;
    background: linear-gradient(
        to bottom,
        #999999 0%,
        #777777 2%,
        #666666 8%,
        #000000 50%,
        #666666 92%,
        #777777 98%,
        #999999 100%
    );
}

#battery:hover {
    border-radius: 5px 20px 5px 20px;
    color: #000000;
    background: linear-gradient(
        to bottom,
        #000000 0%,
        #222222 1%,
        #555555 4%,
        #999999 50%,
        #555555 96%,
        #222222 99%,
        #000000 100%
    );
}

#battery.charging {
    color: #ffffff;
    padding-right: 9px;
    padding-left: 9px;
    background-color: #0f1c17;
    border: solid 3px;
    border-color: #484a4a;
}

#battery.warning:not(.charging) {
    background-color: #0f1c17;
    color: #ff0000;
    border-color: #ff0000;
}

#battery.critical:not(.charging) {
    background-color: #0f1c17;
    color: #ffffff;
    border-color: #ad2626;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

#tooltip {
    background-color: #181818;
}

#tray {
    padding-left: 16px;
    padding-right: 16px;
    margin-right: 8px;
    border-radius: 20px 10px 10px 5px;
    border: solid 3px;
    border-color: #484a4a;
    transition: background 0.3s ease, color 0.3s ease, border-radius 0.3s ease;
    color: #ffffff;
    background: linear-gradient(
        to bottom,
        #999999 0%,
        #777777 2%,
        #666666 8%,
        #000000 50%,
        #666666 92%,
        #777777 98%,
        #999999 100%
    );
}

#tray:hover {
    border-radius: 5px 20px 5px 20px;
    color: #000000;
    background: linear-gradient(
        to bottom,
        #000000 0%,
        #222222 1%,
        #555555 4%,
        #999999 50%,
        #555555 96%,
        #222222 99%,
        #000000 100%
    );
}

#custom-recorder {
    padding-left: 10px;
    padding-right: 10px;
    border-radius: 20px 20px 20px 20px;
    border: solid 3px;
    border-color: #484a4a;
    color: #ffffff;
    background: linear-gradient(
        to bottom,
        #999999 0%,
        #777777 2%,
        #666666 8%,
        #000000 50%,
        #666666 92%,
        #777777 98%,
        #999999 100%
    );
}

#custom-recorder.recording {
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}


      @keyframes blink {
        to {
          background-color: #eb4034;
          color: #484a4a;
        }
      }
    '';
  };

  home.file.".config/waybar/scripts" = {
    source = ../home/scripts;  
    recursive = true;
  };
}
