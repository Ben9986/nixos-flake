{
  config,
  pkgs,
  lib,
  ...
}:
{
  xdg = {
    userDirs = {
      enable = true;
      templates = "${config.home.homeDirectory}/.config/Templates";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      pictures = "${config.home.homeDirectory}/Pictures";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
      "inode/directory" = [ "org.kde.dolphin.desktop" "yazi.desktop"];
      "text/plain" = [ "helix.desktop" "neovim.desktop" ];
      "text/html" = [ "vivaldi-stable.desktop" ];
      "application/pdf" = [ "vivaldi-stable.desktop" ];
    };
    };
  };
  xdg.systemDirs.data = [
    "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  ];
}
