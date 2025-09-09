{
  pkgs,
  lib,
  config,
  ...
}:

{
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  boot.kernelParams = [ "nouveau.config=NvGspRM=1" ];
}
