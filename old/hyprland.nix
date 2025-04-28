{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hyprland-environment.nix
  ];

  home.packages = with pkgs; [ 
    waybar
    swww
  ];
  
  #test later systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''
      #monitor=,preferred,auto,1
      #monitor=DP-1,1920x1080@60,1366x0,1 
      #monitor=HDMI-A-1,1366x768@59,0x0,1
      monitor=DP-1,1920x1080@60,0x0,1
      monitor=HDMI-A-1,1366x768@59,-1366x0,1

      # Fix slow startup
      exec systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP 

      # Autostart
      exec-once = hyprctl setcursor WhiteSur-cursors 24
      exec-once = dunst
      exec-once = swayidle timeout 300 'swaylock'
      exec-once = wl-clipboard-history -t
      #exec-once = wlsunset -S 9:00 -s 19:30
      exec = swaybg -m fill -i  /home/omarhanykasban/Pictures/wall_anime_2K.png
      exec-once = nm-applet
      exec-once = hyprpaper
      exec-once = waybar
      exec-once = xsettingsd
      exec-once = swayidle -w before-sleep $locker lock $locker after-resume $locker
      exec-once = swaync
      exec-once = fcitx5
      exec-once = xwaylandvideobridge
      exec = pkill waybar & sleep 0.5 && waybar
      # Set en layout at startup
      # Input config
      input {
        kb_layout = us,ara
        kb_variant =
        kb_model =
        kb_options=grp:alt_caps_toggle
        kb_rules =
        follow_mouse = 1
        accel_profile = flat
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
        touchpad {
          natural_scroll = false
        }
      }

      general {
        gaps_in = 5
        gaps_out = 5
        border_size = 0
        col.active_border = 0xff74b2ff
        col.inactive_border = 0xb3080808
        layout = dwindle
      }

      decoration {
        rounding = 8
        active_opacity = 1.0
        inactive_opacity = 1.0
        drop_shadow = true
        shadow_ignore_window = true
        shadow_offset = 2 2
        shadow_range = 4
        shadow_render_power = 2
        col.shadow = 0x66000000
        blurls = gtk-layer-shell
        blurls = rofi
        # blurls = waybar
        blurls = lockscreen
        blur {
          enabled = true
          size = 4
          passes = 2
          new_optimizations = true
        }

      }
      animations {
        enabled = yes
        bezier = overshot, 0.05, 0.9, 0.1, 1.05
        bezier = smoothOut, 0.36, 0, 0.66, -0.56
        bezier = smoothIn, 0.25, 1, 0.5, 1
        animation = windows, 1, 5, overshot, slide
        animation = windowsOut, 1, 4, smoothOut, slide
        animation = windowsMove, 1, 4, default
        animation = border, 1, 10, default
        animation = fade, 1, 10, smoothIn
        animation = fadeDim, 1, 10, smoothIn
        animation = workspaces, 1, 6, default
      }

      dwindle {
        no_gaps_when_only = false
        pseudotile = true
        preserve_split = true
      }
    # Example windowrule v1
    # windowrule = float, ^(kitty)$
    # Example windowrule v2
    # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

      windowrule = float, file_progress
      windowrule = float, confirm
      windowrule = float, dialog
      windowrule = float, download
      windowrule = float, notification
      windowrule = float, error
      windowrule = float, splash
      windowrule = float, confirmreset
      windowrule = float, title:Open File
      windowrule = float, title:branchdialog
      windowrule = float, Lxappearance
      windowrule = float, Rofi
      windowrule = animation none,Rofi
      windowrule = float,viewnior
      windowrule = float,feh
      windowrule = float, pavucontrol-qt
      windowrule = float, pavucontrol
      windowrule = float, file-roller
      windowrule = fullscreen, wlogout
      windowrule = float, title:wlogout
      windowrule = fullscreen, title:wlogout
      windowrule = idleinhibit focus, mpv
      windowrule = idleinhibit fullscreen, firefox
      windowrule = float, title:^(Media viewer)$
      windowrule = float, title:^(Volume Control)$
      windowrule = float, title:^(Picture-in-Picture)$
      windowrule = size 800 600, title:^(Volume Control)$
      windowrule = move 75 44%, title:^(Volume Control)$
      windowrulev2 = opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$
      windowrulev2 = noanim,class:^(xwaylandvideobridge)$
      windowrulev2 = noinitialfocus,class:^(xwaylandvideobridge)$
      windowrulev2 = maxsize 1 1,class:^(xwaylandvideobridge)$
      windowrulev2 = noblur,class:^(xwaylandvideobridge)$

      bind = SUPER, P, exec, wlogout
      bind = SUPER, F1, exec, ~/.config/hypr/keybind
      bind=, XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%
      bind=, XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%
      bind=, XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle
      bind=, XF86AudioPlay, exec, playerctl play-pause
      bind=, XF86AudioPause, exec, playerctl play-pause
      bind=, XF86AudioNext, exec, playerctl next
      bind=, XF86AudioPrev, exec, playerctl previous
      bind= ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
      bind= ,XF86MonBrightnessUp,exec,brightnessctl set 5%+

      $screenshotarea = hyprctl 0keyword animation "fadeOut,0,0,default"; grimblast --notify copysave area; hyprctl keyword animation "fadeOut,1,4,default"
      bind = SUPER SHIFT, S, exec, $screenshotarea
      bind = , Print, exec, grimblast --notify --cursor copysave output
      bind = ALT, Print, exec, grimblast --notify --cursor copysave screen


      bind = SUPER SHIFT, X, exec, hyprpicker -a -n
      bind = CTRL ALT, L, exec, swaylock
      bind = SUPER, Return, exec, konsole
      bind = SUPER, X, exec, konsole
      bind = SUPER, Z, exec, nemo
      bind = SUPER, B, exec, google-chrome-stable
      bind = SUPER, D, exec, killall rofi || rofi -modi drun,run -show drun -theme ~/.config/polybar/scripts/rofi/material.rasi
      bind = SUPER, period, exec, killall rofi || rofi -show emoji -emoji-format "{emoji}" -modi emoji -theme ~/.config/rofi/global/emoji
      bind = SUPER, escape, exec, wlogout --protocol layer-shell -b 5 -T 400 -B 400
      bind = SUPER SHIFT, Q, killactive,
      bind = SUPER, F, fullscreen,
      bind = SUPER, Space, togglefloating,
      bind = SUPER, P, pseudo, # dwindle
      bind = SUPER, S, togglesplit, # dwindle
      bind = SUPER, left, movefocus, l
      bind = SUPER, right, movefocus, r
      bind = SUPER, up, movefocus, u
      bind = SUPER, down, movefocus, d
      bind = SUPER SHIFT, left, movewindow, l
      bind = SUPER SHIFT, right, movewindow, r
      bind = SUPER SHIFT, up, movewindow, u
      bind = SUPER SHIFT, down, movewindow, d
      bind = SUPER CTRL, left, resizeactive, -20 0
      bind = SUPER CTRL, right, resizeactive, 20 0
      bind = SUPER CTRL, up, resizeactive, 0 -20
      bind = SUPER CTRL, down, resizeactive, 0 20
      bind= SUPER, g, togglegroup
      bind= SUPER, tab, changegroupactive
      bind = SUPER, grave, togglespecialworkspace
      bind = SUPERSHIFT, grave, movetoworkspace, special
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10
      bind = SUPER ALT, up, workspace, e+1
      bind = SUPER ALT, down, workspace, e-1
      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5
      bind = SUPER SHIFT, 6, movetoworkspace, 6
      bind = SUPER SHIFT, 7, movetoworkspace, 7
      bind = SUPER SHIFT, 8, movetoworkspace, 8
      bind = SUPER SHIFT, 9, movetoworkspace, 9
      bind = SUPER SHIFT, 0, movetoworkspace, 10
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow
      bind = SUPER, mouse_down, workspace, e+1
      bind = SUPER, mouse_up, workspace, e-1
      '';
    };
}
