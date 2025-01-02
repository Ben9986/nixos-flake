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
      packages = lib.mkMerge [ (with pkgs; [
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
        ghostty
        pavucontrol
        onedrivegui
        spotify
        floorp
        konsave
        (vivaldi.override { qt5 = pkgs.qt6; })
        vivaldi-ffmpeg-codecs
        libreoffice-qt6-fresh
        zotero
      ])
      (with pkgs.nerd-fonts; [
        roboto-mono
        jetbrains-mono
        space-mono
        ubuntu
      ])
      ];

      file = {
        ".config/onedrive-launcher".text = ''onedrive onedrive-strath'';
        ".config/onedrive/config".text = ''sync_dir = "/home/ben/OneDrive-Personal"'';
        ".config/onedrive-strath/config".text = 
        ''
        sync_dir = "/home/ben/OneDrive-Strathclyde"
        sync_root_files = "true"
        sync_business_shared_items = "true"
        '';
        ".config/onedrive-strath/sync_list".text = 
        ''
        !/Pictures/
        !/Ben @ University of Strathclyde/
        !dp0/
        !*.mechdb

        /Attachments/
        /Desktop/
        /Documents/
        /folder_BC/
        /Obsidian Vaults/
        /Tethers_publications/
        /Y4 Project/
        '';
      };
    };
    nixpkgs.config.allowUnfree = true;

    programs.home-manager.enable = true;
  };
}
