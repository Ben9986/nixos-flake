{inputs, pkgs, lib, config, ...}:
{
  services.hypridle = lib.mkIf config.hyprland.enable {
    enable = true;
    package = pkgs.hypridle;
    settings = { 
    general = {
      lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
      unlock_cmd = "";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on; ${pkgs.brightnessctl}/bin/brightnessctl -r; echo 2 | ${pkgs.coreutils}/bin/tee  /sys/class/leds/asus::kbd_backlight/brightness";
    };
    listener = [
      {
        timeout = 300;
        on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10% & echo 1 | ${pkgs.coreutils}/bin/tee  /sys/class/leds/asus::kbd_backlight/brightness";
        on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r & echo 2 | ${pkgs.coreutils}/bin/tee /sys/class/leds/asus::kbd_backlight/brightness";
      }
      {
        timeout = 320;
        on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
        on-resume = "";
      }
    ];
    };
  };
}