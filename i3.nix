{ config, lib, pkgs, ... }:

{
  services.xserver.windowManager.i3.enable = true;
  environment.systemPackages = with pkgs; [
     xclip
     flameshot
     polybarFull
     feh
     betterlockscreen
     dunst
     libnotify
     looking-glass-client
];
}
