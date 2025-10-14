{
  pkgs,
  lib,
  config,
  ...
}:
let
  fsmount = pkgs.writeShellScriptBin "fsmount" ''
    #!${lib.getExe pkgs.bash}

    commands=(
      "sudo mount -o compress=zstd,subvol=/ /dev/nvme0n1p6 /mnt"
      "sudo mount -o compress=zstd,subvol=/home /dev/nvme0n1p6 /mnt/home"
      "sudo mount -o compress=zstd,noatime,subvol=/nix /dev/nvme0n1p6 /mnt/nix"
      "sudo mount /dev/nvme0n1p5 /mnt/boot"
    )

    for cmd in "''${commands[@]}"; do
      echo
      echo "About to run: $cmd"
      read -p "Proceed? (y/n) " confirm

      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        eval "$cmd"
      else
        echo "Skipped."
      fi
    done
  '';

  quick-install = pkgs.writeShellScriptBin "custom-reinstall" ''
    #!${lib.getExe pkgs.bash}

    echo "Checking for internet connection"
    if ping 1.1.1.1 -q -c 1 -W 2; then
      echo "Connection detected"
    else
      echo "No connection detected!\n Use nmtui to connect to a network"
      exit 1
    fi

    echo "Cloning flake config..."
    flakedir=/tmp/flake-config
    git clone https://github.com/ben9986/nixos-flake $flakedir && echo "Clone successful"

    read -p "Confirm hostname to be installed (benlaptop/bendesktop/trinity) " hostname

    cmd="sudo nixos-install --flake /home/nixos/flake-config#$hostname --root /mnt --no-root-password"

    echo "About to run: $cmd"
    read -p "Proceed? (y/n) " confirm 

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      eval "$cmd"
    else
      echo "Skipped."
    fi
  '';
  cfg = config.iso;
in
{
  options.iso.enable = lib.mkEnableOption "Custom ISO Configuration";

  config = lib.mkIf cfg.enable {
    isoImage = {
      makeEfiBootable = true;
      makeUsbBootable = true;
      configurationName = "Custom NixOS Live ISO";
      edition = "Custom";
      contents = [
        {
          source = ../../.;
          target = "/flake-config";
        }
      ];
    };
    boot.loader.grub.memtest86.enable = true;

    i18n.defaultLocale = "en_GB.UTF-8";
    networking.networkmanager.enable = true;
    environment.systemPackages = with pkgs; [
      git
      fsmount
      quick-install
    ];
  };
}
