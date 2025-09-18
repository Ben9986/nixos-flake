{pkgs, lib, ... }:
{
  config = {
    isoImage = {
      makeEfiBootable = true;
      makeUsbBootable = true;
      configurationName = "Custom NixOS Live ISO";
      edition = "Custom";
      contents = [ { source = ../../.; target = "/flake-config"; } ];
    }; 
    networking.networkmanager.enable = true;
     environment.systemPackages = with pkgs; [
      git
     ];
  };
}