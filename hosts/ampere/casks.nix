{
  inputs,
  lib,
  ...
}:
{
  nix-homebrew = {
    taps = with inputs; {
      "conductorone/cone" = homebrew-conductorone;
      "hashicorp/tap" = homebrew-hashicorp;
    };
  };

  homebrew.brews = [
    "conductorone/cone/cone"
    "docker-compose"
    "hashicorp/tap/vault"
    "tfenv"
  ];

  homebrew.casks = [
    "chromedriver"
    "docker"
    "firefox"
    "google-chrome"
    "slack"
    "zoom"
  ];
}
