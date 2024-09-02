{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, darwin, home-manager, nixpkgs }: rec {
    darwinConfigurations = (
      import ./darwin {
        inherit inputs nixpkgs home-manager darwin;
      }
    );
    halo = darwinConfigurations.halo.system;
  };
}
