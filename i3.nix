{ config, lib, pkgs, ... }:

{
  # Enable i3 window manager
  services.xserver.windowManager.i3.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    xclip
    flameshot
    polybarFull
    feh
    betterlockscreen
    dunst
    libnotify
    picom
    imagemagick
    i3lock-color
  ];
}
