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
    ];
    
  };
  nixpkgs.config.allowUnfree = true;

  services.easyeffects.enable = true;

  programs.home-manager.enable = true;
}
