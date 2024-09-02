{
  inputs,
  pkgs,
  ...
}: let
  userName = "alice";
  userHome = "/Users/alice";
  inherit (inputs) homebrew-conductorone homebrew-hashicorp;
in {
  nix-homebrew = {
    user = userName;
    taps = {
      "conductorone/cone" = homebrew-conductorone;
      "hashicorp/tap" = homebrew-hashicorp;
    };
  };

  homebrew.brews = [
    "hashicorp/tap/vault"
    "conductorone/cone/cone"
    "docker-compose"
    "tfenv"
  ];

  homebrew.casks = [
    "slack"
    "google-chrome"
    "docker"
    "chromedriver"
  ];

  environment.systemPackages = with pkgs; [
    awscli2
    azure-cli
    kubelogin
    mkcert
  ];

  users.users.alice = {
    name = userName;
    home = userHome;
    shell = pkgs.zsh;
  };

  home-manager.users.alice = import ../home/work.nix;
}
