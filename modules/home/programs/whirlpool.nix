{
  path = [ "psyclyx" "home" "programs" "whirlpool" ];
  description = "Whirlpool River window manager";
  config = { lib, pkgs, ... }: {
    services.whirlpool = {
      enable = true;
      package = pkgs.psyclyx.whirlpool;
    };
  };
}
