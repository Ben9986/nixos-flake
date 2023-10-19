{
  description = "System Configuration Flake";

  nixConfig.extra-substituters = ["https://hyprland.cachix.org"];
  nixConfig.extra-trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];

  inputs = {
    hyprland.url = "github:hyprwm/Hyprland"; 
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ...}@inputs:
  let
       system = "x86_64-linux";
  in {
    nixosConfigurations = (
      import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager;   # Inherit inputs
      }
    );

    homeConfigurations = (
      import ./home-manager {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager;
        }
    );
  };
}
