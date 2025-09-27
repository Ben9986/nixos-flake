{ lib, config, ... }:
{
  programs.fuzzel = lib.mkIf config.home-manager.hyprland.enable {
    enable = true;
    settings = {
      main = {
        namespace = "fuzzel";
        icon-theme = "Breeze";
        fields = "name,keywords";
        width = 45;
        vertical-pad = 15;
        line-height = 20;
      };
      colors = {
        border = lib.mkForce "ffffffff";
      };
      border = {
        width = 2;
      };

    };

  };

  home.file.".config/fuzzel/cliphist.ini".text = ''
    [main]
    anchor=top-right
    font=DejaVu Sans:size=10
    line-height=20
    namespace=fuzzel-clipboard
    vertical-pad=15
    width=45
    x-margin=10
    prompt="  "
    placeholder="Seach Clipboard"

    [colors]
    background=181818FF
    border=ffffffff
    counter=ffffffff
    input=ffffffff
    match=ff9470ff
    placeholder=888888ff
    prompt=ffffffff
    selection=888888ff
    selection-match=ff9470ff
    selection-text=ffffffff
    text=ffffffff
  '';
}
