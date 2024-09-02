{pkgs, ...}:

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

  networking.hostName = "halo";

  services.nix-daemon.enable = true;

  users.users.psyc = {
    name = "psyc";
    home = "/Users/psyc";
  };

  home-manager.users.psyc = {
    home.stateVersion = "23.11";
    imports = [ ../modules/zsh ];
  };
}
