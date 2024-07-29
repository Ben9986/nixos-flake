{
  description = "System Configuration Flake";

  nixConfig.trusted-substituters = ["https://hyprland.cachix.org"];
  nixConfig.extra-trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];

  inputs = {
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprlock.url = "github:hyprwm/hyprlock";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
    matcha.url = "git+https://codeberg.org/QuincePie/matcha.git";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixos-generators, ...}@inputs:
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
      import ./home-manager/default.nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager;
        }
    );
    packages.x86_64-linux = {
      laptop = nixos-generators.nixosGenerate {
        format = "iso";
        inherit system;
        specialArgs = {
          inherit inputs; # needed for hyprland and probs other stuff
          host = {
            hostName = "benlaptop";
          };
        };
      modules = [
        hosts/benlaptop
        hosts/configuration.nix
        hosts/modules
        ./custom-options.nix
         ];
      };
    };
  };
}
