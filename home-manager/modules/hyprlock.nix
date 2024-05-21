{inputs, pkgs, ...}:
{
programs.hyprlock = {
    enable = true;
    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
    settings = {
      background = [
        { 
        path = "screenshot";
        blur_size = 6;
        blur_passes = 2;
        }
      ];
      label = [
        {
         text = "Welcome";
         font_size = 30;
         font_family = "SpaceMono Nerd Font";
         position = "0, 20";
         halign = "center";
         valign = "center";
         shadow_passes = 2;
         shadow_size = 2;
        }
        {
         text = "$TIME";
         position = "0, 280";
         font_size = 160;
         font_family = "SpaceMono Nerd Font Bold";
         halign = "center";
         valign = "center";
         shadow_passes = 2;
        }
      ];
      input-field = [
        {
         size = {
           width = 570;
           height = 70;
           };
         outline_thickness = 3;
         dots_size = 0.40000;
         dots_spacing = 0.150000;
         dots_center = true;
         outer_color = "rgb(151515)";
         inner_color = "rgb(171, 34, 114)";
         font_color = "rgb(0, 0, 0)";
         fade_on_empty = false;
         placeholder_text = "<big><b><i>Input Password</i></b></big>";
         hide_input = false;

         shadow_passes = 2;
         shadow_size = 3;

         fail_text = "<b>$FAIL</b>";
         fail_color = "rgb(15,15,15)";

         position = "0, -70";
         halign = "center";
         valign = "center";
        }
      ];
    };
  };
}
