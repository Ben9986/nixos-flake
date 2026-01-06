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
      desktopConfig.enable = true; 
    };
    niri.enable = true;
    swaylock.enable = true;
    theming.enable = true;
    wleave.enable = true;
    xdg.enable = true;
    zsh.enable = true;
  };
}