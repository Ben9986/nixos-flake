{lib, inputs, nixpkgs, home-manager, ... }:

let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  options = {
    flakeDir = "$HOME/flake-config";
    };
in
{
  "ben@benlaptop" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit inputs options; };
    modules = [
      ./ben.nix
      ./modules
      ./modules/hyprland-laptop.nix
    ];
  };
"ben@bendesktop" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit inputs options; };
    modules = [
      ./ben.nix
      ./modules
      ./modules/hyprland-desktop.nix
      {
      services.hypridle = {
        lockCmd = lib.mkForce "swaylock -f -C $HOME/.config/swaylock/config";
      };
    }
    ];
  };
}
