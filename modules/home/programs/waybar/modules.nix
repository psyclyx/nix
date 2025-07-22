{
  idle_inhibitor = {
    format = "{icon}";
    format-icons = {
      activated = "";
      deactivated = "";
    };
  };

  "sway/workspaces" = {
    on-click = "activate";
    sort-by-number = true;
    format = "{icon}";
    format-icons = {
      "1" = "1";
      "2" = "2";
      "3" = "3";
      "4" = "4";
      "5" = "5";
      "6" = "6";
      "7" = "7";
      "8" = "8";
      "9" = "9";
      "10" = "0";
    };
  };

  "sway/scratchpad" = {
    format-icons = [
      ""
      "󰼜"
    ];
  };

  pulseaudio = {
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

  "network" =
    let
      format_speed = "󰶡 {bandwidthDownBytes} 󰶣 {bandwidthUpBytes}";
    in
    {
      format-wifi = "󰖩 {signalStrength}% ${format_speed}";
      tooltip = "{essid} {ifname} {ipaddr}/{cidr}";
      format-ethernet = "󰈁 ${format_speed}";
      format-linked = "󰲚 {ifname} (No IP) ${format_speed}";
      format-disconnected = "";
    };

  backlight = {
    format = "{percent}% {icon}";
    format-icons = [
      ""
      ""
    ];
  };

  "clock" = {
    interval = 15;
    tooltip = false;
    format = "󰥔 {:%I:%M %m/%d/%y}";
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

  "hyprland/workspaces" = {
    disable-scroll = true;
    all-outputs = true;
    warp-on-scroll = false;
    format = "{icon}";
    format-icons = {
      urgent = " ";
      active = " ";
      default = " ";
    };
    persistent-workspaces = {
      "1" = [ ];
      "2" = [ ];
      "3" = [ ];
    };
  };

  "hyprland/submap" = {
    format = "<span style=\"italic\">{}</span>";
  };

}
