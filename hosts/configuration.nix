# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ inputs, config, lib, pkgs, ... }:
let
 #  zenbook-acpi = pkgs.stdenv.mkDerivation rec {
 #    pname = "asus-zenbook-ux3402za-acpi-tables";
 #    version = "0.0.1";
 #    src = pkgs.fetchFromGitHub {
 #      owner = "thor2002ro";
 #      repo = "asus_zenbook_ux3402za";
 #      rev = "54cc1488e8dd2ffbf3dbffd390e42d9a4657a2de";
 #      sha256 = "sha256-o32kAz8z/AMsKfCmU0nHxhcerDudYqJduHhRCeZbVPQ=";
 #    };

 #    nativeBuildInputs = with pkgs; [
 #      acpica-tools
 #    ];

 #    buildPhase = ''
 #      cp -r Sound Work
 #      iasl -tc Work/ssdt-csc3551.dsl
 #    '';

 #    installPhase = ''
 #      mkdir -p $out/boot $out/etc/grub.d
 #      cp Work/ssdt-csc3551.aml $out/boot/ssdt-csc3551.aml
 #    '';
 #  };

 #  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

 #  hyprland-flake = (import flake-compat {
 #    src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
 #  }).defaultNix;
in
{
  imports =
    [ # Include the results of the hardware scan.
      #./hardware-configuration.nix
      ];
  
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
   #  "/swap".options = [ "noatime" ];
  };


  nixpkgs.config.allowUnfree = true;
  # Windows time compat
  time.hardwareClockInLocalTime = true;
  nix = {
    gc = {
      automatic = true;
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
      # substituters = ["https://hyprland.cachix.org"];
      #trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    package = pkgs.nixFlakes;
  };
  
  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.systemd-boot.configurationLimit = 10;
  # boot.loader.efi.canTouchEfiVariables = true;
  
 #  boot = {
 #    loader.efi.canTouchEfiVariables = true;
 #    loader.grub = {
 #      enable = true;
 #      device = "nodev";
 #      efiSupport = true;
 #      # useOSProber = true;
 #      extraEntriesBeforeNixOS = true;
 #      extraEntries = ''
 #         menuentry 'Windows Boot Manager (on /dev/nvme0n1p3)' --class windows --class os $menuentry_id_option 'osprober-efi-89A9-5B80' {
 #           insmod part_gpt
 #           insmod fat
 #           search --no-floppy --fs-uuid --set=root 89A9-5B80
 #           chainloader /EFI/Microsoft/Boot/bootmgfw.efi
 #         }
 #      '';
 #      # gfxmodeEfi = "2880x1800";
 #      timeoutStyle = "hidden";
 #      theme = pkgs.stdenv.mkDerivation {
 #        name = "vimix-grub-theme";
 #        buildInputs = [ pkgs.bash ];
 #  	src = pkgs.fetchFromGitHub {
 #    	  owner = "vinceliuice";
 #    	  repo = "grub2-themes";
 #    	  rev = "2022-10-30";
 #    	  hash = "sha256-LBYYlRBmsWzmFt8kgfxiKvkb5sdLJ4Y5sy4hd+lWR70=";
 #  	};
 #        installPhase = ''
 #        var="#! ${pkgs.bash}/bin/bash"
 #        echo $var
 #        sed -i "1c\$var" install.sh
 #        chmod +x ./install.sh
 #        ./install.sh -t vimix -s 2k -g $out
 #        mv $out/vimix/* $out
 #        rm -r $out/vimix
 #        '';
}# ;
 #      backgroundColor = "#000000";
 #      extraFiles."ssdt-csc3551.aml" = "${zenbook-acpi}/boot/ssdt-csc3551.aml";
 #      extraConfig = "acpi ($root)/ssdt-csc3551.aml";
 #    };
 #    kernelParams = ["quiet"];
 #    plymouth = {
 #      enable = true;
 #      theme = "catppuccin-mocha";
 #      themePackages = [(pkgs.catppuccin-plymouth.override {variant = "mocha";})];
 #      # themePackages = [(pkgs.adi1090x-plymouth-themes.override {selected_themes = ["double"];})];
 #    };
 #    consoleLogLevel = 1;
 #  };



  networking.hostName = "benlaptop";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  console = {
    font = "iso01-12x22";
    # keyMap = "gb";
    useXkbConfig = true; # use xkbOptions in tty.
   };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Scheduling (used by pipewire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Was weirdly required for pipewire to install
  hardware.pulseaudio.enable = false;

  services.dbus.enable = true;
  services.flatpak.enable = true;

  services.xserver = {
    enable = true;
    layout = "gb";
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    displayManager.lightdm = {
      enable = true;
      greeters.slick.enable = true;
      greeters.slick.theme.name = "Catppuccin-Mocha-Standard-Blue-Dark";
      greeters.slick.theme.package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        #size = "compact";
        tweaks = [ "rimless" ];
        variant = "mocha";
      };
      greeters.slick.cursorTheme.name = "Phinger Cursors";
      greeters.slick.extraConfig = ''
         enable-hidpi=on
      '';
      extraConfig = ''
         minimum-vt=1
	 #logind-check-graphical=true
      '';
    };
    # desktopManager.cinnamon.enable = true;

  };
  
  # xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  
  systemd.services."display-manager".preStart = "sleep 5";
  systemd.user = {
    services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "no";
          RestartSec = 1;
          TimeoutStopSec = 10;
      };
    };
  };


  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.ben = {
     isNormalUser = true;
     extraGroups = [ "wheel" "input" "networkmanager" ]; # Enable ‘sudo’ for the user.
     description = "Ben Carmichael";
     initialPassword = "password";
     shell = pkgs.zsh;
     packages = with pkgs; [
     ];
   };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     polkit_gnome
     xorg.xhost # for polkit apps
     at-spi2-core
     neovim 
     wget
     kitty
     rclone
     ranger
     gh
     git
     eza
     acpica-tools
     p7zip
     # Hyprland stuff
     waybar
     wofi
     hyprpaper
     # hyprshot
     swaylock-effects
     swayidle
     networkmanagerapplet
     blueman
     brightnessctl
     font-awesome
     udiskie
     distrobox
     copyq
     nwg-look
     swaynotificationcenter
     gnome.gnome-software
     cinnamon.nemo
     catppuccin-gtk
     phinger-cursors
     gtk3
     qt6.qtwayland # cursors?
     libsForQt5.qt5.qtwayland
     glib # gsettings for nwg-look
     gsettings-desktop-schemas
     less # pager
     firefox
     gparted
     gnome-multi-writer
     ntfs3g
     (wlogout.override {withGtkLayerShell = true;})
   ];

  programs = {
    hyprland = {
      enable = true;
      # package = hyprland-flake.packages.${pkgs.system}.hyprland;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    zsh.enable = true;
};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

