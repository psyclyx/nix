{ inputs, darwin, home-manager, nixpkgs, ... }:

let
  system = "aarch64-darwin";
  pkgs = import nixpkgs { inherit system; };
in
{
  halo = darwin.lib.darwinSystem rec {
    inherit system;
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
