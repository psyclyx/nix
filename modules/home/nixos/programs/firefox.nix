{ pkgs, ... }:
{
  config = {
    programs = {
      firefox = {
        enable = true;
        package = pkgs.firefox-bin; # throws on darwin
      };
    };
  };
}
