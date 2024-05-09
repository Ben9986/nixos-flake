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
      };
    };
    modules = [
      ./benlaptop
      ./configuration.nix
      ./modules
      ../custom-options.nix
         ];
  };
  bendesktop = lib.nixosSystem {                                # Desktop Profile
    inherit system;
    specialArgs = {
      inherit inputs; # needed for hyprland and probs other stuff
      host = {
        hostName = "bendesktop";
      };
    };
    modules = [
      ./bendesktop
      ./configuration.nix
      ./modules/nvidia.nix
      #./modules/nvidia-nouveau.nix
      ./modules
      ../custom-options.nix
    ];
  };
}
