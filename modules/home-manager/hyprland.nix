{inputs, config, pkgs, lib, ...}:
{

nixpkgs.overlays = [
  (final: previous: {
      xdg-desktop-portal-hyprland = inputs.xdg-desktop-portal-hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    })
];
wayland.windowManager.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;
wayland.windowManager.hyprland.enable = true;
wayland.windowManager.hyprland.settings = {
env = [
  "XCURSOR_SIZE,24"
  "GTK_THEME,Catppuccin-Mocha-Standard-Blue-Dark"
  "COLOR_SCHEME,prefer-dark"
  "QT_QPA_PLATFORMTHEME,qt5ct"
  "WLR_NO_HARDWARE_CURSORS,1"
  "XCURSOR_THEME,phinger-cursors"
  "XDG_SESSION_TYPE,wayland"
  "VISUAL,nvim"
  "EDITOR,nvim"
];

exec = [
  "hyprpaper"
  #"pkill eww; eww daemon; eww open main"
  "pkill waybar; waybar"
  "pkill swayidle; swayidle -w"
];

exec-once = [
  "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
  "swaync" 
  "nm-applet --indicator"
  "blueberry-tray"
  "hyprctl dispatch exec [ workspace special:fm silent ] kitty ranger"
  "udiskie &"
  "copyq"
  "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XCURSOR_SIZE XCURSOR_THEME GTK_THEME COLOR_SCHEME"
  " hyprctl setcursor phinger-cursors 24"

];

input = {
    kb_layout = "gb";
    follow_mouse = 1;
    
    touchpad = {
        natural_scroll = 0;
        };
    sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
};

general = {
    gaps_in = 2;
    gaps_out = 3;
    border_size = 1;
    "col.active_border" = "rgba(2288ffff)";
    "col.inactive_border" = "rgba(595959aa)";
    
    layout = "dwindle";
    resize_on_border = true;
};

decoration = {
    rounding = 4;
    blur = {
      enabled = true;
      size = 6;
      passes = 1;
    };
    drop_shadow = 0;
};

animations = {
    enabled = true;

    bezier = [
      "myBezier, 0.05, 0.9, 0.1, 1.05"
      "newBezier, .54,.38,.22,1.01"
    ];
    animation = [ 
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 2, newBezier"
    ];
};

dwindle = {
    pseudotile = true;
    preserve_split = true;
    force_split = 2;
    no_gaps_when_only = true;
    special_scale_factor = 0.95;
};

master."new_is_master" = true;


gestures = {
    "workspace_swipe" = true;
    "workspace_swipe_invert" = false;
    "workspace_swipe_distance" = 350;
    "workspace_swipe_min_speed_to_force" = 20;
    "workspace_swipe_cancel_ratio" = 0.2;
};

misc = {
    vrr = 1;
    "key_press_enables_dpms" = true;
    "enable_swallow" = true;
    "swallow_regex" = "^(kitty)|()$";
    "swallow_exception_regex" = "^(firefox)|(nemo)$";
    "focus_on_activate" = true;
    "disable_hyprland_logo" = true;
    "force_default_wallpaper" = false;
};

windowrule = [
  "float, ^(blueberry.py)$"
"size 350 265, ^(blueberry.py)$"
"move onscreen cursor 70% 5%, ^(blueberry.py)$"
"noanim, ^(blueberry.py)$"
"stayfocused, ^(blueberry.py)$"

"float, ^(peazip)$"

"noblur, ^(nemo)$"
"noblur, ^(com.obsproject.Studio)$"
"opaque, ^(com.obsproject.Studio)$"

"noborder, ^(wofi)$"
"opacity 0.8 override 0.8 override, ^(kitty)$"
"float, ^(com.github.hluk.copyq)"
"size 40% 60%, ^(com.github.hluk.copyq)"
"center, ^(com.github.hluk.copyq)"
"tile, ^(ONLYOFFICE Desktop Editors)"
"float, ^(xdg-desktop-portal-gtk)"
"size 50% 60%, ^(xdg-desktop-portal-gtk)"
"idleinhibit focus, ^(steam_app*)"
];

"$mainMod" = "SUPER";

bind = [

# General Window Control
"$mainMod, C, killactive" 
"$mainMod, P, togglefloating" 
"$mainMod, J, togglesplit" # dwindle
"$mainMod SHIFT, F, fullscreen"
"$mainMod CTRL, F, fakefullscreen"

"$mainMod, K, togglegroup"
"$mainMod, M, changegroupactive"

# Session Control
"$mainMod ALT, P, exec, PATH=~/.config/wofi-logout GTK_THEME=Catppuccin-Mocha-Standard-Blue-Dark /run/current-system/sw/bin/wofi -c ~/.config/wofi-logout/config-logout"
"$mainMod, L, exec, swaylock -f -C ~/.config/swaylock/config"

# App Launch Shortcuts
"$mainMod, Q, exec, kitty"
"$mainMod, F, exec, firefox"
"SUPER, V, exec, copyq toggle"
"$mainMod, N, exec, swaync-client -t -sw"
"$mainMod, O, exec, flatpak run --user md.obsidian.Obsidian"

#F-keys shortcuts
", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.25 @DEFAULT_AUDIO_SINK@ 5%-"
", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.25 @DEFAULT_AUDIO_SINK@ 5%+"
", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
", XF86MonBrightnessUp, exec, ~/.local/bin/increase-brightness.sh"
", XF86MonBrightnessUp, exec, brightnessctl --min-value=20 s 40+"
", XF86MonBrightnessDown, exec, brightnessctl --min-value=20 s 40-"
", kbbrightcycle, exec, ~/.local/bin/backlightcontrol.sh"
# kill in the bind below doesn't work :/
"$mainMod SHIFT, S, exec, kill -9 $(pidof hyprshot) || XCURSOR_SIZE=48 HYPRSHOT_DIR=$HOME/Pictures/Screenshots ~/.local/bin/hyprshot -m region"
#", XF86Launch1, exec, ~/.local/bin/gtk-dark-light-toggle.sh # Toggle gnome dark/light mode"

# Move focus with mainMod + arrow keys
"$mainMod, left, movefocus, l"
"$mainMod, right, movefocus, r"
"$mainMod, up, movefocus, u"
"$mainMod, down, movefocus, d"

# Move windows with SUPER + ALT + arrow keys
"$mainMod ALT, left, swapwindow, l"
"$mainMod ALT, right, swapwindow, r"
"$mainMod ALT, up, swapwindow, u"
"$mainMod ALT, down, swapwindow, d"

# Switch workspaces with mainMod + [0-9]
"$mainMod, W, togglespecialworkspace, fm"
"$mainMod, 1, workspace, 1"
"$mainMod, 2, workspace, 2"
"$mainMod, 3, workspace, 3"
"$mainMod, 4, workspace, 4"
"$mainMod, 5, workspace, 5"
"$mainMod, 6, workspace, 6"
"$mainMod, 7, workspace, 7"
"$mainMod, 8, workspace, 8"
"$mainMod, 9, workspace, 9"
"$mainMod, 0, workspace, 10"

# Move active window to a workspace with mainMod + SHIFT + [0-9]
"$mainMod SHIFT, W, movetoworkspace, special:fm"
"$mainMod SHIFT, 1, movetoworkspace, 1"
"$mainMod SHIFT, 2, movetoworkspace, 2"
"$mainMod SHIFT, 3, movetoworkspace, 3"
"$mainMod SHIFT, 4, movetoworkspace, 4"
"$mainMod SHIFT, 5, movetoworkspace, 5"
"$mainMod SHIFT, 6, movetoworkspace, 6"
"$mainMod SHIFT, 7, movetoworkspace, 7"
"$mainMod SHIFT, 8, movetoworkspace, 8"
"$mainMod SHIFT, 9, movetoworkspace, 9"
"$mainMod SHIFT, 0, movetoworkspace, 10"

# Open numbered special workspaces
"ALT, 1, togglespecialworkspace, 1"
"ALT, 2, togglespecialworkspace, 2"
"ALT, 3, togglespecialworkspace, 3"
"ALT, 4, togglespecialworkspace, 4"
"ALT, 5, togglespecialworkspace, 5"

# Move active window to numbered special workspace
"ALT SHIFT, 1, movetoworkspace, special:1"
"ALT SHIFT, 2, movetoworkspace, special:2"
"ALT SHIFT, 3, movetoworkspace, special:3"
"ALT SHIFT, 4, movetoworkspace, special:4"
"ALT SHIFT, 5, movetoworkspace, special:5"
];
bindr = [
"SUPER, SUPER_L , exec, pkill wofi || GTK_THEME=Catppuccin-Mocha-Standard-Blue-Dark wofi"
];
bindm = [
# Move/resize windows with mainMod + LMB/RMB and dragging
"$mainMod, mouse:272, movewindow" # LMB
"$mainMod, mouse:274, resizewindow" # RMB
];
};
}
