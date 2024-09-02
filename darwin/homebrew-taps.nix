{config, ...}: {
  homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
}
