{
  description = "nixos/nix-darwin configurations";

  inputs = {
    # ==== Core ====

    # Main package repository
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    #nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Nix user repository
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Simple NixOS modules for common hardware configurations
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # NixOS-esque configuration for Darwin (MacOS)
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS-esque configuration of home directories
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ==== Deploy ====

    # Declarative disk partitioning that doubles as NixOS config
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets decrypted at runtime, for NixOS/nix-darwin and home-manager
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ==== Programs ====

    # `nix-darwin` module to manage a homebrew installation
    # (`nix-darwin` can manage packages/casks from homebrew OOTB,
    #  but doesn't have support for installing homebrew itself)
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };

    # Track newer versions of `emacs` (NixOS) and its package repositories
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    # Track newer versions of `emacs` on Darwin
    nix-darwin-emacs = {
      url = "github:nix-giant/nix-darwin-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ==== Non-flakes ====

    # `zsh` prompt
    powerlevel10k = {
      url = "github:romkatv/powerlevel10k";
      flake = false;
    };

    # ---- Homebrew taps ----

    # Base taps
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
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;

      overlays = with inputs; [
        (import ./pkgs)
        nur.overlays.default
        nix-darwin-emacs.overlays.emacs
        emacs-overlay.overlays.default
      ];

      pkgsFor = system: inputs.nixpkgs.legacyPackages.${system};

      mkDevShell = import ./devshell.nix;
      mkDarwinConfiguration = import ./modules/darwin { inherit inputs overlays; };
      mkNixosConfiguration = import ./modules/nixos { inherit inputs overlays; };

      nixosConfigurations = {
        ix = mkNixosConfiguration {
          modules = [ ./hosts/ix ];
          system = "x86_64-linux";
        };
        omen = mkNixosConfiguration {
          modules = [ ./hosts/omen ];
          system = "x86_64-linux";
        };
        sigil = mkNixosConfiguration {
          modules = [ ./hosts/sigil ];
          system = "x86_64-linux";
        };
        tleilax = mkNixosConfiguration {
          modules = [ ./hosts/tleilax ];
          system = "x86_64-linux";
        };
      };

      darwinConfigurations = {
        halo = mkDarwinConfiguration {
          hostPlatform = "aarch64-darwin";
          system = "aarch64-darwin";
          hostName = "halo";
          modules = [ ./hosts/halo ];
        };
      };
    in
    {
      inherit darwinConfigurations nixosConfigurations;
      checks = lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (
        system:
        lib.mapAttrs' (name: config: (lib.nameValuePair "${name}" config.config.system.build.toplevel)) (
          (lib.filterAttrs (_: config: config.pkgs.system == system)) (
            nixosConfigurations // darwinConfigurations
          )
        )
      );

      devShells = lib.genAttrs [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ] (system: {
        default = mkDevShell (pkgsFor system);
      });
    };
}
