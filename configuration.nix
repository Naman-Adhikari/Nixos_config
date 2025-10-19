
{lib, confit, pkgs,  ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

#  boot.loader.systemd-boot.enable = true;
 # boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = ["mem_sleep_default=deep"];
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      
      theme = "/etc/grub-themes/lain";
      
      gfxmodeEfi = "1920x1080";
    };
  };

  networking.hostName = "proxy-pc"; 
  system.stateVersion = "25.05";


  networking.networkmanager.enable = true;
  networking.networkmanager = {
    dns = "default";  
  };

#networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

# environment.etc."resolv.conf".text = ''
#	nameserver 1.1.1.1
#	nameserver 8.8.8.8
#  '';

 services.passSecretService.enable = true;
 networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 7878 ];  
  };
 
  
  programs.hyprland = {
   enable = true;
   xwayland.enable = true;
 };


 #Enabling NIRI
 services.displayManager.sessionPackages = [ pkgs.niri ];


#Disable nvidia gpu to enter integrated mode (uncomment to enable nvidia)
#boot.blacklistedKernelModules = [ "nvidia" "nvidia_drm" "nvidia_modeset" "nvidia_uvm" ];

programs.fish.enable = true;
users.users.lostfromlight = {
  shell = pkgs.fish;
};



services.xserver.videoDrivers = ["nvidia"];
nix.settings.experimental-features = [ "nix-command" "flakes"];

services.ollama.enable = true;
#services.ollama.acceleration = "cuda";
nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  "cuda_cudart"
  "libcublas"
  "cuda_cccl"
  "cuda_nvcc"
  "nvidia-x11"
  "nvidia-settings"
  "libnvoptix"
];


  environment.sessionVariables = {
  # WLR_NO_HARDWARE_CURSORS = "1";
   EDITOR = "nvim";
   VISUAL = "nvim";
   BROWSER = "app.zen_browser.zen";
   DEFAULT_BROWSER = "app.zen_browser.zen";
   NIXOS_OZONE_WL = "1";
   STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
 };

  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
    nvidia.open = false;
    nvidia.nvidiaSettings = true;
};
hardware.opengl = {
  enable = true;             # enable OpenGL
  driSupport32Bit = true;    # required for Steam / 32-bit games
};

services.flatpak.enable = true;


services.tlp.enable = true;
services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    DISK_IDLE_SECS_ON_AC = 300;                
    DISK_IDLE_SECS_ON_BAT = 60;            
    USB_AUTOSUSPEND = 1;                   
    PCIE_ASPM_ON_BAT = "powersave";
    STOP_CHARGE_THRESH_BAT0 = 80;
};

  time.timeZone = "Asia/Kathmandu";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "lostfromlight";
  services.displayManager.defaultSession = "hyprland";
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  hardware.bluetooth.enable = true;
  services.printing.enable = true;


  virtualisation.docker.enable = true;


  services.power-profiles-daemon.enable = false;


  services.pipewire.wireplumber.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;


  };

  users.users.lostfromlight = {
    isNormalUser = true;
    description = "Naman Adhikari";
    extraGroups = [ "input"  "networkmanager" "wheel" "audio" "docker" ];
    packages = with pkgs; [
    ];
  };


  
nixpkgs.config = {
  allowUnfree = true;
  permittedInsecurePackages = [
    "python3.12-youtube-dl-2021.12.17"
  ];
};


  environment.systemPackages = with pkgs; [
    wget
    fish
    inotify-tools
    psmisc
    tlp
    flatpak
    lmms
    gparted
    niri
    unetbootin
    xwayland-satellite
    ollama
    glib
    mpd
	os-prober
 ];


}





