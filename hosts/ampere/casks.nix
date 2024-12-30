{inputs, lib, ...}: {
  nix-homebrew = {
    taps = with inputs; {
      "conductorone/cone" = homebrew-conductorone;
      "hashicorp/tap" = homebrew-hashicorp;
      "borkdude/brew" = homebrew-borkdude;
    };
  };

  homebrew.casks = [
    "firefox"
    "zoom"
    "slack"
  ];
}
