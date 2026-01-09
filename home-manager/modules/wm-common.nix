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
      # MkOutOfStoreSymlink allows config to be edited from noctalia menu.
      # This can then be commited like any other config change
      ".config/noctalia/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/flake-config/home-manager/dotfiles/noctalia/settings.json";
      ".config/noctalia/plugins/onedrive-status-monitor".source = ../dotfiles/noctalia/onedrive-status-monitor;
    };
  };
}