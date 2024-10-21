{...}: let
  c = import ../../../colors.nix;
in {
  imports = [./style.nix];
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "bottom";
        position = "top";
        modules-left = [
          "sway/workspaces"
          "sway/scratchpad"
          "sway/mode"
          "sway/window"
        ];
        modules-right = [
          "network"
          "backlight"
          "pulseaudio"
          "memory"
          "cpu"
          "clock"
          "battery"
        ];

        "sway/window" = {
          format = " {}";
          max-length = 128;
        };

        "sway/workspaces" = {
          on-click = "activate";
          sort-by-number = true;
          format = "{icon}";
          format-icons = {
            "1" = "1. code";
            "2" = "2. web";
            "3" = "3. notes";
            "4" = "4. chat";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "0";
          };
        };
        "sway/scratchpad" = {
          format-icons = ["" "󰼜"];
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-alt = "{icon} {volume}% {format_source}";
          format-bluetooth = "{icon} {volume}%";
          format-bluetooth-alt = "{icon} {volume}% {format_source}";
          format-bluetooth-muted = " {volume}% {format_source}";
          format-muted = " {volume}% {format_source}";
          format-source = " {volume}%";
          format-source-muted = " {volume}%";
          format-icons = {
            headphone = "";
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
        };
        "network" = let
          format_speed = "󰶡 {bandwidthDownBytes} 󰶣 {bandwidthUpBytes}";
        in {
          format-wifi = "󰖩 {signalStrength}% ${format_speed}";
          tooltip = "{essid} {ifname} {ipaddr}/{cidr}";
          format-ethernet = "󰈁 ${format_speed}";
          format-linked = "󰲚 {ifname} (No IP) ${format_speed}";
          format-disconnected = "";
        };
        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = [
            "󰹐"
            "󱩎"
            "󱩏"
            "󱩐"
            "󱩑"
            "󱩒"
            "󱩓"
            "󱩔"
            "󱩕"
            "󱩖"
            "󰛨"
          ];
        };
        "clock" = {
          interval = 60;
          tooltip = false;
          format = "󰥔 {:%I:%M %m/%d/%y}";
        };
        "cpu" = let
          cpuIcon = "";
        in {
          interval = 4;
          format = "${cpuIcon} {icon0}{icon1}{icon2}{icon3}";
          format-icons = [
            "<span color='${c.blue2}'>▁</span>"
            "<span color='${c.blue3}'>▂</span>"
            "<span color='${c.slate1}'>▃</span>"
            "<span color='${c.slate2}'>▄</span>"
            "<span color='${c.slate3}'>▅</span>"
            "<span color='${c.red2}'>▆</span>"
            "<span color='${c.red3}'>▇</span>"
            "<span color='${c.red4}'>█</span>"
          ];
          tooltip = false;
        };
        "memory" = {
          interval = 4;
          format = " {icon}";
          tooltip = "{used:0.1f}G / {total:0.1f}G";
          format-icons = [
            "<span color='${c.blue2}'>▏</span>"
            "<span color='${c.blue3}'>▎</span>"
            "<span color='${c.slate1}'>▍</span>"
            "<span color='${c.slate2}'>▌</span>"
            "<span color='${c.slate3}'>▋</span>"
            "<span color='${c.red2}'>▊</span>"
            "<span color='${c.red3}'>▉</span>"
            "<span color='${c.red4}'>█</span>"
          ];
        };
        "battery" = {
          states = {
            good = 100;
            normal = 80;
            warning = 30;
            critical = 10;
          };
          interval = 15;
          tooltip = "{time}";
          format = "{icon} {capacity}% ";
          format-alt = "{icon} {capacity}% {time}";
          format-charging = "󱐥 {capacity}% {time}";
          format-plugged = "󰚥 {capacity}%";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
      };
    };
  };
}
