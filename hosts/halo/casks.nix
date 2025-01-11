{inputs, ...}: {
  nix-homebrew = {
    taps = with inputs; {
      "homebrew/bundle" = homebrew-bundle;
      "homebrew/core" = homebrew-core;
      "homebrew/cask" = homebrew-cask;
    };
  };
  homebrew.casks = [
    "firefox"
    "orcaslicer"
  ];
}
