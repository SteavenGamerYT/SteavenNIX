{ config, lib, pkgs, ... }:

{
  # Enable sway window manager
  programs = {
    sway = {
      enable = true;
      xwayland.enable = true;
      extraOptions = [ "--unsupported-gpu" ];
      extraSessionCommands = ''
        export XDG_SESSION_DESKTOP=sway
      '';
      wrapperFeatures.base = true;
      wrapperFeatures.gtk = true;
    };
    waybar.enable = true;
    xwayland.enable = true;
    uwsm = {
      enable = true;
      waylandCompositors = {
        sway = {
          prettyName = "Sway";
          comment = "Sway compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/sway";
        };
      };
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    cliphist
    wl-clip-persist
    cliphist
    swayidle
    swaylock-effects
    swaybg
    kdePackages.xwaylandvideobridge
    waybar
    swaynotificationcenter
    uwsm
    sway
    grim
    slurp
    wl-clipboard
    nwg-look
    sway-contrib.grimshot
    wlsunset
    wdisplays
    wlr-randr
    kdePackages.dolphin
  ];
}
