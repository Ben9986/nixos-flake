{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{

  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    custom.hyprland.enable = true;
    custom.plasma.enable = true;

    boot = {
      extraModprobeConfig = ''
        # Toggle fnlock_default at boot (Y/N)
        options asus_wmi fnlock_default=N
      '';
      initrd = {
        verbose = false;
      };
      plymouth.extraConfig = ''
          [Daemon]
          DeviceScale=3
          ShowDelay=2
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
          extraInstallCommands = mkMerge [
            (mkIf config.custom.laptop.default-windows "echo \"\ndefault windows.conf\" >> /boot/loader/loader.conf")
            (mkIf (
              !config.custom.laptop.default-windows
            ) "echo \"\ndefault nixos-generation-*.conf\" >> /boot/loader/loader.conf")
          ];
        };
      };
      resumeDevice = "/dev/disk/by-uuid/6a68dc0e-442c-4165-9516-aac2766b5ff1";
      kernelParams = [
        "quiet"
        "splash"
        "loglevel=0"
        "vt.global_cursor_default=0"
        "udev.log_level=0"
        "resume_offset=47355654"
      ];
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
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "breeze";
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
  };
}
