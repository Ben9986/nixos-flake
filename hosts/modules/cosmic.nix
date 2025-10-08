{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let cfg = config.cosmic;
in
{  
  options.cosmic = {
    enable = lib.mkEnableOption "Cosmic Session";
    greeter.enable = lib.mkEnableOption "Cosmic Greeter";
  };

  config = lib.mkIf cfg.enable {
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = cfg.greeter.enable;
    environment.systemPackages = with pkgs; [ kdePackages.kwallet-pam ];
    };
}
