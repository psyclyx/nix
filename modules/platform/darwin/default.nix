{
  inputs,
  overlays ? [],
}: {
  hostName,
  hostPlatform,
  modules ? [],
  ...
} @ args: let
  inherit (inputs) nix-darwin;

  defaultModules = [
    {
      system.stateVersion = 4;
      networking.hostName = hostName;
      nixpkgs = {
        inherit overlays hostPlatform;
        config.allowUnfree = true;
      };
    }
  ];
in
  nix-darwin.lib.darwinSystem {
    modules = defaultModules ++ modules;
    specialArgs = {inherit inputs;} // args;
  }
