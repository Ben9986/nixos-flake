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

  bootloader = {
    enable = true;
    quiet-boot = true;
  };
  hyprland.enable = true;
  plasma.enable = false;
  core-services.enable = true;
  nvidia.enable = true;
  virtualisation.enable = true;

  boot = {
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

  environment.variables = {
    # needed for smoother fonts on hidpi display
    QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
  };
}
