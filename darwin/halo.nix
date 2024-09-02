{pkgs, ...}: let
  userName = "psyc";
  userHome = "/Users/psyc";
in {
  security.pam.enableSudoTouchIdAuth = true;

  nix-homebrew.user = userName;

  homebrew.casks = [
    "discord"
    "gimp"
    "orcaslicer"
    "remarkable"
    "signal"
  ];

  users.users.psyc = {
    name = userName;
    home = userHome;
    shell = pkgs.zsh;
  };

  home-manager.users.psyc = ../home/common.nix;
}
