{pkgs, ...}: let
  userName = "psyc";
  userHome = "/Users/psyc";
in {
  security.pam.enableSudoTouchIdAuth = true;

  nix-homebrew.user = userName;

  users.users.psyc = {
    name = userName;
    home = userHome;
    shell = pkgs.zsh;
  };

  homebrew.casks = [
    "discord"
    "gimp"
    "orcaslicer"
    "remarkable"
    "signal"
  ];

  home-manager.users.psyc = import ../home/common.nix;
}
