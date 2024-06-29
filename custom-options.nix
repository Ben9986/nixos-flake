{lib, config, ...}:
let 
  inherit (lib) mkIf mkOption mkEnableOption types;
in { 
  options = {
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
      hyprland.enable = false;
      laptop.default-windows = false;
    };
}
