{
  config,
  pkgs,
  lib,
  ...
}:
{
  xdg = {
    enable = true;
    desktopEntries = {
      vivaldi-stable = {
        name = "Vivaldi";
        exec = "${pkgs.vivaldi}/bin/vivaldi --ozone-platform=wayland --password-store=kwallet6 %U";
        startupNotify = true;
        terminal = false;
        icon = "vivaldi";
        type = "Application";
        categories = [
          "Network"
          "WebBrowser"
        ];
        mimeType = [
          "application/pdf"
          "application/rdf+xml"
          "application/rss+xml"
          "application/xhtml+xml"
          "application/xhtml_xml"
          "application/xml"
          "image/gif"
          "image/jpeg"
          "image/png"
          "image/webp"
          "text/html"
          "text/xml"
          "x-scheme-handler/ftp"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/mailto"
        ];
        actions = {
          "new-window" = {
            exec = "${pkgs.vivaldi}/bin/vivaldi --new-window";
          };
          "new-private-window" = {
            exec = "${pkgs.vivaldi}/bin/vivaldi --incognito";
          };
        };
      };
    };
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [
          "org.kde.dolphin.desktop"
          "yazi.desktop"
        ];
        "text/plain" = [
          "helix.desktop"
          "neovim.desktop"
        ];
        "text/html" = [ "vivaldi-stable.desktop" ];
        "application/pdf" = [ "vivaldi-stable.desktop" ];
      };
    };
    systemDirs.data = [
      "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    ];
    userDirs = {
      enable = true;
      templates = "${config.home.homeDirectory}/.config/Templates";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      pictures = "${config.home.homeDirectory}/Pictures";
    };
  };
}
