{ inputs, config, pkgs, lib, ... }:
{
  home.username = "ben";
  home.homeDirectory = "/home/ben";
  
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
    obsidianWayland = {
      categories = [ "Office" ];
      comment = "Knowledge base";
      exec="obsidian %u --enable-features=ozone --ozone-platform=wayland";
      icon = "obsidian";
      mimeType = [ "x-scheme-handler/obsidian" ];
      name = "Obsidian - Wayland + Native Pkg";
      type = "Application";
    };
  };

  home.stateVersion = "23.05"; # Please read the comment before changing.
  
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
	cursor-theme = "phinger-cursors";
      };
    };
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        #size = "compact";
        tweaks = [ "rimless" ];
        variant = "mocha";
      };
    };
    cursorTheme = {
      name = "phinger-cursors";
     size = 24;
     package = pkgs.phinger-cursors;
    };
  };

  qt = {
    style.name = "adwaita-dark";
    platformTheme = "gnome";
  };


  home.packages = with pkgs; [
     (nerdfonts.override { fonts = [ "RobotoMono" ]; })
     roboto
     git-crypt

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

   home.activation.linkDotfiles = config.lib.dag.entryAfter [ "writeBoundary" ]
    ''
      ln -sfn /etc/nixos/home-manager/dotfiles/ranger/rc.conf         $HOME/.config/ranger/
    '';


  home.file = 
  {
    ".config/waybar".source = dotfiles/waybar;
    ".config/wofi".source = dotfiles/wofi;
    ".config/wofi-logout".source = dotfiles/wofi-logout;
    ".config/kitty".source = dotfiles/kitty;
    # dir must be writable for ranger to run
    # ".config/ranger".source = dotfiles/ranger;
   # ".config/rclone".source = dotfiles/rclone;
    ".config/swayidle".source = dotfiles/swayidle;
    ".config/swaylock".source = dotfiles/swaylock;
    ".config/swaync".source = dotfiles/swaync;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISIAL = "nvim";
    PAGER = "less";
    PATH = "$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH";
    RANGER_LOAD_DEFAULT_RC="false";
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  programs.neovim = {
      defaultEditor = true;
    };

  programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      autocd = true;
      history = {
        path = "${config.xdg.dataHome}/zsh/zsh_history";
        size = 500;
        ignoreDups = true;
      };
      localVariables = {
          PATH = "$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH";
	  GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
	  COLOR_SCHEME = "prefer-dark";
	  VISUAL = "nvim";
	};

      shellAliases = {
        hconf="nvim /etc/nixos/modules/home-manager/hyprland.nix";
        hmconf="nvim /etc/nixos/modules/home-manager/$USER.nix";
	nixdir="cd /etc/nixos";
        hmdir="cd /etc/nixos/modules/home-manager/";
	nconf="sudo nvim /etc/nixos/hosts/configuration.nix";
        tbxe="toolbox enter";
        ls="eza --icons --group-directories-first --width=80 -a";
        ll="eza --icons --group-directories-first --width=80 --no-filesize -alo";
        };
      
      initExtraBeforeCompInit = "zstyle :compinstall filename '/home/ben/.zshrc' ";

      initExtra = ''
      zstyle ':completion:*' menu select=4

      # Set prompt
      setopt PROMPT_SUBST
      PROMPT='%B%n@%m%b %~/ %# '
      
      # Bind ctrl+arrows 
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^H" backward-kill-word

      # Bind Home and End keys
      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line

      bindkey "^L" clear-screen
      
      # Ensures auto completion doesn't break shell in git repos 
      __git_files () { 
    _wanted files expl 'local files' _files     
      }
       
      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End nix

      export GPG_TTY=$(tty)
    '';
    };

    home.activation = {
      # Reload hyprland after home-manager files have been written 
      reloadHyprland = lib.hm.dag.entryAfter ["writeBoundary"] ''
        echo "Reloading Hyprland...";
        ${pkgs.hyprland}/bin/hyprctl reload > /dev/null;
        echo "Hyprland reloaded successfully";
      '';};
}
