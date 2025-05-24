{ config, lib, pkgs, ... }:

let
  # Custom variables
  username = "omarhanykasban";
  hostname = "Omar-PC-Server";
  timezone = "Africa/Cairo";
  locale = "en_US.UTF-8";
  extralocales = [
  "en_US.UTF-8/UTF-8"
  "ar_EG.UTF-8/UTF-8"
  ];

  # Custom packages
  customPackages = with pkgs; [
    # System utilities
    wget
    kitty
    sshfs
    sshpass
    killall
    
    # Development tools
    nodejs_24
    caddy
    
    # System monitoring
    btop
  ];
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # System configuration
  system.stateVersion = "25.05";

  # Networking
  networking = {
    hostName = hostname;
    firewall.enable = false;
  };

  # Time and locale
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

  # User configuration
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

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

  # System packages
  environment.systemPackages = customPackages;

  # Programs configuration
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    fuse.userAllowOther = true;
  };

  # Services
  services = {
    openssh = {
      enable = true;
      allowSFTP = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
      };
    };
    caddy.enable = false;
  };
}