{ inputs, config, lib, pkgs, ... }:
{
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  console = {
    font = "iso01-12x22";
    useXkbConfig = true; # use xkbOptions in tty.
   };

  nix = {
    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    extraOptions = ''
      # free up to 1GiB from store when less that 100MiB left
        min-free = ${toString (100 * 1024 * 1024)}
        max-free = ${toString (1024 * 1024 * 1024)}
        experimental-features = nix-command flakes
      '';
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "ben" ];
      trusted-substituters = ["https://hyprland.cachix.org"];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    package = pkgs.nixFlakes;
  };
  
  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;
  
  time = {
    timeZone = "Europe/London";
    # Needed for Windows dual boot
    hardwareClockInLocalTime = true;
  };

  # Was weirdly required for pipewire to install
  hardware.pulseaudio.enable = false;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  
  systemd.services."display-manager".preStart = "sleep 5";
  # Fix Default Apps opening in Flatpaks
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
  '';
  
  services.displayManager.defaultSession = "hyprland";        
  services.displayManager.sddm = {        
    enable = true;
    wayland.enable = true;
    theme = "sddm-sugar-dark";
    extraPackages = with pkgs; [libsForQt5.qt5.qtgraphicaleffects];
  };

  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
    pam.services.hyprlock = {};
  # Scheduling (used by pipewire)
    rtkit.enable = true;
  };

   users.users.ben = {
     isNormalUser = true;
     extraGroups = [ "wheel" "input" "networkmanager" "video" ];
     description = "Ben Carmichael";
     initialPassword = "password";
     shell = pkgs.zsh;
     packages = with pkgs; [
     ];
   };

  environment.variables = { NIXOS_OZONE_WL = "1"; };

   environment.systemPackages = with pkgs; [
     appimage-run
     polkit_gnome
     xorg.xhost # for polkit apps
     at-spi2-core
     git
     p7zip
     # Hyprland stuff
     networkmanagerapplet
     blueberry
     brightnessctl
     font-awesome
     udiskie
     distrobox
     copyq
     nwg-look
     glib # gsettings for nwg-look
     gsettings-desktop-schemas
     swaynotificationcenter
     gnome.gnome-software
     cinnamon.nemo
     catppuccin-gtk
     gnome.adwaita-icon-theme
     gtk3
     # qt5&6 wayland needed for xdph
     qt6.qtwayland # cursors?
     libsForQt5.qt5.qtwayland
     libsForQt5.qt5ct
     qt6Packages.qt6ct
     libsForQt5.discover
     gparted
     gnome-multi-writer
     ntfs3g
     power-profiles-daemon
     ];

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    zsh.enable = true;
    steam.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = /. + config.flakeDir;
    };
};

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

