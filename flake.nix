{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    ## Homebrew

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs @ {
    darwin,
    home-manager,
    homebrew-bundle,
    homebrew-cask,
    homebrew-core,
    nix-homebrew,
    nixpkgs,
    self,
  }: let
    cljstyle-overlay = final: prev: {
      cljstyle = final.callPackage ./pkgs/cljstyle.nix {};
    };
    overlays = [cljstyle-overlay];
  in rec {
    darwinConfigurations = (
      import ./darwin {
        inherit
          darwin
          home-manager
          homebrew-bundle
          homebrew-cask
          homebrew-core
          inputs
          nix-homebrew
          nixpkgs
          overlays
          ;
      }
    );
    halo = darwinConfigurations.halo.system;
    ampere = darwinConfigurations.ampere.system;
  };
}
