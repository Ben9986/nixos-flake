{ fetchFromGitHub, pkgs }:
  pkgs.buildNpmPackage rec {
    pname = "krohnkite";
    version = "0.9.7";

    dontWrapQtApps=true;
    npmDepsHash = "sha256-My1goFEoZW9kFA3zb8xKPxAPXm6bypyq+ajPM8zVOHQ=";

    nativeBuildInputs =  with pkgs; [
      kdePackages.kpackage
      kdePackages.kwin
      nodePackages.npm
      p7zip
    ];
    # Fixed package-lock needed for reproducibility. Cannot build without.
    postPatch = ''
      cp ${./package-lock.json} package-lock.json
      chmod +w package-lock.json
    '';

    buildPhase = ''
      npm run tsc --
    '';

    installPhase = ''
      runHook preInstall

      make ${pname}-${version}.kwinscript
      kpackagetool6 --type=KWin/Script --install=${pname}-${version}.kwinscript --packageroot=$out/share/kwin/scripts

      runHook postInstall
    '';

    src = fetchFromGitHub {
      owner = "anametologin";
      repo = "krohnkite";
      rev =  version;
      hash = "sha256-8A3zW5tK8jK9fSxYx28b8uXGsvxEoUYybU0GaMD2LNw=";
    };
  }
