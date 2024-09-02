{
  inputs,
  pkgs,
  ...
}: let
  userName = "alice";
  userHome = "/Users/alice";
  inherit (inputs) homebrew-conductorone;
in {
  nix.envVars = {
    # Todo: use this + bin/setup-netskope to make a service that updates this file
    # Todo: find and set the equivalent env var for git, too
    #NIX_SSL_CERT_FILE = "/Library/Application Support/Netskope/STAgent/data/nscacert_combined.pem";
  };

  nix-homebrew = {
    user = userName;
    taps = {"condutorone/cone" = homebrew-conductorone;};
  };

  environment.systemPackages = with pkgs; [
    awscli2
    mkcert
    vault
  ];

  users.users.alice = {
    name = userName;
    home = userHome;
    shell = pkgs.zsh;
  };

  home-manager.users.alice = {
    home.stateVersion = "23.11";
    imports = [
      ../config/tmux
      ../config/zsh
      ../config/zsh/work.nix
      ../config/nvim
    ];
  };
}
