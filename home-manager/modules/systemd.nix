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
 
  systemd.user.services = {
  "pull-flake" = {
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

  "rclone-strath" = {
    Unit = {
      Description = "rclone: Remote FUSE filesystem for cloud storage config %i";
      After = "network-online.target";
      Wants = "network-online.target";
    };
    Install = {
      WantedBy= [ "default.target" ];
    };
    Service = {
      Type = "notify";
      ExecStart = ''
  ${pkgs.rclone}/bin/rclone mount --config=%h/.config/rclone/rclone.conf --vfs-cache-mode full OneDrive-Strathclyde: %h/OneDrive-Strathclyde
      '';
      ExecStop = "${pkgs.fuse}/bin/fusermount -u %h/OneDrive-Strathclyde";
    };
  };

  "rclone-personal" = {
    Unit = {
      Description = "rclone: Remote FUSE filesystem for cloud storage config %i";
      After = "network-online.target";
      Wants = "network-online.target";
    };
    Install = {
      WantedBy= [ "default.target" ];
    };
    Service = {
      Type = "notify";
      ExecStart = ''
  ${pkgs.rclone}/bin/rclone mount --config=%h/.config/rclone/rclone.conf --vfs-cache-mode full OneDrive-Personal: %h/OneDrive-Personal
      '';
      ExecStop = "${pkgs.fuse}/bin/fusermount -u %h/OneDrive-Personal";
    };
  };
};

}
