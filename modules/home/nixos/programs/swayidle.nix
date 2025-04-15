{ pkgs, ... }:
let
  swaylock = pkgs.swaylock;
in
{
  home.packages = [ swaylock ];
  services = {
    swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${swaylock}/bin/swaylock";
        }
        {
          event = "lock";
          command = "${swaylock}/bin/swaylock";
        }
      ];
    };
  };
}
