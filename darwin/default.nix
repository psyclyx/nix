{
  inputs,
  overlays ? [],
}: {
  hostName,
  hostPlatform,
  modules ? [],
  ...
} @ args: let
  inherit (inputs) darwin home-manager;

  defaultModules = [
    {
      networking.hostName = hostName;
      nixpkgs = {
        inherit overlays hostPlatform;
        config.allowUnfree = true;
      };
    }
    home-manager.darwinModules.home-manager
  ];
in
  darwin.lib.darwinSystem {
    modules = defaultModules ++ modules;

    specialArgs = {inherit inputs;} // args;
  }
