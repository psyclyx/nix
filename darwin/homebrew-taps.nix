# Workaround for https://github.com/zhaofengli/nix-homebrew/issues/16
{config, ...}: {
  homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
}
