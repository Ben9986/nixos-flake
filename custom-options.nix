{ lib, config, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options.custom = {
    hyprland.enable = mkEnableOption "Hyprland";
    plasma.enable = mkEnableOption "KDE Plasma 6";
    flakeDir = mkOption {
      type = types.str;
      default = "/home/ben/flake-config";
    };
   
    vscode.disableGpu = mkEnableOption "VScode software rendering only";
  };

  config.custom = {
  };
}
