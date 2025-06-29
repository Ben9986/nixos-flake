{
  lib,
  inputs,
  nixpkgs,
  home-manager,
  ...
}:

let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in
{
  "ben@benlaptop" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs;
    };
    modules = [
      ./ben.nix
      ../custom-options.nix
      ./modules
      ./modules/hyprland-laptop.nix
      inputs.hyprland.homeManagerModules.default
      inputs.stylix.homeModules.stylix
    ];
  };
  "ben@bendesktop" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs;
    };
    modules = [
      ./ben.nix
      ../custom-options.nix
      ./modules
      ./modules/hyprland-desktop.nix
      inputs.hyprland.homeManagerModules.default
      { config.custom.vscode.disableGpu = true; }
    ];
  };
}
