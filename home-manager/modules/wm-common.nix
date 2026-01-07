{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.home-manager.wm-common;
in
{
  options.home-manager.wm-common = {
    enable = mkEnableOption "wm-common Configuration";
  };
  
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kdePackages.breeze
      kdePackages.breeze-icons
      qt6Packages.qt6ct
    ];
    home.file = {
      ".config/rofi/rofi-clipboard.rasi".source = ../dotfiles/rofi/rofi-clipboard.rasi;
      ".config/kdeglobals".source = ../dotfiles/kdeglobals; # allows opening files in terminal apps without konsole, among other things
    };
  };
}