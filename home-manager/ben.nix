{ inputs, config, pkgs, lib, ... }:
{

  imports = [ 
    inputs.ags.homeManagerModules.default
    ];

  home.username = "ben";
  home.homeDirectory = "/home/ben";
  home.stateVersion = "23.05"; # Please read the comment before changing.
  home.packages = with pkgs; [
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

    neovim = {
      defaultEditor = true;
      plugins = [
        pkgs.vimPlugins.yuck-vim
      ];
    };
  
    kitty = {
      enable = true;
      theme = "Cherry Midnight";
      settings = {
        enable_audio_bell = false;
        editor = "nvim";
        confirm_os_window_close = -1;
        shell_integration = true;
      };
    };
  
    yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        manager = {
	        ratio = [1 3 3];
	        show_hidden = true;
	        show_simlink = true;
	        sort_by = "natural";
	        sort_dir_first = true;
        };
      };
    };
  
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    home-manager.enable = true;
  };
  home.activation = lib.mkIf config.hyprland.enable {
    # Reload hyprland after home-manager files have been written 
    reloadHyprland = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Reloading Hyprland...";
    ${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl reload > /dev/null;
    echo "Hyprland reloaded successfully";
  '';
  };
}
