{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.hyprlock = lib.mkIf config.custom.hyprland.enable {
    enable = true;
    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
    settings = {
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
          font_size = 30;
          font_family = "Ubuntu";
          position = "0, 100";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
          shadow_size = 2;
        }
        {
          text = "$TIME";
          position = "0, 280";
          font_size = 160;
          font_family = "Roboto-Black";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
        }
      ];
      input-field = [
        {
          size = "400px,70px";
          rounding = 20;
          outline_thickness = 2;
          dots_size = 0.3;
          dots_spacing = 0.15;
          dots_center = true;
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

          position = "0, -60";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
