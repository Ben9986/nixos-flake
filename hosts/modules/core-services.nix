{ config, pkgs, lib, ... }:
let cfg = config.core-services;
in {
  options.core-services = {
    enable = lib.mkEnableOption "Core Desktop Services";
  };

  config = lib.mkIf cfg.enable {
    services = {
      accounts-daemon.enable = true;

      dbus.enable = true;

      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "breeze";
      };

      flatpak.enable = true;

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;

      onedrive.enable = true;

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber = {
          enable = true;
          
        };
      };

      printing.enable = true;

      upower.enable = true;

      xserver = {
        enable = true;
        xkb.layout = "gb";
      };

      power-profiles-daemon.enable = true;

      auto-cpufreq = {
        enable = false;
        settings = {
          charger = {
            governer = "performance";
            turbo = "auto";
          };
          battery = {
            governer = "powersave";
            turbo = "auto";
          };
        };
      };
    };
  };
}
