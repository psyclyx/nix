{pkgs, ...}: {
  users = {
    users = {
      psyc = {
        name = "psyc";
        home = "/home/psyc";
        shell = pkgs.zsh;
        isNormalUser = true;
        extraGroups = ["wheel" "builders"];
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwUKqMso49edYpzalH/BFfNlwmLDmcUaT00USWiMoFO me@psyclyx.xyz"];
      };
    };
  };
  home-manager = {
    users = {
      psyc = {
        imports = [
          {home.stateVersion = "23.11";}
          ../../modules/home/programs/git.nix
          ../../modules/home/programs/nvim
          ../../modules/home/programs/zsh
          ../../modules/home/services/ssh-agent.nix
        ];
      };
    };
  };
}
