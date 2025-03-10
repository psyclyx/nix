{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkEnableOption types;
  ansiColorType = types.enum [
    "reset"
    "black"
    "red"
    "green"
    "yellow"
    "blue"
    "magenta"
    "cyan"
    "gray"
    "darkgray"
    "lightred"
    "lightgreen"
    "lightyellow"
    "lightblue"
    "lightmagenta"
    "lightcyan"
    "white"
  ];

  validComponents = [
    "text"
    "time"
    "container"
    "title"
    "greet"
    "prompt"
    "input"
    "action"
    "button"
  ];

  themeType = types.either types.str (types.attrsOf ansiColorType);

  themeToString = theme: let
    keys = lib.filter (k: builtins.elem k validComponents) (lib.attrNames theme);
  in
    lib.concatStringsSep ";" (lib.map (k: k + "=" + theme.${k}) keys);

  resolveTheme = theme:
    if builtins.typeOf theme == "set"
    then themeToString theme
    else theme;

  cfg = config.services.greetd.tuigreet;
in {
  options = {
    enable = mkEnableOption "Use Tuigreet as greetd's default session";

    services.greetd.tuigreet = {
      package = lib.mkPackageOption pkgs "greetd.tuigreet" {};

      debug = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/tmp/tuigreet.log";
        description = "Enable debug logging to the provided file";
      };

      cmd = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "${pkgs.sway}/bin/sway";
        description = "Command to run";
      };

      env = mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = {"SDL_VIDEODRIVER" = "WAYLAND";};
        description = "Environment variables to run the default session with";
      };

      sessions = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of Wayland session paths";
      };

      session-wrapper = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Wrapper command to initialize the non-X11 session";
      };

      xsessions = mkOption {
        type = types.listOf types.string;
        default = [];
        description = "List of X11 session paths";
      };

      xsession-wrapper = mkOption {
        type = types.str;
        example = "startx /usr/bin/env";
        description = "Wrapper command to initialize X server and launch X11";
      };

      no-xsession-wrapper = mkEnableOption "Do not wrap commands for X11 sessions";

      width = mkOption {
        type = types.nullOr types.ints.positive;
        default = null;
        example = 80;
        description = "Width of the main prompt";
      };

      issue = mkEnableOption "Show the host's issue file";

      greeting = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Show custom text above login prompt";
      };

      time = mkEnableOption "Display the current date and time";

      time-format = mkOption {
        type = types.nullOr types.str;
        description = "Custom strftime format for displaying date and time";
      };

      remember = mkEnableOption "Remember last logged-in username";

      remember-session = mkEnableOption "Remember last selected session";

      remember-user-session = mkEnableOption "Remember last selection of users from a menu";

      user-menu = mkEnableOption "Allow graphical selection of users from a menu";

      user-menu-min-uid = mkOption {
        type = types.nullOr types.ints.positive;
        default = null;
        example = 1000;
        description = "Minimum UID to display in the user selection menu";
      };

      user-menu-max-uid = mkOption {
        type = types.nullOr types.ints.positive;
        default = null;
        example = 60000;
        description = "Maximum UID to display in the user selection menu";
      };

      theme = mkOption {
        type = types.nullOr themeType;
        default = null;
        example = {
          border = "magenta";
          text = "cyan";
          prompt = "green";
          time = "red";
          action = "blue";
          button = "yellow";
          container = "black";
          input = "red";
        };
        description = "Define the application theme color";
      };

      asterisks = mkEnableOption "Display asterisks when a secret is typed";

      asterisks-char = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "*";
        description = "characters to be used to redact secrets";
      };

      window-padding = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 0;
        description = "Padding inside the terminal area";
      };

      container-padding = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 1;
        description = "Padding inside the main prompt container";
      };

      greet-align = mkOption {
        type = types.nullOr types.enum ["left" "center" "right"];
        default = null;
        example = "center";
        description = "Alignment of the greeting text in the main prompt";
      };

      power-shutdown = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Command to run to shut down the system";
      };

      power-reboot = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Command to run to reboot the system";
      };

      power-no-setsid = mkEnableOption "Do not preface power commands with setsid";

      kb-command = mkOption {
        type = types.nullOr (types.intsBetween 1 12);
        default = null;
        description = "F-key to use to open the command menu";
      };

      kb-sessions = mkOption {
        type = types.nullOr (types.intsBetween 1 12);
        default = null;
        description = "F-key to use to open the sessions menu";
      };

      kb-power = mkOption {
        type = types.nullOr (types.intsBetween 1 12);
        default = null;
        description = "F-key to use to open the power menu";
      };
    };
  };

  config.warnings = lib.mkIf cfg.enable (let
    minimalConfig = lib.nameValuePair "minimalConfig" {
      package = pkgs.hello;
      cmd = "sway";
    };

    themeConfig = lib.nameValuePair "themeConfig" {
      package = pkgs.hello;
      cmd = "sway";
      theme = {
        text = "cyan";
        border = "magenta";
      };
    };

    envConfig = lib.nameValuePair "envConfig" {
      package = pkgs.hello;
      cmd = "sway";
      env = {
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_TYPE = "wayland";
      };
    };

    flagsConfig = lib.nameValuePair "flagsConfig" {
      package = pkgs.hello;
      cmd = "sway";
      issue = true;
      time = true;
      remember = true;
    };

    testConfigs = [
      minimalConfig
      themeConfig
      envConfig
      flagsConfig
    ];

    testResults =
      lib.mapAttrs
      (
        name: testCfg:
          "${testCfg.package}/bin/tuigreet "
          + (lib.cli.toGNUCommandLine {}
            (lib.filterAttrs (n: v: v != null) {
              inherit (testCfg) cmd;

              theme =
                if testCfg ? theme
                then resolveTheme testCfg.theme
                else null;

              env =
                if testCfg ? env && testCfg.env != {}
                then
                  lib.concatStringsSep ","
                  (lib.mapAttrsToList (name: value: "${name}=${value}") testCfg.env)
                else null;

              issue =
                if testCfg ? issue && testCfg.issue
                then true
                else null;
              time =
                if testCfg ? time && testCfg.time
                then true
                else null;
              remember =
                if testCfg ? remember && testCfg.remember
                then true
                else null;
            }))
      )
      (lib.listToAttrs testConfigs);

    expectedOutputs = {
      minimalConfig = "${pkgs.hello}/bin/tuigreet --cmd sway";
      themeConfig = "${pkgs.hello}/bin/tuigreet --cmd sway --theme text=cyan;border=magenta";
      envConfig = "${pkgs.hello}/bin/tuigreet --cmd sway --env SDL_VIDEODRIVER=wayland,XDG_SESSION_TYPE=wayland";
      flagsConfig = "${pkgs.hello}/bin/tuigreet --cmd sway --issue --time --remember";
    };

    testWarnings =
      lib.mapAttrsToList
      (name: expected:
        if testResults.${name} != expected
        then "TEST FAILED [${name}]: Expected '${expected}' but got '${testResults.${name}}'"
        else null)
      expectedOutputs;
  in
    lib.filter (x: x != null) testWarnings);

  config.services.greetd.tuigreet.command = lib.mkIf cfg.enable (
    "${cfg.package}/bin/tuigreet "
    + (lib.cli.toGNUCommandLine {}
      (lib.filterAttrs (n: v: v != null) {
        inherit
          (cfg)
          debug
          cmd
          session-wrapper
          xsession-wrapper
          no-xsession-wrapper
          width
          issue
          greeting
          time
          time-format
          remember
          remember-session
          remember-user-session
          user-menu
          user-menu-min-uid
          user-menu-max-uid
          asterisks
          asterisks-char
          window-padding
          container-padding
          greet-align
          power-shutdown
          power-reboot
          power-no-setsid
          kb-command
          kb-sessions
          kb-power
          ;

        sessions = lib.optionalString (cfg.sessions != []) (lib.concatStringsSep ":" cfg.sessions);
        xsessions = lib.optionalString (cfg.xsessions != []) (lib.concatStringsSep ":" cfg.xsessions);

        theme = lib.optionalString (cfg.theme != null) (resolveTheme cfg.theme);

        env =
          lib.optionalString (cfg.env != {})
          (lib.concatStringsSep ","
            (lib.mapAttrsToList (name: value: "${name}=${value}") cfg.env));
      }))
  );
}
