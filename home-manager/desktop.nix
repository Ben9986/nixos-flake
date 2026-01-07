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
      enable = false;
      hypridle.enable = true;
      hyprlock.enable = true;
      desktopConfig.enable = true; 
    };
    niri.enable = true;
    theming.enable = true;
    wleave.enable = true;
    xdg.enable = true;
    zsh.enable = true;
  };

  programs.hyprlock.settings = {
        background = [
          {
            path = "screenshot";
            blur_size = 8;
            blur_passes = 3;
          }
        ];
        label = [
          {
            text = "Welcome";
            font_size = 20;
            font_family = "Ubuntu";
            position = "0, 60";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
            shadow_size = 2;
          }
          {
            text = "$TIME";
            position = "0, 150";
            font_size = 100;
            font_family = "Roboto-Black";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
          }
        ];
        input-field = [
          {
            size = "300px,40px";
            rounding = 10;
            outline_thickness = 2;
            dots_size = 0.25;
            dots_spacing = 0.12;
            dots_center = false;
            outer_color = "rgb(255,255,255)";
            inner_color = "rgb(100,100,100)";
            font_color = "rgb(0, 0, 0)";
            fade_on_empty = false;
            placeholder_text = "<big><b><i>Input Password</i></b></big>";
            hide_input = false;

            shadow_passes = 2;
            shadow_size = 3;

            fail_text = "<b>$FAIL</b>";
            fail_color = "rgb(15,15,15)";

            position = "0, -30";
            halign = "center";
            valign = "center";
          }
        ];
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