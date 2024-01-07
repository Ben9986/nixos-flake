{inputs, pkgs, home-manager, ...}:
{
services.swayidle = {
  enable = true;
  events = [
    {
      event = "before-sleep";
      command = "${pkgs.swaylock}/bin/swaylock -f";
    }
    {
      event = "after-resume";
      command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on; ${pkgs.brightnessctl}/bin/brightnessctl -r; echo 2 | ${pkgs.coreutils}/bin/tee  /sys/class/leds/asus::kbd_backlight/brightness";
    }
    {
      event = "lock";
      command = "${pkgs.swaylock}/bin/swaylock -f";
    }
  ];
  timeouts = [
    {
      timeout = 150;
      command = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10% & echo 1 | ${pkgs.coreutils}/bin/tee  /sys/class/leds/asus::kbd_backlight/brightness";
      resumeCommand = "brightnessctl -r & echo 1 | ${pkgs.coreutils}/bin/tee /sys/class/leds/asus::kbd_backlight/brightness";
    }
    {
      timeout = 165;
      command = "${pkgs.systemd}/bin/systemctl suspend";
    }
  ];
};
}
