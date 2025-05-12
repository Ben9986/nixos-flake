{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  discover-wrapped = pkgs.symlinkJoin {
    name = "plasma-discover";
    paths = [ pkgs.kdePackages.discover ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/plasma-discover --add-flags "--backends flatpak-backend"
    '';
  };
in
{
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [
      "compress=zstd"
      "noatime"
    ];
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  console = {
    font = "iso01-12x22";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      # free up to 1GiB from store when less that 100MiB left
        min-free = ${toString (100 * 1024 * 1024)}
        max-free = ${toString (1024 * 1024 * 1024)}
        experimental-features = nix-command flakes
    '';
    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "ben"
      ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      substituters = [
        "https://hyprland.cachix.org"
        "https://cosmic.cachix.org/"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      ];
    };
    package = pkgs.nixVersions.stable;
  };

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  time = {
    timeZone = "Europe/London";
    # Needed for Windows dual boot
    hardwareClockInLocalTime = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  services.snapper.configs = {
    home = {
      SUBVOLUME = "/home";
      ALLOW_USERS = [ "ben" ];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
    };
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = lib.mkIf config.custom.hyprland.enable true;

  security = {
    polkit.enable = true;
    pam.services.swaylock = { };
    pam.services.hyprlock = { };
    rtkit.enable = true; # Scheduling (used by pipewire)
  };

  users.users.ben = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
      "video"
      "docker"
      "ydotool"
    ];
    description = "Ben Carmichael";
    initialPassword = "password";
    shell = pkgs.zsh;
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };
  environment.etc = {
    "blossom.jpg".source = ./blossom.jpg;
  };

  environment.systemPackages = with pkgs; [
    (callPackage ./modules/sddm-sugar-dark.nix { })
    (callPackage ./modules/sddm-astronaut-theme.nix { })
    appimage-run
    git
    gsettings-desktop-schemas
    gparted
    snapper-gui
    gnome-multi-writer
    ntfs3g
    kdePackages.sddm-kcm # For Login Theme in Plasma Settings
    discover-wrapped
    kdePackages.baloo
    kdePackages.kde-gtk-config
    pinentry
    localsend
    nix-output-monitor
  ];

  programs = {
    fuse.userAllowOther = true;
    gnupg.agent.enable = true;
    zsh.enable = true;
    steam.enable = true;
    nh = {
      enable = true;
      clean.enable = false;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = config.custom.flakeDir;
    };
    ydotool.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
