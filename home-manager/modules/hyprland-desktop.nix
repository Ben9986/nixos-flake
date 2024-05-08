{...}:        
{ 
wayland.windowManager.hyprland.settings = {
  monitor = "HDMI-A-1,2560x1080@60.0,0x0,1.0,bitdepth,10";
  env = [
    "GDK_SCALE,1"
    "WLR_DRM_NO_ATOMIC,1"
  ];
  windowrulev2 = [
    "immediate, class:^(Minecraft*)$"
    "immediate, class:^(valheim.x86_64)$"
    "idleinhibit focus, class:^(steam_app*)$"
    "immediate, class:^(steam)$"
  ];
  general = {
    allow_tearing = true;
  };
  };
home.file.".config/hypr/hyprpaper.conf".source = ../dotfiles/hypr/hyprpaper-desktop.conf;
}
