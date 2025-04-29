{ config, lib, pkgs, ... }:

let
  # Custom variables
  username = "omarhanykasban";
  hostname = "Omar-PC";
  timezone = "Africa/Cairo";
  locale = "en_US.UTF-8";
  
  # Custom packages
  customPackages = with pkgs; [
    # System utilities
    bat
    eza
    fd
    fzf
    htop
    jq
    neofetch
    ripgrep
    zoxide
    
    # Development tools
    gcc
    gnumake
    cmake
    pkg-config
    
    # Security tools
    gnupg
    pass
    
    # Media tools
    ffmpeg
    imagemagick
    
    # Network tools
    nmap
    wireshark
    
    # System monitoring
    lm_sensors
    mission-center

    file
    coreutils
    gnugrep
    xorg.xdpyinfo
    bc
  ];
in {
  imports = [
    ./hardware-configuration.nix
    ./i3.nix
    ./kvm.nix
  ];

  # Boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # User configuration
  users.users.${username} = {
    isNormalUser = true;
    description = "OmarHanyKasban";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "libvirtd"
      "kvm"
      "libvirt"
      "input"
      "render"
      "docker"
      "scanner"
      "lp"
      "video"
      "disk"
    ];
    shell = pkgs.bash;
    home = "/home/${username}";
  };

  # System services
  services = {
    udisks2.enable = true;
    gvfs.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    syncthing = {
      enable = true;
      user = username;
      dataDir = "/home/${username}/Documents";
      configDir = "/home/${username}/.local/state/syncthing";
    };
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    fwupd.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    xserver = {
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
      xkb = {
        layout = "us,eg";
        options = "grp:alt_shift_toggle";
      };
    };
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        scrollMethod = "twofinger";
        accelProfile = "adaptive";
        accelSpeed = "0.5";
      };
      mouse = {
        accelProfile = "flat";
        accelSpeed = "0";
      };
    };
    flatpak = {
      enable = true;
      update.onActivation = true;
      remotes = [
        { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }
        { name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo"; }
        { name = "appcenter"; location = "https://flatpak.elementary.io/repo.flatpakrepo"; }
        { name = "fedora"; location = "https://flatpak.fedoraproject.org/repo/fedora.flatpakrepo"; }
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
  };

  # System configuration
  programs = {
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nix-ld.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    sudo.wheelNeedsPassword = true;
  };

  # Networking
  networking = {
    hostName = hostname;
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 8080 ];
      allowedUDPPorts = [ 53 67 68 123 5353 ];
    };
  };

  # Localization
  time.timeZone = timezone;
  i18n = {
    defaultLocale = locale;
    extraLocaleSettings = {
      LC_ADDRESS = locale;
      LC_IDENTIFICATION = locale;
      LC_MEASUREMENT = locale;
      LC_MONETARY = locale;
      LC_NAME = locale;
      LC_NUMERIC = locale;
      LC_PAPER = locale;
      LC_TELEPHONE = locale;
      LC_TIME = locale;
    };
  };

  console = {
    keyMap = "us";
    font = "latarcyrheb-sun32";
  };

  # Qt configuration
  qt = {
    platformTheme = "qt6ct";
    style = "kvantum";
  };

  # XDG Portal configuration
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

  # Hardware configuration
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    graphics = {
      enable = true;
    };
    pulseaudio.enable = false;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Existing packages
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
    dwt1-shell-color-scripts
    fastfetch
    bluez
    bluez-alsa
    bluez-tools
    blueman
    code-cursor
    appimage-run
    kbd
 #   dvcp-vaapi
 #   davinci-resolve-studio
  ] ++ customPackages;

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "RobotoMono" "Meslo" "JetBrainsMono" "Ubuntu" "UbuntuMono" "FiraCode" "DroidSansMono" ]; })
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
  ];

  # Nix configuration
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" username ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      dvcp-vaapi = super.callPackage ./packages/dvcp-vaapi { };
      davinci-resolve-studio = super.callPackage ./packages/davinci-resolve { };
    })
  ];

  # System version
  system.stateVersion = "24.11";
}

