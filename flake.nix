{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

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
    supportedSystems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"];
    forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

    overlays = [
      (import ./pkgs)
      (import ./overlays/wezterm.nix inputs.wezterm)
      inputs.emacs-overlay.overlays.emacs
      inputs.emacs-overlay.overlays.package
      inputs.nur.overlays.default
    ];

    mkDarwinConfiguration = import ./darwin {inherit inputs overlays;};
    mkNixosConfiguration = import ./modules/nixos {inherit inputs overlays;};
  in rec
  {
    devShells = forAllSystems (system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          babashka
          sops
        ];

        shellHook = ''
          export PATH="$PWD/scripts:$PATH"
        '';
      };
    });

    darwinConfigurations = {
      halo = mkDarwinConfiguration {
        hostPlatform = "aarch64-darwin";
        hostName = "halo";
        modules = [./hosts/halo];
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
        modules = [./hosts/omen];
      };
      ix = mkNixosConfiguration {
        hostPlatform = "x86_64-linux";
        hostName = "ix";
        modules = [./hosts/ix];
      };
    };
    halo = darwinConfigurations.halo.system;
    ampere = darwinConfigurations.ampere.system;
    omen = nixosConfigurations.omen.system;
    ix = nixosConfigurations.omen.system;
  };
}
