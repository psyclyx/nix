{
  inputs,
  nixpkgs,
  darwin,
  home-manager,
  darwin-emacs,
  darwin-emacs-packages,
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
        home-manager.useUserPackages = true;
      }
    ];
  };
}
