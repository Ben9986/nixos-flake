{ lib, pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "klassy";
  version = "6.2.breeze6.2.1";

  src = pkgs.fetchFromGitHub {
    owner = "paulmcauley";
    repo = "klassy";
    rev = "refs/tags/${version}";
    hash = "sha256-tFqze3xN1XECY74Gj0nScis7DVNOZO4wcfeA7mNZT5M=";
  };

  dontWrapQtApps = true;

  cmakeFlags = [ "-DBUILD_QT5=OFF" ];

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
