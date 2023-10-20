{ pkgs, lib, config, ...}:
let 
  zenbook-acpi = pkgs.stdenv.mkDerivation rec {
    pname = "asus-zenbook-ux3402za-acpi-tables";
    version = "0.0.1";
    src = pkgs.fetchFromGitHub {
      owner = "thor2002ro";
      repo = "asus_zenbook_ux3402za";
      rev = "54cc1488e8dd2ffbf3dbffd390e42d9a4657a2de";
      sha256 = "sha256-o32kAz8z/AMsKfCmU0nHxhcerDudYqJduHhRCeZbVPQ=";
    };
 
    nativeBuildInputs = with pkgs; [
      acpica-tools
    ];
 
    buildPhase = ''
      cp -r Sound Work
      iasl -tc Work/ssdt-csc3551.dsl
    '';
 
    installPhase = ''
      mkdir -p $out/boot $out/etc/grub.d
      cp Work/ssdt-csc3551.aml $out/boot/ssdt-csc3551.aml
    '';
  };
in 
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
      # useOSProber = true;
      extraEntriesBeforeNixOS = true;
      extraEntries = ''
         menuentry 'Windows Boot Manager (on /dev/nvme0n1p3)' --class windows --class os $menuentry_id_option 'osprober-efi-89A9-5B80' {
           insmod part_gpt
           insmod fat
           search --no-floppy --fs-uuid --set=root 89A9-5B80
           chainloader /EFI/Microsoft/Boot/bootmgfw.efi
         }
      '';
      # gfxmodeEfi = "2880x1800";
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
      extraFiles."ssdt-csc3551.aml" = "${zenbook-acpi}/boot/ssdt-csc3551.aml";
      extraConfig = "acpi ($root)/ssdt-csc3551.aml";
    };
    kernelParams = ["quiet"];
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = [(pkgs.catppuccin-plymouth.override {variant = "mocha";})];
    };
    consoleLogLevel = 1;
  };

}
