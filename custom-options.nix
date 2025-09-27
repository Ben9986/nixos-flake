{ lib, config, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options.custom = {
    hyprland.enable = mkEnableOption "Hyprland";
    plasma.enable = mkEnableOption "KDE Plasma 6";
    vscode.disableGpu = mkEnableOption "VScode software rendering only";
  };

  config.custom = {
  };
}
