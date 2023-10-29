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
    };
  };
  xdg.systemDirs.data = [
    "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  ];

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
  Unit = {
    Description = "Gnome Polkit authentication agent";
    Documentation = "https://gitlab.freedesktop.org/polkit/polkit/";
    After = [ "graphical-session-pre.target" ];
    PartOf = [ "graphical-session.target" ];
  };

  Service = {
    ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    Restart = "always";
    BusName = "org.freedesktop.PolicyKit1.Authority";
  };

  Install.WantedBy = [ "graphical-session.target" ];
};

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
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

#  home.pointerCursor = {
#      name = "Phinger Cursors";
#      package = pkgs.phinger-cursors;
#      size = 24;
#      x11 = {
#        enable = true;
#        defaultCursor = "Phinger Cursors";
#      };
#    };

  home.packages = with pkgs; [
     (nerdfonts.override { fonts = [ "RobotoMono" ]; })
     roboto
    # only in unstable at: mpkgs.eza
     git-crypt

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {
    ".config/waybar".source = dotfiles/.config/waybar;
    ".config/wofi".source = dotfiles/.config/wofi;
    ".config/wofi-logout".source = dotfiles/.config/wofi-logout;
    ".config/kitty".source = dotfiles/.config/kitty;
    ".config/hypr".source = dotfiles/.config/hypr;
#    ".config/nvim".source = fetchgit {
#	url = "https://github.com/NvChad/NvChad.git";
#	deepClone = true;
#	fetchSubmodules = true;
#	rev = "v2.0";
#	sha256 = "67c520c402af0b6e44593fba53713c46340814dada0ea9470937228edff6d7dd";
#    };
    
    # dir must be writable for ranger to run
    # ".config/ranger".source = dotfiles/.config/ranger;
   # ".config/rclone".source = dotfiles/.config/rclone;
    ".config/swayidle".source = dotfiles/.config/swayidle;
    ".config/swaylock".source = dotfiles/.config/swaylock;
    ".config/swaync".source = dotfiles/.config/swaync;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # or
  #  /etc/profiles/per-user/ben/etc/profile.d/hm-session-vars.sh
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
    VISIAL = "nvim";
    PAGER = "less";
    PATH = "$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH";
    RANGER_LOAD_DEFAULT_RC="false";
    HMDOTS = "$HOME/.config/home-manager/dotfiles";
    # XDG_DATA_DIRS="$XDG_DATA_DIRS;${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}";
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
	};

      shellAliases = {
        hconf="nvim /etc/nixos/home-manager/dotfiles/.config/hypr/hyprland.conf";
        hmconf="nvim /etc/nixos/home-manager/$USER.nix";
        hmdir="cd /etc/nixos/home-manager/";
        tbxe="toolbox enter";
        ls="eza --icons --group-directories-first --width=80 -a";
        ll="eza --icons --group-directories-first --width=80 --no-filesize -alo";
        };
      
      initExtraBeforeCompInit = "zstyle :compinstall filename '/var/home/ben/.zshrc' ";

      initExtra = ''
      zstyle ':completion:*' menu select=4

      # Set prompt
      setopt PROMPT_SUBST
      PROMPT='%B%n@%m%b %~/ %# '
      
      # Bind ctrl+arrows 
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word

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
        # change to $\{pkgs.hyprland}/bin/hyprctl ? for nixos 
        ${pkgs.hyprland}/bin/hyprctl reload > /dev/null;
        echo "Hyprland reloaded successfully";
      '';};
}
