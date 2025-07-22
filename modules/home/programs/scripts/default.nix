{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.psyclyx.programs.scripts;
  upscale-image = pkgs.writeShellApplication {
    name = "upscale-image";
    runtimeInputs = [ pkgs.nodejs ];
    text = ''
      REPLICATE_API_TOKEN=$(< ${config.sops.secrets.replicate.path})
      export REPLICATE_API_TOKEN
      node ${./upscale-image.js} "$@"
    '';
  };

in
{
  options.psyclyx.programs.scripts = {
    upscale-image = lib.mkEnableOption "upscale with replicate";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.upscale-image {
      home.packages = [ upscale-image ];
    })
  ];
}
