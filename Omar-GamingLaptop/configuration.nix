{ config, lib, pkgs, ... }:

let
  # Custom variables
  username = "omarhanykasban";
  hostname = "Omar-GamingLaptop";
  timezone = "Africa/Cairo";
  locale = "en_US.UTF-8";
  extralocales = [
  "en_US.UTF-8/UTF-8"
  "ar_EG.UTF-8/UTF-8"
  ];

  # Samba share configuration
  sambaShareName = "omar-gaminglaptop";
  sambaValidUsers = "omarhanykasban";
  
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
    file
    coreutils
    gnugrep
    bc
    starship
    atuin
    bash-preexec
    distrobox
    btop-rocm
    topgrade
    trash-cli
    gnome-disk-utility
    xviewer
    yt-dlp
    ffmpeg
    ncdu
    android-tools
    scrcpy
    kdePackages.kdeconnect-kde
    tldr

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
    
    # X11 utilities
    xorg.xdpyinfo

    # Benchmark tools
    mprime
    unigine-heaven
    unigine-superposition
    furmark

    # Apps
    # Dolphin
    kdePackages.dolphin # KDE file manager
    kdePackages.qtimageformats # Image format support for Qt5
    kdePackages.ffmpegthumbs # Video thumbnail support
    kdePackages.kde-cli-tools # KDE command line utilities
    kdePackages.kdegraphics-thumbnailers # KDE graphics thumbnails
    kdePackages.kimageformats # Additional image format support for KDE
    kdePackages.qtsvg # SVG support
    kdePackages.kio # KDE I/O framework
    kdePackages.kio-extras # Additional KDE I/O protocols
    kdePackages.kwayland # KDE Wayland integration

    dropbox
    dropbox-cli

    drive
    google-drive-ocamlfuse
    bleachbit
    unityhub
    anydesk
    rustdesk
    parsec-bin
    libreoffice
    onlyoffice-desktopeditors
    kdePackages.okular

  ];
in {
  imports = [
    ./hardware-configuration.nix
    ./i3.nix
    ./sway.nix
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
  systemd.coredump.enable = false;
  services = {
    speechd.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
    avahi = {
      enable = false;
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
      allowSFTP = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
      };
    };
    udev = {
      packages = with pkgs; [
        game-devices-udev-rules
      ];
    };
    xserver = {
      enable = true;
      displayManager = {
        lightdm = {
          enable = false;
          greeters.gtk = {
            enable = true;
            theme.name = "Nordic";
            iconTheme.name = "Papirus-Dark";
            cursorTheme.size = 24;
            cursorTheme.name = "whitesur-cursors";
          };
        };
        gdm = {
          enable = true;
          wayland = true;
        };
      };
      xkb = {
        layout = "us,eg";
        options = "grp:alt_shift_toggle";
      };
    };
    displayManager = {
      defaultSession = "sway-uwsm";
      sddm = {
          enable = false;
          package = pkgs.kdePackages.sddm;
          wayland.enable = true;
          wayland.compositor = "kwin";
          autoNumlock = true;
          enableHidpi = true;
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
    samba = {
      enable = true;
      smbd.enable = true;
      nmbd.enable = true;
      openFirewall = true;
      settings = {
        ${sambaShareName} = {
          path = "/";
          "read only" = false;
          "guest ok" = false;
          "valid users" = sambaValidUsers;
        };
      };
    };
    samba-wsdd = {
      openFirewall = true;
    };
    flatpak = {
      enable = true;
      update.onActivation = true;
      remotes = [
        { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }
        { name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo"; }
        { name = "appcenter"; location = "https://flatpak.elementary.io/repo.flatpakrepo"; }
        { name = "fedora"; location = "https://flatpak.fedoraproject.org/repo/fedora.flatpakrepo"; }
        { name = "launcher.moe"; location = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo"; }
      ];
      packages = [
        # Games Utitls
        { appId = "com.vysp3r.ProtonPlus"; origin = "flathub"; }
        # Games
        { appId = "org.prismlauncher.PrismLauncher"; origin = "flathub"; }
        { appId = "com.lunarclient.LunarClient"; origin = "flathub"; }
        { appId = "org.vinegarhq.Sober"; origin = "flathub"; }
        { appId = "moe.launcher.an-anime-game-launcher"; origin = "launcher.moe"; }
        # Emulators
        { appId = "net.rpcs3.RPCS3"; origin = "flathub"; }
        { appId = "info.cemu.Cemu"; origin = "flathub"; }
        { appId = "io.github.ryubing.Ryujinx"; origin = "flathub"; }
        # Utitls
        { appId = "org.kde.kwalletmanager5"; origin = "flathub"; }
        { appId = "io.github.flattool.Ignition"; origin = "flathub"; }
        { appId = "io.github.peazip.PeaZip"; origin = "flathub"; }
        { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
        # Apps
        { appId = "io.gitlab.librewolf-community"; origin = "flathub"; }
        { appId = "com.brave.Browser"; origin = "flathub"; }
        { appId = "com.discordapp.Discord"; origin = "flathub"; }
        { appId = "dev.vencord.Vesktop"; origin = "flathub"; }
        { appId = "com.ktechpit.whatsie"; origin = "flathub"; }
        { appId = "org.atheme.audacious"; origin = "flathub"; }
        { appId = "io.mpv.Mpv"; origin = "flathub"; }
        { appId = "org.qbittorrent.qBittorrent"; origin = "flathub"; }
        # Coding
        { appId = "com.visualstudio.code"; origin = "flathub"; }
        { appId = "org.kde.kate"; origin = "flathub"; }
        { appId = "org.kde.kcalc"; origin = "flathub"; }
        { appId = "io.github.shiftey.Desktop"; origin = "flathub"; }
        # Video Editing
        { appId = "com.obsproject.Studio"; origin = "flathub"; }
        { appId = "net.mediaarea.MediaInfo"; origin = "flathub"; }
        { appId = "org.gimp.GIMP"; origin = "flathub"; }
        { appId = "org.audacityteam.Audacity"; origin = "flathub"; }
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
    onlyoffice.enable = true;
  };

  # System configuration
  programs = {
    steam = {
      enable = true;
      protontricks.enable = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nix-ld.enable = false;
    ssh = {
      forwardX11 = true;
    };
    adb.enable = true;
    kdeconnect.enable = true;
    file-roller.enable = true;
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
      enable = false;
      allowedTCPPorts = [ 22 80 443 8080 ];
      allowedUDPPorts = [ 53 67 68 123 5353 ];
    };
  };

  # Localization
  time.timeZone = timezone;
  i18n = {
    extraLocales = extralocales;
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
    font = "latarcyrheb-sun16";
  };

  # Qt configuration
  qt = {
    enable = true;
    platformTheme = "qt5ct";
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

  # Virtualization
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
    waydroid.enable = true;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Existing packages
    wget
    gparted
    lxqt.lxqt-policykit
    nemo
    nemo-fileroller
    file-roller
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
    lutris
    winePackages.stagingFull
    winetricks
    heroic
    alsa-utils
    pamixer
    playerctl
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    lxappearance
    kdePackages.qt6ct
    libsForQt5.qt5ct
    libnotify
    looking-glass-client
    obs-studio-plugins.obs-vkcapture
    mangohud
    gamemode
    pciutils
    usbutils
    syncthingtray
    bleachbit
    whitesur-cursors
    git
    gh
    dwt1-shell-color-scripts
    fastfetch
    code-cursor
    appimage-run
    kbd
#    dvcp-vaapi
#    davinci-resolve-studio
  ] ++ customPackages;

  # Fonts
  fonts.packages = with pkgs; [
    roboto
    roboto-slab
    roboto-mono
    roboto-flex
    roboto-serif
    nerd-fonts.roboto-mono
    ubuntu-sans
    ubuntu-classic
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-sans
    nerd-fonts.ubuntu-mono
    fira-code
    fira-code-symbols
    fira-mono
    fira-math
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.noto
    texlivePackages.noto-emoji
    liberation_ttf
    nerd-fonts.liberation
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
      SteavennSddm = super.callPackage ./packages/SteavennSddm { };
      lact = super.callPackage ./packages/lact { };
    })
  ];

  # System version
  system.stateVersion = "25.05";
}