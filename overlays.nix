final: prev: {
    niri = prev.niri.overrideAttrs (oldAttributes: rec {
      version = "git";
      src = prev.fetchFromGitHub {
        owner = "yalter";
        repo = "niri";
        rev = "cf0b4bc0ca93ab5c18b562ada1d8609b67b3c4e3";
        hash = "sha256-aTj88rDBdhmzaGXoFPOsHjXYM2OjNttixsGftT/X0dI=";
      };
      patches = [
        (prev.fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/YaLTeR/niri/pull/2456.patch";
          hash = "sha256-2R5UP6HTv6UlL4NUOI26nA4n4Wu9tSmk2q6EDX+5WJI=";
          })
      ];
      doInstallCheck = false;
       cargoDeps = final.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-CXRI9LBmP2YXd2Kao9Z2jpON+98n2h7m0zQVVTuwqYQ=";
        };
    });}