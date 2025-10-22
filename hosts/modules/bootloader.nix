{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.bootloader;
in
{
  options.bootloader = {
    enable = mkOption {
      type = lib.types.bool;
      default = true;
      description = "Default Bootloader Configuration";
    };
    default-windows = mkEnableOption "Windows as default boot entry";
    quiet-boot = mkEnableOption "Kernel params to give quiet boot";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      boot = {
        kernelParams = [
          "quiet"
          "splash"
          "loglevel=0"
          "vt.global_cursor_default=0"
          "udev.log_level=0"
        ];
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
          timeout = 0;
          systemd-boot = with lib; {
            enable = lib.mkDefault true;
            configurationLimit = 5;
            consoleMode = "max";
            # extraEntries = {
            #   "windows.conf" ="
            #     title Windows_11
            #     efi /EFI/Microsoft/Boot/bootmgfw.efi
            #     sort-key a-windows
	          #   ";
            # };
            extraFiles = {
              "loader/loader.conf" = pkgs.writeText "loader.conf" "timeout menu-hidden\nauto-entries false";
            };
          };
        };
      };
    }
    (mkIf cfg.default-windows {
      boot.loader.systemd-boot.extraInstallCommands = "echo \"\ndefault auto-windows\" >> /boot/loader/loader.conf";
    })

    (mkIf (!cfg.default-windows) {
      boot.loader.systemd-boot.extraInstallCommands = "echo \"\ndefault nixos-generation-*.conf\" >> /boot/loader/loader.conf";
    })

  ]);

}
