{ config, pkgs, ... }:

{
  home.username = "lostfromlight";
  home.homeDirectory = "/home/lostfromlight";
  home.stateVersion = "25.05"; 

  imports = [
    ./modules/fish.nix
    ./modules/ghostty.nix
    ./modules/kitty.nix
    ./modules/waybar.nix
    ./modules/rofi.nix
    ./modules/fastfetch.nix
    ./modules/hyprland.nix
  ];

  home.packages = with pkgs; [
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
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "app.zen_browser.zen";
    DEFAULT_BROWSER = "app.zen_browser.zen";
    NIXOS_OZONE_WL = "1";
  };

  programs.home-manager.enable = true;
  programs.neovim.enable = true;

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
