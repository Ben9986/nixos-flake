{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.niri;
in
{
  options.niri = {
    enable = lib.mkEnableOption "Niri Wayland Compositor";
    };

  config = lib.mkIf cfg.enable {
    wm-common.enable = true;
    programs.niri = {
      enable = true;
    };
    environment.systemPackages = with pkgs; [
      noctalia-shell
      xwayland-satellite
    ];
    services.gnome.gnome-keyring.enable = false; # Enabled by niri module but I prefer kwallet
  };
}
