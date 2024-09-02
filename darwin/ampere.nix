{
  pkgs,
  homebrew-bundle,
  homebrew-core,
  homebrew-cask,
  ...
}: let
  hostName = "ampere";
  userName = "alice";
  userHome = "/Users/alice";
in {
  networking.hostName = hostName;
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

  users.users.alice = {
    name = userName;
    home = userHome;
    shell = pkgs.zsh;
  };

  home-manager.users.alice = {
    home.stateVersion = "23.11";
    imports = [
      ../programs/zsh
      ../programs/zsh/work.nix
      ../programs/nvim
    ];
  };
}
