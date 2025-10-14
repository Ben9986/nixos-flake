{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.home-manager.wleave;
in
{
  options.home-manager.wleave = {
    enable = mkEnableOption "Wleave and associated Config";
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.wleave ];
    home.file = {
      ".config/wleave/layout.json".text = ''
          {
            "buttons": [
              {"action":"hyprlock","keybind":"l","label":"lock","text":"Lock", "icon": "${pkgs.wleave}/share/wleave/icons/lock.svg"},                              
              {"action":"hyprctl dispatch exit","keybind":"e","label":"logout","text":"Logout", "icon": "${pkgs.wleave}/share/wleave/icons/logout.svg"},
              {"action":"systemctl suspend","keybind":"s","label":"suspend","text":"Sleep", "icon": "${pkgs.wleave}/share/wleave/icons/suspend.svg"},  
              {"action":"systemctl hibernate","keybind":"s","label":"hibernate","text":"Hibernate", "icon": "${pkgs.wleave}/share/wleave/icons/hibernate.svg"},  
              {"action":"systemctl poweroff","keybind":"s","label":"shutdown","text":"Shutdown", "icon": "${pkgs.wleave}/share/wleave/icons/shutdown.svg"},            
              {"action":"systemctl reboot","keybind":"r","label":"reboot","text":"Reboot", "icon": "${pkgs.wleave}/share/wleave/icons/reboot.svg"} 
        ]
          }
      '';

      ".config/wleave/style.css".text = with config.lib.stylix.colors.withHashtag; ''
        @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
        @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};

        @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
        @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};

        * {
          font-family: "${config.stylix.fonts.monospace.name}";
          font-size: ${builtins.toString config.stylix.fonts.sizes.desktop}pt;
          background-image: none;
        }

        window {
          background-color: alpha(@base00, 0.5);
        }

        button {
          color: @base05;
          font-size: 16px;
          background-color: @base01;
          border-style: none;
          background-repeat: no-repeat;
          background-position: 50% 40%;
          background-size: 50%;
          border-radius:30px;
          margin: 10px 5px;
          text-shadow: 0px 0px;
          box-shadow: 0px 0px;
        }

        button:focus, button:active, button:hover {
          background-color: @base02;
          outline-style: none;
        }

      '';
    };
  };
}
