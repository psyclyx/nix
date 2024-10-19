{...}: let
  c = import ../../../colors.nix;
in {
  programs.waybar = {
    style = ''
      * {
          font-family: NotoMono Nerd Font Mono;
          font-size: 14px;
      }

      window#waybar {
          background-color: transparent;
          color: ${c.fg};
      }

      .modules-left,
      .modules-right,
      .modules-center
      {
          min-width: 64px;
          margin: 0px 24px;
      }

      widget {
          padding: 0px 16px;
          min-width: 64px;
          margin: 0px 32px;
          border-radius: 10px;
          background-color: ${c.bg-alt};
      }

      window, #workspaces {
          margin-bottom: 0;
          padding-bottom: 0;
      }

      button {
          box-shadow: inset 0 -3px transparent;
          padding-bottom: 0;
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

      #workspaces button.flat {
          border: none;
          color: ${c.fg-dark};
          border: none;
          border-radius: 0px;
          background-color: transparent;
          padding: 0 8px;
      }

      #workspaces button.focused {
          color: ${c.fg};
          border: none;
          box-shadow: inset 0 -3px ${c.base-light};
      }

      #cpu {
          padding-right: 2px;
          padding-left: 2px;
      }

      #scratchpad,
      #mode,
      #clock,
      #pulseaudio
      {
          padding: 0 10px;
      }

      #battery
      {
          padding-left: 10px;
          padding-right: 4px;
      }

      #network,
      #memory,
      #backlight
      {
          padding-left: 10px;
          padding-right: 18px;
      }

      #workspaces
      {
          padding-right: 8px;
      }

      #mode {
          color: ${c.urgent};
      }

      #battery.warning {
          color: ${c.red1};
      }


      #battery.critical {
          color: ${c.red3};
      }


      #battery.good, #battery.full {
          color: ${c.slate4};
      }

      #scratchpad,
      .modules-right > widget:nth-child(2n) {
          background-color: ${c.bg};
          color: ${c.fg-dark};
      }
    '';
  };
}
