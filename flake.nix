{
  description = "nixos/nix-darwin configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rycee-nurpkgs = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin-emacs = {
      url = "github:nix-giant/nix-darwin-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";

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

    powerlevel10k = {
      url = "github:romkatv/powerlevel10k";
      flake = false;
    };
  };

  outputs = inputs: let
    inherit (inputs) nixpkgs nix-darwin-emacs emacs-overlay nur;
    inherit (nixpkgs) lib;

    overlays = [
      (import ./pkgs)
      nix-darwin-emacs.overlays.emacs
      emacs-overlay.overlays.package
      nur.overlays.default
    ];

    mkDarwinConfiguration = import ./modules/platform/darwin {inherit inputs overlays;};
    mkNixosConfiguration = import ./modules/platform/nixos {inherit inputs overlays;};
  in {
    devShells =
      lib.genAttrs
      ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"]
      (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {
          packages = [pkgs.sops pkgs.nixd pkgs.alejandra];
        };
      });

    overlays.default = import ./pkgs;

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
