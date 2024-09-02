{
  system,
  inputs,
  ...
}: let
  inherit (inputs) homebrew-bundle homebrew-core homebrew-cask;
in {
  nix-homebrew = {
    enable = true;
    enableRosetta = system == "aarch64-darwin";
    mutableTaps = false;
    autoMigrate = true;
    taps = {
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
  };
}
