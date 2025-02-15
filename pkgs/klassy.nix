{ lib, pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "klassy";
  version = "6.2.breeze6.3.0";

  src = pkgs.fetchFromGitHub {
    owner = "foxinatel";
    repo = "klassy";
    rev = "3b26f96c7ace61331506f87d71d3cd7145cdba11";
    # tag = "${version}";
    hash = "sha256-9IZhO8a8URTYPv6/bf7r3incfN1o2jBd2+mLVptNRYo=";
  };

  dontWrapQtApps = true;

  cmakeFlags = [ "-DBUILD_QT5=OFF" ];

  # patches = [
  #   ./setVersion.patch
  # ];

  nativeBuildInputs = with pkgs; [
    kdePackages.extra-cmake-modules
    cmake
    xorg.libX11
  ];

  buildInputs = with pkgs.kdePackages; [
    qtbase
    kcmutils
    kcolorscheme
    kconfig
    kconfigwidgets
    kcoreaddons
    kguiaddons
    ki18n
    kiconthemes
    kirigami
    kpackage
    kservice
    kwindowsystem
    kwayland
    frameworkintegration
    kdecoration
    qtsvg
  ];

  meta = {
    description = "Highly customizable Window Decorations and Application Style plugin for Plasma 6";
    homepage = "https://github.com/paulmcauley/klassy";
    license = with lib.licenses; [
      bsd3
      cc0
      gpl2Only
      gpl2Plus
      gpl3Only
      gpl3Plus
      mit
    ];
    maintainers = with lib.maintainers; [ ben9986 ];
    platforms = lib.platforms.all;
  };
}
