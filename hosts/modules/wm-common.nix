{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.wm-common;
  commonPortals = {
      default = lib.mkForce [
        "hyprland"
        "kde"
        "gtk"
      ];
      "org.freedesktop.portal.FileChooser" = [ "kde" ];
      "org.freedesktop.portal.OpenURI" = [ "kde" ];
      "org.freedesktop.portal.Secret" = [ "kwallet" ];

    }; 
in
{
  options.wm-common = {
    enable = lib.mkEnableOption "Common config for Niri and Hyprland";
    };

  config = lib.mkIf cfg.enable {
    security.pam.services = lib.mkIf (!config.plasma.enable) {
      login.kwallet = {
        enable = true;
        package = pkgs.kdePackages.kwallet-pam;
        forceRun = true;
      };
    };

    xdg.portal =  {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-hyprland
      ];
      config = {
        hyprland = commonPortals;
        niri = commonPortals;
      };
  };


  };
}
  