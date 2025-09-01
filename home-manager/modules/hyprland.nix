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
      # Core utilities & tools
      bc # floating point math in kbbrightnessn.sh
      cargo
      copyq
      eza
      fastfetch
      fd
      figlet
      fzf
      gum
      jq
      rustc
      wget
      xclip
      zsh

      # Fonts & theming
      fira
      fira-sans
      nerd-fonts.fira-mono
      noto-fonts
      noto-fonts-emoji
      noto-fonts-extra
      papirus-icon-theme
      rose-pine-cursor
      rose-pine-hyprcursor
      # Look & feel
      nwg-displays
      nwg-look
      pywal

      # GTK / Qt / KDE packages
      gtk4
      kdePackages.breeze
      kdePackages.kdeclarative
      kdePackages.knewstuff # theming from kde settings
      kdePackages.qtwayland
      kdePackages.xdg-desktop-portal-kde
      libadwaita
      libsForQt5.qt5.qtwayland
      qt6ct
      xdg-desktop-portal-gtk

      # Hyprland ecosystem
      hypridle
      patchedhyprshot
      rofi-wayland
      waybar
      wleave

      # Notifications & clipboard
      cliphist
      dunst
      libnotify
      swaynotificationcenter
      wl-clipboard

      # Networking & devices
      blueman
      blueberry
      gvfs
      networkmanager
      networkmanagerapplet
      udiskie

      # Python packages
      python313Packages.pip
      python313Packages.pygobject3

      # Graphics, images & thumbnails
      grim
      imagemagick # needed for kitty image previews
      slurp
      xfce.tumbler # dbus thumbnail interface

      # Misc
      pavucontrol

    ];
    file = {
      ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/flake-config/home-manager/dotfiles/waybar"; 
      ".config/swaync".source = ../dotfiles/swaync-ml4w;
      ".cache/wal".source = ../cache/wal;
      ".config/wleave/style.css".text = with config.lib.stylix.colors.withHashtag; ''
        @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
        @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};

        @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
        @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};

        * {
          font-family: "${config.stylix.fonts.monospace.name}";
          font-size: ${builtins.toString config.stylix.fonts.sizes.desktop}pt;
          background-image: none;
        }

        window {
          background-color: alpha(@base00, 0.5);
        }

        button {
          color: @base05;
          font-size: 16px;
          background-color: @base01;
          border-style: none;
          background-repeat: no-repeat;
          background-position: 50% 40%;
          background-size: 50%;
          border-radius:30px;
          margin: 10px 5px;
          text-shadow: 0px 0px;
          box-shadow: 0px 0px;
        }

        button:focus, button:active, button:hover {
          background-color: @base02;
          outline-style: none;
        }

        #lock {
          background-image: url("${pkgs.wleave}/share/wleave/icons/lock.svg");
        }
        #logout {
          background-image: url("${pkgs.wleave}/share/wleave/icons/logout.svg");
          background-position: 54% 40%;
        }
        #suspend {
          background-image: url("${pkgs.wleave}/share/wleave/icons/suspend.svg");
        }
        #hibernate {
          background-image: url("${pkgs.wleave}/share/wleave/icons/hibernate.svg");
        }
        #shutdown {
          background-image: url("${pkgs.wleave}/share/wleave/icons/shutdown.svg");
        }
        #reboot {
          background-image: url("${pkgs.wleave}/share/wleave/icons/reboot.svg");
        }
      '';
      ".config/wleave/layout".text = ''
          {"action":"hyprlock","keybind":"l","label":"lock","text":"Lock"}                              
          {"action":"hyprctl dispatch exit","keybind":"e","label":"logout","text":"Logout"}
          {"action":"systemctl suspend","keybind":"s","label":"suspend","text":"Sleep"}  
          {"action":"systemctl hibernate","keybind":"s","label":"hibernate","text":"Hibernate"}  
          {"action":"systemctl poweroff","keybind":"s","label":"shutdown","text":"Shutdown"}            
          {"action":"systemctl reboot","keybind":"r","label":"reboot","text":"Reboot"}                  
      '';
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
      reloadWaybar = lib.hm.dag.entryAfter [ "reloadHyprlandConfig" ] ''
        ${pkgs.procps}/bin/pkill -SIGUSR2 waybar
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

  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde pkgs.xdg-desktop-portal-gtk ];
    };
    configFile."xdg-desktop-portal/portals.conf" = {
      text = ''
          [preferred]
          default = hyprland;kde;gtk
          org.freedesktop.impl.portal.FileChooser = kde
        '';
    };
  };

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
        "QT_QPA_PLATFORMTHEME,kde"
        "XCURSOR_THEME,rose-pine-hyprcursor"
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        "XDG_SESSION_TYPE,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "VISUAL,hx"
        "EDITOR,hx"
      ];

      exec-once = [
        "waybar -c ~/.config/waybar/themes/ml4w-modern/config -s ~/.config/waybar/themes/ml4w-modern/black/style.css"
        "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init"
        "systemctl --user start hyprpolkitagent"
        "nm-applet --indicator"
        "blueberry-tray"
        "hyprctl dispatch exec [ workspace special:fm silent ] kitty yazi"
        "udiskie &"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "hyprctl setcursor rose-pine-hyprcursor 24"
        "matcha -do"
        "swayosd-server"
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
        hover_icon_on_border = true;
      };

      decoration = {
        rounding = 8;
        inactive_opacity = 0.99;
        active_opacity = 1.0;
        fullscreen_opacity = 1.0;
        dim_around = 0.2;
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
       ];
       };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
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
      };

      workspace = [
        "w[t1], gapsout:0, gapsin:0"
        "w[tg1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];

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

      layerrule = [
        "ignorealpha 1, swaync-control-center"
      ];

      windowrule = [
        # replacement for no_gaps_when_only
        "bordersize 0, floating:0, onworkspace:w[t1]"
        "rounding 0, floating:0, onworkspace:w[t1]"
        "bordersize 0, floating:0, onworkspace:w[tg1]"
        "rounding 0, floating:0, onworkspace:w[tg1]"
        "bordersize 0, floating:0, onworkspace:f[1]"
        "rounding 0, floating:0, onworkspace:f[1]"


        "float,class:(com.ml4w.sidebar)"
        "move 100%-w-16 66,class:(com.ml4w.sidebar)"
        "pin, class:(com.ml4w.sidebar)"
        "size 400 740,class:(com.ml4w.sidebar)"

        "float, class:^(blueberry.py)$"
        "size 390 375, class:^(blueberry.py)$"
        "move onscreen cursor 5% 5%, class:^(blueberry.py)$"
        "noanim, class:^(blueberry.py)$"
        "stayfocused, class:^(blueberry.py)$"
        "opacity 1.0, class:^(blueberry.py)$"
        "dimaround 1, class:^(blueberry.py)$"

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
        "stayfocused, class:^(xdg-desktop-portal-gtk)"
        "size 50% 60%, class:^(org.freedesktop.impl.portal.desktop.kde)"
        "float, class:^(org.freedesktop.impl.portal.desktop.kde)"
        "stayfocused, class:^(org.freedesktop.impl.portal.desktop.kde)"

        "stayfocused, class:^(org.gnupg.pinentry-qt)" # vscode commit sign pass popup

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

        "$mainMod ALT, M, exec, wleave -b 3 -T 415 -B 340 -R 540 -L 540 -p layer-shell"
        "$mainMod ALT, R, exec, pkill -SIGUSR2 waybar"

        # Session Control
        "$mainMod ALT, P, exec, ~/.config/ml4w/scripts/wlogout.sh"
        "$mainMod, L, exec, loginctl lock-session"
        "$mainMod, I, exec, matcha -t && notify-send 'Toggled Idle Inhibitor'"

        # App Launch Shortcuts
        "$mainMod, Q, exec, kitty"
        "$mainMod, F, exec, vivaldi --ozone-platform=wayland --password-store=kwallet6"
        "$mainMod, E, exec, dolphin"
        "$mainMod, V, exec, ~/.config/ml4w/scripts/cliphist.sh"
        "$mainMod, N, exec, swaync-client -t -sw"
        "$mainMod, O, exec, obsidian -- obsidian://open?vault=Uni%20Vault"
        "$mainMod SHIFT, O, exec, obsidian -- obsidian://open?vault=Life%20Tings"
        "$mainMod, T, exec, io.github.alainm23.planify.quick-add"
        "$mainMod, D, exec, flatpak run dev.vencord.Vesktop"

        #F-keys shortcuts
        ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
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
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness +10"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness -10"

      ];
      bindn = [
        ", kbbrightcycle, exec, ~/.config/hypr/scripts/kbbrightness.sh"
        ", XF86KbdBrightcycle, exec, ~/.config/hypr/scripts/kbbrightness.sh"
      ];
    };
  };
}
