{
  inputs,
  config,
  pkgs,
  ...
}:
{
  services.desktopManager.cosmic.enable = config.custom.cosmic.enable;
  services.displayManager.cosmic-greeter.enable = config.custom.cosmic.greeter.enable;
  environment.systemPackages = with pkgs; [ kwallet-pam ];
}
