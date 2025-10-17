#---------------------------NOTE-------------------------------
# The wallpaper (swww) is being managed and toggled by the ricetoggle.sh script

#--------------------------------------------------------------
{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    
    extraConfig = ''
      # █▀▀ ▀▄▀ █▀▀ █▀▀
      # ██▄ █░█ ██▄ █▄▄
      exec-once = bash -c "${config.home.homeDirectory}/.dotfiles/home/scripts/lock.sh"
      exec-once = bash -c "${config.home.homeDirectory}/.dotfiles/home/scripts/winsound.sh"
      exec-once = bash -c "sleep 0.9 && hyprpaper"
      exec-once = bash -c "swww init"
      exec-once = bash -c "emacs --daemon"
      exec-once = bash -c "swww img ~/.dotfiles/home/gias.png"
      exec-once = waybar
      exec-once = dunst
      exec-once = pypr
      exec-once = mpd

      # █▀▄▀█ █▀█ █▄░█ █ ▀█▀ █▀█ █▀█
      # █░▀░█ █▄█ █░▀█ █ ░█░ █▄█ █▀▄
      monitor=eDP-1,1920x1080,auto,1
      misc {
        disable_hyprland_logo = true
      }
      monitor= HDMI-A-1, 1280x960@60, auto, auto,

      # █ █▄░█ █▀█ █░█ ▀█▀
      # █ █░▀█ █▀▀ █▄█ ░█░
      input {
        kb_layout = us
        follow_mouse = 1
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

        touchpad { # For Laptops
            natural_scroll = false
            middle_button_emulation = true
        }
      }

      gestures {
          workspace_swipe = true
      }

      general {
        gaps_in= 5
        gaps_out= 10
        border_size= 1
        resize_on_border = true
        col.active_border = rgba(068787ff) rgba(6b0104ff) 90deg
        col.inactive_border = rgba(000000aa)
        allow_tearing = false 
        layout = dwindle
      }

      decoration {
          rounding = 5
          active_opacity = 1.0
          inactive_opacity = 0.95

          blur {
              enabled = true
              size = 5
              passes = 3
              vibrancy = 0.1696
          }
      }

      animations {
        enabled = true
		bezier = tvBezier, 0.05, 0.9, 0.1, 1.05
		bezier = tvSlow, 0.1, 1.1, 0.1, 1.0

		# Window open: TV turning on effect
		animation = windows, 1, 7, tvBezier, popin
		animation = border, 1, 10, default
		animation = borderangle, 1, 100, default, loop

      #  bezier = overshot, 0.05, 0.9, 0.1, 1.05
      #  bezier = smoothOut, 0.36, 0, 0.66, -0.56
      #  bezier = smoothIn, 0.25, 1, 0.5, 1

#        animation = windows, 1, 3, overshot, slide
#        animation = windowsOut, 1, 3, smoothOut, slide
#        animation = windowsMove, 1, 4, default
#        animation = border, 1, 10, default
#        animation = fade, 1, 10, smoothIn
#        animation = fadeDim, 1, 10, smoothIn
#        animation = workspaces, 1, 6, default
      }

      # LAYOUT
      dwindle {
        pseudotile = true
        preserve_split = true
      }

      # █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀█ █░█ █░░ █▀▀ █▀
      # ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █▀▄ █▄█ █▄▄ ██▄ ▄█
      windowrulev2 = float, class:^(com.mitchellh.ghostty)$
      windowrulev2 = size 70% 65%, class:^(com.mitchellh.ghostty)$
	  windowrulev2 = float, initialTitle:^https://duckduckgo.com - qutebrowser$
	  windowrulev2 = size 900 600, initialTitle:^https://duckduckgo.com - qutebrowser$
	  windowrulev2 = center, initialTitle:^https://duckduckgo.com - qutebrowser$
	  windowrulev2 = float, initialTitle:^https://chat.deepseek.com - qutebrowser$
	  windowrulev2 = size 1000 700, initialTitle:^https://chat.deepseek.com - qutebrowser$
	  windowrulev2 = center, initialTitle:^https://chat.deepseek.com - qutebrowser$



      windowrule = float, title:Open File
      windowrule = float, title:branchdialog
      windowrule = float, title:wlogout
      windowrule = float, title:^(Media viewer)$
      windowrule = float, title:^(Volume Control)$
      windowrule = float, title:^(Picture-in-Picture)$

      # █▄▀ █▀▀ █▄█ █▄▄ █ █▄░█ █▀▄
      # █░█ ██▄ ░█░ █▄█ █ █░▀█ █▄▀
      bind = SUPER SHIFT, Y, exec, yt-dlp -f 'bestvideo[height<=720]+bestaudio/best[height<=720]' -o "$HOME/Videos/Youtube/%(title)s.%(ext)s" "$(wl-paste)"
      bind = SUPER SHIFT, W, exec, bash/./hyprpaper.sh
      bind = SUPER , N, exec, hyprsunset --temperature 5000
      bind = SUPER SHIFT , N, exec, pkill hyprsunset 
      bind = SUPER, A, exec, pkill rofi || rofi -show drun
      bind = SUPER, W, exec, pkill waybar || waybar &
      bind = SUPER, X, exec, ghostty
      bind = SUPER, E, exec, emacsclient -c 
      bind = SUPER, B, exec, qutebrowser
      bind = SUPER, S, exec, com.spotify.Client
      bind = SUPER, escape, exec, shutdown now
      bind = SUPER SHIFT, L, exec, ${config.home.homeDirectory}/.dotfiles/home/scripts/lock.sh
      bind = SUPER, 0,  exec, ${config.home.homeDirectory}/.dotfiles/home/scripts/ricetoggle.sh
      bind = SUPER, C,  exec, bongocat --config ~/.config/wayland-bongocat/bongocat.conf 
      bind = SUPER, U, exec, dbus-run-session -- steam-run $(which unityhub)
      bind = SUPER, F, fullscreen,
      bind = SUPER, Q, killactive,
      bind = SUPER SHIFT, Q, exit,
      bind = SUPER, escape, exec, wlogout --protocol layer-shell -b 5 -T 400 -B 400
      bind = Ctrl SHIFT, R, exec, reboot
      bind = SUPER, O, exec, obsidian
      bind = SUPER SHIFT, D, exec, com.discordapp.Discord
      bind = SUPER SHIFT, B, exec, ${config.home.homeDirectory}/blender/result/bin/blender-fhs
      bind = SUPER, M, exec, ghostty -e ncmpcpp
      bind = SUPER SHIFT, T, exec, floorp https://monkeytype.com
      bind = SUPER, Y, exec, ghostty -e yazi
      bind = SUPER, TAB, exec, pypr expose
      bind = SUPER, Z, exec, pypr zoom ++0.5
      bind = SUPER SHIFT, Z, exec, pypr zoom --0.5
	  bind = SUPER, D, exec, qutebrowser --target private-window --set tabs.show never --set scrolling.bar never "https://duckduckgo.com"
	  bind = SUPER SHIFT, A, exec, qutebrowser --target window --set tabs.show never "https://chat.deepseek.com"



      # workspace for expose
      workspace = special:exposed,gapsout:60,gapsin:30,bordersize:2,border:true,shadow:false

      # MULTIMEDIA & BRIGHTNESS
      binde=, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      binde=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind=, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind=, XF86AudioPlay, exec, playerctl play-pause
      bind=, XF86AudioPause, exec, playerctl play-pause
      bind=, XF86AudioNext, exec, playerctl next
      bind=, XF86AudioPrev, exec, playerctl previous
      bind =, XF86MonBrightnessUp, exec, brightnessctl set 10%+
      bind =, XF86MonBrightnessDown, exec, brightnessctl set 10%-

      # SCREENSHOT
      bind =, Print, exec, grim -g "$(slurp)" - | wl-copy && wl-paste > ${config.home.homeDirectory}/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of the region taken" -t 1000
      bind = SHIFT, Print, exec, grim - | wl-copy && wl-paste > ${config.home.homeDirectory}/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of whole screen taken" -t 1000

      # WINDOW MANAGEMENT & WORKSPACES
      bind = SUPER, left, movefocus, l
      bind = SUPER, L, movefocus, l
      bind = SUPER, right, movefocus, r
      bind = SUPER, H, movefocus, r
      bind = SUPER, up, movefocus, u
      bind = SUPER, down, movefocus, d

      bind = SUPER, Space, togglefloating,
      bind = SUPER, P, pseudo,
      bind = SUPER, T, togglesplit,

      bind = SUPER SHIFT, left, movewindow, l
      bind = SUPER SHIFT, right, movewindow, r
      bind = SUPER SHIFT, up, movewindow, u
      bind = SUPER SHIFT, down, movewindow, d

      bind = SUPER CTRL, left, resizeactive, -20 0
      bind = SUPER CTRL, right, resizeactive, 20 0
      bind = SUPER CTRL, up, resizeactive, 0 -20
      bind = SUPER CTRL, down, resizeactive, 0 20

      bind= SUPER, g, togglegroup,
      bind= SUPER, tab, changegroupactive,
      bind = SUPER, grave, togglespecialworkspace,
      bind = SUPERSHIFT, grave, movetoworkspace, special

      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER ALT, up, workspace, e+1
      bind = SUPER ALT, down, workspace, e-1

      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5
      bind = SUPER SHIFT, 6, movetoworkspace, 6
      bind = SUPER SHIFT, 7, movetoworkspace, 7
      bind = SUPER SHIFT, 8, movetoworkspace, 8
      bind = SUPER SHIFT, 9, movetoworkspace, 9
      bind = SUPER SHIFT, 0, movetoworkspace, 10

      # MOUSE BINDING
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow
      bind = SUPER, mouse_down, workspace, e+1
      bind = SUPER, mouse_up, workspace, e-1

      binds {
          workspace_back_and_forth = 1
      }

      # Nvidia
      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = NVD_BACKEND,direct
      env = BROWSER,qutebrowser
      env = DEFAULT_BROWSER, qutebrowser
      env = XCURSOR_THEME=Bibata-Modern-Classic
      env = XCURSOR_SIZE, 24
    '';

  };

#xdg.configFile."hypr/hyprpaper.conf".text = ''
#  preload = ${config.home.homeDirectory}/.dotfiles/home/mountholo.jpg
#  wallpaper = ,${config.home.homeDirectory}/.dotfiles/home/mountholo.jpg
#  splash = false
#'';
    xdg.configFile."hypr/pyprland.toml" = let
    pyprlandToml = ../../home/pyprland.toml; 
  in if builtins.pathExists pyprlandToml then {
    source = pyprlandToml;
  } else {
    text = ""; 
  };

  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
        ignore_empty_input = true
    }

    background {
        monitor = 
        path = ${config.home.homeDirectory}/.dotfiles/home/emoergo.jpg
        color = rgba(0, 0, 0, 0) 
        blur_passes = 0 
        noise = 2.0 
    }

    input-field {
        monitor =
        size = 100, 30
        outline_thickness = 3
        dots_size = 0.33 
        dots_spacing = 0.15 
        dots_center = true
        dots_rounding = -1 
        outer_color = rgb(000000)
        inner_color = rgb(000000)
        font_color = rgb(140, 140, 140)
        fade_on_empty = true
        fade_timeout = 1000 
        placeholder_text = <i> Remember Thyself...</i> 
        hide_input = false
        rounding = 40 
        check_color = rgb(ff, ff, ff)
        fail_color = rgb(204, 34, 34) 
        fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> 
        fail_transition = 300 
        capslock_color = -1
        numlock_color = -1
        bothlock_color = -1 
        invert_numlock = false 
        swap_font_color = false 
        position = 150, -360
        halign = left
        valign = top
        shadow_passes = 10
        shadow_size = 20
        shadow_color = rgb(0,0,0)
        shadow_boost = 1.6
    }

    label {
        monitor =
        text = cmd[update:1000] echo "$TIME"
        color = rgba(138, 140, 140, 1)
        font_size = 125
        font_family = evanescent
        position = -70, 20
        halign = right
        valign = bottom
        shadow_passes = 5
        shadow_size = 10
    }

    label {
        monitor =
        text = $USER
        color = rgba(138, 140, 140, 1)
        font_size = 55
        font_family = evanescent
        position = 50, -25
        halign = left
        valign = top
        shadow_passes = 5
        shadow_size = 10
    }

    image {
        monitor =
        path = ${config.home.homeDirectory}/.dotfiles/home/mongrel.jpg
        size = 200
        rounding = 150
        border_size = 1
        border_color = rgb(0, 0, 0)
        rotate = 0 
        reload_time = -1 
        position = 95, -110
        halign = left
        valign = top
        shadow_passes = 10
        shadow_size = 20
        shadow_color = rgb(0,0,0)
        shadow_boost = 1.6
    }
  '';

  home.file.".config/hypr/mongrel.jpg".source = ../../home/mongrel.jpg;
}
