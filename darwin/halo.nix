{ pkgs ... }

{
  users.users.psyc = {
    home =  "/Users/psyc";
    shell = pkgs.zsh;
  };

  programs = {
    zsh.enable = true;
  };

  services = {
    nix-daemon.enable = true;
  };

  home-manager.users.psyc = {
    home = { stateVersion = "23.11" };
  };

  programs = {
    zsh = {
      enable = true;
    };
  };
}
