{inputs, config, ...}:
{
programs.waybar.enable = true;
programs.waybar.settings = {
    mainbar= {
    output = [      "eDP-1"      "HDMI-A-1"    ];
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
};

programs.waybar.style = ''
.modules-right > * {
}
* {
    /* `otf-font-awesome` is required to be installed for icons */
    font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
    font-size: 13px;
}

window#waybar {
    /*background-color: rgba(43, 48, 59, 0.5); */
    background-color: transparent;
    /*border-bottom: 2px solid rgba(89, 89, 89, 0.5);*/
    border: none;
    color: #ffffff;
    transition-property: background-color;
    transition-duration: .5s;
}

window#waybar.hidden {
    opacity: 0.2;
}

/*
window#waybar.empty {
    background-color: transparent;
}
window#waybar.solo {
    background-color: #FFFFFF;
}
*/

window#waybar.termite {
    background-color: #3F3F3F;
}

window#waybar.chromium {
    background-color: #000000;
    border: none;
}

button {
    /* Use box-shadow instead of border so the text isn't offset */
    /*box-shadow: inset 0 -3px transparent;*/
    /* Avoid rounded borders under each button name */
    /*border: none;
    border-radius: 0;*/
}

/* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
button:hover {
    background: inherit;
    box-shadow: inset 0 -3px #ffffff;
}

#workspaces button {
    padding: 0 5px;
    background-color: transparent;
    color: #ffffff;
}

#workspaces button:hover {
    background: rgba(0, 0, 0, 0.2);
    box-shadow: inherit;
    text-shadow: inherit;
}

#workspaces button.focused {
    background-color: #64727D;
    box-shadow: inset 0 -3px #ffffff;
}

#workspaces button.urgent {
    background-color: #eb4d4b;
}

#mode {
    background-color: #64727D;
    border-bottom: 3px solid #ffffff;
}

#clock,
clock.date,
#battery,
#bluetooth,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#wireplumber,
#custom-media,
#tray,
#mode,
#idle_inhibitor,
#scratchpad,
#mpd {
    padding: 0 10px;
    color: #ffffff;
    font-size:11pt;
    color: rgba(220,220,220,1);
    background-color: rgba(45, 45, 45, 1);
    border-radius: 15px;
    border-color: rgba(55,55,55,1);
    border-style: solid;
    border-width: 2px; 
}

#window,
#workspaces {
    margin: 0 4px;
    background-color: rgba(45, 45, 45, 1);
    border-radius: 15px;
    border-color: rgba(55,55,55,1);
    border-style: solid;
    border-width: 2px; 

}

#workspaces button.active {
  background-color: rgb(100,100,100);
  border-radius: 15px;

}

/* If workspaces is the leftmost module, omit left margin */
.modules-left > widget:first-child > #workspaces {
    margin-left: 0;
}

/* If workspaces is the rightmost module, omit right margin */
.modules-right > widget:last-child > #workspaces {
    margin-right: 0;
}

#clock {
    padding: 2px 20px 0px;
    font-size:11pt;
    color: rgba(220,220,220,1);
}

#clock.time {
}

#clock.date {
}

#battery {
    /*alignment messed up without this padding*/
    padding: 0px 12px 1px 12px;
}

#battery.good {
    background-color: #26A65B;
    color: rgb(10,10,10);
}

#battery.medium {
    background-color: rgb(212, 114, 34);
    color: rgb(0,0,0);
}

#battery.warning {
  background-color: #f53c3c;
  color: rgb(10,10,10);
}

#battery.charging, #battery.plugged {
    color: #ffffff;
    background-color: #26A65B;
}

@keyframes blink {
    to {
        background-color: #ffffff;
        color: #000000;
    }
}

#battery.critical:not(.charging) {
    background-color: #f53c3c;
    color: #ffffff;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

label:focus {
    background-color: #000000;
}

#backlight {
    min-width: 3.7em;
}

#network {
    background-color: rgba(43, 48, 59, 0.5);
}

#network.disconnected {
    background-color: #f53c3c;
}

#pulseaudio {
    color: #ffffff;
}

#pulseaudio.muted {
    background-color: #90b1b1;
    color: #2a5c45;
}

#wireplumber {
    /*background-color: #fff0f5; */
    min-width: 3.7em;
}

wireplumber.muted {
    background-color: rgb(180,180,180);
    color: #2d3436;
    font-size: 14px
}

#custom-media {
    background-color: #66cc99;
    min-width: 60px;
}

#custom-media.custom-spotify {
    background-color: #66cc99;
}

#custom-media.custom-vlc {
    background-color: #ffa000;
}

#temperature {
    background-color: #f0932b;
}

#temperature.critical {
    background-color: #eb4d4b;
}

#tray {
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background-color: #eb4d4b;
}

#idle_inhibitor {
    /*Center the icon correctly*/
    padding: 0px 10px 0px 12px;
    border-radius: 18px;
}

#idle_inhibitor.activated {
    background-color: rgb(180,180,180);
    color: #2d3436;
    border: 2px solid grey;
}

#mpd {
    background-color: #66cc99;
    color: #2a5c45;
}

#mpd.disconnected {
    background-color: #f53c3c;
}

#mpd.stopped {
    background-color: #90b1b1;
}

#mpd.paused {
    background-color: #51a37a;
}

#language {
    background: #00b093;
    color: #740864;
    padding: 0 5px;
    margin: 0 5px;
    min-width: 16px;
}

#keyboard-state {
    background: #97e1ad;
    color: #000000;
    padding: 0 0px;
    margin: 0 5px;
    min-width: 16px;
}

#keyboard-state > label {
    padding: 0 5px;
}

#keyboard-state > label.locked {
    background: rgba(0, 0, 0, 0.2);
}

#scratchpad {
    background: rgba(0, 0, 0, 0.2);
}

#scratchpad.empty {
        background-color: transparent;
}
'';
}
