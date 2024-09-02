{
  inputs,
  overlays ? [],
}: {
  hostName,
  hostPlatform,
  modules ? [],
  ...
} @ args: let
  inherit (inputs) darwin home-manager nix-homebrew;

  defaultModules = [
    {
      networking.hostName = hostName;
      nixpkgs = {
        inherit overlays hostPlatform;
        config.allowUnfree = true;
      };
    }
    home-manager.darwinModules.home-manager
    nix-homebrew.darwinModules.nix-homebrew
    ./nix-homebrew.nix
    ./common.nix
  ];
in
  darwin.lib.darwinSystem {
    modules =
      defaultModules
      ++ modules
      ++ [
        # Workaround for https://github.com/zhaofengli/nix-homebrew/issues/16
        ./homebrew-taps.nix
      ];

    specialArgs =
      {inherit inputs;} // args;
  }
