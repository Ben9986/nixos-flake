{ lib, inputs, nixpkgs, home-manager, nixgl, vars, ... }:

let
  system = "x86_64-linux";
 # pkgs = nixpkgs.legacyPackages.${system};
in
{
  ben = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit inputs; };
    modules = [
      ./ben.nix
    ];
  };
}
