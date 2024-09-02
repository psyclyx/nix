{
  inputs,
  nixpkgsFor,
}: {
  hostName,
  system,
  module,
  ...
} @ args: let
  inherit (inputs) darwin home-manager nix-homebrew;
in
  darwin.lib.darwinSystem {
    inherit system;

    modules = [
      {networking.hostName = hostName;}
      home-manager.darwinModules.home-manager
      nix-homebrew.darwinModules.nix-homebrew
      ./common.nix
      module
      ./homebrew.nix
    ];

    specialArgs =
      {
        inherit inputs;
        pkgs = nixpkgsFor.${system};
      }
      // args;
  }
