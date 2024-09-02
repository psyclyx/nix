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
      ./nix-homebrew.nix
      ./homebrew-taps.nix
    ];

    specialArgs =
      {
        inherit inputs system;
        pkgs = nixpkgsFor.${system};
      }
      // args;
  }
