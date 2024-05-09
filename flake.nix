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
    matugen.url = "github:/InioX/Matugen?ref=v2.2.0";
    matcha.url = "git+https://codeberg.org/QuincePie/matcha.git";
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
      import ./home-manager/default.nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager;
        }
    );
  };
}
