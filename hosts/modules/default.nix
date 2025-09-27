{...}: {
  imports = [
    ./bootloader.nix
    ./core-services.nix
    ./cosmic.nix
    ./hyprland.nix
    ./plasma.nix
    ./nvidia.nix
    ./virtualisation.nix
    ./zenbook-audio-patch.nix
  ];
}
