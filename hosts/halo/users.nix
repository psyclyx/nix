{pkgs, ...}: let
  userName = "psyc";
  userHome = "/Users/psyc";
  mkHome = import ../../modules/home;
in {
  nix.settings.trusted-users = ["root" "@admin" userName];

  users.users.psyc = {
    name = userName;
    home = userHome;
    shell = pkgs.zsh;
  };

  home-manager.users.psyc = mkHome {
    name = userName;
    email = "me@psyclyx.xyz";
    modules = [
      ../../modules/home/base
      ../../modules/home/secrets
      ../../modules/home/programs/emacs
      ../../modules/home/programs/kitty.nix
      ../../modules/home/programs/signal.nix
    ];
  };

  nix-homebrew.user = userName;
}
