{
  inputs,
  nixpkgsFor,
}: {
  hostName,
  system,
  modules ? [],
  ...
} @ args: let
  inherit (inputs) darwin home-manager nix-homebrew;

  defaultModules = [
    {networking.hostName = hostName;}
    home-manager.darwinModules.home-manager
    nix-homebrew.darwinModules.nix-homebrew
    ./nix-homebrew.nix
    ./common.nix
  ];
in
  darwin.lib.darwinSystem {
    inherit system;

    modules =
      defaultModules
      ++ modules
      ++ [
        # Workaround for https://github.com/zhaofengli/nix-homebrew/issues/16
        ./homebrew-taps.nix
      ];

    specialArgs =
      {
        inherit inputs system;
        pkgs = nixpkgsFor.${system};
      }
      // args;
  }
