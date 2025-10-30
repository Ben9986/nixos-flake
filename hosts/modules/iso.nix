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
      printf "About to run: $cmd\n"
      read -p "Proceed? (y/n): " confirm

      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        eval "$cmd"
        printf "\n\n"
      else
        printf "Skipped.\n\n"
      fi
    done

  '';

  quick-install = pkgs.writeShellScriptBin "custom-reinstall" ''
    #!${lib.getExe pkgs.bash}

    printf "Checking for internet connection\n\n"
    if ping 1.1.1.1 -q -c 1 -W 2; then
      printf "Connection detected\n\n"
    else
      printf "No connection detected!\n Use nmtui to connect to a network"
      exit 1
    fi

    printf "Cloning flake config..."
    flakedir=/tmp/flake-config
    rm -rf $flakedir
    git clone https://github.com/ben9986/nixos-flake $flakedir && printf "\nClone successful\n\n"

    read -p "Confirm hostname to be installed (benlaptop/bendesktop/trinity): " hostname

    case "$hostname" in 
      benlaptop|bendesktop|trinity)
        printf "You selected $hostname\n\n"
        ;;
      *)
        printf "$hostname is not a valid hostname"
        exit 1
        ;;
    esac
    
    cmd="sudo nixos-install --flake $flakedir#$hostname --root /mnt --no-root-password"

    printf "About to run: $cmd\n\n"
    read -p "Proceed? (y/n): " confirm 

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      eval "$cmd"
    else
      printf "Installation Cancelled\n"
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
