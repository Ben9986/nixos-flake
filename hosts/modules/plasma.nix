{pkgs, lib, config, ...}:
let cfg = config.plasma;
in {
  options.plasma = {
    enable = lib.mkEnableOption "Plasma Desktop Sessoion";
  };

  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.plasma6.enable = true;
    };
};
}