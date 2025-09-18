{ lib, config, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options.custom = {
    cosmic = {
      enable = mkEnableOption "pre-alpha Cosmic desktop environment";
      greeter.enable = mkEnableOption "Cosmic DE greeter";
    };
    hyprland.enable = mkEnableOption "Hyprland";
    plasma.enable = mkEnableOption "KDE Plasma 6";
    flakeDir = mkOption {
      type = types.str;
      default = "/home/ben/flake-config";
    };
   
    laptop.default-windows = mkEnableOption "booting directly to windows instead of nixos";
    vscode.disableGpu = mkEnableOption "VScode software rendering only";
  };

  config.custom = {
    laptop.default-windows = lib.mkDefault true;
    cosmic.enable = false;
    cosmic.greeter.enable = false;
  };
}
