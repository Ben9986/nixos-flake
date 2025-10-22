{
  pkgs,
  lib,
  config,
  ...
}:
{

  imports = [
    ./hardware-configuration.nix
  ];

  bootloader = {
    enable = true;
    lanzaboote.enable = true;
    default-windows = true;
    quiet-boot = true;
  };
  cosmic = {
    enable = false;
    greeter.enable = true;
  };
  hyprland.enable = true;
  plasma.enable = false;
  core-services.enable = true;
  virtualisation.enable = true;
  zenbook-audio-patch.enable = true;

  boot = {
    extraModprobeConfig = ''
      # Toggle fnlock_default at boot (Y/N)
      options asus_wmi fnlock_default=N
    '';
    resumeDevice = "/dev/disk/by-uuid/a181d09e-f92e-4c4f-9385-0ed7eaa84c5c";
    kernelParams = [ "resume_offset=9053367" ];
    kernelPackages = pkgs.linuxPackages_zen;
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      options = [ "sw" ];
    }
  ];

  environment.systemPackages = with pkgs; [
    r2modman
    vscodium-fhs
  ];

  networking.hostName = "benlaptop";

  services = {
    pipewire.wireplumber.extraConfig = {
      "10-disable-camera" = {
        "wireplumber.profiles" = {
          main."monitor.libcamera" = "disabled";
        };
      };
    };
    udev.extraRules = ''SUBSYSTEM=="backlight",RUN+="${pkgs.coreutils}/bin/chmod 777 /sys/class/leds/asus::kbd_backlight/brightness"'';
  };

  systemd = {
    services."mic-mute-led-invert" = {
      after = [ "multi-user.target" ];
      wantedBy = [ "graphical.target" ];
      unitConfig = {
        Description = "Reverse microphone mute led";
      };
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c 'echo follow-route > /sys/devices/virtual/sound/ctl-led/mic/mode'";
      };
    };
    sleep.extraConfig = ''
      AllowHibernation=yes
      AllowHybridSleep=no
      AllowSuspendThenHibernate=no
      HibernateMode=shutdown
    '';
  };
}
