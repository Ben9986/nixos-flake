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
      #./modules/nvidia-nouveau.nix
      ./modules
      ../custom-options.nix
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
    ];
  };
}
