{...}: let
  c = import ../../../colors.nix;
in {
  programs.waybar = {
    style = ''
      * {
          padding: 0;
          margin: 0;
          border: none;
          min-height: 0;
          box-shadow: none;
          border-radius: 0;
      }

      window#waybar {
          font-family: NotoMono Nerd Font Propo;
          color: ${c.fg-dark};
          background-color: ${c.bg-alt};
      }


      widget > * {
          padding: 0px 16px;
      }

      widget:first-child > * {
          padding-left: 4px;
      }

      widget:last-child > * {
          padding-right: 4px;
      }

      widget:nth-child(2n+1) {
          background-color: ${c.bg};
          color: ${c.fg};
      }

      window, #workspaces {
          margin-bottom: 0;
          padding-bottom: 0;
      }

      button:hover {
          box-shadow: none;
          text-shadow: none;
          background: inherit;
          transition: none;
          color: inherit;
      }

      #workspaces button:not(:first-child) {
          margin-left: 16px;
      }

      #workspaces button {
          color: ${c.fg-darker};
      }

      #workspaces button.focused {
          color: ${c.fg};
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
