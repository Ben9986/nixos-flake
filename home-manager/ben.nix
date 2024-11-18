{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{

  imports = [
    inputs.ags.homeManagerModules.default
  ];
  config = {
    custom.hyprland.enable = false;

    home = {
      username = "ben";
      homeDirectory = "/home/ben";
      stateVersion = "23.05"; # Please read the comment before changing.

      sessionVariables = {
        EDITOR = "hx";
        VISIAL = "hx";
        PAGER = "less";
        PATH = "$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH";
        RANGER_LOAD_DEFAULT_RC = "false";
      };
      packages = with pkgs; [
        (nerdfonts.override {
          fonts = [
            "RobotoMono"
            "JetBrainsMono"
            "SpaceMono"
            "Ubuntu"
          ];
        })
        (callPackage ../pkgs/klassy.nix { })
        kdePackages.krohnkite
        phinger-cursors
        tela-circle-icon-theme
        neovim
        wget
        rclone
        libnotify
        cantarell-fonts
        roboto
        git-crypt
        pavucontrol
        spotify
        floorp
        konsave
        (vivaldi.override { qt5 = pkgs.qt6; })
        vivaldi-ffmpeg-codecs
        libreoffice-qt6-fresh
      ];

    };
    nixpkgs.config.allowUnfree = true;

    programs.home-manager.enable = true;
  };
}
