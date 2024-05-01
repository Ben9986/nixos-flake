{pkgs, config, ...}:
{
  systemd.user.timers."pull-flake" = {
    Install = {
      WantedBy =  [ "timers.target" ];
    };
    Timer = {
      OnStartupSec = "20";
      Unit = "pull-flake.service";
    };
  };
 
  systemd.user.services."pull-flake" = {
     Unit = {
      Description = "Pull changes for flake configuration from github";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "pull-flake" ''
      set -eu
      ${pkgs.coreutils}/bin/echo "Starting Git Pull..."
      cd ${config.flakeDir}
      ${pkgs.libnotify}/bin/notify-send "Checking for Config Changes..." "$(${pkgs.git}/bin/git pull)" -t 4000 -e
    ''}";
      Type = "oneshot";
      };
  };
}
