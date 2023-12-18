{lib, inputs, nixpkgs, home-manager}:
let
  system = "x86_64-linux";                                  # System Architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow Proprietary Software
  };

  lib = nixpkgs.lib;
in
{
  benlaptop = lib.nixosSystem {                                # Laptop Profile
    inherit system;
    specialArgs = {
      inherit inputs; # needed for hyprland and probs other stuff
      host = {
        hostName = "benlaptop";
        #mainMonitor = "eDP-1";
      };
    };
    modules = [
      ./benlaptop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
  bendesktop = lib.nixosSystem {                                # Laptop Profile
    inherit system;
    specialArgs = {
      inherit inputs; # needed for hyprland and probs other stuff
      host = {
        hostName = "bendesktop";
        #mainMonitor = "eDP-1";
      };
    };
    modules = [
      ./bendesktop
      ./configuration.nix
      ../modules/nixos/nvidia.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
