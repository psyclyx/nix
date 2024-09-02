{pkgs, homebrew-bundle, homebrew-core, homebrew-cask, ...}:

let
  userName = "psyc";
  userHome = "/Users/psyc";
in
{
  environment.systemPackages = with pkgs; [ htop kitty ];

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
    mutableTaps = false;
    taps = {
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
  };

  networking.hostName = "halo";

  services.nix-daemon.enable = true;
  services.link-apps = {
    enable = true;
    inherit userName userHome;
  };


  users.users.psyc = {
    name = userName;
    home = userHome;
    shell = "zsh";
  };

  programs.zsh.enable = true;

  home-manager.users.psyc = {
    home.stateVersion = "23.11";
    imports = [
      ../programs/zsh
      ../programs/kitty.nix 
    ];
  };
}
