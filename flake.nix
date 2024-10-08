{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";

    mac-app-util.url = "github:hraban/mac-app-util";

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

    homebrew-hashicorp = {
      url = "github:hashicorp/homebrew-tap";
      flake = false;
    };

    homebrew-conductorone = {
      url = "github:conductorone/cone";
      flake = false;
    };

    homebrew-borkdude = {
      url = "github:borkdude/homebrew-brew";
      flake = false;
    };
  };

  outputs = inputs: let
    inherit (inputs) nixpkgs;
    overlays = [(import ./pkgs)];
    mkDarwinConfiguration = import ./darwin {inherit inputs overlays;};
    mkNixosConfiguration = import ./nixos {inherit inputs overlays;};
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
    nixosConfigurations = {
      omen = mkNixosConfiguration {
        hostPlatform = "x86_64-linux";
        hostName = "omen";
        modules = [./nixos/omen];
      };
    };
    halo = darwinConfigurations.halo.system;
    ampere = darwinConfigurations.ampere.system;
    omen = nixosConfigurations.omen.system;
  };
}
