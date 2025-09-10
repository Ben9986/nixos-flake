{ pkgs, config, ... }:
{
  systemd.user.services = {
    "pull-flake" = {
      Unit = {
        Description = "Pull changes for flake configuration from github";
        After = [ "graphical-session.target" "network-online.target" ];
        Wants = [ "network-online.target" ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "pull-flake" ''
          set -eu
          cd ${config.custom.flakeDir}
          result=$(${pkgs.git}/bin/git pull)

          if echo "$result" | grep -q -E "Updating|Fast-forward"; then
           ${pkgs.libnotify}/bin/notify-send "✅ Changes Pulled\!" "Must be manually installed" -e -t 4000
          elif echo "$result" | grep -q "Already up to date."; then
           ${pkgs.libnotify}/bin/notify-send "📂 No Changes to Pull" -e -t 4000
          else
            ${pkgs.libnotify}/bin/notify-send "⚠️ Config Pull Error"
            echo "$result"
          fi
        ''}";
        Type = "oneshot";
      };
    };

    # "rclone-reauth@" = {
    #   Unit = {
    #     Description = "Rclone Service Failure Script";
    #   };
    #   Install = {
    #     WantedBy = [ "network-online.target" ];
    #   };
    #   Service = {
    #     ExecStartPre = "sleep 5";
    #     ExecStart = "${pkgs.writeShellScript "rclone-failure" ''
    #       set -eu
    #       ${pkgs.libnotify}/bin/notify-send "'$1 disconnected'" "'Opening browser to re-autherise'" -t 4000
    #       ${pkgs.rclone}/bin/rclone config reconnect $1: --auto-confirm -n && ${pkgs.libnotify}/bin/notify-send "'$1 reconnected'" "'$1 has been reconnected successfully'" && exit 0
    #       ${pkgs.libnotify}/bin/notify-send "'$1 Connection Failure'" "'Failed to re-athorise connection'" -t 10000 && exit 1
    #     ''} %i";
    #     Type = "oneshot";
    #   };
    # };

    # "rclone-strath" = {
    #   Unit = {
    #     Description = "rclone: Remote FUSE filesystem for cloud storage config %i";
    #     After = "network-online.target";
    #     Wants = "network-online.target";
    #     OnFailure = "rclone-reauth@OneDrive-Strathclyde.service";
    #   };
    #   Install = {
    #     WantedBy = [ "network-online.target" ];
    #   };
    #   Service = {
    #     Type = "notify";
    #     ExecStart = ''
    #       ${pkgs.rclone}/bin/rclone mount --config=%h/.config/rclone/rclone.conf --vfs-cache-mode full OneDrive-Strathclyde: %h/OneDrive-Strathclyde
    #     '';
    #     ExecStop = "${pkgs.fuse}/bin/fusermount -u %h/OneDrive-Strathclyde";
    #     Restart = "on-failure";
    #     RestartSec = "5s";
    #   };
    # };

    # "rclone-personal" = {
    #   Unit = {
    #     Description = "rclone: Remote FUSE filesystem for cloud storage config %i";
    #     After = "network-online.target";
    #     Wants = "network-online.target";
    #     OnFailure = "rclone-reauth@OneDrive-Personal.service";
    #   };
    #   Install = {
    #     WantedBy = [ "network-online.target" ];
    #   };
    #   Service = {
    #     Type = "notify";
    #     ExecStart = ''
    #       ${pkgs.rclone}/bin/rclone mount --config=%h/.config/rclone/rclone.conf --vfs-cache-mode full OneDrive-Personal: %h/OneDrive-Personal
    #     '';
    #     ExecStop = "${pkgs.fuse}/bin/fusermount -u %h/OneDrive-Personal";
    #     Restart = "on-failure";
    #     RestartSec = "5s";
    #   };
    # };
  };

}
