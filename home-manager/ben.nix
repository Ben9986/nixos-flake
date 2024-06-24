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

  home.file = lib.mkIf config.hyprland.enable {
    ".config/swaync".source = dotfiles/swaync;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISIAL = "nvim";
    PAGER = "less";
    PATH = "$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH";
    RANGER_LOAD_DEFAULT_RC="false";
  };
 
  services.hypridle = lib.mkIf config.hyprland.enable {
    enable = true;
    package = pkgs.hypridle;
    settings = { 
    general = {
      lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
      unlock_cmd = "";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on; ${pkgs.brightnessctl}/bin/brightnessctl -r; echo 2 | ${pkgs.coreutils}/bin/tee  /sys/class/leds/asus::kbd_backlight/brightness";
    };
    listener = [
      {
        timeout = 300;
	on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10% & echo 1 | ${pkgs.coreutils}/bin/tee  /sys/class/leds/asus::kbd_backlight/brightness";
	on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r & echo 2 | ${pkgs.coreutils}/bin/tee /sys/class/leds/asus::kbd_backlight/brightness";
      }
      {
        timeout = 320;
	on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
	on-resume = "";
      }
    ];
    };

  };

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
  
    wlogout = lib.mkIf config.hyprland.enable {
      enable = false;
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
