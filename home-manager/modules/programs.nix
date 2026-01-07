{
  config,
  pkgs,
  lib,
  ...
}:
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
    helix = {
      enable = true;
      extraPackages = with pkgs; [
        nil
        typescript-language-server
        vscode-langservers-extracted
        markdown-oxide
      ];
      settings = {
        # theme = "jetbrains_dark";
        keys = {
          normal = {
            "C-right" = "move_next_word_start";
            "C-left" = "move_prev_word_end";
          };
          insert = {
            "C-right" = "move_next_word_start";
            "C-left" = "move_prev_word_end";
          };
        };
        editor = {
          auto-save = {
            focus-lost = true;
          };
          indent-guides = {
            render = true;
            character = "┊";
            skip-levels = 1;
          };
          line-number = "relative";
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          statusline = {
            left = [
              "mode"
              "spinner"
              "read-only-indicator"
              "file-modification-indicator"
            ];
            center = [ "file-name" ];
            right = [
              "file-type"
              "separator"
              "diagnostics"
              "position"
            ];
            mode.normal = "NORMAL";
            mode.insert = "INSERT";
            mode.select = "SELECT";
            separator = "│";
          };
        };
      };
    };
    kitty = {
      enable = true;
      shellIntegration = {
        enableZshIntegration = true;
        mode = "no-sudo";
      };
      themeFile = "Alabaster_Dark";
      settings = {
        enable_audio_bell = false;
        editor = "hx";
        confirm_os_window_close = -1;
      };
    };
    navi = {
      enable = true;
      enableZshIntegration = true;
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
          ratio = [
            1
            3
            3
          ];
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
