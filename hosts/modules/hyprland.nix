{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf config.custom.hyprland.enable {
  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };
  environment.systemPackages = with pkgs; [
    kdePackages.kwallet
    kdePackages.kwallet-pam
    kdePackages.kirigami
    kdePackages.qtstyleplugin-kvantum
    kdePackages.qt6ct
    kvmarwaita
    lxqt.pcmanfm-qt
    hyprpolkitagent
    swayosd
    brightnessctl
  ];

  # Fix Default Apps opening in Flatpaks
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
  '';

  systemd.services.swayosd-libinput-backend = {
    description = "SwayOSD LibInput backend for listening to certain keys like CapsLock, ScrollLock, VolumeUp, etc.";
    documentation = [ "https://github.com/ErikReider/SwayOSD" ];
    wantedBy = [ "graphical.target" ];

    serviceConfig = {
      Type = "dbus";
      BusName = "org.erikreider.swayosd";
      ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
      Restart = "on-failure";
    };
  };
  
  services = {
    blueman.enable = true;
    displayManager.defaultSession = "hyprland";
    udev.packages = [ pkgs.swayosd ];
  };
  
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.kdePackages.xdg-desktop-portal-kde ];

}
