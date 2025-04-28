{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./i3.nix
      ./kvm.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  users.users.omarhanykasban = {
    isNormalUser = true;
    description = "OmarHanyKasban";
    extraGroups = [ "wheel" "networkmanager" "audio" "libvirtd" "kvm" "libvirt" "input" "render" ];
    shell = pkgs.bash;
    home = "/home/omarhanykasban";
  };


      services.udisks2.enable = true;
      services.gvfs.enable = true;
      services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      };
      services.syncthing = {
            enable = true;
            user = "omarhanykasban";
            dataDir = "/home/omarhanykasban/Documents";
            configDir = "/home/omarhanykasban/.local/state/syncthing";
      };

    programs.dconf.enable = true;
   security.polkit.enable = true;
   networking.hostName = "Omar-PC";
   networking.networkmanager.enable = true;
   networking.networkmanager.wifi.powersave = false;
   time.timeZone = "Africa/Cairo";
   i18n.defaultLocale = "en_US.UTF-8";
   console = {
  #   font = "Lat2-Terminus16";
     keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
   };

  programs.nix-ld.enable = true;
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm = {
        enable = true;
        greeters.gtk = {
            enable = true;
            theme.name = "Nordic";
            iconTheme.name = "Papirus-Dark";
            cursorTheme.size = 24;
            cursorTheme.name = "whitesur-cursors";
      };
     };
 };  
};

    qt.platformTheme = "qt6ct";
    qt.style = "kvantum";
   services.xserver.xkb.layout = "us,eg";
   services.xserver.xkb.options = "grp:alt_shift_toggle";


   services.printing.enable = true;
   services.pipewire = {
     enable = true;
     pulse.enable = true;
     wireplumber.enable = true;
   };

  
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config = {
      preferred = {
        default = "gtk";
        "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
        "org.freedesktop.impl.portal.Screenshot" = "hyprland";
        "org.freedesktop.impl.portal.FileChooser" = "kde";
        "org.freedesktop.impl.portal.Secret" = "kwallet";
        "org.freedesktop.impl.portal.Inhibit" = "none";
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-wlr
    ];
  };
  services.libinput.enable = true;
  services.flatpak.enable = true;
nixpkgs.config.allowUnfree = true;
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
   nixpkgs.overlays = [
    (self: super: {
     dvcp-vaapi = super.callPackage ./packages/dvcp-vaapi { };
     davinci-resolve-studio = super.callPackage ./packages/davinci-resolve { };
    })
  ];
   environment.systemPackages = with pkgs; [
     wget
     gparted
     lxqt.lxqt-policykit
     nemo
     nemo-fileroller
     mpv
     kdePackages.kwallet
     kdePackages.kwallet-pam
     kdePackages.kwalletmanager
     kdePackages.qttools
     bat
     nordic
     papirus-icon-theme
     kitty
     rofi-wayland
     killall
     flatpak
     steam
     lutris
     wine-staging
     winetricks
     protontricks
     alsa-utils
     pamixer
     playerctl
     kdePackages.qtstyleplugin-kvantum
     lxappearance
     kdePackages.qt6ct
     libnotify
     looking-glass-client
     obs-studio-plugins.obs-vkcapture
     mangohud
     gamemode
     gamescope
     pciutils
     usbutils
     syncthingtray
     bleachbit
     whitesur-cursors
     git
     gh
#     davinci-resolve-studio
#     dvcp-vaapi
]; 
fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "RobotoMono" "Meslo" "JetBrainsMono" "Ubuntu" "UbuntuMono" "FiraCode" "DroidSansMono" ]; })
  ];

services.flatpak = {
  update.onActivation = true;
  remotes = [
    { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }
    { name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo"; }
    { name = "appcenter"; location = "https://flatpak.elementary.io/repo.flatpakrepo"; }
  ];
  packages = [
    { appId = "com.brave.Browser"; origin = "flathub"; }
    { appId = "io.gitlab.librewolf-community"; origin = "flathub"; }
    { appId = "com.obsproject.Studio"; origin = "flathub"; }
    { appId = "com.discordapp.Discord"; origin = "flathub"; }
    { appId = "io.github.ryubing.Ryujinx"; origin = "flathub"; }
    { appId = "info.cemu.Cemu"; origin = "flathub"; }
    { appId = "org.qbittorrent.qBittorrent"; origin = "flathub"; }
    { appId = "org.gimp.GIMP"; origin = "flathub"; }
    { appId = "net.rpcs3.RPCS3"; origin = "flathub"; }
    { appId = "org.prismlauncher.PrismLauncher"; origin = "flathub"; }
    { appId = "com.visualstudio.code"; origin = "flathub"; }
    { appId = "io.github.shiftey.Desktop"; origin = "flathub"; }

  ];
  overrides = {
    global = {
      Environment = {
        XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
      };
     Context = {
       filesystems = [
       "~/GitHub/dot-files:ro"
       "~/.local/share/icons:ro"
       "~/.local/share/themes:ro"
       "/run/host/usr/share/icons:ro"
       "/run/host/usr/share/themes:ro"
       "xdg-config/qt5ct:ro"
       "xdg-config/qt6ct:ro"
       "xdg-config/gtk-3.0:ro"
       "xdg-config/gtk-4.0:ro"
       "xdg-config/Kvantum:ro"
       "xdg-config/gtkrc:ro"
       "xdg-config/gtkrc-2.0:ro"
       ];
     };
    };
   };
};


   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  system.stateVersion = "24.11";
}

