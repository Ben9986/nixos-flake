{pkgs, lib, config, ... }:
let custom-installer = pkgs.writeShellScriptBin "custom-installer" ''
  echo "Hello, world!"
  '';
in
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
      custom-installer
     ];
  };
}