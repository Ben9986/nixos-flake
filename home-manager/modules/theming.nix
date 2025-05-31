{
  pkgs,
  config,
  lib,
  ...
}:
{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        icon-theme = "adwaita-icon-theme";
        cursor-theme = "phinger-cursors";
      };
    };
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = config.custom.hyprland.enable;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    cursorTheme = {
      name = "phinger-cursors";
      size = 24;
      package = pkgs.phinger-cursors;
    };
    iconTheme = {
      name = "adwaita-icon-theme";
      package = pkgs.adwaita-icon-theme;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    # gtk2.configLocation = "${config.home.homeDirectory}/.config/gtk-2.0/gtkrc-2.0";
  };

  # qt = {
  #   enable = config.custom.hyprland.enable;
  #   style.name = "Breeze";
  #   style.package = pkgs.kdePackages.breeze;
  #   platformTheme.name = "Breeze";
  # };
}
