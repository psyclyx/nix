{inputs, lib, ...}: {
  nix-homebrew = {
    taps = with inputs; {
      "homebrew/bundle" = homebrew-bundle;
      "homebrew/core" = homebrew-core;
      "homebrew/cask" = homebrew-cask;
      "conductorone/cone" = homebrew-conductorone;
      "hashicorp/tap" = homebrew-hashicorp;
      "borkdude/brew" = homebrew-borkdude;
    };
  };

  homebrew.brews = [
    "borkdude/brew/jet"
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
