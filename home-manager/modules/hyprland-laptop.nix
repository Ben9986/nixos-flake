{...}:        
{ 
wayland.windowManager.hyprland.settings = {
  monitor = "eDP-1,highres,0x0,1.8";
  env = [
    "QT_AUTO_SCREEN_SCALE_FACTOR,1"
  ];
  };
home.file.".config/hypr/hyprpaper.conf".source = ../dotfiles/hypr/hyprpaper-laptop.conf;
}
