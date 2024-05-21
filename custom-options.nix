{lib, ...}:
{ 
options = {
  flakeDir = lib.mkOption {  
    type = lib.types.str;
    default = "/home/ben/flake-config";
    };
    hyprland.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
}
