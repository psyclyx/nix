{ ... }:

{
  services.nix-daemon.enable = true;

  users.users.psyc = {
    home =  "/Users/psyc";
  };

  home-manager.users.psyc = {
    home = { stateVersion = "23.11"; };
  };

}
