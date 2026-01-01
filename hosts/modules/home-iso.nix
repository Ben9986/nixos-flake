{ ... }:
{
  home.file."flake-config" = {
    recursive = true;
    source = ../../.;
  };
  home.stateVersion = "25.05";
}