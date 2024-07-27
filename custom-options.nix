{lib, config, ...}:
let 
  inherit (lib) mkIf mkOption mkEnableOption types;
in { 
  options.custom = {
    cosmic = {
      enable = mkEnableOption "pre-alpha Cosmic desktop environment";
      greeter.enable = mkEnableOption "Cosmic DE greeter";
    };
    flakeDir = mkOption {  
      type = types.str;
      default = "/home/ben/flake-config";
    };
    hyprland.enable = mkEnableOption "Hyprland";
    laptop.default-windows = mkEnableOption "booting directly to windows instead of nixos";
    vscode.disableGpu = mkOption {
      type = types.bool;
      default = false; 
    };
  };

  config.custom = {
    cosmic = {
      enable = lib.mkDefault false;
      greeter.enable = lib.mkDefault false;
    };
    hyprland.enable = lib.mkDefault false;
    laptop.default-windows = false;
  };
}
