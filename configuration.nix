# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
   ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = { "vm.max_map_count" = 2147483642; };
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
# Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

#  i18n.extraLocaleSettings = {
#    LC_ADDRESS = "ar_EG.UTF-8";
#    LC_IDENTIFICATION = "ar_EG.UTF-8";
#    LC_MEASUREMENT = "ar_EG.UTF-8";
#    LC_MONETARY = "ar_EG.UTF-8";
#    LC_NAME = "ar_EG.UTF-8";
#    LC_NUMERIC = "ar_EG.UTF-8";
#    LC_PAPER = "ar_EG.UTF-8";
#    LC_TELEPHONE = "ar_EG.UTF-8";
#    LC_TIME = "ar_EG.UTF-8";
#  };
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

systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
};
services = {
  xserver.enable = true;
  flatpak.enable = true;
  xserver.displayManager.sddm.enable = true;
  gvfs.enable = true;
  udisks2.enable = true;
  # Configure keymap in X11
  xserver = {
    layout = "us,ara";
    xkbVariant = "";
    xkbOptions = "grp:alt_caps_toggle";
  };
  avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
  syncthing = {
    enable = true;
    user = "omarhanykasban";
    dataDir = "/home/omarhanykasban/Documents";
    configDir = "/home/omarhanykasban/Documents/.config/syncthing";
  };
  gnome.gnome-keyring.enable = true;
};

security.sudo = {
  configFile = ''
    Defaults env_reset,pwfeedback
  '';
};

  systemd.user.services."gnome-keyring".enable = true;
  systemd.user.services."gnome-keyring".description = "GNOME Keyring Daemon";
  systemd.user.services."gnome-keyring".serviceConfig = {
    Type = "simple";
    ExecStart = "${pkgs.gnome3.gnome-keyring}/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh";
  };

xdg.portal = {
    enable = true;
    wlr.enable = true;
    configPackages = [
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # enableNvidiaPatches = true;
  };
environment.sessionVariables = {
  WLR_NO_HARDWARE_CURSORS = "1";
  NIXOS_OZONE_WL = "1";
  SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
  __GL_SHADER_DISK_CACHE = "1";
  __GL_SHADER_DISK_CACHE_SIZE = "100000000000";
  __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.omarhanykasban = {
    isNormalUser = true;
    description = "Omar Hany Kasban";
    extraGroups = [ "networkmanager" "wheel" "lp" "storage" ];
#    packages = with pkgs; [
#    firefox
#    google-chrome
#    discord
#    audacious
    #  thunderbird
#    ];
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  hyprland
  xdg-desktop-portal-hyprland
  waybar
  rofi-wayland
  konsole
  wget
  git
  nano
  pavucontrol
  mpv
  swaybg
  #cinnamon.nemo
  cinnamon.nemo-with-extensions  
  cinnamon.nemo-emblems
  cinnamon.nemo-fileroller
  cinnamon.folder-color-switcher
  gnome.gnome-system-monitor
  procps
  killall
  noto-fonts
  noto-fonts-cjk
  noto-fonts-color-emoji
  roboto
  nordic
  whitesur-cursors
  github-desktop
  vscode
  obs-studio
  obs-studio-plugins.obs-vkcapture
  obs-studio-plugins.obs-pipewire-audio-capture
  obs-studio-plugins.obs-multi-rtmp
  obs-studio-plugins.wlrobs
  kdenlive
  ffmpeg-full
  lutris
  steam
  protontricks
  libsForQt5.kcalc
  krita
  libreoffice-fresh
  onlyoffice-bin
  element-desktop
  firefox
  google-chrome
  discord
  audacious
  telegram-desktop
  qbittorrent
  libsForQt5.qt5ct
  qt6Packages.qt6ct
  libsForQt5.qtstyleplugins
  libsForQt5.qt5.qtbase
  qt6.qtbase
  libsForQt5.qt5.qttools
  qt6.qttools
  libsForQt5.qtstyleplugin-kvantum
  qt6Packages.qtstyleplugin-kvantum
  kitty
  grimblast
  dunst
  networkmanagerapplet
  libsForQt5.kate
  polkit_gnome
  polkit
  minecraft
  temurin-jre-bin-8
  temurin-jre-bin-17
  prismlauncher
  papirus-icon-theme
  material-design-icons
  xwaylandvideobridge
  steamtinkerlaunch
  webcord
  ubuntu_font_family
  playerctl
  brightnessctl
  pulseaudio
  google-fonts
  usbutils
  udiskie
  udisks
  gnome.gnome-disk-utility
  hplip
  system-config-printer
  syncthing
  syncthingtray  
  vlc
  celluloid
  shortwave
  mousai
  curtail
  blanket
  metadata-cleaner
  tagger
  unityhub
  warp
  upscayl
  parsec-bin
  mangohud
  gamescope
  goverlay
  gimp-with-plugins
];
fonts.packages = with pkgs; [
  (nerdfonts.override { fonts = [ "RobotoMono" "Meslo" "JetBrainsMono" "Ubuntu" "UbuntuMono" "FiraCode" "DroidSansMono" ]; })
];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
