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
    ./homebrew.nix
    ./common.nix
  ];
in
  darwin.lib.darwinSystem {
    modules = defaultModules ++ modules;

    specialArgs = {inherit inputs;} // args;
  }
