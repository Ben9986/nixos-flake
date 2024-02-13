{config, ...}:
{
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
      sessionVariables = {
          PATH = "$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH";
          GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
          COLOR_SCHEME = "prefer-dark";
          VISUAL = "nvim";
        };

      shellAliases = {
        hconf="nvim /etc/nixos/home-manager/modules/hyprland.nix";
        hmconf="nvim /etc/nixos/home-manager/$USER.nix";
        nixdir="cd /etc/nixos";
        hmdir="cd /etc/nixos/home-manager/";
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
}
