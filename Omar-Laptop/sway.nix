{ config, lib, pkgs, ... }:

let
  swayWithUnsupportedGpu = pkgs.writeShellScript "sway-uwsm-wrapper" ''
    export XDG_SESSION_DESKTOP=sway
    exec ${pkgs.sway}/bin/sway --unsupported-gpu "$@"
  '';
in

{
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
          comment = "Sway compositor managed by UWSM with --unsupported-gpu";
          binPath = swayWithUnsupportedGpu;
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    cliphist
    wl-clip-persist
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
  ];
}
