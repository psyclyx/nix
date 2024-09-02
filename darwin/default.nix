{ inputs, nixpkgs, darwin, home-manager, ... }:

let
  hostPlatform = "aarch64-darwin";
  pkgs = import nixpkgs {
    inherit hostPlatform;
  };
in
{
  halo = darwin.lib.darwinSystem {
    inherit hostPlatform;
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
