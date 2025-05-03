{ config, lib, pkgs, ... }:

let
  # Custom variables
  username = "omarhanykasban";
  hostname = "Omar-PC-Server";
  timezone = "Africa/Cairo";
  locale = "en_US.UTF-8";

  # Custom packages
  customPackages = with pkgs; [
    # System utilities
    wget
    kitty
    sshfs
    sshpass
    killall
    
    # Development tools
    nodejs_23
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
  system.stateVersion = "24.11";

  # Networking
  networking = {
    hostName = hostname;
    firewall.enable = false;
  };

  # Time and locale
  time.timeZone = timezone;
  i18n.defaultLocale = locale;

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