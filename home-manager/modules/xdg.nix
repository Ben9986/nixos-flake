{config, pkgs, lib, ...}:
{
  xdg = {
    userDirs = {
      enable = true;
      templates = "${config.home.homeDirectory}/.config/Templates";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      pictures = "${config.home.homeDirectory}/Pictures";
    };
    mimeApps.defaultApplications = {
     "text/html" = "firefox.desktop"; 
      "application/pdf" = "firefox.desktop";
    };
  };
  xdg.systemDirs.data = [
    "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  ];

  xdg.desktopEntries = {
    spotify = {
      type="Application";
      name="Spotify";
      genericName="Online music streaming service";
      comment="Access all of your favorite music";
      icon="spotify-client";
      exec="spotify --enable-features=ozone --ozone-platform=wayland";
      terminal=false;
      mimeType=[ "x-scheme-handler/spotify" ];
      categories= [ "Audio" "Music" "AudioVideo" ];
      settings = {
        X-GNOME-UsesNotifications="true";
      };
    };
    vscodium-no-gpu = lib.mkIf config.vscode.disableGpu {
      type = "Application";
      name="Vscodium - No GPU";
      categories= [ "Utility" "TextEditor" "Development" "IDE" ];
      comment="Code Editing. Redefined.";
      exec="codium --disable-gpu %F";
      genericName="Text Editor";
      icon="vscodium";
      mimeType= [ "text/plain" "inode/directory" ];
      settings = {
        Keywords="vscode";
        StartupNotify="true";
        StartupWMClass="vscodium";
      };
      actions = {
        "new-empty-window" = {
          exec="codium --disable-gpu --new-window %F";
          icon="vscodium";
          name="New Empty Window";
        };
      };
    };
};
}
