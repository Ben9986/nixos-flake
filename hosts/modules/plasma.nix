{pkgs, lib, config, ...}:
let cfg = config.plasma;
in {
  options.plasma = {
    enable = lib.mkEnableOption "Plasma Desktop Sessoion";
    sddm.enable = lib.mkEnableOption "SDDM Display Manager";
  };

  config = lib.mkIf cfg.enable {
    services = {
      # sddm needs plasma-workspace for breeze theme otherwise fallback theme
      displayManager.sddm = {
        enable = cfg.sddm.enable;
        wayland.enable = true;
        theme = "breeze";
      };
      desktopManager.plasma6.enable = true;
    };
};
}