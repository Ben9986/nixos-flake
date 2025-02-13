{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";
  programs.nixfmt.enable = true;
  settings.excludes = [
    "flake.lock"
    "*.gitignore"
    "*.dsl"
    "*.jpg"
    "*.patch"
    "*valheim-server*"
    "*/dotfiles/*"
  ];
}
