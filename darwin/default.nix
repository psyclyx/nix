{
  inputs,
  nixpkgs,
  darwin,
  home-manager,
  darwin-emacs,
  darwin-emacs-packages,
  spacebar,
  nix-homebrew,
  homebrew-bundle,
  homebrew-core,
  homebrew-cask,
  ...
}:

let
  system = "aarch64-darwin";
  pkgs = import nixpkgs { 
           inherit system;
           overlays = [
             darwin-emacs.overlays.emacs
             darwin-emacs-packages.overlays.package
     	     spacebar.overlay
           ];
  };
in
{
  halo = darwin.lib.darwinSystem rec {
    inherit system;
    specialArgs = { inherit pkgs homebrew-bundle homebrew-core homebrew-cask; };
    modules = [
      home-manager.darwinModules.home-manager
      nix-homebrew.darwinModules.nix-homebrew
      ./halo.nix
      ./link-apps.nix
      {
        home-manager.useGlobalPkgs = true;
      }
    ];
  };

  ampere = darwin.lib.darwinSystem rec {
    inherit system;
    specialArgs = { inherit pkgs homebrew-bundle homebrew-core homebrew-cask; };
    modules = [
      home-manager.darwinModules.home-manager
      nix-homebrew.darwinModules.nix-homebrew
      ./ampere.nix
      {
        home-manager.useGlobalPkgs = true;
      }
    ];
  };
}
