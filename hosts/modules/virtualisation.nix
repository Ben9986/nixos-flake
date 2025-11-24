{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.virtualisation;
in
{
  options.virtualisation = {
    enable = lib.mkEnableOption "Virtualisation Support";
    winboat.enable = lib.mkEnableOption "Winboat and required config";
  };
  config = lib.mkIf cfg.enable (lib.mkMerge ([{
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    users.users.ben.extraGroups = [ "libvirtd" ];
    }
    (lib.mkIf cfg.winboat.enable {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
      };
      users.users.ben.extraGroups = [ "docker" ];
      environment.systemPackages = with pkgs; [ winboat docker-compose ];
    })
  ]));
}
