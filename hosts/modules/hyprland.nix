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
    polkit_gnome
    networkmanagerapplet
    blueberry
    brightnessctl
    font-awesome
    udiskie
    copyq
    nwg-look
    swww
    glib # gsettings for nwg-look
    swaynotificationcenter
    gnome.gnome-software
    nemo-with-extensions
    gtk3
    adwaita-icon-theme
    # qt5&6 wayland needed for xdph
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    libsForQt5.qt5ct
    qt6Packages.qt6ct
  ];

  # Fix Default Apps opening in Flatpaks
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
  '';

  services.displayManager.defaultSession = lib.mkIf config.custom.hyprland.enable "hyprland";

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

}
