{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.home-manager.hyprland;
  # hyprlandPackages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  hyprlandPackages = pkgs;
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
      { hyprland = hyprlandPackages.hyprland; };
in
{
  options.home-manager.hyprland = {
    enable = mkEnableOption "Hyprland home manager config";
  };

  config = mkIf cfg.enable {
    home = {
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
        noto-fonts-color-emoji
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
        qt6Packages.qt6ct
        xdg-desktop-portal-gtk
        kdePackages.plasma-integration # needed for dolphin theming without kde installed

        # Hyprland ecosystem
        hypridle
        patchedhyprshot
        rofi
        waybar

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
        tumbler # dbus thumbnail interface

        # Misc
        pavucontrol

      ];
      file = {
        ".config/waybar".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/flake-config/home-manager/dotfiles/waybar";
        ".config/swaync".source = ../dotfiles/swaync-ml4w;
        ".cache/wal".source = ../cache/wal;
        ".config/rofi/rofi-clipboard.rasi".source = ../dotfiles/rofi/rofi-clipboard.rasi;
        ".config/kdeglobals".source = ../dotfiles/kdeglobals; # allows opening files in terminal apps without konsole, among other things
      };
      activation = {
        # Reload hyprland after home-manager files have been written
        reloadHyprlandConfig = lib.hm.dag.entryAfter [ "linkML4WSettings" ] ''
          verboseEcho "Reloading Hyprland config..."
          if run ${hyprlandPackages.hyprland}/bin/hyprctl reload > /dev/null; then
            verboseEcho "Hyprland reloaded successfully"
          else
            verboseEcho "Hyprland Reload Failed"
          fi
        '';
        reloadWaybar = lib.hm.dag.entryAfter [ "reloadHyprlandConfig" ] ''
          ${pkgs.procps}/bin/pkill -SIGUSR2 waybar
        '';

        linkML4WSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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

    

    # xdg = {
    #   portal = {
    #     enable = lib.mkForce true; # conflicts with setting hyprland portalPackage below
    #     configPackages = with pkgs; [ kdePackages.xdg-desktop-portal-kde inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland xdg-desktop-portal-gtk ];
    #     config = {
    #       common = {
    #         default = [
    #           "hyprland"
    #           "kde"
    #           "gtk"
    #         ];
    #       };
    #       Hyprland = {
    #         "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
    #       };
    #     };
    #     # enable = true;
    #     extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland ];
    #   };
    # configFile."xdg-desktop-portal/portals.conf" = {
    #   text = ''
    #       [preferred]
    #       default = hyprland;kde;gtk
    #       org.freedesktop.impl.portal.FileChooser = kde
    #     '';
    # };
    # };

    wayland.windowManager.hyprland = {
      enable = true;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
      # ensures pkg used in nixos module & hm is the same
      package = hyprlandPackages.hyprland;
      portalPackage = hyprlandPackages.xdg-desktop-portal-hyprland;
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
          "XDG_MENU_PREFIX,plasma-" # required for dolphin to read installed apps to "open with.."
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
          "hyprctl dispatch exec [ workspace special:term silent ] kitty"
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
          gaps_workspaces = 2;
          border_size = 2;
          "col.active_border" = "rgba(ffffffff)";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
          resize_on_border = true;
          extend_border_grab_area = 20;
          hover_icon_on_border = true;
        };

        decoration = {
          rounding = 8;
          inactive_opacity = 0.99;
          active_opacity = 1.0;
          fullscreen_opacity = 1.0;
          dim_around = 0.3;
          blur = {
            enabled = true;
            size = 3;
            passes = 2;
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
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
            "easeOutExpo, 0.16, 1, 0.3, 1"
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
            "specialWorkspaceIn, 1, 3, easeOutExpo, slidevert -10%"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
          force_split = 2;
          special_scale_factor = 0.95;
        };

        gestures = {
          "workspace_swipe_invert" = false;
          "workspace_swipe_distance" = 350;
          "workspace_swipe_min_speed_to_force" = 20;
          "workspace_swipe_cancel_ratio" = 0.2;
          "workspace_swipe_forever" = true;
          "workspace_swipe_create_new" = true;
        };

        gesture = [
          "3, horizontal, workspace"
          "3, vertical, special, term"
        ];

        group = {
          "col.border_active" = "rgb(8,169,255) rgb(8,169,255)";
          "col.border_inactive" = "rgb(2,86,143) rgb(2,86,143)";
          groupbar = {
            "col.active" = "rgb(255,255,255) rgb(255,255,255)";
            "col.inactive" = "rgb(147,147,147) rgb(147,147,147)";
            keep_upper_gap = false;
            font_size = 12;
            font_weight_active = "medium";
            font_weight_inactive = "medium";
            height = 12;
          };
        };

        binds = {
          workspace_back_and_forth = false;
          allow_workspace_cycles = true;
        };

        workspace = [
          "w[tv1]s[false], gapsout:0, gapsin:0"
          "f[1]s[false], gapsout:0, gapsin:0"
        ];

        misc = {
          vrr = 1;
          "key_press_enables_dpms" = true;
          "enable_swallow" = true;
          "swallow_regex" = "^(kitty)|()$";
          "swallow_exception_regex" = "^(firefox)|(nemo)|(dolphin)$";
          "focus_on_activate" = true;
          "disable_hyprland_logo" = true;
          "force_default_wallpaper" = false;
        };

        xwayland = {
          force_zero_scaling = true;
        };

        layerrule = [
          "match:namespace swaync-control-center, ignore_alpha on"
          "match:namespace rofi, dim_around on"
        ];

        windowrule = [
          # replacement for no_gaps_when_only
          "border_size 0, match:float 0, match:workspace w[tv1]s[false]"
          "rounding 0, match:float 0, match:workspace w[tv1]s[false]"
          "border_size 0, match:float 0, match:workspace f[1]s[false]"
          "rounding 0, match:float 0, match:workspace f[1]s[false]"

          "match:class (com.ml4w.sidebar), float on, move 100%-w-16 66, pin on, size 400 740"
          "match:class ^(blueberry.py)$, size 390 375, move onscreen cursor 5% 5%, no_anim on, stay_focused on, opacity 1.0, dim_around on"
          "match:class ^(peazip)$, float on"
          "match:class ^(nemo)$, float on, no_blur on"
          "match:class ^(com.obsproject.Studio)$, no_blur on, opaque on"

          "match:class ^(wofi)$, border_size 0"
          "match:class ^(wlogout), no_anim on, float on, fullscreen on"

          "match:workspace s[1], match:class ^(kitty)$, opacity 0.95"
          "match:workspace s[0], match:class ^(kitty)$, opacity 0.95 0.95 0.95"

          "match:class (xdg-desktop-portal-gtk), float on, size (monitor_w*0.65) (monitor_h*0.7), stay_focused on, center on"        
          "match:class ^(org.gnupg.pinentry-qt), stay_focused on, dim_around on" # vscode commit sign pass popup
          "match:title (.*)(Bitwarden)$, size 600 600"
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

          "$mainMod ALT, M, exec, wleave -b 3 -T 415 -B 340 -R 540 -L 540 -p layer-shell"
          "$mainMod ALT, R, exec, pkill -SIGUSR2 waybar"

          # Session Control
          "$mainMod ALT, P, exec, wleave -b 3 -T 415 -B 340 -R 540 -L 540 -p layer-shell"
          "$mainMod, L, exec, loginctl lock-session"
          "$mainMod, I, exec, matcha -t && notify-send 'Toggled Idle Inhibitor'"

          # App Launch Shortcuts
          "$mainMod, Q, exec, kitty"
          "$mainMod, F, exec, vivaldi --ozone-platform=wayland --password-store=kwallet6"
          "$mainMod, E, exec, dolphin"
          "$mainMod, V, exec, pkill fuzzel || ~/.config/ml4w/scripts/cliphist.sh"
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

          # Group Controls
          "$mainMod, K, togglegroup"
          "$mainMod, M, changegroupactive"

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
  };
}
