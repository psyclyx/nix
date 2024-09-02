{ inputs, darwin, home-manager, ... }:
{
  halo = darwin.lib.darwinSystem {
    system = "aarch64-darwin";
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
