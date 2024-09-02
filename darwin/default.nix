{
  inputs,
  nixpkgs,
  darwin,
  home-manager,
  nix-homebrew,
  homebrew-bundle,
  homebrew-core,
  homebrew-cask,
  ...
}: let
  system = "aarch64-darwin";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in {
  halo = darwin.lib.darwinSystem rec {
    inherit system;
    specialArgs = {inherit pkgs homebrew-bundle homebrew-core homebrew-cask;};
    modules = [
      home-manager.darwinModules.home-manager
      nix-homebrew.darwinModules.nix-homebrew
      ./common.nix
      ./halo.nix
      ./link-apps.nix
    ];
  };

  ampere = darwin.lib.darwinSystem rec {
    inherit system;
    specialArgs = {inherit pkgs homebrew-bundle homebrew-core homebrew-cask;};
    modules = [
      home-manager.darwinModules.home-manager
      nix-homebrew.darwinModules.nix-homebrew
      ./common.nix
      ./ampere.nix
    ];
  };
}
