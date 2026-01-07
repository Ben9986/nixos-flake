{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.home-manager.theming;
in
{
  options.home-manager.theming = {
    enable = mkEnableOption "Theming Configuration";
  };
  
  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/circus.yaml";
      targets = {
        hyprland.enable = false;
        hyprlock = {
          enable = false;
          useWallpaper = false;
        };
        kde.enable = false;
        kitty.enable = false;
        swaylock.enable = false;
      };
    };

    gtk.iconTheme.name = "Papirus";

    fonts.fontconfig.enable = true;
  };
}
