{inputs, config, ...}:
{

programs.waybar.settings = {
    "layer" = "top"; # Waybar on top layer
    "height" = 32; # Waybar height (to be removed for auto height)
    "spacing" = 4; # Gaps between modules (4px)

#--- Module Order ---
    "modules-left" = ["hyprland/workspaces" "custom/media"];
    "modules-center" = ["clock#time" "clock#date"];
    "modules-right" = ["idle_inhibitor" "wireplumber"  "backlight"  "battery"  "bluetooth"  "tray"];
    
# -------- Modules configuration ---------
  
  "wlr/taskbar" = {
    "format" = "{icon}";
    "icon-size" = 14;
    "icon-theme" = "Numix-Circle";
    "tooltip-format" = "{title}";
    "on-click" = "activate";
    "on-click-middle" = "close";
    "ignore-list" = [
       "kitty"
    ];
    "app_ids-mapping" = {
      "firefoxdeveloperedition" = "firefox-developer-edition";
    };
    "rewrite" = {
        "Firefox Web Browser" = "Firefox";
        "Foot Server" = "Terminal";
    };
}; 

  "hyprland/workspaces" = {
      "format" = "{name}";
      "on-click" = "activate";
      "format-icons" = {
        "1" = "";
        "2" = "";
        "3" = "";
        "4" = "";
        "5" = "";
      "urgent" = "";
      "active" = "";
      "default" = "";
    };
    "sort-by-number" = true;
    };

    "idle_inhibitor" = {
      "format" = "{icon}";
      "format-icons" = {
          "activated" = " ";
          "deactivated" = " ";
      };
      "tooltip-format-activated" = "Activated";
      "tooltip-format-deactivated" = "Deactivated";
    };

    "bluetooth" = {
        "on-click" = "pkill blueberry || blueberry";
	"on-click-right" = "flatpak run io.github.kaii_lb.Overskride";
	"format-on" = "󰂯";
	"format-off" = "󰂲";
	"format-disabled" = "󰂲"; # an empty format will hide the module
	"format-connected" = " {num_connections} connected";
	"tooltip-format" = "";
	"tooltip-format-connected" = "";
	"tooltip-format-enumerate-connected" = "";
  };
    "tray" = {
        "icon-size" = 18;
        "spacing" = 10;
    };
    "clock#time" = {
        "format" = "{ :%H :%M}";
        # "timezone" = "America/New_York";
                "format-alt" = "{:%Y-%m-%d}";
    };
    "clock#date" = {
       "format" = "{:%A; %d/%m/%Y}";
       "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };
    "cpu" = {
        "format" = "{usage}% ";
        "tooltip" = false;
    };
    "memory" = {
        "format" = "{}% ";
    };
    "temperature" = {
        # "thermal-zone" = 2;
        # "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input";
        "critical-threshold" = 80;
        # "format-critical" = "{temperatureC}°C {icon}";
        "format" = "{temperatureC}°C {icon}";
        "format-icons" = ["" ""  ""];
    };
    "backlight" = {
        "format" = "{icon} {percent}%";
        "format-icons" = ["󰃞 " "󰃞 " "󰃞 "  "󰃝 "  "󰃟 "  "󰃟 " "󰃟 " "󰃟 " "󰃟 " "󰃠 "];
    };
    "battery" = {
        "states" = {
            "good" = 100;
	    "medium" = 50;
            "warning" = 25;
            "critical" = 15;
        };
        "format" = "{capacity}% {icon} ";
        "format-charging" = "{capacity}% ";
        "format-plugged" = "{capacity}% ";
        "format-alt" = "{time} {icon}";
        # "format-good" = ""; // An empty format will hide the module
        # "format-full" = "";
        "format-icons" = ["" "" "" "" ""];
    };
    "network" = {
        # "interface" = "wlp2*"; // (Optional) To force the use of this interface
        "format-wifi" = "   {essid}";
        "format-ethernet" = "{ipaddr}/{cidr} ";
        "tooltip-format" = "{ifname} {signalStrength}%";
        "format-linked" = "{ifname} (No IP) ";
        "format-disconnected" = "Disconnected ⚠";
        "on-click" = "nm-connection-editor";
        };
    "pulseaudio" = {
        "format" = "{icon}  {volume}%  {format_source}";
        "format-bluetooth" = "{volume}% {icon} {format_source}";
        "format-bluetooth-muted" = " {icon} {format_source}";
        "format-muted" = " {format_source}";
        "format-source" = "  {volume}%";
        "format-source-muted" = "";
        "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" "" ""];
        };
        "on-click" = "pavucontrol";
    };
    "wireplumber" = {
      "format" = "{icon} {volume}%";
      "format-muted" = "󰝟  Mute";
      "on-click" = "wpctl set-mute @DEFAULT_SINK@ toggle";
      "format-icons" = ["" "" "" "" "󰕾 " "󰕾 " "󰕾 " "󰕾 " " " " "];
      "scroll-step" = 1;
    };
    "custom/media" = {
    "format" = "{icon} {}";
    "format-icons" = "🎵";
    "escape" = true;
    "return-type" = "json";
    "max-length" = 40;
    "on-click" = "playerctl play-pause";
    "on-click-right" = "playerctl stop";
    "smooth-scrolling-threshold" = 10; # This value was tested using a trackpad, it should be lowered if using a mouse.
    "on-scroll-up" = "playerctl next";
    "on-scroll-down" = "playerctl previous";
    "exec" = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null"; # Script in resources/custom_modules folder
};
};
}
