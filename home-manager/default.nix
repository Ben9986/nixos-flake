{
  lib,
  inputs,
  nixpkgs,
  home-manager,
  ...
}:
with lib;
let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  flakeDir = {
    options.flakeDir = lib.mkOption {
      type = lib.types.str;
      default = "/home/ben/flake-config";
    };
  };
in
{
  "ben@benlaptop" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs;
    };
    modules = [
      inputs.hyprland.homeManagerModules.default
      inputs.stylix.homeModules.stylix
      ./ben.nix
      ../custom-options.nix
      ./modules
      flakeDir
      {
        options.host = mkOption {
          type = types.enum [
            "desktop"
            "laptop"
          ];
          default = "laptop";
          description = "Hostname";
        };
      }
    ];
  };
  "ben@bendesktop" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs;
    };
    modules = [
      inputs.hyprland.homeManagerModules.default
      inputs.stylix.homeModules.stylix
      ./ben.nix
      ../custom-options.nix
      ./modules
      flakeDir
      {
        config.custom.vscode.disableGpu = true;
        options.host = mkOption {
          type = types.enum [
            "desktop"
            "laptop"
          ];
          default = "desktop";
          description = "Hostname";
        };
      }
    ];
  };
}
