{ config, pkgs, pkgsUnstable, ... }:
{
  home.username = "lostfromlight";
  home.homeDirectory = "/home/lostfromlight";
  home.stateVersion = "25.05"; 

  imports = [
  ];

  home.packages = 
  (with pkgs; [
    lsof
    openssh_hpn
kdePackages.kdenlive
    vips
  localsend
  auto-cpufreq
	ispell
	docker
	steam
	qutebrowser
	unzip
	swww
	ffmpeg-full
	qbittorrent
	caligula
	zathura
	texliveFull
    waybar
    kitty
    hyprsunset
    gimp
    audacity
    vlc
	ani-cli
    libreoffice-qt6
    mpv
    kooha
    git
    tmux
    btop
    curl
    jq
    atuin
    zoxide
    nix-direnv
    direnv
    starship
    fastfetch
    hyprpaper
    rofi
    pyprland
    grim
    slurp
    wl-clipboard
    hyprlock
    hypridle
    waypaper
    python311
    gcc
    lua-language-server
    luajit
    pavucontrol
    cava
    playerctl
    copyq
    dunst
    libnotify
    brightnessctl 
    imv         
    yazi        
    toipe        
    pulseaudio
    powertop
    mpc      
    ncmpcpp 
    protonup-ng
    octaveFull 
    waypaper    
    wf-recorder  
    bibata-cursors 
    desktop-file-utils 
    xdg-desktop-portal  
    xdg-desktop-portal-wlr  
    entr
    tree
    jdk17
    steam-run
    img2pdf
    cliphist
    wineWowPackages.full
	winetricks
	file
  ])

    ++

   (with pkgsUnstable; [
    blender
    matugen
    emacs
    ghostty
    yt-dlp
]);



  home.sessionVariables = {
	wallpaper = "/home/lostfromlight/NMN/Luminarium";
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "app.zen_browser.zen";
    DEFAULT_BROWSER = "app.zen_browser.zen";
    NIXOS_OZONE_WL = "1";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "x-scheme-handler/http" = "org.qutebrowser.qutebrowser";
      "x-scheme-handler/https" = "org.qutebrowser.qutebrowser";
      "x-scheme-handler/chrome" = "org.qutebrowser.qutebrowser";
      "text/html" = "org.qutebrowser.qutebrowser";
      "application/x-extension-htm" = "org.qutebrowser.qutebrowser";
      "application/x-extension-html" = "org.qutebrowser.qutebrowser";
      "application/x-extension-shtml" = "org.qutebrowser.qutebrowser";
      "application/xhtml+xml" = "org.qutebrowser.qutebrowser";
      "application/x-extension-xhtml" = "org.qutebrowser.qutebrowser";
      "application/x-extension-xht" = "org.qutebrowser.qutebrowser";
      "x-scheme-handler/unityhub" = "unityhub.desktop";
	  "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/jpg" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/bmp" = "imv.desktop";
      "image/svg+xml" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "image/tiff" = "imv.desktop";
    };
  };
  programs.home-manager.enable = true;
  programs.neovim.enable = true;

  xdg.configFile."nvim" = {
  source = config.lib.file.mkOutOfStoreSymlink "/home/lostfromlight/.dotfiles/modules/nvim";
  recursive = true;
};

#-------------------mkOutOfSymlink for my dotfiles-------------------------------#
home.file.".config/hypr/hyprland.conf".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/hyprland/hyprland.conf";

home.file.".config/hypr/hyprlock.conf".source=
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/hyprland/hyprlock.conf";

home.file.".config/hypr/pyprland.toml".source=
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/hyprland/pyprland.toml";

home.file.".config/wayland-bongocat/bongocat.conf".source=
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/bongocat/bongocat.conf";

home.file.".config/fastfetch/config.jsonc".source=
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/fastfetch/config.jsonc";

home.file.".config/fish/config.fish".source=
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/fish/config.fish";

home.file.".config/ghostty/config".source=
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/ghostty/config";

home.file.".config/starship.toml".source=
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/ghostty/starship.toml";

home.file.".config/qutebrowser/config.py".source=
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/qutebrowser/config.py";

home.file.".config/rofi/config.rasi".source=
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/rofi/config.rasi";

  home.file.".config/waybar/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/waybar/config";

  home.file.".config/waybar/style.css".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/waybar/style.css";

  home.file.".config/waybar/style2.css".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/waybar/style2.css";

  home.file.".config/waybar/scripts".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home/scripts";

  home.file.".config/kitty/kitty.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/kitty/kitty.conf";

  home.file.".config/matugen/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/matugen/config.toml";

home.file.".config/matugen/templates".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/matugen/templates";

  nixpkgs.config.allowUnfree = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr 
      xdg-desktop-portal-gtk  
    ];
    config.common.default = "*"; 
  };
}
