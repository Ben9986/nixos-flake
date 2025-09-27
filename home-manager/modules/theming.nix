{
  pkgs,
  config,
  lib,
  ...
}:
{
  stylix.enable = true;
  stylix.targets = {
    hyprland.enable = false;
    hyprlock.useWallpaper = false;
    hyprlock.enable = false;
    swaylock.enable = false;
    kde.enable = config.home-manager.hyprland.enable;
  };
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-gray.yaml";

  gtk.iconTheme.name = "Papirus";


  # dconf = {
  #   enable = true;
  #   # settings = {
  #   #   "org/gnome/desktop/interface" = {
  #   #     color-scheme = "prefer-dark";
  #   #     icon-theme = "adwaita-icon-theme";
  #   #     cursor-theme = "phinger-cursors";
  #   #   };
  #   # };
  # };

  fonts.fontconfig.enable = true;

  # gtk = {
  #   enable = config.home-manager.hyprland.enable;
  #   # theme = {
  #   #   name = "Adwaita-dark";
  #   #   package = pkgs.gnome-themes-extra;
  #   # };
  #   cursorTheme = {
  #     name = "phinger-cursors";
  #     size = 24;
  #     package = pkgs.phinger-cursors;
  #   };
  #   iconTheme = {
  #     name = "adwaita-icon-theme";
  #     package = pkgs.adwaita-icon-theme;
  #   };
  #   gtk4.extraConfig = {
  #     gtk-application-prefer-dark-theme = true;
  #   };
  #   # gtk2.configLocation = "${config.home.homeDirectory}/.config/gtk-2.0/gtkrc-2.0";
  # };

  # qt = {
  #   enable = config.home-manager.hyprland.enable;
  #   style.name = "Breeze";
  #   style.package = pkgs.kdePackages.breeze;
  #   platformTheme.name = "Breeze";
  # };
}
