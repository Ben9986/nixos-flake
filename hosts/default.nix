{
  lib,
  inputs,
  nixpkgs,
  home-manager,
}:
let
  system = "x86_64-linux"; # System Architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true; # Allow Proprietary Software
  };

  lib = nixpkgs.lib;
  flakeDir = { 
    options.flakeDir = lib.mkOption {
      type = lib.types.str;
      default = "/home/ben/flake-config";
    };};
in
{
  benlaptop = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs; # needed for hyprland and probs other stuff
      host = {
        hostName = "benlaptop";
      };
    };
    modules = [
      ./benlaptop
      ./common.nix
      ./modules
      ../custom-options.nix
      flakeDir
    ];
  };
  bendesktop = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs; # needed for hyprland and probs other stuff
      host = {
        hostName = "bendesktop";
      };
    };
    modules = [
      ./bendesktop
      ./common.nix
      ./modules/nvidia.nix
      ./modules
      ../custom-options.nix
      flakeDir
    ];
  };
  trinity = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs;
      host = {
        hostName = "trinity";
      };
    };
    modules = [
      ./trinity
      ../custom-options.nix
      flakeDir
    ];
  };
  iso = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs;
        host = {
          hostName = "NixosIso";
      };
    };
    modules = [
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      ./modules/iso.nix
    ];
  };
}
