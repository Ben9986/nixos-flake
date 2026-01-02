{ ... }:
{
  imports = [
    ./bootloader.nix
    ./core-services.nix
    ./cosmic.nix
    ./hyprland.nix
    ./niri.nix
    ./nvidia.nix
    ./plasma.nix
    ./virtualisation.nix
    ./wm-common.nix
    ./zenbook-audio-patch.nix
  ];
}
