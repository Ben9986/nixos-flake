{lib, ...}:
{ 
options.flakeDir = lib.mkOption {  
  type = lib.types.str;
};
config.flakeDir = "/home/ben/flake-config";
}
