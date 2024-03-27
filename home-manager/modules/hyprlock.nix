{inputs, pkgs, ...}:
{
programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
    backgrounds = [
      { 
      path = "screenshot";
      blur_size = 6;
      blur_passes = 2;
      }
    ];
    labels = [
      {
       text = "<b>Please enter your password</b>";
       font_size = 28;
       font_family = "SpaceMono";
       position.y = 80;
       halign = "center";
      }
    ];
    input-fields = [
      {
       size = {
         width = 450;
         height = 60;
         };
       outline_thickness = 3;
       dots_size = 0.30000;
       dots_spacing = 0.150000;
       dots_center = true;
       outer_color = "rgb(151515)";
       inner_color = "rgb(166, 18, 72)";
       font_color = "rgb(10, 10, 10)";
       fade_on_empty = true;
       placeholder_text = "<i>Input Password...</i>";
       hide_input = false;

       position.y = -20;
       halign = "center";
       valign = "center";
      }
    ];
  };
}
