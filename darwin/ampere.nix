{
  inputs,
  pkgs,
  lib,
  ...
}: let
  userName = "alice";
  userHome = "/Users/alice";
  inherit (inputs) homebrew-conductorone homebrew-hashicorp;
in {
  nix.envVars = {
    # Todo: use this + bin/setup-netskope to make a service that updates this file
    # Todo: find and set the equivalent env var for git, too
    #NIX_SSL_CERT_FILE = "/Library/Application Support/Netskope/STAgent/data/nscacert_combined.pem";
  };

  nix-homebrew = {
    user = userName;
    taps = {
      "conductorone/cone" = homebrew-conductorone;
      "hashicorp/tap" = homebrew-hashicorp;
    };
    mutableTaps = true;
  };

  homebrew.brews = [
    "hashicorp/tap/vault"
    "conductorone/cone/cone"
  ];

  homebrew.casks = [
    "slack"
    "docker"
    "chromedriver"
    "font-sauce-code-pro-nerd-font"
  ];

  environment.systemPackages = with pkgs; [
    awscli2
    mkcert
  ];

  users.users.alice = {
    name = userName;
    home = userHome;
    shell = pkgs.zsh;
  };

  home-manager.users.alice = {
    home.stateVersion = "23.11";
    imports = [
      ../home/modules/p10k-hm.nix
      ../config/tmux
      ../config/zsh
      ../config/zsh/work.nix
      ../config/nvim
    ];
  };
}
