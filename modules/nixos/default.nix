{
  inputs,
  overlays ? [],
}: {
  hostName,
  hostPlatform,
  modules ? [],
  ...
} @ args: let
  inherit (inputs) nixpkgs home-manager;
in
  nixpkgs.lib.nixosSystem {
    modules =
      [
        {
          networking.hostName = hostName;
          nixpkgs = {
            inherit overlays hostPlatform;
            config.allowUnfree = true;
          };
        }
        home-manager.nixosModules.home-manager
        ./programs
        ./services
        ./system
      ]
      ++ modules;

    specialArgs = {inherit inputs;} // args;
  }
