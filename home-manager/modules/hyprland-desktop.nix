{ lib, config, ... }:
lib.mkIf config.custom.hyprland.enable {
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


  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload =
        [ "/home/ben/Pictures/Wallpapers/stag-ultrawide.jpg" ];

      wallpaper = [
        "DP-3,/home/ben/Pictures/Wallpapers/stag-ultrawide.jpg"
      ];
    };
  };

  services.hypridle.settings.general = {
    lock_cmd = lib.mkForce "swaylock -f -C $HOME/.config/swaylock/config";
  };
}
