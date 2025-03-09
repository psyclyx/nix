{
  description = "nixos/nix-darwin configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-darwin = {
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
    inherit (inputs) nixpkgs nixpkgs-master nix-darwin-emacs emacs-overlay;
    inherit (nixpkgs) lib;

    overlays = [
      (import ./pkgs)
      nix-darwin-emacs.overlays.emacs
      emacs-overlay.overlays.default

      # Temporary - tailscale is currently broken in `unstable`, but works in `master`
      (final: prev: let
        system = prev.stdenv.hostPlatform.system;
      in {
        tailscale = nixpkgs-master.legacyPackages.${system}.tailscale;
      })
    ];

    mkDarwinConfiguration = import ./modules/platform/darwin {inherit inputs overlays;};
    mkNixosConfiguration = import ./modules/platform/nixos {inherit inputs overlays;};

    pkgsFor = system:
      import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
  in {
    devShells =
      lib.genAttrs
      ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"]
      (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            age
            alejandra
            nixd
            sops
            ssh-to-age
          ];
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
      tleilax = mkNixosConfiguration {
        hostPlatform = "x86_64-linux";
        hostName = "tleilax";
        modules = [./hosts/tleilax];
      };
      tleilax-iso = mkNixosConfiguration {
        hostPlatform = "x86_64-linux";
        hostName = "tleilax";
        modules = [
          ./modules/platform/nixos/iso.nix
          ./hosts/tleilax
        ];
      };
    };

    # For cache
    packages = {
      "aarch64-darwin".emacs = (pkgsFor "aarch64-darwin").emacs-30;
      "x86_64-linux".emacs = (pkgsFor "x86_64-linux").emacs30-pgtk;
    };
  };
}
