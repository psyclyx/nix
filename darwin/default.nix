{ inputs, nixpkgs, darwin, home-manager, ... }:
let
  pkgs = import nixpkgs;
in
{
  halo = darwin.lib.darwinSystem {
    hostPlatform = "aarch64-darwin";
    specialArgs = { inherit pkgs; };
    modules = [
      home-manager.darwinModules.home-manager
      ./halo.nix
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
