{ inputs, config, pkgs, lib, ... }:
{
  home.username = "ben";
  home.homeDirectory = "/home/ben";
  home.stateVersion = "23.05"; # Please read the comment before changing.
  home.packages = with pkgs; [
     (nerdfonts.override { fonts = [ "RobotoMono" ]; })
     roboto
     git-crypt

    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
  programs.home-manager.enable = true;

  home.activation.linkDotfiles = config.lib.dag.entryAfter [ "writeBoundary" ]
    ''
      ln -sfn /etc/nixos/home-manager/dotfiles/ranger/rc.conf         $HOME/.config/ranger/
    '';
  home.file = {
    ".config/wofi-logout".source = dotfiles/wofi-logout;
    # dir must be writable for ranger to run
    # ".config/ranger".source = dotfiles/ranger;
   # ".config/rclone".source = dotfiles/rclone;
    ".config/swaync".source = dotfiles/swaync;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISIAL = "nvim";
    PAGER = "less";
    PATH = "$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH";
    RANGER_LOAD_DEFAULT_RC="false";
  };
  
  programs.neovim = {
      defaultEditor = true;
      plugins = [
        pkgs.vimPlugins.yuck-vim
      ];
    };
  programs.eww ={
    enable = true;
    configDir = ./dotfiles/eww;
    package = pkgs.eww-wayland;
  };

  programs.kitty = {
    enable = true;
    theme = "Cherry Midnight";
    settings = {
      enable_audio_bell = false;
      editor = "nvim";
      confirm_os_window_close = -1;
      shell_integration = true;
    };
  };

  programs.wlogout = {
    enable = true;

  };

  home.activation = {
    # Reload hyprland after home-manager files have been written 
    reloadHyprland = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "Reloading Hyprland...";
      ${pkgs.hyprland}/bin/hyprctl reload > /dev/null;
      echo "Hyprland reloaded successfully";
    '';};
}
