{
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs) homebrew-bundle homebrew-core homebrew-cask;
  inherit (pkgs.stdenv) hostPlatform;
in {
  nix-homebrew = {
    enable = true;
    enableRosetta = hostPlatform.isAarch64;
    mutableTaps = false;
    autoMigrate = true;
    taps = {
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
  };
}
