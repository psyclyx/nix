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
    shell = pkgs.fish;
  };

  home-manager.users.alice = mkHome {
    name = userName;
    email = "me@psyclyx.xyz";
    modules = [
      ../../modules/home/base
      { services.syncthing.enable = lib.mkForce false; }
      ../../modules/home/programs/emacs
      ../../modules/home/programs/kitty.nix
      ./zsh.nix
      {
        home.sessionPath = [ "$HOME/bin" ];
      }
      {
        programs = {
          fish = {
            enable = true;
            shellInit = lib.optionalString pkgs.stdenv.isDarwin ''
              eval (/opt/homebrew/bin/brew shellenv)
            '';
            interactiveShellInit = ''
              set -g fish_key_bindings fish_vi_key_bindings
            '';
          };
          bash.enable = true;
          starship = {
            enable = true;
            enableTransience = true;
            enableZshIntegration = false;
            enableFishIntegration = true;
          };
        };
      }
    ];
  };

  nix-homebrew.user = userName;
}
