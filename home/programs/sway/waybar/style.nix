{...}: let
  c = import ../../../colors.nix;
in {
  programs.waybar = {
    style = ''
      * {
          font-family: NotoMono Nerd Font;
          font-size: 14px;
      }

      window#waybar {
          background-color: ${c.bg-alt};
          color: ${c.fg};
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
          box-shadow: inset 0 -3px ${c.base-light};
      }

      #workspaces button {
          color: ${c.fg-dark};
          background-color: transparent;
          padding: 0 8px;
      }

      #workspaces button.focused {
          color: ${c.fg};
          box-shadow: inset 0 -3px ${c.base-light};
      }

      #scratchpad,
      #mode,
      #clock,
      #pulseaudio,
      #network,
      #backlight,
      #cpu,
      #memory,
      #battery
      {
          padding: 0 16px;
      }

      #workspaces
      {
          padding-right: 16px;
      }

      #workspaces,
      #scratchpad,
      #clock,
      #pulseaudio,
      #network,
      #backlight,
      #cpu,
      #memory,
      #battery
      {
          color: ${c.fg};
      }

      #mode {
          color: ${c.urgent};
      }

      #scratchpad,
      .modules-right > widget:nth-child(2n) {
          background-color: ${c.bg};
      }
    '';
  };
}
