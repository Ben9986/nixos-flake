{ pkgs, lib, ... }:
{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  users.users.ben.extraGroups = [ "libvirtd" ];

}
