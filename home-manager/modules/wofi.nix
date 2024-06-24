{lib, config, ...}:
{
  programs.wofi = lib.mkIf config.hyprland.enable {
    enable = true;
    settings = {
      mode="drun";
      allow_images=true;
      allow_markup=true;
      prompt="Search...";
      key_expand="Tab";
      no_actions=true;
      insensitive=true;
    };
  };
}
