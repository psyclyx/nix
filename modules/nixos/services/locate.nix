{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.psyclyx.services.locate;
in
{
  options = {
    psyclyx = {
      services = {
        locate = {
          enable = lib.mkEnableOption "Locate service";
          users = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Users to put in the locate group";
          };
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      locate = {
        enable = true;
        package = pkgs.mlocate;
        interval = "hourly";
        pruneNames = [".cache" ".git" "result" ".cargo" ".julia"];
      };
    };
    users = {
      groups = {
        mlocate = {
          members = cfg.users;
        };
      };
    };
  };
}
