{
  pkgs,
  config,
  ...
}: let
  c = import ../colors.nix;
in {
  programs.rofi = {
    enable = true;
    font = "Fira Code Nerd Font 12";
    package = pkgs.rofi-wayland;
    extraConfig = {
      case-sensitive = false;
      display-drun = "Apps: ";
      modi = [
        "drun"
        "filebrowser"
        "run"
      ];
      show-icons = true;
    };

    plugins = [pkgs.rofi-file-browser];
    theme = let
      mkLiteral = config.lib.formats.rasi.mkLiteral;
    in {
      "*" = {
        bg = mkLiteral c.base;
        fg = mkLiteral c.fg;
        ac = mkLiteral c.accent;
        background-color = mkLiteral "transparent";
      };

      "#window" = {
        background-color = mkLiteral "@bg";
        location = mkLiteral "center";
        width = mkLiteral "30%";
      };

      "#prompt" = {
        text-color = mkLiteral "@fg";
      };

      "#textbox-prompt-colon" = {
        text-color = mkLiteral "@fg";
      };

      "#entry" = {
        text-color = mkLiteral "@fg";
        blink = mkLiteral "true";
      };

      "#inputbar" = {
        children = mkLiteral "[ prompt, entry ]";
        text-color = mkLiteral "@fg";
        padding = mkLiteral "3px";
      };

      "#listview" = {
        columns = mkLiteral "1";
        lines = mkLiteral "8";
        cycle = mkLiteral "true";
        dynamic = mkLiteral "true";
      };

      "#mainbox" = {
        border = mkLiteral "1px";
        border-color = mkLiteral "@ac";
        children = mkLiteral "[ inputbar, listview ]";
        padding = mkLiteral "10px";
      };

      "#element" = {
        text-color = mkLiteral "@fg";
        padding = mkLiteral "3px";
      };

      "#element-icon" = {
        text-color = mkLiteral "@fg";
        size = mkLiteral "16px";
      };

      "#element-text" = {
        text-color = mkLiteral "@fg";
        padding = mkLiteral "3px";
      };

      "#element selected" = {
        border = mkLiteral "1px";
        border-color = mkLiteral "@ac";
        text-color = mkLiteral "@fg";
        background-color = mkLiteral "@ac";
      };
    };
  };
}
