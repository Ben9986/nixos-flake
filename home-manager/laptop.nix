{
  pkgs,
  config,
  lib,
  ...
}:
with lib;

{
  home-manager = {
    fuzzel.enable = true;
    hyprland = {
      hypridle.enable = true;
      laptopConfig.enable = true; 
    };
    niri.enable = true;
    theming.enable = true;
    wleave.enable = true;
    xdg.enable = true;
    zsh.enable = true;
  };

  systemd.user.services = {
    "wallpaper" = {
       Unit = {
        Description = "Set Wallpaper";
        After = [
          "graphical-session.target"
        ];
        Wants = [ "graphical-session.target" ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "set-wallpaper" ''
          set -eu
          swww-daemon || true
          swww img $HOME/Pictures/Wallpapers/lo-fi-cafe.png
        ''}";
        Type = "oneshot";
      };
    };
  };
}