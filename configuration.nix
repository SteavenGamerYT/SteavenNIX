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
  boot.kernelModules = [ "v4l2loopback-dc" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Networking
  networking = {
    networkmanager.enable = true;
    hostName = "nixos";
    enableIPv6 = false;
    nameservers = ["8.8.8.8" "8.8.4.4" "2001:4860:4860::8888" "2001:4860:4860::8844" ];
    firewall = {
      enable = false;
      allowedTCPPorts = [ 22 139 445 47984 47989 47990 48010 25565 ];
      allowedUDPPorts = [ 137 138 47998 47999 48000 48002 ];
    };
    extraHosts = ''
      109.94.209.70   fitgirlrepacks.co
      109.94.209.70   fitgirl-repacks.cc
      109.94.209.70   fitgirl-repacks.com
      109.94.209.70   fitgirl-repacks.website
      109.94.209.70   www.fitgirlrepacks.co
      109.94.209.70   www.fitgirl-repacks.cc
      109.94.209.70   www.fitgirl-repacks.website
      109.94.209.70   ww9.fitgirl-repacks.xyz
      109.94.209.70   *.fitgirl-repacks.xyz
      109.94.209.70   fitgirl-repacks.xyz
      109.94.209.70   fitgirl-repack.net
      109.94.209.70   www.fitgirl-repack.net
      109.94.209.70   fitgirlpack.site
      109.94.209.70   www.fitgirlpack.site
    '';
    #networking.wireless.enable = true;
    #proxy.default = "http://user:password@proxy:port/";
    #proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };  

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  #i18n.defaultLocale = "ar_EG.UTF-8";
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
    xserver = {
      xkb.layout = "us,ara";
      xkb.variant = "";
      xkb.options = "grp:alt_caps_toggle";
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    syncthing = {
      enable = true;
      user = "omarhanykasban";
      dataDir = "/home/omarhanykasban/Documents";
      configDir = "/home/omarhanykasban/Documents/.config/syncthing";
    };
      flatpak.remotes = [
      {name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo";}
      {name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrep";}
      {name = "appcenter"; location = "https://flatpak.elementary.io/repo.flatpakrepo";}
  ];
    flatpak.update.auto.enable = true;
    flatpak.uninstallUnmanagedPackages = true;
    flatpak.packages = [
      { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
      { appId = "io.github.shiftey.Desktop"; origin = "flathub"; }
      ];
    dbus.enable = true;
    printing.enable = true;
    openssh.enable = true;
  };

  security.sudo = {
    configFile = ''
      Defaults env_reset,pwfeedback
    '';
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
    adb.enable = true;
  };

systemd.services.libvirtd = {
    path = let
             env = pkgs.buildEnv {
               name = "qemu-hook-env";
               paths = with pkgs; [
                 bash
                 libvirt
                 kmod
                 systemd
                 ripgrep
                 sd
               ];
             };
           in
           [ env ];

    preStart =
    ''
      mkdir -p /var/lib/libvirt/hooks
      mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin
      mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/release/end

      ln -sf "/home/omarhanykasban/VMs/Hooks/qemu" "/var/lib/libvirt/hooks/qemu"
      ln -sf "/home/omarhanykasban/VMs/win10/start.sh" "/var/lib/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh"
      ln -sf "/home/omarhanykasban/VMs/win10/stop.sh" "/var/lib/libvirt/hooks/qemu.d/win10/release/end/stop.sh"

      chmod +x /var/lib/libvirt/hooks/qemu
      chmod +x /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh
      chmod +x /var/lib/libvirt/hooks/qemu.d/win10/release/end/stop.sh
    '';
  };

services.udev.extraRules = ''
  # Rule for Oppo phone
  ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="22d9", ATTRS{idProduct}=="2765", ENV{ID_SERIAL_SHORT}=="d6188ca0", TAG+="udev-acl", TAG+="uaccess", TAG+="udev", TAG+="seat", TAG+="input", RUN+="/bin/sh -c 'ANDROID_SERIAL=d6188ca0 ${pkgs.android-tools}/bin/adb forward tcp:8081 tcp:8081 > /tmp/adb_log_oppo 2>&1'"
  
  # Rule for Samsung Galaxy phone
  ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="04e8", ATTRS{idProduct}=="6860", ENV{ID_SERIAL_SHORT}=="RK8W703Q8PR", TAG+="udev-acl", TAG+="uaccess", TAG+="udev", TAG+="seat", TAG+="input", RUN+="/bin/sh -c 'ANDROID_SERIAL=RK8W703Q8PR ${pkgs.android-tools}/bin/adb forward tcp:8080 tcp:8080 > /tmp/adb_log_samsung 2>&1'"
'';

  virtualisation.libvirtd.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_SIZE = "100000000000";
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
    PROTON_HIDE_NVIDIA_GPU = "0";
    PROTON_ENABLE_NVAPI = "1";
  };

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
    wireplumber = {
      enable = true;
      package = pkgs.wireplumber;
    };

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
    extraGroups = [ "networkmanager" "wheel" "lp" "storage" "libvirtd" "adbusers" ];
#    packages = with pkgs; [
#    firefox
#    google-chrome
#    discord
#    audacious
    #  thunderbird
#    ];
  };
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    hyprland
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    xdg-desktop-portal
    waybar
    rofi-wayland
    konsole
    wget
    git
    nano
    pavucontrol
    mpv
    swaybg
    cinnamon.nemo-with-extensions  
    cinnamon.nemo-emblems
    cinnamon.nemo-fileroller
    gnome.file-roller
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
    kdenlive
    ffmpeg-full
    lutris
    steam
    protontricks
    protonup-qt
    libsForQt5.kcalc
    krita
    libreoffice-fresh
    onlyoffice-bin
    element-desktop
    firefox
    google-chrome
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
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
    grimblast
    dunst
    networkmanagerapplet
    libsForQt5.kate
    polkit_gnome
    polkit
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
    #wineWowPackages.waylandFull
    wineWowPackages.stagingFull
    winetricks
    wireplumber
    android-tools
    audacity
    gparted
    yt-dlp
    openssh
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
