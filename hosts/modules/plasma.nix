{pkgs, lib, config, ...}:
lib.mkIf config.custom.plasma.enable {
  services = {
    desktopManager.plasma6.enable = true;
  };
}