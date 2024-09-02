{
  pkgs,
  darwin-emacs,
  darwin-emacs-packages,
  homebrew-bundle,
  homebrew-core,
  homebrew-cask,
  ...
}: let
  hostName = "halo";
  userName = "psyc";
  userHome = "/Users/psyc";
in {
  networking.hostName = "halo";
  security.pam.enableSudoTouchIdAuth = true;

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = userName;
    mutableTaps = true;
    taps = {
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
  };

  users.users.psyc = {
    name = userName;
    home = userHome;
    shell = pkgs.zsh;
  };

  home-manager.users.psyc = {
    home.stateVersion = "23.11";
    imports = [
      ../programs/zsh
      ../programs/nvim
    ];
  };
}
