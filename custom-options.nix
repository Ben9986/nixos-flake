{lib, ...}:
{ 
options = {
  flakeDir = lib.mkOption {  
    type = lib.types.str;
    };
    hyprland.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
config.flakeDir = "/home/ben/flake-config";
}
