{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs) nix-homebrew homebrew-bundle homebrew-core homebrew-cask;
  inherit (pkgs.stdenv) hostPlatform;
in {
  imports = [nix-homebrew.darwinModules.nix-homebrew];

  homebrew = {
    enable = true;

    caskArgs.no_quarantine = true;

    global.autoUpdate = false;

    onActivation = {
      upgrade = true;
      autoUpdate = false;
      cleanup = "zap";
    };

    taps = builtins.attrNames config.nix-homebrew.taps;
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = hostPlatform.isAarch64;
    mutableTaps = lib.mkDefault false;
    autoMigrate = true;
    taps = {
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
  };
}