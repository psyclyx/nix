{
  pkgs,
  lib,
  ...
}:
let
  userName = "alice";
  userHome = "/Users/alice";
  mkHome = import ../../modules/home;
in
{
  nix.settings.trusted-users = [
    "root"
    "@admin"
    userName
  ];

  users.knownUsers = [ userName ];
  users.users.alice = {
    name = userName;
    uid = 501;
    home = userHome;
    shell = pkgs.zsh;
  };

  home-manager.users.alice = mkHome {
    name = userName;
    email = "me@psyclyx.xyz";
    modules = [
      ../../modules/home/base
      { services.syncthing.enable = lib.mkForce false; }
      ../../modules/home/programs/emacs
      ../../modules/home/programs/kitty.nix
      ../../modules/home/programs/alacritty.nix
      ./zsh.nix
    ];
  };

  nix-homebrew.user = userName;
}
