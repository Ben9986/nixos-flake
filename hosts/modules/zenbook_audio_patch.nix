{ pkgs, lib, ...}:
with lib;
let 
  inherit (pkgs) runCommand acpica-tools cpio;

  ssdt-csc2551-acpi-table-patch = runCommand "ssdt-csc2551" { } ''
    mkdir iasl
    cp ${../benlaptop/ssdt-csc3551.dsl} iasl/ssdt-csc3551.dsl
    ${getExe' acpica-tools "iasl"} -ia iasl/ssdt-csc3551.dsl

    mkdir -p kernel/firmware/acpi
    cp iasl/ssdt-csc3551.aml kernel/firmware/acpi/
    find kernel | ${getExe cpio} -H newc --create > patched-acpi-tables.cpio

    cp patched-acpi-tables.cpio $out
  '';
  in {
    config.boot.initrd.prepend = [ (toString ssdt-csc2551-acpi-table-patch) ];
  }