{lib, ...}:
{ 
options.flakeDir = lib.mkOption {  
  type = lib.types.str;
};
config.flakeDir = "$HOME/flake-config";
}
