{
  pkgs,
  lib,
  config,
  ...
}:
let cfg = config.nvidia;
in {
  options.nvidia = {
    enable = lib.mkEnableOption "Nvidia Proprietary Drivers";
    nouveau.enable = lib.mkEnableOption "Nouveua";
  };
  
  config = lib.mkMerge [
    (lib.mkIf (cfg.enable && !cfg.nouveau.enable) {
      # Load nvidia driver for Xorg and Wayland
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        # Modesetting is required.
        modesetting.enable = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        powerManagement.enable = true;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        #powerManagement.finegrained = true;

        open = true;

        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidia_x11;
        # Only sha256_64bit and settingsSha256 need to be set for most systems.
        # The others need to be present but not valid (I don't know why) hence the fakeSha256's
        # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        #   version = "560.35.03";
        #   sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
        #   sha256_aarch64 = lib.fakeSha256;
        #   openSha256 = lib.fakeSha256;
        #   settingsSha256 = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
        #   persistencedSha256 = lib.fakeSha256;
        # };
      };
      })
      (lib.mkIf (cfg.enable && cfg.nouveau.enable) {
          # Enable OpenGL
          hardware.opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
          };
          boot.kernelParams = [ "nouveau.config=NvGspRM=1" ];
      })
  ];
}
