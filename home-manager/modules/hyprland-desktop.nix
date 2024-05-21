{...}:        
{ 
wayland.windowManager.hyprland.settings = {
  monitor = "HDMI-A-1,2560x1080@60,auto,1,bitdepth,10";
  env = [
    "GDK_SCALE,1"
    "WLR_DRM_NO_ATOMIC,1"
    "LIBVA_DRIVER_NAME,nvidia"
    "GBM_BACKEND,nvidia-drm"
    "__GLX_VENDOR_LIBRARY_NAME,nvidia"
  ];
  windowrulev2 = [
    "immediate, class:^(Minecraft*)$"
    "immediate, class:^(valheim.x86_64)$"
    "idleinhibit focus, class:^(steam_app*)$"
    #"immediate, class:^(steam)$"
  ];
  general = {
    allow_tearing = true;
  };
  cursor = {
    no_hardware_cursors = false;
  };
  };
home.file.".config/hypr/hyprpaper.conf".source = ../dotfiles/hypr/hyprpaper-desktop.conf;
}
