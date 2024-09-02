{pkgs, homebrew-bundle, homebrew-core, homebrew-cask, ...}:

let
  hostName = "ampere";
  userName = "alice";
  userHome = "/Users/alice";
in
{
  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = userName;
    mutableTaps = true;
    autoMigrate = true;
    taps = {
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
  };

  networking.hostName = hostName;

  services.nix-daemon.enable = true;

  programs.direnv.enable = true;

  environment.systemPackages = with pkgs; [ jq clojure tmux ];

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
