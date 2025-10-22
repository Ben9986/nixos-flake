{ ... }:
{
  imports = [
    ./bootloader.nix
    ./core-services.nix
    ./cosmic.nix
    ./hyprland.nix
    ./lanzaboote.nix
    ./nvidia.nix
    ./plasma.nix
    ./virtualisation.nix
    ./zenbook-audio-patch.nix
  ];
}
