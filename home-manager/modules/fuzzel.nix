{lib, config, ...}:
{
programs.fuzzel = lib.mkIf config.custom.hyprland.enable {
  enable = true;
  settings = {
    main = {
      icon-theme = "Adwaita";
      fields = "name,keywords";
      width = 35;
      vertical-pad= 15;
      line-height = 20;
      };
    colors = {
      background = "4a4c4fff";
      text = "ddddddff";
    };

  };

};
}
