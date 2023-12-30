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

    services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "chili";
  };

  # Disable suspend as it crashes hyprland on nvidia
  systemd.services.systemd-suspend.enable = true;
  
  networking.hostName = "bendesktop";

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
  ];

}
