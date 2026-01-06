{
  lib,
  inputs,
  nixpkgs,
  home-manager,
  ...
}:
with lib;
let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  flakeDir = {
    options.flakeDir = lib.mkOption {
      type = lib.types.str;
      default = "/home/ben/flake-config";
    };
  };
in
{
  "ben@benlaptop" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs;
    };
    modules = [
      inputs.stylix.homeModules.stylix
      ./laptop.nix
      ./ben.nix
      ../custom-options.nix
      ./modules
      flakeDir
    ];
  };
  "ben@bendesktop" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs;
    };
    modules = [
      inputs.stylix.homeModules.stylix
      ./desktop.nix
      ./ben.nix
      ../custom-options.nix
      ./modules
      flakeDir
    ];
  };
}
