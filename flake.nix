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

    powerlevel10k = {
      url = "github:romkatv/powerlevel10k";
      flake = false;
    };

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

  outputs = {nixpkgs, ...} @ inputs: let
    overlays = [(import ./pkgs)];
    mkDarwinConfiguration = import ./darwin {inherit inputs overlays;};
  in rec
  {
    darwinConfigurations = {
      halo = mkDarwinConfiguration {
        hostPlatform = "aarch64-darwin";
        hostName = "halo";
        modules = [./darwin/halo.nix];
      };
      ampere = mkDarwinConfiguration {
        hostPlatform = "aarch64-darwin";
        hostName = "ampere";
        modules = [./darwin/ampere.nix];
      };
    };
    halo = darwinConfigurations.halo.system;
    ampere = darwinConfigurations.ampere.system;
  };
}
