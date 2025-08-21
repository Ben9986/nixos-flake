{
  pkgs,
  lib,
  config,
  ...
}:
let
  codium-no-gpu = pkgs.symlinkJoin {
    name = "codium-no-gpu";
    paths = [ pkgs.vscodium-fhs ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/codium --add-flags "--disable-gpu"
    '';
  };
in
{

  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    custom.hyprland.enable = true;
    custom.plasma.enable = true;

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
      kernelParams = [ "quiet" "splash" "udev.log_level=0" ] ;
      kernelPackages = pkgs.linuxPackages_zen;
      plymouth = {
        enable = true;
        theme ="bgrt";
      };
      consoleLogLevel = 0;
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

    hardware.logitech.wireless.enable = true;

    # Disable suspend as it crashes hyprland on nvidia
    systemd.services.systemd-suspend.enable = !config.custom.hyprland.enable;
    systemd.targets.suspend.enable = !config.custom.hyprland.enable;

    networking.hostName = "bendesktop";

    environment.systemPackages = with pkgs; [
      mangohud
      goverlay
      gamemode
      gamescope
      r2modman
      vulkan-tools
      codium-no-gpu
      solaar
    ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "breeze";
    };

    environment.variables = {
      # needed for smoother fonts on hidpi display
      QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
    };
  };
}
