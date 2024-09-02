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
    mutableTaps = true;
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
    "font-sauce-code-pro-nerd-font"
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
