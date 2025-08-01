{ config, lib, pkgs, unstable, ... }:

{
  _module.args = {
    username = "omarhanykasban";
    username2 = "rawanhanykasban";
    hostname = "Omar-PC";
    timezone = "Africa/Cairo";
    locale = "en_US.UTF-8";
    extralocales = [
      "en_US.UTF-8/UTF-8"
      "ar_EG.UTF-8/UTF-8"
    ];
    SunshinePort = 6000;
    sambaShareName = "omar-pc";
    sambaValidUsers = "omarhanykasban";
  };

  imports = [
    ./hardware-configuration.nix
    ./steavensettings.nix
    ./i3.nix
    ./sway.nix
    ./kvm.nix
    ./ollama.nix
    ./config.nix
  ];

  system.stateVersion = "25.05";
}
