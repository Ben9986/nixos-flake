{lib, config, ...}:
let 
  inherit (lib) mkIf mkOption mkEnableOption types;
in { 
  options = {
    cosmic.enable = mkEnableOption "pre-alpha Cosmic desktop environment";
    flakeDir = mkOption {  
      type = types.str;
      default = "/home/ben/flake-config";
      };
      hyprland.enable = mkEnableOption "Hyprland";
      vscode.disableGpu = mkOption {
        type = types.bool;
        default = false; 
      };
      laptop.default-windows = mkEnableOption "booting directly to windows instead of nixos";
    };

    config = {
      cosmic.enable = true;
      hyprland.enable = false;
      laptop.default-windows = false;
    };
}
