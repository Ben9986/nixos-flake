{config, pkgs, ...}:
{
services = {
  accounts-daemon.enable = true;
  
  dbus.enable = true;
  
  flatpak.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  libinput.enable = true;
  
  pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  printing.enable = true;
  
  udev.extraRules = ''
  SUBSYSTEM=="backlight",RUN+="${pkgs.coreutils}/bin/chmod 777 /sys/class/leds/asus::kbd_backlight/brightness"
  '';
  
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
  systemd.services."tailscaled" = {
    # wants = [ "network-pre.target" "network-online.target" ];
    # after = [ "network-online.target" "NetworkManager.service" "systemd-resolved.service" ];
    # wantedBy = ["multi-user.target" ];
    serviceConfig = {
      # ExecStart="${pkgs.tailscale}/bin/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/run/tailscale/tailscaled.sock --port=$\{PORT} $FLAGS";
      ExecStop="${pkgs.tailscale}/bin/tailscale down";
      # ExecStopPost="${pkgs.tailscale}/bin/tailscaled --cleanup";

      # Restart="on-failure";

      # RuntimeDirectory="tailscale";
      # RuntimeDirectoryMode="0755";
      # StateDirectory="tailscale";
      # StateDirectoryMode="0700";
      # CacheDirectory="tailscale";
      # CacheDirectoryMode="0750";
      # Type="notify";
    };
  };
}
