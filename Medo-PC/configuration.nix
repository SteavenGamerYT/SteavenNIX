{ config, pkgs, unstabe, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
    };
  };

  networking.hostName = "Medo-PC"; # Define your hostname.

  time.timeZone = "Africa/Cairo";
  i18n = {
    extraLocales = [
      "en_US.UTF-8/UTF-8"
      "ar_EG.UTF-8/UTF-8"
    ];
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS       = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT   = "en_US.UTF-8";
      LC_MONETARY      = "en_US.UTF-8";
      LC_NAME          = "en_US.UTF-8";
      LC_NUMERIC       = "en_US.UTF-8";
      LC_PAPER         = "en_US.UTF-8";
      LC_TELEPHONE     = "en_US.UTF-8";
      LC_TIME          = "en_US.UTF-8";
    };
  };

  services = {
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable      = true;
          wayland     = true;
          autoSuspend = false;
        };
      };
      desktopManager.gnome.enable = true;
      xkb = {
        layout  = "us,eg";
        options = "grp:alt_shift_toggle";
      };
    };
    libinput.enable = true;
    openssh = {
      enable    = true;
      allowSFTP = true;
    };
    flatpak = {
      enable           = true;
      update.onActivation = true;
      remotes = [
        { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }
      ];
      packages = [
        # Games Utilities
        { appId = "com.vysp3r.ProtonPlus"; origin = "flathub"; }
        # Games
        { appId = "org.prismlauncher.PrismLauncher"; origin = "flathub"; }
        { appId = "org.vinegarhq.Sober"; origin = "flathub"; }
        { appId = "sh.ppy.osu"; origin = "flathub"; }
        # Utilities
        { appId = "org.kde.kwalletmanager5"; origin = "flathub"; }
        { appId = "io.github.flattool.Ignition"; origin = "flathub"; }
        { appId = "io.github.peazip.PeaZip"; origin = "flathub"; }
        { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
        { appId = "io.github.flattool.Warehouse"; origin = "flathub"; }
        { appId = "io.github.jonmagon.kdiskmark"; origin = "flathub"; }
        { appId = "com.mattjakeman.ExtensionManager"; origin = "flathub"; }
        # Apps
        { appId = "org.mozilla.firefox"; origin = "flathub"; }
        { appId = "com.discordapp.Discord"; origin = "flathub"; }
        { appId = "dev.vencord.Vesktop"; origin = "flathub"; }
        { appId = "io.mpv.Mpv"; origin = "flathub"; }
        { appId = "org.qbittorrent.qBittorrent"; origin = "flathub"; }
        { appId = "io.webtorrent.WebTorrent"; origin = "flathub"; }
        { appId = "com.moonlight_stream.Moonlight"; origin = "flathub"; }
        # Coding
        { appId = "org.kde.kate"; origin = "flathub"; }
        { appId = "org.kde.kcalc"; origin = "flathub"; }
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
  };

  security = {
    polkit.enable = true;
    rtkit.enable  = true;
    sudo.wheelNeedsPassword = true;
  };

  users.users.medo = {
    isNormalUser = true;
    description  = "medo";
    extraGroups  = [ "networkmanager" "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    kitty
    wget
    mpv
    topgrade
    fastfetch
    btop-rocm
    lutris
    badlion-client
    gnome-tweaks
  ];

  programs = {
    steam = {
      enable = true;
      protontricks.enable = true;
    };
    gamescope = {
      enable     = true;
      capSysNice = true;
    };
    dconf.enable = true;
    gnupg.agent = {
      enable           = true;
      enableSSHSupport = true;
    };
    nix-ld.enable = false;
    ssh.forwardX11 = true;
    file-roller.enable = true;
  };

  system.stateVersion = "25.05";
}
