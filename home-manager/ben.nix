{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  options.home-manager.plasma.enable = lib.mkEnableOption "Plasma Desktop Sessions Packages";
  config = {
    home-manager = {
      hyprland.enable = true;
      plasma.enable = true;
    };

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
        NIXOS_OZONE_WL = "1";
      };
      packages = lib.mkMerge [
        (with pkgs; [    
          phinger-cursors
          neovim
          libnotify
          cantarell-fonts
          roboto
          git-crypt
          pavucontrol
          onedrivegui
          obsidian
          poppler-utils
          spotify
          konsave
          tesseract
          vivaldi
          vivaldi-ffmpeg-codecs
          libreoffice-qt6-fresh
          zotero
        ])
        (with pkgs.nerd-fonts; [
          roboto-mono
          jetbrains-mono
          space-mono
          ubuntu
          symbols-only
        ])
        (lib.mkIf config.home-manager.plasma.enable [
          pkgs.kdePackages.krohnkite
          pkgs.kdePackages.yakuake
          (pkgs.callPackage ../pkgs/klassy.nix { })

      ])
      ];

      file = {
        ".config/onedrive-launcher".text = ''onedrive onedrive-strath'';
        ".config/onedrive/config".text = ''sync_dir = "/home/ben/OneDrive-Personal"'';
        ".config/onedrive-strath/config".text = ''
          sync_dir = "/home/ben/OneDrive-Strathclyde"
          sync_root_files = "true"
          sync_business_shared_items = "true"
        '';
        ".config/onedrive-strath/sync_list".text = ''
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

    programs.git = {
      enable = true;
      userName = "ben9986";
      userEmail = "38633150+Ben9986@users.noreply.github.com";
      signing = {
        format = "openpgp";
        key = "ABBCDD7769BCD3B0";
        signByDefault = true;
      };
    };
  };
}
