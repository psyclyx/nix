{
  system,
  userName,
}: {
  nix-homebrew = {
    enable = true;
    enableRosetta = system == "aarch64-darwin";
    user = userName;
    mutableTaps = true;
    autoMigrate = true;
    taps = {
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
  };
}
