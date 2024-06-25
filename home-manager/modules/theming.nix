{pkgs, config, ...}:
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
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    cursorTheme = {
      name = "phinger-cursors";
     size = 24;
     package = pkgs.phinger-cursors;
    };
    iconTheme = {
      name = "adwaita-icon-theme";
      package = pkgs.gnome.adwaita-icon-theme;
      };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme=true;
      };
    gtk2.configLocation = "${config.home.homeDirectory}/.config/gtk-2.0/gtkrc-2.0";
  };

  qt = {
    enable = true;
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
    platformTheme.name = "adwaita";
  };
}
