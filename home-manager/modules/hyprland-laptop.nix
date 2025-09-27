{ lib, config, ... }:
lib.mkIf ((config.host == "laptop") && config.home-manager.hyprland.enable ){
  wayland.windowManager.hyprland.settings = {
    monitor = "eDP-1,highres,0x0,1.5";
    env = [
      "QT_AUTO_SCREEN_SCALE_FACTOR,1.5"
    ];
  };
  home.file = {
    ".config/hypr/scripts/kbbrightness.sh".source = ../dotfiles/hypr/scripts/kbbrightness.sh;

    ".config/hypr/workspaces-acer.conf".source = ../dotfiles/hypr/workspaces-acer.conf;
    ".config/hypr/workspaces-ultrawide.conf".source = ../dotfiles/hypr/workspaces-ultrawide.conf;
    ".config/hypr/workspaces-blank.conf".text = "";

    ".config/hypr/monitors-blank.conf".text = "monitor = eDP-1,highres,0x0,1.8";
    ".config/hypr/monitors-acer.conf".text = ''
      monitor=desc:Samsung Display Corp. 0x4171,2880x1800@90.0,0x80,1.8,bitdepth,10
      monitor=desc:Acer Technologies Acer V247Y 0x1411579A,1920x1080@74.97,1600x0,1.0,bitdepth,10
    '';

    ".config/hypr/monitors-ultrawide.conf".text = ''
      monitor=desc:Samsung Display Corp. 0x4171,2880x1800@90.0,515x1080,1.8,bitdepth,10
      monitor=desc:LG Electronics LG ULTRAWIDE 0x000542FD,2560x1080@60.0,0x0,1.0,bitdepth,10
    '';
    ".config/hypr/scripts/monitor-switch.sh".source = ../dotfiles/hypr/scripts/monitor-switch.sh;
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload =
        [ "/home/ben/Pictures/Wallpapers/sundown-over-water.jpg" ];

      wallpaper = [
        ",/home/ben/Pictures/Wallpapers/sundown-over-water.jpg"
      ];
    };
  };
}
