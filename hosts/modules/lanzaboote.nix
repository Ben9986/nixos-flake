{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.bootloader.lanzaboote;
in
{
  options.bootloader.lanzaboote = {
    enable = mkEnableOption {
      type = lib.types.bool;
      default = false;
      description = "Replace default bootloader config with lanzaboote to enable secure boot";
    };
  };
  
  config = lib.mkIf (cfg.enable && config.bootloader.enable) (lib.mkMerge [
    {
    environment.systemPackages = [ pkgs.sbctl ];
    boot.loader.systemd-boot.enable = lib.mkForce false;
  
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      settings = {
        timeout = "menu-hidden";
      };
    };
    }
    (mkIf config.bootloader.default-windows {
      boot.lanzaboote.settings.default = "auto-windows";
    })
  ]);
}