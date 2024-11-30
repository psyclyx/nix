{pkgs, ...}: let
  userName = "psyc";
  userHome = "/Users/psyc";
in {
  users.users.psyc = {
    name = userName;
    home = userHome;
    shell = pkgs.zsh;
  };

  home-manager.users.psyc.imports = [../../home/psyc-halo.nix];

  nix-homebrew.user = userName;
}
