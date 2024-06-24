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

      ags.enable = mkEnableOption "Ags configuration";
      vscode.disableGpu = mkOption {
        type = types.bool;
        default = false; 
      };
    };

    config = {
      hyprland.enable = false;
      ags.enable = mkIf config.hyprland.enable true;
    };
}
