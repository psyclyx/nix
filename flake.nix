{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Emacs

    darwin-emacs = {
      url = "github:c4710n/nix-darwin-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spacebar
    spacebar.url = "github:cmacrae/spacebar";

    # Homebrew

    darwin-emacs-packages = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Homebrew taps

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

  outputs = inputs@{
    self,
    nixpkgs,
    darwin,
    home-manager,
    darwin-emacs,
    darwin-emacs-packages,
    spacebar,
    nix-homebrew,
    homebrew-bundle,
    homebrew-core,
    homebrew-cask
  }:
  rec {
    darwinConfigurations = (
      import ./darwin {
        inherit
          inputs
          nixpkgs

          darwin
          home-manager

          darwin-emacs
          darwin-emacs-packages

          spacebar

          nix-homebrew
          homebrew-bundle
          homebrew-core
          homebrew-cask;
      }
    );
    halo = darwinConfigurations.halo.system;
  };
}
