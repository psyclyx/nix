{
  config,
  lib,
  inputs,
  ...
}:
with lib;
  let
    inherit (inputs) powerlevel10k;

    cfg = config.programs.zsh.powerlevel10k;
    direnvCfg = config.programs.direnv;

    wrapDirenv = inner: ''
      (( ''${+commands[direnv]} )) && emulate zsh -c "''$(direnv export zsh)"
      ${inner}
      (( ''${+commands[direnv]} )) && emulate zsh -c "''$(direnv hook zsh)"
    '';

    instantPromptConfig = ''
      if [[ -r "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
  in {
    options.programs.zsh.powerlevel10k = {
      enable = mkEnableOption "Powerlevel10k zsh theme";

      instantPrompt = mkEnableOption "Whether to enable p10k's instant prompt";

      config = mkOption {
        type = types.attrsOf types.anything;
        default = {};
        example = "./path/to/your/.p10k.zsh";
        description = "Path to your Powerlevel10k configuration file (.p10k.zsh)";
      };

    };

    config =
      mkIf cfg.enable
      {
        # disable default direnv zsh integration

        warnings = optional (direnvCfg.enable && direnvCfg.enableZshIntegration) [
          ("programs.direnv.enable and programs.direnv.enableZshIntegration are both true. "
            + "p10k-hm is providing custom direnv integration for zsh. You probably want to disable direnv's integration.")
        ];

        home.file.".p10k-config.zsh" = cfg.config;

        programs.zsh = {
          initExtraFirst = mkBefore (
            # p10k friendly direnvZshIntegration replacement
            if direnvCfg.enable
            then wrapDirenv instantPromptConfig
            else instantPromptConfig
          );

          initExtra = ''
            source ${powerlevel10k}/powerlevel10k.zsh-theme
            source ~/.p10k-config.zsh
          '';
        };
      };
  }
