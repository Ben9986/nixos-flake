{ inputs, config, pkgs, lib, ... }:
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
        EDITOR = "nvim";
        VISIAL = "nvim";
        PAGER = "less";
        PATH = "$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH";
        RANGER_LOAD_DEFAULT_RC="false";
      };
      packages = with pkgs; [
        (nerdfonts.override { fonts = [ "RobotoMono" "JetBrainsMono" "SpaceMono" "Ubuntu"]; })
        phinger-cursors
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
      ];
      
    };
    nixpkgs.config.allowUnfree = true;

    programs.home-manager.enable = true;
  };
}
