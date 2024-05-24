{ pkgs, lib, config, ...}:
{

  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      timeoutStyle = "hidden";
      theme = pkgs.stdenv.mkDerivation {
        name = "vimix-grub-theme";
        buildInputs = [ pkgs.bash ];
        src = pkgs.fetchFromGitHub {
          owner = "vinceliuice";
          repo = "grub2-themes";
          rev = "2022-10-30";
          hash = "sha256-LBYYlRBmsWzmFt8kgfxiKvkb5sdLJ4Y5sy4hd+lWR70=";
        };
        installPhase = ''
        var="#! ${pkgs.bash}/bin/bash"
        echo $var
        sed -i "1c\$var" install.sh
        chmod +x ./install.sh
        ./install.sh -t vimix -s 2k -g $out
        mv $out/vimix/* $out
        rm -r $out/vimix
        '';
};
      backgroundColor = "#000000";
    };
    kernelParams = ["quiet"];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = [(pkgs.catppuccin-plymouth.override {variant = "mocha";})];
    };
    consoleLogLevel = 1;
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };

  };

#  services.pipewire.extraConfig.pipewire = {
#    "10-mic-mon" = {
#      "context.modules" = [
#      {
#        "name" = "libpipewire-module-loopback";
#        "args" = {
#            "audio.position" = "[ FL FR ]";
#            "capture.props" = {
#	        "node.name" = "mic-input";
#                "media.class" = "Audio/Source";
#                "node.target" = "alsa_input.pci-0000_0b_00.4.analog-stereo";
#                "node.description" = "my-sink";
#            };
#            "playback.props" = {
#                "node.name" = "mic-sink";
#                "node.passive" = "true";
#                "node.target" = "alsa_output.pci-0000_0b_00.4.analog-stereo";
#            };
#        };
#	}
#    ];
#    };
#  };

  # Disable suspend as it crashes hyprland on nvidia
  systemd.services.systemd-suspend.enable = false;
  systemd.targets.suspend.enable = false;
  
  networking.hostName = "bendesktop";

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    gamemode
    gamescope
    r2modman
    vulkan-tools
    sddm-kcm # For Login Theme in Plasma Settings
  ];

  ## Plasma 6
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = [ pkgs.kdePackages.sddm ];

  services.displayManager.sddm = {        
    enable = true;
    wayland.enable = true;
    theme = "sddm-sugar-dark";
    # mkForce needed for sugar dark theme when plasma 6 is enabled
    package = lib.mkForce pkgs.libsForQt5.sddm;
    extraPackages = lib.mkForce [
      pkgs.libsForQt5.qt5.qtgraphicaleffects
    ];
  };

}
