{
  description = "System Configuration Flake";

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
    nixosConfigurations = {
      benlaptop = nixpkgs.lib.nixosSystem {
        inherit system;
	specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              users.ben = ./home-manager/home.nix;
            };
          }
        ];
      };
    };
  
  };
}
}
