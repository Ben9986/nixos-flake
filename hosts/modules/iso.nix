{pkgs, lib, config, ... }:
let custom-installer = pkgs.writeShellScriptBin "custom-installer" ''
  echo "Hello, world!"
  '';
  cfg = config.iso;
in
{
  options.iso.enable = lib.mkEnableOption "Custom ISO Configuration";

  config = lib.mkIf cfg.iso {
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