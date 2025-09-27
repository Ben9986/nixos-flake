{ pkgs, config, lib, ... }:
let cfg = config.virtualisation;
in {
  options.virtualisation = {
    enable = lib.mkEnableOption "Virtualisation Support";
  };
  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    users.users.ben.extraGroups = [ "libvirtd" ];
    };
}
