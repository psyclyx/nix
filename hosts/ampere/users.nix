{pkgs, lib, ...}: let
  userName = "alice";
  userHome = "/Users/alice";
  mkHome = import ../../modules/home;
in {
  nix.settings.trusted-users = ["root" "@admin" userName];

  users.users.alice = {
    name = userName;
    home = userHome;
    shell = pkgs.zsh;
  };

  home-manager.users.alice = mkHome {
    name = userName;
    email = "me@psyclyx.xyz";
    modules = [
      ../../modules/home/base
      {services.syncthing.enable = lib.mkForce false;}
      ../../modules/home/programs/emacs
      ../../modules/home/programs/kitty.nix
      ./zsh.nix
    ];
  };

  nix-homebrew.user = userName;
}
