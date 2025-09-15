#Here the current.png changes symlinks to different images when switching rice with ricetoggle.sh

{ pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    package = pkgs.fastfetch;  
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      
      logo = {
        type = "kitty-direct";
        source = "~/.config/fastfetch/current.png";
        width = 27;
        height = 20;
        padding = {
          right = 5;
          left = 5;
          bottom = 2;
          top = 4;
        };
      };

      general.multithreading = true;
      display.separator = "➜   ";

      modules = [
        "break"
        {
          type = "title";
          format = "                                {6}{7}{8}";
        }
        "break"
        {
          type = "custom";
          format = "┌──────────────────────────────────────────────────────────────────────────────┐";
        }
        "break"
        {
          key = "     OS           ";
          keyColor = "green";
          type = "os";
        }
        {
          key = "    󰌢 Machine      ";
          keyColor = "cyan";
          type = "host";
        }
        {
          key = "     Kernel       ";
          keyColor = "white";
          type = "kernel";
        }
        {
          key = "    󰅐 Uptime       ";
          keyColor = "green";
          type = "uptime";
        }
        {
          key = "     Packages     ";
          keyColor = "cyan";
          type = "packages";
        }
        {
          key = "     WM           ";
          keyColor = "white";
          type = "wm";
        }
        {
          key = "     Shell        ";
          keyColor = "green";
          type = "shell";
        }
        {
          key = "     Terminal     ";
          keyColor = "cyan";
          type = "terminal";
        }
        {
          key = "     Font         ";
          keyColor = "white";
          type = "terminalfont";
        }
        {
          key = "    󰻠 CPU          ";
          keyColor = "green";
          type = "cpu";
        }
        {
          key = "    󰍛 GPU          ";
          keyColor = "cyan";
          type = "gpu";
        }
        {
          key = "    󰑭 Memory       ";
          keyColor = "white";
          type = "memory";
        }
        {
          key = "      Wifi        ";
          keyColor = "green";
          type = "wifi";
        }
        {
          key = "    󰩟 Local IP     ";
          keyColor = "cyan";
          type = "localip";
          compact = true;
        }
        "break"
        {
          type = "custom";
          format = "└──────────────────────────────────────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "colors";
          paddingLeft = 34;
          symbol = "circle";
          block.width = 10;
        }
      ];
    };
  };

}
