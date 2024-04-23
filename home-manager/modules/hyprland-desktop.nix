{...}:        
{ 
wayland.windowManager.hyprland.settings = {
  monitor = "HDMI-A-1,highres,auto,1";
  env = [
    "GDK_SCALE,1"
    "WLR_DRM_NO_ATOMIC,1"
  ];
  windowrule = [
    "immediate, ^(Minecraft*)$"
  ];
  };
home.file.".config/hypr/hyprpaper.conf".source = ../dotfiles/hypr/hyprpaper-desktop.conf;
}
