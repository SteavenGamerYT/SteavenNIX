{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hyprland.nix
   ];
  # TODO please change the username & home direcotry to your own
  home.username = "omarhanykasban";
  home.homeDirectory = "/home/omarhanykasban";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  wayland.windowManager.hyprland.systemd.enable = true;
  # Themes
  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    theme.name = "Nordic";
    theme.package = pkgs.nordic;
    iconTheme.name = "Papirus";
    iconTheme.package = pkgs.papirus-icon-theme;
    cursorTheme.name = "WhiteSur-cursors";
    cursorTheme.package = pkgs.whitesur-cursors;
    font.name = "Roboto";
    font.package = pkgs.roboto;
  };
  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum-dark";
    style.package = pkgs.libsForQt5.qtstyleplugin-kvantum;
  };

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 24;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
      "inode/directory" = "nemo.desktop";
      "application/x-gnome-saved-search" = "nemo.desktop";
      "application/x-shellscript" = "org.kde.konsole.desktop";
      "video/mp4" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop"; # mov
      "video/x-matroska" = "mpv.desktop"; # mkv
      "audio/mpeg" = "mpv.desktop";
      "audio/x-wav" = "mpv.desktop";
      "audio/mp3" = "mpv.desktop";
      "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
      "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";
      "text/plain" = "org.kde.kate.desktop";
    };
  };

  home.file.".local/share/flatpak/overrides/global".text = ''
    [Context]
    filesystems=/run/current-system/sw/share/X11/fonts:ro;/nix/store:ro;~/.themes:ro;~/.icons:ro;xdg-config/gtk-3.0:ro;xdg-config/gtk-4.0:ro;xdg-config/qt5ct:ro;xdg-config/qt6ct:ro;xdg-config/Kvantum:ro;xdg-config/fontconfig:ro
  '';

# Packages that should be installed to the user profile.
  home.packages = with pkgs; [

    neofetch

    # archives

    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    bat # moderm cat
    trash-cli # trash command

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    
    lolcat
    gh
    dwt1-shell-color-scripts
  ];

  programs = {
    git = {
      enable = true;
      userName = "Omar Hany Kasban";
      userEmail = "omarhanykaban706@gmail.com";
    };
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };
    bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
        source /home/omarhanykasban/Documents/GitHub/dot-files/.steavengameryt
        unalias neofetch
   '';
      shellAliases = {
        cls = "${pkgs.ncurses}/bin/clear && colorscript -r";
        clear = "${pkgs.ncurses}/bin/clear && colorscript -r";
        neofetch-big = "${pkgs.neofetch}/bin/neofetch --ascii ~/.config/neofetch/cat.txt | lolcat";
        neofetch-small = "${pkgs.neofetch}/bin/neofetch --ascii ~/.config/neofetch/cat2.txt | lolcat";
        clean-nix = "sudo nix-collect-garbage -d && sudo nixos-rebuild boot";
        update-nix = "sudo nixos-rebuild switch";
      };   
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
