{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  hyprenable = config.custom.hyprland.enable;
  patchedhyprshot =
    (pkgs.hyprshot.overrideAttrs (old: rec {
      version = "git";
      src = pkgs.fetchFromGitHub {
        owner = "Gustash";
        repo = "hyprshot";
        rev = "36dbe2e6e97fb96bf524193bf91f3d172e9011a5";
        hash = "sha256-n1hDJ4Bi0zBI/Gp8iP9w9rt1nbGSayZ4V75CxOzSfFg=";
      };
      patches = [
        (pkgs.fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/Gustash/Hyprshot/pull/39.patch";
          hash = "sha256-kNo+s6NfeuoVsAtcHcecWo3LbX9ac8EOOqYdFjQNyHQ=";
        })
        (pkgs.fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/Gustash/Hyprshot/pull/47.patch";
          hash = "sha256-NkyAv7MPr0C+CvmBi1ECZcPkbl8qK99qKDMNOP+VZkY=";
        })
      ];

    })).override
      { hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland; };
in
{

  home = lib.mkIf hyprenable {
    packages = with pkgs; [
      hyprpaper
      patchedhyprshot
      nwg-displays
      gnome-control-center
      file-roller
      copyq
      udiskie
      ### end-4 ags config ####
      # adw-gtk3
      # ydotool
      # sassc
      # qt5ct
      # gradience
      # lexend
      # material-symbols
      #########
      ### current ags bar ##
      bun
      dart-sass
      fd
      matugen
      ####
      #ml4w
      wget
      nwg-dock-hyprland
      waybar
      font-awesome
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-extra
      libnotify
      libsForQt5.qt5.qtwayland
      kdePackages.qtwayland
      uwsm
      fastfetch
      xdg-desktop-portal-gtk
      eza
      python313Packages.pip
      python313Packages.pygobject3
      xfce.tumbler
      brightnessctl
      networkmanagerapplet
      networkmanager
      gtk4
      libadwaita
      fuse2
      # imageMagick
      jq
      xclip
      rustc
      cargo
      pinta
      blueman
      grim
      slurp
      cliphist
      nwg-look
      qt6ct
      rofi-wayland
      zsh
      fzf
      pavucontrol
      papirus-icon-theme
      # papirus-icon-theme-dark
      kdePackages.breeze
      flatpak
      swaynotificationcenter
      gvfs
      wlogout
      hyprshade
      pinta
      bibata-cursors
      fira-sans
      fira
      nwg-dock-hyprland 
      pywal
      wlogout
      dunst
      hypridle
      hyprpaper
      gum
      ags
      figlet
      waypaper
    ];
    file = {
      ".config/waybar".source = ../dotfiles/waybar; 
      ".config/swaync".source = ../dotfiles/swaync-ml4w;
    };
    activation = {
      # Reload hyprland after home-manager files have been written
      reloadHyprlandConfig = lib.hm.dag.entryAfter [ "linkML4WSettings" ] ''
        verboseEcho "Reloading Hyprland config..."
        if run ${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl reload > /dev/null; then
          verboseEcho "Hyprland reloaded successfully"
        else
          verboseEcho "Hyprland Reload Failed"
        fi
      '';

      linkML4WSettings = lib.hm.dag.entryAfter [ "writeBoundary" ]  ''
        if [ ! -h $HOME/.config/ml4w ]; then
          verboseEcho "ML4W config files not present, creating symbolic link..."
          if run ln -s $HOME/flake-config/home-manager/dotfiles/ml4w $HOME/.config/ml4w; then 
            verboseEcho "Linking Sucessful"
            else
            verboseEcho "Linking Failed. Link/copy manually to ensure complete functionality"
          fi
          else
            verboseEcho "ML4W config files already present, skipping linking"
        fi
      '';
    };
  };
  # programs.ags = lib.mkIf config.custom.hyprland.enable {
  #   enable = true;
  #   configDir = ../dotfiles/ags;
  #   # additional packages to add to gjs's runtime
  #   extraPackages = with pkgs; [
  #     gtksourceview
  #     webkitgtk
  #     accountsservice
  #   ];
  # };

  wayland.windowManager.hyprland = lib.mkIf hyprenable {
    enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    settings = {
      env = [
        "XCURSOR_SIZE,24"
        "GDK_BACKEND,wayland,x11"
        "QT_QPA_PLATFORM,wayland"
        "COLOR_SCHEME,prefer-dark"
        # "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        # "QT_QPA_PLATFORMTHEME,kvantum"
        "QT_QPA_PLATFORMTHEME,kde"
        "XCURSOR_THEME,phinger-cursors"
        "XDG_SESSION_TYPE,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "VISUAL,hx"
        "EDITOR,hx"
      ];
      exec = [
        "hyprpaper"
        "notify-send 'help'"
        # "ags -q && ags"
      ];

      exec-once = [
        "waybar -c ~/.config/waybar/themes/ml4w-modern/config -s ~/.config/waybar/themes/ml4w-modern/white/style.css"
        "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init"
        "systemctl --user start hyprpolkitagent"
        # "~/.config/nwg-dock-hyprland/launch.sh"
        # "kstart plasmashell"
        "nm-applet --indicator"
        # "swaync"
        # "blueberry-tray"
        "hyprctl dispatch exec [ workspace special:fm silent ] kitty yazi"
        "udiskie &"
        # "copyq"
        "wl-paste --watch cliphist store"
        " hyprctl setcursor phinger-cursors 24"
        "matcha -do"
        # "ags -q && ags"
      ];

      input = {
        kb_layout = "gb";
        numlock_by_default = true;
        follow_mouse = 1;

        touchpad = {
          natural_scroll = 0;
        };
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      general = {
        gaps_in = 4;
        gaps_out = 3;
        border_size = 2;
        "col.active_border" = "rgba(ffffffff)";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding = 8;
        inactive_opacity = 0.99;
        active_opacity = 1.0;
        fullscreen_opacity = 1.0;
        blur = {
          enabled = true;
          size = 6;
          passes = 1;
        };
        shadow = {
        enabled = true;
        range = 30;
        render_power = 3;
        color = "0x66000000";
      };
      };

      

      animations = {
        enabled = true;

      bezier = [
        "myBezier, 0.05, 0.9, 0.1, 1.05"
        "newBezier, .54,.38,.22,1.01"
        "wind, 0.05, 0.9, 0.1, 1.05"
        "winIn, 0.1, 1.1, 0.1, 1.1"
        "winOut, 0.3, -0.3, 0, 1"
        "liner, 1, 1, 1, 1"
      ];
      animation = [
        "windows, 1, 6, wind, slide"
       "windowsIn, 1, 6, winIn, slide"
       "windowsOut, 1, 5, winOut, slide"
       "windowsMove, 1, 5, wind, slide"
       "border, 1, 1, liner"
       "borderangle, 1, 30, liner, loop"
       "fade, 1, 10, default"
       "workspaces, 1, 5, wind"
    #       "windows, 1, 7, myBezier"
    #       "windowsOut, 1, 7, default, popin 40%"
    #       "border, 1, 10, default"
    #       "borderangle, 1, 8, default"
    #       "fade, 1, 7, default"
    #       "workspaces, 1, 2, newBezier"
         ];
       };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
        # no_gaps_when_only = true;
        special_scale_factor = 0.95;
      };

      gestures = {
        "workspace_swipe" = true;
        "workspace_swipe_invert" = false;
        "workspace_swipe_distance" = 350;
        "workspace_swipe_min_speed_to_force" = 20;
        "workspace_swipe_cancel_ratio" = 0.2;
        "workspace_swipe_forever" = true;
        "workspace_swipe_create_new" = true;
        "workspace_swipe_fingers" = 3;
      };

      binds = {
        workspace_back_and_forth = true;
        allow_workspace_cycles = true;
        # pass_mouse_when_bound = false;
      };

      misc = {
        vrr = 1;
        "key_press_enables_dpms" = true;
        "enable_swallow" = true;
        "swallow_regex" = "^(kitty)|()$";
        "swallow_exception_regex" = "^(firefox)|(nemo)$";
        "focus_on_activate" = true;
        "disable_hyprland_logo" = true;
        "force_default_wallpaper" = false;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      windowrule = [
        # "float, class:org.kde.plasmashell"
        # "move onscreen cursor 1% 1%, class:org.kde.plasmashell"
        # "noanim, class:org.kde.plasmashell"

        "float,class:(com.ml4w.sidebar)"
        "move 100%-w-16 66,class:(com.ml4w.sidebar)"
        "pin, class:(com.ml4w.sidebar)"
        "size 400 740,class:(com.ml4w.sidebar)"

        "float, class:^(blueberry.py)$"
        "size 350 265, class:^(blueberry.py)$"
        "move onscreen cursor 70% 5%, class:^(blueberry.py)$"
        "noanim, class:^(blueberry.py)$"

        "float, class:^(peazip)$"

        "float, class:^(nemo)$"

        "noblur, class:^(nemo)$"
        "noblur, class:^(com.obsproject.Studio)$"
        "opaque, class:^(com.obsproject.Studio)$"
        "opaque, class:^(io.github.alainm23.planify)$"
        "noblur, class:^(io.github.alainm23.planify)$"

        "noborder, class:^(wofi)$"
        "noanim, class:^(wlogout)$"
        "float, class:^(wlogout)$"
        "fullscreen, class:^(wlogout)$"
        "opacity 0.8 override 0.8 override, class:^(kitty)$"
        "float, class:^(com.github.hluk.copyq)"
        "size 40% 60%, class:^(com.github.hluk.copyq)"
        "center, class:^(com.github.hluk.copyq)"
        "tile, class:^(ONLYOFFICE Desktop Editors)"
        "float, class:^(xdg-desktop-portal-gtk)"
        "size 50% 60%, class:^(xdg-desktop-portal-gtk)"

        "size 600 600, title:(.*)(Bitwarden)$"
      ];

      "$mainMod" = "SUPER";

      bind = [

       # General Window Control
        "$mainMod, C, killactive"
        "$mainMod, P, togglefloating"
        "$mainMod, B, pin, active"
        "$mainMod, J, togglesplit" # dwindle
        "$mainMod SHIFT, F, fullscreen, 1" # maximise
        "$mainMod CTRL, F, fullscreenstate, 2 0" # window thinks it's fullscreen
        "$mainMod ALT, F, fullscreen, 0" # actual fullscreen

        "$mainMod, K, togglegroup"
        "$mainMod, M, changegroupactive"

        "$mainMod ALT, M, exec, ~/.config/hypr/scripts/monitor-switch.sh"

        # Session Control
        # "$mainMod ALT, P, exec, ${
        #   inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.default
        # }/bin/ags -t powermenu"
        "$mainMod ALT, P, exit"
        "$mainMod, L, exec, loginctl lock-session"
        "$mainMod, I, exec, matcha -t && notify-send 'Toggled Idle Inhibitor'"

        # App Launch Shortcuts
        "$mainMod, Q, exec, kitty"
        "$mainMod, F, exec, vivaldi --ozone-platform=wayland --password-store=kwallet6"
        "$mainMod, E, exec, dolphin"
         "SUPER, V, exec, copyq toggle"
          "$mainMod, V, exec, ~/.config/ml4w/scripts/cliphist.sh"
        "$mainMod, N, exec, swaync-client -t -sw"
        "$mainMod, O, exec, flatpak run --user md.obsidian.Obsidian -- obsidian://open?vault=Uni%20Vault"
        "$mainMod SHIFT, O, exec, flatpak run --user md.obsidian.Obsidian -- obsidian://open?vault=Life%20Tings"
        "$mainMod, T, exec, io.github.alainm23.planify.quick-add"
        "$mainMod, D, exec, flatpak run dev.vencord.Vesktop"

        #F-keys shortcuts
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", kbbrightcycle, exec, ~/.config/hypr/scripts/kbbacklight.sh"
        # kill in the bind below doesn't work :/
        "$mainMod SHIFT, S, exec, kill -9 $(pidof hyprshot) || XCURSOR_SIZE=32 HYPRSHOT_DIR=$HOME/Pictures/Screenshots ${patchedhyprshot}/bin/hyprshot -m region --move-cursor 0,0"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Move windows with SUPER + ALT + arrow keys
        "$mainMod ALT, left, swapwindow, l"
        "$mainMod ALT, right, swapwindow, r"
        "$mainMod ALT, up, swapwindow, u"
        "$mainMod ALT, down, swapwindow, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, W, togglespecialworkspace, fm"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, W, movetoworkspace, special:fm"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Open numbered special workspaces
        "ALT, 1, togglespecialworkspace, 1"
        "ALT, 2, togglespecialworkspace, 2"
        "ALT, 3, togglespecialworkspace, 3"
        "ALT, 4, togglespecialworkspace, 4"
        "ALT, 5, togglespecialworkspace, 5"

        # Move active window to numbered special workspace
        "ALT SHIFT, 1, movetoworkspace, special:1"
        "ALT SHIFT, 2, movetoworkspace, special:2"
        "ALT SHIFT, 3, movetoworkspace, special:3"
        "ALT SHIFT, 4, movetoworkspace, special:4"
        "ALT SHIFT, 5, movetoworkspace, special:5"
      ];
      bindr = [
        "SUPER, SUPER_L , exec, pkill fuzzel || fuzzel --fuzzy-min-length=4"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow" # LMB
        "$mainMod, mouse:274, resizewindow" # RMB
      ];
      binde = [
        ", XF86AudioLowerVolume, exec, ags -r \"indicator.popup(1)\"; wpctl set-volume -l 1.25 @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioRaiseVolume, exec, ags -r \"indicator.popup(1)\"; wpctl set-volume -l 1.25 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86MonBrightnessUp, exec, brightnessctl --min-value=20 s 40+"
        ", XF86MonBrightnessDown, exec, brightnessctl --min-value=20 s 40-"

      ];
    };
  };
}
