{...}: let
  c = import ../../../colors.nix;
in {
  programs.waybar = {
    style = ''
      * {
          font-family: NotoMono Nerd Font;
          font-size: 18px;
      }

      window#waybar {
          color: ${c.fg-dark};
          background-color: ${c.bg-alt};
      }

      widget > * {
          padding: 0px 16px;
      }

      widget:nth-child(2n+1) {
          background-color: ${c.bg};
          color: ${c.fg};
      }

      window, #workspaces {
          margin-bottom: 0;
          padding-bottom: 0;
      }

      button {
          box-shadow: inset 0 -3px transparent;
          margin-bottom: -3px;
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

    '';
  };
}
