{...}:
{
  programs.wofi = {
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
