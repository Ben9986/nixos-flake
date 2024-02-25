{...}:        
{ 
wayland.windowManager.hyprland.settings = {
  monitor = "HDMI-A-1,highres,auto,1";
  env = [
    "GDK_SCALE,1"
  ];
  };
home.file.".config/hypr/hyprpaper.conf".source = ../dotfiles/hypr/hyprpaper-desktop.conf;
}
