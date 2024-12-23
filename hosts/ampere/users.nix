{pkgs, ...}: let
  userName = "alice";
  userHome = "/Users/alice";
in {
  users.users.alice = {
    name = userName;
    home = userHome;
    shell = pkgs.zsh;
  };

  home-manager.users.alice.imports = [../../home/alice-ampere.nix];

  nix-homebrew.user = userName;
}
