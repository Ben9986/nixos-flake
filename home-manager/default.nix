{lib, inputs, nixpkgs, home-manager, ... }:

let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in
{
  "ben@benlaptop" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit inputs; };
    modules = [
      ./ben.nix
      ../custom-options.nix
      ./modules
      ./modules/hyprland-laptop.nix
      inputs.hyprland.homeManagerModules.default
    ];
  };
"ben@bendesktop" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit inputs; };
    modules = [
      ./ben.nix
      ../custom-options.nix
      ./modules
      ./modules/hyprland-desktop.nix
      inputs.hyprland.homeManagerModules.default
      {
      services.hypridle = {
        lockCmd = lib.mkForce "swaylock -f -C $HOME/.config/swaylock/config";
      };
    }
    ];
  };
}
