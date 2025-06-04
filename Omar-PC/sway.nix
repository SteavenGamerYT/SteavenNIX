{ config, lib, pkgs, ... }:

let
  swayWithUnsupportedGpu = pkgs.writeShellScriptBin "sway-uwsm-wrapper" ''
    export XDG_SESSION_DESKTOP=sway
    exec ${pkgs.sway}/bin/sway --unsupported-gpu "$@"
  '';
in

{
  programs = {
    sway = {
      enable = true;
      extraOptions = [ "--unsupported-gpu" ];
      xwayland.enable = true;
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
          binPath = "${swayWithUnsupportedGpu}/bin/sway-uwsm-wrapper";
        };
      };
    };
  };

  # Make sure the custom sway.desktop is available system-wide
  environment.etc."xdg/wayland-sessions/sway.desktop".text = ''
    [Desktop Entry]
    Name=Sway (Unsupported GPU)
    Comment=An i3-compatible Wayland compositor with --unsupported-gpu
    Exec=${swayWithUnsupportedGpu}/bin/sway-uwsm-wrapper
    Type=Application
    DesktopNames=sway
    X-GDM-SessionRegisters=true
  '';

  environment.systemPackages = with pkgs; [
    sway
    waybar
    uwsm
    swaylock-effects
    swaybg
    swayidle
    swaynotificationcenter
    cliphist
    wl-clip-persist
    grim
    slurp
    wl-clipboard
    nwg-look
    sway-contrib.grimshot
    wlsunset
    wdisplays
    wlr-randr
    kdePackages.xwaylandvideobridge
  ];
  systemd.targets.network-online.wantedBy = [ ];
}