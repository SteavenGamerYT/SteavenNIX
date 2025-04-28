{ config, pkgs, ... }:

{
  home = {
    sessionVariables = {
    EDITOR = "nano";
    BROWSER = "google-chrome";
    TERMINAL = "konsole";
    WLR_NO_HARDWARE_CURSORS = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    ICON_THEME = "Papirus";
    GTK_THEME = "Nordic";
    XCURSOR_SIZE = "24";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    };
  };
}
