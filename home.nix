{ config, pkgs, ... }:

{
  home.username = "lostfromlight";
  home.homeDirectory = "/home/lostfromlight";
  home.stateVersion = "25.05"; 

  imports = [
    ./modules/fish/fish.nix
    ./modules/bongocat/bongocat.nix
    ./modules/kitty/kitty.nix
    ./modules/ghostty/ghostty.nix
    ./modules/waybar/waybar.nix
    ./modules/rofi/rofi.nix
    ./modules/fastfetch/fastfetch.nix
    ./modules/hyprland/hyprland.nix
  ];

  home.packages = with pkgs; [
	unzip
	swww
	ffmpeg
	qbittorrent
	caligula
	zathura
	texliveMedium
    waybar
    kitty
    hyprsunset
    gimp
    audacity
    vlc
	ani-cli
    obsidian
    libreoffice-qt6
    mpv
    kooha
    floorp
    git
    tmux
    btop
    curl
    jq
    atuin
    zoxide
    direnv
    starship
    fastfetch
    hyprpaper
    rofi-wayland
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
    ghostty     
    yazi        
    toipe        
    powertop     
    pulseaudio    
    mpc      
    ncmpcpp 
    protonup  
    octaveFull 
    waypaper    
    wf-recorder  
    floorp        
    bibata-cursors 
    desktop-file-utils 
    xdg-desktop-portal  
    xdg-desktop-portal-wlr  
    entr
  ];

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
      
      "x-scheme-handler/http" = "floorp.desktop";
      "x-scheme-handler/https" = "floorp.desktop";
      "x-scheme-handler/chrome" = "floorp.desktop";
      "text/html" = "floorp.desktop";
      "application/x-extension-htm" = "floorp.desktop";
      "application/x-extension-html" = "floorp.desktop";
      "application/x-extension-shtml" = "floorp.desktop";
      "application/xhtml+xml" = "floorp.desktop";
      "application/x-extension-xhtml" = "floorp.desktop";
      "application/x-extension-xht" = "floorp.desktop";
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
  programs.fish.enable = true;

  xdg.configFile."nvim" = {
  source = config.lib.file.mkOutOfStoreSymlink "/home/lostfromlight/.dotfiles/modules/nvim";
  recursive = true;
};

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
