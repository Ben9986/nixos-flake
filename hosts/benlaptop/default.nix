{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  inherit (pkgs) runCommand acpica-tools cpio;

  ssdt-csc2551-acpi-table-patch = runCommand "ssdt-csc2551" { } ''
    mkdir iasl
    cp ${./ssdt-csc3551.dsl} iasl/ssdt-csc3551.dsl
    ${getExe' acpica-tools "iasl"} -ia iasl/ssdt-csc3551.dsl

    mkdir -p kernel/firmware/acpi
    cp iasl/ssdt-csc3551.aml kernel/firmware/acpi/
    find kernel | ${getExe cpio} -H newc --create > patched-acpi-tables.cpio

    cp patched-acpi-tables.cpio $out
  '';
in
{

  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    custom.hyprland.enable = false;

    boot = {
      initrd = {
        prepend = [ (toString ssdt-csc2551-acpi-table-patch) ];
        verbose = false;
      };
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
        "udev.log_level=0"
        "resume_offset=47355654"
      ];
      kernelPackages = pkgs.linuxPackages_6_12;
      plymouth = {
        enable = true;
        theme = "bgrt";
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
      desktopManager.plasma6.enable = true;
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
