{ config, pkgs, pkgsUnstable, ... }:
{
  home.username = "lostfromlight";
  home.homeDirectory = "/home/lostfromlight";
  home.stateVersion = "25.05"; 

  imports = [
    ./modules/fish/fish.nix
    ./modules/qutebrowser/qutebrowser.nix
    ./modules/bongocat/bongocat.nix
    ./modules/kitty/kitty.nix
    ./modules/ghostty/ghostty.nix
    ./modules/waybar/waybar.nix
    ./modules/rofi/rofi.nix
    ./modules/fastfetch/fastfetch.nix
    ./modules/hyprland/hyprland.nix
  ];

  home.packages = 
  (with pkgs; [
    lsof
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
    picom
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
    yazi        
    toipe        
    pulseaudio
    powertop
    mpc      
    ncmpcpp 
    protonup  
    octaveFull 
    waypaper    
    wf-recorder  
    bibata-cursors 
    desktop-file-utils 
    xdg-desktop-portal  
    xdg-desktop-portal-wlr  
    entr
    tree
  ])

    ++

   (with pkgsUnstable; [
  blender
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
