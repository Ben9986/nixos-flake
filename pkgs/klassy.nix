{ stdenv, fetchFromGitHub, pkgs, lib }:
  stdenv.mkDerivation rec {
    pname = "klassy";
    version = "6.1.breeze6.0.3";
    dontWrapQtApps = true;
    nativeBuildInputs =  with pkgs.kdePackages; [
      extra-cmake-modules
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
    ] 
    ++ [
      pkgs.cmake
      pkgs.xorg.libX11
    ];
    cmakeFlags = [ "-DBUILD_QT5=OFF"];
    src = fetchFromGitHub {
      owner = "paulmcauley";
      repo = "klassy";
      rev =  version;
      hash = "sha256-D8vjc8LT+pn6Qzn9cSRL/TihrLZN4Y+M3YiNLPrrREc=";
    };
  }
