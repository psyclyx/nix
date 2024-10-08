{
  pkgs,
  config,
  ...
}: let
  inherit (config.colorScheme) palette;
in {
  programs.waybar = {
    style = ''
      * {
          font-family: Fira Code Nerd Font;
          font-size: 16px;
      }

      window#waybar {
          background-color: #${palette.base00};
          color: #${palette.base06};

      }

      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }
      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }

      button {
          box-shadow: inset 0 -3px transparent;
          border: none;
          border-radius: 0;
          transition:
            background-color 0.3s,
            box-shadow 0.3s,
            color 0.3s;
      }

      button:hover {
          background: inherit;
          text-shadow: inherit;
          box-shadow: inset 0 -3px #${palette.base05};
      }

      #workspaces button {
          color: #${palette.base05};
          background-color: transparent;
          padding: 0 5px;
      }

      #workspaces button.focused {
          color: #${palette.base06};
          box-shadow: inset 0 -3px #${palette.base06};
      }

      #pulseaudio,
      #network,
      #backlight,
      #cpu,
      #memory,
      #battery,
      #clock
      {
          padding: 0 16px;
          color: #${palette.base06};
      }

      .modules-right > widget:nth-child(2n) {
          background-color: #${palette.base02};
      }

      .modules-right > widget:nth-child(2n+1) {
          background-color: #${palette.base03};
      }

    '';
    enable = true;
    settings = {
      mainBar = {
        layer = "bottom";
        position = "top";
        height = 24;
        spacing = 16;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [
          "sway/window"
        ];
        modules-right = [
          "clock"
          "pulseaudio"
          "network"
          "backlight"
          "cpu"
          "memory"
          "battery"
        ];
        "sway/window" = {
          max-length = 64;
        };
        "sway/workspaces" = {
          on-click = "activate";
          sort-by-number = true;
          format = "{icon}";
          format-icons = {
            "1" = "i";
            "2" = "ii";
            "3" = "iii";
            "4" = "iv";
            "5" = "v";
            "6" = "vi";
            "7" = "vii";
            "8" = "viii";
            "9" = "ix";
            "10" = "x";
          };
        };
        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-alt = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = "{volume}%  {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "{volume}% ";
          format-icons = {
            headphone = "";
            default = [
              ""
              ""
              ""
            ];
          };
        };
        "network" = {
          format-wifi = "{signalStrength}% ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ";
          format-alt = "{ifname} = {ipaddr}/{cidr} ";
        };
        "clock" = {
          interval = 60;
          tooltip = false;
          format = "[{:%R | %a, %d/%m/%y}]";
        };
        "cpu" = {
          format = "{usage}% ";
          tooltip = false;
        };
        "memory" = {
          format = "{}% ";
        };
        "battery" = {
          states = {
            good = 97;
            warning = 30;
            critical = 10;
          };
          interval = 2;
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          # "format-good": ""; # An empty format will hide the module
          # "format-full": "";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
      };
    };
  };
}
