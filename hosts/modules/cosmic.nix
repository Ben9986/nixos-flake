{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.cosmic;
in
with lib;
{
  options.cosmic = {
    enable = lib.mkEnableOption "Cosmic Session";
    greeter.enable = lib.mkEnableOption "Cosmic Greeter";
  };

  config = mkMerge [
    (mkIf cfg.enable { services.desktopManager.cosmic.enable = true; })

    (mkIf cfg.greeter.enable {
      services.displayManager.cosmic-greeter.enable = cfg.greeter.enable;
      security.pam.services.greetd.kwallet = lib.mkIf cfg.greeter.enable {
        enable = true;
        package = pkgs.kdePackages.kwallet-pam;
      };
    })
  ];
}
