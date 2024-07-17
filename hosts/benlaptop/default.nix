{ pkgs, lib, config, ...}:
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

  imports =
    [
      ./hardware-configuration.nix
    ];
  
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
	        "windows.conf"= "
            title Windows_11
            efi /EFI/Microsoft/Boot/bootmgfw.efi
            sort-key a-windows
	        ";
	      };
        extraFiles = {
          "loader/loader.conf" = pkgs.writeText "loader.conf" "timeout menu-hidden\nauto-entries false";
        };
        extraInstallCommands = mkMerge [
          (mkIf config.laptop.default-windows "echo \"\ndefault windows.conf\" >> /boot/loader/loader.conf")
          (mkIf (!config.laptop.default-windows) "echo \"\ndefault nixos-generation-*.conf\" >> /boot/loader/loader.conf")
        ];
      };
    };
    kernelParams = ["quiet" "splash" "udev.log_level=0" ];
    kernelPackages = pkgs.linuxPackages_zen;
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

  environment.systemPackages = with pkgs; [
    r2modman
    vscodium-fhs
    ];

  networking.hostName = "benlaptop";

  ## Plasma 6
  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm = {        
    enable = true;
    wayland.enable = true;
    theme = "breeze";
  };


}
