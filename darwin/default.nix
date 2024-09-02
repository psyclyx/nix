{ inputs, nixpkgs, darwin, home-manager, ... }:

let 
{
  system = "aarch64-darwin";
  pkgs = nixpkgs-unstable {
    inherit system;
  };
}
in
{
  specialArgs = { inherit pkgs; };
  modules = [
    home-manager.darwinModules.home-manager
    ./halo.nix
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }
  ];
}
