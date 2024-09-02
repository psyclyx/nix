{pkgs, homebrew-bundle, homebrew-core, homebrew-cask, ...}:

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
    user = "psyc";
    mutableTaps = false;
    taps = {
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    casks = [
      "alfred"
    ];
  };

  networking.hostName = "halo";

  services.nix-daemon.enable = true;

  users.users.psyc = {
    name = "psyc";
    home = "/Users/psyc";
    shell = "zsh";
  };

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [ htop kitty ];

  home-manager.users.psyc = {
    home.stateVersion = "23.11";
    imports = [
      ../programs/zsh
      ../programs/kitty.nix 
    ];
  };
}
