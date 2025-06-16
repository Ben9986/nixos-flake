{
  inputs,
  pkgs,
  config,
  ...
}:
{
  programs.swaylock = pkgs.lib.mkIf config.custom.hyprland.enable {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      # "color" = "303336";
      "ignore-empty-password" = true;
      "indicator-caps-lock" = true;
      "screenshots" = true;
      "effect-blur" = "10x3";
      "effect-greyscale" = true;
      "clock" = true;
      "timestr" = "%H:%M";
      "datestr" = "";
      "indicator-thickness" = "5";
      "ring-color" = "bb00cc";
      "key-hl-color" = "ffffffff";
      "inside-wrong-color" = "00000088";
      "text-wrong-color" = "ff0055ff";
    };
  };
}
