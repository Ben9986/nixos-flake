{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.hyprland;
  # hyprlandPackages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  hyprlandPackages = pkgs; # Use nixpkgs instead of git
in
{
  options.hyprland = {
    enable = lib.mkEnableOption "Hyprland Session";
  };

  config = lib.mkIf cfg.enable {

    wm-common.enable = true;
    programs = {
      hyprland = {
        enable = true;
        package = hyprlandPackages.hyprland;
        portalPackage = hyprlandPackages.xdg-desktop-portal-hyprland;
      };
    };
    environment.systemPackages = lib.mkMerge [
      (with pkgs.kdePackages; [
        dolphin
        kservice # for kbuildsyscoca6 to update open-with menus
        kwallet
        kwallet-pam
        kirigami
        qtstyleplugin-kvantum
        breeze
      ])
      (with pkgs; [
        kvmarwaita
        lxqt.pcmanfm-qt
        hyprpolkitagent
        swayosd
        brightnessctl
      ])
    ];

    
    # Fix Default Apps opening in Flatpaks
    systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
    '';

    systemd.services.swayosd-libinput-backend = {
      description = "SwayOSD LibInput backend for listening to certain keys like CapsLock, ScrollLock, VolumeUp, etc.";
      documentation = [ "https://github.com/ErikReider/SwayOSD" ];
      wantedBy = [ "graphical.target" ];

      serviceConfig = {
        Type = "dbus";
        BusName = "org.erikreider.swayosd";
        ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
        Restart = "on-failure";
      };
    };

    services = {
      blueman.enable = lib.mkDefault true;
      displayManager.defaultSession = "hyprland";
      udev.packages = [ pkgs.swayosd ];
    };

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];

    # Fix unpopulated MIME menus in dolphin
    environment.etc."/xdg/menus/applications.menu".text =
      builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  };
}
