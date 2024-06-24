{ inputs, config, pkgs, lib, ... }:
{

  imports = [ 
    inputs.ags.homeManagerModules.default
    ];

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
      neovim
      wget
      rclone
      libnotify
      cantarell-fonts
      roboto
      git-crypt
      pavucontrol
      vscodium-fhs
    ];
    
  };
  nixpkgs.config.allowUnfree = true;

  services.easyeffects.enable = true;

  programs = {
    ags = lib.mkIf config.ags.enable {
      enable = true;
      configDir = ./dotfiles/ags;
      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
      ];
    };
    home-manager.enable = true;
  };
}
