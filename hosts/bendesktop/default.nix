{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
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
      initrd.verbose = false;
      plymouth.extraConfig = ''
          [Daemon]
          DeviceScale=1
        '';
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
          consoleMode = "max";
          extraEntries = {
            "windows.conf" =
              "
            title Windows_11
            efi /EFI/Microsoft/Boot/bootmgfw.efi
            sort-key a-windows
	        ";
          };
          extraFiles = {
            "loader/loader.conf" = pkgs.writeText "loader.conf" "timeout menu-hidden\nauto-entries false";
          };
          extraInstallCommands = "echo '\ndefault nixos-generation-*.conf' >> /boot/loader/loader.conf";
        };
      };
      kernelParams = [ "quiet" "splash" "udev.log_level=0" "vt.global_cursor_default=0" ] ;
      kernelPackages = pkgs.linuxPackages_zen;
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

    # Disable suspend as monitor KVM can't wake PC.
    systemd.services.systemd-suspend.enable = false;
    systemd.targets.suspend.enable = false;

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
