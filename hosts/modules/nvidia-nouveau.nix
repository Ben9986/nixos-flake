{pkgs, lib, config, ...}:

{ 
    # Enable OpenGL
   hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    # zen kernel is already on 6.8 so not needed
  # kernelPackages = lib.mkForce pkgs.linuxPackages_6_8;
  boot.kernelParams = [ "nouveau.config=NvGspRM=1" ];
}
