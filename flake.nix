{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";

    # Homebrew taps

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-conductorone = {
      url = "github:conductorone/cone";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
    nix-homebrew,
    homebrew-bundle,
    homebrew-cask,
    homebrew-core,
    homebrew-conductorone,
  } @ inputs: let
    supportedSystems = ["aarch64-darwin"];
    nixpkgsFor = nixpkgs.lib.genAttrs supportedSystems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            cljstyle = final.callPackage ./pkgs/cljstyle.nix {};
          })
        ];
      });
    mkDarwinConfiguration = import ./darwin {
      inherit inputs nixpkgsFor;
    };
  in rec
  {
    darwinConfigurations = {
      halo = mkDarwinConfiguration {
        system = "aarch64-darwin";
        hostName = "halo";
        module = ./darwin/halo.nix;
      };
      ampere = mkDarwinConfiguration {
        system = "aarch64-darwin";
        hostName = "ampere";
        module = ./darwin/ampere.nix;
      };
    };
    halo = darwinConfigurations.halo.system;
    ampere = darwinConfigurations.ampere.system;
  };
}
