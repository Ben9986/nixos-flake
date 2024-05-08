{pkgs, lib, config, ...}:

{ 
    # Enable OpenGL
   hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  kernelPackages = pkgs.linuxPackages_6_8;
  boot.kernelParams = [ "nouveau.config=NvGspRM=1" ];
}
