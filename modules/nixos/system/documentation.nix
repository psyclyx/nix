{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.psyclyx.documentation;
in
{
  options = {
    psyclyx.documentation = {
      enable = mkEnableOption "documentation generation";
    };
  };

  config = mkIf cfg.enable {
    documentation = {
      enable = true;

      dev.enable = true;
      doc.enable = true;
      info.enable = true;
      nixos = {
        enable = true;
        includeAllModules = true;
      };
    };
  };
}
