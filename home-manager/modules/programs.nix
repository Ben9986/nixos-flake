{config, pkgs, lib, ...}:
{
programs = {
  btop.enable = true;
  eza = {
    enable = true;
    enableZshIntegration = true;
  };
  firefox.enable = true;
  gh.enable = true;
  yazi.enable = true;
};

}
