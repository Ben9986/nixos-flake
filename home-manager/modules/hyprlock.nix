{inputs, pkgs, ...}:
{
programs.hyprlock = {
    enable = true;
    backgrounds = [
      { 
      path = "screenshot";
      blur_size = 6;
      blur_passes = 2;
      }
    ];
    labels = [
      {
       text = "Welcome";
       font_size = 30;
       font_family = "SpaceMono Nerd Font";
       position.y = 20;
       halign = "center";
       shadow_passes = 2;
       shadow_size = 2;
      }
      {
       #text = "cmd[update:1000] date +\"%-H:%M\"";
       text = "$TIME";
       position.y = 280;
       font_size = 160;
       font_family = "SpaceMono Nerd Font Bold";
       halign = "center";
       shadow_passes = 2;
      }
    ];
    input-fields = [
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

       position.y = -70;
       halign = "center";
       valign = "center";
      }
    ];
  };
}
