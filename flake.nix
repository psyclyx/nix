{
  description = "System flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://psyclyx.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "psyclyx.cachix.org-1:UFwKXEDn3gLxIW9CeXGdFFUzCIjj8m6IdAQ7GA4XfCk="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=7acb98dcc9daad82f57d8382ef89597b808ff193";

    nur.url = "github:nix-community/NUR";

    rycee-nurpkgs = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin-emacs = {
      url = "github:nix-giant/nix-darwin-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # used for patches
    homebrew-emacs-plus = {
      url = "github:d12frosted/homebrew-emacs-plus";
      flake = false;
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";

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

    homebrew-nikitabobko = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
  };

  outputs = inputs: let
    inherit (inputs) self nixpkgs nix-darwin-emacs emacs-overlay nur;
    inherit (nixpkgs) lib;

    supportedSystems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"];
    forAllSystems = lib.genAttrs supportedSystems;

    overlays = [
      (import ./pkgs)
      nix-darwin-emacs.overlays.emacs
      emacs-overlay.overlays.package
      nur.overlays.default
    ];

    mkDarwinConfiguration = import ./modules/darwin {inherit inputs overlays;};
    mkNixosConfiguration = import ./modules/nixos {inherit inputs overlays;};
  in {
    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = [pkgs.sops pkgs.nixd pkgs.alejandra];
      };
    });

    overlays = {
      "aarch64-darwin" = {
        default = import ./pkgs;
      };
      "x86_64-linux" = {
        default = final: prev: prev;
      };
      "x86_64-darwin" = {
        default = final: prev: prev;
      };
    };

    darwinConfigurations = {
      halo = mkDarwinConfiguration {
        hostPlatform = "aarch64-darwin";
        system = "aarch64-darwin";
        hostName = "halo";
        modules = [./hosts/halo];
      };
      ampere = mkDarwinConfiguration {
        hostPlatform = "aarch64-darwin";
        system = "aarch64-darwin";
        hostName = "ampere";
        modules = [./hosts/ampere];
      };
    };

    nixosConfigurations = {
      omen = mkNixosConfiguration {
        hostPlatform = "x86_64-linux";
        hostName = "omen";
        modules = [./hosts/omen];
      };
      sigil = mkNixosConfiguration {
        hostPlatform = "x86_64-linux";
        hostName = "sigil";
        modules = [./hosts/sigil];
      };
      ix = mkNixosConfiguration {
        hostPlatform = "x86_64-linux";
        hostName = "ix";
        modules = [./hosts/ix];
      };
    };
  };
}
