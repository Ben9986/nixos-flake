{ config, lib, ... }:
let
  flakeDir = config.custom.flakeDir;
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    autocd = true;
    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      size = 500;
      ignoreDups = true;
    };
    sessionVariables = {
      PATH = "$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH";
      COLOR_SCHEME = "prefer-dark";
      VISUAL = "nvim";
    };

    shellAliases = {
      hconf = lib.mkIf config.home-manager.hyprland.enable "nvim ${flakeDir}/home-manager/modules/hyprland.nix";
      hmconf = "nvim ${flakeDir}/home-manager/$USER.nix";
      hmsw = "nh home switch";
      nxsw = "nh os switch";
      cdn = "cd ${flakeDir}";
      cdhm = "cd ${flakeDir}/home-manager/";
      nconf = "nvim ${flakeDir}/hosts/configuration.nix";
      gs = "git status";
      gd = "git diff -a";
      tbxe = "toolbox enter";
      ls = "eza --icons --group-directories-first --width=80 -a";
      ll = "eza --icons --group-directories-first --width=80 --no-filesize -alo";
    };

    initContent = lib.mkMerge [ (lib.mkOrder 550 "zstyle :compinstall filename '$HOME/.zshrc' ")
(''
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
    '')];
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      directory = {
        read_only = " 󰌾";
      };
    };
  };
}
