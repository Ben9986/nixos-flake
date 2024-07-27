{config, pkgs, lib, ...}:
{
programs = {
  btop.enable = true;
  direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  eza = {
    enable = true;
    enableZshIntegration = true;
  };
  firefox.enable = false;
  gh.enable = true;
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
  neovim = {
    defaultEditor = true;
    plugins = [
      pkgs.vimPlugins.yuck-vim
    ];
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
};

}
